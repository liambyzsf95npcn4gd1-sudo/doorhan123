<!DOCTYPE html>
<html lang="<?php echo Language::get(); ?>" dir="<?php echo Language::getDirection(); ?>" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo isset($seo_title) ? htmlspecialchars($seo_title) : 'DoorHan International'; ?></title>
    <meta name="description" content="<?php echo isset($meta_description) ? htmlspecialchars($meta_description) : ''; ?>">
    
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800;900&family=Noto+Sans+SC:wght@300;400;500;700;900&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="<?php echo SITE_URL; ?>/assets/css/style.css">
    <link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css" />

    <style>
        body {
            font-family: 'Inter', 'Noto Sans SC', sans-serif;
        }
        .doorhan-blue { background-color: #0055A5; }
        .text-doorhan-blue { color: #0055A5; }

        /* Custom scrollbar */
        ::-webkit-scrollbar { width: 8px; }
        ::-webkit-scrollbar-track { background: #0B1120; }
        ::-webkit-scrollbar-thumb { background: #1E293B; border-radius: 4px; }
        ::-webkit-scrollbar-thumb:hover { background: #0055A5; }

        /* Location Panel Expansion */
        .location-panel {
            transition: all 0.7s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .location-panel:hover {
            flex-grow: 2;
        }

        /* Animations */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(40px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        .fade-in-up {
            animation: fadeInUp 1s cubic-bezier(0.22, 1, 0.36, 1) forwards;
        }

        .reveal {
            opacity: 0;
            transform: translateY(30px);
            transition: all 0.8s cubic-bezier(0.22, 1, 0.36, 1);
        }
        .reveal.active {
            opacity: 1;
            transform: translateY(0);
        }

        /* Accordion Marker Removal */
        summary::-webkit-details-marker {
            display: none;
        }
    </style>
</head>
<body class="antialiased bg-[#0B1120] text-white">

    <!-- Header -->
    <header class="fixed top-0 w-full z-50 backdrop-blur-md bg-black/80 border-b border-white/10" x-data="{ mobileMenuOpen: false }">
        <div class="max-w-[1440px] mx-auto px-6 lg:px-12 py-5 flex items-center justify-between">
            <!-- Logo -->
            <a href="<?php echo url('/'); ?>" class="text-2xl font-black tracking-tighter text-white uppercase">DOORHAN</a>

            <!-- Navigation (Desktop) -->
            <nav class="hidden xl:flex items-center space-x-10 text-[11px] font-bold uppercase tracking-[0.15em]">
                <?php if (isset($menuItems) && is_array($menuItems)): ?>
                    <?php foreach ($menuItems as $item): ?>
                        <div class="relative group">
                            <a href="<?php echo url($item['url']); ?>" class="hover:text-doorhan-blue transition-colors text-white block py-2"><?php echo htmlspecialchars(__($item['title'])); ?></a>
                            <?php if (!empty($item['children'])): ?>
                                <div class="absolute top-full left-0 bg-[#0B1120] border border-white/10 py-2 min-w-[200px] hidden group-hover:block shadow-xl">
                                    <?php foreach ($item['children'] as $child): ?>
                                        <a href="<?php echo url($child['url']); ?>" class="block px-4 py-2 hover:bg-white/5 hover:text-doorhan-blue text-white/80 transition-colors"><?php echo htmlspecialchars(__($child['title'])); ?></a>
                                    <?php endforeach; ?>
                                </div>
                            <?php endif; ?>
                        </div>
                    <?php endforeach; ?>
                <?php endif; ?>
            </nav>

            <!-- Right side -->
            <div class="flex items-center space-x-8">
                <!-- Mobile Menu Button -->
                <button @click="mobileMenuOpen = !mobileMenuOpen" class="xl:hidden text-white hover:text-doorhan-blue transition-colors">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
                    </svg>
                </button>

                <!-- Language Switcher Dropdown (Desktop) -->
                <div class="relative group hidden md:block border-l border-white/20 pl-8" x-data="{ open: false }">
                    <?php
                    $currentLang = Language::get();
                    $langs = Language::getList();
                    $currentLangDetails = $langs[$currentLang] ?? ['code' => 'en', 'flag_icon' => 'flag-en.svg'];
                    ?>
                    <button @click="open = !open" @click.outside="open = false" class="flex items-center space-x-2 text-[10px] font-black tracking-[0.2em] text-white hover:text-doorhan-blue transition-colors uppercase cursor-pointer">
                        <img src="<?php echo SITE_URL; ?>/assets/img/flags/<?php echo htmlspecialchars($currentLangDetails['flag_icon'] ?? 'flag-default.svg'); ?>" class="w-4 h-4 rounded-full object-cover" alt="<?php echo $currentLang; ?>" onerror="this.style.display='none'">
                        <span><?php echo strtoupper($currentLang); ?></span>
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-3 w-3 transition-transform duration-200" :class="{'rotate-180': open}" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                        </svg>
                    </button>

                    <div x-show="open"
                         x-transition:enter="transition ease-out duration-100"
                         x-transition:enter-start="transform opacity-0 scale-95"
                         x-transition:enter-end="transform opacity-100 scale-100"
                         x-transition:leave="transition ease-in duration-75"
                         x-transition:leave-start="transform opacity-100 scale-100"
                         x-transition:leave-end="transform opacity-0 scale-95"
                         style="display: none;"
                         class="absolute right-0 mt-2 w-32 bg-[#0B1120] border border-white/10 shadow-xl rounded-sm py-2 z-50">
                        <?php foreach ($langs as $code => $details): ?>
                            <?php if ($code !== $currentLang): ?>
                                <a href="<?php echo url($current_uri ?? '', $code); ?>"
                                   class="block px-4 py-2 text-[10px] font-bold uppercase tracking-widest text-white/60 hover:text-white hover:bg-white/5 flex items-center space-x-3 transition-colors">
                                   <img src="<?php echo SITE_URL; ?>/assets/img/flags/<?php echo htmlspecialchars($details['flag_icon'] ?? 'flag-default.svg'); ?>" class="w-4 h-4 rounded-full object-cover" alt="<?php echo $code; ?>" onerror="this.style.display='none'">
                                   <span><?php echo strtoupper($code); ?></span>
                                </a>
                            <?php endif; ?>
                        <?php endforeach; ?>
                    </div>
                </div>
            </div>
        </div>

        <!-- Mobile Menu (Alpine) -->
        <div x-show="mobileMenuOpen"
             x-transition:enter="transition ease-out duration-200"
             x-transition:enter-start="opacity-0 -translate-y-2"
             x-transition:enter-end="opacity-100 translate-y-0"
             x-transition:leave="transition ease-in duration-150"
             x-transition:leave-start="opacity-100 translate-y-0"
             x-transition:leave-end="opacity-0 -translate-y-2"
             class="xl:hidden absolute top-full left-0 w-full bg-[#0B1120] border-b border-white/10 p-6 shadow-2xl overflow-y-auto max-h-[80vh]">
            <nav class="flex flex-col space-y-4 text-sm font-bold uppercase tracking-widest text-center">
                <?php if (isset($menuItems) && is_array($menuItems)): ?>
                    <?php foreach ($menuItems as $item): ?>
                        <a href="<?php echo url($item['url']); ?>" class="text-white hover:text-doorhan-blue py-2"><?php echo htmlspecialchars(__($item['title'])); ?></a>
                        <?php if (!empty($item['children'])): ?>
                            <div class="pl-4 border-l border-white/10 ml-4 flex flex-col space-y-2 text-left">
                                <?php foreach ($item['children'] as $child): ?>
                                    <a href="<?php echo url($child['url']); ?>" class="text-white/60 hover:text-doorhan-blue text-xs"><?php echo htmlspecialchars(__($child['title'])); ?></a>
                                <?php endforeach; ?>
                            </div>
                        <?php endif; ?>
                    <?php endforeach; ?>
                <?php endif; ?>
                <!-- Mobile Lang Switcher -->
                <div class="grid grid-cols-4 gap-2 pt-4 border-t border-white/10 mt-4">
                     <?php
                     foreach ($langs as $code => $details) {
                         $isActive = ($code === $currentLang);
                         $class = $isActive ? 'text-white bg-white/10 border border-white/20' : 'text-white/40 border border-transparent hover:border-white/10';
                         $url = url($current_uri ?? '', $code);
                         echo '<a href="' . $url . '" class="' . $class . ' py-2 rounded text-center text-xs block">' . strtoupper($code) . '</a>';
                     }
                     ?>
                </div>
            </nav>
        </div>
    </header>
    <main>
