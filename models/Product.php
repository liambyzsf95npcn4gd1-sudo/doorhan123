<?php
// Модель для работы с товарами (Multi-language support)

class Product {
    private $db;
    private $lang;

    public function __construct() {
        $this->db = Database::getInstance()->getConnection();
        $this->lang = Language::get();
    }

    public function getAll() {
        $sql = "SELECT p.id, p.status, p.created_at,
                       pt.name, pt.slug, pt.content, pt.seo_title, pt.meta_description,
                       pt.max_width, pt.max_height, pt.panel_thickness, pt.insulation
                FROM products p
                LEFT JOIN product_translations pt ON p.id = pt.product_id AND pt.language_code = ?";
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
                       pt.name, pt.slug, pt.content, pt.seo_title, pt.meta_description
                FROM products p
                LEFT JOIN product_translations pt ON p.id = pt.product_id AND pt.language_code = ?
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
        $sql = "SELECT p.id, p.status, p.created_at,
                       pt.name, pt.slug, pt.content, pt.seo_title, pt.meta_description,
                       pt.max_width, pt.max_height, pt.panel_thickness, pt.insulation
                FROM products p
                JOIN product_translations pt ON p.id = pt.product_id
                WHERE pt.slug = ? AND pt.language_code = ? AND p.status = 'active'";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([$slug, $this->lang]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    public function getById($id) {
        $sql = "SELECT p.id, p.status, p.created_at,
                       pt.name, pt.slug, pt.content, pt.seo_title, pt.meta_description,
                       pt.max_width, pt.max_height, pt.panel_thickness, pt.insulation
                FROM products p
                LEFT JOIN product_translations pt ON p.id = pt.product_id AND pt.language_code = ?
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

    /**
     * Create product with translations
     * $data needs to be an array keyed by language code:
     * $data['en'] = ['name' => ..., 'slug' => ..., ...]
     */
    public function create($status, $data) {
        $this->db->beginTransaction();
        try {
            // 1. Insert into products
            $stmt = $this->db->prepare("INSERT INTO products (status) VALUES (?)");
            $stmt->execute([$status]);
            $productId = $this->db->lastInsertId();

            // 2. Insert translations
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
            // 1. Update products status
            $stmt = $this->db->prepare("UPDATE products SET status = ? WHERE id = ?");
            $stmt->execute([$status, $id]);

            // 2. Update translations (upsert logic)
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
