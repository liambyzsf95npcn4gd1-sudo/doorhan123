<?php
// Контроллер для публичной части сайта

class PublicController {

    /**
     * Отображение главной страницы
     */
    public function home() {
        $productModel = new Product();
        $postModel = new Post();

        $featuredProducts = $productModel->getAllActive(4);
        $latestNews = $postModel->getAllPublished(3);

        $this->view('public/home', [
            'featured_products' => $featuredProducts, // [ИСПРАВЛЕНО] (было featuredProducts)
            'latest_posts' => $latestNews      // [ИСПРАВЛЕНО] (было latestNews)
        ]);
    }

    /**
     * Отображение страницы "О нас"
     */
    public function about() {
        $pageModel = new Page();
        $page = $pageModel->getBySlug('about');
        $this->view('public/page', ['page' => $page]);
    }

    /**
     * Отображение списка товаров
     */
    public function products() {
        $productModel = new Product();
        $page = isset($_GET['page']) ? (int)$_GET['page'] : 1;
        $limit = 12; // Products per page
        $offset = ($page - 1) * $limit;

        $products = $productModel->getAllActive($limit, $offset);
        $totalProducts = $productModel->countAllActive();
        $totalPages = ceil($totalProducts / $limit);

        $this->view('public/products', [
            'products' => $products,
            'currentPage' => $page,
            'totalPages' => $totalPages
        ]);
    }

    /**
     * Отображение страницы одного товара
     * @param array $params
     */
    public function product($params) {
        $productModel = new Product();
        $product = $productModel->getBySlug($params['slug']);
        $this->view('public/product', ['product' => $product]);
    }

    /**
     * Отображение страницы "Производство"
     */
    public function factories() {
        $pageModel = new Page();
        $page = $pageModel->getBySlug('factories');
        $this->view('public/page', ['page' => $page]);
    }

    /**
     * Отображение страницы "Решения"
     */
    public function solutions() {
        $pageModel = new Page();
        $page = $pageModel->getBySlug('solutions');
        $this->view('public/page', ['page' => $page]);
    }

    /**
     * Отображение списка новостей
     */
    public function news() {
        $postModel = new Post();
        $page = isset($_GET['page']) ? (int)$_GET['page'] : 1;
        $limit = 10; // Posts per page
        $offset = ($page - 1) * $limit;

        $posts = $postModel->getAllPublished($limit, $offset);
        $totalPosts = $postModel->countAllPublished();
        $totalPages = ceil($totalPosts / $limit);

        $this->view('public/news', [
            'posts' => $posts,
            'currentPage' => $page,
            'totalPages' => $totalPages
        ]);
    }

    /**
     * Отображение страницы одной новости
     * @param array $params
     */
    public function post($params) {
        $postModel = new Post();
        $post = $postModel->getBySlug($params['slug']);
        $this->view('public/post', ['post' => $post]);
    }

    /**
     * Отображение страницы контактов и обработка формы
     */
    public function contact() {
        
        // ИСПРАВЛЕНО: Убедимся, что токен существует, *до* обработки формы
        if (empty($_SESSION['csrf_token'])) {
            $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
        }

        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            // CSRF check
            if (!isset($_POST['csrf_token']) || !hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'])) {
                $error = "Invalid CSRF token.";
            } else {
                // Sanitize and validate inputs
                $name = htmlspecialchars(trim($_POST['name']));
                $email = filter_var(trim($_POST['email']), FILTER_SANITIZE_EMAIL);
                $phone = htmlspecialchars(trim($_POST['phone']));
                $message = htmlspecialchars(trim($_POST['message']));

                $errors = [];
                if (empty($name)) {
                    $errors[] = "Name is required.";
                }
                if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
                    $errors[] = "Invalid email format.";
                }
                if (empty($message)) {
                    $errors[] = "Message is required.";
                }

                if (empty($errors)) {
                    $messageModel = new Message();
                    if ($messageModel->save($name, $email, $phone, $message)) {
                        $success = "Your message has been sent successfully!";
                        // Unset form data to prevent re-submission
                        unset($_POST);
                        
                        // ИСПРАВЛЕНО: Регенерируем токен после успешной отправки
                        $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
                    } else {
                        $error = "There was an error sending your message.";
                    }
                } else {
                    $error = implode("<br>", $errors);
                }
            }
        }

        // ИСПРАВЛЕНО: Удалена повторная генерация токена отсюда
        
        $this->view('public/contact', [
            'success' => $success ?? null,
            'error' => $error ?? null,
            'csrf_token' => $_SESSION['csrf_token']
        ]);
    }

    /**
     * Генерация sitemap.xml
     */
    public function sitemap() {
        header("Content-Type: application/xml; charset=utf-8");

        $urls = [];
        $base_url = SITE_URL;

        // Static pages
        $urls[] = $base_url . '/';
        $urls[] = $base_url . '/about';
        $urls[] = $base_url . '/products';
        $urls[] = $base_url . '/factories';
        $urls[] = $base_url . '/solutions';
        $urls[] = $base_url . '/news';
        $urls[] = $base_url . '/contact';

        // Products
        $productModel = new Product();
        $products = $productModel->getAllActive();
        foreach ($products as $product) {
            $urls[] = $base_url . '/products/' . $product['slug'];
        }

        // Posts
        $postModel = new Post();
        $posts = $postModel->getAllPublished();
        foreach ($posts as $post) {
            $urls[] = $base_url . '/news/' . $post['slug'];
        }

        echo '<?xml version="1.0" encoding="UTF-8"?>';
        echo '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">';
        foreach ($urls as $url) {
            echo '<url><loc>' . htmlspecialchars($url) . '</loc></url>';
        }
        echo '</urlset>';
    }

    /**
     * Загрузка вида
     * @param string $view
     * @param array $data
     */
    private function view($view, $data = []) {
        // Fetch navigation menu for all views
        $navigationModel = new Navigation();
        $data['menuItems'] = $navigationModel->getMenuItems();

        // Fetch site settings for all views
        $settingsModel = new Settings();
        $data['settings'] = $settingsModel->getAllSettings();

        extract($data);
        require_once ROOT_PATH . '/templates/' . $view . '.php';
    }
}