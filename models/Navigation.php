<?php
// Модель для работы с элементами навигации

class Navigation {
    private $db;

    public function __construct() {
        $this->db = Database::getInstance()->getConnection();
    }

    public function getMenuItems() {
        $stmt = $this->db->query("SELECT * FROM navigation_items ORDER BY parent_id, menu_order ASC");
        $items = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Build a hierarchical array
        $menu = [];
        $children = [];

        foreach ($items as $item) {
            if ($item['parent_id'] === null) {
                $menu[$item['id']] = $item;
                $menu[$item['id']]['children'] = [];
            } else {
                $children[$item['parent_id']][] = $item;
            }
        }

        foreach ($children as $parentId => $childItems) {
            if (isset($menu[$parentId])) {
                $menu[$parentId]['children'] = $childItems;
            }
        }

        return $menu;
    }
}
