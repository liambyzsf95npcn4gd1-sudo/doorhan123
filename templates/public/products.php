<?php require_once ROOT_PATH . '/templates/public/header.php'; ?>

<section class="page-header">
    <div class="container">
        <h1><?php echo __('our_products_title'); ?></h1>
    </div>
</section>

<section class="products-page-section section-padding">
    <div class="container">
        <div class="product-grid">
            <?php if (!empty($categories)): ?>
                <?php foreach ($categories as $category): ?>
                    <div class="card product-card category-card">
                        <a href="<?php echo url('/products/category/' . htmlspecialchars($category['slug'])); ?>">
                            <img src="<?php echo SITE_URL; ?>/assets/img/<?php echo htmlspecialchars($category['image'] ?? 'category-placeholder.jpg'); ?>" alt="<?php echo htmlspecialchars($category['name']); ?>">
                            <h3><?php echo htmlspecialchars($category['name']); ?></h3>
                        </a>
                        <p><?php echo htmlspecialchars($category['meta_description'] ?? ''); ?></p>
                        <a href="<?php echo url('/products/category/' . htmlspecialchars($category['slug'])); ?>" class="btn btn-secondary"><?php echo __('view_more'); ?></a>
                    </div>
                <?php endforeach; ?>
            <?php else: ?>
                <p><?php echo __('no_categories'); ?></p>
            <?php endif; ?>
        </div>
    </div>
</section>

<?php require_once ROOT_PATH . '/templates/public/footer.php'; ?>
