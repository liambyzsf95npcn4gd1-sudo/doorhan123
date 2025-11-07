<?php require_once ROOT_PATH . '/templates/public/header.php'; ?>

<section class="page-header">
    <div class="container">
        <h1><?php echo htmlspecialchars($page['title'] ?? 'Page'); ?></h1>
    </div>
</section>

<section class="page-section section-padding">
    <div class="container">
        <?php if (!empty($page['content'])): ?>
            <div class="page-content">
                <?php echo $page['content']; // HTML content from database ?>
            </div>
        <?php else: ?>
            <p>This page is currently empty.</p>
        <?php endif; ?>
    </div>
</section>

<?php require_once ROOT_PATH . '/templates/public/footer.php'; ?>
