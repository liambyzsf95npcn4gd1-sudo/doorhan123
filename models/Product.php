<?php
// Модель для работы с товарами (Multi-language support with Fallback)

class Product {
    private $db;
    private $lang;

    public function __construct() {
        $this->db = Database::getInstance()->getConnection();
        $this->lang = Language::get();
    }

    public function getAll() {
        $sql = "SELECT p.id, p.status, p.created_at,
                       COALESCE(pt.name, pt_en.name) as name,
                       COALESCE(pt.slug, pt_en.slug) as slug,
                       COALESCE(pt.content, pt_en.content) as content,
                       COALESCE(pt.seo_title, pt_en.seo_title) as seo_title,
                       COALESCE(pt.meta_description, pt_en.meta_description) as meta_description,
                       COALESCE(pt.max_width, pt_en.max_width) as max_width,
                       COALESCE(pt.max_height, pt_en.max_height) as max_height,
                       COALESCE(pt.panel_thickness, pt_en.panel_thickness) as panel_thickness,
                       COALESCE(pt.insulation, pt_en.insulation) as insulation
                FROM products p
                LEFT JOIN product_translations pt ON p.id = pt.product_id AND pt.language_code = ?
                LEFT JOIN product_translations pt_en ON p.id = pt_en.product_id AND pt_en.language_code = 'en'";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([$this->lang]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    // Helper to get raw translations for admin
    public function getTranslations($id) {
        $stmt = $this->db->prepare("SELECT * FROM product_translations WHERE product_id = ?");
        $stmt->execute([$id]);
        $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
        $result = [];
        foreach ($rows as $row) {
            $result[$row['language_code']] = $row;
        }
        return $result;
    }

    public function getAllActive($limit = 10, $offset = 0) {
        $sql = "SELECT p.id, p.status, p.created_at,
                       COALESCE(pt.name, pt_en.name) as name,
                       COALESCE(pt.slug, pt_en.slug) as slug,
                       COALESCE(pt.content, pt_en.content) as content,
                       COALESCE(pt.seo_title, pt_en.seo_title) as seo_title,
                       COALESCE(pt.meta_description, pt_en.meta_description) as meta_description
                FROM products p
                LEFT JOIN product_translations pt ON p.id = pt.product_id AND pt.language_code = ?
                LEFT JOIN product_translations pt_en ON p.id = pt_en.product_id AND pt_en.language_code = 'en'
                WHERE p.status = 'active'
                ORDER BY p.created_at DESC
                LIMIT " . (int)$limit . " OFFSET " . (int)$offset;
        $stmt = $this->db->prepare($sql);
        $stmt->execute([$this->lang]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function countAllActive() {
        $stmt = $this->db->prepare("SELECT COUNT(*) FROM products WHERE status = 'active'");
        $stmt->execute();
        return $stmt->fetchColumn();
    }

    public function getBySlug($slug) {
        // First find ID by checking both localized and English slug
        $stmt = $this->db->prepare("
            SELECT p.id
            FROM products p
            LEFT JOIN product_translations pt ON p.id = pt.product_id AND pt.language_code = ?
            LEFT JOIN product_translations pt_en ON p.id = pt_en.product_id AND pt_en.language_code = 'en'
            WHERE (pt.slug = ? OR pt_en.slug = ?) AND p.status = 'active'
        ");
        $stmt->execute([$this->lang, $slug, $slug]);
        $id = $stmt->fetchColumn();

        if (!$id) return false;

        return $this->getById($id);
    }

    public function getById($id) {
        $sql = "SELECT p.id, p.status, p.created_at,
                       COALESCE(pt.name, pt_en.name) as name,
                       COALESCE(pt.slug, pt_en.slug) as slug,
                       COALESCE(pt.content, pt_en.content) as content,
                       COALESCE(pt.seo_title, pt_en.seo_title) as seo_title,
                       COALESCE(pt.meta_description, pt_en.meta_description) as meta_description,
                       COALESCE(pt.max_width, pt_en.max_width) as max_width,
                       COALESCE(pt.max_height, pt_en.max_height) as max_height,
                       COALESCE(pt.panel_thickness, pt_en.panel_thickness) as panel_thickness,
                       COALESCE(pt.insulation, pt_en.insulation) as insulation
                FROM products p
                LEFT JOIN product_translations pt ON p.id = pt.product_id AND pt.language_code = ?
                LEFT JOIN product_translations pt_en ON p.id = pt_en.product_id AND pt_en.language_code = 'en'
                WHERE p.id = ?";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([$this->lang, $id]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    public function getImages($productId) {
        $stmt = $this->db->prepare("SELECT * FROM product_images WHERE product_id = ?");
        $stmt->execute([$productId]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function create($status, $data) {
        $this->db->beginTransaction();
        try {
            $stmt = $this->db->prepare("INSERT INTO products (status) VALUES (?)");
            $stmt->execute([$status]);
            $productId = $this->db->lastInsertId();

            $stmt = $this->db->prepare("INSERT INTO product_translations (product_id, language_code, name, slug, content, seo_title, meta_description, max_width, max_height, panel_thickness, insulation) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");

            foreach ($data as $lang => $fields) {
                $stmt->execute([
                    $productId,
                    $lang,
                    $fields['name'],
                    $fields['slug'],
                    $fields['content'],
                    $fields['seo_title'],
                    $fields['meta_description'],
                    $fields['max_width'],
                    $fields['max_height'],
                    $fields['panel_thickness'],
                    $fields['insulation']
                ]);
            }

            $this->db->commit();
            return $productId;
        } catch (Exception $e) {
            $this->db->rollBack();
            return false;
        }
    }

    public function update($id, $status, $data) {
        $this->db->beginTransaction();
        try {
            $stmt = $this->db->prepare("UPDATE products SET status = ? WHERE id = ?");
            $stmt->execute([$status, $id]);

            $stmt = $this->db->prepare("INSERT INTO product_translations (product_id, language_code, name, slug, content, seo_title, meta_description, max_width, max_height, panel_thickness, insulation) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE name=VALUES(name), slug=VALUES(slug), content=VALUES(content), seo_title=VALUES(seo_title), meta_description=VALUES(meta_description), max_width=VALUES(max_width), max_height=VALUES(max_height), panel_thickness=VALUES(panel_thickness), insulation=VALUES(insulation)");

            foreach ($data as $lang => $fields) {
                 $stmt->execute([
                    $id,
                    $lang,
                    $fields['name'],
                    $fields['slug'],
                    $fields['content'],
                    $fields['seo_title'],
                    $fields['meta_description'],
                    $fields['max_width'],
                    $fields['max_height'],
                    $fields['panel_thickness'],
                    $fields['insulation']
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
        $stmt = $this->db->prepare("DELETE FROM products WHERE id = ?");
        return $stmt->execute([$id]);
    }

    public function setCategories($productId, $categoryIds) {
        $stmt = $this->db->prepare("DELETE FROM product_categories WHERE product_id = ?");
        $stmt->execute([$productId]);

        if (!empty($categoryIds)) {
            $stmt = $this->db->prepare("INSERT INTO product_categories (product_id, category_id) VALUES (?, ?)");
            foreach ($categoryIds as $categoryId) {
                $stmt->execute([$productId, $categoryId]);
            }
        }
    }

    public function getCategoryIds($productId) {
        $stmt = $this->db->prepare("SELECT category_id FROM product_categories WHERE product_id = ?");
        $stmt->execute([$productId]);
        return $stmt->fetchAll(PDO::FETCH_COLUMN);
    }
}
