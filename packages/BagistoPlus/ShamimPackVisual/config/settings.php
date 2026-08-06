<?php

use BagistoPlus\Visual\Settings;

return [
    [
        'name' => 'shamim-pack::theme.settings.colors',
        'settings' => [
            Settings\ColorScheme::make('default_scheme', 'shamim-pack::theme.settings.default_scheme_label')
                ->default('default'),

            Settings\ColorSchemeGroup::make('color_schemes', 'shamim-pack::theme.settings.color_schemes')
                ->schemes([
                    'default' => [
                        'background' => '#fffaf3',
                        'on-background' => '#18251d',

                        'surface' => '#f4eadb',
                        'on-surface' => '#18251d',

                        'surface-alt' => '#ead8bd',
                        'on-surface-alt' => '#18251d',

                        'primary' => '#2f4a38',
                        'on-primary' => '#fffaf3',

                        'secondary' => '#efe4d3',
                        'on-secondary' => '#18181b',

                        'accent' => '#c56f3d',
                        'on-accent' => '#fffbeb',

                        'neutral' => '#383D41',
                        'on-neutral' => '#E2E3E5',

                        'info' => '#0090b5',
                        'on-info' => '#fffaf3',

                        'success' => '#155721',
                        'on-success' => '#D4EDDA',

                        'warning' => '#856404',
                        'on-warning' => '#FFF3CD',

                        'danger' => '#721C24',
                        'on-danger' => '#F8D7DA',
                    ],
                    'mocha' => [
                        'background' => '#f8f8f8',
                        'on-background' => '#272322',

                        'surface' => '#f5f5f4',
                        'on-surface' => '#272322',

                        'surface-alt' => '#e6e4e3',
                        'on-surface-alt' => '#272322',

                        'primary' => '#92400e',
                        'on-primary' => '#fffaf3',

                        'secondary' => '#44403c',
                        'on-secondary' => '#fffaf3',

                        'accent' => '#4ade80',
                        'on-accent' => '#000000',

                        'neutral' => '#6b7280',
                        'on-neutral' => '#fffaf3',

                        'info' => '#2563eb',
                        'on-info' => '#fffaf3',

                        'success' => '#059669',
                        'on-success' => '#fffaf3',

                        'warning' => '#d97706',
                        'on-warning' => '#fffaf3',

                        'danger' => '#dc2626',
                        'on-danger' => '#fffaf3',
                    ],
                    'dark' => [
                        'background' => '#1d232a',
                        'on-background' => '#ecf9ff',

                        'surface' => '#191e24',
                        'on-surface' => '#ecf9ff',

                        'surface-alt' => '#15191e',
                        'on-surface-alt' => '#ecf9ff',

                        'primary' => '#605dff',
                        'on-primary' => '#edf1fe',

                        'secondary' => '#f43098',
                        'on-secondary' => '#f9e4f0',

                        'accent' => '#00d3bb',
                        'on-accent' => '#084d49',

                        'neutral' => '#18251d',
                        'on-neutral' => '#ead8bd',

                        'info' => '#00bafe',
                        'on-info' => '#042e49',

                        'success' => '#00d390',
                        'on-success' => '#004c39',

                        'warning' => '#fcb700',
                        'on-warning' => '#793205',

                        'danger' => '#ff637d',
                        'on-danger' => '#4d0218',

                    ]
                ])
        ]
    ],
    [
        'name' => 'shamim-pack::theme.settings.typography',
        'settings' => [
            Settings\Font::make('default_font', 'shamim-pack::theme.settings.default_font_label')->default('vazirmatn')
                ->info('shamim-pack::theme.settings.default_font_info'),

            Settings\Font::make('heading_font', 'shamim-pack::theme.settings.heading_font_label')->default('dm-serif-display')
                ->info('shamim-pack::theme.settings.heading_font_info'),
        ],
    ],
];
