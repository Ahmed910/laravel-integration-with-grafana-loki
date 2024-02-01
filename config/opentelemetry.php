<?php

use OpenTelemetry\Contrib\Otlp\OtlpUtil;

return [
    'sdk' => [
        'trace' => [
            'exporter' => [
                'class' => OtlpUtil::class,
                'options' => [
                    'endpoint' => 'http://otel-collector:4317/v1/trace'
                ]
            ]
        ],
        'instrumentation' => [
            // Add any desired instrumentation modules here
        ]
    ]
];