<h1><?php echo isset($product) ? 'Редактировать товар' : 'Создать товар'; ?></h1>

<style>
    .lang-tabs { margin-bottom: 20px; border-bottom: 1px solid #ccc; }
    .lang-tab { display: inline-block; padding: 10px 20px; cursor: pointer; background: #f1f1f1; margin-right: 5px; border: 1px solid #ccc; border-bottom: none; }
    .lang-tab.active { background: #fff; font-weight: bold; border-bottom: 1px solid #fff; margin-bottom: -1px; }
    .lang-content { display: none; padding: 20px; border: 1px solid #ccc; border-top: none; background: #fff; }
    .lang-content.active { display: block; }
</style>

<form method="post" enctype="multipart/form-data">
    <input type="hidden" name="csrf_token" value="<?php echo htmlspecialchars($csrf_token, ENT_QUOTES, 'UTF-8'); ?>">

    <div class="form-group">
        <label for="status">Статус</label>
        <select name="status" id="status">
            <option value="active" <?php echo (isset($product) && $product['status'] == 'active') ? 'selected' : ''; ?>>Активен</option>
            <option value="inactive" <?php echo (isset($product) && $product['status'] == 'inactive') ? 'selected' : ''; ?>>Неактивен</option>
        </select>
    </div>

    <div class="form-group">
        <label for="categories">Категории</label>
        <select name="categories[]" id="categories" multiple required>
            <?php foreach ($categories as $category): ?>
                <option value="<?php echo $category['id']; ?>" <?php echo (isset($product_categories) && in_array($category['id'], $product_categories)) ? 'selected' : ''; ?>>
                    <?php echo htmlspecialchars($category['name'] ?? 'Category ' . $category['id'], ENT_QUOTES, 'UTF-8'); ?>
                </option>
            <?php endforeach; ?>
        </select>
    </div>

    <!-- Language Tabs -->
    <div class="lang-tabs">
        <?php foreach (SUPPORTED_LANGUAGES as $index => $lang): ?>
            <div class="lang-tab <?php echo $index === 0 ? 'active' : ''; ?>" onclick="showTab('<?php echo $lang; ?>')">
                <?php echo strtoupper($lang); ?>
            </div>
        <?php endforeach; ?>
    </div>

    <?php foreach (SUPPORTED_LANGUAGES as $index => $lang):
        $t = $translations[$lang] ?? [];
    ?>
    <div id="tab-<?php echo $lang; ?>" class="lang-content <?php echo $index === 0 ? 'active' : ''; ?>">
        <h3><?php echo strtoupper($lang); ?> Content</h3>

        <div class="form-group">
            <label for="name_<?php echo $lang; ?>">Название (<?php echo $lang; ?>)</label>
            <input type="text" name="name[<?php echo $lang; ?>]" id="name_<?php echo $lang; ?>" value="<?php echo htmlspecialchars($t['name'] ?? '', ENT_QUOTES, 'UTF-8'); ?>">
        </div>

        <div class="form-group">
            <label for="slug_<?php echo $lang; ?>">Slug (<?php echo $lang; ?>)</label>
            <input type="text" name="slug[<?php echo $lang; ?>]" id="slug_<?php echo $lang; ?>" value="<?php echo htmlspecialchars($t['slug'] ?? '', ENT_QUOTES, 'UTF-8'); ?>">
        </div>

        <div class="form-group">
            <label for="content_<?php echo $lang; ?>">Содержимое (<?php echo $lang; ?>)</label>
            <textarea name="content[<?php echo $lang; ?>]" id="content_<?php echo $lang; ?>"><?php echo htmlspecialchars($t['content'] ?? '', ENT_QUOTES, 'UTF-8'); ?></textarea>
        </div>

        <div class="form-group">
            <label for="max_width_<?php echo $lang; ?>">Max Width (<?php echo $lang; ?>)</label>
            <input type="text" name="max_width[<?php echo $lang; ?>]" id="max_width_<?php echo $lang; ?>" value="<?php echo htmlspecialchars($t['max_width'] ?? '', ENT_QUOTES, 'UTF-8'); ?>">
        </div>

        <div class="form-group">
            <label for="max_height_<?php echo $lang; ?>">Max Height (<?php echo $lang; ?>)</label>
            <input type="text" name="max_height[<?php echo $lang; ?>]" id="max_height_<?php echo $lang; ?>" value="<?php echo htmlspecialchars($t['max_height'] ?? '', ENT_QUOTES, 'UTF-8'); ?>">
        </div>

        <div class="form-group">
            <label for="panel_thickness_<?php echo $lang; ?>">Panel Thickness (<?php echo $lang; ?>)</label>
            <input type="text" name="panel_thickness[<?php echo $lang; ?>]" id="panel_thickness_<?php echo $lang; ?>" value="<?php echo htmlspecialchars($t['panel_thickness'] ?? '', ENT_QUOTES, 'UTF-8'); ?>">
        </div>

        <div class="form-group">
            <label for="insulation_<?php echo $lang; ?>">Insulation (<?php echo $lang; ?>)</label>
            <input type="text" name="insulation[<?php echo $lang; ?>]" id="insulation_<?php echo $lang; ?>" value="<?php echo htmlspecialchars($t['insulation'] ?? '', ENT_QUOTES, 'UTF-8'); ?>">
        </div>

        <div class="form-group">
            <label for="seo_title_<?php echo $lang; ?>">SEO Title (<?php echo $lang; ?>)</label>
            <input type="text" name="seo_title[<?php echo $lang; ?>]" id="seo_title_<?php echo $lang; ?>" value="<?php echo htmlspecialchars($t['seo_title'] ?? '', ENT_QUOTES, 'UTF-8'); ?>">
        </div>

        <div class="form-group">
            <label for="meta_description_<?php echo $lang; ?>">Meta Description (<?php echo $lang; ?>)</label>
            <input type="text" name="meta_description[<?php echo $lang; ?>]" id="meta_description_<?php echo $lang; ?>" value="<?php echo htmlspecialchars($t['meta_description'] ?? '', ENT_QUOTES, 'UTF-8'); ?>">
        </div>
    </div>
    <?php endforeach; ?>

    <button type="submit" class="btn btn-primary" style="margin-top: 20px;">Сохранить</button>
</form>

<script>
function showTab(lang) {
    // Hide all tabs
    document.querySelectorAll('.lang-content').forEach(el => el.classList.remove('active'));
    document.querySelectorAll('.lang-tab').forEach(el => el.classList.remove('active'));

    // Show selected tab
    document.getElementById('tab-' + lang).classList.add('active');

    // Find tab button (not robust selector but works for simple case)
    const tabs = document.querySelectorAll('.lang-tab');
    const langs = <?php echo json_encode(SUPPORTED_LANGUAGES); ?>;
    const index = langs.indexOf(lang);
    if(index >= 0 && tabs[index]) tabs[index].classList.add('active');
}
</script>
