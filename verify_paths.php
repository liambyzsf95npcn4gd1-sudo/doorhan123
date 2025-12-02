<?php
// Script to verify if the news images are correctly rendering
// This simulates the logic used in the templates

// Mock environment
define('SITE_URL', 'http://localhost:8080');
define('ROOT_PATH', __DIR__);
define('UPLOADS_DIR', '/uploads/');

// Mock data
$posts = [
    [
        'id' => 1,
        'title' => 'Test News 1',
        'image' => 'news/news2.jpg'
    ],
    [
        'id' => 2,
        'title' => 'Test News 2',
        'image' => null // Should trigger fallback
    ]
];

echo "Testing Home Logic:\n";
foreach ($posts as $post) {
    $imgSrc = !empty($post['image']) ? SITE_URL . '/uploads/' . $post['image'] : SITE_URL . '/assets/img/news-placeholder.jpg';
    echo "ID " . $post['id'] . ": " . $imgSrc . "\n";
}

echo "\nTesting News Logic:\n";
foreach ($posts as $post) {
    // Logic from news.php
    $imgSrc = !empty($post['image']) ? SITE_URL . '/uploads/' . $post['image'] : SITE_URL . '/assets/img/news-placeholder.jpg';
    echo "ID " . $post['id'] . ": " . $imgSrc . "\n";
}

echo "\nTesting Post Logic (Single Page):\n";
foreach ($posts as $post) {
    // Logic from post.php
    if (!empty($post['image'])) {
        echo "ID " . $post['id'] . ": " . SITE_URL . '/uploads/' . $post['image'] . "\n";
    } else {
        echo "ID " . $post['id'] . ": " . SITE_URL . '/assets/img/news-placeholder.jpg' . " (Fallback)\n";
    }
}
