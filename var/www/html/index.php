<?php

$method = strtoupper($_SERVER['REQUEST_METHOD']);
$headers = getallheaders();
$doc = [
    'headers' => $headers,
    'content' => $_REQUEST,
    'server'  => $_SERVER,
    'method'  => $method,
    'uri'     => $_SERVER['REQUEST_URI'],
    'host'    => empty($headers['host']) ? '' : $headers['host']
];

$mongoHost = getenv('MONGODBHOST');
$m = new MongoDB\Driver\Manager("mongodb://$mongoHost");
$bulk = new MongoDB\Driver\BulkWrite;
$bulk->insert($doc);
$m->executeBulkWrite("elb.requests", $bulk);

echo " ";

