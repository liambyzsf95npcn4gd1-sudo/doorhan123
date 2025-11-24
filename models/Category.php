<?php
// Модель для работы с категориями (Multi-language)

class Category {
    private $db;
    private $lang;

    public function __construct() {
        $this->db = Database::getInstance()->getConnection();
        $this->lang = Language::get();
    }

    public function getAll() {
        $sql = "SELECT c.id, c.parent_id,
                       ct.name, ct.slug, ct.description, ct.seo_title, ct.meta_description
                FROM categories c
                LEFT JOIN category_translations ct ON c.id = ct.category_id AND ct.language_code = ?";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([$this->lang]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function getTranslations($id) {
        $stmt = $this->db->prepare("SELECT * FROM category_translations WHERE category_id = ?");
        $stmt->execute([$id]);
        $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
        $result = [];
        foreach ($rows as $row) {
            $result[$row['language_code']] = $row;
        }
        return $result;
    }

    public function getBySlug($slug) {
        $sql = "SELECT c.id, c.parent_id,
                       ct.name, ct.slug, ct.description, ct.seo_title, ct.meta_description
                FROM categories c
                JOIN category_translations ct ON c.id = ct.category_id
                WHERE ct.slug = ? AND ct.language_code = ?";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([$slug, $this->lang]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    public function getById($id) {
        $sql = "SELECT c.id, c.parent_id,
                       ct.name, ct.slug, ct.description, ct.seo_title, ct.meta_description
                FROM categories c
                LEFT JOIN category_translations ct ON c.id = ct.category_id AND ct.language_code = ?
                WHERE c.id = ?";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([$this->lang, $id]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    public function getProductsByCategoryId($categoryId) {
        $sql = "SELECT p.id, p.status, p.created_at,
                       pt.name, pt.slug, pt.content, pt.seo_title, pt.meta_description,
                       pt.max_width, pt.max_height, pt.panel_thickness, pt.insulation
                FROM products p
                JOIN product_categories pc ON p.id = pc.product_id
                LEFT JOIN product_translations pt ON p.id = pt.product_id AND pt.language_code = ?
                WHERE pc.category_id = ? AND p.status = 'active'";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([$this->lang, $categoryId]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function create($parentId, $data) {
        $this->db->beginTransaction();
        try {
            $stmt = $this->db->prepare("INSERT INTO categories (parent_id) VALUES (?)");
            $stmt->execute([$parentId]);
            $categoryId = $this->db->lastInsertId();

            $stmt = $this->db->prepare("INSERT INTO category_translations (category_id, language_code, name, slug, description, seo_title, meta_description) VALUES (?, ?, ?, ?, ?, ?, ?)");
            foreach ($data as $lang => $fields) {
                $stmt->execute([
                    $categoryId,
                    $lang,
                    $fields['name'],
                    $fields['slug'],
                    $fields['description'],
                    $fields['seo_title'],
                    $fields['meta_description']
                ]);
            }
            $this->db->commit();
            return $categoryId;
        } catch (Exception $e) {
            $this->db->rollBack();
            return false;
        }
    }

    public function update($id, $parentId, $data) {
        $this->db->beginTransaction();
        try {
            $stmt = $this->db->prepare("UPDATE categories SET parent_id = ? WHERE id = ?");
            $stmt->execute([$parentId, $id]);

            $stmt = $this->db->prepare("INSERT INTO category_translations (category_id, language_code, name, slug, description, seo_title, meta_description) VALUES (?, ?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE name=VALUES(name), slug=VALUES(slug), description=VALUES(description), seo_title=VALUES(seo_title), meta_description=VALUES(meta_description)");
            foreach ($data as $lang => $fields) {
                $stmt->execute([
                    $id,
                    $lang,
                    $fields['name'],
                    $fields['slug'],
                    $fields['description'],
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
        $stmt = $this->db->prepare("DELETE FROM categories WHERE id = ?");
        return $stmt->execute([$id]);
    }
}
