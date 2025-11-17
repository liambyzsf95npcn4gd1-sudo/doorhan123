<style>
    .tabs {
        display: flex;
        border-bottom: 1px solid #ccc;
        margin-bottom: 20px;
    }
    .tab-link {
        padding: 10px 20px;
        cursor: pointer;
        border: 1px solid #ccc;
        border-bottom: none;
        background-color: #f1f1f1;
        margin-right: 5px;
    }
    .tab-link.active {
        background-color: #fff;
        border-bottom: 1px solid #fff;
    }
    .tab-content {
        display: none;
    }
    .tab-content.active {
        display: block;
    }
</style>

<h1>Настройки</h1>

<div class="tabs">
    <div class="tab-link active" onclick="openTab(event, 'general')">Основные</div>
    <div class="tab-link" onclick="openTab(event, 'chatbot')">Чат-бот</div>
</div>

<div id="general" class="tab-content active">
    <h2>Основные настройки</h2>
    <form action="<?php echo SITE_URL; ?>/admin/settings" method="post">
        <input type="hidden" name="csrf_token" value="<?php echo htmlspecialchars($csrf_token, ENT_QUOTES, 'UTF-8'); ?>">
        <input type="hidden" name="form_type" value="general">
        <div>
            <label for="site_title">Название сайта</label>
            <input type="text" name="site_title" id="site_title" value="<?php echo htmlspecialchars($settings['site_title'] ?? '', ENT_QUOTES, 'UTF-8'); ?>" required>
        </div>
        <div>
            <label for="contact_email">Email для контактов</label>
            <input type="email" name="contact_email" id="contact_email" value="<?php echo htmlspecialchars($settings['contact_email'] ?? '', ENT_QUOTES, 'UTF-8'); ?>" required>
        </div>
        <button type="submit">Сохранить</button>
    </form>
</div>

