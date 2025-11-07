--
-- Seeding data for the DoorHan website
--

-- Categories
INSERT INTO `categories` (`id`, `parent_id`, `name`, `slug`, `seo_title`, `meta_description`) VALUES
(1, NULL, 'Garage Doors', 'garage-doors', 'Garage Doors', 'High quality garage doors for your home.'),
(2, 1, 'Sectional Doors', 'sectional-doors', 'Sectional Garage Doors', 'Sectional garage doors for residential and commercial use.'),
(3, 1, 'Roller Shutter Doors', 'roller-shutter-doors', 'Roller Shutter Garage Doors', 'Roller shutter garage doors for tight spaces.'),
(4, NULL, 'Industrial Doors', 'industrial-doors', 'Industrial Doors', 'Industrial doors for various applications.'),
(5, 4, 'High Speed Doors', 'high-speed-doors', 'High Speed Industrial Doors', 'High speed doors for industrial and commercial use.');

-- Products
INSERT INTO `products` (`id`, `name`, `slug`, `content`, `status`, `seo_title`, `meta_description`) VALUES
(1, 'Sectional Door RSD01', 'sectional-door-rsd01', '<p>The RSD01 sectional door is a reliable and durable solution for your garage.</p>', 'active', 'Sectional Door RSD01', 'Sectional Door RSD01 - reliable and durable.'),
(2, 'Sectional Door RSD02', 'sectional-door-rsd02', '<p>The RSD02 sectional door offers excellent thermal insulation.</p>', 'active', 'Sectional Door RSD02', 'Sectional Door RSD02 - excellent thermal insulation.'),
(3, 'Roller Shutter Door', 'roller-shutter-door', '<p>A compact and convenient roller shutter door.</p>', 'active', 'Roller Shutter Door', 'A compact and convenient roller shutter door.'),
(4, 'High Speed Door', 'high-speed-door', '<p>A high-speed door for intensive use.</p>', 'active', 'High Speed Door', 'A high-speed door for intensive use.'),
(5, 'Industrial Sectional Door', 'industrial-sectional-door', '<p>A robust sectional door for industrial applications.</p>', 'active', 'Industrial Sectional Door', 'A robust sectional door for industrial applications.');

-- Product-category mapping
INSERT INTO `product_categories` (`product_id`, `category_id`, `is_primary`) VALUES
(1, 2, 1),
(2, 2, 1),
(3, 3, 1),
(4, 5, 1),
(5, 4, 1);

-- News (blog)
INSERT INTO `posts` (`id`, `slug`, `title`, `content`, `status`, `created_at`, `seo_title`, `meta_description`) VALUES
(1, 'new-product-line', 'New Product Line', '<p>We are excited to announce our new product line.</p>', 'published', '2023-10-26 10:00:00', 'New Product Line', 'We are excited to announce our new product line.'),
(2, 'doorhan-at-exhibition', 'DoorHan at Exhibition', '<p>DoorHan will be participating in the upcoming construction exhibition.</p>', 'published', '2023-10-27 11:00:00', 'DoorHan at Exhibition', 'DoorHan will be participating in the upcoming construction exhibition.'),
(3, 'maintenance-tips', 'Maintenance Tips', '<p>Here are some tips for maintaining your garage door.</p>', 'draft', '2023-10-28 12:00:00', 'Maintenance Tips', 'Here are some tips for maintaining your garage door.');

-- Settings
INSERT INTO `settings` (`key`, `value`) VALUES
('site_title', 'DoorHan'),
('contact_email', 'admin@doorhan.com'),
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
('Sectional Doors', '/products/sectional-doors', 2, 1),
('Roller Shutters', '/products/roller-shutters', 2, 2),
('News', '/news', NULL, 3),
('About', '/about', NULL, 4),
('Contact', '/contact', NULL, 5);
