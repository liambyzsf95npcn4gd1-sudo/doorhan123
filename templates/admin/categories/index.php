<h1>Управление категориями</h1>

<a href="<?php echo SITE_URL; ?>/admin/categories/create">Создать новую категорию</a>

<table>
    <thead>
        <tr>
            <th>Название</th>
            <th>Slug</th>
            <th>Действия</th>
        </tr>
    </thead>
    <tbody>
        <?php foreach ($categories as $category): ?>
            <tr>
                <td><?php echo htmlspecialchars($category['name'], ENT_QUOTES, 'UTF-8'); ?></td>
                <td><?php echo htmlspecialchars($category['slug'], ENT_QUOTES, 'UTF-8'); ?></td>
                <td>
                    <a href="<?php echo SITE_URL; ?>/admin/categories/edit/<?php echo $category['id']; ?>">Редактировать</a>
                    <a href="<?php echo SITE_URL; ?>/admin/categories/delete/<?php echo $category['id']; ?>" onclick="return confirm('Вы уверены?');">Удалить</a>
                </td>
            </tr>
        <?php endforeach; ?>
    </tbody>
</table>