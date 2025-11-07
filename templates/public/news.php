<?php require_once ROOT_PATH . '/templates/public/header.php'; ?>

<section class="page-header">
    <div class="container">
        <h1>News</h1>
    </div>
</section>

<section class="news-page-section section-padding">
    <div class="container">
        <div class="news-grid">
            <?php if (!empty($posts)): ?>
                <?php foreach ($posts as $post): ?>
                    <div class="card news-card">
                        <a href="<?php echo SITE_URL; ?>/news/<?php echo htmlspecialchars($post['slug']); ?>">
                            <img src="<?php echo SITE_URL; ?>/assets/img/<?php echo htmlspecialchars($post['image'] ?? 'news-placeholder.jpg'); ?>" alt="<?php echo htmlspecialchars($post['title']); ?>">
                        </a>
                        <div class="news-card-content">
                            <span class="news-date"><?php echo date('F j, Y', strtotime($post['created_at'])); ?></span>
                            <h3><a href="<?php echo SITE_URL; ?>/news/<?php echo htmlspecialchars($post['slug']); ?>"><?php echo htmlspecialchars($post['title']); ?></a></h3>
                            
                            <p><?php echo htmlspecialchars(substr(strip_tags($post['content']), 0, 150)); ?>...</p>
                            
                            <a href="<?php echo SITE_URL; ?>/news/<?php echo htmlspecialchars($post['slug']); ?>" class="btn btn-secondary">Read More</a>
                        </div>
                    </div>
                <?php endforeach; ?>
            <?php else: ?>
                <p>No news posts found.</p>
            <?php endif; ?>
        </div>

        <?php if ($totalPages > 1): ?>
        <div class="pagination">
            <?php if ($currentPage > 1): ?>
                <a href="<?php echo SITE_URL; ?>/news?page=<?php echo $currentPage - 1; ?>" class="btn">&laquo; Previous</a>
            <?php endif; ?>

            <?php for ($i = 1; $i <= $totalPages; $i++): ?>
                <a href="<?php echo SITE_URL; ?>/news?page=<?php echo $i; ?>" class="btn <?php echo $i == $currentPage ? 'active' : ''; ?>"><?php echo $i; ?></a>
            <?php endfor; ?>

            <?php if ($currentPage < $totalPages): ?>
                <a href="<?php echo SITE_URL; ?>/news?page=<?php echo $currentPage + 1; ?>" class="btn">Next &raquo;</a>
            <?php endif; ?>
        </div>
        <?php endif; ?>
    </div>
</section>

<?php require_once ROOT_PATH . '/templates/public/footer.php'; ?>