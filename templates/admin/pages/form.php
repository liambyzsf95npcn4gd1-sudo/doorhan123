<h1><?php echo isset($page) ? 'Редактировать страницу' : 'Создать страницу'; ?></h1>

<form method="post">
    <input type="hidden" name="csrf_token" value="<?php echo htmlspecialchars($csrf_token, ENT_QUOTES, 'UTF-8'); ?>">
    <div>
        <label for="title">Заголовок</label>
        <input type="text" name="title" id="title" value="<?php echo htmlspecialchars($page['title'] ?? '', ENT_QUOTES, 'UTF-8'); ?>" required>
    </div>
    <div>
        <label for="slug">Slug</label>
        <input type="text" name="slug" id="slug" value="<?php echo htmlspecialchars($page['slug'] ?? '', ENT_QUOTES, 'UTF-8'); ?>" required>
    </div>
    <div>
        <label for="content">Содержимое</label>
        <textarea name="content" id="content"><?php echo htmlspecialchars($page['content'] ?? '', ENT_QUOTES, 'UTF-8'); ?></textarea>
    </div>
    <div>
        <label for="seo_title">SEO Title</label>
        <input type="text" name="seo_title" id="seo_title" value="<?php echo htmlspecialchars($page['seo_title'] ?? '', ENT_QUOTES, 'UTF-8'); ?>">
    </div>
    <div>
        <label for="meta_description">Meta Description</label>
        <input type="text" name="meta_description" id="meta_description" value="<?php echo htmlspecialchars($page['meta_description'] ?? '', ENT_QUOTES, 'UTF-8'); ?>">
    </div>
    <button type="submit">Сохранить</button>
</form>
