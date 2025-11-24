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
            'seo_title' => __('Home') . ' | DoorHan',
            'meta_description' => 'DoorHan is a leading global manufacturer of gates, doors, and automation systems.'
        ]);
    }

    public function about() {
        $this->view('public/about', [
            'seo_title' => __('About') . ' | DoorHan',
            'meta_description' => 'Learn more about DoorHan.'
        ]);
    }

    public function privacyPolicy() {
        $this->view('public/privacy-policy', [
            'seo_title' => __('Privacy Policy') . ' | DoorHan',
            'meta_description' => 'Read our Privacy Policy.'
        ]);
    }

    public function products() {
        $categoryModel = new Category();
        $categories = $categoryModel->getAll(); // TODO: Update Category model to be language aware (handled in view mostly)
        $this->view('public/products', [
            'categories' => $categories,
            'seo_title' => __('Products') . ' | DoorHan',
            'meta_description' => 'Browse our wide range of products.'
        ]);
    }

    public function category($params) {
        $categoryModel = new Category();
        $category = $categoryModel->getBySlug($params['slug']);

        if (!$category) {
            header("HTTP/1.0 404 Not Found");
            $this->view('public/404');
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

    public function product($params) {
        $productModel = new Product();
        $product = $productModel->getBySlug($params['slug']);

        if (!$product) {
            header("HTTP/1.0 404 Not Found");
            $this->view('public/404');
            return;
        }

        $this->view('public/product', [
            'product' => $product,
            'seo_title' => $product['seo_title'] ?? $product['name'],
            'meta_description' => $product['meta_description'] ?? ''
        ]);
    }

    public function factories() {
        $this->view('public/factories', [
            'seo_title' => __('Our Factories') . ' | DoorHan',
            'meta_description' => 'Learn more about our state-of-the-art manufacturing facilities.'
        ]);
    }

    public function solutions() {
        $this->view('public/solutions', [
            'seo_title' => 'Solutions | DoorHan',
            'meta_description' => 'Discover our innovative solutions.'
        ]);
    }

    public function news() {
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
            'seo_title' => __('News') . ' | DoorHan',
            'meta_description' => 'Latest news from DoorHan.'
        ]);
    }

    public function post($params) {
        $postModel = new Post();
        $post = $postModel->getBySlug($params['slug']);
        $this->view('public/post', ['post' => $post]);
    }

    public function contact() {
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
            'seo_title' => __('Contact') . ' | DoorHan',
            'meta_description' => 'Get in touch with DoorHan.'
        ]);
    }

    public function sitemap() {
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

    private function view($view, $data = []) {
        $navigationModel = new Navigation();
        $data['menuItems'] = $navigationModel->getMenuItems();

        $settingsModel = new Settings();
        $data['settings'] = $settingsModel->getAllSettings();

        extract($data);
        require_once ROOT_PATH . '/templates/' . $view . '.php';
    }
}
