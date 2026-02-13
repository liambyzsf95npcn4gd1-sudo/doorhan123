<?php

class Language {
    private static $current_lang = 'en';
    private static $translations = [];
    private static $supported_languages = [];
    private static $direction = 'ltr';

    public static function init() {
        // Load supported languages from DB
        try {
            $db = Database::getInstance()->getConnection();
            $stmt = $db->query("SELECT code, is_default, direction FROM languages WHERE is_active = 1");
            $langs = $stmt->fetchAll(PDO::FETCH_ASSOC);

            self::$supported_languages = [];
            foreach ($langs as $lang) {
                self::$supported_languages[$lang['code']] = $lang;
            }

            // If we have a default in DB, use it as initial value
            foreach ($langs as $lang) {
                if ($lang['is_default']) {
                    self::$current_lang = $lang['code'];
                    self::$direction = $lang['direction'];
                    break;
                }
            }

        } catch (Exception $e) {
            // Fallback if DB fails
            self::$supported_languages = ['en' => ['code'=>'en', 'direction'=>'ltr']];
        }
    }

    public static function set($lang) {
        if (empty(self::$supported_languages)) {
            self::init();
        }

        if (array_key_exists($lang, self::$supported_languages)) {
            self::$current_lang = $lang;
            self::$direction = self::$supported_languages[$lang]['direction'];
            self::loadTranslations($lang);
        }
    }

    public static function get() {
        if (empty(self::$supported_languages)) {
            self::init();
        }
        return self::$current_lang;
    }

    public static function getAll() {
        if (empty(self::$supported_languages)) {
            self::init();
        }
        return array_keys(self::$supported_languages);
    }

    public static function getList() {
        if (empty(self::$supported_languages)) {
            self::init();
        }
        return self::$supported_languages;
    }

    private static function loadTranslations($lang) {
        try {
            $db = Database::getInstance()->getConnection();
            $stmt = $db->prepare("SELECT `key`, `value` FROM ui_translations WHERE language_code = ?");
            $stmt->execute([$lang]);
            self::$translations = $stmt->fetchAll(PDO::FETCH_KEY_PAIR);
        } catch (Exception $e) {
            self::$translations = [];
        }
    }

    public static function translate($key) {
        return self::$translations[$key] ?? $key;
    }

    public static function getDirection() {
        return self::$direction;
    }
}

function __($key) {
    return Language::translate($key);
}

function url($path, $forceLang = null) {
    $lang = $forceLang ?? Language::get();
    // Ensure path starts with /
    if ($path !== '' && $path[0] !== '/') {
        $path = '/' . $path;
    }

    $defaultLang = 'en'; // Fallback
    if (defined('DEFAULT_LANGUAGE')) {
        $defaultLang = DEFAULT_LANGUAGE;
    }

    if ($path === '/' || $path === '') {
        return ($lang === $defaultLang) ? SITE_URL : SITE_URL . '/' . $lang;
    }

    $prefix = ($lang === $defaultLang) ? '' : '/' . $lang;
    return SITE_URL . $prefix . $path;
}
