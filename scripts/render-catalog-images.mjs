#!/usr/bin/env node

import { execFileSync } from 'node:child_process';
import { existsSync, mkdirSync, rmSync, writeFileSync } from 'node:fs';
import { dirname, join, resolve } from 'node:path';
import { pathToFileURL } from 'node:url';

const root = resolve(import.meta.dirname, '..');
const catalogDir = join(root, 'database/seeders/data/shamim-catalog');
const baseDir = join(catalogDir, 'generated-base');
const outputDir = join(catalogDir, 'measured');
const tempDir = join(root, 'storage/framework/cache/catalog-image-render');
const chrome = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome';
const force = process.argv.includes('--force');
const only = process.argv.find((argument) => argument.startsWith('--only='))?.split('=')[1];

if (! existsSync(chrome)) {
    throw new Error(`Google Chrome was not found at ${chrome}`);
}

mkdirSync(outputDir, { recursive: true });
mkdirSync(tempDir, { recursive: true });

const products = [
    ['SP-FC-002-W', 'fried-01.png', [['طول', '۱۸٫۵'], ['عرض', '۱۰'], ['ارتفاع', '۷٫۵']]],
    ['SP-FC-003-W', 'fried-02.png', [['طول', '۲۲'], ['عرض', '۱۲'], ['ارتفاع', '۸']]],
    ['SP-FC-005-W', 'fried-03.png', [['طول', '۲۲'], ['عرض', '۱۲'], ['ارتفاع', '۱۰٫۵']]],
    ['SP-FC-002-B', 'fried-04.png', [['طول', '۱۸٫۵'], ['عرض', '۱۰'], ['ارتفاع', '۷٫۵']]],
    ['SP-FC-003-B', 'fried-05.png', [['طول', '۲۲'], ['عرض', '۱۲'], ['ارتفاع', '۸']]],
    ['SP-FC-005-B', 'fried-06.png', [['طول', '۲۲'], ['عرض', '۱۲'], ['ارتفاع', '۱۰٫۵']]],
    ['SP-FC-HANDLE-W', 'fried-07.png', [['طول', '۲۲'], ['عرض', '۱۲'], ['ارتفاع', '۱۱']]],
    ['SP-FC-HANDLE-B', 'fried-08.png', [['طول', '۲۲'], ['عرض', '۱۲'], ['ارتفاع', '۱۱']]],
    ['SP-FC-TABLE-S', 'fried-09.png', [['طول', '۱۹٫۵'], ['عرض', '۱۵'], ['ارتفاع', '۷']]],
    ['SP-FC-TABLE-L', 'fried-09.png', [['طول', '۲۴٫۵'], ['عرض', '۱۹٫۵'], ['ارتفاع', '۷٫۵']]],
    ['SP-FC-PLATE', 'fried-10.png', [['طول', '۲۵'], ['عرض', '۱۵'], ['ارتفاع', '۵']]],
    ['SP-FF-BOX', 'fries-11.png', [['طول', '۱۲'], ['عرض', '۸'], ['ارتفاع', '۷']]],
    ['SP-FF-BOAT-S', 'fries-12.png', [['طول', '۱۵'], ['عرض', '۱۱٫۵'], ['ارتفاع', '۴']]],
    ['SP-FF-BOAT-L', 'fries-12.png', [['طول', '۲۱٫۵'], ['عرض', '۱۰'], ['ارتفاع', '۶']]],
    ['SP-FF-CONE', 'fries-13.png', [['عرض', '۱۸٫۵'], ['ارتفاع', '۳۱']]],
    ['SP-FF-NEO', 'fries-14.png', [['طول', '۱۴'], ['عرض', '۱۱'], ['ارتفاع', '۷']]],
    ['SP-FF-PYRAMID-S', 'fries-15.png', [['ضلع بزرگ', '۷٫۵'], ['ضلع کوچک', '۶'], ['ارتفاع', '۱۱']]],
    ['SP-FF-PYRAMID-L', 'fries-15.png', [['ضلع بزرگ', '۱۰٫۵'], ['ضلع کوچک', '۶٫۵'], ['ارتفاع', '۱۱٫۵']]],
    ['SP-PAPER-2535', 'paper-16.png', [['طول', '۳۵'], ['عرض', '۲۵']]],
    ['SP-PAPER-3550', 'paper-16.png', [['طول', '۵۰'], ['عرض', '۳۵']]],
    ['SP-PIZZA-50-PARS', 'pizza-50-pars.png', [['طول', '۵۰'], ['عرض', '۵۰']]],
    ['SP-PIZZA-50-TAGHDIS', 'pizza-50-taghdis.png', [['طول', '۵۰'], ['عرض', '۵۰']]],
    ['SP-PIZZA-32-TAGHDIS', 'pizza-32.png', [['طول', '۳۲'], ['عرض', '۳۲']]],
    ['SP-PIZZA-30-TAGHDIS', 'pizza-30.png', [['طول', '۳۰'], ['عرض', '۳۰']]],
    ['SP-PIZZA-28-TAGHDIS', 'pizza-28.png', [['طول', '۲۸'], ['عرض', '۲۸']]],
    ['SP-PIZZA-24-TAGHDIS', 'pizza-24.png', [['طول', '۲۴'], ['عرض', '۲۴']]],
];

