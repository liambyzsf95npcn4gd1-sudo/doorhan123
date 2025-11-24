<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo isset($seo_title) ? htmlspecialchars($seo_title) : 'DoorHan International'; ?></title>
    <meta name="description" content="<?php echo isset($meta_description) ? htmlspecialchars($meta_description) : ''; ?>">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@700&family=Open+Sans:wght@400;600&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="<?php echo SITE_URL; ?>/assets/css/style.css">
    
    <link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css" />
    
    <script src="<?php echo SITE_URL; ?>/assets/js/mobile-nav.js" defer></script>
</head>
<body>
    <header class="sticky-header">
        <div class="container">
            <div class="header-flex">
                <div class="logo">
                    <a href="<?php echo url('/'); ?>"><img src="<?php echo SITE_URL; ?>/assets/img/logo.png" alt="DoorHan International"></a>
                </div>
                <nav class="main-nav">
                    <ul>
                        <?php if (isset($menuItems) && is_array($menuItems)): ?>
                            <?php foreach ($menuItems as $item): ?>
                                <li class="nav-item <?php echo !empty($item['children']) ? 'has-dropdown' : ''; ?>">
                                    <a href="<?php echo url($item['url']); ?>"><?php echo htmlspecialchars(__($item['title'])); ?></a>
                                    <?php if (!empty($item['children'])): ?>
                                        <div class="dropdown-menu">
                                            <ul>
                                                <?php foreach ($item['children'] as $child): ?>
                                                    <li><a href="<?php echo url($child['url']); ?>"><?php echo htmlspecialchars(__($child['title'])); ?></a></li>
                                                <?php endforeach; ?>
                                            </ul>
                                        </div>
                                    <?php endif; ?>
                                </li>
                            <?php endforeach; ?>
                        <?php endif; ?>
                    </ul>
                </nav>
                <div class="header-right">
                    <div class="lang-switcher">
                        <?php foreach (SUPPORTED_LANGUAGES as $lang): ?>
                            <a href="<?php echo SITE_URL . '/' . $lang; ?>" class="<?php echo Language::get() === $lang ? 'active' : ''; ?>"><?php echo strtoupper($lang); ?></a>
                        <?php endforeach; ?>
                    </div>
                    <div class="header-phone">
                        <a href="tel:+1-800-DOORHAN">+1-800-DOORHAN</a>
                    </div>
                    <a href="<?php echo url('/contact'); ?>" class="btn btn-primary"><?php echo __('Find Dealer'); ?></a>
                </div>
                <button class="mobile-nav-toggle">
                    <span class="hamburger"></span>
                </button>
            </div>
        </div>
    </header>
    <main>