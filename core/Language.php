<?php

class Language {
    private static $instance = null;
    private $pdo;
    private $languages = [];
    private $translations = [];
    private $currentLang = 'en';

    private function __construct() {
        try {
            $this->pdo = Database::getInstance()->getConnection();
            $this->loadLanguages();
        } catch (Exception $e) {
            // Fail silently or log, fallback to English/empty
            error_log("Language initialization failed: " . $e->getMessage());
        }
    }

    public static function getInstance() {
        if (self::$instance === null) {
            self::$instance = new Language();
        }
        return self::$instance;
    }

    private function loadLanguages() {
        if ($this->pdo) {
            try {
                $stmt = $this->pdo->query("SELECT * FROM languages");
                while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
                    $this->languages[$row['code']] = $row;
                }
            } catch (PDOException $e) {
                error_log("Failed to load languages: " . $e->getMessage());
            }
        }
    }

    public static function getLanguages() {
        return self::getInstance()->languages;
    }

    public static function isSupported($code) {
        return array_key_exists($code, self::getInstance()->languages);
    }

    public static function set($code) {
        $instance = self::getInstance();
        if (array_key_exists($code, $instance->languages)) {
            $instance->currentLang = $code;
            $instance->loadTranslations($instance->languages[$code]['id']);
        }
    }

    public static function get() {
        return self::getInstance()->currentLang;
    }

    private function loadTranslations($langId) {
        if ($this->pdo) {
            try {
                $stmt = $this->pdo->prepare("SELECT `key`, `value` FROM ui_translations WHERE language_id = ?");
                $stmt->execute([$langId]);
                $this->translations = $stmt->fetchAll(PDO::FETCH_KEY_PAIR);
            } catch (PDOException $e) {
                error_log("Failed to load translations: " . $e->getMessage());
            }
        }
    }

    public static function translate($key) {
        $instance = self::getInstance();
        return $instance->translations[$key] ?? $key;
    }

    public static function getDirection() {
        return self::getInstance()->currentLang === 'ar' ? 'rtl' : 'ltr';
    }
}

// Global Helper Functions

function __($key) {
    return Language::translate($key);
}

function url($path) {
    $lang = Language::get();

    // Ensure path starts with /
    if ($path !== '' && $path[0] !== '/') {
        $path = '/' . $path;
    }

    $defaultLang = defined('DEFAULT_LANGUAGE') ? DEFAULT_LANGUAGE : 'en';

    // If path is root
    if ($path === '/' || $path === '') {
        return ($lang === $defaultLang) ? SITE_URL : SITE_URL . '/' . $lang;
    }

    // Construct URL with language prefix if not default
    $prefix = ($lang === $defaultLang) ? '' : '/' . $lang;

    // Check if SITE_URL ends with / to avoid double slash if needed, but typically SITE_URL is base.
    // Assuming SITE_URL does not have trailing slash based on config.
    return SITE_URL . $prefix . $path;
}
