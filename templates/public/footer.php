</main>
    <footer class="site-footer">
        <div class="container">
            <div class="footer-grid">
                <div class="footer-col">
                    <h4><?php echo __('About'); ?> DoorHan</h4>
                    <p><?php echo __('about_doorhan_desc'); ?></p>
                </div>
                <div class="footer-col">
                    <h4><?php echo __('Quick Links'); ?></h4>
                    <ul>
                        <li><a href="<?php echo url('/'); ?>"><?php echo __('Home'); ?></a></li>
                        <li><a href="<?php echo url('/products'); ?>"><?php echo __('Products'); ?></a></li>
                        <li><a href="<?php echo url('/news'); ?>"><?php echo __('News'); ?></a></li>
                        <li><a href="<?php echo url('/about'); ?>"><?php echo __('About'); ?></a></li>
                        <li><a href="<?php echo url('/contact'); ?>"><?php echo __('Contact'); ?></a></li>
                        <li><a href="<?php echo url('/privacy-policy'); ?>"><?php echo __('Privacy Policy'); ?></a></li>
                    </ul>
                </div>
                <div class="footer-col">
                    <h4><?php echo __('Regional Websites'); ?></h4>
                    <ul>
                        <li><a href="https://doorhan.cz" target="_blank"><?php echo __('Czech Republic'); ?></a></li>
                        <li><a href="https://doorhan.cn" target="_blank"><?php echo __('China'); ?></a></li>
                        <li><a href="https://doorhan.ae" target="_blank"><?php echo __('UAE'); ?></a></li>
                        <li><a href="https://doorhan.de" target="_blank"><?php echo __('Germany'); ?></a></li>
                        <li><a href="https://doorhan.lv" target="_blank"><?php echo __('Latvia'); ?></a></li>
                        <li><a href="https://doorhan.fr" target="_blank"><?php echo __('France'); ?></a></li>
                    </ul>
                </div>
                <div class="footer-col">
                    <h4><?php echo __('Connect With Us'); ?></h4>
                    <div class="social-icons">
                        <a href="#"><img src="<?php echo SITE_URL; ?>/assets/img/facebook.svg" alt="Facebook"></a>
                        <a href="#"><img src="<?php echo SITE_URL; ?>/assets/img/linkedin.svg" alt="LinkedIn"></a>
                        <a href="#"><img src="<?php echo SITE_URL; ?>/assets/img/youtube.svg" alt="YouTube"></a>
                    </div>
                </div>
            </div>
            <div class="copyright">
                <p>&copy; <?php echo date('Y'); ?> DoorHan International. <?php echo __('All rights reserved'); ?></p>
            </div>
        </div>
    </footer>

    <div id="cookie-consent-banner" class="cookie-consent-banner">
        <p><?php echo __('cookie_message'); ?> <a href="<?php echo url('/privacy-policy'); ?>"><?php echo __('Learn More'); ?></a>.</p>
        <button id="cookie-consent-button" class="btn btn-primary"><?php echo __('cookie_btn'); ?></button>
    </div>

    <script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>
    <script src="<?php echo SITE_URL; ?>/assets/js/main.js"></script>
</body>
</html>