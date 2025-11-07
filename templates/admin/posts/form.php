<h1><?php echo isset($post) ? 'Редактировать новость' : 'Создать новость'; ?></h1>

<form method="post">
    <input type="hidden" name="csrf_token" value="<?php echo htmlspecialchars($csrf_token, ENT_QUOTES, 'UTF-8'); ?>">
    <div>
        <label for="title">Заголовок</label>
        <input type="text" name="title" id="title" value="<?php echo htmlspecialchars($post['title'] ?? '', ENT_QUOTES, 'UTF-8'); ?>" required>
    </div>
    <div>
        <label for="slug">Slug</label>
        <input type="text" name="slug" id="slug" value="<?php echo htmlspecialchars($post['slug'] ?? '', ENT_QUOTES, 'UTF-8'); ?>" required>
    </div>
    <div>
        <label for="content">Содержимое</label>
        <textarea name="content" id="content"><?php echo htmlspecialchars($post['content'] ?? '', ENT_QUOTES, 'UTF-8'); ?></textarea>
    </div>
    <div>
        <label for="status">Статус</label>
        <select name="status" id="status">
            <option value="draft" <?php echo (isset($post) && $post['status'] == 'draft') ? 'selected' : ''; ?>>Черновик</option>
            <option value="published" <?php echo (isset($post) && $post['status'] == 'published') ? 'selected' : ''; ?>>Опубликовано</option>
        </select>
    </div>
    <div>
        <label for="seo_title">SEO Title</label>
        <input type="text" name="seo_title" id="seo_title" value="<?php echo htmlspecialchars($post['seo_title'] ?? '', ENT_QUOTES, 'UTF-8'); ?>">
    </div>
    <div>
        <label for="meta_description">Meta Description</label>
        <input type="text" name="meta_description" id="meta_description" value="<?php echo htmlspecialchars($post['meta_description'] ?? '', ENT_QUOTES, 'UTF-8'); ?>">
    </div>
    <button type="submit">Сохранить</button>
</form>
