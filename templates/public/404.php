<?php
$seo_title = __('Page Not Found') . ' | DoorHan';
$meta_description = '';
?>
<!DOCTYPE html>
<html lang="<?php echo Language::get(); ?>" dir="<?php echo Language::getDirection(); ?>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo isset($seo_title) ? htmlspecialchars($seo_title) : 'DoorHan International'; ?></title>
    <meta name="description" content="<?php echo isset($meta_description) ? htmlspecialchars($meta_description) : ''; ?>">
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<?php echo SITE_URL; ?>/assets/css/style.css">
    <style>
        body { font-family: 'Inter', sans-serif; }
    </style>
</head>
<body class="antialiased bg-white text-gray-800 min-h-screen flex flex-col">

    <main class="flex-grow flex items-center justify-center px-6">
        <div class="text-center max-w-lg">
            <div class="mb-8">
                <svg class="mx-auto h-24 w-24 text-[#0055A5]" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9.172 16.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
            </div>

            <h1 class="text-6xl font-black text-[#0055A5] mb-4 tracking-tight">404</h1>
            <h2 class="text-2xl font-bold text-gray-800 mb-4 uppercase tracking-wide"><?php echo __('Page Not Found'); ?></h2>
            <p class="text-gray-500 mb-10 leading-relaxed">
                <?php echo __('The page you are looking for might have been removed, had its name changed, or is temporarily unavailable.'); ?>
            </p>

            <a href="<?php echo url('/'); ?>" class="inline-block bg-[#0055A5] hover:bg-[#004488] text-white font-bold uppercase text-xs tracking-widest px-8 py-4 transition-colors">
                <?php echo __('Go to Homepage'); ?>
            </a>
        </div>
    </main>

    <footer class="py-6 text-center">
        <p class="text-xs text-gray-400">&copy; <?php echo date('Y'); ?> DoorHan International.</p>
    </footer>

</body>
</html>