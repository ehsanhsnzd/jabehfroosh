<?php

return [
    'code' => 'shamim-digi-mobile',
    'name' => 'Shamim Digi Mobile',
    'version' => '1.0.0',
    'author' => 'Shamim Digi Mobile',
    // This layout is an extension of the existing Shamim Pack storefront, so
    // both themes intentionally share its compiled storefront assets.
    'assets_path' => 'public/themes/shop/shamim-pack',
    'views_path' => 'resources/themes/shamim-digi-mobile/views',
    'preview_image' => 'themes/shop/shamim-pack/images/theme-preview.png',
    'documentation_url' => '',
    'vite' => [
        'hot_file' => 'themes/shop/shamim-pack/shamim-pack-vite.hot',
        'build_directory' => 'themes/shop/shamim-pack',
        'package_assets_directory' => 'resources/assets',
    ],
];
