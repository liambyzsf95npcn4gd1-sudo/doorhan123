<h1><?php echo isset($product) ? 'Редактировать товар' : 'Создать товар'; ?></h1>

<form method="post" enctype="multipart/form-data">
    <input type="hidden" name="csrf_token" value="<?php echo htmlspecialchars($csrf_token, ENT_QUOTES, 'UTF-8'); ?>">
    <div>
        <label for="name">Название</label>
        <input type="text" name="name" id="name" value="<?php echo htmlspecialchars($product['name'] ?? '', ENT_QUOTES, 'UTF-8'); ?>" required>
    </div>
    <div>
        <label for="slug">Slug</label>
        <input type="text" name="slug" id="slug" value="<?php echo htmlspecialchars($product['slug'] ?? '', ENT_QUOTES, 'UTF-8'); ?>" required>
    </div>
    <div>
        <label for="content">Содержимое</label>
        <textarea name="content" id="content"><?php echo htmlspecialchars($product['content'] ?? '', ENT_QUOTES, 'UTF-8'); ?></textarea>
    </div>
    <div>
        <label for="status">Статус</label>
        <select name="status" id="status">
            <option value="active" <?php echo (isset($product) && $product['status'] == 'active') ? 'selected' : ''; ?>>Активен</option>
            <option value="inactive" <?php echo (isset($product) && $product['status'] == 'inactive') ? 'selected' : ''; ?>>Неактивен</option>
        </select>
    </div>
    <div>
        <label for="categories">Категории</label>
        <select name="categories[]" id="categories" multiple required>
            <?php foreach ($categories as $category): ?>
                <option value="<?php echo $category['id']; ?>" <?php echo (isset($product_categories) && in_array($category['id'], $product_categories)) ? 'selected' : ''; ?>>
                    <?php echo htmlspecialchars($category['name'], ENT_QUOTES, 'UTF-8'); ?>
                </option>
            <?php endforeach; ?>
        </select>
    </div>
    <div>
        <label for="seo_title">SEO Title</label>
        <input type="text" name="seo_title" id="seo_title" value="<?php echo htmlspecialchars($product['seo_title'] ?? '', ENT_QUOTES, 'UTF-8'); ?>">
    </div>
    <div>
        <label for="meta_description">Meta Description</label>
        <input type="text" name="meta_description" id="meta_description" value="<?php echo htmlspecialchars($product['meta_description'] ?? '', ENT_QUOTES, 'UTF-8'); ?>">
    </div>
    <button type="submit">Сохранить</button>
</form>
