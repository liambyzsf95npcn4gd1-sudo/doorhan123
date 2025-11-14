<?php
// Модель для работы с категориями

class Category {
    private $db;

    public function __construct() {
        $this->db = Database::getInstance()->getConnection();
    }

    public function getAll() {
        $stmt = $this->db->prepare("SELECT * FROM categories");
        $stmt->execute();
        return $stmt->fetchAll();
    }

    public function getBySlug($slug) {
        $stmt = $this->db->prepare("SELECT * FROM categories WHERE slug = ?");
        $stmt->execute([$slug]);
        return $stmt->fetch();
    }

    public function getById($id) {
        $stmt = $this->db->prepare("SELECT * FROM categories WHERE id = ?");
        $stmt->execute([$id]);
        return $stmt->fetch();
    }

    public function create($name, $slug, $parent_id, $seo_title, $meta_description) {
        $stmt = $this->db->prepare("INSERT INTO categories (name, slug, parent_id, seo_title, meta_description) VALUES (?, ?, ?, ?, ?)");
        return $stmt->execute([$name, $slug, $parent_id, $seo_title, $meta_description]);
    }

    public function update($id, $name, $slug, $parent_id, $seo_title, $meta_description) {
        $stmt = $this->db->prepare("UPDATE categories SET name = ?, slug = ?, parent_id = ?, seo_title = ?, meta_description = ? WHERE id = ?");
        return $stmt->execute([$name, $slug, $parent_id, $seo_title, $meta_description, $id]);
    }

    public function delete($id) {
        $stmt = $this->db->prepare("DELETE FROM categories WHERE id = ?");
        return $stmt->execute([$id]);
    }

    public function getSubcategories($categoryId) {
        $stmt = $this->db->prepare("SELECT * FROM categories WHERE parent_id = ?");
        $stmt->execute([$categoryId]);
        return $stmt->fetchAll();
    }

    public function getProductsByCategoryId($categoryId) {
        $stmt = $this->db->prepare("
            SELECT p.*
            FROM products p
            JOIN product_categories pc ON p.id = pc.product_id
            WHERE pc.category_id = ? AND p.status = 'active'
        ");
        $stmt->execute([$categoryId]);
        return $stmt->fetchAll();
    }
}