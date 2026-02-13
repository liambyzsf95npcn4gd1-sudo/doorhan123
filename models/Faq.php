<?php

class Faq {
    private $db;
    private $lang;

    public function __construct() {
        $this->db = Database::getInstance()->getConnection();
        $this->lang = Language::get();
    }

    public function getAllActive() {
        $sql = "SELECT f.id, f.sort_order,
                       COALESCE(ft.question, ft_en.question) as question,
                       COALESCE(ft.answer, ft_en.answer) as answer
                FROM faqs f
                LEFT JOIN faq_translations ft ON f.id = ft.faq_id AND ft.language_code = ?
                LEFT JOIN faq_translations ft_en ON f.id = ft_en.faq_id AND ft_en.language_code = 'en'
                WHERE f.is_active = 1
                ORDER BY f.sort_order ASC";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([$this->lang]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
}
