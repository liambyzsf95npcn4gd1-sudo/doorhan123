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
(1, 'en', 'Sectional Doors', 'sectional-doors', '', 'Sectional Garage Doors | DoorHan', 'Modern and efficient sectional garage doors that provide excellent insulation and security.'),
(2, 'en', 'Roller Shutter Doors', 'roller-shutter-doors', '', 'Roller Shutter Garage Doors | DoorHan', 'Space-saving and durable roller shutter doors, ideal for garages with limited headroom.'),
(3, 'en', 'High Speed Doors', 'high-speed-doors', '', 'High-Speed Industrial Doors | DoorHan', 'Optimize your workflow with our fast and reliable high-speed industrial doors.'),
(4, 'en', 'Folding Doors', 'folding-doors', '', 'Industrial Folding Doors | DoorHan', 'Versatile and robust folding doors for large openings in industrial facilities.'),
(5, 'en', 'Sliding Gates', 'sliding-gates', '', 'Sliding Gates | DoorHan', 'Automatic sliding gates for secure and convenient access to your property.');

-- Products
INSERT INTO `products` (`id`, `status`) VALUES
(1, 'active'), (2, 'active'), (3, 'active'), (4, 'active'), (5, 'active'),
(6, 'active'), (7, 'active'), (8, 'active'), (9, 'active');

INSERT INTO `product_translations` (`product_id`, `language_code`, `name`, `slug`, `content`, `seo_title`, `meta_description`, `max_width`, `max_height`, `panel_thickness`, `insulation`) VALUES
(1, 'en', 'Sectional Door RSD01', 'sectional-door-rsd01', '<p>The RSD01 sectional door is a reliable and durable solution for your garage. It offers a classic design with robust construction.</p>', 'Sectional Door RSD01 | DoorHan', 'The RSD01 is a reliable and durable sectional garage door. Get a quote today!', '3000 mm', '2700 mm', '40 mm', 'Polyurethane'),
(2, 'en', 'Sectional Door RSD02', 'sectional-door-rsd02', '<p>The RSD02 sectional door offers excellent thermal insulation thanks to its sandwich panels. Perfect for heated garages.</p>', 'Insulated Sectional Door RSD02 | DoorHan', 'The RSD02 sectional door provides excellent thermal insulation and security for your garage.', '6000 mm', '3100 mm', '40 mm', 'Polyurethane'),
(3, 'en', 'Roller Shutter RH77', 'roller-shutter-rh77', '<p>A compact and convenient roller shutter door made of steel profiles. Ideal for garages and retail spaces.</p>', 'Roller Shutter Door RH77 | DoorHan', 'The RH77 is a compact and secure roller shutter door, perfect for various applications.', '5000 mm', '4000 mm', '19 mm', 'None'),
(4, 'en', 'High Speed Door D-313', 'high-speed-door-d313', '<p>A high-speed PVC door for intensive use in interior spaces. It helps to maintain climate control and workflow.</p>', 'High Speed Door D-313 | DoorHan', 'The D-313 is a high-speed door designed for intensive use in industrial and commercial environments.', '4000 mm', '4000 mm', 'N/A', 'PVC'),
(5, 'en', 'Industrial Sectional Door ISD01', 'industrial-sectional-door-isd01', '<p>A robust sectional door for industrial applications. It is designed for large openings and intensive use.</p>', 'Industrial Sectional Door ISD01 | DoorHan', 'The ISD01 is a robust and reliable sectional door for all types of industrial buildings.', '8000 mm', '7000 mm', '40 mm', 'Polyurethane'),
(6, 'en', 'Yett 01', 'yett-01', '<p>Yett 01 is a great choice for residential garages. It features a modern design and is easy to install.</p>', 'Yett 01 Residential Door | DoorHan', 'Yett 01 offers the perfect balance of modern design, security, and affordability for your home.', '3000 mm', '2700 mm', '40 mm', 'Polyurethane'),
(7, 'en', 'Yett 02', 'yett-02', '<p>Yett 02 provides superior insulation and a premium finish. It is the top choice for modern homes.</p>', 'Yett 02 Insulated Residential Door | DoorHan', 'Keep your garage warm and secure with the Yett 02, featuring superior insulation properties.', '5500 mm', '3000 mm', '40 mm', 'Polyurethane'),
(8, 'en', 'Folding Gate', 'folding-gate', '<p>Industrial folding gate for hangars and depots. Allows for maximum opening width.</p>', 'Industrial Folding Gate | DoorHan', 'Our industrial folding gates are the perfect solution for extra-large openings like aircraft hangars.', '30000 mm', '8000 mm', 'N/A', 'Mineral Wool'),
(9, 'en', 'Sliding Gate DIY', 'sliding-gate-diy', '<p>A complete DIY kit for a self-supporting sliding gate. Easy to assemble and install.</p>', 'DIY Sliding Gate Kit | DoorHan', 'Get our complete DIY kit to easily install a modern and reliable sliding gate on your property.', '4500 mm', '2200 mm', 'N/A', 'None');

-- Product-category mapping
INSERT INTO `product_categories` (`product_id`, `category_id`, `is_primary`) VALUES
(1, 1, 1), (2, 1, 1), (3, 2, 1), (4, 3, 1), (5, 1, 1), (6, 1, 1), (7, 1, 1), (8, 4, 1), (9, 5, 1);

-- Posts
INSERT INTO `posts` (`id`, `status`, `created_at`) VALUES
(1, 'published', '2023-10-26 10:00:00'),
(2, 'published', '2023-10-27 11:00:00'),
(3, 'draft', '2023-10-28 12:00:00');

INSERT INTO `post_translations` (`post_id`, `language_code`, `title`, `slug`, `content`, `seo_title`, `meta_description`) VALUES
(1, 'en', 'New Product Line', 'new-product-line', '<p>We are excited to announce our new product line.</p>', 'New Product Line', 'We are excited to announce our new product line.'),
(2, 'en', 'DoorHan at Exhibition', 'doorhan-at-exhibition', '<p>DoorHan will be participating in the upcoming construction exhibition.</p>', 'DoorHan at Exhibition', 'DoorHan will be participating in the upcoming construction exhibition.'),
(3, 'en', 'Maintenance Tips', 'maintenance-tips', '<p>Here are some tips for maintaining your garage door.</p>', 'Maintenance Tips', 'Here are some tips for maintaining your garage door.');

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
('News', '/news', NULL, 3),
('About', '/about', NULL, 4),
('Contact', '/contact', NULL, 5);
