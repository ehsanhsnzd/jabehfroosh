<?php

return [
    'title' => 'SMS settings',
    'info' => 'The selected provider and test mode apply to both mobile login and credit phone verification.',
    'ghasedak' => 'Ghasedak',
    'apiKey' => 'API key',
    'template' => 'Ghasedak approved OTP template name',
    'templateHelp' => 'Enter the approved Ghasedak template name. The six-digit code is sent as %param1%.',
    'testMode' => 'Test mode (no SMS sent)',
    'testHelp' => 'When enabled, no SMS is sent and the code appears on login and credit verification pages, including on the live store. Disable for real phone verification.',
    'testCode' => 'Test mode — verification code: :code',
    'settings' => 'Provider and delivery settings',
    'provider' => 'Active SMS provider',
    'vip0098' => '0098VIP / 0098SMS',
    'vipHelp' => 'SOAP delivery through 0098VIP for login and credit verification. Activate the dedicated sender and enter the web service password generated in the provider panel.',
    'from' => 'Dedicated sender number (FROM)',
    'username' => '0098VIP username',
    'password' => '0098VIP web service password',
    'message' => 'Verification SMS text',
    'messageHelp' => 'Use {code} for the six-digit code. Text must match the approved OTP settings in your provider panel.',
];
