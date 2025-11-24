<?php
// Модель для работы с новостями (блог) (Multi-language)

class Post {
    private $db;
    private $lang;

    public function __construct() {
        $this->db = Database::getInstance()->getConnection();
        $this->lang = Language::get();
    }

    public function getAll() {
        $sql = "SELECT p.id, p.status, p.created_at,
                       pt.title, pt.slug, pt.content, pt.seo_title, pt.meta_description
                FROM posts p
                LEFT JOIN post_translations pt ON p.id = pt.post_id AND pt.language_code = ?";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([$this->lang]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function getTranslations($id) {
        $stmt = $this->db->prepare("SELECT * FROM post_translations WHERE post_id = ?");
        $stmt->execute([$id]);
        $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
        $result = [];
        foreach ($rows as $row) {
            $result[$row['language_code']] = $row;
        }
        return $result;
    }

    public function getAllPublished($limit = 10, $offset = 0) {
        $sql = "SELECT p.id, p.status, p.created_at,
                       pt.title, pt.slug, pt.content, pt.seo_title, pt.meta_description
                FROM posts p
                LEFT JOIN post_translations pt ON p.id = pt.post_id AND pt.language_code = ?
                WHERE p.status = 'published'
                ORDER BY p.created_at DESC
                LIMIT " . (int)$limit . " OFFSET " . (int)$offset;
        $stmt = $this->db->prepare($sql);
        $stmt->execute([$this->lang]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function countAllPublished() {
        $stmt = $this->db->prepare("SELECT COUNT(*) FROM posts WHERE status = 'published'");
        $stmt->execute();
        return $stmt->fetchColumn();
    }

    public function getBySlug($slug) {
        $sql = "SELECT p.id, p.status, p.created_at,
                       pt.title, pt.slug, pt.content, pt.seo_title, pt.meta_description
                FROM posts p
                JOIN post_translations pt ON p.id = pt.post_id
                WHERE pt.slug = ? AND pt.language_code = ? AND p.status = 'published'";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([$slug, $this->lang]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    public function getById($id) {
        $sql = "SELECT p.id, p.status, p.created_at,
                       pt.title, pt.slug, pt.content, pt.seo_title, pt.meta_description
                FROM posts p
                LEFT JOIN post_translations pt ON p.id = pt.post_id AND pt.language_code = ?
                WHERE p.id = ?";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([$this->lang, $id]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    public function create($status, $data) {
        $this->db->beginTransaction();
        try {
            $stmt = $this->db->prepare("INSERT INTO posts (status) VALUES (?)");
            $stmt->execute([$status]);
            $postId = $this->db->lastInsertId();

            $stmt = $this->db->prepare("INSERT INTO post_translations (post_id, language_code, title, slug, content, seo_title, meta_description) VALUES (?, ?, ?, ?, ?, ?, ?)");
            foreach ($data as $lang => $fields) {
                $stmt->execute([
                    $postId,
                    $lang,
                    $fields['title'],
                    $fields['slug'],
                    $fields['content'],
                    $fields['seo_title'],
                    $fields['meta_description']
                ]);
            }
            $this->db->commit();
            return $postId;
        } catch (Exception $e) {
            $this->db->rollBack();
            return false;
        }
    }

    public function update($id, $status, $data) {
        $this->db->beginTransaction();
        try {
            $stmt = $this->db->prepare("UPDATE posts SET status = ? WHERE id = ?");
            $stmt->execute([$status, $id]);

            $stmt = $this->db->prepare("INSERT INTO post_translations (post_id, language_code, title, slug, content, seo_title, meta_description) VALUES (?, ?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE title=VALUES(title), slug=VALUES(slug), content=VALUES(content), seo_title=VALUES(seo_title), meta_description=VALUES(meta_description)");
            foreach ($data as $lang => $fields) {
                $stmt->execute([
                    $id,
                    $lang,
                    $fields['title'],
                    $fields['slug'],
                    $fields['content'],
                    $fields['seo_title'],
                    $fields['meta_description']
                ]);
            }
            $this->db->commit();
            return true;
        } catch (Exception $e) {
            $this->db->rollBack();
            return false;
        }
    }

    public function delete($id) {
        $stmt = $this->db->prepare("DELETE FROM posts WHERE id = ?");
        return $stmt->execute([$id]);
    }
}
