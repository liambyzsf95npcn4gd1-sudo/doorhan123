<?php
// Контроллер для админ-панели

class AdminController {

    const MAX_LOGIN_ATTEMPTS = 5;
    const LOCKOUT_TIME = 900; // 15 минут

    public function __construct() {
        // Генерация CSRF-токена
        if (empty($_SESSION['csrf_token'])) {
            $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
        }
    }

    /**
     * Проверка, авторизован ли администратор
     */
    private function checkAuth() {
        if (!isset($_SESSION['user_id'])) {
            header('Location: ' . SITE_URL . '/admin/login'); // <- Я поправил и здесь, на всякий случай
            exit;
        }
    }

    private function hasPermission($role) {
        // Пока просто проверяем, залогинен ли пользователь.
        // Можно расширить для проверки по $_SESSION['user_role']
        return isset($_SESSION['user_id']);
    }

    /**
     * Главная страница админ-панели
     */
    public function dashboard() {
        $this->checkAuth();
        $this->view('admin/dashboard');
    }

    /**
     * Страница входа и обработка формы
     */
    public function login() {
        if (isset($_SESSION['user_id'])) {
            header('Location: ' . SITE_URL . '/admin');
            exit;
        }

        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            // Проверка CSRF-токена
            if (!isset($_POST['csrf_token']) || !hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'])) {
                die('Ошибка валидации CSRF-токена');
            }

            // Ограничение попыток входа
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
                        // Пересоздаем ID сессии для предотвращения фиксации сессии
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

    /**
     * Выход из системы
     */
    public function logout() {
        $_SESSION = [];

        // Получаем параметры cookie сессии, чтобы корректно их удалить
        $params = session_get_cookie_params();

        // Отправляем cookie с истекшим сроком годности
        setcookie(session_name(), '', time() - 42000,
            $params["path"], $params["domain"],
            $params["secure"], $params["httponly"]
        );

        session_destroy();

        // Этот редирект уже был правильным
        header('Location: ' . SITE_URL . '/admin/login');
        exit;
    }

    /**
     * Управление страницами
     */
    public function pages() {
        $this->checkAuth();
        $pageModel = new Page();
        $pages = $pageModel->getAll();
        $this->view('admin/pages/index', ['pages' => $pages]);
    }

    public function create_page() {
        $this->checkAuth();
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            if (!hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'])) {
                die('Ошибка валидации CSRF-токена');
            }
            $pageModel = new Page();
            if ($pageModel->create($_POST['title'], $_POST['slug'], $_POST['content'], $_POST['seo_title'], $_POST['meta_description'])) {
                Flash::set('Страница успешно создана');
            } else {
                Flash::set('Ошибка при создании страницы', 'error');
            }
            // ИСПРАВЛЕНО:
            header('Location: ' . SITE_URL . '/admin/pages');
            exit;
        }
        $this->view('admin/pages/form', ['csrf_token' => $_SESSION['csrf_token']]);
    }