// Each profile follows the real visible edges of that product photograph.
// Coordinates are [x1, y1, x2, y2, labelOffset] in the 1200px master image.
const profiles = {
    'fried-01.png': [[245, 895, 950, 985, 55], [165, 260, 565, 135, -52], [190, 570, 215, 815, 55]],
    'fried-02.png': [[250, 875, 930, 860, 58], [175, 330, 455, 215, -52], [980, 500, 980, 815, -65]],
    'fried-03.png': [[245, 875, 980, 920, 58], [195, 275, 730, 165, -52], [1035, 440, 1035, 825, -65]],
    'fried-04.png': [[310, 875, 855, 875, 58], [250, 290, 730, 290, -52], [905, 410, 905, 820, -65]],
    'fried-05.png': [[300, 895, 900, 895, 58], [250, 295, 730, 295, -52], [950, 420, 950, 835, -65]],
    'fried-06.png': [[270, 875, 930, 875, 58], [195, 310, 700, 220, -52], [980, 455, 980, 825, -65]],
    'fried-07.png': [[300, 940, 900, 940, 55], [245, 210, 690, 150, -50], [960, 260, 960, 885, -65]],
    'fried-08.png': [[285, 940, 915, 940, 55], [240, 220, 715, 155, -50], [970, 260, 970, 890, -65]],
    'fried-09.png': [[290, 880, 885, 880, 58], [235, 325, 655, 230, -52], [930, 470, 930, 830, -65]],
    'fried-10.png': [[235, 800, 970, 800, 58], [185, 445, 420, 345, -52], [1015, 535, 1015, 720, -65]],
    'fries-11.png': [[285, 890, 900, 890, 58], [235, 295, 690, 200, -52], [945, 430, 945, 835, -65]],
    'fries-12.png': [[255, 825, 965, 825, 58], [205, 430, 445, 330, -52], [1010, 500, 1010, 750, -65]],
    'fries-13.png': [[285, 155, 755, 155, -52], [910, 170, 910, 1040, -65]],
    'fries-14.png': [[350, 940, 850, 940, 55], [275, 310, 545, 190, -52], [905, 330, 905, 880, -65]],
    'fries-15.png': [[370, 940, 835, 940, 55], [280, 305, 540, 190, -52], [885, 320, 885, 885, -65]],
    'paper-16.png': [[405, 125, 135, 820, -62], [220, 925, 690, 1155, 55]],
    'pizza-24.png': [[180, 925, 930, 925, 58], [85, 790, 375, 555, -58]],
    'pizza-28.png': [[180, 925, 930, 925, 58], [85, 790, 375, 555, -58]],
    'pizza-30.png': [[180, 925, 930, 925, 58], [85, 790, 375, 555, -58]],
    'pizza-32.png': [[180, 925, 930, 925, 58], [85, 790, 375, 555, -58]],
    'pizza-50-pars.png': [[160, 955, 960, 955, 58], [70, 820, 390, 555, -58]],
    'pizza-50-taghdis.png': [[160, 955, 960, 955, 58], [70, 820, 390, 555, -58]],
};

