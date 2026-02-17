-- Database Initialization for DoorHan

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS `product_categories`;
DROP TABLE IF EXISTS `product_images`;
DROP TABLE IF EXISTS `product_translations`;
DROP TABLE IF EXISTS `products`;
DROP TABLE IF EXISTS `category_translations`;
DROP TABLE IF EXISTS `categories`;
DROP TABLE IF EXISTS `post_translations`;
DROP TABLE IF EXISTS `posts`;
DROP TABLE IF EXISTS `settings`;
DROP TABLE IF EXISTS `users`;
DROP TABLE IF EXISTS `navigation_items`;
DROP TABLE IF EXISTS `page_translations`;
DROP TABLE IF EXISTS `pages`;
DROP TABLE IF EXISTS `messages`;
DROP TABLE IF EXISTS `languages`;
DROP TABLE IF EXISTS `ui_translations`;
DROP TABLE IF EXISTS `faq_translations`;
DROP TABLE IF EXISTS `faqs`;
SET FOREIGN_KEY_CHECKS = 1;

-- Base Schema
--
-- Структура базы данных для сайта DoorHan
--

-- Таблица для категорий товаров
CREATE TABLE `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `description` text,
  `seo_title` varchar(255) DEFAULT NULL,
  `meta_description` varchar(255) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `parent_id` (`parent_id`),
  CONSTRAINT `categories_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Таблица для товаров
CREATE TABLE `products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `content` text,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `seo_title` varchar(255) DEFAULT NULL,
  `meta_description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Таблица для связи товаров и категорий
