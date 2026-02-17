<h1><?php echo isset($page) ? 'Редактировать страницу' : 'Создать страницу'; ?></h1>

<style>
    .lang-tabs { margin-bottom: 20px; border-bottom: 1px solid #ccc; }
    .lang-tab { display: inline-block; padding: 10px 20px; cursor: pointer; background: #f1f1f1; margin-right: 5px; border: 1px solid #ccc; border-bottom: none; }
    .lang-tab.active { background: #fff; font-weight: bold; border-bottom: 1px solid #fff; margin-bottom: -1px; }
    .lang-content { display: none; padding: 20px; border: 1px solid #ccc; border-top: none; background: #fff; }
    .lang-content.active { display: block; }
</style>

<form method="post" enctype="multipart/form-data">
    <input type="hidden" name="csrf_token" value="<?php echo htmlspecialchars($csrf_token, ENT_QUOTES, 'UTF-8'); ?>">

    <!-- Language Tabs -->
    <div class="lang-tabs">
        <?php foreach (Language::getAll() as $index => $lang): ?>
            <div class="lang-tab <?php echo $index === 0 ? 'active' : ''; ?>" onclick="showTab('<?php echo $lang; ?>')">
                <?php echo strtoupper($lang); ?>
            </div>
        <?php endforeach; ?>
    </div>

    <?php foreach (Language::getAll() as $index => $lang):
        $t = $translations[$lang] ?? [];
    ?>
    <div id="tab-<?php echo $lang; ?>" class="lang-content <?php echo $index === 0 ? 'active' : ''; ?>">
        <h3><?php echo strtoupper($lang); ?> Content</h3>

        <div class="form-group">
            <label for="title_<?php echo $lang; ?>">Заголовок (<?php echo $lang; ?>)</label>
            <input type="text" name="title[<?php echo $lang; ?>]" id="title_<?php echo $lang; ?>" value="<?php echo htmlspecialchars($t['title'] ?? '', ENT_QUOTES, 'UTF-8'); ?>">
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
            <label for="seo_title_<?php echo $lang; ?>">SEO Title (<?php echo $lang; ?>)</label>
            <input type="text" name="seo_title[<?php echo $lang; ?>]" id="seo_title_<?php echo $lang; ?>" value="<?php echo htmlspecialchars($t['seo_title'] ?? '', ENT_QUOTES, 'UTF-8'); ?>">
        </div>

        <div class="form-group">
            <label for="meta_description_<?php echo $lang; ?>">Meta Description (<?php echo $lang; ?>)</label>
            <input type="text" name="meta_description[<?php echo $lang; ?>]" id="meta_description_<?php echo $lang; ?>" value="<?php echo htmlspecialchars($t['meta_description'] ?? '', ENT_QUOTES, 'UTF-8'); ?>">
        </div>

        <div class="form-group">
            <label for="image_<?php echo $lang; ?>">Изображение (<?php echo $lang; ?>)</label>
            <input type="file" name="image[<?php echo $lang; ?>]" id="image_<?php echo $lang; ?>">
            <?php if (!empty($t['image'])): ?>
                <p>Текущее изображение: <?php echo htmlspecialchars($t['image'], ENT_QUOTES, 'UTF-8'); ?></p>
                <img src="<?php echo SITE_URL; ?>/uploads/<?php echo htmlspecialchars($t['image'], ENT_QUOTES, 'UTF-8'); ?>" alt="Current Image" style="max-width: 200px;">
            <?php endif; ?>
        </div>
    </div>
    <?php endforeach; ?>

    <button type="submit" class="btn btn-primary" style="margin-top: 20px;">Сохранить</button>
</form>

<script>
function showTab(lang) {
    document.querySelectorAll('.lang-content').forEach(el => el.classList.remove('active'));
    document.querySelectorAll('.lang-tab').forEach(el => el.classList.remove('active'));

    document.getElementById('tab-' + lang).classList.add('active');

    const tabs = document.querySelectorAll('.lang-tab');
    const langs = <?php echo json_encode(Language::getAll()); ?>;
    const index = langs.indexOf(lang);
    if(index >= 0 && tabs[index]) tabs[index].classList.add('active');
}
</script>
