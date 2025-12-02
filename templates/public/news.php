<?php require_once ROOT_PATH . '/templates/public/header.php'; ?>

<section class="page-header">
    <div class="container">
        <h1><?php echo __('News'); ?></h1>
    </div>
</section>

<section class="news-page-section section-padding">
    <div class="container">
        <div class="news-grid">
            <?php if (!empty($posts)): ?>
                <?php foreach ($posts as $post): ?>
                    <div class="card news-card">
                        <a href="<?php echo url('/news/' . htmlspecialchars($post['slug'])); ?>">
<<<<<<< Updated upstream
                            <img src="<?php echo SITE_URL; ?>/uploads/<?php echo htmlspecialchars($post['image'] ?? 'news-placeholder.jpg'); ?>" alt="<?php echo htmlspecialchars($post['title']); ?>">
=======
                            <img src="<?php echo !empty($post['image']) ? SITE_URL . UPLOADS_DIR . htmlspecialchars($post['image']) : SITE_URL . '/assets/img/news-placeholder.jpg'; ?>" alt="<?php echo htmlspecialchars($post['title']); ?>">
>>>>>>> Stashed changes
                        </a>
                        <div class="news-card-content">
                            <span class="news-date"><?php echo date('F j, Y', strtotime($post['created_at'])); ?></span>
                            <h3><a href="<?php echo url('/news/' . htmlspecialchars($post['slug'])); ?>"><?php echo htmlspecialchars($post['title']); ?></a></h3>
                            
                            <p><?php echo htmlspecialchars(substr(strip_tags($post['content']), 0, 150)); ?>...</p>
                            
                            <a href="<?php echo url('/news/' . htmlspecialchars($post['slug'])); ?>" class="btn btn-secondary"><?php echo __('Read More'); ?></a>
                        </div>
                    </div>
                <?php endforeach; ?>
            <?php else: ?>
                <p><?php echo __('no_news_posts'); ?></p>
            <?php endif; ?>
        </div>

        <?php if ($totalPages > 1): ?>
        <div class="pagination">
            <?php if ($currentPage > 1): ?>
                <a href="<?php echo url('/news?page=' . ($currentPage - 1)); ?>" class="btn">&laquo; <?php echo __('previous_btn'); ?></a>
            <?php endif; ?>

            <?php for ($i = 1; $i <= $totalPages; $i++): ?>
                <a href="<?php echo url('/news?page=' . $i); ?>" class="btn <?php echo $i == $currentPage ? 'active' : ''; ?>"><?php echo $i; ?></a>
            <?php endfor; ?>

            <?php if ($currentPage < $totalPages): ?>
                <a href="<?php echo url('/news?page=' . ($currentPage + 1)); ?>" class="btn"><?php echo __('next_btn'); ?> &raquo;</a>
            <?php endif; ?>
        </div>
        <?php endif; ?>
    </div>
</section>

<?php require_once ROOT_PATH . '/templates/public/footer.php'; ?>