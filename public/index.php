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
// Используем более безопасное, пользовательское имя сессии для предотвращения фиксации сессии.
// Префикс __Secure- требует, чтобы для cookie был установлен флаг 'secure'.
session_name('SITE_SESSID');

// Устанавливаем параметры cookie сессии для повышения безопасности.
$isHttps = isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on';
session_set_cookie_params([
    'lifetime' => 0, // Сессионный cookie, истекает при закрытии браузера.
    'path' => '/doorhan/public/',
    'domain' => '', // Укажите ваш домен для production. Например, '.yourdomain.com'
    'secure' => $isHttps, // Отправлять cookie только по HTTPS.
    'httponly' => true, // Запретить доступ к cookie сессии через JavaScript.
    'samesite' => 'Lax' // Снижает риск CSRF-атак. 'Strict' более безопасен, но может повлиять на удобство использования.
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

// ... другие маршруты админ-панели ...
// --- Корректное определение URI для поддиректорий ---

// 1. Получаем путь к скрипту (e.g., /doorhan/public/index.php)
$scriptName = $_SERVER['SCRIPT_NAME'];

// 2. Получаем директорию, в которой он находится (e.g., /doorhan/public)
$basePath = dirname($scriptName);

// 3. Если мы в корне, basePath будет '\' или '/', нормализуем
if ($basePath === '/' || $basePath === '\\') {
    $basePath = '';
}

// 4. Получаем полный запрошенный URI (e.g., /doorhan/public/about?query=1)
$requestUri = $_SERVER['REQUEST_URI'];

// 5. Отсекаем query string
$requestUri = strtok($requestUri, '?');

// 6. Получаем URI относительно приложения, удаляя basePath
// (e.g., /doorhan/public/about -> /about)
$uri = substr($requestUri, strlen($basePath));

// 7. Убедимся, что URI начинается со / (если он не пустой)
if (empty($uri)) {
    $uri = '/';
} elseif ($uri[0] !== '/') {
    $uri = '/' . $uri;
}

// --- Диспетчеризация ---
// Маршруты УЖЕ БЫЛИ добавлены выше, дублировать их не нужно.
$router->dispatch($uri);