--
-- Seeding data for the DoorHan website
--

-- Clear existing data
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE `product_categories`;
TRUNCATE TABLE `product_images`;
TRUNCATE TABLE `products`;
TRUNCATE TABLE `categories`;
TRUNCATE TABLE `posts`;
TRUNCATE TABLE `settings`;
TRUNCATE TABLE `users`;
TRUNCATE TABLE `navigation_items`;
SET FOREIGN_KEY_CHECKS = 1;

-- Categories
INSERT INTO `categories` (`id`, `parent_id`, `name`, `slug`, `seo_title`, `meta_description`) VALUES
(1, NULL, 'Sectional Doors', 'sectional-doors', 'Sectional Garage Doors | DoorHan', 'Modern and efficient sectional garage doors that provide excellent insulation and security.'),
(2, NULL, 'Roller Shutter Doors', 'roller-shutter-doors', 'Roller Shutter Garage Doors | DoorHan', 'Space-saving and durable roller shutter doors, ideal for garages with limited headroom.'),
(3, NULL, 'High Speed Doors', 'high-speed-doors', 'High-Speed Industrial Doors | DoorHan', 'Optimize your workflow with our fast and reliable high-speed industrial doors.'),
(4, NULL, 'Folding Doors', 'folding-doors', 'Industrial Folding Doors | DoorHan', 'Versatile and robust folding doors for large openings in industrial facilities.'),
(5, NULL, 'Sliding Gates', 'sliding-gates', 'Sliding Gates | DoorHan', 'Automatic sliding gates for secure and convenient access to your property.');

-- Products
INSERT INTO `products` (`id`, `name`, `slug`, `content`, `status`, `seo_title`, `meta_description`) VALUES
(1, 'Sectional Door RSD01', 'sectional-door-rsd01', '<p>The RSD01 sectional door is a reliable and durable solution for your garage. It offers a classic design with robust construction.</p>', 'active', 'Sectional Door RSD01 | DoorHan', 'The RSD01 is a reliable and durable sectional garage door. Get a quote today!'),
(2, 'Sectional Door RSD02', 'sectional-door-rsd02', '<p>The RSD02 sectional door offers excellent thermal insulation thanks to its sandwich panels. Perfect for heated garages.</p>', 'active', 'Insulated Sectional Door RSD02 | DoorHan', 'The RSD02 sectional door provides excellent thermal insulation and security for your garage.'),
(3, 'Roller Shutter RH77', 'roller-shutter-rh77', '<p>A compact and convenient roller shutter door made of steel profiles. Ideal for garages and retail spaces.</p>', 'active', 'Roller Shutter Door RH77 | DoorHan', 'The RH77 is a compact and secure roller shutter door, perfect for various applications.'),
(4, 'High Speed Door D-313', 'high-speed-door-d313', '<p>A high-speed PVC door for intensive use in interior spaces. It helps to maintain climate control and workflow.</p>', 'active', 'High Speed Door D-313 | DoorHan', 'The D-313 is a high-speed door designed for intensive use in industrial and commercial environments.'),
(5, 'Industrial Sectional Door ISD01', 'industrial-sectional-door-isd01', '<p>A robust sectional door for industrial applications. It is designed for large openings and intensive use.</p>', 'active', 'Industrial Sectional Door ISD01 | DoorHan', 'The ISD01 is a robust and reliable sectional door for all types of industrial buildings.'),
(6, 'Yett 01', 'yett-01', '<p>Yett 01 is a great choice for residential garages. It features a modern design and is easy to install.</p>', 'active', 'Yett 01 Residential Door | DoorHan', 'Yett 01 offers the perfect balance of modern design, security, and affordability for your home.'),
(7, 'Yett 02', 'yett-02', '<p>Yett 02 provides superior insulation and a premium finish. It is the top choice for modern homes.</p>', 'active', 'Yett 02 Insulated Residential Door | DoorHan', 'Keep your garage warm and secure with the Yett 02, featuring superior insulation properties.'),
(8, 'Folding Gate', 'folding-gate', '<p>Industrial folding gate for hangars and depots. Allows for maximum opening width.</p>', 'active', 'Industrial Folding Gate | DoorHan', 'Our industrial folding gates are the perfect solution for extra-large openings like aircraft hangars.'),
(9, 'Sliding Gate DIY', 'sliding-gate-diy', '<p>A complete DIY kit for a self-supporting sliding gate. Easy to assemble and install.</p>', 'active', 'DIY Sliding Gate Kit | DoorHan', 'Get our complete DIY kit to easily install a modern and reliable sliding gate on your property.');

-- Product-category mapping
INSERT INTO `product_categories` (`product_id`, `category_id`, `is_primary`) VALUES
(1, 1, 1),
(2, 1, 1),
(3, 2, 1),
(4, 3, 1),
(5, 1, 1),
(6, 1, 1),
(7, 1, 1),
(8, 4, 1),
(9, 5, 1);

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
('News', '/news', NULL, 3),
('About', '/about', NULL, 4),
('Contact', '/contact', NULL, 5);