<div id="chatbot" class="tab-content">
    <h2>Настройки чат-бота</h2>
    <form action="<?php echo SITE_URL; ?>/admin/settings" method="post">
        <input type="hidden" name="csrf_token" value="<?php echo htmlspecialchars($csrf_token, ENT_QUOTES, 'UTF-8'); ?>">
        <input type="hidden" name="form_type" value="chatbot">

        <label for="chatbot_is_enabled">Чат-бот включен</label>
        <input type="checkbox" name="chatbot_is_enabled" id="chatbot_is_enabled" <?php echo !empty($chatbot_settings['is_enabled']) ? 'checked' : ''; ?>>

        <label for="chatbot_api_key">API ключ Gemini</label>
        <input type="text" name="chatbot_api_key" id="chatbot_api_key" value="<?php echo htmlspecialchars($chatbot_settings['api_key'] ?? '', ENT_QUOTES, 'UTF-8'); ?>">

        <label for="chatbot_model">Модель Gemini</label>
        <select name="chatbot_model" id="chatbot_model">
            <option value="gemini-pro" <?php echo (($chatbot_settings['model'] ?? '') === 'gemini-pro') ? 'selected' : ''; ?>>gemini-pro</option>
        </select>

        <label for="chatbot_name">Имя чат-бота</label>
        <input type="text" name="chatbot_name" id="chatbot_name" value="<?php echo htmlspecialchars($chatbot_settings['chatbot_name'] ?? 'Chatbot', ENT_QUOTES, 'UTF-8'); ?>">

        <label for="chatbot_welcome_message">Приветственное сообщение</label>
        <textarea name="chatbot_welcome_message" id="chatbot_welcome_message"><?php echo htmlspecialchars($chatbot_settings['welcome_message'] ?? '', ENT_QUOTES, 'UTF-8'); ?></textarea>

        <label for="chatbot_bot_rules">Правила "Как должен отвечать бот"</label>
        <textarea name="chatbot_bot_rules" id="chatbot_bot_rules"><?php echo htmlspecialchars($chatbot_settings['bot_rules'] ?? '', ENT_QUOTES, 'UTF-8'); ?></textarea>

        <label>Разрешенные источники данных:</label>
        <input type="checkbox" name="chatbot_allow_db_source" id="chatbot_allow_db_source" <?php echo !empty($chatbot_settings['allow_db_source']) ? 'checked' : ''; ?>>
        <label for="chatbot_allow_db_source">База данных сайта</label>
        <input type="checkbox" name="chatbot_allow_pdf_source" id="chatbot_allow_pdf_source" <?php echo !empty($chatbot_settings['allow_pdf_source']) ? 'checked' : ''; ?>>
        <label for="chatbot_allow_pdf_source">PDF каталоги</label>

        <label for="chatbot_message_length_mode">Режим длины сообщений</label>
        <select name="chatbot_message_length_mode" id="chatbot_message_length_mode">
            <option value="short" <?php echo (($chatbot_settings['message_length_mode'] ?? '') === 'short') ? 'selected' : ''; ?>>Короткий</option>
            <option value="detailed" <?php echo (($chatbot_settings['message_length_mode'] ?? '') === 'detailed') ? 'selected' : ''; ?>>Подробный</option>
        </select>

        <label for="chatbot_fallback_email">Email для связи</label>
        <input type="email" name="chatbot_fallback_email" id="chatbot_fallback_email" value="<?php echo htmlspecialchars($chatbot_settings['fallback_email'] ?? '', ENT_QUOTES, 'UTF-8'); ?>">

        <h3>Дизайн кнопки</h3>
        <label for="chatbot_button_color">Цвет кнопки</label>
        <input type="color" name="chatbot_button_color" id="chatbot_button_color" value="<?php echo htmlspecialchars($chatbot_settings['button_color'] ?? '#007bff', ENT_QUOTES, 'UTF-8'); ?>">

        <label for="chatbot_button_position">Позиция кнопки</label>
        <select name="chatbot_button_position" id="chatbot_button_position">
            <option value="bottom-right" <?php echo (($chatbot_settings['button_position'] ?? '') === 'bottom-right') ? 'selected' : ''; ?>>Справа внизу</option>
            <option value="bottom-left" <?php echo (($chatbot_settings['button_position'] ?? '') === 'bottom-left') ? 'selected' : ''; ?>>Слева внизу</option>
        </select>

        <label for="chatbot_button_size">Размер кнопки</label>
        <select name="chatbot_button_size" id="chatbot_button_size">
            <option value="small" <?php echo (($chatbot_settings['button_size'] ?? '') === 'small') ? 'selected' : ''; ?>>Маленький</option>
            <option value="medium" <?php echo (($chatbot_settings['button_size'] ?? '') === 'medium') ? 'selected' : ''; ?>>Средний</option>
            <option value="large" <?php echo (($chatbot_settings['button_size'] ?? '') === 'large') ? 'selected' : ''; ?>>Большой</option>
        </select>

        <h3>Дизайн окна чата</h3>
        <label for="chatbot_chat_window_styles">Стили CSS</label>
        <textarea name="chatbot_chat_window_styles" id="chatbot_chat_window_styles"><?php echo htmlspecialchars($chatbot_settings['chat_window_styles'] ?? '', ENT_QUOTES, 'UTF-8'); ?></textarea>

        <button type="submit">Сохранить настройки чат-бота</button>
    </form>
</div>

<script>
    function openTab(evt, tabName) {
        var i, tabcontent, tablinks;
        tabcontent = document.getElementsByClassName("tab-content");
        for (i = 0; i < tabcontent.length; i++) {
            tabcontent[i].style.display = "none";
        }
        tablinks = document.getElementsByClassName("tab-link");
        for (i = 0; i < tablinks.length; i++) {
            tablinks[i].className = tablinks[i].className.replace(" active", "");
        }
        document.getElementById(tabName).style.display = "block";
        evt.currentTarget.className += " active";
    }
</script>