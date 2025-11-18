<?php require_once ROOT_PATH . '/templates/public/header.php'; ?>

<section class="hero-slider">
    <div class="swiper-container">
        <div class="swiper-wrapper">
            <div class="swiper-slide" style="background-image: url('<?php echo SITE_URL; ?>/assets/img/home/slide1.jpg');">
                <div class="container">
                    <div class="hero-content">
                        <h1>30+ Years of Quality Gates & Automation</h1>
                        <a href="<?php echo SITE_URL; ?>/products" class="btn btn-primary">Explore Products</a>
                    </div>
                </div>
            </div>
            <div class="swiper-slide" style="background-image: url('<?php echo SITE_URL; ?>/assets/img/home/slide2.jpg');">
                <div class="container">
                    <div class="hero-content">
                        <h1>Innovative Solutions for Every Need</h1>
                        <a href="<?php echo SITE_URL; ?>/products" class="btn btn-primary">Discover Our Range</a>
                    </div>
                </div>
            </div>
            <div class="swiper-slide" style="background-image: url('<?php echo SITE_URL; ?>/assets/img/home/slide3.jpg');">
                <div class="container">
                    <div class="hero-content">
                        <h1>Global Leader in Doors and Automation</h1>
                        <a href="<?php echo SITE_URL; ?>/contact" class="btn btn-primary">Contact Us</a>
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
        <h2 class="text-center">About Us</h2>
        <div class="grid-3-col">
            <div class="card text-center">
                <img src="<?php echo SITE_URL; ?>/assets/img/quality.svg" alt="Quality Icon" class="card-icon">
                <h3>Quality</h3>
                <p>We are committed to providing the highest quality products, ensuring durability and reliability for all our customers.</p>
            </div>
            <div class="card text-center">
                <img src="<?php echo SITE_URL; ?>/assets/img/innovation.svg" alt="Innovation Icon" class="card-icon">
                <h3>Innovation</h3>
                <p>Our team is constantly developing new and innovative solutions to meet the evolving needs of the market.</p>
            </div>
            <div class="card text-center">
                <img src="<?php echo SITE_URL; ?>/assets/img/global-network.svg" alt="Global Network Icon" class="card-icon">
                <h3>Global Network</h3>
                <p>With a presence in over 30 countries, our global network ensures that we can serve customers worldwide.</p>
            </div>
        </div>
    </div>
</section>

<section class="websites-section section-padding bg-light">
    <div class="container">
        <h2 class="text-center">Go to following websites to make a purchase</h2>
        <div class="grid-3-col">
            <div class="card">
                <img src="<?php echo SITE_URL; ?>/assets/img/cz.png" alt="Czech Republic Flag">
                <h3>Czech Republic</h3>
                <ul>
                    <li>Sectional doors</li>
                    <li>Roller shutters</li>
                </ul>
                <a href="https://doorhan.cz" class="btn btn-primary" target="_blank">Go to website</a>
            </div>
            <div class="card">
                <img src="<?php echo SITE_URL; ?>/assets/img/cn.png" alt="China Flag">
                <h3>China</h3>
                <ul>
                    <li>Industrial doors</li>
                    <li>Sliding gates</li>
                </ul>
                <a href="https://doorhan.cn" class="btn btn-primary" target="_blank">Go to website</a>
            </div>
            <div class="card">
                <img src="<?php echo SITE_URL; ?>/assets/img/ae.png" alt="UAE Flag">
                <h3>UAE</h3>
                <ul>
                    <li>Garage doors</li>
                    <li>Automation</li>
                </ul>
                <a href="https://doorhan.ae" class="btn btn-primary" target="_blank">Go to website</a>
            </div>
        </div>
    </div>
</section>

<section class="featured-products-section section-padding">
    <div class="container">
        <h2 class="text-center">Featured Products</h2>
        <div class="grid-4-col">
            
            <?php if (!empty($featured_products)): ?>
                <?php foreach ($featured_products as $product): ?>
                    <div class="card product-card">
                        <a href="<?php echo SITE_URL; ?>/products/<?php echo htmlspecialchars($product['slug']); ?>">
                            <img src="<?php echo SITE_URL; ?>/assets/img/<?php echo htmlspecialchars($product['image'] ?? 'product-placeholder.jpg'); ?>" alt="<?php echo htmlspecialchars($product['name']); ?>">
                            <h3><?php echo htmlspecialchars($product['name']); ?></h3>
                        </a>
                        <p><?php echo htmlspecialchars(substr(strip_tags($product['content'] ?? ''), 0, 100)); ?>...</p>
                        <a href="<?php echo SITE_URL; ?>/products/<?php echo htmlspecialchars($product['slug']); ?>" class="btn btn-secondary">Learn More</a>
                    </div>
                <?php endforeach; ?>
            <?php else: ?>
                <p class="text-center" style="grid-column: 1 / -1;">No featured products available at this time.</p>
            <?php endif; ?>

        </div>
    </div>
