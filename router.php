<?php
// router.php
$publicDir = __DIR__ . '/public';
$uri = urldecode(parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH));

// Serve the requested resource as-is if it's a file or directory.
if ($uri !== '/' && file_exists($publicDir . $uri)) {
    return false;
}

// For any other request, load the main index.php file.
require_once $publicDir . '/index.php';
