<h1>Настройки сайта</h1>

<form action="<?php echo SITE_URL; ?>/admin/settings" method="post">
    <input type="hidden" name="csrf_token" value="<?php echo htmlspecialchars($csrf_token, ENT_QUOTES, 'UTF-8'); ?>">
    <div>
        <label for="site_title">Название сайта</label>
        <input type="text" name="site_title" id="site_title" value="<?php echo htmlspecialchars($settings['site_title'] ?? '', ENT_QUOTES, 'UTF-8'); ?>" required>
    </div>
    <div>
        <label for="contact_email">Email для контактов</label>
        <input type="email" name="contact_email" id="contact_email" value="<?php echo htmlspecialchars($settings['contact_email'] ?? '', ENT_QUOTES, 'UTF-8'); ?>" required>
    </div>
    <button type="submit">Сохранить</button>
</form>