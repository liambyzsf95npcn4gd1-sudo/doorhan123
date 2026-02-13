<?php
// Единая точка входа

// Абсолютный путь к корню проекта
define('ROOT_PATH', dirname(__DIR__));

// Загрузка конфигурации.
// Прекращаем работу, если файл конфигурации отсутствует. Пользователи должны скопировать config.php.example в config.php.
if (file_exists('../config/config.php')) {
    require_once '../config/config.php';
} else {
    die('Файл конфигурации не найден. Пожалуйста, скопируйте config/config.php.example в config/config.php и настройте ваше окружение.');
}

// --- Безопасная инициализация сессии ---
session_name('SITE_SESSID');

// Устанавливаем параметры cookie сессии для повышения безопасности.
$isHttps = isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on';
session_set_cookie_params([
    'lifetime' => 0,
    'path' => '/',
    'domain' => '',
    'secure' => $isHttps,
    'httponly' => true,
    'samesite' => 'Lax'
]);

// Запускаем сессию.
session_start();

// --- Основные файлы и автозагрузка ---
spl_autoload_register(function ($class_name) {
    $paths = [
        ROOT_PATH . '/core/' . $class_name . '.php',
        ROOT_PATH . '/controllers/' . $class_name . '.php',
        ROOT_PATH . '/models/' . $class_name . '.php',
    ];

    foreach ($paths as $file) {
        if (file_exists($file)) {
            require_once $file;
            return;
        }
    }
});

// Load Language helper
require_once ROOT_PATH . '/core/Language.php';

// Initialize Language (loads from DB)
Language::init();

$router = new Router();

// Маршруты для публичной части
$router->add('/', 'PublicController', 'home');
$router->add('/about', 'PublicController', 'about');
$router->add('/products', 'PublicController', 'products');
$router->add('/products/category/{slug}', 'PublicController', 'category');
$router->add('/products/{slug}', 'PublicController', 'product');
$router->add('/factories', 'PublicController', 'factories');
$router->add('/solutions', 'PublicController', 'solutions');
$router->add('/news', 'PublicController', 'news');
$router->add('/news/{slug}', 'PublicController', 'post');
$router->add('/contact', 'PublicController', 'contact');
$router->add('/sitemap.xml', 'PublicController', 'sitemap');
$router->add('/privacy-policy', 'PublicController', 'privacyPolicy');


// Маршруты для админ-панели
$router->add('/admin', 'AdminController', 'dashboard');
$router->add('/admin/login', 'AdminController', 'login');
$router->add('/admin/logout', 'AdminController', 'logout');
$router->add('/admin/pages', 'AdminController', 'pages');
$router->add('/admin/pages/create', 'AdminController', 'create_page');
$router->add('/admin/pages/edit/{id}', 'AdminController', 'edit_page');
$router->add('/admin/pages/delete/{id}', 'AdminController', 'delete_page');
$router->add('/admin/categories', 'AdminController', 'categories');
$router->add('/admin/categories/create', 'AdminController', 'create_category');
$router->add('/admin/categories/edit/{id}', 'AdminController', 'edit_category');
$router->add('/admin/categories/delete/{id}', 'AdminController', 'delete_category');
$router->add('/admin/products', 'AdminController', 'products');
$router->add('/admin/products/create', 'AdminController', 'create_product');
$router->add('/admin/products/edit/{id}', 'AdminController', 'edit_product');
$router->add('/admin/products/delete/{id}', 'AdminController', 'delete_product');
$router->add('/admin/posts', 'AdminController', 'posts');
$router->add('/admin/posts/create', 'AdminController', 'create_post');
$router->add('/admin/posts/edit/{id}', 'AdminController', 'edit_post');
$router->add('/admin/posts/delete/{id}', 'AdminController', 'delete_post');
$router->add('/admin/messages', 'AdminController', 'messages');
$router->add('/admin/messages/view/{id}', 'AdminController', 'view_message');
$router->add('/admin/messages/delete/{id}', 'AdminController', 'delete_message');
$router->add('/admin/messages/export', 'AdminController', 'export_messages');
$router->add('/admin/settings', 'AdminController', 'settings');

// --- Корректное определение URI для поддиректорий ---
$scriptName = $_SERVER['SCRIPT_NAME'];
$basePath = dirname($scriptName);
if ($basePath === '/' || $basePath === '\\') {
    $basePath = '';
}
$requestUri = $_SERVER['REQUEST_URI'];
$requestUri = strtok($requestUri, '?');

// Check if requestUri starts with basePath
// This logic is fragile if basePath is substring of other path but assuming typical setup:
// e.g. /app/public/index.php -> basePath = /app/public
// requestUri = /app/public/en/about
if (strpos($requestUri, $basePath) === 0) {
    $uri = substr($requestUri, strlen($basePath));
} else {
    // If we can't strip base path correctly, fallback
    $uri = $requestUri;
}

if (empty($uri)) {
    $uri = '/';
} elseif ($uri[0] !== '/') {
    $uri = '/' . $uri;
}

// --- Обработка языка ---
$parts = explode('/', trim($uri, '/'));
// Ensure parts is valid array even for '/'
if (empty($parts)) $parts = [];

$lang = DEFAULT_LANGUAGE;
$supported_languages = Language::getAll(); // Fetch from DB

if (!empty($parts[0]) && in_array($parts[0], $supported_languages)) {
    $lang = array_shift($parts);
    Language::set($lang);

    // Пересобираем URI без языка
    $uri = '/' . implode('/', $parts);
} else {
    // If no language in URL, set default (or fallback)
    Language::set(DEFAULT_LANGUAGE);
}

if ($uri === '') {
    $uri = '/';
}

// --- Диспетчеризация ---
$router->dispatch($uri);
