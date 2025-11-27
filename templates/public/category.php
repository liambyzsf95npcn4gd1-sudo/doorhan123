<?php include 'header.php'; ?>

<div class="container">
    <h1><?php echo htmlspecialchars($category['name']); ?></h1>
    <p><?php echo htmlspecialchars($category['description'] ?? ''); ?></p>

    <?php if (!empty($products)): ?>
        <h2><?php echo __('products_in_category'); ?></h2>
        <div class="product-grid">
            <?php foreach ($products as $product): ?>
                <div class="card product-card">
                    <a href="<?php echo url('/products/' . htmlspecialchars($product['slug'])); ?>">
                        <img src="<?php echo SITE_URL; ?>/assets/img/products/<?php echo htmlspecialchars($product['image'] ?? 'product-placeholder.jpg'); ?>" alt="<?php echo htmlspecialchars($product['name']); ?>">
                        <h3><?php echo htmlspecialchars($product['name']); ?></h3>
                    </a>
                    <p><?php echo htmlspecialchars(substr(strip_tags($product['content']), 0, 100)); ?>...</p>
                    <a href="<?php echo url('/products/' . htmlspecialchars($product['slug'])); ?>" class="btn btn-secondary"><?php echo __('view_details'); ?></a>
                </div>
            <?php endforeach; ?>
        </div>
    <?php endif; ?>
</div>

<?php include 'footer.php'; ?>
