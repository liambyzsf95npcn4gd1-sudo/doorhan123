<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Панель управления</title>
    <link rel="stylesheet" href="<?php echo SITE_URL; ?>/assets/css/admin_style.css">
</head>
<body>
    <header>
        <h1>Панель управления сайтом DoorHan</h1>
        <?php if (isset($_SESSION['user_id'])): ?>
        <nav>
            <ul>
                <li><a href="<?php echo SITE_URL; ?>/admin">Главная</a></li>
                <li><a href="<?php echo SITE_URL; ?>/admin/pages">Страницы</a></li>
                <li><a href="<?php echo SITE_URL; ?>/admin/pages/edit/about">Редактировать "О нас"</a></li>
                <li><a href="<?php echo SITE_URL; ?>/admin/categories">Категории</a></li>
                <li><a href="<?php echo SITE_URL; ?>/admin/products">Товары</a></li>
                <li><a href="<?php echo SITE_URL; ?>/admin/posts">Новости</a></li>
                <li><a href="<?php echo SITE_URL; ?>/admin/messages">Сообщения</a></li>
                <li><a href="<?php echo SITE_URL; ?>/admin/settings">Настройки</a></li>
                <li><a href="<?php echo SITE_URL; ?>/admin/logout">Выход</a></li>
            </ul>
        </nav>
        <?php endif; ?>
    </header>
    <main>
        <?php Flash::display(); ?>