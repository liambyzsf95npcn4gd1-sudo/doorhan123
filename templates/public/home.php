<?php
if (empty($_SESSION['csrf_token'])) {
    $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
}
$csrf_token = $_SESSION['csrf_token'];
require_once ROOT_PATH . '/templates/public/header.php';
?>

    <!-- Hero Section -->
    <section class="relative h-screen flex items-center overflow-hidden">
        <!-- Background Asset -->
        <div class="absolute inset-0 z-0">
            <img src="https://images.unsplash.com/photo-1504307651254-35680f356dfd?q=80&w=2070"
                 class="w-full h-full object-cover grayscale opacity-50" alt="Industrial Hub">
            <div class="absolute inset-0 bg-gradient-to-r from-black/90 via-black/40 to-transparent"></div>
        </div>

        <div class="relative z-10 max-w-[1440px] mx-auto px-6 lg:px-12 w-full">
            <div class="max-w-4xl fade-in-up">
                <h1 class="text-6xl lg:text-8xl font-black tracking-tighter uppercase leading-[0.9] mb-10 text-white">
                    <?php echo __('hero_title_1') ?: 'ENGINEERING<br>SOLUTIONS<br>OF THE FUTURE'; ?>
                </h1>
                <p class="text-xl text-white/60 max-w-xl mb-12 font-medium leading-relaxed">
                    <?php echo __('hero_desc_1') ?: 'Comprehensive systems for industry and private housing construction. Technological superiority in every detail.'; ?>
                </p>
                <div class="flex flex-col sm:flex-row gap-5">
                    <a href="<?php echo url('/products'); ?>" class="doorhan-blue hover:bg-blue-700 text-white px-12 py-5 font-black text-xs uppercase tracking-widest transition-all text-center">
                        <?php echo __('Catalog'); ?>
                    </a>
                    <a href="#projects" class="border border-white/20 hover:bg-white hover:text-black text-white px-12 py-5 font-black text-xs uppercase tracking-widest transition-all text-center">
                        <?php echo __('Our Projects'); ?>
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- Global Geography Headline -->
    <div class="bg-white py-20 px-6 lg:px-12">
        <div class="max-w-[1440px] mx-auto text-center reveal">
            <h2 class="text-[#111827] text-sm md:text-base font-black uppercase tracking-[0.5em] mb-6">
                <?php echo __('GLOBAL GEOGRAPHY'); ?>
            </h2>
            <div class="h-1 w-24 bg-doorhan-blue mx-auto"></div>
        </div>
    </div>

    <!-- Global Presence (Interactive Panels) -->
    <section class="h-[70vh] flex flex-col lg:flex-row overflow-hidden border-y border-white/5">
        <!-- China -->
        <a href="<?php echo $websites['cn'] ?? '#'; ?>" target="_blank" class="location-panel relative flex-1 h-full min-h-[300px] overflow-hidden group cursor-pointer block">
            <img src="https://images.unsplash.com/photo-1541888946425-d81bb19480c5?q=80&w=1500" class="absolute inset-0 w-full h-full object-cover grayscale transition-all duration-700 group-hover:grayscale-0 group-hover:scale-110" alt="China Factory">
            <div class="absolute inset-0 bg-red-900/20 group-hover:bg-transparent transition-colors"></div>
            <div class="absolute inset-0 bg-black/40 p-12 flex flex-col justify-end">
                <span class="text-doorhan-blue font-black text-[10px] uppercase tracking-widest mb-2">Manufacturing</span>
                <h3 class="text-4xl font-black uppercase tracking-tight text-white">Suzhou, China</h3>
            </div>
        </a>
        <!-- Czechia -->
        <a href="<?php echo $websites['cz'] ?? '#'; ?>" target="_blank" class="location-panel relative flex-1 h-full min-h-[300px] overflow-hidden group cursor-pointer border-x border-white/10 block">
            <img src="https://images.unsplash.com/photo-1517420812314-8b17177f59c7?q=80&w=1500" class="absolute inset-0 w-full h-full object-cover grayscale transition-all duration-700 group-hover:grayscale-0 group-hover:scale-110" alt="Czech Plant">
            <div class="absolute inset-0 bg-blue-900/20 group-hover:bg-transparent transition-colors"></div>
            <div class="absolute inset-0 bg-black/40 p-12 flex flex-col justify-end">
                <span class="text-doorhan-blue font-black text-[10px] uppercase tracking-widest mb-2">European Hub</span>
                <h3 class="text-4xl font-black uppercase tracking-tight text-white">Kadan, Czechia</h3>
            </div>
        </a>
        <!-- Dubai -->
        <a href="<?php echo $websites['ae'] ?? '#'; ?>" target="_blank" class="location-panel relative flex-1 h-full min-h-[300px] overflow-hidden group cursor-pointer block">
            <img src="https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?q=80&w=1500" class="absolute inset-0 w-full h-full object-cover grayscale transition-all duration-700 group-hover:grayscale-0 group-hover:scale-110" alt="Dubai Hub">
            <div class="absolute inset-0 bg-yellow-900/20 group-hover:bg-transparent transition-colors"></div>
            <div class="absolute inset-0 bg-black/40 p-12 flex flex-col justify-end">
                <span class="text-doorhan-blue font-black text-[10px] uppercase tracking-widest mb-2">Logistics Center</span>
                <h3 class="text-4xl font-black uppercase tracking-tight text-white">Dubai, UAE</h3>
            </div>
        </a>
    </section>

    <!-- Product Catalog -->
    <section id="products" class="py-32 px-6 lg:px-12 bg-white text-black">
        <div class="max-w-[1440px] mx-auto">
            <div class="mb-20 flex flex-col md:flex-row md:items-end justify-between">
                <div>
                    <span class="text-doorhan-blue font-black text-[11px] uppercase tracking-[0.4em] mb-4 block">Product Ecosystem</span>
                    <h2 class="text-5xl lg:text-7xl font-black tracking-tighter uppercase leading-none text-[#111827]"><?php echo __('System Solutions'); ?></h2>
                </div>
                <p class="text-gray-500 max-w-sm mt-8 md:mt-0 font-medium"><?php echo __('Comprehensive approach to automation and protection of objects of any scale.'); ?></p>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <?php if (!empty($featured_products)): ?>
                    <?php foreach ($featured_products as $product): ?>
                        <div class="group relative aspect-square overflow-hidden bg-gray-100 cursor-pointer block">
                            <a href="<?php echo url('/products/' . htmlspecialchars($product['slug'])); ?>" class="absolute inset-0 z-20"></a>
                            <!-- Using Product Image -->
                            <img src="<?php echo SITE_URL; ?>/assets/img/products/<?php echo htmlspecialchars($product['image'] ?? 'product-placeholder.jpg'); ?>"
                                 class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-105"
                                 alt="<?php echo htmlspecialchars($product['name']); ?>">

                            <div class="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-transparent pointer-events-none"></div>
                            <div class="absolute bottom-0 left-0 p-8 w-full pointer-events-none">
                                <h3 class="text-3xl font-black text-white uppercase tracking-tight"><?php echo htmlspecialchars($product['name']); ?></h3>
                                <div class="h-[2px] w-0 bg-doorhan-blue mt-4 group-hover:w-full transition-all duration-500"></div>
                            </div>
                        </div>
                    <?php endforeach; ?>
                <?php else: ?>
                    <p class="col-span-3 text-center text-gray-500"><?php echo __('no_featured_products'); ?></p>
                <?php endif; ?>
            </div>
        </div>
    </section>

    <!-- Realized Projects (Mapped from News) -->
    <section id="projects" class="relative py-40 overflow-hidden">
        <div class="absolute inset-0 z-0">
            <img src="https://images.unsplash.com/photo-1581094794329-c8112a89af12?q=80&w=2000" class="w-full h-full object-cover" alt="Large Projects">
            <div class="absolute inset-0 bg-black/70"></div>
        </div>
        <div class="relative z-10 max-w-[1440px] mx-auto px-6 lg:px-12 text-center">
            <h2 class="text-5xl lg:text-9xl font-black tracking-tighter uppercase mb-12 opacity-100 text-white"><?php echo __('Realized Objects'); ?></h2>
            
            <div class="grid grid-cols-1 md:grid-cols-3 gap-8 mt-24">
                <?php if (!empty($latest_posts)): ?>
                    <?php foreach ($latest_posts as $post): ?>
                        <a href="<?php echo url('/news/' . htmlspecialchars($post['slug'])); ?>" class="bg-white/5 backdrop-blur-md p-10 border border-white/10 text-left hover:bg-white/10 transition-all cursor-pointer block group">
                            <h4 class="text-doorhan-blue font-black text-sm uppercase mb-4 tracking-widest"><?php echo __('News'); ?></h4>
                            <p class="text-2xl font-bold uppercase tracking-tight text-white group-hover:text-doorhan-blue transition-colors"><?php echo htmlspecialchars($post['title']); ?></p>
                        </a>
                    <?php endforeach; ?>
                <?php else: ?>
                    <p class="col-span-3 text-center text-white/50"><?php echo __('no_news'); ?></p>
                <?php endif; ?>
            </div>
        </div>
    </section>

    <!-- Section: About Company (Asymmetric Layout) -->
    <section id="about" class="py-32 px-6 lg:px-12 bg-[#F9FAFB] text-black overflow-hidden">
        <div class="max-w-[1440px] mx-auto grid grid-cols-1 lg:grid-cols-2 gap-16 items-center">
            <!-- Text Content -->
            <div class="reveal">
                <span class="text-doorhan-blue font-black text-[11px] uppercase tracking-[0.4em] mb-6 block">Legacy & Future</span>
                <h2 class="text-4xl lg:text-6xl font-black tracking-tighter uppercase leading-none mb-10 text-gray-900">
                    <?php echo __('SCALE. EXPERIENCE. INNOVATION.'); ?>
                </h2>
                <div class="space-y-6 text-gray-600 font-medium leading-relaxed max-w-lg">
                    <p class="text-lg">
                        <?php echo __('DoorHan is 30 factories worldwide and a full production cycle, covering all stages: from aluminum casting to final assembly of control systems.'); ?>
                    </p>
                    <p>
                        <?php echo __('We create solutions that define industry standards for decades to come, ensuring safety and comfort for millions of people.'); ?>
                    </p>
                </div>
                <div class="mt-12">
                    <a href="<?php echo url('/about'); ?>" class="inline-flex items-center text-[11px] font-black uppercase tracking-widest text-doorhan-blue border-b-2 border-doorhan-blue pb-2 group">
                        <?php echo __('More about company'); ?>
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 ml-2 group-hover:translate-x-1 transition-transform" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M17 8l4 4m0 0l-4 4m4-4H3" />
                        </svg>
                    </a>
                </div>
            </div>

            <!-- Overlapping composition -->
            <div class="relative reveal lg:pl-12" style="transition-delay: 200ms;">
                <!-- Main Large Photo -->
                <div class="aspect-[3/4] overflow-hidden shadow-2xl rounded-sm">
                    <img src="https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?q=80&w=2070"
                         class="w-full h-full object-cover" alt="Factory Floor">
                </div>
                <!-- Accent Overlapping Photo -->
                <div class="absolute -bottom-12 -left-6 lg:-left-12 w-1/2 aspect-square overflow-hidden border-[10px] border-white shadow-xl rounded-sm z-10 hidden sm:block">
                    <img src="https://images.unsplash.com/photo-1504328345606-18bbc8c9d7d1?q=80&w=800"
                         class="w-full h-full object-cover" alt="Engineer Detail">
                </div>
            </div>
        </div>
    </section>

    <!-- Section: Contact Form (Minimalist Architectural) -->
    <section id="contact" class="py-32 px-6 lg:px-12 bg-[#0B1120] text-white">
        <div class="max-w-[1440px] mx-auto text-center">
            <div class="reveal inline-block mb-16">
                <span class="text-doorhan-blue font-black text-[11px] uppercase tracking-[0.4em] mb-4 block">Let's connect</span>
                <h2 class="text-4xl lg:text-7xl font-black tracking-tighter uppercase text-white"><?php echo __('DISCUSS A PROJECT'); ?></h2>
            </div>

            <form action="<?php echo url('/contact'); ?>" method="post" class="max-w-2xl mx-auto space-y-12 reveal" style="transition-delay: 200ms;">
                <input type="hidden" name="csrf_token" value="<?php echo htmlspecialchars($csrf_token); ?>">

                <div class="grid grid-cols-1 md:grid-cols-2 gap-12 text-left">
                    <div class="relative">
                        <input type="text" name="name" id="name" required class="w-full bg-transparent border-b border-white/20 py-4 outline-none focus:border-doorhan-blue transition-colors text-lg peer text-white" placeholder=" ">
                        <label for="name" class="absolute top-4 left-0 text-white/40 uppercase text-[10px] font-black tracking-widest transition-all peer-focus:-top-4 peer-focus:text-doorhan-blue peer-[:not(:placeholder-shown)]:-top-4"><?php echo __('Your Name'); ?></label>
                    </div>
                    <div class="relative">
                        <input type="tel" name="phone" id="phone" required class="w-full bg-transparent border-b border-white/20 py-4 outline-none focus:border-doorhan-blue transition-colors text-lg peer text-white" placeholder=" ">
                        <label for="phone" class="absolute top-4 left-0 text-white/40 uppercase text-[10px] font-black tracking-widest transition-all peer-focus:-top-4 peer-focus:text-doorhan-blue peer-[:not(:placeholder-shown)]:-top-4"><?php echo __('Phone'); ?></label>
                    </div>
                </div>
                <div class="relative text-left">
                    <input type="email" name="email" id="email" required class="w-full bg-transparent border-b border-white/20 py-4 outline-none focus:border-doorhan-blue transition-colors text-lg peer text-white" placeholder=" ">
                    <label for="email" class="absolute top-4 left-0 text-white/40 uppercase text-[10px] font-black tracking-widest transition-all peer-focus:-top-4 peer-focus:text-doorhan-blue peer-[:not(:placeholder-shown)]:-top-4"><?php echo __('Email'); ?></label>
                </div>

                <!-- Hidden message field for simplicity if contact logic requires it, but template doesn't show it.
                     The ContactController requires 'message'. I should add it or hardcode a default?
                     "Message is required." in controller.
                     I will add a Message field. The template didn't show it, but form logic requires it.
                     I'll add it to be safe and functional. -->
                <div class="relative text-left">
                    <textarea name="message" id="message" required class="w-full bg-transparent border-b border-white/20 py-4 outline-none focus:border-doorhan-blue transition-colors text-lg peer text-white h-24 resize-none" placeholder=" "></textarea>
                    <label for="message" class="absolute top-4 left-0 text-white/40 uppercase text-[10px] font-black tracking-widest transition-all peer-focus:-top-4 peer-focus:text-doorhan-blue peer-[:not(:placeholder-shown)]:-top-4"><?php echo __('Message'); ?></label>
                </div>

                <div class="pt-8">
                    <button type="submit" class="w-full bg-white text-[#0B1120] hover:bg-doorhan-blue hover:text-white px-12 py-6 font-black text-xs uppercase tracking-[0.3em] transition-all transform hover:scale-[1.02]">
                        <?php echo __('SEND REQUEST'); ?>
                    </button>
                    <p class="mt-8 text-[10px] text-white/30 uppercase tracking-widest font-bold">
                        <?php echo __('By clicking the button, you agree to the personal data processing policy'); ?>
                    </p>
                </div>
            </form>
        </div>
    </section>

    <!-- FAQ Section (Swiss Style Accordion) -->
    <section id="faq" class="py-40 px-6 lg:px-12 bg-white text-black">
        <div class="max-w-[1440px] mx-auto grid grid-cols-1 lg:grid-cols-12 gap-16">
            <!-- Title -->
            <div class="lg:col-span-4 reveal">
                <span class="text-doorhan-blue font-black text-[11px] uppercase tracking-[0.4em] mb-6 block">Support Center</span>
                <h2 class="text-4xl lg:text-5xl font-black tracking-tighter uppercase leading-none text-gray-900">
                    <?php echo __('FAQ'); ?>
                </h2>
            </div>

            <!-- Accordion Items -->
            <div class="lg:col-span-8 space-y-0 reveal" style="transition-delay: 200ms;">
                <details class="group border-b border-gray-200 py-10">
                    <summary class="flex justify-between items-center cursor-pointer list-none">
                        <h3 class="text-xl md:text-2xl font-bold uppercase tracking-tight text-gray-900 pr-8 transition-colors group-hover:text-doorhan-blue"><?php echo __('How to become an official dealer?'); ?></h3>
                        <span class="text-doorhan-blue transition-transform duration-500 group-open:rotate-45 shrink-0">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                            </svg>
                        </span>
                    </summary>
                    <div class="mt-8 text-gray-600 text-lg leading-relaxed font-medium max-w-3xl">
                        <?php echo __('Fill out the application form on our website or contact a regional representative. We provide a full package of dealer support: regular training at the DoorHan Academy, exhibition samples, marketing materials, and a personal manager.'); ?>
                    </div>
                </details>

                <details class="group border-b border-gray-200 py-10">
                    <summary class="flex justify-between items-center cursor-pointer list-none">
                        <h3 class="text-xl md:text-2xl font-bold uppercase tracking-tight text-gray-900 pr-8 transition-colors group-hover:text-doorhan-blue"><?php echo __('Where is the production located?'); ?></h3>
                        <span class="text-doorhan-blue transition-transform duration-500 group-open:rotate-45 shrink-0">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                            </svg>
                        </span>
                    </summary>
                    <div class="mt-8 text-gray-600 text-lg leading-relaxed font-medium max-w-3xl">
                         <?php echo __('DoorHan main production clusters are located in Russia, China, and the Czech Republic. 30 factories worldwide allow us to ensure uninterrupted supplies and localized service in 40+ countries.'); ?>
                    </div>
                </details>

                <details class="group border-b border-gray-200 py-10">
                    <summary class="flex justify-between items-center cursor-pointer list-none">
                        <h3 class="text-xl md:text-2xl font-bold uppercase tracking-tight text-gray-900 pr-8 transition-colors group-hover:text-doorhan-blue"><?php echo __('Production time for custom orders?'); ?></h3>
                        <span class="text-doorhan-blue transition-transform duration-500 group-open:rotate-45 shrink-0">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                            </svg>
                        </span>
                    </summary>
                    <div class="mt-8 text-gray-600 text-lg leading-relaxed font-medium max-w-3xl">
                        <?php echo __('Production terms for custom items start from 14 working days. The exact time depends on the chosen configuration, complexity of the engineering solution, and current production line load.'); ?>
                    </div>
                </details>

                <details class="group border-b border-gray-200 py-10">
                    <summary class="flex justify-between items-center cursor-pointer list-none">
                        <h3 class="text-xl md:text-2xl font-bold uppercase tracking-tight text-gray-900 pr-8 transition-colors group-hover:text-doorhan-blue"><?php echo __('Do you provide installation supervision?'); ?></h3>
                        <span class="text-doorhan-blue transition-transform duration-500 group-open:rotate-45 shrink-0">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                            </svg>
                        </span>
                    </summary>
                    <div class="mt-8 text-gray-600 text-lg leading-relaxed font-medium max-w-3xl">
                        <?php echo __('Yes, our technical specialists carry out installation supervision at facilities of any complexity worldwide. The service includes monitoring compliance with installation technology, checking commissioning works, and training customer personnel.'); ?>
                    </div>
                </details>
            </div>
        </div>
    </section>

<?php require_once ROOT_PATH . '/templates/public/footer.php'; ?>
