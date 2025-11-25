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
                <p><strong><?php echo __('email_label'); ?>:</strong> info@doorhan.com</p>
            </div>
        </div>
    </div>
</section>

<?php require_once ROOT_PATH . '/templates/public/footer.php'; ?>