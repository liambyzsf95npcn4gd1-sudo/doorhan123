<h1>Управление товарами</h1>

<a href="<?php echo SITE_URL; ?>/admin/products/create">Создать новый товар</a>

<table>
    <thead>
        <tr>
            <th>Название</th>
            <th>Slug</th>
            <th>Статус</th>
            <th>Действия</th>
        </tr>
    </thead>
    <tbody>
        <?php foreach ($products as $product): ?>
            <tr>
                <td><?php echo htmlspecialchars($product['name'], ENT_QUOTES, 'UTF-8'); ?></td>
                <td><?php echo htmlspecialchars($product['slug'], ENT_QUOTES, 'UTF-8'); ?></td>
                <td><?php echo htmlspecialchars($product['status'], ENT_QUOTES, 'UTF-8'); ?></td>
                <td>
                    <a href="<?php echo SITE_URL; ?>/admin/products/edit/<?php echo $product['id']; ?>">Редактировать</a>
                    <a href="<?php echo SITE_URL; ?>/admin/products/delete/<?php echo $product['id']; ?>" onclick="return confirm('Вы уверены?');">Удалить</a>
                </td>
            </tr>
        <?php endforeach; ?>
    </tbody>
</table>