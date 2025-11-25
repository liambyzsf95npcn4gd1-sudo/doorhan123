<?php
// Контроллер для админ-панели (Updated for Multi-language)

class AdminController {

    const MAX_LOGIN_ATTEMPTS = 5;
    const LOCKOUT_TIME = 900;

    public function __construct() {
        if (empty($_SESSION['csrf_token'])) {
            $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
        }
    }

    private function checkAuth() {
        if (!isset($_SESSION['user_id'])) {
            header('Location: ' . SITE_URL . '/admin/login');
            exit;
        }
    }

    public function dashboard() {
        $this->checkAuth();
        $this->view('admin/dashboard');
    }

    public function login() {
        if (isset($_SESSION['user_id'])) {
            header('Location: ' . SITE_URL . '/admin');
            exit;
        }

        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            if (!isset($_POST['csrf_token']) || !hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'])) {
                die('Ошибка валидации CSRF-токена');
            }

            if (isset($_SESSION['lockout_time']) && time() < $_SESSION['lockout_time']) {
                $error = 'Слишком много неудачных попыток входа. Пожалуйста, попробуйте позже.';
            } else {
                $_SESSION['login_attempts'] = ($_SESSION['login_attempts'] ?? 0) + 1;

                if ($_SESSION['login_attempts'] > self::MAX_LOGIN_ATTEMPTS) {
                    $_SESSION['lockout_time'] = time() + self::LOCKOUT_TIME;
                    $error = 'Слишком много неудачных попыток входа. Пожалуйста, попробуйте позже.';
                } else {
                    $username = trim($_POST['username']);
                    $password = $_POST['password'];

                    $db = Database::getInstance()->getConnection();
                    $stmt = $db->prepare("SELECT * FROM users WHERE username = ?");
                    $stmt->execute([$username]);
                    $user = $stmt->fetch();

                    if ($user && password_verify($password, $user['password'])) {
                        session_regenerate_id(true);
                        unset($_SESSION['login_attempts']);
                        unset($_SESSION['lockout_time']);
                        $_SESSION['user_id'] = $user['id'];
                        $_SESSION['user_role'] = $user['role'];
                        header('Location: ' . SITE_URL . '/admin');
                        exit;
                    } else {
                        $error = 'Неверное имя пользователя или пароль';
                    }
                }
            }
        }

