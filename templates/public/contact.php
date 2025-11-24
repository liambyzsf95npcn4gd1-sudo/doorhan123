<?php require_once ROOT_PATH . '/templates/public/header.php'; ?>

<section class="page-header">
    <div class="container">
        <h1><?php echo __('contact_us_title'); ?></h1>
    </div>
</section>

<section class="contact-page-section section-padding">
    <div class="container">
        <div class="contact-layout">
            <div class="contact-form">
                <h2><?php echo __('send_message_title'); ?></h2>
                <form action="<?php echo url('/contact'); ?>" method="post">
                    <input type="hidden" name="csrf_token" value="<?php echo htmlspecialchars($csrf_token); ?>">
                    <input type="text" name="name" placeholder="<?php echo __('name_placeholder'); ?>" required>
                    <input type="email" name="email" placeholder="<?php echo __('email_placeholder'); ?>" required>
                    <input type="tel" name="phone" placeholder="<?php echo __('phone_placeholder'); ?>">
                    <textarea name="message" placeholder="<?php echo __('message_placeholder'); ?>" required></textarea>
                    <button type="submit" class="btn btn-primary"><?php echo __('send_btn'); ?></button>
                </form>
            </div>
            <div class="contact-info">
                <h2><?php echo __('contact_info_title'); ?></h2>
                <p><strong><?php echo __('address_label'); ?>:</strong> <?php echo __('address_value'); ?></p>
                <p><strong><?php echo __('phone_label'); ?>:</strong> +1-800-DOORHAN</p>
                <p><strong><?php echo __('email_label'); ?>:</strong> info@doorhan.com</p>
                <div class="map-embed">
                    <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3153.225224826131!2d-122.4194154846816!3d37.77492927975871!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x8085808c7c1a80e3%3A0x4a4b2b93479f642a!2sSan%20Francisco%2C%20CA%2C%20USA!5e0!3m2!1sen!2s!4v1620000000000!5m2!1sen!2s" width="100%" height="300" style="border:0;" allowfullscreen="" loading="lazy"></iframe>
                </div>
            </div>
        </div>
    </div>
</section>

<?php require_once ROOT_PATH . '/templates/public/footer.php'; ?>