    public function edit_page($params) {
        $this->checkAuth();
        $pageModel = new Page();
        $page = $pageModel->getById($params['id']);
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            if (!hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'])) {
                die('Ошибка валидации CSRF-токена');
            }
            if ($pageModel->update($params['id'], $_POST['title'], $_POST['slug'], $_POST['content'], $_POST['seo_title'], $_POST['meta_description'])) {
                Flash::set('Страница успешно обновлена');
            } else {
                Flash::set('Ошибка при обновлении страницы', 'error');
            }
            // ИСПРАВЛЕНО:
            header('Location: ' . SITE_URL . '/admin/pages');
            exit;
        }
        $this->view('admin/pages/form', ['page' => $page, 'csrf_token' => $_SESSION['csrf_token']]);
    }

    public function delete_page($params) {
        $this->checkAuth();
        $pageModel = new Page();
        if ($pageModel->delete($params['id'])) {
            Flash::set('Страница успешно удалена');
        } else {
            Flash::set('Ошибка при удалении страницы', 'error');
        }
        // ИСПРАВЛЕНО:
        header('Location: ' . SITE_URL . '/admin/pages');
        exit;
    }

    /**
     * Управление категориями
     */
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
            // Set parent_id to NULL as it's no longer used from the form
            if ($categoryModel->create($_POST['name'], $_POST['slug'], NULL, $_POST['seo_title'], $_POST['meta_description'])) {
                Flash::set('Категория успешно создана');
            } else {
                Flash::set('Ошибка при создании категории', 'error');
            }
            // ИСПРАВЛЕНО:
            header('Location: '. SITE_URL . '/admin/categories');
            exit;
        }
        $this->view('admin/categories/form', ['csrf_token' => $_SESSION['csrf_token']]);
    }

    public function edit_category($params) {
        $this->checkAuth();
        $categoryModel = new Category();
        $category = $categoryModel->getById($params['id']);
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            if (!hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'])) {
                die('Ошибка валидации CSRF-токена');
            }
            // Set parent_id to NULL as it's no longer used from the form
            if ($categoryModel->update($params['id'], $_POST['name'], $_POST['slug'], NULL, $_POST['seo_title'], $_POST['meta_description'])) {
                Flash::set('Категория успешно обновлена');
            } else {
                Flash::set('Ошибка при обновлении категории', 'error');
            }
            // ИСПРАВЛЕНО:
            header('Location: ' . SITE_URL . '/admin/categories');
            exit;
        }
        $this->view('admin/categories/form', ['category' => $category, 'csrf_token' => $_SESSION['csrf_token']]);
    }

    public function delete_category($params) {
        $this->checkAuth();
        $categoryModel = new Category();
        if ($categoryModel->delete($params['id'])) {
            Flash::set('Категория успешно удалена');
        } else {
            Flash::set('Ошибка при удалении категории', 'error');
        }
        // ИСПРАВЛЕНО:
        header('Location: ' . SITE_URL . '/admin/categories');
        exit;
    }

    /**
     * Управление товарами
     */
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
            $productId = $productModel->create($_POST['name'], $_POST['slug'], $_POST['content'], $_POST['status'], $_POST['seo_title'], $_POST['meta_description']);

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
        $product = $productModel->getById($params['id']);
        $categoryModel = new Category();
        $categories = $categoryModel->getAll();
        $product_categories = $productModel->getCategoryIds($params['id']);


        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            if (!hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'])) {
                die('Ошибка валидации CSRF-токена');
            }
            if ($productModel->update($params['id'], $_POST['name'], $_POST['slug'], $_POST['content'], $_POST['status'], $_POST['seo_title'], $_POST['meta_description'])) {
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
        // ИСПРАВЛЕНО:
        header('Location: ' . SITE_URL . '/admin/products');
        exit;
    }

    /**
     * Управление новостями
     */
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
            if ($postModel->create($_POST['title'], $_POST['slug'], $_POST['content'], $_POST['status'], $_POST['seo_title'], $_POST['meta_description'])) {
                Flash::set('Новость успешно создана');
            } else {
                Flash::set('Ошибка при создании новости', 'error');
            }
            // ИСПРАВЛЕНО:
            header('Location: ' . SITE_URL . '/admin/posts');
            exit;
        }
        $this->view('admin/posts/form', ['csrf_token' => $_SESSION['csrf_token']]);
    }

    public function edit_post($params) {
        $this->checkAuth();
        $postModel = new Post();
        $post = $postModel->getById($params['id']);
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            if (!hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'])) {
                die('Ошибка валидации CSRF-токена');
            }
            if ($postModel->update($params['id'], $_POST['title'], $_POST['slug'], $_POST['content'], $_POST['status'], $_POST['seo_title'], $_POST['meta_description'])) {
                Flash::set('Новость успешно обновлена');
            } else {
                Flash::set('Ошибка при обновлении новости', 'error');
            }
            // ИСПРАВЛЕНО:
            header('Location: ' . SITE_URL . '/admin/posts');
            exit;
        }
        $this->view('admin/posts/form', ['post' => $post, 'csrf_token' => $_SESSION['csrf_token']]);
    }

    public function delete_post($params) {
        $this->checkAuth();
        $postModel = new Post();
        if ($postModel->delete($params['id'])) {
            Flash::set('Новость успешно удалена');
        } else {
            Flash::set('Ошибка при удалении новости', 'error');
        }
        // ИСПРАВЛЕНО:
        header('Location: ' . SITE_URL . '/admin/posts');
        exit;
    }

    /**
     * Управление сообщениями
     */
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
        // ИСПРАВЛЕНО:
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

    /**
     * Управление настройками
     */
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
            // ИСПРАВЛЕНО:
            header('Location: ' . SITE_URL . '/admin/settings');
            exit;
        }

        $this->view('admin/settings', ['settings' => $settings, 'csrf_token' => $_SESSION['csrf_token']]);
    }

    /**
     * Загрузка вида
     * @param string $view
     * @param array $data
     * @param bool $withLayout
     */
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
}