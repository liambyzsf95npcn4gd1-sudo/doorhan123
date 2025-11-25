<?php require_once ROOT_PATH . '/templates/public/header.php'; ?>

<section class="post-page-section section-padding">
    <div class="container">
        <div class="post-layout">
            <article class="post-content">
                <?php if (!empty($post)): ?>
                    <h1><?php echo htmlspecialchars($post['title']); ?></h1>
                    <span class="post-date"><?php echo date('F j, Y', strtotime($post['created_at'])); ?></span>
                    <?php if (!empty($post['image'])): ?>
                    <img src="<?php echo SITE_URL; ?>/assets/img/news/<?php echo htmlspecialchars($post['image']); ?>" alt="<?php echo htmlspecialchars($post['title']); ?>" class="post-image">
                    <?php endif; ?>
                    <?php if (!empty($post['image2'])): ?>
                    <img src="<?php echo SITE_URL; ?>/assets/img/news/<?php echo htmlspecialchars($post['image2']); ?>" alt="<?php echo htmlspecialchars($post['title']); ?>" class="post-image">
                    <?php endif; ?>
                    <?php if (!empty($post['image3'])): ?>
                    <img src="<?php echo SITE_URL; ?>/assets/img/news/<?php echo htmlspecialchars($post['image3']); ?>" alt="<?php echo htmlspecialchars($post['title']); ?>" class="post-image">
                    <?php endif; ?>
                    <div class="post-body">
                        <?php echo $post['content']; // HTML content from database ?>
                    </div>
                <?php else: ?>
                    <h1><?php echo __('post_not_found_title'); ?></h1>
                    <p><?php echo __('post_not_found_desc'); ?></p>
                <?php endif; ?>
            </article>
            <aside class="sidebar">
                <h3><?php echo __('related_posts_title'); ?></h3>
                <ul class="related-posts-list">
                    <li>
                        <a href="<?php echo url('/news/news-title-2'); ?>">
                            <img src="<?php echo SITE_URL; ?>/assets/img/news2.jpg" alt="News 2">
                            <span>News Title 2</span>
                        </a>
                    </li>
                    <li>
                        <a href="<?php echo url('/news/news-title-3'); ?>">
                            <img src="<?php echo SITE_URL; ?>/assets/img/news3.jpg" alt="News 3">
                            <span>News Title 3</span>
                        </a>
                    </li>
                    <li>
                        <a href="<?php echo url('/news/news-title-4'); ?>">
                            <img src="<?php echo SITE_URL; ?>/assets/img/news4.jpg" alt="News 4">
                            <span>News Title 4</span>
                        </a>
                    </li>
                </ul>
            </aside>
        </div>
    </div>
</section>

<?php require_once ROOT_PATH . '/templates/public/footer.php'; ?>