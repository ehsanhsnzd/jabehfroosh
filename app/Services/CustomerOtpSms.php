<?php

namespace App\Services;

use DOMDocument;
use DOMXPath;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;
use RuntimeException;

class CustomerOtpSms
{
    public function isTesting(): bool
    {
        return filter_var(core()->getConfigData('customer.sms.ghasedak.test_mode'), FILTER_VALIDATE_BOOLEAN);
    }

    public function send(string $phone, string $code): bool
    {
        $testing = $this->isTesting();

        if ($testing) {
            return true;
        }

        $provider = core()->getConfigData('customer.sms.ghasedak.provider');

        if ($provider === 'vip0098') {
            $this->sendViaVip0098($phone, $code);

            return false;
        }

        if ($provider !== 'ghasedak') {
            throw new RuntimeException('Unsupported SMS provider.');
        }

        $this->sendViaGhasedak($phone, $code);

        return false;
    }

    private function sendViaGhasedak(string $phone, string $code): void
    {
        $apiKey = trim((string) (core()->getConfigData('customer.sms.ghasedak.api_key') ?: config('services.ghasedak.api_key')));
        $template = trim((string) (core()->getConfigData('customer.sms.ghasedak.template') ?: config('services.ghasedak.template')));

        if ($apiKey === '' || $template === '') {
            throw new RuntimeException('SMS credentials are not configured.');
        }

        // https://ghasedak.me/docs — SendOtpWithParams; the OTP occupies %param1%.
        $response = Http::acceptJson()->withHeaders(['ApiKey' => $apiKey])
            ->connectTimeout(5)->timeout(15)
            ->post('https://gateway.ghasedak.me/rest/api/v1/WebService/SendOtpWithParams', [
                'receptors' => [['mobile' => $phone, 'clientReferenceId' => (string) Str::uuid()]],
                'templateName' => $template,
                'param1' => $code,
                'isVoice' => false,
                'udh' => false,
            ]);

        if ($response->failed() || $response->json('IsSuccess') !== true) {
            Log::warning('Ghasedak OTP delivery failed', ['http_status' => $response->status(), 'status_code' => $response->json('StatusCode')]);

            throw new RuntimeException('SMS delivery failed.');
        }

    }

    private function sendViaVip0098(string $phone, string $code): void
    {
        $settings = [];

        foreach (['from', 'username', 'password', 'message'] as $field) {
            $value = (string) core()->getConfigData('customer.sms.vip0098.'.$field);
            $settings[$field] = $field === 'password' ? $value : trim($value);

            if ($settings[$field] === '') {
                throw new RuntimeException('0098VIP SMS settings are not configured.');
            }
        }

        if (! str_contains($settings['message'], '{code}')) {
            throw new RuntimeException('Invalid 0098VIP SMS settings.');
        }

        // Match SendSMS in https://webservice.0098vip.com/service.asmx?WSDL.
        $soapNamespace = 'http://schemas.xmlsoap.org/soap/envelope/';
        $serviceNamespace = 'http://tempuri.org/';
        $document = new DOMDocument('1.0', 'UTF-8');
        $envelope = $document->appendChild($document->createElementNS($soapNamespace, 'soap:Envelope'));
        $body = $envelope->appendChild($document->createElementNS($soapNamespace, 'soap:Body'));
        $operation = $body->appendChild($document->createElementNS($serviceNamespace, 'SendSMS'));

        foreach ([
            'username' => $settings['username'],
            'password' => $settings['password'],
            'text' => str_replace('{code}', $code, $settings['message']),
            'mobileno' => $phone,
            'pnlno' => $settings['from'],
        ] as $name => $value) {
            $element = $operation->appendChild($document->createElementNS($serviceNamespace, $name));
            $element->appendChild($document->createTextNode($value));
        }

        $response = Http::withOptions(['allow_redirects' => false])
            ->withHeaders(['SOAPAction' => '"http://tempuri.org/SendSMS"', 'Accept' => 'text/xml'])
            ->withBody($document->saveXML(), 'text/xml; charset=utf-8')
            ->connectTimeout(5)->timeout(15)
            ->post('https://webservice.0098vip.com/service.asmx');

        // SOAP SendSMS reports success as 2; the old link API used a different code.
        if (! $response->successful() || ! $this->vipSoapSucceeded($response->body())) {
            Log::warning('0098VIP OTP delivery failed', ['http_status' => $response->status()]);

            throw new RuntimeException('SMS delivery failed.');
        }
    }

    private function vipSoapSucceeded(string $xml): bool
    {
        if ($xml === '' || stripos($xml, '<!DOCTYPE') !== false) {
            return false;
        }

        $previous = libxml_use_internal_errors(true);

        try {
            $document = new DOMDocument;

            if (! $document->loadXML($xml, LIBXML_NONET)) {
                return false;
            }

            $xpath = new DOMXPath($document);
            $xpath->registerNamespace('soap', 'http://schemas.xmlsoap.org/soap/envelope/');
            $xpath->registerNamespace('sms', 'http://tempuri.org/');
            $results = $xpath->query('/soap:Envelope/soap:Body/sms:SendSMSResponse/sms:SendSMSResult');

            return $xpath->query('/soap:Envelope/soap:Body/soap:Fault')->length === 0
                && $results->length === 1
                && trim($results->item(0)->textContent) === '2';
        } finally {
            libxml_clear_errors();
            libxml_use_internal_errors($previous);
        }
    }
}
