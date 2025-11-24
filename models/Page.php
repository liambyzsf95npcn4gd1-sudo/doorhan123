<?php
// Модель для работы со статическими страницами (Multi-language)

class Page {
    private $db;
    private $lang;

    public function __construct() {
        $this->db = Database::getInstance()->getConnection();
        $this->lang = Language::get();
    }

    public function getAll() {
        $sql = "SELECT p.id,
                       pt.title, pt.slug, pt.content, pt.seo_title, pt.meta_description
                FROM pages p
                LEFT JOIN page_translations pt ON p.id = pt.page_id AND pt.language_code = ?";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([$this->lang]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function getTranslations($id) {
        $stmt = $this->db->prepare("SELECT * FROM page_translations WHERE page_id = ?");
        $stmt->execute([$id]);
        $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
        $result = [];
        foreach ($rows as $row) {
            $result[$row['language_code']] = $row;
        }
        return $result;
    }

    public function getBySlug($slug) {
        $sql = "SELECT p.id,
                       pt.title, pt.slug, pt.content, pt.seo_title, pt.meta_description
                FROM pages p
                JOIN page_translations pt ON p.id = pt.page_id
                WHERE pt.slug = ? AND pt.language_code = ?";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([$slug, $this->lang]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    public function getById($id) {
        $sql = "SELECT p.id,
                       pt.title, pt.slug, pt.content, pt.seo_title, pt.meta_description
                FROM pages p
                LEFT JOIN page_translations pt ON p.id = pt.page_id AND pt.language_code = ?
                WHERE p.id = ?";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([$this->lang, $id]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    public function create($data) {
        $this->db->beginTransaction();
        try {
            $stmt = $this->db->prepare("INSERT INTO pages () VALUES ()");
            $stmt->execute();
            $pageId = $this->db->lastInsertId();

            $stmt = $this->db->prepare("INSERT INTO page_translations (page_id, language_code, title, slug, content, seo_title, meta_description) VALUES (?, ?, ?, ?, ?, ?, ?)");
            foreach ($data as $lang => $fields) {
                $stmt->execute([
                    $pageId,
                    $lang,
                    $fields['title'],
                    $fields['slug'],
                    $fields['content'],
                    $fields['seo_title'],
                    $fields['meta_description']
                ]);
            }
            $this->db->commit();
            return $pageId;
        } catch (Exception $e) {
            $this->db->rollBack();
            return false;
        }
    }

    public function update($id, $data) {
        $this->db->beginTransaction();
        try {
            $stmt = $this->db->prepare("INSERT INTO page_translations (page_id, language_code, title, slug, content, seo_title, meta_description) VALUES (?, ?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE title=VALUES(title), slug=VALUES(slug), content=VALUES(content), seo_title=VALUES(seo_title), meta_description=VALUES(meta_description)");
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
        $stmt = $this->db->prepare("DELETE FROM pages WHERE id = ?");
        return $stmt->execute([$id]);
    }
}