</section>

<section class="news-section section-padding">
    <div class="container">
        <h2 class="text-center">Latest News</h2>
        
        <div class="grid-3-col news-carousel">
            
            <?php if (!empty($latest_posts)): ?>
                <?php foreach ($latest_posts as $post): ?>
                    <div class="card">
                        <a href="<?php echo SITE_URL; ?>/news/<?php echo htmlspecialchars($post['slug']); ?>">
                            <img src="<?php echo SITE_URL; ?>/assets/img/<?php echo htmlspecialchars($post['image'] ?? 'news-placeholder.jpg'); ?>" alt="<?php echo htmlspecialchars($post['title']); ?>">
                        </a>
                        <h3><?php echo htmlspecialchars($post['title']); ?></h3>
                        <p><?php echo htmlspecialchars(substr(strip_tags($post['content'] ?? ''), 0, 100)); ?>...</p>
                        <a href="<?php echo SITE_URL; ?>/news/<?php echo htmlspecialchars($post['slug']); ?>">Read More</a>
                    </div>
                <?php endforeach; ?>
            <?php else: ?>
                 <p class="text-center" style="grid-column: 1 / -1;">No recent news available.</p>
            <?php endif; ?>

        </div>
    </div>
</section>

<section class="questions-section section-padding bg-light">
    <div class="container">
        <h2 class="text-center">Frequently Asked Questions</h2>
        <div class="accordion">
            <div class="accordion-item">
                <button class="accordion-header">What types of doors do you offer?</button>
                <div class="accordion-content">
                    <p>We offer a wide range of doors, including sectional doors, roller shutters, sliding gates, industrial doors, and garage doors. We also provide automation solutions for all our products.</p>
                </div>
            </div>
            <div class="accordion-item">
                <button class="accordion-header">Do you provide installation services?</button>
                <div class="accordion-content">
                    <p>Yes, we have a network of certified dealers who can provide professional installation services. Contact us to find a dealer near you.</p>
                </div>
            </div>
            <div class="accordion-item">
                <button class="accordion-header">What is the warranty on your products?</button>
                <div class="accordion-content">
                    <p>All our products come with a standard warranty. The warranty period varies depending on the product. Please contact us for more details.</p>
                </div>
            </div>
            <div class="accordion-item">
                <button class="accordion-header">How can I get a quote?</button>
                <div class="accordion-content">
                    <p>You can request a quote by contacting us through our website or by calling our sales team. We are always ready to help you with your queries.</p>
                </div>
            </div>
            <div class="accordion-item">
                <button class="accordion-header">Are your products certified?</button>
                <div class="accordion-content">
                    <p>Yes, all our products are certified and comply with international quality standards. We are committed to providing our customers with safe and reliable products.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<section class="factories-section section-padding">
    <div class="container">
        <h2 class="text-center">Our Factories</h2>
        <div class="grid-3-col">
            <div class="card text-center">
                <img src="<?php echo SITE_URL; ?>/assets/img/dubai.jpg" alt="Dubai Factory" class="factory-img">
                <h3>Dubai</h3>
                <p>Our state-of-the-art factory in Dubai produces a wide range of products for the Middle East and Africa.</p>
            </div>
            <div class="card text-center">
                <img src="<?php echo SITE_URL; ?>/assets/img/czech.jpg" alt="Czech Factory" class="factory-img">
                <h3>Czech Republic</h3>
                <p>Our factory in the Czech Republic is a key hub for our European operations, producing high-quality doors and components.</p>
            </div>
            <div class="card text-center">
                <img src="<?php echo SITE_URL; ?>/assets/img/china.jpg" alt="China Factory" class="factory-img">
                <h3>China</h3>
                <p>Our factory in China is a major production center, manufacturing a wide range of products for the Asian market.</p>
            </div>
        </div>
    </div>
</section>

<?php require_once ROOT_PATH . '/templates/public/footer.php'; ?>