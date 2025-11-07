<h1>Просмотр сообщения</h1>

<div>
    <strong>Имя:</strong> <?php echo htmlspecialchars($message['name'], ENT_QUOTES, 'UTF-8'); ?>
</div>
<div>
    <strong>Email:</strong> <?php echo htmlspecialchars($message['email'], ENT_QUOTES, 'UTF-8'); ?>
</div>
<div>
    <strong>Телефон:</strong> <?php echo htmlspecialchars($message['phone'], ENT_QUOTES, 'UTF-8'); ?>
</div>
<div>
    <strong>Дата:</strong> <?php echo date('Y-m-d H:i', strtotime($message['created_at'])); ?>
</div>
<div>
    <strong>Сообщение:</strong>
    <p><?php echo nl2br(htmlspecialchars($message['message'], ENT_QUOTES, 'UTF-8')); ?></p>
</div>

<a href="/admin/messages">Назад к списку</a>
