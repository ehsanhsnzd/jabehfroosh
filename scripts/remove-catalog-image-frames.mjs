#!/usr/bin/env node

import { spawnSync } from 'node:child_process';
import {
    copyFileSync,
    existsSync,
    mkdirSync,
    readdirSync,
    renameSync,
    statSync,
} from 'node:fs';
import { dirname, extname, join, relative, resolve } from 'node:path';

const root = resolve(import.meta.dirname, '..');
const apply = process.argv.includes('--apply');
const ffmpeg = '/opt/homebrew/bin/ffmpeg';
const ffprobe = '/opt/homebrew/bin/ffprobe';
const backupRoot = join(root, 'tmp/catalog-frame-backup-20260829');

const roots = [
    join(root, 'database/seeders/data/shamim-catalog/generated-base'),
    join(root, 'database/seeders/data/shamim-catalog/measured'),
    join(root, 'storage/app/public/product'),
    join(root, 'storage/app/public/products'),
];

const supportedExtensions = new Set(['.jpg', '.jpeg', '.png', '.webp']);

function filesIn(directory) {
    if (! existsSync(directory)) return [];

    return readdirSync(directory, { withFileTypes: true }).flatMap((entry) => {
        const path = join(directory, entry.name);

        if (entry.isDirectory()) return filesIn(path);

        return supportedExtensions.has(extname(entry.name).toLowerCase()) ? [path] : [];
    });
}

function run(command, args, options = {}) {
    const result = spawnSync(command, args, {
        encoding: options.encoding ?? null,
        maxBuffer: 64 * 1024 * 1024,
    });

    if (result.status !== 0) {
        throw new Error(result.stderr?.toString().trim() || `${command} failed`);
    }

    return result.stdout;
}

function dimensions(path) {
    const output = run(ffprobe, [
        '-v', 'error',
        '-select_streams', 'v:0',
        '-show_entries', 'stream=width,height',
        '-of', 'json',
        path,
    ], { encoding: 'utf8' });

    const stream = JSON.parse(output).streams?.[0];

    return stream ? { width: stream.width, height: stream.height } : null;
}

function greenBorderPixelCount(path, width, height) {
    const stripHeight = Math.max(32, Math.round(height * 0.04));
    const pixels = run(ffmpeg, [
        '-hide_banner',
        '-loglevel', 'error',
        '-i', path,
        '-vf', `crop=${width}:${stripHeight}:0:0`,
        '-f', 'rawvideo',
        '-pix_fmt', 'rgb24',
        'pipe:1',
    ]);

    let count = 0;

    for (let index = 0; index < pixels.length; index += 3) {
        const red = pixels[index];
        const green = pixels[index + 1];
        const blue = pixels[index + 2];

        if (
            green >= 35
            && green <= 145
            && red <= 100
            && blue <= 115
            && green >= red * 1.25
            && green >= blue * 1.15
        ) {
            count++;
        }
    }

    return count;
}

function removeFrame(path, width, height) {
    const margin = Math.max(12, Math.round(Math.min(width, height) * 0.02));
    const croppedWidth = width - margin * 2;
    const croppedHeight = height - margin * 2;
    const extension = extname(path).toLowerCase();
    const temporary = `${path}.frame-removal${extension}`;
    const codec = extension === '.webp'
        ? ['-c:v', 'libwebp', '-lossless', '1']
        : extension === '.png'
            ? ['-c:v', 'png']
            : ['-q:v', '2'];

    run(ffmpeg, [
        '-hide_banner',
        '-loglevel', 'error',
        '-y',
        '-i', path,
        '-vf', `crop=${croppedWidth}:${croppedHeight}:${margin}:${margin},scale=${width}:${height}:flags=lanczos`,
        ...codec,
        temporary,
    ]);

    renameSync(temporary, path);
}

if (! existsSync(ffmpeg) || ! existsSync(ffprobe)) {
    throw new Error('ffmpeg and ffprobe are required.');
}

const candidates = roots.flatMap(filesIn);
const framed = [];

for (const path of candidates) {
    if (! statSync(path).isFile()) continue;

    const size = dimensions(path);

    if (! size || size.width < 200 || size.height < 200) continue;

    const greenPixels = greenBorderPixelCount(path, size.width, size.height);

    if (greenPixels < size.width) continue;

    framed.push({ path, ...size, greenPixels });
}

for (const image of framed) {
    const relativePath = relative(root, image.path);
    process.stdout.write(`${apply ? 'Removing' : 'Detected'} frame: ${relativePath} (${image.greenPixels} green edge pixels)\n`);

    if (! apply) continue;

    const backup = join(backupRoot, relativePath);
    mkdirSync(dirname(backup), { recursive: true });

    if (! existsSync(backup)) {
        copyFileSync(image.path, backup);
    }

    removeFrame(image.path, image.width, image.height);
}

if (apply) {
    for (const image of framed) {
        const size = dimensions(image.path);
        const remainingGreenPixels = greenBorderPixelCount(image.path, size.width, size.height);

        if (remainingGreenPixels >= size.width) {
            throw new Error(`Green frame is still present: ${relative(root, image.path)}`);
        }
    }
}

process.stdout.write(`${apply ? 'Updated' : 'Found'} ${framed.length} framed image(s).\n`);
