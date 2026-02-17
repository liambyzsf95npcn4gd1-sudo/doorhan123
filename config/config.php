<?php

// Database Settings
define('DB_HOST', getenv('DB_HOST') ?: 'db');
define('DB_USER', getenv('DB_USER') ?: 'doorhan_user');
define('DB_PASS', getenv('DB_PASS') ?: 'password');
define('DB_NAME', getenv('DB_NAME') ?: 'doorhan');

// Site Settings
define('SITE_URL', getenv('SITE_URL') ?: 'http://localhost:6063');
define('ADMIN_EMAIL', getenv('ADMIN_EMAIL') ?: 'admin@doorhan.com');
define('UPLOADS_DIR', '/uploads/'); // Relative path from public root

// Debug Mode
define('DEBUG', filter_var(getenv('DEBUG'), FILTER_VALIDATE_BOOLEAN));

if (DEBUG) {
    ini_set('display_errors', 1);
    ini_set('display_startup_errors', 1);
    error_reporting(E_ALL);
} else {
    ini_set('display_errors', 0);
    ini_set('display_startup_errors', 0);
    error_reporting(0);
    ini_set('log_errors', 1);
    ini_set('error_log', ROOT_PATH . '/logs/php_errors.log');
}

// Timezone
date_default_timezone_set('UTC');

// Supported Languages - Now managed by Language class via DB
// But we keep DEFAULT_LANGUAGE as a fallback
define('DEFAULT_LANGUAGE', 'en');
