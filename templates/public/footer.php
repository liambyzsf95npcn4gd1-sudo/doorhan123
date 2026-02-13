    </main>

    <!-- Footer -->
    <footer class="bg-gray-900 pt-32 pb-16 px-6 lg:px-12 border-t border-white/5 relative z-10">
        <div class="max-w-[1440px] mx-auto">
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-16 mb-24">
                <div>
                    <span class="text-3xl font-black tracking-tighter text-white block mb-8 uppercase">DOORHAN</span>
                    <p class="text-white/40 text-sm leading-relaxed max-w-xs"><?php echo __('about_doorhan_desc'); ?></p>
                </div>
                <div>
                    <h5 class="text-doorhan-blue font-black text-[10px] uppercase tracking-widest mb-10"><?php echo __('Products'); ?></h5>
                    <ul class="space-y-4 text-sm font-medium text-white/50">
                        <li><a href="<?php echo url('/products'); ?>" class="hover:text-white transition-colors"><?php echo __('All Products'); ?></a></li>
                        <li><a href="<?php echo url('/products/gates'); ?>" class="hover:text-white transition-colors"><?php echo __('Gates'); ?></a></li>
                        <li><a href="<?php echo url('/products/automation'); ?>" class="hover:text-white transition-colors"><?php echo __('Automation'); ?></a></li>
                        <li><a href="<?php echo url('/solutions'); ?>" class="hover:text-white transition-colors"><?php echo __('Solutions'); ?></a></li>
                    </ul>
                </div>
                <div>
                    <h5 class="text-doorhan-blue font-black text-[10px] uppercase tracking-widest mb-10"><?php echo __('Partners'); ?></h5>
                    <ul class="space-y-4 text-sm font-medium text-white/50">
                        <li><a href="<?php echo url('/contact'); ?>" class="hover:text-white transition-colors"><?php echo __('Find Dealer'); ?></a></li>
                        <li><a href="<?php echo url('/contact'); ?>" class="hover:text-white transition-colors"><?php echo __('Technical Support'); ?></a></li>
                        <li><a href="<?php echo url('/factories'); ?>" class="hover:text-white transition-colors"><?php echo __('Our Factories'); ?></a></li>
                        <li><a href="<?php echo url('/about'); ?>" class="hover:text-white transition-colors"><?php echo __('About Company'); ?></a></li>
                    </ul>
                </div>
                <div>
                    <h5 class="text-doorhan-blue font-black text-[10px] uppercase tracking-widest mb-10"><?php echo __('Contact'); ?></h5>
                    <p class="text-sm font-bold mb-4 text-white">info@doorhan.com</p>
                    <p class="text-xs text-white/30 mt-6 leading-relaxed uppercase tracking-wider"><?php echo __('address_placeholder'); // Using a placeholder or hardcoded generic address if not available ?></p>

                    <!-- Regional Sites (moved here to preserve access) -->
                    <div class="mt-8">
                         <h6 class="text-doorhan-blue font-black text-[8px] uppercase tracking-widest mb-4"><?php echo __('Regional Websites'); ?></h6>
                         <div class="flex flex-wrap gap-4 text-xs text-white/40">
                             <a href="https://doorhan.cz" target="_blank" class="hover:text-white">CZ</a>
                             <a href="https://doorhan.cn" target="_blank" class="hover:text-white">CN</a>
                             <a href="https://doorhan.ae" target="_blank" class="hover:text-white">AE</a>
                         </div>
                    </div>
                </div>
            </div>

            <div class="pt-12 border-t border-white/5 flex flex-col md:flex-row justify-between items-center text-[10px] font-bold text-white/20 uppercase tracking-[0.2em]">
                <p>&copy; <?php echo date('Y'); ?> DoorHan International. <?php echo __('All rights reserved'); ?></p>
                <div class="flex space-x-10 mt-6 md:mt-0">
                    <a href="<?php echo url('/privacy-policy'); ?>" class="hover:text-white"><?php echo __('Privacy Policy'); ?></a>
                    <a href="<?php echo url('/sitemap.xml'); ?>" class="hover:text-white">Sitemap</a>
                </div>
            </div>
        </div>
    </footer>

    <!-- Cookie Consent Banner -->
    <div id="cookie-consent-banner" class="fixed bottom-0 left-0 w-full bg-[#0B1120] text-white p-4 text-center z-[1001] hidden border-t border-white/10">
        <p class="mb-2 text-sm text-white/60"><?php echo __('cookie_message'); ?> <a href="<?php echo url('/privacy-policy'); ?>" class="text-doorhan-blue hover:underline"><?php echo __('Learn More'); ?></a>.</p>
        <button id="cookie-consent-button" class="bg-doorhan-blue hover:bg-blue-600 text-white px-6 py-2 text-xs font-black uppercase tracking-widest transition-colors"><?php echo __('cookie_btn'); ?></button>
    </div>

    <!-- Scripts -->
    <script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>
    <script src="<?php echo SITE_URL; ?>/assets/js/main.js"></script>

    <script>
        // Reveal Animation Logic from Template
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('active');
                }
            });
        }, { threshold: 0.1 });

        document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
    </script>
</body>
</html>
