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
            'featured_products' => $featuredProducts,
            'latest_posts' => $latestNews,
            'seo_title' => 'DoorHan International - Leading Manufacturer of Doors and Gates',
            'meta_description' => 'DoorHan is a leading global manufacturer of gates, doors, and automation systems. We offer innovative and reliable solutions for your home and business.'
        ]);
    }

    /**
     * Отображение страницы "О нас"
     */
    public function about() {
        $this->page(['slug' => 'about']);
    }

    /**
     * Отображение статической страницы по ее слагу
     * @param array $params
     */
    public function page($params) {
        $pageModel = new Page();
        $page = $pageModel->getBySlug($params['slug']);

        if (!$page) {
            header("HTTP/1.0 404 Not Found");
            $this->view('public/404');
            return;
        }

        $this->view('public/page', [
            'page' => $page,
            'seo_title' => $page['seo_title'] ?? $page['title'],
            'meta_description' => $page['meta_description'] ?? ''
        ]);
    }

    /**
     * Отображение списка товаров
     */
    public function products() {
        $categoryModel = new Category();
        $categories = $categoryModel->getAll(); // Get all categories
        $this->view('public/products', [
            'categories' => $categories,
            'seo_title' => 'All Product Categories | DoorHan',
            'meta_description' => 'Browse our wide range of products, including sectional doors, roller shutters, high-speed doors, and more. Find the perfect solution for your needs.'
        ]);
    }

    /**
     * Отображение страницы одной категории
     * @param array $params
     */
    public function category($params) {
        $categoryModel = new Category();
        $category = $categoryModel->getBySlug($params['slug']);

        if (!$category) {
            // Handle category not found, maybe show a 404 page
            header("HTTP/1.0 404 Not Found");
            $this->view('public/404'); // Assuming you have a 404 template
            return;
        }

        $products = $categoryModel->getProductsByCategoryId($category['id']);

        $this->view('public/category', [
            'category' => $category,
            'products' => $products,
            'seo_title' => $category['seo_title'] ?? $category['name'],
            'meta_description' => $category['meta_description'] ?? ''
        ]);
    }

    /**
     * Отображение страницы одного товара
     * @param array $params
     */
    public function product($params) {
        $productModel = new Product();
        $product = $productModel->getBySlug($params['slug']);
        $this->view('public/product', [
            'product' => $product,
            'seo_title' => $product['seo_title'] ?? $product['name'],
            'meta_description' => $product['meta_description'] ?? ''
        ]);
    }

    /**
     * Отображение страницы "Производство"
     */
    public function factories() {
        $this->page(['slug' => 'factories']);
    }

    /**
     * Отображение страницы "Решения"
     */
    public function solutions() {
        $this->page(['slug' => 'solutions']);
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
            'totalPages' => $totalPages,
            'seo_title' => 'Latest News and Updates | DoorHan',
            'meta_description' => 'Stay up-to-date with the latest news, events, and product announcements from DoorHan.'
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
            'csrf_token' => $_SESSION['csrf_token'],
            'seo_title' => 'Contact Us | DoorHan',
            'meta_description' => 'Get in touch with DoorHan. We are here to help you with any questions you may have about our products and services.'
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