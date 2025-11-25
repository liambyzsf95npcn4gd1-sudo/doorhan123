<?php
// Контроллер для публичной части сайта

class PublicController {

    /**
     * Отображение главной страницы
     */
    public function home($params = [], $uri = '/') {
        $productModel = new Product();
        $postModel = new Post();

        $featuredProducts = $productModel->getAllActive(4);
        $latestNews = $postModel->getAllPublished(3);

        $this->view('public/home', [
            'featured_products' => $featuredProducts,
            'latest_posts' => $latestNews,
            'seo_title' => __('Home') . ' | DoorHan',
            'meta_description' => 'DoorHan is a leading global manufacturer of gates, doors, and automation systems.'
        ], $uri);
    }

    public function about($params = [], $uri = '/') {
        $this->view('public/about', [
            'seo_title' => __('About Us') . ' | DoorHan',
            'meta_description' => 'Learn more about DoorHan, a leading manufacturer of garage doors, gates, and automation systems.'
        ], $uri);
    }

    public function privacyPolicy($params = [], $uri = '/') {
        $this->view('public/privacy-policy', [
            'seo_title' => __('Privacy Policy') . ' | DoorHan',
            'meta_description' => 'Read our Privacy Policy to understand how we handle your data.'
        ], $uri);
    }

    public function products($params = [], $uri = '/') {
        $categoryModel = new Category();
        $categories = $categoryModel->getAll();
        $this->view('public/products', [
            'categories' => $categories,
            'seo_title' => __('All Products') . ' | DoorHan',
            'meta_description' => 'Browse our wide range of high-quality garage doors, gates, and automation systems.'
        ], $uri);
    }

    public function category($params, $uri = '/') {
        $categoryModel = new Category();
        $category = $categoryModel->getBySlug($params['slug']);

        if (!$category) {
            header("HTTP/1.0 404 Not Found");
            $this->view('public/404', [], $uri);
            return;
        }

        $products = $categoryModel->getProductsByCategoryId($category['id']);

        $this->view('public/category', [
            'category' => $category,
            'products' => $products,
            'seo_title' => $category['seo_title'] ?? $category['name'],
            'meta_description' => $category['meta_description'] ?? ''
        ], $uri);
    }

    public function product($params, $uri = '/') {
        $productModel = new Product();
        $product = $productModel->getBySlug($params['slug']);

        if (!$product) {
            header("HTTP/1.0 404 Not Found");
            $this->view('public/404', [], $uri);
            return;
        }

        $images = $productModel->getImages($product['id']);

        $this->view('public/product', [
            'product' => $product,
            'images' => $images,
            'seo_title' => $product['seo_title'] ?? $product['name'],
            'meta_description' => $product['meta_description'] ?? ''
        ], $uri);
    }

    public function factories($params = [], $uri = '/') {
        $this->view('public/factories', [
            'seo_title' => __('Our Factories') . ' | DoorHan',
            'meta_description' => 'Learn more about our state-of-the-art manufacturing facilities and our global presence.'
        ], $uri);
    }

    public function solutions($params = [], $uri = '/') {
        $this->view('public/solutions', [
            'seo_title' => 'Innovative Solutions | DoorHan',
            'meta_description' => 'Discover our innovative solutions for residential, commercial, and industrial applications.'
        ], $uri);
    }

    public function news($params = [], $uri = '/') {
        $postModel = new Post();
        $page = isset($_GET['page']) ? (int)$_GET['page'] : 1;
        $limit = 10;
        $offset = ($page - 1) * $limit;

        $posts = $postModel->getAllPublished($limit, $offset);
        $totalPosts = $postModel->countAllPublished();
        $totalPages = ceil($totalPosts / $limit);

        $this->view('public/news', [
            'posts' => $posts,
            'currentPage' => $page,
            'totalPages' => $totalPages,
            'seo_title' => __('News and Updates') . ' | DoorHan',
            'meta_description' => 'Stay up-to-date with the latest news and announcements from DoorHan.'
        ], $uri);
    }

    public function post($params, $uri = '/') {
        $postModel = new Post();
        $post = $postModel->getBySlug($params['slug']);

        if (!$post) {
            header("HTTP/1.0 404 Not Found");
            $this->view('public/404', [], $uri);
            return;
        }

        $this->view('public/post', [
            'post' => $post,
            'seo_title' => $post['seo_title'] ?? $post['title'],
            'meta_description' => $post['meta_description'] ?? ''
        ], $uri);
    }

    public function contact($params = [], $uri = '/') {
        if (empty($_SESSION['csrf_token'])) {
            $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
        }

        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            if (!isset($_POST['csrf_token']) || !hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'])) {
                $error = "Invalid CSRF token.";
            } else {
                $name = htmlspecialchars(trim($_POST['name']));
                $email = filter_var(trim($_POST['email']), FILTER_SANITIZE_EMAIL);
                $phone = htmlspecialchars(trim($_POST['phone']));
                $message = htmlspecialchars(trim($_POST['message']));

                $errors = [];
                if (empty($name)) $errors[] = "Name is required.";
                if (!filter_var($email, FILTER_VALIDATE_EMAIL)) $errors[] = "Invalid email format.";
                if (empty($message)) $errors[] = "Message is required.";

                if (empty($errors)) {
                    $messageModel = new Message();
                    if ($messageModel->save($name, $email, $phone, $message)) {
                        $success = "Your message has been sent successfully!";
                        unset($_POST);
                        $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
                    } else {
                        $error = "There was an error sending your message.";
                    }
                } else {
                    $error = implode("<br>", $errors);
                }
            }
        }

        $this->view('public/contact', [
            'success' => $success ?? null,
            'error' => $error ?? null,
            'csrf_token' => $_SESSION['csrf_token'],
            'seo_title' => __('Contact Us') . ' | DoorHan',
            'meta_description' => 'Get in touch with DoorHan for any inquiries or to find a dealer near you.'
        ], $uri);
    }

    public function sitemap($params = [], $uri = '/') {
        header("Content-Type: application/xml; charset=utf-8");

        $urls = [];
        $base_url = SITE_URL; // Should account for language

        // Static pages
        $urls[] = $base_url . '/';
        $urls[] = $base_url . '/about';
        // ... (Update sitemap logic to include languages later)

        echo '<?xml version="1.0" encoding="UTF-8"?>';
        echo '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">';
        foreach ($urls as $url) {
            echo '<url><loc>' . htmlspecialchars($url) . '</loc></url>';
        }
        echo '</urlset>';
    }

    private function view($view, $data = [], $uri = '/') {
        $navigationModel = new Navigation();
        $data['menuItems'] = $navigationModel->getMenuItems();

        $settingsModel = new Settings();
        $data['settings'] = $settingsModel->getAllSettings();

        $data['current_uri'] = $uri;

        extract($data);
        require_once ROOT_PATH . '/templates/' . $view . '.php';
    }
}
