<?php
// Класс для работы с flash-сообщениями

class Flash {
    /**
     * Установить flash-сообщение
     * @param string $message
     * @param string $type (success, error)
     */
    public static function set($message, $type = 'success') {
        $_SESSION['flash_message'] = [
            'message' => $message,
            'type' => $type
        ];
    }

    /**
     * Отобразить flash-сообщение, если оно есть
     */
    public static function display() {
        if (isset($_SESSION['flash_message'])) {
            $message = $_SESSION['flash_message']['message'];
            $type = $_SESSION['flash_message']['type'];
            echo "<div class='flash-message {$type}'>{$message}</div>";
            unset($_SESSION['flash_message']);
        }
    }
}
