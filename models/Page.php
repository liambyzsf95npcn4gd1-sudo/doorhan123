<?php
// Модель для работы со статическими страницами

class Page {
    private $db;

    public function __construct() {
        $this->db = Database::getInstance()->getConnection();
    }

    public function getAll() {
        $stmt = $this->db->prepare("SELECT * FROM pages");
        $stmt->execute();
        return $stmt->fetchAll();
    }

    public function getBySlug($slug) {
        $stmt = $this->db->prepare("SELECT * FROM pages WHERE slug = ?");
        $stmt->execute([$slug]);
        return $stmt->fetch();
    }

    public function getById($id) {
        $stmt = $this->db->prepare("SELECT * FROM pages WHERE id = ?");
        $stmt->execute([$id]);
        return $stmt->fetch();
    }

    public function create($title, $slug, $content, $seo_title, $meta_description) {
        $stmt = $this->db->prepare("INSERT INTO pages (title, slug, content, seo_title, meta_description) VALUES (?, ?, ?, ?, ?)");
        return $stmt->execute([$title, $slug, $content, $seo_title, $meta_description]);
    }

    public function update($id, $title, $slug, $content, $seo_title, $meta_description) {
        $stmt = $this->db->prepare("UPDATE pages SET title = ?, slug = ?, content = ?, seo_title = ?, meta_description = ? WHERE id = ?");
        return $stmt->execute([$title, $slug, $content, $seo_title, $meta_description, $id]);
    }

    public function delete($id) {
        $stmt = $this->db->prepare("DELETE FROM pages WHERE id = ?");
        return $stmt->execute([$id]);
    }
}
