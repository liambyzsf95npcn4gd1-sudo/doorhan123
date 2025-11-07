<?php
// Модель для работы с новостями (блог)

class Post {
    private $db;

    public function __construct() {
        $this->db = Database::getInstance()->getConnection();
    }

    public function getAll() {
        $stmt = $this->db->prepare("SELECT * FROM posts");
        $stmt->execute();
        return $stmt->fetchAll();
    }

    public function getAllPublished($limit = 10, $offset = 0) {
        $stmt = $this->db->prepare("SELECT * FROM posts WHERE status = 'published' ORDER BY created_at DESC LIMIT :limit OFFSET :offset");
        $stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
        $stmt->bindValue(':offset', $offset, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function countAllPublished() {
        $stmt = $this->db->prepare("SELECT COUNT(*) FROM posts WHERE status = 'published'");
        $stmt->execute();
        return $stmt->fetchColumn();
    }

    public function getBySlug($slug) {
        $stmt = $this->db->prepare("SELECT * FROM posts WHERE slug = ? AND status = 'published'");
        $stmt->execute([$slug]);
        return $stmt->fetch();
    }

    public function getById($id) {
        $stmt = $this->db->prepare("SELECT * FROM posts WHERE id = ?");
        $stmt->execute([$id]);
        return $stmt->fetch();
    }

    public function create($title, $slug, $content, $status, $seo_title, $meta_description) {
        $stmt = $this->db->prepare("INSERT INTO posts (title, slug, content, status, seo_title, meta_description) VALUES (?, ?, ?, ?, ?, ?)");
        return $stmt->execute([$title, $slug, $content, $status, $seo_title, $meta_description]);
    }

    public function update($id, $title, $slug, $content, $status, $seo_title, $meta_description) {
        $stmt = $this->db->prepare("UPDATE posts SET title = ?, slug = ?, content = ?, status = ?, seo_title = ?, meta_description = ? WHERE id = ?");
        return $stmt->execute([$title, $slug, $content, $status, $seo_title, $meta_description, $id]);
    }

    public function delete($id) {
        $stmt = $this->db->prepare("DELETE FROM posts WHERE id = ?");
        return $stmt->execute([$id]);
    }
}
