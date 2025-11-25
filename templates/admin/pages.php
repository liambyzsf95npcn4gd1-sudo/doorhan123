<h1>Управление страницами</h1>

<a href="<?php echo SITE_URL; ?>/admin/pages/create" class="btn btn-primary">Создать новую страницу</a>
<a href="<?php echo SITE_URL; ?>/admin/pages/edit/about" class="btn btn-secondary">Редактировать "О нас"</a>

<?php if (empty($pages)): ?>
    <p>Нет страниц для отображения.</p>
<?php else: ?>
    <table class="table">
        <thead>
            <tr>
                <th>Заголовок</th>
                <th>Slug</th>
                <th>Действия</th>
            </tr>
        </thead>
        <tbody>
            <?php foreach ($pages as $page): ?>
                <tr>
                    <td><?php echo htmlspecialchars($page['title']); ?></td>
                    <td><?php echo htmlspecialchars($page['slug']); ?></td>
                    <td>
                        <a href="<?php echo SITE_URL; ?>/admin/pages/edit/<?php echo $page['id']; ?>" class="btn btn-sm btn-info">Редактировать</a>
                        <a href="<?php echo SITE_URL; ?>/admin/pages/delete/<?php echo $page['id']; ?>" class="btn btn-sm btn-danger" onclick="return confirm('Вы уверены?');">Удалить</a>
                    </td>
                </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
<?php endif; ?>
