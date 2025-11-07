<?php
// Модель для работы с товарами

class Product {
    private $db;

    public function __construct() {
        $this->db = Database::getInstance()->getConnection();
    }

    public function getAll() {
        $stmt = $this->db->prepare("SELECT * FROM products");
        $stmt->execute();
        return $stmt->fetchAll();
    }

    public function getAllActive($limit = 10, $offset = 0) {
        $stmt = $this->db->prepare("SELECT * FROM products WHERE status = 'active' ORDER BY created_at DESC LIMIT :limit OFFSET :offset");
        $stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
        $stmt->bindValue(':offset', $offset, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function countAllActive() {
        $stmt = $this->db->prepare("SELECT COUNT(*) FROM products WHERE status = 'active'");
        $stmt->execute();
        return $stmt->fetchColumn();
    }

    public function getBySlug($slug) {
        $stmt = $this->db->prepare("SELECT * FROM products WHERE slug = ? AND status = 'active'");
        $stmt->execute([$slug]);
        return $stmt->fetch();
    }

    public function getById($id) {
        $stmt = $this->db->prepare("SELECT * FROM products WHERE id = ?");
        $stmt->execute([$id]);
        return $stmt->fetch();
    }

    public function getImages($productId) {
        $stmt = $this->db->prepare("SELECT * FROM product_images WHERE product_id = ?");
        $stmt->execute([$productId]);
        return $stmt->fetchAll();
    }

    public function create($name, $slug, $content, $status, $seo_title, $meta_description) {
        $stmt = $this->db->prepare("INSERT INTO products (name, slug, content, status, seo_title, meta_description) VALUES (?, ?, ?, ?, ?, ?)");
        return $stmt->execute([$name, $slug, $content, $status, $seo_title, $meta_description]);
    }

    public function update($id, $name, $slug, $content, $status, $seo_title, $meta_description) {
        $stmt = $this->db->prepare("UPDATE products SET name = ?, slug = ?, content = ?, status = ?, seo_title = ?, meta_description = ? WHERE id = ?");
        return $stmt->execute([$name, $slug, $content, $status, $seo_title, $meta_description, $id]);
    }

    public function delete($id) {
        $stmt = $this->db->prepare("DELETE FROM products WHERE id = ?");
        return $stmt->execute([$id]);
    }
}
