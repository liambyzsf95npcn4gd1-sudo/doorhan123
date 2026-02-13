<?php
// scripts/generate_db_init.php

define('ROOT_PATH', dirname(__DIR__));

// Helper to read file content
function readFileContent($filename) {
    return file_get_contents(ROOT_PATH . '/' . $filename);
}

// 1. Start with base schema
$sql = "-- Database Initialization for DoorHan\n\n";
$sql .= "SET FOREIGN_KEY_CHECKS = 0;\n";
$sql .= "DROP TABLE IF EXISTS `product_categories`;\n";
$sql .= "DROP TABLE IF EXISTS `product_images`;\n";
$sql .= "DROP TABLE IF EXISTS `product_translations`;\n";
$sql .= "DROP TABLE IF EXISTS `products`;\n";
$sql .= "DROP TABLE IF EXISTS `category_translations`;\n";
$sql .= "DROP TABLE IF EXISTS `categories`;\n";
$sql .= "DROP TABLE IF EXISTS `post_translations`;\n";
$sql .= "DROP TABLE IF EXISTS `posts`;\n";
$sql .= "DROP TABLE IF EXISTS `settings`;\n";
$sql .= "DROP TABLE IF EXISTS `users`;\n";
$sql .= "DROP TABLE IF EXISTS `navigation_items`;\n";
$sql .= "DROP TABLE IF EXISTS `page_translations`;\n";
$sql .= "DROP TABLE IF EXISTS `pages`;\n";
$sql .= "DROP TABLE IF EXISTS `messages`;\n";
$sql .= "DROP TABLE IF EXISTS `languages`;\n";
$sql .= "DROP TABLE IF EXISTS `ui_translations`;\n";
$sql .= "DROP TABLE IF EXISTS `faq_translations`;\n";
$sql .= "DROP TABLE IF EXISTS `faqs`;\n";
$sql .= "SET FOREIGN_KEY_CHECKS = 1;\n\n";

// Append schema.sql
$sql .= "-- Base Schema\n";
$sql .= readFileContent('schema.sql') . "\n\n";

// Append schema_i18n.sql
$sql .= "-- i18n Schema Updates\n";
$sql .= readFileContent('schema_i18n.sql') . "\n\n";


// 2. Add New Tables

$sql .= "-- New Tables for Consolidation\n";

// Languages Table
$sql .= "CREATE TABLE `languages` (\n";
$sql .= "  `id` INT AUTO_INCREMENT PRIMARY KEY,\n";
$sql .= "  `code` VARCHAR(5) NOT NULL UNIQUE,\n"; // en, es, zh, zh-CN
$sql .= "  `name` VARCHAR(50) NOT NULL,\n";
$sql .= "  `flag_icon` VARCHAR(255) DEFAULT NULL,\n"; // path to flag icon or class
$sql .= "  `is_active` TINYINT(1) DEFAULT 1,\n";
$sql .= "  `is_default` TINYINT(1) DEFAULT 0,\n";
$sql .= "  `direction` ENUM('ltr', 'rtl') DEFAULT 'ltr'\n";
$sql .= ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;\n\n";

// UI Translations Table
$sql .= "CREATE TABLE `ui_translations` (\n";
$sql .= "  `id` INT AUTO_INCREMENT PRIMARY KEY,\n";
$sql .= "  `key` VARCHAR(255) NOT NULL,\n";
$sql .= "  `language_code` VARCHAR(5) NOT NULL,\n";
$sql .= "  `value` TEXT,\n";
$sql .= "  UNIQUE KEY `unique_translation` (`key`, `language_code`),\n";
$sql .= "  KEY `language_code` (`language_code`),\n";
$sql .= "  CONSTRAINT `fk_ui_lang` FOREIGN KEY (`language_code`) REFERENCES `languages` (`code`) ON DELETE CASCADE\n";
$sql .= ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;\n\n";

// FAQs Table
$sql .= "CREATE TABLE `faqs` (\n";
$sql .= "  `id` INT AUTO_INCREMENT PRIMARY KEY,\n";
$sql .= "  `sort_order` INT DEFAULT 0,\n";
$sql .= "  `is_active` TINYINT(1) DEFAULT 1\n";
$sql .= ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;\n\n";

