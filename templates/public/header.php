<!DOCTYPE html>
<html lang="<?php echo Language::get(); ?>" dir="<?php echo Language::getDirection(); ?>">
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
    <div class="top-bar">
        <div class="container">
            <div class="top-bar-flex">
                <div class="header-email">
                    <a href="mailto:info@doorhan.com">info@doorhan.com</a>
                </div>
                <div class="lang-switcher">
                    <div class="lang-switcher-trigger">
                        <img src="<?php echo SITE_URL; ?>/assets/img/icons/globe.svg" alt="Language" class="globe-icon">
                        <img src="<?php echo SITE_URL; ?>/assets/img/flags/<?php echo Language::get(); ?>.svg" alt="<?php echo strtoupper(Language::get()); ?>" class="current-flag">
                        <span class="current-lang-code"><?php echo strtoupper(Language::get()); ?></span>
                    </div>
                    <div class="lang-switcher-dropdown">
                        <ul>
                            <?php foreach (SUPPORTED_LANGUAGES as $lang): ?>
                                <li>
                                    <a href="<?php echo SITE_URL . '/' . $lang . $current_uri; ?>" class="<?php echo Language::get() === $lang ? 'active' : ''; ?>">
                                        <img src="<?php echo SITE_URL; ?>/assets/img/flags/<?php echo $lang; ?>.svg" alt="<?php echo strtoupper($lang); ?>">
                                        <?php echo strtoupper($lang); ?>
                                    </a>
                                </li>
                            <?php endforeach; ?>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
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
<<<<<<< Updated upstream
                    <div class="lang-switcher">
                        <div class="lang-switcher-trigger">
                            <img src="<?php echo SITE_URL; ?>/assets/img/icons/globe.svg" alt="Language">
                        </div>
                        <div class="lang-switcher-dropdown">
                            <ul>
                                <?php foreach (SUPPORTED_LANGUAGES as $lang): ?>
                                    <li>
                                        <a href="<?php echo SITE_URL . '/' . $lang . $current_uri; ?>" class="<?php echo Language::get() === $lang ? 'active' : ''; ?>">
                                            <img src="<?php echo SITE_URL; ?>/assets/img/flags/<?php echo $lang; ?>.svg" alt="<?php echo strtoupper($lang); ?>">
                                            <?php echo strtoupper($lang); ?>
                                        </a>
                                    </li>
                                <?php endforeach; ?>
                            </ul>
                        </div>
                    </div>
                    <div class="header-email">
                        <a href="mailto:info@doorhan.com">info@doorhan.com</a>
                    </div>
=======
>>>>>>> Stashed changes
                    <a href="<?php echo url('/contact'); ?>" class="btn btn-primary"><?php echo __('Find Dealer'); ?></a>
                </div>
                <button class="mobile-nav-toggle">
                    <span class="hamburger"></span>
                </button>
            </div>
        </div>
    </header>
    <main>