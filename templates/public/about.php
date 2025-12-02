<?php require_once ROOT_PATH . '/templates/public/header.php'; ?>

<section class="page-header">
    <div class="container">
        <h1><?php echo htmlspecialchars($page['title'] ?? __('About Us')); ?></h1>
    </div>
</section>

<section class="about-page-section section-padding">
    <div class="container">
        <div class="about-page-content">
<<<<<<< Updated upstream
            <?php if (!empty($page['image'])): ?>
                <img src="<?php echo SITE_URL; ?>/uploads/<?php echo htmlspecialchars($page['image']); ?>" alt="<?php echo htmlspecialchars($page['title']); ?>" class="about-page-image">
            <?php endif; ?>
            <div class="about-page-text">
                <?php echo $page['content'] ?? '<p>' . __('about_us_placeholder') . '</p>'; ?>
            </div>
=======
            <p>The DoorHan International Concern is an industrial group of deeply integrated manufacturing enterprises whose common goal is the integrated supply of complete solutions for industrial construction, private housing, as well as urban infrastructure and agriculture. All the proposed solutions consist entirely of DoorHan products, in addition, they are designed and manufactured in DoorHan's own factories.</p>
>>>>>>> Stashed changes
        </div>
    </div>
</section>

<?php require_once ROOT_PATH . '/templates/public/footer.php'; ?>