// FAQ Translations Table
$sql .= "CREATE TABLE `faq_translations` (\n";
$sql .= "  `id` INT AUTO_INCREMENT PRIMARY KEY,\n";
$sql .= "  `faq_id` INT NOT NULL,\n";
$sql .= "  `language_code` VARCHAR(5) NOT NULL,\n";
$sql .= "  `question` TEXT NOT NULL,\n";
$sql .= "  `answer` TEXT NOT NULL,\n";
$sql .= "  UNIQUE KEY `unique_faq_trans` (`faq_id`, `language_code`),\n";
$sql .= "  CONSTRAINT `fk_faq_id` FOREIGN KEY (`faq_id`) REFERENCES `faqs` (`id`) ON DELETE CASCADE,\n";
$sql .= "  CONSTRAINT `fk_faq_lang` FOREIGN KEY (`language_code`) REFERENCES `languages` (`code`) ON DELETE CASCADE\n";
$sql .= ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;\n\n";


// 3. Seed Data

$sql .= "-- Seed Data\n";

// Seed Languages
// We scan the languages directory to find supported languages
$langFiles = glob(ROOT_PATH . '/languages/*.php');
$languages = [];
foreach ($langFiles as $file) {
    $code = basename($file, '.php');
    $languages[] = $code;
}

// Map codes to names (simple mapping)
$langNames = [
    'en' => 'English',
    'es' => 'Español',
    'zh' => '中文', // Chinese
    'ru' => 'Русский',
    'fr' => 'Français',
    'de' => 'Deutsch',
    'it' => 'Italiano',
    'pt' => 'Português',
    'ar' => 'العربية',
    'hi' => 'हिन्दी',
    'id' => 'Bahasa Indonesia',
    'ja' => '日本語',
    'ko' => '한국어',
    // Add others if needed
];

foreach ($languages as $code) {
    $name = $langNames[$code] ?? ucfirst($code);
    $isDefault = ($code === 'en') ? 1 : 0;
    $direction = ($code === 'ar') ? 'rtl' : 'ltr';
    $flag = "flag-$code.svg"; // Placeholder

    $sql .= sprintf(
        "INSERT INTO `languages` (`code`, `name`, `is_active`, `is_default`, `direction`, `flag_icon`) VALUES ('%s', '%s', 1, %d, '%s', '%s');\n",
        $code, $name, $isDefault, $direction, $flag
    );
}
$sql .= "\n";


// Seed UI Translations and FAQs
// We need to parse the PHP arrays.

// Store FAQs to insert them later properly grouped
$faqs = []; // [index => [lang => ['q' => '...', 'a' => '...']]]

foreach ($languages as $code) {
    $trans = require ROOT_PATH . '/languages/' . $code . '.php';

    foreach ($trans as $key => $value) {
        // Check if it's an FAQ item
        if (preg_match('/^faq_q_(\d+)$/', $key, $matches)) {
            $index = $matches[1];
            $faqs[$index][$code]['question'] = $value;
        } elseif (preg_match('/^faq_a_(\d+)$/', $key, $matches)) {
            $index = $matches[1];
            $faqs[$index][$code]['answer'] = $value;
        } else {
            // Normal UI translation
            // Escape single quotes
            $safeValue = str_replace("'", "''", $value);
            $safeKey = str_replace("'", "''", $key);
            $sql .= sprintf(
                "INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('%s', '%s', '%s') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);\n",
                $safeKey, $code, $safeValue
            );
        }
    }
}
$sql .= "\n";

// Seed FAQs
foreach ($faqs as $index => $langData) {
    $sql .= "INSERT INTO `faqs` (`sort_order`, `is_active`) VALUES ($index, 1);\n";
    $sql .= "SET @last_faq_id = LAST_INSERT_ID();\n";

    foreach ($langData as $code => $qa) {
        if (isset($qa['question']) && isset($qa['answer'])) {
             $safeQ = str_replace("'", "''", $qa['question']);
             $safeA = str_replace("'", "''", $qa['answer']);
             $sql .= sprintf(
                "INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, '%s', '%s', '%s');\n",
                $code, $safeQ, $safeA
             );
        }
    }
}
$sql .= "\n";

// Append seed_i18n.sql (which contains products, categories, pages, etc.)
// Note: seed_i18n.sql truncates tables. We should make sure we don't truncate the new tables we just filled if seed_i18n included them (it doesn't).
// But seed_i18n truncates `users`, `settings`, etc. So we should append it.
// However, seed_i18n.sql TRUNCATES tables. So if we put it here, it's fine as long as it doesn't truncate `ui_translations`.
// It doesn't truncate `ui_translations` because it didn't know about it.

$sql .= "-- Existing Seed Data\n";
$sql .= readFileContent('seed_i18n.sql') . "\n";

// Write result
file_put_contents(ROOT_PATH . '/database_init.sql', $sql);

echo "database_init.sql generated successfully.\n";
