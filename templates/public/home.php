<?php require_once ROOT_PATH . '/templates/public/header.php'; ?>

<section class="hero-slider">
    <div class="swiper-container">
        <div class="swiper-wrapper">
            <div class="swiper-slide" style="background-image: url('<?php echo SITE_URL; ?>/assets/img/home/slide1.jpg');">
                <div class="container">
                    <div class="hero-content">
                        <h1><?php echo __('hero_title_1'); ?></h1>
                        <a href="<?php echo url('/products'); ?>" class="btn btn-primary"><?php echo __('hero_btn_1'); ?></a>
                    </div>
                </div>
            </div>
            <div class="swiper-slide" style="background-image: url('<?php echo SITE_URL; ?>/assets/img/home/slide2.jpg');">
                <div class="container">
                    <div class="hero-content">
                        <h1><?php echo __('hero_title_2'); ?></h1>
                        <a href="<?php echo url('/products'); ?>" class="btn btn-primary"><?php echo __('hero_btn_2'); ?></a>
                    </div>
                </div>
            </div>
            <div class="swiper-slide" style="background-image: url('<?php echo SITE_URL; ?>/assets/img/home/slide3.jpg');">
                <div class="container">
                    <div class="hero-content">
                        <h1><?php echo __('hero_title_3'); ?></h1>
                        <a href="<?php echo url('/contact'); ?>" class="btn btn-primary"><?php echo __('hero_btn_3'); ?></a>
                    </div>
                </div>
            </div>
        </div>
        <div class="swiper-pagination"></div>
        <div class="swiper-button-next"></div>
        <div class="swiper-button-prev"></div>
    </div>
</section>

<section class="about-us-section section-padding">
    <div class="container">
        <h2 class="text-center"><?php echo __('about_us_title'); ?></h2>
        <div class="grid-3-col">
            <div class="card text-center">
                <img src="<?php echo SITE_URL; ?>/assets/img/quality.svg" alt="Quality Icon" class="card-icon">
                <h3><?php echo __('quality_title'); ?></h3>
                <p><?php echo __('quality_desc'); ?></p>
            </div>
            <div class="card text-center">
                <img src="<?php echo SITE_URL; ?>/assets/img/innovation.svg" alt="Innovation Icon" class="card-icon">
                <h3><?php echo __('innovation_title'); ?></h3>
                <p><?php echo __('innovation_desc'); ?></p>
            </div>
            <div class="card text-center">
                <img src="<?php echo SITE_URL; ?>/assets/img/global-network.svg" alt="Global Network Icon" class="card-icon">
                <h3><?php echo __('global_network_title'); ?></h3>
                <p><?php echo __('global_network_desc'); ?></p>
            </div>
        </div>
    </div>
</section>

<section class="websites-section section-padding bg-light">
    <div class="container">
        <h2 class="text-center"><?php echo __('websites_title'); ?></h2>
        <div class="grid-3-col">
            <div class="card">
                <img src="<?php echo SITE_URL; ?>/assets/img/cz.png" alt="Czech Republic Flag">
                <h3><?php echo __('cz_title'); ?></h3>
                <ul>
                    <li><?php echo __('cz_item_1'); ?></li>
                    <li><?php echo __('cz_item_2'); ?></li>
                </ul>
                <a href="<?php echo $websites['cz']; ?>" class="btn btn-primary websites-section-btn" target="_blank"><?php echo __('go_to_website'); ?></a>
            </div>
            <div class="card">
                <img src="<?php echo SITE_URL; ?>/assets/img/cn.png" alt="China Flag">
                <h3><?php echo __('cn_title'); ?></h3>
                <ul>
                    <li><?php echo __('cn_item_1'); ?></li>
                    <li><?php echo __('cn_item_2'); ?></li>
                </ul>
                <a href="<?php echo $websites['cn']; ?>" class="btn btn-primary websites-section-btn" target="_blank"><?php echo __('go_to_website'); ?></a>
            </div>
            <div class="card">
                <img src="<?php echo SITE_URL; ?>/assets/img/ae.png" alt="UAE Flag">
                <h3><?php echo __('ae_title'); ?></h3>
                <ul>
                    <li><?php echo __('ae_item_1'); ?></li>
                    <li><?php echo __('ae_item_2'); ?></li>
                </ul>
                <a href="<?php echo $websites['ae']; ?>" class="btn btn-primary websites-section-btn" target="_blank"><?php echo __('go_to_website'); ?></a>
            </div>
        </div>
    </div>
</section>

