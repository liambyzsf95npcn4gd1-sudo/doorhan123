<?php require_once ROOT_PATH . '/templates/public/header.php'; ?>

<section class="product-detail-section section-padding">
    <div class="container">
        <div class="product-detail-layout">
            <div class="product-gallery">
                <div class="swiper-container gallery-slider">
                    <div class="swiper-wrapper">
                        <div class="swiper-slide"><img src="<?php echo SITE_URL; ?>/assets/img/product1.jpg" alt="Product 1"></div>
                        <div class="swiper-slide"><img src="<?php echo SITE_URL; ?>/assets/img/product1-2.jpg" alt="Product 1-2"></div>
                        <div class="swiper-slide"><img src="<?php echo SITE_URL; ?>/assets/img/product1-3.jpg" alt="Product 1-3"></div>
                    </div>
                    <div class="swiper-pagination"></div>
                    <div class="swiper-button-next"></div>
                    <div class="swiper-button-prev"></div>
                </div>
            </div>
            <div class="product-info">
                <?php if (!empty($product)): ?>
                    <h1><?php echo htmlspecialchars($product['name']); ?></h1>
                    <div class="product-description">
                        <?php echo $product['content']; // HTML content from database ?>
                    </div>
                    <a href="#quote-form" class="btn btn-primary">Request a Quote</a>
                <?php else: ?>
                    <h1>Product not found</h1>
                    <p>The product you are looking for does not exist.</p>
                <?php endif; ?>
            </div>
        </div>

        <div class="product-tabs">
            <ul class="nav nav-tabs">
                <li class="active"><a data-toggle="tab" href="#specifications">Specifications</a></li>
            </ul>
            <div class="tab-content">
                <div id="specifications" class="tab-pane active">
                    <h3>Technical Specifications</h3>
                    <table class="spec-table">
                        <tr>
                            <td>Max Width</td>
                            <td>6000 mm</td>
                        </tr>
                        <tr>
                            <td>Max Height</td>
                            <td>3000 mm</td>
                        </tr>
                        <tr>
                            <td>Panel Thickness</td>
                            <td>40 mm</td>
                        </tr>
                        <tr>
                            <td>Insulation</td>
                            <td>Polyurethane foam</td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>

        <div id="quote-form" class="quote-form-section section-padding">
            <h2 class="text-center">Request a Quote</h2>
            <form class="quote-form">
                <input type="text" name="name" placeholder="Your Name" required>
                <input type="email" name="email" placeholder="Your Email" required>
                <textarea name="message" placeholder="Your Message" required></textarea>
                <button type="submit" class="btn btn-primary">Send Request</button>
            </form>
        </div>
    </div>
</section>

<?php require_once ROOT_PATH . '/templates/public/footer.php'; ?>