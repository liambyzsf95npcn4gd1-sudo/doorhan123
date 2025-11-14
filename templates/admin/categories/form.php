<h1><?php echo isset($category) ? 'Редактировать категорию' : 'Создать категорию'; ?></h1>

<form method="post">
    <input type="hidden" name="csrf_token" value="<?php echo htmlspecialchars($csrf_token, ENT_QUOTES, 'UTF-8'); ?>">
    <div>
        <label for="name">Название</label>
        <input type="text" name="name" id="name" value="<?php echo htmlspecialchars($category['name'] ?? '', ENT_QUOTES, 'UTF-8'); ?>" required>
    </div>
    <div>
        <label for="slug">Slug</label>
        <input type="text" name="slug" id="slug" value="<?php echo htmlspecialchars($category['slug'] ?? '', ENT_QUOTES, 'UTF-8'); ?>" required>
    </div>
    <div>
        <label for="seo_title">SEO Title</label>
        <input type="text" name="seo_title" id="seo_title" value="<?php echo htmlspecialchars($category['seo_title'] ?? '', ENT_QUOTES, 'UTF-8'); ?>">
    </div>
    <div>
        <label for="meta_description">Meta Description</label>
        <input type="text" name="meta_description" id="meta_description" value="<?php echo htmlspecialchars($category['meta_description'] ?? '', ENT_QUOTES, 'UTF-8'); ?>">
    </div>
    <button type="submit">Сохранить</button>
</form>