<section class="featured-products-section section-padding">
    <div class="container">
        <h2 class="text-center"><?php echo __('featured_products_title'); ?></h2>
        <div class="grid-4-col">
            
            <?php if (!empty($featured_products)): ?>
                <?php foreach ($featured_products as $product): ?>
                    <div class="card product-card">
                        <a href="<?php echo url('/products/' . htmlspecialchars($product['slug'])); ?>">
                            <img src="<?php echo SITE_URL; ?>/assets/img/products/<?php echo htmlspecialchars($product['image'] ?? 'product-placeholder.jpg'); ?>" alt="<?php echo htmlspecialchars($product['name']); ?>">
                            <h3><?php echo htmlspecialchars($product['name']); ?></h3>
                        </a>
                        <p><?php echo htmlspecialchars(substr(strip_tags($product['content'] ?? ''), 0, 100)); ?>...</p>
                        <a href="<?php echo url('/products/' . htmlspecialchars($product['slug'])); ?>" class="btn btn-secondary"><?php echo __('Learn More'); ?></a>
                    </div>
                <?php endforeach; ?>
            <?php else: ?>
                <p class="text-center" style="grid-column: 1 / -1;"><?php echo __('no_featured_products'); ?></p>
            <?php endif; ?>

        </div>
    </div>
</section>

<section class="news-section section-padding">
    <div class="container">
        <h2 class="text-center"><?php echo __('latest_news_title'); ?></h2>
        
        <div class="grid-3-col news-carousel">
            
            <?php if (!empty($latest_posts)): ?>
                <?php foreach ($latest_posts as $post): ?>
                    <div class="card">
                        <a href="<?php echo url('/news/' . htmlspecialchars($post['slug'])); ?>">
                            <img src="<?php echo !empty($post['image']) ? SITE_URL . UPLOADS_DIR . htmlspecialchars($post['image']) : SITE_URL . '/assets/img/news-placeholder.jpg'; ?>" alt="<?php echo htmlspecialchars($post['title']); ?>">
                        </a>
                        <h3><?php echo htmlspecialchars($post['title']); ?></h3>
                        <p><?php echo htmlspecialchars(substr(strip_tags($post['content'] ?? ''), 0, 100)); ?>...</p>
                        <a href="<?php echo url('/news/' . htmlspecialchars($post['slug'])); ?>"><?php echo __('Read More'); ?></a>
                    </div>
                <?php endforeach; ?>
            <?php else: ?>
                 <p class="text-center" style="grid-column: 1 / -1;"><?php echo __('no_news'); ?></p>
            <?php endif; ?>

        </div>
    </div>
</section>

<section class="questions-section section-padding bg-light">
    <div class="container">
        <h2 class="text-center"><?php echo __('faq_title'); ?></h2>
        <div class="accordion">
            <div class="accordion-item">
                <button class="accordion-header"><?php echo __('faq_q_1'); ?></button>
                <div class="accordion-content">
                    <p><?php echo __('faq_a_1'); ?></p>
                </div>
            </div>
            <div class="accordion-item">
                <button class="accordion-header"><?php echo __('faq_q_2'); ?></button>
                <div class="accordion-content">
                    <p><?php echo __('faq_a_2'); ?></p>
                </div>
            </div>
            <div class="accordion-item">
                <button class="accordion-header"><?php echo __('faq_q_3'); ?></button>
                <div class="accordion-content">
                    <p><?php echo __('faq_a_3'); ?></p>
                </div>
            </div>
            <div class="accordion-item">
                <button class="accordion-header"><?php echo __('faq_q_4'); ?></button>
                <div class="accordion-content">
                    <p><?php echo __('faq_a_4'); ?></p>
                </div>
            </div>
            <div class="accordion-item">
                <button class="accordion-header"><?php echo __('faq_q_5'); ?></button>
                <div class="accordion-content">
                    <p><?php echo __('faq_a_5'); ?></p>
                </div>
            </div>
        </div>
    </div>
</section>

<section class="factories-section section-padding">
    <div class="container">
        <h2 class="text-center"><?php echo __('factories_title'); ?></h2>
        <div class="grid-3-col">
            <div class="card text-center">
                <img src="<?php echo SITE_URL; ?>/assets/img/dubai.jpg" alt="Dubai Factory" class="factory-img">
                <h3><?php echo __('dubai_title'); ?></h3>
                <p><?php echo __('dubai_desc'); ?></p>
            </div>
            <div class="card text-center">
                <img src="<?php echo SITE_URL; ?>/assets/img/czech.jpg" alt="Czech Factory" class="factory-img">
                <h3><?php echo __('czech_title'); ?></h3>
                <p><?php echo __('czech_desc'); ?></p>
            </div>
            <div class="card text-center">
                <img src="<?php echo SITE_URL; ?>/assets/img/china.jpg" alt="China Factory" class="factory-img">
                <h3><?php echo __('china_title'); ?></h3>
                <p><?php echo __('china_desc'); ?></p>
            </div>
        </div>
    </div>
</section>

<?php require_once ROOT_PATH . '/templates/public/footer.php'; ?>