        $this->view('admin/login', ['error' => $error ?? null, 'csrf_token' => $_SESSION['csrf_token']], false);
    }

    public function logout() {
        $_SESSION = [];
        $params = session_get_cookie_params();
        setcookie(session_name(), '', time() - 42000,
            $params["path"], $params["domain"],
            $params["secure"], $params["httponly"]
        );
        session_destroy();
        header('Location: ' . SITE_URL . '/admin/login');
        exit;
    }

    // --- PRODUCTS ---
    public function products() {
        $this->checkAuth();
        $productModel = new Product();
        $products = $productModel->getAll();
        $this->view('admin/products/index', ['products' => $products]);
    }

    public function create_product() {
        $this->checkAuth();
        $categoryModel = new Category();
        $categories = $categoryModel->getAll();

        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            if (!hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'])) {
                die('Ошибка валидации CSRF-токена');
            }

            $productModel = new Product();
            $status = $_POST['status'];

            // Collect multi-language data
            $langData = [];
            foreach (SUPPORTED_LANGUAGES as $lang) {
                $langData[$lang] = [
                    'name' => $_POST['name'][$lang] ?? '',
                    'slug' => $_POST['slug'][$lang] ?? '',
                    'content' => $_POST['content'][$lang] ?? '',
                    'seo_title' => $_POST['seo_title'][$lang] ?? '',
                    'meta_description' => $_POST['meta_description'][$lang] ?? '',
                    'max_width' => $_POST['max_width'][$lang] ?? '',
                    'max_height' => $_POST['max_height'][$lang] ?? '',
                    'panel_thickness' => $_POST['panel_thickness'][$lang] ?? '',
                    'insulation' => $_POST['insulation'][$lang] ?? ''
                ];
            }

            $productId = $productModel->create($status, $langData);

            if ($productId) {
                if (isset($_POST['categories']) && is_array($_POST['categories'])) {
                    $productModel->setCategories($productId, $_POST['categories']);
                }
                Flash::set('Товар успешно создан');
            } else {
                Flash::set('Ошибка при создании товара', 'error');
            }
            header('Location: ' . SITE_URL . '/admin/products');
            exit;
        }
        $this->view('admin/products/form', ['categories' => $categories, 'csrf_token' => $_SESSION['csrf_token']]);
    }

    public function edit_product($params) {
        $this->checkAuth();
        $productModel = new Product();
        $product = $productModel->getById($params['id']); // Gets basic data (status, etc)
        $translations = $productModel->getTranslations($params['id']); // Gets translations

        $categoryModel = new Category();
        $categories = $categoryModel->getAll();
        $product_categories = $productModel->getCategoryIds($params['id']);

        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            if (!hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'])) {
                die('Ошибка валидации CSRF-токена');
            }

            $status = $_POST['status'];
            // Collect multi-language data
            $langData = [];
            foreach (SUPPORTED_LANGUAGES as $lang) {
                $langData[$lang] = [
                    'name' => $_POST['name'][$lang] ?? '',
                    'slug' => $_POST['slug'][$lang] ?? '',
                    'content' => $_POST['content'][$lang] ?? '',
                    'seo_title' => $_POST['seo_title'][$lang] ?? '',
                    'meta_description' => $_POST['meta_description'][$lang] ?? '',
                    'max_width' => $_POST['max_width'][$lang] ?? '',
                    'max_height' => $_POST['max_height'][$lang] ?? '',
                    'panel_thickness' => $_POST['panel_thickness'][$lang] ?? '',
                    'insulation' => $_POST['insulation'][$lang] ?? ''
                ];
            }

            if ($productModel->update($params['id'], $status, $langData)) {
                if (isset($_POST['categories']) && is_array($_POST['categories'])) {
                    $productModel->setCategories($params['id'], $_POST['categories']);
                }
                Flash::set('Товар успешно обновлен');
            } else {
                Flash::set('Ошибка при обновлении товара', 'error');
            }
            header('Location: ' . SITE_URL . '/admin/products');
            exit;
        }
        $this->view('admin/products/form', [
            'product' => $product,
            'translations' => $translations,
            'categories' => $categories,
            'product_categories' => $product_categories,
            'csrf_token' => $_SESSION['csrf_token']
        ]);
    }

    public function delete_product($params) {
        $this->checkAuth();
        $productModel = new Product();
        if ($productModel->delete($params['id'])) {
            Flash::set('Товар успешно удален');
        } else {
            Flash::set('Ошибка при удалении товара', 'error');
        }
        header('Location: ' . SITE_URL . '/admin/products');
        exit;
    }

    public function pages() { $this->checkAuth(); $pageModel = new Page(); $pages = $pageModel->getAll(); $this->view('admin/pages/index', ['pages' => $pages]); }
    public function create_page() {
        $this->checkAuth();
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            if (!hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'])) {
                die('Ошибка валидации CSRF-токена');
            }
            $pageModel = new Page();
            // Collect multi-language data
            $langData = [];
            foreach (SUPPORTED_LANGUAGES as $lang) {
                $langData[$lang] = [
                    'title' => $_POST['title'][$lang] ?? '',
                    'slug' => $_POST['slug'][$lang] ?? '',
                    'content' => $_POST['content'][$lang] ?? '',
                    'seo_title' => $_POST['seo_title'][$lang] ?? '',
                    'meta_description' => $_POST['meta_description'][$lang] ?? ''
                ];
            }

            if ($pageModel->create($langData)) {
                Flash::set('Страница успешно создана');
            } else {
                Flash::set('Ошибка при создании страницы', 'error');
            }
            header('Location: ' . SITE_URL . '/admin/pages');
            exit;
        }
        $this->view('admin/pages/form', ['csrf_token' => $_SESSION['csrf_token']]);
    }

    public function edit_page($params) {
        $this->checkAuth();
        $pageModel = new Page();

        // Handle 'about' slug specifically
        if (isset($params['id']) && $params['id'] === 'about') {
            $page = $pageModel->getBySlug('about');
            if (!$page) {
                // Handle case where 'about' page doesn't exist
                Flash::set('Страница "О нас" не найдена.', 'error');
                header('Location: ' . SITE_URL . '/admin/pages');
                exit;
            }
            $pageId = $page['id'];
        } else {
            $pageId = $params['id'];
        }

        $page = $pageModel->getById($pageId);
        $translations = $pageModel->getTranslations($pageId);

        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            if (!hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'])) {
                die('Ошибка валидации CSRF-токена');
            }

            // Collect multi-language data
            $langData = [];
            foreach (SUPPORTED_LANGUAGES as $lang) {
                $langData[$lang] = [
                    'title' => $_POST['title'][$lang] ?? '',
                    'slug' => $_POST['slug'][$lang] ?? '',
                    'content' => $_POST['content'][$lang] ?? '',
                    'seo_title' => $_POST['seo_title'][$lang] ?? '',
                    'meta_description' => $_POST['meta_description'][$lang] ?? ''
                ];
            }

            if ($pageModel->update($params['id'], $langData)) {
                Flash::set('Страница успешно обновлена');
            } else {
                Flash::set('Ошибка при обновлении страницы', 'error');
            }
            header('Location: ' . SITE_URL . '/admin/pages');
            exit;
        }
        $this->view('admin/pages/form', ['page' => $page, 'translations' => $translations, 'csrf_token' => $_SESSION['csrf_token']]);
    }

    public function delete_page($params) {
        $this->checkAuth();
        $pageModel = new Page();
        if ($pageModel->delete($params['id'])) {
            Flash::set('Страница успешно удалена');
        } else {
            Flash::set('Ошибка при удалении страницы', 'error');
        }
        header('Location: ' . SITE_URL . '/admin/pages');
        exit;
    }

    public function categories() {
        $this->checkAuth();
        $categoryModel = new Category();
        $categories = $categoryModel->getAll();
        $this->view('admin/categories/index', ['categories' => $categories]);
    }

    public function create_category() {
        $this->checkAuth();
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            if (!hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'])) {
                die('Ошибка валидации CSRF-токена');
            }
            $categoryModel = new Category();

            // Collect multi-language data
            $langData = [];
            foreach (SUPPORTED_LANGUAGES as $lang) {
                $langData[$lang] = [
                    'name' => $_POST['name'][$lang] ?? '',
                    'slug' => $_POST['slug'][$lang] ?? '',
                    'description' => $_POST['description'][$lang] ?? '',
                    'seo_title' => $_POST['seo_title'][$lang] ?? '',
                    'meta_description' => $_POST['meta_description'][$lang] ?? ''
                ];
            }

            if ($categoryModel->create(NULL, $langData)) {
                Flash::set('Категория успешно создана');
            } else {
                Flash::set('Ошибка при создании категории', 'error');
            }
            header('Location: '. SITE_URL . '/admin/categories');
            exit;
        }
        $this->view('admin/categories/form', ['csrf_token' => $_SESSION['csrf_token']]);
    }

    public function edit_category($params) {
        $this->checkAuth();
        $categoryModel = new Category();
        $category = $categoryModel->getById($params['id']);
        $translations = $categoryModel->getTranslations($params['id']);

        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            if (!hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'])) {
                die('Ошибка валидации CSRF-токена');
            }

            // Collect multi-language data
            $langData = [];
            foreach (SUPPORTED_LANGUAGES as $lang) {
                $langData[$lang] = [
                    'name' => $_POST['name'][$lang] ?? '',
                    'slug' => $_POST['slug'][$lang] ?? '',
                    'description' => $_POST['description'][$lang] ?? '',
                    'seo_title' => $_POST['seo_title'][$lang] ?? '',
                    'meta_description' => $_POST['meta_description'][$lang] ?? ''
                ];
            }

            if ($categoryModel->update($params['id'], NULL, $langData)) {
                Flash::set('Категория успешно обновлена');
            } else {
                Flash::set('Ошибка при обновлении категории', 'error');
            }
            header('Location: ' . SITE_URL . '/admin/categories');
            exit;
        }
        $this->view('admin/categories/form', ['category' => $category, 'translations' => $translations, 'csrf_token' => $_SESSION['csrf_token']]);
    }

    public function delete_category($params) {
        $this->checkAuth();
        $categoryModel = new Category();
        if ($categoryModel->delete($params['id'])) {
            Flash::set('Категория успешно удалена');
        } else {
            Flash::set('Ошибка при удалении категории', 'error');
        }
        header('Location: ' . SITE_URL . '/admin/categories');
        exit;
    }

    public function posts() {
        $this->checkAuth();
        $postModel = new Post();
        $posts = $postModel->getAll();
        $this->view('admin/posts/index', ['posts' => $posts]);
    }

    public function create_post() {
        $this->checkAuth();
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            if (!hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'])) {
                die('Ошибка валидации CSRF-токена');
            }
            $postModel = new Post();

            // Collect multi-language data
            $langData = [];
            foreach (SUPPORTED_LANGUAGES as $lang) {
                $langData[$lang] = [
                    'title' => $_POST['title'][$lang] ?? '',
                    'slug' => $_POST['slug'][$lang] ?? '',
                    'content' => $_POST['content'][$lang] ?? '',
                    'seo_title' => $_POST['seo_title'][$lang] ?? '',
                    'meta_description' => $_POST['meta_description'][$lang] ?? ''
                ];
            }
            $status = $_POST['status'];

            $image = $this->handleUpload('image');
            $image2 = $this->handleUpload('image2');
            $image3 = $this->handleUpload('image3');

            $data = [
                'status' => $status,
                'image' => $image,
                'image2' => $image2,
                'image3' => $image3
            ];

            if ($postModel->create($data, $langData)) {
                Flash::set('Новость успешно создана');
            } else {
                Flash::set('Ошибка при создании новости', 'error');
            }
            header('Location: ' . SITE_URL . '/admin/posts');
            exit;
        }
        $this->view('admin/posts/form', ['csrf_token' => $_SESSION['csrf_token']]);
    }

    public function edit_post($params) {
        $this->checkAuth();
        $postModel = new Post();
        $post = $postModel->getById($params['id']);
        $translations = $postModel->getTranslations($params['id']);

        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            if (!hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'])) {
                die('Ошибка валидации CSRF-токена');
            }

            // Collect multi-language data
            $langData = [];
            foreach (SUPPORTED_LANGUAGES as $lang) {
                $langData[$lang] = [
                    'title' => $_POST['title'][$lang] ?? '',
                    'slug' => $_POST['slug'][$lang] ?? '',
                    'content' => $_POST['content'][$lang] ?? '',
                    'seo_title' => $_POST['seo_title'][$lang] ?? '',
                    'meta_description' => $_POST['meta_description'][$lang] ?? ''
                ];
            }
            $status = $_POST['status'];

            $data = ['status' => $status];
            if (!empty($_FILES['image']['name'])) {
                $data['image'] = $this->handleUpload('image');
            }
            if (!empty($_FILES['image2']['name'])) {
                $data['image2'] = $this->handleUpload('image2');
            }
            if (!empty($_FILES['image3']['name'])) {
                $data['image3'] = $this->handleUpload('image3');
            }

            if ($postModel->update($params['id'], $data, $langData)) {
                Flash::set('Новость успешно обновлена');
            } else {
                Flash::set('Ошибка при обновлении новости', 'error');
            }
            header('Location: ' . SITE_URL . '/admin/posts');
            exit;
        }
        $this->view('admin/posts/form', ['post' => $post, 'translations' => $translations, 'csrf_token' => $_SESSION['csrf_token']]);
    }

    public function delete_post($params) {
        $this->checkAuth();
        $postModel = new Post();
        if ($postModel->delete($params['id'])) {
            Flash::set('Новость успешно удалена');
        } else {
            Flash::set('Ошибка при удалении новости', 'error');
        }
        header('Location: ' . SITE_URL . '/admin/posts');
        exit;
    }

    public function messages() {
        $this->checkAuth();
        $messageModel = new Message();
        $messages = $messageModel->getAll();
        $this->view('admin/messages/index', ['messages' => $messages]);
    }

    public function view_message($params) {
        $this->checkAuth();
        $messageModel = new Message();
        $messageModel->markAsRead($params['id']);
        $message = $messageModel->getById($params['id']);
        $this->view('admin/messages/view', ['message' => $message]);
    }

    public function delete_message($params) {
        $this->checkAuth();
        $messageModel = new Message();
        if ($messageModel->delete($params['id'])) {
            Flash::set('Сообщение успешно удалено');
        } else {
            Flash::set('Ошибка при удалении сообщения', 'error');
        }
        header('Location: ' . SITE_URL . '/admin/messages');
        exit;
    }

    public function export_messages() {
        $this->checkAuth();
        $messageModel = new Message();
        $messages = $messageModel->getAll();

        header('Content-Type: text/csv');
        header('Content-Disposition: attachment; filename="messages.csv"');

        $output = fopen('php://output', 'w');
        fputcsv($output, ['ID', 'Name', 'Email', 'Phone', 'Message', 'Date']);

        foreach ($messages as $message) {
            fputcsv($output, $message);
        }
        fclose($output);
        exit;
    }

    public function settings() {
        $this->checkAuth();
        $db = Database::getInstance()->getConnection();
        $stmt = $db->prepare("SELECT `key`, `value` FROM settings");
        $stmt->execute();
        $settings = $stmt->fetchAll(PDO::FETCH_KEY_PAIR);

        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            if (!hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'])) {
                die('Ошибка валидации CSRF-токена');
            }

            $stmt = $db->prepare("UPDATE settings SET value = ? WHERE `key` = ?");
            $stmt->execute([$_POST['site_title'], 'site_title']);
            $stmt->execute([$_POST['contact_email'], 'contact_email']);

            Flash::set('Настройки успешно сохранены');
            header('Location: ' . SITE_URL . '/admin/settings');
            exit;
        }

        $this->view('admin/settings', ['settings' => $settings, 'csrf_token' => $_SESSION['csrf_token']]);
    }

    private function view($view, $data = [], $withLayout = true) {
        extract($data);
        if ($withLayout) {
            require_once ROOT_PATH . '/templates/admin/header.php';
        }
        require_once ROOT_PATH . '/templates/' . $view . '.php';
        if ($withLayout) {
            require_once ROOT_PATH . '/templates/admin/footer.php';
        }
    }

    private function handleUpload($fileKey) {
        if (isset($_FILES[$fileKey]) && $_FILES[$fileKey]['error'] === UPLOAD_ERR_OK) {
            $uploadDir = ROOT_PATH . UPLOADS_DIR;
            if (!is_dir($uploadDir)) {
                mkdir($uploadDir, 0777, true);
            }

            $fileName = uniqid() . '-' . basename($_FILES[$fileKey]['name']);
            $targetPath = $uploadDir . $fileName;

            if (move_uploaded_file($_FILES[$fileKey]['tmp_name'], $targetPath)) {
                return 'news/' . $fileName;
            }
        }
        return null;
    }
}
