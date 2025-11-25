<?php
// Модель для работы с новостями (блог) (Multi-language with Fallback)

class Post {
    private $db;
    private $lang;

    public function __construct() {
        $this->db = Database::getInstance()->getConnection();
        $this->lang = Language::get();
    }

    public function getAll() {
        $sql = "SELECT p.id, p.status, p.created_at, p.image, p.image2, p.image3,
                       COALESCE(pt.title, pt_en.title) as title,
                       COALESCE(pt.slug, pt_en.slug) as slug,
                       COALESCE(pt.content, pt_en.content) as content,
                       COALESCE(pt.seo_title, pt_en.seo_title) as seo_title,
                       COALESCE(pt.meta_description, pt_en.meta_description) as meta_description
                FROM posts p
                LEFT JOIN post_translations pt ON p.id = pt.post_id AND pt.language_code = ?
                LEFT JOIN post_translations pt_en ON p.id = pt_en.post_id AND pt_en.language_code = 'en'";
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
        $sql = "SELECT p.id, p.status, p.created_at, p.image, p.image2, p.image3,
                       COALESCE(pt.title, pt_en.title) as title,
                       COALESCE(pt.slug, pt_en.slug) as slug,
                       COALESCE(pt.content, pt_en.content) as content,
                       COALESCE(pt.seo_title, pt_en.seo_title) as seo_title,
                       COALESCE(pt.meta_description, pt_en.meta_description) as meta_description
                FROM posts p
                LEFT JOIN post_translations pt ON p.id = pt.post_id AND pt.language_code = ?
                LEFT JOIN post_translations pt_en ON p.id = pt_en.post_id AND pt_en.language_code = 'en'
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
        // Find ID first
        $stmt = $this->db->prepare("
            SELECT p.id
            FROM posts p
            LEFT JOIN post_translations pt ON p.id = pt.post_id AND pt.language_code = ?
            LEFT JOIN post_translations pt_en ON p.id = pt_en.post_id AND pt_en.language_code = 'en'
            WHERE (pt.slug = ? OR pt_en.slug = ?) AND p.status = 'published'
        ");
        $stmt->execute([$this->lang, $slug, $slug]);
        $id = $stmt->fetchColumn();

        if (!$id) return false;

        return $this->getById($id);
    }

    public function getById($id) {
        $sql = "SELECT p.id, p.status, p.created_at, p.image, p.image2, p.image3,
                       COALESCE(pt.title, pt_en.title) as title,
                       COALESCE(pt.slug, pt_en.slug) as slug,
                       COALESCE(pt.content, pt_en.content) as content,
                       COALESCE(pt.seo_title, pt_en.seo_title) as seo_title,
                       COALESCE(pt.meta_description, pt_en.meta_description) as meta_description
                FROM posts p
                LEFT JOIN post_translations pt ON p.id = pt.post_id AND pt.language_code = ?
                LEFT JOIN post_translations pt_en ON p.id = pt_en.post_id AND pt_en.language_code = 'en'
                WHERE p.id = ?";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([$this->lang, $id]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    public function create($data, $langData) {
        $this->db->beginTransaction();
        try {
            $stmt = $this->db->prepare("INSERT INTO posts (status, image, image2, image3) VALUES (:status, :image, :image2, :image3)");
            $stmt->execute([
                ':status' => $data['status'],
                ':image' => $data['image'],
                ':image2' => $data['image2'],
                ':image3' => $data['image3']
            ]);
            $postId = $this->db->lastInsertId();

            $stmt = $this->db->prepare("INSERT INTO post_translations (post_id, language_code, title, slug, content, seo_title, meta_description) VALUES (?, ?, ?, ?, ?, ?, ?)");
            foreach ($langData as $lang => $fields) {
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

    public function update($id, $data, $langData) {
        $this->db->beginTransaction();
        try {
            // Get current images to avoid overwriting them with null
            $currentPost = $this->getById($id);

            $updateData = [
                'id' => $id,
                'status' => $data['status'],
                'image' => isset($data['image']) ? $data['image'] : $currentPost['image'],
                'image2' => isset($data['image2']) ? $data['image2'] : $currentPost['image2'],
                'image3' => isset($data['image3']) ? $data['image3'] : $currentPost['image3']
            ];

            $stmt = $this->db->prepare("UPDATE posts SET status = :status, image = :image, image2 = :image2, image3 = :image3 WHERE id = :id");
            $stmt->execute($updateData);

            $stmt = $this->db->prepare("INSERT INTO post_translations (post_id, language_code, title, slug, content, seo_title, meta_description) VALUES (?, ?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE title=VALUES(title), slug=VALUES(slug), content=VALUES(content), seo_title=VALUES(seo_title), meta_description=VALUES(meta_description)");
            foreach ($langData as $lang => $fields) {
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
