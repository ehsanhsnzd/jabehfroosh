<?php

namespace App\Http\Controllers;

use Illuminate\Http\Client\ConnectionException;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class NeshanAddressController extends Controller
{
    public function reverse(Request $request): JsonResponse
    {
        $coordinates = $request->validate([
            'lat' => ['required', 'numeric', 'between:24,41'],
            'lng' => ['required', 'numeric', 'between:43,64'],
        ]);
        $key = trim((string) core()->getConfigData('customer.address.neshan.service_key'));
        abort_if($key === '', 503, trans('shop::delivery.map-unavailable'));
        try {
            $response = Http::withHeaders(['Api-Key' => $key])->acceptJson()
                ->withOptions(['allow_redirects' => false])->connectTimeout(5)->timeout(10)
                ->get('https://api.neshan.org/v5/reverse', $coordinates);
            if (! $response->successful() || $response->json('status') !== 'OK') {
                return response()->json(['message' => trans('shop::delivery.map-error')], 502);
            }

            return response()->json([
                'address' => (string) $response->json('formatted_address'),
                'city' => (string) $response->json('city'),
                'state' => preg_replace('/^استان\s+/u', '', (string) $response->json('state')),
                'latitude' => (float) $coordinates['lat'],
                'longitude' => (float) $coordinates['lng'],
            ]);
        } catch (ConnectionException $exception) {
            return response()->json(['message' => trans('shop::delivery.map-error')], 502);
        }
    }
}
