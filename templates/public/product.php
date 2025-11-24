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
                    <a href="#quote-form" class="btn btn-primary"><?php echo __('Request a Quote'); ?></a>
                <?php else: ?>
                    <h1><?php echo __('product_not_found_title'); ?></h1>
                    <p><?php echo __('product_not_found_desc'); ?></p>
                <?php endif; ?>
            </div>
        </div>

        <div class="product-tabs">
            <ul class="nav nav-tabs">
                <li class="active"><a data-toggle="tab" href="#specifications"><?php echo __('specifications_tab'); ?></a></li>
            </ul>
            <div class="tab-content">
                <div id="specifications" class="tab-pane active">
                    <h3><?php echo __('Technical Specifications'); ?></h3>
                    <table class="spec-table">
                        <tr>
                            <td><?php echo __('Max Width'); ?></td>
                            <td><?php echo htmlspecialchars($product['max_width'] ?? 'N/A'); ?></td>
                        </tr>
                        <tr>
                            <td><?php echo __('Max Height'); ?></td>
                            <td><?php echo htmlspecialchars($product['max_height'] ?? 'N/A'); ?></td>
                        </tr>
                        <tr>
                            <td><?php echo __('Panel Thickness'); ?></td>
                            <td><?php echo htmlspecialchars($product['panel_thickness'] ?? 'N/A'); ?></td>
                        </tr>
                        <tr>
                            <td><?php echo __('Insulation'); ?></td>
                            <td><?php echo htmlspecialchars($product['insulation'] ?? 'N/A'); ?></td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>

        <div id="quote-form" class="quote-form-section section-padding">
            <h2 class="text-center"><?php echo __('Request a Quote'); ?></h2>
            <form class="quote-form">
                <input type="text" name="name" placeholder="<?php echo __('name_placeholder'); ?>" required>
                <input type="email" name="email" placeholder="<?php echo __('email_placeholder'); ?>" required>
                <textarea name="message" placeholder="<?php echo __('message_placeholder'); ?>" required></textarea>
                <button type="submit" class="btn btn-primary"><?php echo __('send_request_btn'); ?></button>
            </form>
        </div>
    </div>
</section>

<?php require_once ROOT_PATH . '/templates/public/footer.php'; ?>