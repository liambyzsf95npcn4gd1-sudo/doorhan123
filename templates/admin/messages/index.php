<h1>Сообщения из контактной формы</h1>

<table>
    <thead>
        <tr>
            <th>Имя</th>
            <th>Email</th>
            <th>Дата</th>
            <th>Статус</th>
            <th>Действия</th>
        </tr>
    </thead>
    <tbody>
        <?php foreach ($messages as $message): ?>
            <tr class="<?php echo $message['is_read'] ? 'read' : 'unread'; ?>">
                <td><?php echo htmlspecialchars($message['name'], ENT_QUOTES, 'UTF-8'); ?></td>
                <td><?php echo htmlspecialchars($message['email'], ENT_QUOTES, 'UTF-8'); ?></td>
                <td><?php echo date('Y-m-d H:i', strtotime($message['created_at'])); ?></td>
                <td><?php echo $message['is_read'] ? 'Прочитано' : 'Новое'; ?></td>
                <td>
                    <a href="<?php echo SITE_URL; ?>/admin/messages/view/<?php echo $message['id']; ?>">Посмотреть</a>
                    <a href="<?php echo SITE_URL; ?>/admin/messages/delete/<?php echo $message['id']; ?>" onclick="return confirm('Вы уверены?');">Удалить</a>
                </td>
            </tr>
        <?php endforeach; ?>
    </tbody>
</table>