<?php
// Модель для работы с категориями (Multi-language with Fallback)

class Category {
    private $db;
    private $lang;

    public function __construct() {
        $this->db = Database::getInstance()->getConnection();
        $this->lang = Language::get();
    }

    public function getAll() {
        $sql = "SELECT c.id, c.parent_id,
                       COALESCE(ct.name, ct_en.name) as name,
                       COALESCE(ct.slug, ct_en.slug) as slug,
                       COALESCE(ct.description, ct_en.description) as description,
                       COALESCE(ct.seo_title, ct_en.seo_title) as seo_title,
                       COALESCE(ct.meta_description, ct_en.meta_description) as meta_description
                FROM categories c
                LEFT JOIN category_translations ct ON c.id = ct.category_id AND ct.language_code = ?
                LEFT JOIN category_translations ct_en ON c.id = ct_en.category_id AND ct_en.language_code = 'en'";
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
        // Find ID first
        $stmt = $this->db->prepare("
            SELECT c.id
            FROM categories c
            LEFT JOIN category_translations ct ON c.id = ct.category_id AND ct.language_code = ?
            LEFT JOIN category_translations ct_en ON c.id = ct_en.category_id AND ct_en.language_code = 'en'
            WHERE (ct.slug = ? OR ct_en.slug = ?)
        ");
        $stmt->execute([$this->lang, $slug, $slug]);
        $id = $stmt->fetchColumn();

        if (!$id) return false;

        return $this->getById($id);
    }

    public function getById($id) {
        $sql = "SELECT c.id, c.parent_id,
                       COALESCE(ct.name, ct_en.name) as name,
                       COALESCE(ct.slug, ct_en.slug) as slug,
                       COALESCE(ct.description, ct_en.description) as description,
                       COALESCE(ct.seo_title, ct_en.seo_title) as seo_title,
                       COALESCE(ct.meta_description, ct_en.meta_description) as meta_description
                FROM categories c
                LEFT JOIN category_translations ct ON c.id = ct.category_id AND ct.language_code = ?
                LEFT JOIN category_translations ct_en ON c.id = ct_en.category_id AND ct_en.language_code = 'en'
                WHERE c.id = ?";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([$this->lang, $id]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    public function getProductsByCategoryId($categoryId) {
        // Also needs fallback for Product data!
        $sql = "SELECT p.id, p.status, p.created_at,
                       COALESCE(pt.name, pt_en.name) as name,
                       COALESCE(pt.slug, pt_en.slug) as slug,
                       COALESCE(pt.content, pt_en.content) as content,
                       COALESCE(pt.seo_title, pt_en.seo_title) as seo_title,
                       COALESCE(pt.meta_description, pt_en.meta_description) as meta_description,
                       COALESCE(pt.max_width, pt_en.max_width) as max_width,
                       COALESCE(pt.max_height, pt_en.max_height) as max_height,
                       COALESCE(pt.panel_thickness, pt_en.panel_thickness) as panel_thickness,
                       COALESCE(pt.insulation, pt_en.insulation) as insulation,
                       pi.image_path as image
                FROM products p
                JOIN product_categories pc ON p.id = pc.product_id
                LEFT JOIN product_translations pt ON p.id = pt.product_id AND pt.language_code = ?
                LEFT JOIN product_translations pt_en ON p.id = pt_en.product_id AND pt_en.language_code = 'en'
                LEFT JOIN product_images pi ON p.id = pi.product_id AND pi.sort_order = 0
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
