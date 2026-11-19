<?php

namespace Webkul\Customer\Helpers;

use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;
use Intervention\Image\ImageManager;

class CreditDocumentStorage
{
    public const MAX_BYTES = 5 * 1024 * 1024;

    public function store(UploadedFile $file, int $customerId, string $type): array
    {
        $name = basename($file->getClientOriginalName());

        if ($file->getMimeType() === 'application/pdf') {
            if ($file->getSize() >= self::MAX_BYTES) {
                $this->fail($type, 'fileTooLarge');
            }

            return ['path' => $file->store('credit-applications/'.$customerId, 'private'), 'name' => $name, 'type' => $type];
        }

        $dimensions = @getimagesize($file->getRealPath());
        if (! $dimensions || $dimensions[0] * $dimensions[1] > 12000000) {
            $this->fail($type, 'imageResizeFailed');
        }

        try {
            $image = ImageManager::gd()->read($file->getRealPath())->scaleDown(width: 1600, height: 1600);
            $encoded = (string) $image->toJpeg(quality: 85);
        } catch (\Throwable $exception) {
            report($exception);
            $this->fail($type, 'imageResizeFailed');
        }

        if (strlen($encoded) >= self::MAX_BYTES) {
            $this->fail($type, 'fileTooLarge');
        }

        $path = 'credit-applications/'.$customerId.'/'.Str::uuid().'.jpg';
        if (! Storage::disk('private')->put($path, $encoded)) {
            throw new \RuntimeException('Unable to store credit document.');
        }

        return ['path' => $path, 'name' => pathinfo($name, PATHINFO_FILENAME).'.jpg', 'type' => $type];
    }

    private function fail(string $field, string $message): never
    {
        throw ValidationException::withMessages([$field => trans('customer::purchase-credit.'.$message)]);
    }
}
