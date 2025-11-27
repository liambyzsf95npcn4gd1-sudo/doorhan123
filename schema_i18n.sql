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