CREATE TABLE `product_categories` (
  `product_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `is_primary` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`product_id`,`category_id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `product_categories_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `product_categories_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Таблица для изображений товаров
-- Таблица для изображений товаров
CREATE TABLE `product_images` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `image_path` varchar(255) NOT NULL,
  `sort_order` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `product_images_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Таблица для статических страниц
CREATE TABLE `pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `slug` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` text,
  `seo_title` varchar(255) DEFAULT NULL,
  `meta_description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Таблица для новостей (блог)
CREATE TABLE `posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `slug` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` text,
  `status` enum('draft','published') NOT NULL DEFAULT 'draft',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `image` varchar(255) DEFAULT NULL,
  `image2` varchar(255) DEFAULT NULL,
  `image3` varchar(255) DEFAULT NULL,
  `seo_title` varchar(255) DEFAULT NULL,
  `meta_description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Таблица для сообщений из контактной формы
CREATE TABLE `messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `message` text NOT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Таблица для настроек сайта
CREATE TABLE `settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(50) NOT NULL,
  `value` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Таблица для пользователей (администратор)
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(50) NOT NULL DEFAULT 'editor',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Таблица для элементов навигации
CREATE TABLE `navigation_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `url` varchar(255) NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `menu_order` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `parent_id` (`parent_id`),
  CONSTRAINT `navigation_items_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `navigation_items` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- i18n Schema Updates
-- Multi-language support schema updates

-- 1. Product Translations
CREATE TABLE `product_translations` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `product_id` INT NOT NULL,
    `language_code` VARCHAR(2) NOT NULL DEFAULT 'en',
    `name` VARCHAR(255) NOT NULL,
    `slug` VARCHAR(255) NOT NULL,
    `content` TEXT,
    `seo_title` VARCHAR(255),
    `meta_description` VARCHAR(255),
    `max_width` VARCHAR(255),
    `max_height` VARCHAR(255),
    `panel_thickness` VARCHAR(255),
    `insulation` VARCHAR(255),
    UNIQUE KEY `product_lang_slug` (`language_code`, `slug`),
    UNIQUE KEY `product_lang_id` (`product_id`, `language_code`),
    CONSTRAINT `fk_product_trans` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Migrate existing product data to 'en'
-- Note: New fields (max_width, etc.) are not in original table, so we don't select them.
INSERT INTO `product_translations` (product_id, language_code, name, slug, content, seo_title, meta_description)
SELECT id, 'en', name, slug, content, seo_title, meta_description FROM products;

-- 2. Category Translations
CREATE TABLE `category_translations` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `category_id` INT NOT NULL,
    `language_code` VARCHAR(2) NOT NULL DEFAULT 'en',
    `name` VARCHAR(255) NOT NULL,
    `slug` VARCHAR(255) NOT NULL,
    `description` TEXT,
    `seo_title` VARCHAR(255),
    `meta_description` VARCHAR(255),
    UNIQUE KEY `category_lang_slug` (`language_code`, `slug`),
    UNIQUE KEY `category_lang_id` (`category_id`, `language_code`),
    CONSTRAINT `fk_category_trans` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Migrate existing category data
INSERT INTO `category_translations` (category_id, language_code, name, slug, description, seo_title, meta_description)
SELECT id, 'en', name, slug, description, seo_title, meta_description FROM categories;

-- 3. Page Translations
CREATE TABLE `page_translations` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `page_id` INT NOT NULL,
    `language_code` VARCHAR(2) NOT NULL DEFAULT 'en',
    `title` VARCHAR(255) NOT NULL,
    `slug` VARCHAR(255) NOT NULL,
    `content` TEXT,
    `seo_title` VARCHAR(255),
    `meta_description` VARCHAR(255),
    `image` VARCHAR(255) DEFAULT NULL,
    UNIQUE KEY `page_lang_slug` (`language_code`, `slug`),
    UNIQUE KEY `page_lang_id` (`page_id`, `language_code`),
    CONSTRAINT `fk_page_trans` FOREIGN KEY (`page_id`) REFERENCES `pages` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Migrate existing page data
INSERT INTO `page_translations` (page_id, language_code, title, slug, content, seo_title, meta_description)
SELECT id, 'en', title, slug, content, seo_title, meta_description FROM pages;

-- 4. Post Translations
CREATE TABLE `post_translations` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `post_id` INT NOT NULL,
    `language_code` VARCHAR(2) NOT NULL DEFAULT 'en',
    `title` VARCHAR(255) NOT NULL,
    `slug` VARCHAR(255) NOT NULL,
    `content` TEXT,
    `seo_title` VARCHAR(255),
    `meta_description` VARCHAR(255),
    UNIQUE KEY `post_lang_slug` (`language_code`, `slug`),
    UNIQUE KEY `post_lang_id` (`post_id`, `language_code`),
    CONSTRAINT `fk_post_trans` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Migrate existing post data
INSERT INTO `post_translations` (post_id, language_code, title, slug, content, seo_title, meta_description)
SELECT id, 'en', title, slug, content, seo_title, meta_description FROM posts;

-- Drop old columns
ALTER TABLE products DROP COLUMN name, DROP COLUMN slug, DROP COLUMN content, DROP COLUMN seo_title, DROP COLUMN meta_description;
ALTER TABLE categories DROP COLUMN name, DROP COLUMN slug, DROP COLUMN description, DROP COLUMN seo_title, DROP COLUMN meta_description;
ALTER TABLE pages DROP COLUMN title, DROP COLUMN slug, DROP COLUMN content, DROP COLUMN seo_title, DROP COLUMN meta_description;
ALTER TABLE posts DROP COLUMN title, DROP COLUMN slug, DROP COLUMN content, DROP COLUMN seo_title, DROP COLUMN meta_description;


-- New Tables for Consolidation
CREATE TABLE `languages` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `code` VARCHAR(5) NOT NULL UNIQUE,
  `name` VARCHAR(50) NOT NULL,
  `flag_icon` VARCHAR(255) DEFAULT NULL,
  `is_active` TINYINT(1) DEFAULT 1,
  `is_default` TINYINT(1) DEFAULT 0,
  `direction` ENUM('ltr', 'rtl') DEFAULT 'ltr'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `ui_translations` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `key` VARCHAR(255) NOT NULL,
  `language_code` VARCHAR(5) NOT NULL,
  `value` TEXT,
  UNIQUE KEY `unique_translation` (`key`, `language_code`),
  KEY `language_code` (`language_code`),
  CONSTRAINT `fk_ui_lang` FOREIGN KEY (`language_code`) REFERENCES `languages` (`code`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `faqs` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `sort_order` INT DEFAULT 0,
  `is_active` TINYINT(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `faq_translations` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `faq_id` INT NOT NULL,
  `language_code` VARCHAR(5) NOT NULL,
  `question` TEXT NOT NULL,
  `answer` TEXT NOT NULL,
  UNIQUE KEY `unique_faq_trans` (`faq_id`, `language_code`),
  CONSTRAINT `fk_faq_id` FOREIGN KEY (`faq_id`) REFERENCES `faqs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_faq_lang` FOREIGN KEY (`language_code`) REFERENCES `languages` (`code`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Seed Data
INSERT INTO `languages` (`code`, `name`, `is_active`, `is_default`, `direction`, `flag_icon`) VALUES ('ar', 'العربية', 1, 0, 'rtl', 'flag-ar.svg');
INSERT INTO `languages` (`code`, `name`, `is_active`, `is_default`, `direction`, `flag_icon`) VALUES ('de', 'Deutsch', 1, 0, 'ltr', 'flag-de.svg');
INSERT INTO `languages` (`code`, `name`, `is_active`, `is_default`, `direction`, `flag_icon`) VALUES ('en', 'English', 1, 1, 'ltr', 'flag-en.svg');
INSERT INTO `languages` (`code`, `name`, `is_active`, `is_default`, `direction`, `flag_icon`) VALUES ('es', 'Español', 1, 0, 'ltr', 'flag-es.svg');
INSERT INTO `languages` (`code`, `name`, `is_active`, `is_default`, `direction`, `flag_icon`) VALUES ('fr', 'Français', 1, 0, 'ltr', 'flag-fr.svg');
INSERT INTO `languages` (`code`, `name`, `is_active`, `is_default`, `direction`, `flag_icon`) VALUES ('hi', 'हिन्दी', 1, 0, 'ltr', 'flag-hi.svg');
INSERT INTO `languages` (`code`, `name`, `is_active`, `is_default`, `direction`, `flag_icon`) VALUES ('id', 'Bahasa Indonesia', 1, 0, 'ltr', 'flag-id.svg');
INSERT INTO `languages` (`code`, `name`, `is_active`, `is_default`, `direction`, `flag_icon`) VALUES ('it', 'Italiano', 1, 0, 'ltr', 'flag-it.svg');
INSERT INTO `languages` (`code`, `name`, `is_active`, `is_default`, `direction`, `flag_icon`) VALUES ('ja', '日本語', 1, 0, 'ltr', 'flag-ja.svg');
INSERT INTO `languages` (`code`, `name`, `is_active`, `is_default`, `direction`, `flag_icon`) VALUES ('ko', '한국어', 1, 0, 'ltr', 'flag-ko.svg');
INSERT INTO `languages` (`code`, `name`, `is_active`, `is_default`, `direction`, `flag_icon`) VALUES ('pt', 'Português', 1, 0, 'ltr', 'flag-pt.svg');
INSERT INTO `languages` (`code`, `name`, `is_active`, `is_default`, `direction`, `flag_icon`) VALUES ('zh', '中文', 1, 0, 'ltr', 'flag-zh.svg');

INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Home', 'ar', 'الرئيسية') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Products', 'ar', 'المنتجات') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('News', 'ar', 'الأخبار') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('About', 'ar', 'من نحن') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Contact', 'ar', 'اتصل بنا') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Privacy Policy', 'ar', 'سياسة الخصوصية') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Read More', 'ar', 'اقرأ المزيد') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Learn More', 'ar', 'اعرف المزيد') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Featured Products', 'ar', 'منتجات مميزة') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Latest News', 'ar', 'آخر الأخبار') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Our Factories', 'ar', 'مصانعنا') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Questions', 'ar', 'أسئلة مكررة') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Request a Quote', 'ar', 'طلب عرض أسعار') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Technical Specifications', 'ar', 'المواصفات الفنية') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Max Width', 'ar', 'أقصى عرض') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Max Height', 'ar', 'أقصى ارتفاع') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Panel Thickness', 'ar', 'سمك اللوحة') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Insulation', 'ar', 'العزل') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Go to website', 'ar', 'اذهب إلى الموقع') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Quality', 'ar', 'الجودة') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Innovation', 'ar', 'الابتكار') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Global Network', 'ar', 'شبكة عالمية') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Find Dealer', 'ar', 'ابحث عن وكيل') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Connect With Us', 'ar', 'تواصل معنا') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Quick Links', 'ar', 'روابط سريعة') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Regional Websites', 'ar', 'مواقع إقليمية') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('All rights reserved', 'ar', 'جميع الحقوق محفوظة.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Factories', 'ar', 'المصانع') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Solutions', 'ar', 'الحلول') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Czech Republic', 'ar', 'الجمهورية التشيكية') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('China', 'ar', 'الصين') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('UAE', 'ar', 'الإمارات') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Germany', 'ar', 'ألمانيا') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Latvia', 'ar', 'لاتفيا') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('France', 'ar', 'فرنسا') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cookie_message', 'ar', 'نستخدم ملفات تعريف الارتباط لضمان حصولك على أفضل تجربة على موقعنا.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cookie_btn', 'ar', 'فهمت!') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_title_1', 'ar', '30+ عاماً من البوابات والأتمتة عالية الجودة') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_btn_1', 'ar', 'استكشف المنتجات') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_title_2', 'ar', 'حلول مبتكرة لكل احتياج') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_btn_2', 'ar', 'اكتشف مجموعتنا') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_title_3', 'ar', 'رائد عالمي في الأبواب والأتمتة') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_btn_3', 'ar', 'اتصل بنا') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('about_us_title', 'ar', 'من نحن') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('quality_title', 'ar', 'الجودة') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('quality_desc', 'ar', 'نحن ملتزمون بتقديم منتجات بأعلى جودة.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('innovation_title', 'ar', 'الابتكار') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('innovation_desc', 'ar', 'يقوم فريقنا باستمرار بتطوير حلول جديدة ومبتكرة.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('global_network_title', 'ar', 'شبكة عالمية') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('global_network_desc', 'ar', 'مع وجود في أكثر من 30 دولة، تضمن شبكتنا العالمية الخدمة في جميع أنحاء العالم.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('websites_title', 'ar', 'قم بزيارة المواقع التالية للشراء') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cz_title', 'ar', 'الجمهورية التشيكية') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cz_item_1', 'ar', 'أبواب مقطعية') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cz_item_2', 'ar', 'مصاريع دوارة') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cn_title', 'ar', 'الصين') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cn_item_1', 'ar', 'أبواب صناعية') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cn_item_2', 'ar', 'بوابات منزلقة') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('ae_title', 'ar', 'الإمارات') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('ae_item_1', 'ar', 'أبواب المرآب') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('ae_item_2', 'ar', 'الأتمتة') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_featured_products', 'ar', 'لا توجد منتجات مميزة حالياً.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_news', 'ar', 'لا توجد أخبار حديثة.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('faq_title', 'ar', 'أسئلة مكررة') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('factories_title', 'ar', 'مصانعنا') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('dubai_title', 'ar', 'دبي') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('dubai_desc', 'ar', 'ينتج مصنعنا المتطور في دبي مجموعة واسعة من المنتجات.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('czech_title', 'ar', 'الجمهورية التشيكية') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('czech_desc', 'ar', 'مصنعنا في جمهورية التشيك هو مركز رئيسي لأوروبا.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('china_title', 'ar', 'الصين') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('china_desc', 'ar', 'مصنعنا في الصين هو مركز إنتاج رئيسي لآسيا.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('contact_us_title', 'ar', 'اتصل بنا') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('send_message_title', 'ar', 'أرسل لنا رسالة') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('name_placeholder', 'ar', 'اسمك') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('email_placeholder', 'ar', 'بريدك الإلكتروني') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('phone_placeholder', 'ar', 'هاتفك (اختياري)') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('message_placeholder', 'ar', 'رسالتك') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('send_btn', 'ar', 'إرسال الرسالة') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('contact_info_title', 'ar', 'معلومات الاتصال') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('address_label', 'ar', 'العنوان') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('phone_label', 'ar', 'الهاتف') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('email_label', 'ar', 'البريد الإلكتروني') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('address_value', 'ar', '123 DoorHan Way, Gate City, 12345') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('about_doorhan_title', 'ar', 'عن DoorHan') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('about_doorhan_desc', 'ar', 'DoorHan هي شركة عالمية رائدة في تصنيع البوابات والأبواب وأنظمة الأتمتة.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('mission_desc', 'ar', 'مهمتنا هي تزويد عملائنا بمنتجات عالية الجودة.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('factories_placeholder', 'ar', 'هذا عنصر نائب لصفحة المصانع.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('solutions_title', 'ar', 'الحلول') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('solutions_placeholder', 'ar', 'هذا عنصر نائب لصفحة الحلول.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('our_products_title', 'ar', 'منتجاتنا') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('view_more', 'ar', 'عرض المزيد') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_categories', 'ar', 'لم يتم العثور على فئات منتجات.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('product_not_found_title', 'ar', 'المنتج غير موجود') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('product_not_found_desc', 'ar', 'المنتج الذي تبحث عنه غير موجود.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('specifications_tab', 'ar', 'المواصفات') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('send_request_btn', 'ar', 'إرسال الطلب') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_news_posts', 'ar', 'لم يتم العثور على أخبار.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('previous_btn', 'ar', 'السابق') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('next_btn', 'ar', 'التالي') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('products_in_category', 'ar', 'المنتجات في هذه الفئة') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('view_details', 'ar', 'عرض التفاصيل') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('post_not_found_title', 'ar', 'المقال غير موجود') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('post_not_found_desc', 'ar', 'المقال غير موجود.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('related_posts_title', 'ar', 'مقالات ذات صلة') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Home', 'de', 'Startseite') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Products', 'de', 'Produkte') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('News', 'de', 'Nachrichten') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('About', 'de', 'Über uns') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Contact', 'de', 'Kontakt') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Privacy Policy', 'de', 'Datenschutzrichtlinie') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Read More', 'de', 'Weiterlesen') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Learn More', 'de', 'Mehr erfahren') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Featured Products', 'de', 'Ausgewählte Produkte') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Latest News', 'de', 'Aktuelle Nachrichten') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Our Factories', 'de', 'Unsere Fabriken') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Questions', 'de', 'Häufig gestellte Fragen') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Request a Quote', 'de', 'Angebot anfordern') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Technical Specifications', 'de', 'Technische Daten') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Max Width', 'de', 'Max. Breite') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Max Height', 'de', 'Max. Höhe') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Panel Thickness', 'de', 'Plattenstärke') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Insulation', 'de', 'Isolierung') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Go to website', 'de', 'Zur Website') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Quality', 'de', 'Qualität') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Innovation', 'de', 'Innovation') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Global Network', 'de', 'Globales Netzwerk') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Find Dealer', 'de', 'Händler finden') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Connect With Us', 'de', 'Verbinden Sie sich mit uns') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Quick Links', 'de', 'Schnelllinks') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Regional Websites', 'de', 'Regionale Websites') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('All rights reserved', 'de', 'Alle Rechte vorbehalten.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Factories', 'de', 'Fabriken') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Solutions', 'de', 'Lösungen') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Czech Republic', 'de', 'Tschechische Republik') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('China', 'de', 'China') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('UAE', 'de', 'VAE') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Germany', 'de', 'Deutschland') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Latvia', 'de', 'Lettland') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('France', 'de', 'Frankreich') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cookie_message', 'de', 'Wir verwenden Cookies, um Ihnen das beste Erlebnis auf unserer Website zu bieten.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cookie_btn', 'de', 'Verstanden!') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_title_1', 'de', '30+ Jahre Qualitätstore & Automatisierung') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_btn_1', 'de', 'Produkte erkunden') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_title_2', 'de', 'Innovative Lösungen für jeden Bedarf') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_btn_2', 'de', 'Entdecken Sie unser Sortiment') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_title_3', 'de', 'Weltweiter Marktführer bei Türen und Automatisierung') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_btn_3', 'de', 'Kontaktieren Sie uns') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('about_us_title', 'de', 'Über uns') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('quality_title', 'de', 'Qualität') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('quality_desc', 'de', 'Wir verpflichten uns, Produkte von höchster Qualität anzubieten.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('innovation_title', 'de', 'Innovation') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('innovation_desc', 'de', 'Unser Team entwickelt ständig neue und innovative Lösungen.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('global_network_title', 'de', 'Globales Netzwerk') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('global_network_desc', 'de', 'Mit Präsenz in über 30 Ländern sichert unser Netzwerk den weltweiten Service.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('websites_title', 'de', 'Besuchen Sie die folgenden Websites zum Kauf') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cz_title', 'de', 'Tschechische Republik') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cz_item_1', 'de', 'Sektionaltore') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cz_item_2', 'de', 'Rollläden') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cn_title', 'de', 'China') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cn_item_1', 'de', 'Industrietore') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cn_item_2', 'de', 'Schiebetore') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('ae_title', 'de', 'VAE') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('ae_item_1', 'de', 'Garagentore') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('ae_item_2', 'de', 'Automatisierung') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_featured_products', 'de', 'Derzeit keine ausgewählten Produkte verfügbar.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_news', 'de', 'Keine aktuellen Nachrichten.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('faq_title', 'de', 'Häufig gestellte Fragen') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('factories_title', 'de', 'Unsere Fabriken') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('dubai_title', 'de', 'Dubai') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('dubai_desc', 'de', 'Unsere hochmoderne Fabrik in Dubai produziert eine breite Palette von Produkten.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('czech_title', 'de', 'Tschechische Republik') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('czech_desc', 'de', 'Unsere Fabrik in der Tschechischen Republik ist ein wichtiger Knotenpunkt für Europa.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('china_title', 'de', 'China') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('china_desc', 'de', 'Unsere Fabrik in China ist ein wichtiges Produktionszentrum für Asien.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('contact_us_title', 'de', 'Kontaktieren Sie uns') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('send_message_title', 'de', 'Senden Sie uns eine Nachricht') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('name_placeholder', 'de', 'Ihr Name') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('email_placeholder', 'de', 'Ihre E-Mail') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('phone_placeholder', 'de', 'Ihr Telefon (optional)') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('message_placeholder', 'de', 'Ihre Nachricht') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('send_btn', 'de', 'Nachricht senden') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('contact_info_title', 'de', 'Kontaktinformationen') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('address_label', 'de', 'Adresse') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('phone_label', 'de', 'Telefon') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('email_label', 'de', 'E-Mail') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('address_value', 'de', '123 DoorHan Way, Gate City, 12345') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('about_doorhan_title', 'de', 'Über DoorHan') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('about_doorhan_desc', 'de', 'DoorHan ist ein weltweit führender Hersteller von Toren, Türen und Automatisierungssystemen.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('mission_desc', 'de', 'Unsere Mission ist es, unseren Kunden hochwertige Produkte anzubieten.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('factories_placeholder', 'de', 'Dies ist ein Platzhalter für die Fabrikseite.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('solutions_title', 'de', 'Lösungen') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('solutions_placeholder', 'de', 'Dies ist ein Platzhalter für die Lösungsseite.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('our_products_title', 'de', 'Unsere Produkte') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('view_more', 'de', 'Mehr sehen') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_categories', 'de', 'Keine Produktkategorien gefunden.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('product_not_found_title', 'de', 'Produkt nicht gefunden') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('product_not_found_desc', 'de', 'Das gesuchte Produkt existiert nicht.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('specifications_tab', 'de', 'Spezifikationen') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('send_request_btn', 'de', 'Anfrage senden') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_news_posts', 'de', 'Keine Nachrichten gefunden.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('previous_btn', 'de', 'Zurück') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('next_btn', 'de', 'Weiter') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('products_in_category', 'de', 'Produkte in dieser Kategorie') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('view_details', 'de', 'Details anzeigen') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('post_not_found_title', 'de', 'Beitrag nicht gefunden') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('post_not_found_desc', 'de', 'Der Beitrag existiert nicht.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('related_posts_title', 'de', 'Verwandte Beiträge') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Home', 'en', 'Home') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Products', 'en', 'Products') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('News', 'en', 'News') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('About', 'en', 'About') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Contact', 'en', 'Contact') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Privacy Policy', 'en', 'Privacy Policy') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Read More', 'en', 'Read More') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Learn More', 'en', 'Learn More') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Featured Products', 'en', 'Featured Products') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Latest News', 'en', 'Latest News') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Our Factories', 'en', 'Our Factories') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Questions', 'en', 'Frequently Asked Questions') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Request a Quote', 'en', 'Request a Quote') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Technical Specifications', 'en', 'Technical Specifications') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Max Width', 'en', 'Max Width') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Max Height', 'en', 'Max Height') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Panel Thickness', 'en', 'Panel Thickness') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Insulation', 'en', 'Insulation') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Go to website', 'en', 'Go to website') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Quality', 'en', 'Quality') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Innovation', 'en', 'Innovation') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Global Network', 'en', 'Global Network') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Find Dealer', 'en', 'Find Dealer') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Connect With Us', 'en', 'Connect With Us') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Quick Links', 'en', 'Quick Links') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Regional Websites', 'en', 'Regional Websites') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('All rights reserved', 'en', 'All rights reserved.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Factories', 'en', 'Factories') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Solutions', 'en', 'Solutions') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Czech Republic', 'en', 'Czech Republic') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('China', 'en', 'China') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('UAE', 'en', 'UAE') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Germany', 'en', 'Germany') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Latvia', 'en', 'Latvia') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('France', 'en', 'France') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cookie_message', 'en', 'We use cookies to ensure you get the best experience on our website.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cookie_btn', 'en', 'Got it!') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_title_1', 'en', 'ENGINEERING<br>SOLUTIONS<br>OF THE FUTURE') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_desc_1', 'en', 'Comprehensive systems for industry and private housing construction. Technological superiority in every detail.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_btn_1', 'en', 'Explore Products') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_title_2', 'en', 'Innovative Solutions for Every Need') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_btn_2', 'en', 'Discover Our Range') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_title_3', 'en', 'Global Leader in Doors and Automation') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_btn_3', 'en', 'Contact Us') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Catalog', 'en', 'Catalog') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Our Projects', 'en', 'Our Projects') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('GLOBAL GEOGRAPHY', 'en', 'GLOBAL GEOGRAPHY') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('about_us_title', 'en', 'About Us') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('quality_title', 'en', 'Quality') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('quality_desc', 'en', 'We are committed to providing the highest quality products, ensuring durability and reliability for all our customers.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('innovation_title', 'en', 'Innovation') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('innovation_desc', 'en', 'Our team is constantly developing new and innovative solutions to meet the evolving needs of the market.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('global_network_title', 'en', 'Global Network') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('global_network_desc', 'en', 'With a presence in over 30 countries, our global network ensures that we can serve customers worldwide.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('websites_title', 'en', 'Go to following websites to make a purchase') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cz_title', 'en', 'Czech Republic') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cz_item_1', 'en', 'Sectional doors') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cz_item_2', 'en', 'Roller shutters') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cn_title', 'en', 'China') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cn_item_1', 'en', 'Industrial doors') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cn_item_2', 'en', 'Sliding gates') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('ae_title', 'en', 'UAE') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('ae_item_1', 'en', 'Garage doors') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('ae_item_2', 'en', 'Automation') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_featured_products', 'en', 'No featured products available at this time.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_news', 'en', 'No recent news available.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('faq_title', 'en', 'Frequently Asked Questions') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('factories_title', 'en', 'Our Factories') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('dubai_title', 'en', 'Dubai') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('dubai_desc', 'en', 'Our state-of-the-art factory in Dubai produces a wide range of products for the Middle East and Africa.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('czech_title', 'en', 'Czech Republic') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('czech_desc', 'en', 'Our factory in the Czech Republic is a key hub for our European operations, producing high-quality doors and components.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('china_title', 'en', 'China') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('china_desc', 'en', 'Our factory in China is a major production center, manufacturing a wide range of products for the Asian market.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('contact_us_title', 'en', 'Contact Us') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('send_message_title', 'en', 'Send us a message') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('name_placeholder', 'en', 'Your Name') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('email_placeholder', 'en', 'Your Email') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('phone_placeholder', 'en', 'Your Phone (optional)') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('message_placeholder', 'en', 'Your Message') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('send_btn', 'en', 'Send Message') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('contact_info_title', 'en', 'Contact Information') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('address_label', 'en', 'Address') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('phone_label', 'en', 'Phone') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('email_label', 'en', 'Email') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('address_value', 'en', '123 DoorHan Way, Gate City, 12345') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('address_placeholder', 'en', '123 DoorHan Way, Gate City, 12345') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('about_doorhan_title', 'en', 'About DoorHan') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('about_doorhan_desc', 'en', 'DoorHan is a leading global manufacturer of gates, doors, and automation systems, offering innovative and reliable solutions for over 30 years.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('mission_desc', 'en', 'Our mission is to provide our customers with high-quality products that meet their needs and exceed their expectations. We are committed to innovation, quality, and customer satisfaction.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('factories_placeholder', 'en', 'This is a placeholder for the factories page.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('solutions_title', 'en', 'Solutions') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('solutions_placeholder', 'en', 'This is a placeholder for the solutions page.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('our_products_title', 'en', 'Our Products') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('view_more', 'en', 'View More') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_categories', 'en', 'No product categories found.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('product_not_found_title', 'en', 'Product not found') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('product_not_found_desc', 'en', 'The product you are looking for does not exist.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('specifications_tab', 'en', 'Specifications') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('send_request_btn', 'en', 'Send Request') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_news_posts', 'en', 'No news posts found.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('previous_btn', 'en', 'Previous') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('next_btn', 'en', 'Next') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('products_in_category', 'en', 'Products in this category') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('view_details', 'en', 'View Details') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('post_not_found_title', 'en', 'Post not found') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('post_not_found_desc', 'en', 'The post you are looking for does not exist.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('related_posts_title', 'en', 'Related Posts') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Gates', 'en', 'Gates') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Automation', 'en', 'Automation') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Partners', 'en', 'Partners') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Technical Support', 'en', 'Technical Support') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('About Company', 'en', 'About Company') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('No FAQs available.', 'en', 'No FAQs available.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('System Solutions', 'en', 'System Solutions') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Comprehensive approach to automation and protection of objects of any scale.', 'en', 'Comprehensive approach to automation and protection of objects of any scale.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Realized Objects', 'en', 'Realized Objects') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Realized Projects', 'en', 'Realized Projects') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('SCALE. EXPERIENCE. INNOVATION.', 'en', 'SCALE. EXPERIENCE. INNOVATION.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('DoorHan is 30 factories worldwide and a full production cycle, covering all stages: from aluminum casting to final assembly of control systems.', 'en', 'DoorHan is 30 factories worldwide and a full production cycle, covering all stages: from aluminum casting to final assembly of control systems.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('We create solutions that define industry standards for decades to come, ensuring safety and comfort for millions of people.', 'en', 'We create solutions that define industry standards for decades to come, ensuring safety and comfort for millions of people.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('More about company', 'en', 'More about company') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('DISCUSS A PROJECT', 'en', 'DISCUSS A PROJECT') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Let''s connect', 'en', 'Let''s connect') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Your Name', 'en', 'Your Name') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Phone', 'en', 'Phone') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Email', 'en', 'Email') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Message', 'en', 'Message') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('SEND REQUEST', 'en', 'SEND REQUEST') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('By clicking the button, you agree to the personal data processing policy', 'en', 'By clicking the button, you agree to the personal data processing policy') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Support Center', 'en', 'Support Center') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('FAQ', 'en', 'FAQ') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Home', 'es', 'Inicio') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Products', 'es', 'Productos') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('News', 'es', 'Noticias') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('About', 'es', 'Nosotros') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Contact', 'es', 'Contacto') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Privacy Policy', 'es', 'Política de Privacidad') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Read More', 'es', 'Leer más') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Learn More', 'es', 'Saber más') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Featured Products', 'es', 'Productos Destacados') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Latest News', 'es', 'Últimas Noticias') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Our Factories', 'es', 'Nuestras Fábricas') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Questions', 'es', 'Preguntas Frecuentes') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Request a Quote', 'es', 'Solicitar Presupuesto') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Technical Specifications', 'es', 'Especificaciones Técnicas') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Max Width', 'es', 'Ancho Máx') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Max Height', 'es', 'Alto Máx') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Panel Thickness', 'es', 'Espesor del Panel') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Insulation', 'es', 'Aislamiento') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Go to website', 'es', 'Ir al sitio web') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Quality', 'es', 'Calidad') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Innovation', 'es', 'Innovación') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Global Network', 'es', 'Red Global') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Find Dealer', 'es', 'Buscar Distribuidor') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Connect With Us', 'es', 'Conéctate con nosotros') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Quick Links', 'es', 'Enlaces Rápidos') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Regional Websites', 'es', 'Sitios Regionales') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('All rights reserved', 'es', 'Todos los derechos reservados.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Factories', 'es', 'Fábricas') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Solutions', 'es', 'Soluciones') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Czech Republic', 'es', 'República Checa') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('China', 'es', 'China') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('UAE', 'es', 'EAU') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Germany', 'es', 'Alemania') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Latvia', 'es', 'Letonia') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('France', 'es', 'Francia') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cookie_message', 'es', 'Utilizamos cookies para asegurar que tengas la mejor experiencia en nuestro sitio web.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cookie_btn', 'es', '¡Entendido!') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_title_1', 'es', '30+ Años de Puertas y Automatización de Calidad') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_btn_1', 'es', 'Explorar Productos') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_title_2', 'es', 'Soluciones Innovadoras para Cada Necesidad') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_btn_2', 'es', 'Descubre Nuestra Gama') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_title_3', 'es', 'Líder Global en Puertas y Automatización') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_btn_3', 'es', 'Contáctanos') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('about_us_title', 'es', 'Sobre Nosotros') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('quality_title', 'es', 'Calidad') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('quality_desc', 'es', 'Estamos comprometidos a proporcionar productos de la más alta calidad, asegurando durabilidad y fiabilidad.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('innovation_title', 'es', 'Innovación') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('innovation_desc', 'es', 'Nuestro equipo desarrolla constantemente soluciones nuevas e innovadoras.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('global_network_title', 'es', 'Red Global') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('global_network_desc', 'es', 'Con presencia en más de 30 países, nuestra red global asegura el servicio mundial.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('websites_title', 'es', 'Visite los siguientes sitios web para realizar una compra') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cz_title', 'es', 'República Checa') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cz_item_1', 'es', 'Puertas seccionales') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cz_item_2', 'es', 'Persianas enrollables') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cn_title', 'es', 'China') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cn_item_1', 'es', 'Puertas industriales') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cn_item_2', 'es', 'Puertas correderas') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('ae_title', 'es', 'EAU') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('ae_item_1', 'es', 'Puertas de garaje') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('ae_item_2', 'es', 'Automatización') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_featured_products', 'es', 'No hay productos destacados en este momento.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_news', 'es', 'No hay noticias recientes.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('faq_title', 'es', 'Preguntas Frecuentes') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('factories_title', 'es', 'Nuestras Fábricas') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('dubai_title', 'es', 'Dubái') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('dubai_desc', 'es', 'Nuestra fábrica de última generación en Dubái produce una amplia gama de productos.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('czech_title', 'es', 'República Checa') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('czech_desc', 'es', 'Nuestra fábrica en la República Checa es un centro clave para nuestras operaciones europeas.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('china_title', 'es', 'China') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('china_desc', 'es', 'Nuestra fábrica en China es un importante centro de producción para el mercado asiático.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('contact_us_title', 'es', 'Contáctanos') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('send_message_title', 'es', 'Envíanos un mensaje') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('name_placeholder', 'es', 'Tu Nombre') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('email_placeholder', 'es', 'Tu Email') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('phone_placeholder', 'es', 'Tu Teléfono (opcional)') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('message_placeholder', 'es', 'Tu Mensaje') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('send_btn', 'es', 'Enviar Mensaje') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('contact_info_title', 'es', 'Información de Contacto') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('address_label', 'es', 'Dirección') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('phone_label', 'es', 'Teléfono') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('email_label', 'es', 'Email') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('address_value', 'es', '123 DoorHan Way, Gate City, 12345') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('about_doorhan_title', 'es', 'Sobre DoorHan') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('about_doorhan_desc', 'es', 'DoorHan es un fabricante líder mundial de puertas y sistemas de automatización.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('mission_desc', 'es', 'Nuestra misión es proporcionar a nuestros clientes productos de alta calidad.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('factories_placeholder', 'es', 'Este es un marcador de posición para la página de fábricas.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('solutions_title', 'es', 'Soluciones') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('solutions_placeholder', 'es', 'Este es un marcador de posición para la página de soluciones.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('our_products_title', 'es', 'Nuestros Productos') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('view_more', 'es', 'Ver Más') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_categories', 'es', 'No se encontraron categorías.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('product_not_found_title', 'es', 'Producto no encontrado') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('product_not_found_desc', 'es', 'El producto que buscas no existe.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('specifications_tab', 'es', 'Especificaciones') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('send_request_btn', 'es', 'Enviar Solicitud') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_news_posts', 'es', 'No se encontraron noticias.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('previous_btn', 'es', 'Anterior') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('next_btn', 'es', 'Siguiente') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('products_in_category', 'es', 'Productos en esta categoría') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('view_details', 'es', 'Ver Detalles') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('post_not_found_title', 'es', 'Noticia no encontrada') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('post_not_found_desc', 'es', 'La noticia no existe.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('related_posts_title', 'es', 'Noticias Relacionadas') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Home', 'fr', 'Accueil') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Products', 'fr', 'Produits') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('News', 'fr', 'Actualités') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('About', 'fr', 'À propos') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Contact', 'fr', 'Contact') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Privacy Policy', 'fr', 'Politique de confidentialité') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Read More', 'fr', 'Lire la suite') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Learn More', 'fr', 'En savoir plus') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Featured Products', 'fr', 'Produits en vedette') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Latest News', 'fr', 'Dernières nouvelles') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Our Factories', 'fr', 'Nos usines') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Questions', 'fr', 'Foire Aux Questions') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Request a Quote', 'fr', 'Demander un devis') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Technical Specifications', 'fr', 'Spécifications techniques') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Max Width', 'fr', 'Largeur max') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Max Height', 'fr', 'Hauteur max') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Panel Thickness', 'fr', 'Épaisseur du panneau') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Insulation', 'fr', 'Isolation') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Go to website', 'fr', 'Aller sur le site') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Quality', 'fr', 'Qualité') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Innovation', 'fr', 'Innovation') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Global Network', 'fr', 'Réseau mondial') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Find Dealer', 'fr', 'Trouver un revendeur') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Connect With Us', 'fr', 'Connectez-vous avec nous') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Quick Links', 'fr', 'Liens rapides') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Regional Websites', 'fr', 'Sites régionaux') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('All rights reserved', 'fr', 'Tous droits réservés.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Factories', 'fr', 'Usines') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Solutions', 'fr', 'Solutions') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Czech Republic', 'fr', 'République tchèque') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('China', 'fr', 'Chine') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('UAE', 'fr', 'EAU') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Germany', 'fr', 'Allemagne') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Latvia', 'fr', 'Lettonie') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('France', 'fr', 'France') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cookie_message', 'fr', 'Nous utilisons des cookies pour vous garantir la meilleure expérience sur notre site.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cookie_btn', 'fr', 'Compris !') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_title_1', 'fr', '30+ Ans de Portes et Automatisme de Qualité') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_btn_1', 'fr', 'Explorer les produits') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_title_2', 'fr', 'Solutions innovantes pour chaque besoin') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_btn_2', 'fr', 'Découvrir notre gamme') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_title_3', 'fr', 'Leader mondial des portes et de l''automatisation') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_btn_3', 'fr', 'Contactez-nous') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('about_us_title', 'fr', 'À propos de nous') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('quality_title', 'fr', 'Qualité') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('quality_desc', 'fr', 'Nous nous engageons à fournir des produits de la plus haute qualité.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('innovation_title', 'fr', 'Innovation') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('innovation_desc', 'fr', 'Notre équipe développe constamment de nouvelles solutions innovantes.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('global_network_title', 'fr', 'Réseau mondial') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('global_network_desc', 'fr', 'Présent dans plus de 30 pays, notre réseau assure un service mondial.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('websites_title', 'fr', 'Visitez les sites suivants pour faire un achat') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cz_title', 'fr', 'République tchèque') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cz_item_1', 'fr', 'Portes sectionnelles') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cz_item_2', 'fr', 'Volets roulants') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cn_title', 'fr', 'Chine') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cn_item_1', 'fr', 'Portes industrielles') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cn_item_2', 'fr', 'Portails coulissants') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('ae_title', 'fr', 'EAU') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('ae_item_1', 'fr', 'Portes de garage') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('ae_item_2', 'fr', 'Automatisation') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_featured_products', 'fr', 'Aucun produit en vedette pour le moment.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_news', 'fr', 'Aucune nouvelle récente.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('faq_title', 'fr', 'Foire Aux Questions') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('factories_title', 'fr', 'Nos usines') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('dubai_title', 'fr', 'Dubaï') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('dubai_desc', 'fr', 'Notre usine ultramoderne à Dubaï produit une large gamme de produits.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('czech_title', 'fr', 'République tchèque') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('czech_desc', 'fr', 'Notre usine en République tchèque est un centre clé pour l''Europe.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('china_title', 'fr', 'Chine') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('china_desc', 'fr', 'Notre usine en Chine est un centre de production majeur pour l''Asie.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('contact_us_title', 'fr', 'Contactez-nous') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('send_message_title', 'fr', 'Envoyez-nous un message') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('name_placeholder', 'fr', 'Votre nom') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('email_placeholder', 'fr', 'Votre email') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('phone_placeholder', 'fr', 'Votre téléphone (optionnel)') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('message_placeholder', 'fr', 'Votre message') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('send_btn', 'fr', 'Envoyer le message') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('contact_info_title', 'fr', 'Informations de contact') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('address_label', 'fr', 'Adresse') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('phone_label', 'fr', 'Téléphone') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('email_label', 'fr', 'Email') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('address_value', 'fr', '123 DoorHan Way, Gate City, 12345') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('about_doorhan_title', 'fr', 'À propos de DoorHan') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('about_doorhan_desc', 'fr', 'DoorHan est un fabricant leader mondial de portes et systèmes d''automatisation.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('mission_desc', 'fr', 'Notre mission est de fournir à nos clients des produits de haute qualité.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('factories_placeholder', 'fr', 'Ceci est un espace réservé pour la page des usines.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('solutions_title', 'fr', 'Solutions') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('solutions_placeholder', 'fr', 'Ceci est un espace réservé pour la page des solutions.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('our_products_title', 'fr', 'Nos produits') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('view_more', 'fr', 'Voir plus') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_categories', 'fr', 'Aucune catégorie de produits trouvée.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('product_not_found_title', 'fr', 'Produit non trouvé') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('product_not_found_desc', 'fr', 'Le produit que vous recherchez n''existe pas.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('specifications_tab', 'fr', 'Spécifications') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('send_request_btn', 'fr', 'Envoyer la demande') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_news_posts', 'fr', 'Aucun article trouvé.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('previous_btn', 'fr', 'Précédent') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('next_btn', 'fr', 'Suivant') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('products_in_category', 'fr', 'Produits dans cette catégorie') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('view_details', 'fr', 'Voir les détails') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('post_not_found_title', 'fr', 'Article non trouvé') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('post_not_found_desc', 'fr', 'L''article n''existe pas.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('related_posts_title', 'fr', 'Articles connexes') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Home', 'hi', 'होम') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Products', 'hi', 'उत्पाद') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('News', 'hi', 'समाचार') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('About', 'hi', 'हमारे बारे में') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Contact', 'hi', 'संपर्क करें') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Privacy Policy', 'hi', 'गोपनीयता नीति') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Read More', 'hi', 'और पढ़ें') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Learn More', 'hi', 'और जानें') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Featured Products', 'hi', 'विशेष उत्पाद') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Latest News', 'hi', 'ताजा खबर') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Our Factories', 'hi', 'हमारे कारखाने') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Questions', 'hi', 'अक्सर पूछे जाने वाले प्रश्न') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Request a Quote', 'hi', 'उद्धरण का अनुरोध करें') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Technical Specifications', 'hi', 'तकनीकी विनिर्देश') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Max Width', 'hi', 'अधिकतम चौड़ाई') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Max Height', 'hi', 'अधिकतम ऊंचाई') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Panel Thickness', 'hi', 'पैनल की मोटाई') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Insulation', 'hi', 'इन्सुलेशन') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Go to website', 'hi', 'वेबसाइट पर जाएं') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Quality', 'hi', 'गुणवत्ता') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Innovation', 'hi', 'नवाचार') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Global Network', 'hi', 'वैश्विक नेटवर्क') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Find Dealer', 'hi', 'डीलर खोजें') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Connect With Us', 'hi', 'हमसे जुड़ें') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Quick Links', 'hi', 'त्वरित लिंक') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Regional Websites', 'hi', 'क्षेत्रीय वेबसाइटें') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('All rights reserved', 'hi', 'सर्वाधिकार सुरक्षित।') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Factories', 'hi', 'कारखाने') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Solutions', 'hi', 'समाधान') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Czech Republic', 'hi', 'चेक गणतंत्र') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('China', 'hi', 'चीन') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('UAE', 'hi', 'संयुक्त अरब अमीरात') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Germany', 'hi', 'जर्मनी') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Latvia', 'hi', 'लातविया') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('France', 'hi', 'फ्रांस') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cookie_message', 'hi', 'हम यह सुनिश्चित करने के लिए कुकीज़ का उपयोग करते हैं कि आपको हमारी वेबसाइट पर सबसे अच्छा अनुभव मिले।') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cookie_btn', 'hi', 'समझ गया!') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_title_1', 'hi', '30+ साल की गुणवत्ता वाले गेट और स्वचालन') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_btn_1', 'hi', 'उत्पादों का अन्वेषण करें') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_title_2', 'hi', 'हर जरूरत के लिए अभिनव समाधान') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_btn_2', 'hi', 'हमारी सीमा खोजें') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_title_3', 'hi', 'दरवाजे और स्वचालन में वैश्विक नेता') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_btn_3', 'hi', 'हमसे संपर्क करें') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('about_us_title', 'hi', 'हमारे बारे में') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('quality_title', 'hi', 'गुणवत्ता') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('quality_desc', 'hi', 'हम उच्चतम गुणवत्ता वाले उत्पाद प्रदान करने के लिए प्रतिबद्ध हैं।') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('innovation_title', 'hi', 'नवाचार') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('innovation_desc', 'hi', 'हमारी टीम लगातार नए और अभिनव समाधान विकसित कर रही है।') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('global_network_title', 'hi', 'वैश्विक नेटवर्क') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('global_network_desc', 'hi', '30 से अधिक देशों में उपस्थिति के साथ, हमारा वैश्विक नेटवर्क दुनिया भर में सेवा सुनिश्चित करता है।') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('websites_title', 'hi', 'खरीदारी करने के लिए निम्नलिखित वेबसाइटों पर जाएं') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cz_title', 'hi', 'चेक गणतंत्र') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cz_item_1', 'hi', 'अनुभागीय दरवाजे') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cz_item_2', 'hi', 'रोलर शटर') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cn_title', 'hi', 'चीन') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cn_item_1', 'hi', 'औद्योगिक दरवाजे') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cn_item_2', 'hi', 'स्लाइडिंग गेट्स') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('ae_title', 'hi', 'संयुक्त अरब अमीरात') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('ae_item_1', 'hi', 'गेराज दरवाजे') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('ae_item_2', 'hi', 'स्वचालन') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_featured_products', 'hi', 'फिलहाल कोई विशेष उत्पाद उपलब्ध नहीं है।') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_news', 'hi', 'कोई हालिया खबर नहीं।') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('faq_title', 'hi', 'अक्सर पूछे जाने वाले प्रश्न') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('factories_title', 'hi', 'हमारे कारखाने') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('dubai_title', 'hi', 'दुबई') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('dubai_desc', 'hi', 'दुबई में हमारा अत्याधुनिक कारखाना उत्पादों की एक विस्तृत श्रृंखला का उत्पादन करता है।') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('czech_title', 'hi', 'चेक गणतंत्र') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('czech_desc', 'hi', 'चेक गणतंत्र में हमारा कारखाना यूरोप के लिए एक प्रमुख केंद्र है।') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('china_title', 'hi', 'चीन') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('china_desc', 'hi', 'चीन में हमारा कारखाना एशिया के लिए एक प्रमुख उत्पादन केंद्र है।') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('contact_us_title', 'hi', 'संपर्क करें') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('send_message_title', 'hi', 'हमें एक संदेश भेजें') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('name_placeholder', 'hi', 'आपका नाम') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('email_placeholder', 'hi', 'आपका ईमेल') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('phone_placeholder', 'hi', 'आपका फोन (वैकल्पिक)') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('message_placeholder', 'hi', 'आपका संदेश') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('send_btn', 'hi', 'संदेश भेजें') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('contact_info_title', 'hi', 'संपर्क जानकारी') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('address_label', 'hi', 'पता') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('phone_label', 'hi', 'फोन') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('email_label', 'hi', 'ईमेल') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('address_value', 'hi', '123 DoorHan Way, Gate City, 12345') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('about_doorhan_title', 'hi', 'DoorHan के बारे में') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('about_doorhan_desc', 'hi', 'DoorHan गेट, दरवाजे और स्वचालन प्रणालियों का एक अग्रणी वैश्विक निर्माता है।') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('mission_desc', 'hi', 'हमारा मिशन हमारे ग्राहकों को उच्च गुणवत्ता वाले उत्पाद प्रदान करना है।') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('factories_placeholder', 'hi', 'यह कारखानों के पृष्ठ के लिए एक प्लेसहोल्डर है।') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('solutions_title', 'hi', 'समाधान') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('solutions_placeholder', 'hi', 'यह समाधान पृष्ठ के लिए एक प्लेसहोल्डर है।') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('our_products_title', 'hi', 'हमारे उत्पाद') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('view_more', 'hi', 'और देखें') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_categories', 'hi', 'कोई उत्पाद श्रेणी नहीं मिली।') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('product_not_found_title', 'hi', 'उत्पाद नहीं मिला') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('product_not_found_desc', 'hi', 'आप जो उत्पाद ढूंढ रहे हैं वह मौजूद नहीं है।') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('specifications_tab', 'hi', 'विनिर्देश') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('send_request_btn', 'hi', 'अनुरोध भेजें') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_news_posts', 'hi', 'कोई समाचार नहीं मिला।') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('previous_btn', 'hi', 'पिछला') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('next_btn', 'hi', 'अगला') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('products_in_category', 'hi', 'इस श्रेणी के उत्पाद') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('view_details', 'hi', 'विवरण देखें') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('post_not_found_title', 'hi', 'लेख नहीं मिला') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('post_not_found_desc', 'hi', 'लेख मौजूद नहीं है।') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('related_posts_title', 'hi', 'संबंधित लेख') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Home', 'id', 'Beranda') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Products', 'id', 'Produk') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('News', 'id', 'Berita') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('About', 'id', 'Tentang') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Contact', 'id', 'Kontak') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Privacy Policy', 'id', 'Kebijakan Privasi') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Read More', 'id', 'Baca Selengkapnya') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Learn More', 'id', 'Pelajari Lebih Lanjut') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Featured Products', 'id', 'Produk Unggulan') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Latest News', 'id', 'Berita Terbaru') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Our Factories', 'id', 'Pabrik Kami') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Questions', 'id', 'Pertanyaan Umum') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Request a Quote', 'id', 'Minta Penawaran') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Technical Specifications', 'id', 'Spesifikasi Teknis') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Max Width', 'id', 'Lebar Maks') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Max Height', 'id', 'Tinggi Maks') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Panel Thickness', 'id', 'Ketebalan Panel') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Insulation', 'id', 'Isolasi') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Go to website', 'id', 'Ke situs web') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Quality', 'id', 'Kualitas') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Innovation', 'id', 'Inovasi') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Global Network', 'id', 'Jaringan Global') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Find Dealer', 'id', 'Cari Dealer') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Connect With Us', 'id', 'Terhubung Dengan Kami') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Quick Links', 'id', 'Tautan Cepat') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Regional Websites', 'id', 'Situs Web Regional') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('All rights reserved', 'id', 'Hak cipta dilindungi undang-undang.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Factories', 'id', 'Pabrik') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Solutions', 'id', 'Solusi') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Czech Republic', 'id', 'Republik Ceko') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('China', 'id', 'Cina') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('UAE', 'id', 'UEA') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Germany', 'id', 'Jerman') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Latvia', 'id', 'Latvia') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('France', 'id', 'Prancis') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cookie_message', 'id', 'Kami menggunakan cookie untuk memastikan Anda mendapatkan pengalaman terbaik di situs web kami.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cookie_btn', 'id', 'Mengerti!') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_title_1', 'id', '30+ Tahun Gerbang & Otomatisasi Berkualitas') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_btn_1', 'id', 'Jelajahi Produk') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_title_2', 'id', 'Solusi Inovatif untuk Setiap Kebutuhan') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_btn_2', 'id', 'Temukan Rangkaian Kami') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_title_3', 'id', 'Pemimpin Global dalam Pintu dan Otomatisasi') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_btn_3', 'id', 'Hubungi Kami') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('about_us_title', 'id', 'Tentang Kami') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('quality_title', 'id', 'Kualitas') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('quality_desc', 'id', 'Kami berkomitmen untuk menyediakan produk dengan kualitas terbaik.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('innovation_title', 'id', 'Inovasi') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('innovation_desc', 'id', 'Tim kami terus mengembangkan solusi baru yang inovatif.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('global_network_title', 'id', 'Jaringan Global') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('global_network_desc', 'id', 'Dengan kehadiran di lebih dari 30 negara, jaringan global kami memastikan layanan di seluruh dunia.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('websites_title', 'id', 'Kunjungi situs web berikut untuk melakukan pembelian') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cz_title', 'id', 'Republik Ceko') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cz_item_1', 'id', 'Pintu sectional') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cz_item_2', 'id', 'Roller shutter') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cn_title', 'id', 'Cina') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cn_item_1', 'id', 'Pintu industri') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cn_item_2', 'id', 'Gerbang geser') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('ae_title', 'id', 'UEA') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('ae_item_1', 'id', 'Pintu garasi') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('ae_item_2', 'id', 'Otomatisasi') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_featured_products', 'id', 'Tidak ada produk unggulan saat ini.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_news', 'id', 'Tidak ada berita terbaru.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('faq_title', 'id', 'Pertanyaan Umum') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('factories_title', 'id', 'Pabrik Kami') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('dubai_title', 'id', 'Dubai') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('dubai_desc', 'id', 'Pabrik canggih kami di Dubai memproduksi berbagai macam produk.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('czech_title', 'id', 'Republik Ceko') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('czech_desc', 'id', 'Pabrik kami di Republik Ceko adalah pusat utama untuk Eropa.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('china_title', 'id', 'Cina') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('china_desc', 'id', 'Pabrik kami di Cina adalah pusat produksi utama untuk Asia.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('contact_us_title', 'id', 'Hubungi Kami') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('send_message_title', 'id', 'Kirimi kami pesan') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('name_placeholder', 'id', 'Nama Anda') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('email_placeholder', 'id', 'Email Anda') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('phone_placeholder', 'id', 'Telepon Anda (opsional)') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('message_placeholder', 'id', 'Pesan Anda') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('send_btn', 'id', 'Kirim Pesan') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('contact_info_title', 'id', 'Informasi Kontak') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('address_label', 'id', 'Alamat') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('phone_label', 'id', 'Telepon') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('email_label', 'id', 'Email') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('address_value', 'id', '123 DoorHan Way, Gate City, 12345') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('about_doorhan_title', 'id', 'Tentang DoorHan') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('about_doorhan_desc', 'id', 'DoorHan adalah produsen global terkemuka untuk gerbang, pintu, dan sistem otomatisasi.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('mission_desc', 'id', 'Misi kami adalah menyediakan produk berkualitas tinggi bagi pelanggan kami.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('factories_placeholder', 'id', 'Ini adalah pengganti untuk halaman pabrik.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('solutions_title', 'id', 'Solusi') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('solutions_placeholder', 'id', 'Ini adalah pengganti untuk halaman solusi.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('our_products_title', 'id', 'Produk Kami') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('view_more', 'id', 'Lihat Lebih Banyak') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_categories', 'id', 'Kategori produk tidak ditemukan.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('product_not_found_title', 'id', 'Produk tidak ditemukan') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('product_not_found_desc', 'id', 'Produk yang Anda cari tidak ada.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('specifications_tab', 'id', 'Spesifikasi') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('send_request_btn', 'id', 'Kirim Permintaan') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_news_posts', 'id', 'Tidak ada berita ditemukan.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('previous_btn', 'id', 'Sebelumnya') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('next_btn', 'id', 'Selanjutnya') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('products_in_category', 'id', 'Produk dalam kategori ini') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('view_details', 'id', 'Lihat Detail') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('post_not_found_title', 'id', 'Artikel tidak ditemukan') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('post_not_found_desc', 'id', 'Artikel tidak ada.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('related_posts_title', 'id', 'Artikel Terkait') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Home', 'it', 'Home') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Products', 'it', 'Prodotti') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('News', 'it', 'Notizie') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('About', 'it', 'Chi siamo') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Contact', 'it', 'Contatti') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Privacy Policy', 'it', 'Privacy Policy') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Read More', 'it', 'Leggi di più') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Learn More', 'it', 'Scopri di più') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Featured Products', 'it', 'Prodotti in evidenza') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Latest News', 'it', 'Ultime notizie') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Our Factories', 'it', 'Le nostre fabbriche') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Questions', 'it', 'Domande frequenti') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Request a Quote', 'it', 'Richiedi un preventivo') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Technical Specifications', 'it', 'Specifiche tecniche') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Max Width', 'it', 'Larghezza max') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Max Height', 'it', 'Altezza max') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Panel Thickness', 'it', 'Spessore pannello') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Insulation', 'it', 'Isolamento') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Go to website', 'it', 'Vai al sito') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Quality', 'it', 'Qualità') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Innovation', 'it', 'Innovazione') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Global Network', 'it', 'Rete globale') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Find Dealer', 'it', 'Trova rivenditore') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Connect With Us', 'it', 'Connettiti con noi') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Quick Links', 'it', 'Link rapidi') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Regional Websites', 'it', 'Siti regionali') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('All rights reserved', 'it', 'Tutti i diritti riservati.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Factories', 'it', 'Fabbriche') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Solutions', 'it', 'Soluzioni') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Czech Republic', 'it', 'Repubblica Ceca') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('China', 'it', 'Cina') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('UAE', 'it', 'EAU') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Germany', 'it', 'Germania') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Latvia', 'it', 'Lettonia') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('France', 'it', 'Francia') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cookie_message', 'it', 'Utilizziamo i cookie per garantirti la migliore esperienza sul nostro sito.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cookie_btn', 'it', 'Capito!') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_title_1', 'it', '30+ Anni di Cancelli e Automazione di Qualità') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_btn_1', 'it', 'Esplora i prodotti') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_title_2', 'it', 'Soluzioni innovative per ogni esigenza') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_btn_2', 'it', 'Scopri la nostra gamma') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_title_3', 'it', 'Leader globale in porte e automazione') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_btn_3', 'it', 'Contattaci') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('about_us_title', 'it', 'Chi siamo') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('quality_title', 'it', 'Qualità') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('quality_desc', 'it', 'Ci impegniamo a fornire prodotti della massima qualità.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('innovation_title', 'it', 'Innovazione') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('innovation_desc', 'it', 'Il nostro team sviluppa costantemente nuove soluzioni innovative.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('global_network_title', 'it', 'Rete globale') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('global_network_desc', 'it', 'Con una presenza in oltre 30 paesi, la nostra rete globale garantisce un servizio mondiale.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('websites_title', 'it', 'Visita i seguenti siti web per effettuare un acquisto') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cz_title', 'it', 'Repubblica Ceca') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cz_item_1', 'it', 'Porte sezionali') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cz_item_2', 'it', 'Serrande avvolgibili') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cn_title', 'it', 'Cina') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cn_item_1', 'it', 'Porte industriali') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cn_item_2', 'it', 'Cancelli scorrevoli') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('ae_title', 'it', 'EAU') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('ae_item_1', 'it', 'Porte da garage') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('ae_item_2', 'it', 'Automazione') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_featured_products', 'it', 'Nessun prodotto in evidenza al momento.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_news', 'it', 'Nessuna notizia recente.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('faq_title', 'it', 'Domande frequenti') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('factories_title', 'it', 'Le nostre fabbriche') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('dubai_title', 'it', 'Dubai') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('dubai_desc', 'it', 'La nostra fabbrica all''avanguardia a Dubai produce una vasta gamma di prodotti.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('czech_title', 'it', 'Repubblica Ceca') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('czech_desc', 'it', 'La nostra fabbrica in Repubblica Ceca è un hub chiave per l''Europa.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('china_title', 'it', 'Cina') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('china_desc', 'it', 'La nostra fabbrica in Cina è un importante centro di produzione per l''Asia.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('contact_us_title', 'it', 'Contattaci') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('send_message_title', 'it', 'Inviaci un messaggio') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('name_placeholder', 'it', 'Il tuo nome') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('email_placeholder', 'it', 'La tua email') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('phone_placeholder', 'it', 'Il tuo telefono (opzionale)') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('message_placeholder', 'it', 'Il tuo messaggio') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('send_btn', 'it', 'Invia messaggio') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('contact_info_title', 'it', 'Informazioni di contatto') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('address_label', 'it', 'Indirizzo') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('phone_label', 'it', 'Telefono') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('email_label', 'it', 'Email') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('address_value', 'it', '123 DoorHan Way, Gate City, 12345') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('about_doorhan_title', 'it', 'Informazioni su DoorHan') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('about_doorhan_desc', 'it', 'DoorHan è un produttore leader mondiale di cancelli, porte e sistemi di automazione.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('mission_desc', 'it', 'La nostra missione è fornire ai nostri clienti prodotti di alta qualità.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('factories_placeholder', 'it', 'Questo è un segnaposto per la pagina delle fabbriche.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('solutions_title', 'it', 'Soluzioni') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('solutions_placeholder', 'it', 'Questo è un segnaposto per la pagina delle soluzioni.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('our_products_title', 'it', 'I nostri prodotti') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('view_more', 'it', 'Vedi altro') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_categories', 'it', 'Nessuna categoria di prodotti trovata.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('product_not_found_title', 'it', 'Prodotto non trovato') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('product_not_found_desc', 'it', 'Il prodotto che cerchi non esiste.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('specifications_tab', 'it', 'Specifiche') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('send_request_btn', 'it', 'Invia richiesta') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_news_posts', 'it', 'Nessuna notizia trovata.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('previous_btn', 'it', 'Precedente') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('next_btn', 'it', 'Successivo') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('products_in_category', 'it', 'Prodotti in questa categoria') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('view_details', 'it', 'Vedi dettagli') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('post_not_found_title', 'it', 'Articolo non trovato') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('post_not_found_desc', 'it', 'L''articolo non esiste.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('related_posts_title', 'it', 'Articoli correlati') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Home', 'ja', 'ホーム') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Products', 'ja', '製品') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('News', 'ja', 'ニュース') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('About', 'ja', '私たちについて') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Contact', 'ja', 'お問い合わせ') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Privacy Policy', 'ja', 'プライバシーポリシー') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Read More', 'ja', '続きを読む') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Learn More', 'ja', 'もっと詳しく') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Featured Products', 'ja', 'おすすめ製品') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Latest News', 'ja', '最新ニュース') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Our Factories', 'ja', '私たちの工場') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Questions', 'ja', 'よくある質問') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Request a Quote', 'ja', '見積もりを依頼') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Technical Specifications', 'ja', '技術仕様') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Max Width', 'ja', '最大幅') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Max Height', 'ja', '最大高さ') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Panel Thickness', 'ja', 'パネルの厚さ') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Insulation', 'ja', '断熱') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Go to website', 'ja', 'ウェブサイトへ') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Quality', 'ja', '品質') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Innovation', 'ja', '革新') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Global Network', 'ja', 'グローバルネットワーク') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Find Dealer', 'ja', 'ディーラーを探す') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Connect With Us', 'ja', '私たちとつながる') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Quick Links', 'ja', 'クイックリンク') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Regional Websites', 'ja', '地域ウェブサイト') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('All rights reserved', 'ja', '無断転載を禁じます。') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Factories', 'ja', '工場') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Solutions', 'ja', 'ソリューション') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Czech Republic', 'ja', 'チェコ共和国') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('China', 'ja', '中国') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('UAE', 'ja', 'アラブ首長国連邦') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Germany', 'ja', 'ドイツ') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Latvia', 'ja', 'ラトビア') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('France', 'ja', 'フランス') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cookie_message', 'ja', '当サイトでは、最高の体験を提供するためにクッキーを使用しています。') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cookie_btn', 'ja', '理解しました！') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_title_1', 'ja', '30年以上の高品質なゲートと自動化') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_btn_1', 'ja', '製品を見る') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_title_2', 'ja', 'あらゆるニーズに対応する革新的なソリューション') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_btn_2', 'ja', '範囲を発見') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_title_3', 'ja', 'ドアと自動化の世界的リーダー') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_btn_3', 'ja', 'お問い合わせ') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('about_us_title', 'ja', '私たちについて') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('quality_title', 'ja', '品質') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('quality_desc', 'ja', '最高の品質の製品を提供し、耐久性と信頼性を保証することに取り組んでいます。') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('innovation_title', 'ja', '革新') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('innovation_desc', 'ja', '私たちのチームは常に新しい革新的なソリューションを開発しています。') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('global_network_title', 'ja', 'グローバルネットワーク') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('global_network_desc', 'ja', '30カ国以上に展開するグローバルネットワークが世界中のサービスを保証します。') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('websites_title', 'ja', '購入するには以下のウェブサイトにアクセスしてください') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cz_title', 'ja', 'チェコ共和国') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cz_item_1', 'ja', 'セクショナルドア') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cz_item_2', 'ja', 'シャッター') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cn_title', 'ja', '中国') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cn_item_1', 'ja', '産業用ドア') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cn_item_2', 'ja', 'スライディングゲート') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('ae_title', 'ja', 'UAE') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('ae_item_1', 'ja', 'ガレージドア') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('ae_item_2', 'ja', '自動化') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_featured_products', 'ja', '現在、おすすめの製品はありません。') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_news', 'ja', '最新のニュースはありません。') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('faq_title', 'ja', 'よくある質問') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('factories_title', 'ja', '私たちの工場') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('dubai_title', 'ja', 'ドバイ') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('dubai_desc', 'ja', 'ドバイの最新鋭工場では、幅広い製品を生産しています。') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('czech_title', 'ja', 'チェコ共和国') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('czech_desc', 'ja', 'チェコ共和国の工場は、ヨーロッパの重要な拠点です。') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('china_title', 'ja', '中国') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('china_desc', 'ja', '中国の工場は、アジアの主要な生産センターです。') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('contact_us_title', 'ja', 'お問い合わせ') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('send_message_title', 'ja', 'メッセージを送る') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('name_placeholder', 'ja', 'お名前') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('email_placeholder', 'ja', 'メールアドレス') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('phone_placeholder', 'ja', '電話番号（任意）') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('message_placeholder', 'ja', 'メッセージ') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('send_btn', 'ja', 'メッセージを送信') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('contact_info_title', 'ja', '連絡先情報') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('address_label', 'ja', '住所') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('phone_label', 'ja', '電話') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('email_label', 'ja', 'メール') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('address_value', 'ja', '123 DoorHan Way, Gate City, 12345') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('about_doorhan_title', 'ja', 'DoorHanについて') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('about_doorhan_desc', 'ja', 'DoorHanは、ゲート、ドア、自動化システムの世界的リーダーメーカーです。') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('mission_desc', 'ja', '私たちの使命は、お客様に高品質の製品を提供することです。') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('factories_placeholder', 'ja', 'これは工場ページのプレースホルダーです。') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('solutions_title', 'ja', 'ソリューション') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('solutions_placeholder', 'ja', 'これはソリューションページのプレースホルダーです。') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('our_products_title', 'ja', '当社の製品') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('view_more', 'ja', 'もっと見る') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_categories', 'ja', '製品カテゴリが見つかりません。') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('product_not_found_title', 'ja', '製品が見つかりません') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('product_not_found_desc', 'ja', 'お探しの製品は存在しません。') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('specifications_tab', 'ja', '仕様') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('send_request_btn', 'ja', 'リクエストを送信') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_news_posts', 'ja', 'ニュースが見つかりません。') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('previous_btn', 'ja', '前へ') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('next_btn', 'ja', '次へ') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('products_in_category', 'ja', 'このカテゴリの製品') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('view_details', 'ja', '詳細を見る') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('post_not_found_title', 'ja', '記事が見つかりません') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('post_not_found_desc', 'ja', '記事は存在しません。') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('related_posts_title', 'ja', '関連記事') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Home', 'ko', '홈') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Products', 'ko', '제품') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('News', 'ko', '뉴스') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('About', 'ko', '회사 소개') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Contact', 'ko', '연락처') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Privacy Policy', 'ko', '개인정보 보호정책') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Read More', 'ko', '더 읽기') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Learn More', 'ko', '자세히 알아보기') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Featured Products', 'ko', '추천 제품') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Latest News', 'ko', '최신 뉴스') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Our Factories', 'ko', '우리 공장') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Questions', 'ko', '자주 묻는 질문') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Request a Quote', 'ko', '견적 요청') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Technical Specifications', 'ko', '기술 사양') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Max Width', 'ko', '최대 너비') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Max Height', 'ko', '최대 높이') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Panel Thickness', 'ko', '패널 두께') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Insulation', 'ko', '단열') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Go to website', 'ko', '웹사이트로 이동') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Quality', 'ko', '품질') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Innovation', 'ko', '혁신') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Global Network', 'ko', '글로벌 네트워크') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Find Dealer', 'ko', '딜러 찾기') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Connect With Us', 'ko', 'SNS 연결') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Quick Links', 'ko', '빠른 링크') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Regional Websites', 'ko', '지역 웹사이트') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('All rights reserved', 'ko', '판권 소유.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Factories', 'ko', '공장') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Solutions', 'ko', '솔루션') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Czech Republic', 'ko', '체코 공화국') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('China', 'ko', '중국') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('UAE', 'ko', 'UAE') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Germany', 'ko', '독일') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Latvia', 'ko', '라트비아') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('France', 'ko', '프랑스') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cookie_message', 'ko', '우리는 웹사이트에서 최고의 경험을 제공하기 위해 쿠키를 사용합니다.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cookie_btn', 'ko', '알겠습니다!') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_title_1', 'ko', '30년 이상의 고품질 게이트 및 자동화') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_btn_1', 'ko', '제품 탐색') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_title_2', 'ko', '모든 요구에 맞는 혁신적인 솔루션') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_btn_2', 'ko', '범위 발견') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_title_3', 'ko', '도어 및 자동화 분야의 글로벌 리더') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_btn_3', 'ko', '문의하기') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('about_us_title', 'ko', '회사 소개') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('quality_title', 'ko', '품질') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('quality_desc', 'ko', '우리는 최고의 품질의 제품을 제공하기 위해 최선을 다하고 있습니다.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('innovation_title', 'ko', '혁신') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('innovation_desc', 'ko', '우리 팀은 끊임없이 새로운 혁신적인 솔루션을 개발하고 있습니다.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('global_network_title', 'ko', '글로벌 네트워크') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('global_network_desc', 'ko', '30개국 이상에 진출한 글로벌 네트워크를 통해 전 세계 서비스를 보장합니다.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('websites_title', 'ko', '구매하려면 다음 웹사이트를 방문하세요') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cz_title', 'ko', '체코 공화국') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cz_item_1', 'ko', '섹션 도어') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cz_item_2', 'ko', '롤러 셔터') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cn_title', 'ko', '중국') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cn_item_1', 'ko', '산업용 도어') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cn_item_2', 'ko', '슬라이딩 게이트') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('ae_title', 'ko', 'UAE') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('ae_item_1', 'ko', '차고 문') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('ae_item_2', 'ko', '자동화') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_featured_products', 'ko', '현재 추천 제품이 없습니다.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_news', 'ko', '최신 뉴스가 없습니다.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('faq_title', 'ko', '자주 묻는 질문') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('factories_title', 'ko', '우리 공장') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('dubai_title', 'ko', '두바이') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('dubai_desc', 'ko', '두바이의 최첨단 공장은 다양한 제품을 생산합니다.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('czech_title', 'ko', '체코 공화국') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('czech_desc', 'ko', '체코 공화국 공장은 유럽의 핵심 허브입니다.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('china_title', 'ko', '중국') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('china_desc', 'ko', '중국 공장은 아시아의 주요 생산 센터입니다.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('contact_us_title', 'ko', '문의하기') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('send_message_title', 'ko', '메시지 보내기') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('name_placeholder', 'ko', '이름') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('email_placeholder', 'ko', '이메일') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('phone_placeholder', 'ko', '전화번호 (선택 사항)') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('message_placeholder', 'ko', '메시지') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('send_btn', 'ko', '메시지 보내기') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('contact_info_title', 'ko', '연락처 정보') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('address_label', 'ko', '주소') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('phone_label', 'ko', '전화') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('email_label', 'ko', '이메일') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('address_value', 'ko', '123 DoorHan Way, Gate City, 12345') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('about_doorhan_title', 'ko', 'DoorHan 소개') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('about_doorhan_desc', 'ko', 'DoorHan은 게이트, 도어 및 자동화 시스템의 글로벌 선두 제조업체입니다.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('mission_desc', 'ko', '우리의 임무는 고객에게 고품질의 제품을 제공하는 것입니다.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('factories_placeholder', 'ko', '이것은 공장 페이지의 자리 표시자입니다.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('solutions_title', 'ko', '솔루션') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('solutions_placeholder', 'ko', '이것은 솔루션 페이지의 자리 표시자입니다.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('our_products_title', 'ko', '우리 제품') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('view_more', 'ko', '더 보기') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_categories', 'ko', '제품 카테고리를 찾을 수 없습니다.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('product_not_found_title', 'ko', '제품을 찾을 수 없음') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('product_not_found_desc', 'ko', '찾고 있는 제품이 존재하지 않습니다.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('specifications_tab', 'ko', '사양') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('send_request_btn', 'ko', '요청 보내기') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_news_posts', 'ko', '뉴스를 찾을 수 없습니다.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('previous_btn', 'ko', '이전') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('next_btn', 'ko', '다음') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('products_in_category', 'ko', '이 카테고리의 제품') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('view_details', 'ko', '세부 정보 보기') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('post_not_found_title', 'ko', '기사를 찾을 수 없음') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('post_not_found_desc', 'ko', '기사가 존재하지 않습니다.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('related_posts_title', 'ko', '관련 기사') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Home', 'pt', 'Início') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Products', 'pt', 'Produtos') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('News', 'pt', 'Notícias') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('About', 'pt', 'Sobre') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Contact', 'pt', 'Contato') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Privacy Policy', 'pt', 'Política de Privacidade') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Read More', 'pt', 'Ler mais') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Learn More', 'pt', 'Saiba mais') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Featured Products', 'pt', 'Produtos em Destaque') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Latest News', 'pt', 'Últimas Notícias') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Our Factories', 'pt', 'Nossas Fábricas') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Questions', 'pt', 'Perguntas Frequentes') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Request a Quote', 'pt', 'Solicitar Cotação') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Technical Specifications', 'pt', 'Especificações Técnicas') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Max Width', 'pt', 'Largura Máx') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Max Height', 'pt', 'Altura Máx') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Panel Thickness', 'pt', 'Espessura do Painel') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Insulation', 'pt', 'Isolamento') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Go to website', 'pt', 'Ir para o site') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Quality', 'pt', 'Qualidade') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Innovation', 'pt', 'Inovação') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Global Network', 'pt', 'Rede Global') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Find Dealer', 'pt', 'Encontrar Revendedor') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Connect With Us', 'pt', 'Conecte-se conosco') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Quick Links', 'pt', 'Links Rápidos') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Regional Websites', 'pt', 'Sites Regionais') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('All rights reserved', 'pt', 'Todos os direitos reservados.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Factories', 'pt', 'Fábricas') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Solutions', 'pt', 'Soluções') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Czech Republic', 'pt', 'República Checa') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('China', 'pt', 'China') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('UAE', 'pt', 'EAU') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Germany', 'pt', 'Alemanha') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Latvia', 'pt', 'Letônia') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('France', 'pt', 'França') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cookie_message', 'pt', 'Usamos cookies para garantir a melhor experiência em nosso site.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cookie_btn', 'pt', 'Entendi!') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_title_1', 'pt', '30+ Anos de Portões e Automação de Qualidade') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_btn_1', 'pt', 'Explorar Produtos') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_title_2', 'pt', 'Soluções Inovadoras para Cada Necessidade') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_btn_2', 'pt', 'Descubra Nossa Gama') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_title_3', 'pt', 'Líder Global em Portas e Automação') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_btn_3', 'pt', 'Contate-nos') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('about_us_title', 'pt', 'Sobre Nós') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('quality_title', 'pt', 'Qualidade') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('quality_desc', 'pt', 'Estamos comprometidos em fornecer produtos da mais alta qualidade.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('innovation_title', 'pt', 'Inovação') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('innovation_desc', 'pt', 'Nossa equipe desenvolve constantemente novas soluções inovadoras.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('global_network_title', 'pt', 'Rede Global') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('global_network_desc', 'pt', 'Com presença em mais de 30 países, nossa rede global garante atendimento mundial.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('websites_title', 'pt', 'Visite os seguintes sites para fazer uma compra') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cz_title', 'pt', 'República Checa') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cz_item_1', 'pt', 'Portas seccionais') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cz_item_2', 'pt', 'Persianas') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cn_title', 'pt', 'China') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cn_item_1', 'pt', 'Portas industriais') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cn_item_2', 'pt', 'Portões deslizantes') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('ae_title', 'pt', 'EAU') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('ae_item_1', 'pt', 'Portas de garagem') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('ae_item_2', 'pt', 'Automação') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_featured_products', 'pt', 'Nenhum produto em destaque no momento.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_news', 'pt', 'Nenhuma notícia recente.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('faq_title', 'pt', 'Perguntas Frequentes') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('factories_title', 'pt', 'Nossas Fábricas') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('dubai_title', 'pt', 'Dubai') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('dubai_desc', 'pt', 'Nossa fábrica de última geração em Dubai produz uma ampla gama de produtos.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('czech_title', 'pt', 'República Checa') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('czech_desc', 'pt', 'Nossa fábrica na República Checa é um centro chave para a Europa.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('china_title', 'pt', 'China') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('china_desc', 'pt', 'Nossa fábrica na China é um importante centro de produção para a Ásia.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('contact_us_title', 'pt', 'Contate-nos') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('send_message_title', 'pt', 'Envie-nos uma mensagem') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('name_placeholder', 'pt', 'Seu Nome') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('email_placeholder', 'pt', 'Seu Email') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('phone_placeholder', 'pt', 'Seu Telefone (opcional)') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('message_placeholder', 'pt', 'Sua Mensagem') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('send_btn', 'pt', 'Enviar Mensagem') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('contact_info_title', 'pt', 'Informações de Contato') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('address_label', 'pt', 'Endereço') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('phone_label', 'pt', 'Telefone') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('email_label', 'pt', 'Email') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('address_value', 'pt', '123 DoorHan Way, Gate City, 12345') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('about_doorhan_title', 'pt', 'Sobre a DoorHan') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('about_doorhan_desc', 'pt', 'A DoorHan é uma fabricante líder global de portões, portas e sistemas de automação.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('mission_desc', 'pt', 'Nossa missão é fornecer aos nossos clientes produtos de alta qualidade.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('factories_placeholder', 'pt', 'Este é um espaço reservado para a página das fábricas.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('solutions_title', 'pt', 'Soluções') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('solutions_placeholder', 'pt', 'Este é um espaço reservado para a página de soluções.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('our_products_title', 'pt', 'Nossos Produtos') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('view_more', 'pt', 'Ver Mais') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_categories', 'pt', 'Nenhuma categoria de produto encontrada.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('product_not_found_title', 'pt', 'Produto não encontrado') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('product_not_found_desc', 'pt', 'O produto que você procura não existe.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('specifications_tab', 'pt', 'Especificações') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('send_request_btn', 'pt', 'Enviar Solicitação') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_news_posts', 'pt', 'Nenhuma notícia encontrada.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('previous_btn', 'pt', 'Anterior') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('next_btn', 'pt', 'Próximo') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('products_in_category', 'pt', 'Produtos nesta categoria') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('view_details', 'pt', 'Ver Detalhes') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('post_not_found_title', 'pt', 'Artigo não encontrado') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('post_not_found_desc', 'pt', 'O artigo não existe.') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('related_posts_title', 'pt', 'Artigos Relacionados') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Home', 'zh', '首页') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Products', 'zh', '产品') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('News', 'zh', '新闻') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('About', 'zh', '关于我们') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Contact', 'zh', '联系我们') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Privacy Policy', 'zh', '隐私政策') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Read More', 'zh', '阅读更多') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Learn More', 'zh', '了解更多') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Featured Products', 'zh', '精选产品') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Latest News', 'zh', '最新新闻') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Our Factories', 'zh', '我们的工厂') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Questions', 'zh', '常见问题') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Request a Quote', 'zh', '请求报价') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Technical Specifications', 'zh', '技术规格') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Max Width', 'zh', '最大宽度') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Max Height', 'zh', '最大高度') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Panel Thickness', 'zh', '面板厚度') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Insulation', 'zh', '绝缘') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Go to website', 'zh', '访问网站') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Quality', 'zh', '质量') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Innovation', 'zh', '创新') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Global Network', 'zh', '全球网络') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Find Dealer', 'zh', '查找经销商') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Connect With Us', 'zh', '联系我们') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Quick Links', 'zh', '快速链接') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Regional Websites', 'zh', '区域网站') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('All rights reserved', 'zh', '版权所有。') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Factories', 'zh', '工厂') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Solutions', 'zh', '解决方案') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Czech Republic', 'zh', '捷克共和国') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('China', 'zh', '中国') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('UAE', 'zh', '阿联酋') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Germany', 'zh', '德国') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('Latvia', 'zh', '拉脱维亚') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('France', 'zh', '法国') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cookie_message', 'zh', '我们使用 cookie 以确保您在我们的网站上获得最佳体验。') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cookie_btn', 'zh', '明白了！') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_title_1', 'zh', '30 多年优质大门和自动化') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_btn_1', 'zh', '探索产品') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_title_2', 'zh', '满足各种需求的创新解决方案') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_btn_2', 'zh', '发现我们的范围') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_title_3', 'zh', '门业和自动化的全球领导者') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('hero_btn_3', 'zh', '联系我们') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('about_us_title', 'zh', '关于我们') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('quality_title', 'zh', '质量') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('quality_desc', 'zh', '我们致力于提供最高质量的产品，确保耐用性和可靠性。') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('innovation_title', 'zh', '创新') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('innovation_desc', 'zh', '我们的团队不断开发新的创新解决方案。') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('global_network_title', 'zh', '全球网络') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('global_network_desc', 'zh', '我们的全球网络遍布 30 多个国家/地区，确保全球服务。') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('websites_title', 'zh', '访问以下网站进行购买') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cz_title', 'zh', '捷克共和国') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cz_item_1', 'zh', '分段门') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cz_item_2', 'zh', '卷帘门') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cn_title', 'zh', '中国') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cn_item_1', 'zh', '工业门') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('cn_item_2', 'zh', '滑动门') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('ae_title', 'zh', '阿联酋') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('ae_item_1', 'zh', '车库门') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('ae_item_2', 'zh', '自动化') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_featured_products', 'zh', '目前没有精选产品。') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_news', 'zh', '没有最新新闻。') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('faq_title', 'zh', '常见问题') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('factories_title', 'zh', '我们的工厂') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('dubai_title', 'zh', '迪拜') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('dubai_desc', 'zh', '我们在迪拜的最先进工厂生产各种产品。') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('czech_title', 'zh', '捷克共和国') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('czech_desc', 'zh', '我们在捷克共和国的工厂是欧洲的重要枢纽。') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('china_title', 'zh', '中国') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('china_desc', 'zh', '我们在中国的工厂是亚洲的主要生产中心。') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('contact_us_title', 'zh', '联系我们') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('send_message_title', 'zh', '给我们发信息') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('name_placeholder', 'zh', '您的姓名') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('email_placeholder', 'zh', '您的电子邮件') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('phone_placeholder', 'zh', '您的电话（可选）') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('message_placeholder', 'zh', '您的留言') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('send_btn', 'zh', '发送留言') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('contact_info_title', 'zh', '联系信息') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('address_label', 'zh', '地址') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('phone_label', 'zh', '电话') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('email_label', 'zh', '电子邮件') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('address_value', 'zh', '123 DoorHan Way, Gate City, 12345') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('about_doorhan_title', 'zh', '关于 DoorHan') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('about_doorhan_desc', 'zh', 'DoorHan 是门业和自动化系统的全球领先制造商。') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('mission_desc', 'zh', '我们的使命是为客户提供高质量的产品。') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('factories_placeholder', 'zh', '这是工厂页面的占位符。') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('solutions_title', 'zh', '解决方案') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('solutions_placeholder', 'zh', '这是解决方案页面的占位符。') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('our_products_title', 'zh', '我们的产品') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('view_more', 'zh', '查看更多') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_categories', 'zh', '未找到产品类别。') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('product_not_found_title', 'zh', '未找到产品') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('product_not_found_desc', 'zh', '您寻找的产品不存在。') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('specifications_tab', 'zh', '规格') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('send_request_btn', 'zh', '发送请求') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('no_news_posts', 'zh', '未找到新闻。') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('previous_btn', 'zh', '上一页') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('next_btn', 'zh', '下一页') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('products_in_category', 'zh', '此类别的产品') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('view_details', 'zh', '查看详情') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('post_not_found_title', 'zh', '未找到文章') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('post_not_found_desc', 'zh', '该文章不存在。') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);
INSERT INTO `ui_translations` (`key`, `language_code`, `value`) VALUES ('related_posts_title', 'zh', '相关文章') ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);

INSERT INTO `faqs` (`sort_order`, `is_active`) VALUES (1, 1);
SET @last_faq_id = LAST_INSERT_ID();
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'ar', 'ما أنواع الأبواب التي تقدمونها؟', 'نقدم مجموعة واسعة من الأبواب، بما في ذلك المقطعية، والدوارة، والمنزلقة، والصناعية.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'de', 'Welche Arten von Türen bieten Sie an?', 'Wir bieten eine breite Palette von Türen an, darunter Sektional-, Roll-, Schiebe- und Industrietore.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'en', 'What types of doors do you offer?', 'We offer a wide range of doors, including sectional doors, roller shutters, sliding gates, industrial doors, and garage doors. We also provide automation solutions for all our products.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'es', '¿Qué tipos de puertas ofrecen?', 'Ofrecemos una amplia gama de puertas, incluyendo seccionales, enrollables, correderas, industriales y de garaje.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'fr', 'Quels types de portes proposez-vous ?', 'Nous proposons une large gamme de portes, y compris sectionnelles, enroulables, coulissantes et industrielles.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'hi', 'आप किस प्रकार के दरवाजे प्रदान करते हैं?', 'हम विभिन्न प्रकार के दरवाजे प्रदान करते हैं, जिनमें अनुभागीय, रोलर, स्लाइडिंग और औद्योगिक शामिल हैं।');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'id', 'Jenis pintu apa yang Anda tawarkan?', 'Kami menawarkan berbagai macam pintu, termasuk sectional, roller, geser, dan industri.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'it', 'Che tipi di porte offrite?', 'Offriamo una vasta gamma di porte, tra cui sezionali, avvolgibili, scorrevoli e industriali.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'ja', 'どのような種類のドアを提供していますか？', 'セクショナル、シャッター、スライディング、産業用など、幅広いドアを提供しています。');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'ko', '어떤 종류의 문을 제공합니까?', '우리는 섹션, 롤러, 슬라이딩 및 산업용 도어를 포함한 다양한 도어를 제공합니다.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'pt', 'Que tipos de portas vocês oferecem?', 'Oferecemos uma ampla gama de portas, incluindo seccionais, de enrolar, deslizantes e industriais.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'zh', '你们提供什么类型的门？', '我们提供各种各样的门，包括分段门、卷帘门、滑动门和工业门。');
INSERT INTO `faqs` (`sort_order`, `is_active`) VALUES (2, 1);
SET @last_faq_id = LAST_INSERT_ID();
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'ar', 'هل تقدمون خدمات التركيب؟', 'نعم، لدينا شبكة من الوكلاء المعتمدين.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'de', 'Bieten Sie Installationsdienste an?', 'Ja, wir haben ein Netzwerk von zertifizierten Händlern.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'en', 'Do you provide installation services?', 'Yes, we have a network of certified dealers who can provide professional installation services. Contact us to find a dealer near you.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'es', '¿Ofrecen servicios de instalación?', 'Sí, tenemos una red de distribuidores certificados que pueden proporcionar instalación profesional.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'fr', 'Proposez-vous des services d''installation ?', 'Oui, nous avons un réseau de revendeurs certifiés.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'hi', 'क्या आप स्थापना सेवाएं प्रदान करते हैं?', 'हां, हमारे पास प्रमाणित डीलरों का नेटवर्क है।');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'id', 'Apakah Anda menyediakan layanan pemasangan?', 'Ya, kami memiliki jaringan dealer bersertifikat.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'it', 'Offrite servizi di installazione?', 'Sì, abbiamo una rete di rivenditori certificati.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'ja', '設置サービスは提供していますか？', 'はい、認定ディーラーのネットワークがあります。');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'ko', '설치 서비스를 제공합니까?', '예, 인증된 딜러 네트워크가 있습니다.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'pt', 'Vocês oferecem serviços de instalação?', 'Sim, temos uma rede de revendedores certificados.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'zh', '你们提供安装服务吗？', '是的，我们拥有认证经销商网络。');
INSERT INTO `faqs` (`sort_order`, `is_active`) VALUES (3, 1);
SET @last_faq_id = LAST_INSERT_ID();
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'ar', 'ما هو الضمان على منتجاتكم؟', 'تأتي جميع منتجاتنا مع ضمان قياسي.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'de', 'Wie lange ist die Garantie auf Ihre Produkte?', 'Alle unsere Produkte haben eine Standardgarantie.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'en', 'What is the warranty on your products?', 'All our products come with a standard warranty. The warranty period varies depending on the product. Please contact us for more details.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'es', '¿Cuál es la garantía de sus productos?', 'Todos nuestros productos vienen con una garantía estándar.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'fr', 'Quelle est la garantie sur vos produits ?', 'Tous nos produits sont livrés avec une garantie standard.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'hi', 'आपके उत्पादों पर वारंटी क्या है?', 'हमारे सभी उत्पाद मानक वारंटी के साथ आते हैं।');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'id', 'Apa garansi untuk produk Anda?', 'Semua produk kami dilengkapi dengan garansi standar.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'it', 'Qual è la garanzia sui vostri prodotti?', 'Tutti i nostri prodotti sono coperti da garanzia standard.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'ja', '製品の保証はどうなっていますか？', 'すべての製品には標準保証が付いています。');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'ko', '제품 보증은 어떻게 됩니까?', '모든 제품에는 표준 보증이 제공됩니다.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'pt', 'Qual é a garantia dos seus produtos?', 'Todos os nossos produtos vêm com garantia padrão.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'zh', '你们产品的保修期是多久？', '我们所有产品均附带标准保修。');
INSERT INTO `faqs` (`sort_order`, `is_active`) VALUES (4, 1);
SET @last_faq_id = LAST_INSERT_ID();
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'ar', 'كيف يمكنني الحصول على عرض أسعار؟', 'يمكنك طلب عرض أسعار من خلال موقعنا الإلكتروني.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'de', 'Wie erhalte ich ein Angebot?', 'Sie können ein Angebot über unsere Website anfordern.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'en', 'How can I get a quote?', 'You can request a quote by contacting us through our website or by calling our sales team. We are always ready to help you with your queries.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'es', '¿Cómo puedo obtener un presupuesto?', 'Puede solicitar un presupuesto contactándonos a través de nuestro sitio web.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'fr', 'Comment obtenir un devis ?', 'Vous pouvez demander un devis via notre site web.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'hi', 'मैं उद्धरण कैसे प्राप्त कर सकता हूं?', 'आप हमारी वेबसाइट के माध्यम से उद्धरण का अनुरोध कर सकते हैं।');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'id', 'Bagaimana cara mendapatkan penawaran?', 'Anda dapat meminta penawaran melalui situs web kami.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'it', 'Come posso ottenere un preventivo?', 'Puoi richiedere un preventivo tramite il nostro sito web.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'ja', '見積もりはどうすればもらえますか？', 'ウェブサイトから見積もりを依頼できます。');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'ko', '견적은 어떻게 받을 수 있습니까?', '웹사이트를 통해 견적을 요청할 수 있습니다.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'pt', 'Como posso obter uma cotação?', 'Você pode solicitar uma cotação através do nosso site.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'zh', '我如何获得报价？', '您可以通过我们的网站索取报价。');
INSERT INTO `faqs` (`sort_order`, `is_active`) VALUES (5, 1);
SET @last_faq_id = LAST_INSERT_ID();
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'ar', 'هل منتجاتكم معتمدة؟', 'نعم، جميع منتجاتنا معتمدة.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'de', 'Sind Ihre Produkte zertifiziert?', 'Ja, alle unsere Produkte sind zertifiziert.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'en', 'Are your products certified?', 'Yes, all our products are certified and comply with international quality standards. We are committed to providing our customers with safe and reliable products.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'es', '¿Están certificados sus productos?', 'Sí, todos nuestros productos están certificados y cumplen con los estándares internacionales de calidad.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'fr', 'Vos produits sont-ils certifiés ?', 'Oui, tous nos produits sont certifiés.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'hi', 'क्या आपके उत्पाद प्रमाणित हैं?', 'हां, हमारे सभी उत्पाद प्रमाणित हैं।');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'id', 'Apakah produk Anda bersertifikat?', 'Ya, semua produk kami bersertifikat.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'it', 'I vostri prodotti sono certificati?', 'Sì, tutti i nostri prodotti sono certificati.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'ja', '製品は認証されていますか？', 'はい、すべての製品は認証されています。');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'ko', '제품이 인증되었습니까?', '예, 모든 제품은 인증되었습니다.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'pt', 'Seus produtos são certificados?', 'Sim, todos os nossos produtos são certificados.');
INSERT INTO `faq_translations` (`faq_id`, `language_code`, `question`, `answer`) VALUES (@last_faq_id, 'zh', '你们的产品有认证吗？', '是的，我们所有产品均已通过认证。');

-- Existing Seed Data
-- Seed data for i18n schema

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE `product_categories`;
TRUNCATE TABLE `product_images`;
TRUNCATE TABLE `product_translations`;
TRUNCATE TABLE `products`;
TRUNCATE TABLE `category_translations`;
TRUNCATE TABLE `categories`;
TRUNCATE TABLE `post_translations`;
TRUNCATE TABLE `posts`;
TRUNCATE TABLE `settings`;
TRUNCATE TABLE `users`;
TRUNCATE TABLE `navigation_items`;
TRUNCATE TABLE `page_translations`;
TRUNCATE TABLE `pages`;
SET FOREIGN_KEY_CHECKS = 1;

-- Categories
INSERT INTO `categories` (`id`, `parent_id`) VALUES (1, NULL), (2, NULL), (3, NULL), (4, NULL), (5, NULL);
INSERT INTO `category_translations` (`category_id`, `language_code`, `name`, `slug`, `description`, `seo_title`, `meta_description`) VALUES
(1, 'en', 'Sectional Doors', 'sectional-doors', 'Our sectional doors are engineered for reliability, security, and excellent thermal insulation. Available in a wide range of designs and finishes to perfectly match your home or industrial facility.', 'High-Quality Sectional Doors | Secure & Insulated | DoorHan', 'Discover our premium sectional doors, offering superior insulation, robust security, and modern designs. Perfect for residential garages and industrial applications.'),
(2, 'en', 'Roller Shutter Doors', 'roller-shutter-doors', 'DoorHan roller shutter doors are a compact and durable solution, ideal for applications where space is limited. They provide reliable security for garages, warehouses, and retail storefronts.', 'Durable Roller Shutter Doors | Space-Saving & Secure | DoorHan', 'Explore our space-saving and secure roller shutter doors. Built for durability and performance, they are the ideal choice for commercial and residential properties.'),
(3, 'en', 'High Speed Doors', 'high-speed-doors', 'Increase efficiency and maintain stable climate conditions with our high-speed doors. Designed for intensive use in industrial and commercial environments, they ensure optimized traffic flow and energy savings.', 'High-Speed Industrial Doors | Efficient & Reliable | DoorHan', 'Optimize your operations with DoorHan high-speed doors. Engineered for speed, reliability, and energy efficiency in demanding industrial environments.'),
(4, 'en', 'Folding Doors', 'folding-doors', 'Our industrial folding doors are the perfect solution for very large openings, such as aircraft hangars and large warehouse entrances. They offer robust construction and reliable performance.', 'Industrial Folding Doors for Large Openings | DoorHan', 'Secure and versatile industrial folding doors designed for extra-large openings. Discover our robust and reliable solutions for hangars, shipyards, and industrial facilities.'),
(5, 'en', 'Sliding Gates', 'sliding-gates', 'Automate and secure your property with our range of sliding gates. We offer reliable and aesthetically pleasing solutions for residential, commercial, and industrial applications.', 'Automatic Sliding Gates | Secure & Convenient | DoorHan', 'Enhance your property’s security and convenience with our automatic sliding gates. Durable, reliable, and available in various styles to suit your needs.'),
-- Spanish Translations
(1, 'es', 'Puertas Seccionales', 'puertas-seccionales', 'Nuestras puertas seccionales están diseñadas para ofrecer fiabilidad, seguridad y un excelente aislamiento térmico. Disponibles en una amplia gama de diseños y acabados para adaptarse perfectamente a su hogar o instalación industrial.', 'Puertas Seccionales de Alta Calidad | Seguras y Aislantes | DoorHan', 'Descubra nuestras puertas seccionales de primera calidad, que ofrecen un aislamiento superior, una seguridad robusta y diseños modernos. Perfectas para garajes residenciales e instalaciones industriales.'),
(2, 'es', 'Puertas Enrollables', 'puertas-enrollables', 'Las puertas enrollables de DoorHan son una solución compacta y duradera, ideal para aplicaciones donde el espacio es limitado. Proporcionan seguridad fiable para garajes, almacenes y fachadas de tiendas.', 'Puertas Enrollables Duraderas | Ahorro de Espacio y Seguridad | DoorHan', 'Explore nuestras puertas enrollables seguras y que ahorran espacio. Fabricadas para ofrecer durabilidad y rendimiento, son la opción ideal para propiedades comerciales y residenciales.'),
(3, 'es', 'Puertas Rápidas', 'puertas-rapidas', 'Aumente la eficiencia y mantenga condiciones climáticas estables con nuestras puertas rápidas. Diseñadas para un uso intensivo en entornos industriales y comerciales, garantizan un flujo de tráfico optimizado y un ahorro de energía.', 'Puertas Industriales Rápidas | Eficientes y Fiables | DoorHan', 'Optimice sus operaciones con las puertas rápidas de DoorHan. Diseñadas para ofrecer velocidad, fiabilidad y eficiencia energética en entornos industriales exigentes.'),
(4, 'es', 'Puertas Plegables', 'puertas-plegables', 'Nuestras puertas plegables industriales son la solución perfecta para aberturas muy grandes, como hangares de aviones y grandes entradas de almacenes. Ofrecen una construcción robusta y un rendimiento fiable.', 'Puertas Plegables Industriales para Grandes Aberturas | DoorHan', 'Puertas plegables industriales, seguras y versátiles, diseñadas para aberturas extragrandes. Descubra nuestras soluciones robustas y fiables para hangares, astilleros e instalaciones industriales.'),
(5, 'es', 'Portones Correderos', 'portones-correderos', 'Automatice y asegure su propiedad con nuestra gama de portones correderos. Ofrecemos soluciones fiables y estéticamente agradables para aplicaciones residenciales, comerciales e industriales.', 'Portones Correderos Automáticos | Seguros y Cómodos | DoorHan', 'Mejore la seguridad y comodidad de su propiedad con nuestros portones correderos automáticos. Duraderos, fiables y disponibles en varios estilos para adaptarse a sus necesidades.'),
-- Chinese Translations
(1, 'zh', '分段提升门', 'fen-duan-ti-sheng-men', '我们的分段门经过精心设计，具有高可靠性、安全性和出色的隔热性能。提供多种设计和饰面，完美匹配您的家庭或工业设施。', '高品质分段门 | 安全隔热 | DoorHan', '了解我们的优质分段门，提供卓越的隔热、强大的安全性和现代化的设计。是住宅车库和工业应用的理想选择。'),
(2, 'zh', '卷帘门', 'juan-lian-men', 'DoorHan卷帘门是一种紧凑耐用的解决方案，非常适用于空间有限的应用场景。它们为车库、仓库和零售店面提供可靠的安全保障。', '耐用型卷帘门 | 节省空间且安全 | DoorHan', '探索我们节省空间且安全的卷帘门。为耐用性和高性能而打造，是商业和住宅物业的理想选择。'),
(3, 'zh', '快速门', 'kuai-su-men', '使用我们的快速门提高效率并保持稳定的气候条件。专为工业和商业环境中的高强度使用而设计，确保优化的交通流量和节能效果。', '工业快速门 | 高效可靠 | DoorHan', '通过DoorHan快速门优化您的运营。专为要求严苛的工业环境中的速度、可靠性和能源效率而设计。'),
(4, 'zh', '折叠门', 'zhe-die-men', '我们的工业折叠门是飞机库和大型仓库入口等超大洞口的完美解决方案。它们提供坚固的结构和可靠的性能。', '适用于大型洞口的工业折叠门 | DoorHan', '安全多功能的工业折叠门，专为超大洞口设计。了解我们为飞机库、造船厂和工业设施提供的坚固可靠的解决方案。'),
(5, 'zh', '平移门', 'ping-yi-men', '通过我们的平移门系列，实现您财产的自动化和安全保障。我们为住宅、商业和工业应用提供可靠且美观的解决方案。', '自动平移门 | 安全便捷 | DoorHan', '通过我们的自动平移门，提升您财产的安全性和便利性。耐用、可靠，并提供多种风格以满足您的需求。');

-- Products
INSERT INTO `products` (`id`, `status`) VALUES
(1, 'active'), (2, 'active'), (3, 'active'), (4, 'active'), (5, 'active'),
(6, 'active'), (7, 'active'), (8, 'active'), (9, 'active');

INSERT INTO `product_translations` (`product_id`, `language_code`, `name`, `slug`, `content`, `seo_title`, `meta_description`, `max_width`, `max_height`, `panel_thickness`, `insulation`) VALUES
(1, 'en', 'Sectional Door RSD01', 'sectional-door-rsd01', '<p>The RSD01 sectional door is a classic and affordable solution for residential garages. It combines a traditional design with robust construction and reliable components, ensuring long-term performance. The panels are filled with polyurethane foam for effective insulation.</p>', 'Affordable Sectional Garage Door RSD01 | DoorHan', 'The RSD01 is a reliable and cost-effective sectional garage door with a classic design. Get a quote for this durable and insulated solution today!', '3000 mm', '2700 mm', '40 mm', 'Polyurethane'),
(2, 'en', 'Sectional Door RSD02', 'sectional-door-rsd02', '<p>The RSD02 is a premium sectional door featuring thick sandwich panels for superior thermal and acoustic insulation. It is the perfect choice for heated garages or workshops, offering maximum energy efficiency and a sleek, modern appearance.</p>', 'Premium Insulated Sectional Door RSD02 | DoorHan', 'Experience superior thermal insulation and security with the RSD02 sectional door. Its 40mm panels make it ideal for heated garages and modern homes.', '6000 mm', '3100 mm', '40 mm', 'Polyurethane'),
(3, 'en', 'Roller Shutter RH77', 'roller-shutter-rh77', '<p>The RH77 roller shutter is a versatile security door constructed from strong steel profiles. Its space-saving design makes it ideal for garages with limited headroom, as well as for securing retail storefronts and commercial premises.</p>', 'Secure Steel Roller Shutter Door RH77 | DoorHan', 'The RH77 is a compact and highly secure roller shutter door. Made from durable steel, it’s a perfect security solution for garages and retail spaces.', '5000 mm', '4000 mm', '19 mm', 'None'),
(4, 'en', 'High Speed Door D-313', 'high-speed-door-d313', '<p>The D-313 is a flexible high-speed PVC roll-up door designed for interior applications. It enhances workflow, separates working areas, and helps maintain climate control, making it essential for logistics, food, and pharmaceutical industries.</p>', 'Interior High-Speed PVC Door D-313 | DoorHan', 'Improve logistics and climate control with the D-313 high-speed door. This fast and reliable PVC door is designed for intensive interior use.', '4000 mm', '4000 mm', 'N/A', 'PVC'),
(5, 'en', 'Industrial Sectional Door ISD01', 'industrial-sectional-door-isd01', '<p>The ISD01 is a heavy-duty sectional door engineered for industrial environments. It is built with reinforced components to withstand intensive use in warehouses, loading docks, and production facilities, offering maximum durability and security.</p>', 'Heavy-Duty Industrial Sectional Door ISD01 | DoorHan', 'The ISD01 is a robust and secure sectional door for all types of industrial buildings. Designed for large openings and intensive operation cycles.', '8000 mm', '7000 mm', '40 mm', 'Polyurethane'),
(6, 'en', 'Yett 01', 'yett-01', '<p>The Yett 01 garage door combines a contemporary aesthetic with user-friendly installation. It is an excellent choice for modern homes, offering a balance of style, functionality, and affordability. The door is delivered as a pre-assembled kit for easy DIY installation.</p>', 'Modern DIY Garage Door Yett 01 | DoorHan', 'Yett 01 delivers a perfect mix of modern design, security, and affordability. This easy-to-install kit is the ideal choice for residential garages.', '3000 mm', '2700 mm', '40 mm', 'Polyurethane'),
(7, 'en', 'Yett 02', 'yett-02', '<p>The Yett 02 series represents our premium residential garage door solution. With superior insulation, a wide range of exclusive finishes, and enhanced security features, the Yett 02 is the ultimate choice for homeowners seeking the best in quality and design.</p>', 'Premium Insulated Residential Door Yett 02 | DoorHan', 'Keep your garage warm and secure with the Yett 02. This premium door features superior insulation, a high-end finish, and advanced security.', '5500 mm', '3000 mm', '40 mm', 'Polyurethane'),
(8, 'en', 'Folding Gate', 'folding-gate', '<p>Our industrial folding gates are custom-built to close extra-large openings in facilities like aircraft hangars, shipyards, and railway depots. Their robust design ensures reliable operation even in the most demanding conditions, allowing for maximum clear width.</p>', 'Custom Industrial Folding Gates for Hangars | DoorHan', 'Our industrial folding gates are the definitive solution for extra-large openings. Custom-engineered for reliability in aircraft hangars and shipyards.', '30000 mm', '8000 mm', 'N/A', 'Mineral Wool'),
(9, 'en', 'Sliding Gate DIY', 'sliding-gate-diy', '<p>This all-in-one DIY kit includes everything you need to install a self-supporting sliding gate. The kit is designed for easy assembly and installation, providing a modern, reliable, and cost-effective solution for automating your driveway entrance.</p>', 'Complete DIY Sliding Gate Kit | Easy Installation | DoorHan', 'Get our complete DIY kit to easily install a modern and reliable sliding gate. This all-in-one package is perfect for residential property access.', '4500 mm', '2200 mm', 'N/A', 'None'),
-- Spanish Translations
(1, 'es', 'Puerta Seccional RSD01', 'puerta-seccional-rsd01', '<p>La puerta seccional RSD01 es una solución clásica y asequible para garajes residenciales. Combina un diseño tradicional con una construcción robusta y componentes fiables, garantizando un rendimiento a largo plazo. Los paneles están rellenos de espuma de poliuretano para un aislamiento eficaz.</p>', 'Puerta de Garaje Seccional Asequible RSD01 | DoorHan', 'La RSD01 es una puerta de garaje seccional fiable y económica con un diseño clásico. ¡Pida hoy mismo un presupuesto para esta solución duradera y aislante!', '3000 mm', '2700 mm', '40 mm', 'Poliuretano'),
(2, 'es', 'Puerta Seccional RSD02', 'puerta-seccional-rsd02', '<p>La RSD02 es una puerta seccional de gama alta con paneles sándwich gruesos para un aislamiento térmico y acústico superior. Es la opción perfecta para garajes o talleres con calefacción, ya que ofrece la máxima eficiencia energética y un aspecto elegante y moderno.</p>', 'Puerta Seccional Premium Aislante RSD02 | DoorHan', 'Experimente un aislamiento térmico y una seguridad superiores con la puerta seccional RSD02. Sus paneles de 40 mm la hacen ideal para garajes con calefacción y hogares modernos.', '6000 mm', '3100 mm', '40 mm', 'Poliuretano'),
(3, 'es', 'Puerta Enrollable RH77', 'puerta-enrollable-rh77', '<p>La persiana enrollable RH77 es una versátil puerta de seguridad fabricada con resistentes perfiles de acero. Su diseño compacto la hace ideal para garajes con altura libre limitada, así como para proteger escaparates y locales comerciales.</p>', 'Puerta Enrollable de Acero Segura RH77 | DoorHan', 'La RH77 es una puerta enrollable compacta y de alta seguridad. Fabricada en acero duradero, es una solución de seguridad perfecta para garajes y locales comerciales.', '5000 mm', '4000 mm', '19 mm', 'Ninguno'),
(4, 'es', 'Puerta Rápida D-313', 'puerta-rapida-d313', '<p>La D-313 es una puerta enrollable de PVC flexible de alta velocidad diseñada para aplicaciones interiores. Mejora el flujo de trabajo, separa áreas de trabajo y ayuda a mantener el control climático, por lo que es esencial para las industrias de logística, alimentaria y farmacéutica.</p>', 'Puerta Rápida de PVC para Interiores D-313 | DoorHan', 'Mejore la logística y el control climático con la puerta rápida D-313. Esta puerta de PVC rápida y fiable está diseñada para un uso interior intensivo.', '4000 mm', '4000 mm', 'N/A', 'PVC'),
(5, 'es', 'Puerta Seccional Industrial ISD01', 'puerta-seccional-industrial-isd01', '<p>La ISD01 es una puerta seccional de alta resistencia diseñada para entornos industriales. Está construida con componentes reforzados para soportar un uso intensivo en almacenes, muelles de carga e instalaciones de producción, ofreciendo la máxima durabilidad y seguridad.</p>', 'Puerta Seccional Industrial de Alta Resistencia ISD01 | DoorHan', 'La ISD01 es una puerta seccional robusta y segura para todo tipo de edificios industriales. Diseñada para grandes aperturas y ciclos de funcionamiento intensivos.', '8000 mm', '7000 mm', '40 mm', 'Poliuretano'),
(6, 'es', 'Yett 01', 'yett-01', '<p>La puerta de garaje Yett 01 combina una estética contemporánea con una instalación sencilla. Es una excelente opción para hogares modernos, ya que ofrece un equilibrio entre estilo, funcionalidad y asequibilidad. La puerta se entrega como un kit premontado para facilitar la instalación por parte del usuario.</p>', 'Puerta de Garaje Moderna DIY Yett 01 | DoorHan', 'Yett 01 ofrece una mezcla perfecta de diseño moderno, seguridad y asequibilidad. Este kit de fácil instalación es la opción ideal para garajes residenciales.', '3000 mm', '2700 mm', '40 mm', 'Poliuretano'),
(7, 'es', 'Yett 02', 'yett-02', '<p>La serie Yett 02 representa nuestra solución de puertas de garaje residenciales de primera calidad. Con un aislamiento superior, una amplia gama de acabados exclusivos y características de seguridad mejoradas, la Yett 02 es la opción definitiva para los propietarios que buscan lo mejor en calidad y diseño.</p>', 'Puerta Residencial Premium Aislante Yett 02 | DoorHan', 'Mantenga su garaje cálido y seguro con la Yett 02. Esta puerta de primera calidad cuenta con un aislamiento superior, un acabado de alta gama y seguridad avanzada.', '5500 mm', '3000 mm', '40 mm', 'Poliuretano'),
(8, 'es', 'Portón Plegable', 'porton-plegable', '<p>Nuestros portones plegables industriales se fabrican a medida para cerrar aberturas extragrandes en instalaciones como hangares de aviones, astilleros y cocheras de ferrocarril. Su robusto diseño garantiza un funcionamiento fiable incluso en las condiciones más exigentes, permitiendo la máxima anchura libre.</p>', 'Portones Plegables Industriales a Medida para Hangares | DoorHan', 'Nuestros portones plegables industriales son la solución definitiva para aberturas extragrandes. Diseñados a medida para garantizar su fiabilidad en hangares de aviones y astilleros.', '30000 mm', '8000 mm', 'N/A', 'Lana mineral'),
(9, 'es', 'Portón Corredero DIY', 'porton-corredero-diy', '<p>Este kit todo en uno de bricolaje incluye todo lo que necesita para instalar un portón corredero autoportante. El kit está diseñado para un fácil montaje e instalación, proporcionando una solución moderna, fiable y rentable para automatizar la entrada de su vehículo.</p>', 'Kit Completo de Portón Corredero DIY | Fácil Instalación | DoorHan', 'Consiga nuestro completo kit de bricolaje para instalar fácilmente un portón corredero moderno y fiable. Este paquete todo en uno es perfecto para el acceso a propiedades residenciales.', '4500 mm', '2200 mm', 'N/A', 'Ninguno'),
-- Chinese Translations
(1, 'zh', '分段门 RSD01', 'fen-duan-men-rsd01', '<p>RSD01分段门是住宅车库的经典且经济实惠的解决方案。它结合了传统设计、坚固的结构和可靠的组件，确保长期性能。门板填充有聚氨酯泡沫，以实现有效的隔热。</p>', '经济实惠的分段车库门 RSD01 | DoorHan', 'RSD01是一款可靠且经济高效的分段车库门，采用经典设计。立即获取这款耐用隔热解决方案的报价！', '3000 mm', '2700 mm', '40 mm', '聚氨酯'),
(2, 'zh', '分段门 RSD02', 'fen-duan-men-rsd02', '<p>RSD02是一款优质分段门，采用厚夹芯板，具有卓越的隔热和隔音性能。它是加热车库或车间的完美选择，提供最大的能源效率和时尚现代的外观。</p>', '优质隔热分段门 RSD02 | DoorHan', '体验RSD02分段门卓越的隔热和安全性能。其40毫米厚的门板使其成为加热车库和现代家庭的理想选择。', '6000 mm', '3100 mm', '40 mm', '聚氨酯'),
(3, 'zh', '卷帘门 RH77', 'juan-lian-men-rh77', '<p>RH77卷帘门是由坚固的钢型材构成的多功能安全门。其节省空间的设计使其非常适用于净空有限的车库，以及保护零售店面和商业场所。</p>', '安全钢制卷帘门 RH77 | DoorHan', 'RH77是一款紧凑且高度安全的卷帘门。由耐用钢材制成，是车库和零售空间的完美安全解决方案。', '5000 mm', '4000 mm', '19 mm', '无'),
(4, 'zh', '快速门 D-313', 'kuai-su-men-d313', '<p>D-313是专为室内应用设计的柔性高速PVC卷帘门。它能改善工作流程、分隔工作区域并帮助维持气候控制，使其成为物流、食品和制药行业必不可少的设备。</p>', '室内高速PVC门 D-313 | DoorHan', '使用D-313高速门改善物流和气候控制。这款快速可靠的PVC门专为高强度室内使用而设计。', '4000 mm', '4000 mm', 'N/A', 'PVC'),
(5, 'zh', '工业分段门 ISD01', 'gong-ye-fen-duan-men-isd01', '<p>ISD01是专为工业环境设计的重型分段门。它采用加固组件制造，可承受仓库、装卸平台和生产设施的高强度使用，提供最大的耐用性和安全性。</p>', '重型工业分段门 ISD01 | DoorHan', 'ISD01是适用于所有类型工业建筑的坚固安全的分段门。专为大型洞口和高强度操作循环而设计。', '8000 mm', '7000 mm', '40 mm', '聚氨酯'),
(6, 'zh', 'Yett 01', 'yett-01', '<p>Yett 01车库门将现代美学与用户友好的安装相结合。它是现代家庭的绝佳选择，实现了风格、功能和经济性的平衡。该门以预组装套件形式交付，便于自行安装。</p>', '现代DIY车库门 Yett 01 | DoorHan', 'Yett 01完美融合了现代设计、安全性和经济性。这款易于安装的套件是住宅车库的理想选择。', '3000 mm', '2700 mm', '40 mm', '聚氨酯'),
(7, 'zh', 'Yett 02', 'yett-02', '<p>Yett 02系列代表了我们的优质住宅车库门解决方案。凭借卓越的隔热性能、多种独特的饰面和增强的安全功能，Yett 02是追求最佳质量和设计的房主的终极选择。', '优质隔热住宅门 Yett 02 | DoorHan', '使用Yett 02让您的车库保持温暖和安全。这款优质门具有卓越的隔热性能、高端饰面和先进的安全性。', '5500 mm', '3000 mm', '40 mm', '聚氨酯'),
(8, 'zh', '折叠门', 'zhe-die-men', '<p>我们的工业折叠门是为飞机库、造船厂和铁路车库等设施中的超大洞口定制的。其坚固的设计确保即使在最苛刻的条件下也能可靠运行，并允许最大的净宽度。', '定制机库工业折叠门 | DoorHan', '我们的工业折叠门是超大洞口的终极解决方案。为飞机库和造船厂的可靠性而定制设计。', '30000 mm', '8000 mm', 'N/A', '矿棉'),
(9, 'zh', '平移门DIY', 'ping-yi-men-diy', '<p>这款一体化DIY套件包含安装自支撑平移门所需的一切。该套件设计用于轻松组装和安装，为自动化您的车道入口提供了一个现代、可靠且经济高效的解决方案。', '完整DIY平移门套件 | 安装简便 | DoorHan', '获取我们完整的DIY套件，轻松安装现代可靠的平移门。这款一体化套装非常适合住宅物业的入口。', '4500 mm', '2200 mm', 'N/A', '无');

-- Product-category mapping
INSERT INTO `product_categories` (`product_id`, `category_id`, `is_primary`) VALUES
(1, 1, 1), (2, 1, 1), (3, 2, 1), (4, 3, 1), (5, 1, 1), (6, 1, 1), (7, 1, 1), (8, 4, 1), (9, 5, 1);

-- Posts
INSERT INTO `posts` (`id`, `status`, `created_at`, `image`, `image2`, `image3`) VALUES
(1, 'published', '2023-10-26 10:00:00', 'news1.jpg', 'news1-2.jpg', NULL),
(2, 'published', '2023-10-27 11:00:00', 'news2.jpg', NULL, NULL),
(3, 'published', '2023-10-28 12:00:00', 'news3.jpg', 'news3-2.jpg', 'news3-3.jpg');

INSERT INTO `post_translations` (`post_id`, `language_code`, `title`, `slug`, `content`, `seo_title`, `meta_description`) VALUES
(1, 'en', 'DoorHan Launches New Line of Premium Residential Doors', 'new-premium-residential-doors', '<p>We are thrilled to announce the launch of our new Yett series, a premium line of residential garage doors. Combining cutting-edge technology with sophisticated design, the Yett series offers homeowners unparalleled security, insulation, and style. Visit our products page to explore the new collection.</p>', 'DoorHan Launches New Yett Series of Premium Garage Doors', 'Discover the new Yett series from DoorHan. A premium line of residential garage doors offering advanced security, superior insulation, and modern design.'),
(2, 'en', 'Visit DoorHan at the International Construction Exhibition 2023', 'doorhan-at-construction-exhibition-2023', '<p>DoorHan is excited to confirm its participation in the International Construction Exhibition 2023. We will be showcasing our latest innovations in industrial doors and automation systems. Join us at booth #42B to see live demonstrations and speak with our experts.</p>', 'Meet DoorHan at the International Construction Exhibition 2023', 'Join DoorHan at the International Construction Exhibition 2023. Visit booth #42B to discover our latest innovations in industrial doors and automation.'),
(3, 'en', 'Essential Maintenance Tips for Your Garage Door', 'essential-garage-door-maintenance-tips', '<p>Proper maintenance is key to ensuring the longevity and safe operation of your garage door. In this post, we share essential tips, from lubricating moving parts to checking the balance. Following these simple steps can prevent costly repairs and extend the life of your door.</p>', 'Top Maintenance Tips for a Long-Lasting Garage Door | DoorHan', 'Learn how to properly maintain your garage door with our essential tips. Ensure safety, prevent costly repairs, and extend the life of your door with these simple steps.'),
-- Spanish Translations
(1, 'es', 'DoorHan Lanza Nueva Línea de Puertas Residenciales Premium', 'nueva-linea-puertas-residenciales-premium', '<p>Estamos encantados de anunciar el lanzamiento de nuestra nueva serie Yett, una línea premium de puertas de garaje residenciales. Combinando tecnología de vanguardia con un diseño sofisticado, la serie Yett ofrece a los propietarios una seguridad, aislamiento y estilo inigualables. Visite nuestra página de productos para explorar la nueva colección.</p>', 'DoorHan Lanza la Nueva Serie Yett de Puertas de Garaje Premium', 'Descubra la nueva serie Yett de DoorHan. Una línea premium de puertas de garaje residenciales que ofrece seguridad avanzada, aislamiento superior y diseño moderno.'),
(2, 'es', 'Visite a DoorHan en la Exposición Internacional de la Construcción 2023', 'doorhan-en-exposicion-internacional-construccion-2023', '<p>DoorHan se complace en confirmar su participación en la Exposición Internacional de la Construcción 2023. Estaremos presentando nuestras últimas innovaciones en puertas industriales y sistemas de automatización. Visítenos en el stand #42B para ver demostraciones en vivo y hablar con nuestros expertos.</p>', 'Encuentre a DoorHan en la Exposición Internacional de la Construcción 2023', 'Únase a DoorHan en la Exposición Internacional de la Construcción 2023. Visite el stand #42B para descubrir nuestras últimas innovaciones en puertas industriales y automatización.'),
(3, 'es', 'Consejos Esenciales para el Mantenimiento de su Puerta de Garaje', 'consejos-esenciales-mantenimiento-puerta-garaje', '<p>Un mantenimiento adecuado es clave para garantizar la longevidad y el funcionamiento seguro de su puerta de garaje. En esta publicación, compartimos consejos esenciales, desde la lubricación de las piezas móviles hasta la comprobación del equilibrio. Seguir estos sencillos pasos puede evitar reparaciones costosas y prolongar la vida útil de su puerta.</p>', 'Los Mejores Consejos de Mantenimiento para una Puerta de Garaje Duradera | DoorHan', 'Aprenda a mantener adecuadamente su puerta de garaje con nuestros consejos esenciales. Garantice la seguridad, evite reparaciones costosas y prolongue la vida útil de su puerta con estos sencillos pasos.'),
-- Chinese Translations
(1, 'zh', 'DoorHan推出全新高端住宅门系列', '全新高端住宅门系列', '<p>我们非常激动地宣布推出全新的Yett系列高端住宅车库门。Yett系列将尖端技术与精致设计相结合，为房主提供无与伦比的安全性、隔热性和风格。请访问我们的产品页面，探索新系列。', 'DoorHan推出全新Yett系列高端车库门', '探索DoorHan全新的Yett系列。一个提供先进安全性、卓越隔热性和现代设计的高端住宅车库门系列。'),
(2, 'zh', '欢迎参观2023年国际建筑展览会的DoorHan展台', 'doorhan-2023-国际建筑展览会', '<p>DoorHan很高兴地确认将参加2023年国际建筑展览会。我们将展示我们在工业门和自动化系统方面的最新创新。欢迎莅临42B展台观看现场演示并与我们的专家交流。', '在2023年国际建筑展览会与DoorHan会面', '欢迎参加2023年国际建筑展览会的DoorHan展台。请访问42B展台，了解我们在工业门和自动化领域的最新创新。'),
(3, 'zh', '车库门基本维护技巧', '车库门基本维护技巧', '<p>适当的维护是确保车库门使用寿命和安全运行的关键。在这篇文章中，我们分享了从润滑活动部件到检查平衡等基本技巧。遵循这些简单的步骤可以避免昂贵的维修，并延长您门的使用寿命。', '延长车库门使用寿命的最佳维护技巧 | DoorHan', '通过我们的基本技巧，了解如何正确维护您的车库门。通过这些简单的步骤，确保安全，避免昂贵的维修，并延长您门的使用寿命。');

-- Settings
INSERT INTO `settings` (`key`, `value`) VALUES
('site_title', 'DoorHan'),
('contact_email', 'info@doorhan.com'),
('footer_about', 'DoorHan is a leading global manufacturer of gates, doors, and automation systems, offering innovative and reliable solutions for over 30 years.'),
('facebook_url', 'https://www.facebook.com/DoorHan'),
('linkedin_url', 'https://www.linkedin.com/company/doorhan'),
('youtube_url', 'https://www.youtube.com/user/DoorHan');

-- Administrator (password: P@ssw0rd123!)
INSERT INTO `users` (`username`, `password`, `role`) VALUES
('admin', '$2y$10$xH0YiKX4gw55ZIL2Z3KVOe3PPocrQCg75yAZv7zeHb2zB6lkqWNX6', 'admin');

-- Navigation items
INSERT INTO `navigation_items` (`title`, `url`, `parent_id`, `menu_order`) VALUES
('Home', '/', NULL, 1),
('Products', '/products', NULL, 2),
('News', '/news', NULL, 3),
('About', '/about', NULL, 4),
('Contact', '/contact', NULL, 5);
