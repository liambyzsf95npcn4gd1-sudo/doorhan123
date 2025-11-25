<?php require_once ROOT_PATH . '/templates/public/header.php'; ?>

<section class="page-header">
    <div class="container">
        <h1><?php echo htmlspecialchars($page['title'] ?? __('about_us_title')); ?></h1>
    </div>
</section>

<section class="section-padding">
    <div class="container">
        <?php if ($page): ?>
            <?php echo $page['content']; ?>
        <?php else: ?>
            <h1><?php echo __('about_doorhan_title'); ?></h1>
            <p><?php echo __('about_doorhan_desc'); ?></p>
            <img src="/assets/img/placeholder.jpg" alt="Placeholder Image">
            <p><?php echo __('mission_desc'); ?></p>
            <img src="/assets/img/placeholder.jpg" alt="Placeholder Image">
        <?php endif; ?>
    </div>
</section>

<?php require_once ROOT_PATH . '/templates/public/footer.php'; ?>
