<?php
define('SITE_URL', 'http://localhost:8080');
define('UPLOADS_DIR', '/uploads/');
$post = ['image' => 'news/news2.jpg'];
echo SITE_URL . '/uploads/' . $post['image'];
echo "\n";
echo SITE_URL . UPLOADS_DIR . $post['image'];
?>
