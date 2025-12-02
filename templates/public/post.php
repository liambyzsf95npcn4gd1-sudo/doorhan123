<?php require_once ROOT_PATH . '/templates/public/header.php'; ?>

<section class="post-page-section section-padding">
    <div class="container">
        <div class="post-layout">
            <article class="post-content">
                <?php if (!empty($post)): ?>
                    <h1><?php echo htmlspecialchars($post['title']); ?></h1>
                    <span class="post-date"><?php echo date('F j, Y', strtotime($post['created_at'])); ?></span>
                    <?php if (!empty($post['image'])): ?>
                    <img src="<?php echo SITE_URL . UPLOADS_DIR . htmlspecialchars($post['image']); ?>" alt="<?php echo htmlspecialchars($post['title']); ?>" class="post-image">
                    <?php else: ?>
                    <img src="<?php echo SITE_URL; ?>/assets/img/news-placeholder.jpg" alt="<?php echo htmlspecialchars($post['title']); ?>" class="post-image">
                    <?php endif; ?>
                    <?php if (!empty($post['image2'])): ?>
                    <img src="<?php echo SITE_URL . UPLOADS_DIR . htmlspecialchars($post['image2']); ?>" alt="<?php echo htmlspecialchars($post['title']); ?>" class="post-image">
                    <?php endif; ?>
                    <?php if (!empty($post['image3'])): ?>
                    <img src="<?php echo SITE_URL . UPLOADS_DIR . htmlspecialchars($post['image3']); ?>" alt="<?php echo htmlspecialchars($post['title']); ?>" class="post-image">
                    <?php endif; ?>
                    <div class="post-body">
                        <?php echo $post['content']; // HTML content from database ?>
                    </div>
                <?php else: ?>
                    <h1><?php echo __('post_not_found_title'); ?></h1>
                    <p><?php echo __('post_not_found_desc'); ?></p>
                <?php endif; ?>
            </article>
        </div>
    </div>
</section>

<?php require_once ROOT_PATH . '/templates/public/footer.php'; ?>