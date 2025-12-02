<h1>Управление новостями</h1>

<a href="<?php echo SITE_URL; ?>/admin/posts/create">Создать новую новость</a>

<table>
    <thead>
        <tr>
            <th>Изображение</th>
            <th>Заголовок</th>
            <th>Slug</th>
            <th>Статус</th>
            <th>Действия</th>
        </tr>
    </thead>
    <tbody>
        <?php foreach ($posts as $post): ?>
            <tr>
                <td>
                    <?php if (!empty($post['image'])): ?>
                        <img src="<?php echo SITE_URL . UPLOADS_DIR . htmlspecialchars($post['image']); ?>" alt="Img" style="width: 50px; height: 50px; object-fit: cover;">
                    <?php else: ?>
                        <span style="color: #ccc;">Нет фото</span>
                    <?php endif; ?>
                </td>
                <td><?php echo htmlspecialchars($post['title'], ENT_QUOTES, 'UTF-8'); ?></td>
                <td><?php echo htmlspecialchars($post['slug'], ENT_QUOTES, 'UTF-8'); ?></td>
                <td><?php echo htmlspecialchars($post['status'], ENT_QUOTES, 'UTF-8'); ?></td>
                <td>
                    <a href="<?php echo SITE_URL; ?>/admin/posts/edit/<?php echo $post['id']; ?>">Редактировать</a>
                    <a href="<?php echo SITE_URL; ?>/admin/posts/delete/<?php echo $post['id']; ?>" onclick="return confirm('Вы уверены?');">Удалить</a>
                </td>
            </tr>
        <?php endforeach; ?>
    </tbody>
</table>