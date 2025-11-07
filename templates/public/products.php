<?php require_once ROOT_PATH . '/templates/public/header.php'; ?>

<section class="page-header">
    <div class="container">
        <h1>Our Products</h1>
    </div>
</section>

<section class="products-page-section section-padding">
    <div class="container">
        <div class="products-layout">
            <aside class="sidebar">
                <h3>Categories</h3>
                <ul class="category-list">
                    <li><a href="#">Sectional Doors</a></li>
                    <li><a href="#">Roller Shutters</a></li>
                    <li><a href="#">Sliding Gates</a></li>
                    <li><a href="#">Industrial Doors</a></li>
                    <li><a href="#">Garage Doors</a></li>
                    <li><a href="#">Automation</a></li>
                </ul>
            </aside>
            <main class="product-grid">
                <?php if (!empty($products)): ?>
                    <?php foreach ($products as $product): ?>
                        <div class="card product-card">
                            <a href="<?php echo SITE_URL; ?>/products/<?php echo htmlspecialchars($product['slug']); ?>">
                                <img src="<?php echo SITE_URL; ?>/assets/img/<?php echo htmlspecialchars($product['image'] ?? 'product-placeholder.jpg'); ?>" alt="<?php echo htmlspecialchars($product['name']); ?>">
                                <h3><?php echo htmlspecialchars($product['name']); ?></h3>
                            </a>
                            
                            <p><?php echo htmlspecialchars(substr(strip_tags($product['content']), 0, 100)); ?>...</p>
                            
                            <a href="<?php echo SITE_URL; ?>/products/<?php echo htmlspecialchars($product['slug']); ?>" class="btn btn-secondary">View Details</a>
                        </div>
                    <?php endforeach; ?>
                <?php else: ?>
                    <p>No products found.</p>
                <?php endif; ?>
            </main>
        </div>

        <?php if ($totalPages > 1): ?>
        <div class="pagination">
            <?php if ($currentPage > 1): ?>
                <a href="<?php echo SITE_URL; ?>/products?page=<?php echo $currentPage - 1; ?>" class="btn">&laquo; Previous</a>
            <?php endif; ?>

            <?php for ($i = 1; $i <= $totalPages; $i++): ?>
                <a href="<?php echo SITE_URL; ?>/products?page=<?php echo $i; ?>" class="btn <?php echo $i == $currentPage ? 'active' : ''; ?>"><?php echo $i; ?></a>
            <?php endfor; ?>

            <?php if ($currentPage < $totalPages): ?>
                <a href="<?php echo SITE_URL; ?>/products?page=<?php echo $currentPage + 1; ?>" class="btn">Next &raquo;</a>
            <?php endif; ?>
        </div>
        <?php endif; ?>
        </div>
    </div>
</section

<?php require_once ROOT_PATH . '/templates/public/footer.php'; ?>