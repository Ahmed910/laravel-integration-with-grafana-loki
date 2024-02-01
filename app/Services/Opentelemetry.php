<?php

namespace App\Services;

use OpenTelemetry\API\Logs\EventLogger;
use OpenTelemetry\API\Logs\LogRecord;
use OpenTelemetry\Contrib\Otlp\LogsExporter;
use OpenTelemetry\SDK\Common\Export\Stream\StreamTransportFactory;
use OpenTelemetry\SDK\Logs\LoggerProvider;
use OpenTelemetry\SDK\Logs\Processor\SimpleLogRecordProcessor;
use OpenTelemetry\SDK\Resource\ResourceInfoFactory;

class Opentelemetry
{
    public static function log()
    {
        $exporter = new LogsExporter(
            (new StreamTransportFactory())->create('php://stdout', 'application/json')
        );
        
        $loggerProvider = LoggerProvider::builder()
            ->addLogRecordProcessor(new SimpleLogRecordProcessor($exporter))
            ->setResource(ResourceInfoFactory::emptyResource())
            ->build();

        $logger = $loggerProvider->getLogger('demo', '1.0', 'http://schema.url', [/*attributes*/]);
        $eventLogger = new EventLogger($logger, 'my-domain');
        $record = (new LogRecord('hello world'))
            ->setSeverityText('INFO')
            ->setAttributes([/*attributes*/]);
        
        $eventLogger->logEvent('foo', $record);
    
        $handler = new \OpenTelemetry\Contrib\Logs\Monolog\Handler(
            $loggerProvider,
            \Psr\Log\LogLevel::ERROR,
        );
        return new \Monolog\Logger('example', [$handler]);
    }
}