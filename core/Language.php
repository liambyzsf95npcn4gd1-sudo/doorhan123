<?php

class Language {
    private static $current_lang = DEFAULT_LANGUAGE;
    private static $translations = [];

    public static function set($lang) {
        if (in_array($lang, SUPPORTED_LANGUAGES)) {
            self::$current_lang = $lang;
            self::loadTranslations($lang);
        }
    }

    public static function get() {
        return self::$current_lang;
    }

    private static function loadTranslations($lang) {
        $file = ROOT_PATH . '/languages/' . $lang . '.php';
        if (file_exists($file)) {
            self::$translations = require $file;
        } else {
            self::$translations = [];
        }
    }

    public static function translate($key) {
        return self::$translations[$key] ?? $key;
    }
}

function __($key) {
    return Language::translate($key);
}

function url($path) {
    $lang = Language::get();
    // Ensure path starts with /
    if ($path !== '' && $path[0] !== '/') {
        $path = '/' . $path;
    }

    // If path is '/', return SITE_URL (for default) or SITE_URL/lang
    if ($path === '/' || $path === '') {
        return ($lang === DEFAULT_LANGUAGE) ? SITE_URL : SITE_URL . '/' . $lang;
    }

    $prefix = ($lang === DEFAULT_LANGUAGE) ? '' : '/' . $lang;
    return SITE_URL . $prefix . $path;
}
