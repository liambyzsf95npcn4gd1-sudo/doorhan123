<?php
// Модель для работы с настройками сайта

class Settings {
    private $db;

    public function __construct() {
        $this->db = Database::getInstance()->getConnection();
    }

    public function getAllSettings() {
        $stmt = $this->db->query("SELECT `key`, `value` FROM settings");
        $settings = $stmt->fetchAll(PDO::FETCH_KEY_PAIR);
        return $settings;
    }
}
