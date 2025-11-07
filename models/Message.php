<?php
// Модель для работы с сообщениями из контактной формы

class Message {
    private $db;

    public function __construct() {
        $this->db = Database::getInstance()->getConnection();
    }

    public function save($name, $email, $phone, $message) {
        $stmt = $this->db->prepare("INSERT INTO messages (name, email, phone, message) VALUES (?, ?, ?, ?)");
        return $stmt->execute([$name, $email, $phone, $message]);
    }

    public function getAll() {
        $stmt = $this->db->prepare("SELECT * FROM messages ORDER BY created_at DESC");
        $stmt->execute();
        return $stmt->fetchAll();
    }

    public function getById($id) {
        $stmt = $this->db->prepare("SELECT * FROM messages WHERE id = ?");
        $stmt->execute([$id]);
        return $stmt->fetch();
    }

    public function markAsRead($id) {
        $stmt = $this->db->prepare("UPDATE messages SET is_read = 1 WHERE id = ?");
        return $stmt->execute([$id]);
    }

    public function delete($id) {
        $stmt = $this->db->prepare("DELETE FROM messages WHERE id = ?");
        return $stmt->execute([$id]);
    }
}