function measurement(value, [x1, y1, x2, y2, offset]) {
    const angle = Math.atan2(y2 - y1, x2 - x1) * 180 / Math.PI;
    const length = Math.hypot(x2 - x1, y2 - y1);
    const nx = -(y2 - y1) / length;
    const ny = (x2 - x1) / length;
    const tx = (x1 + x2) / 2 + nx * offset;
    const ty = (y1 + y2) / 2 + ny * offset;

    return `
        <line x1="${x1}" y1="${y1}" x2="${x2}" y2="${y2}" class="arrow"/>
        <text x="${tx}" y="${ty}" transform="rotate(${angle} ${tx} ${ty})" text-anchor="middle">${value} CM</text>`;
}

function overlay(baseImage, dimensions) {
    const profile = profiles[baseImage];

    if (! profile || profile.length !== dimensions.length) {
        throw new Error(`Measurement profile mismatch: ${baseImage}`);
    }

    return dimensions.map(([, value], index) => measurement(value, profile[index])).join('\n');
}

for (const [sku, baseImage, dimensions] of products) {
    if (only && sku !== only) continue;

    const input = join(baseDir, baseImage);
    const output = join(outputDir, `${sku}.png`);
    const html = join(tempDir, `${sku}.html`);

    if (! force && existsSync(output)) {
        process.stdout.write(`Skipped ${sku} (already rendered)\n`);
        continue;
    }

    if (! existsSync(input)) {
        throw new Error(`Base image is missing: ${input}`);
    }

    writeFileSync(html, `<!doctype html>
<html lang="fa" dir="rtl">
<head>
    <meta charset="utf-8">
    <style>
        * { box-sizing: border-box; }
        html, body { width: 1200px; height: 1200px; margin: 0; overflow: hidden; background: #fff; }
        .canvas { position: relative; width: 1200px; height: 1200px; background: #fff; }
        .product { position: absolute; inset: 0; width: 1200px; height: 1200px; object-fit: cover; }
        svg { position: absolute; inset: 0; width: 1200px; height: 1200px; }
        text {
            font: 400 40px "Marker Felt", "Chalkboard SE", "Comic Sans MS", sans-serif;
            fill: #111;
            paint-order: stroke;
            stroke: #fff;
            stroke-width: 10px;
            stroke-linejoin: round;
            direction: ltr;
            unicode-bidi: bidi-override;
        }
        .arrow { stroke: #111; stroke-width: 5; marker-start: url(#arrow); marker-end: url(#arrow); }
    </style>
</head>
<body>
    <div class="canvas">
        <img class="product" src="${pathToFileURL(input).href}" alt="">
        <svg viewBox="0 0 1200 1200" aria-hidden="true">
            <defs>
                <marker id="arrow" markerWidth="10" markerHeight="10" refX="5" refY="3" orient="auto-start-reverse" markerUnits="strokeWidth">
                    <path d="M0,0 L0,6 L6,3 z" fill="#111"/>
                </marker>
            </defs>
            ${overlay(baseImage, dimensions)}
        </svg>
    </div>
</body>
</html>`);

    const chromeArgs = [
        '--headless=new',
        '--hide-scrollbars',
        '--disable-gpu',
        '--disable-background-networking',
        '--disable-extensions',
        '--disable-sync',
        '--no-first-run',
        '--allow-file-access-from-files',
        '--force-device-scale-factor=1',
        '--window-size=1200,1200',
        '--virtual-time-budget=1500',
        `--screenshot=${output}`,
        pathToFileURL(html).href,
    ];

    for (let attempt = 1; attempt <= 3; attempt++) {
        try {
            execFileSync(chrome, chromeArgs, { stdio: 'ignore' });
            break;
        } catch (error) {
            if (attempt === 3) throw error;
            process.stderr.write(`Retrying ${sku} after Chrome exited early (${attempt}/3)\n`);
            Atomics.wait(new Int32Array(new SharedArrayBuffer(4)), 0, 0, 1000);
        }
    }

    process.stdout.write(`Rendered ${sku}\n`);
}

rmSync(tempDir, { recursive: true, force: true });
console.log(`Created ${products.length} catalog images in ${outputDir}`);
