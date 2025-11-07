<h1>Управление страницами</h1>

<a href="<?php echo SITE_URL; ?>/admin/pages/create">Создать новую страницу</a>

<table>
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
                <td><?php echo htmlspecialchars($page['title'], ENT_QUOTES, 'UTF-8'); ?></td>
                <td><?php echo htmlspecialchars($page['slug'], ENT_QUOTES, 'UTF-8'); ?></td>
                <td>
                    <a href="<?php echo SITE_URL; ?>/admin/pages/edit/<?php echo $page['id']; ?>">Редактировать</a>
                    <a href="/admin/pages/delete/<?php echo $page['id']; ?>" ...>Удалить</a>
                </td>
            </tr>
        <?php endforeach; ?>
    </tbody>
</table>
