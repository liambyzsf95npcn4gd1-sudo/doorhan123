</main>
    <footer class="site-footer">
        <div class="container">
            <div class="footer-grid">
                <div class="footer-col">
                    <h4>About DoorHan</h4>
                    <p>DoorHan is a leading global manufacturer of gates, doors, and automation systems, offering innovative and reliable solutions for over 30 years.</p>
                </div>
                <div class="footer-col">
                    <h4>Quick Links</h4>
                    <ul>
                        <li><a href="<?php echo SITE_URL; ?>/">Home</a></li>
                        <li><a href="<?php echo SITE_URL; ?>/products">Products</a></li>
                        <li><a href="<?php echo SITE_URL; ?>/news">News</a></li>
                        <li><a href="<?php echo SITE_URL; ?>/about">About</a></li>
                        <li><a href="<?php echo SITE_URL; ?>/contact">Contact</a></li>
                        <li><a href="<?php echo SITE_URL; ?>/privacy-policy">Privacy Policy</a></li>
                    </ul>
                </div>
                <div class="footer-col">
                    <h4>Regional Websites</h4>
                    <ul>
                        <li><a href="https://doorhan.cz" target="_blank">Czech Republic</a></li>
                        <li><a href="https://doorhan.cn" target="_blank">China</a></li>
                        <li><a href="https://doorhan.ae" target="_blank">UAE</a></li>
                        <li><a href="https://doorhan.de" target="_blank">Germany</a></li>
                        <li><a href="https://doorhan.lv" target="_blank">Latvia</a></li>
                        <li><a href="https://doorhan.fr" target="_blank">France</a></li>
                    </ul>
                </div>
                <div class="footer-col">
                    <h4>Connect With Us</h4>
                    <div class="social-icons">
                        <a href="#"><img src="<?php echo SITE_URL; ?>/assets/img/facebook.svg" alt="Facebook"></a>
                        <a href="#"><img src="<?php echo SITE_URL; ?>/assets/img/linkedin.svg" alt="LinkedIn"></a>
                        <a href="#"><img src="<?php echo SITE_URL; ?>/assets/img/youtube.svg" alt="YouTube"></a>
                    </div>
                </div>
            </div>
            <div class="copyright">
                <p>&copy; <?php echo date('Y'); ?> DoorHan International. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <div id="cookie-consent-banner" class="cookie-consent-banner">
        <p>We use cookies to ensure you get the best experience on our website. <a href="<?php echo SITE_URL; ?>/privacy-policy">Learn more</a>.</p>
        <button id="cookie-consent-button" class="btn btn-primary">Got it!</button>
    </div>

    <script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>
    <script src="<?php echo SITE_URL; ?>/assets/js/main.js"></script>

    <?php if (!empty($chatbot_settings['is_enabled'])): ?>
    <!-- Chatbot -->
    <link rel="stylesheet" href="<?php echo SITE_URL; ?>/assets/css/chatbot.css">
    <div id="chatbot-container">
        <div id="chatbot-button" style="background-color: <?php echo htmlspecialchars($chatbot_settings['button_color'] ?? '#007bff'); ?>;">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-message-square"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path></svg>
        </div>
        <div id="chatbot-window">
            <div id="chatbot-header" style="background-color: <?php echo htmlspecialchars($chatbot_settings['button_color'] ?? '#007bff'); ?>;">
                <span><?php echo htmlspecialchars($chatbot_settings['chatbot_name'] ?? 'Chatbot'); ?></span>
                <button id="chatbot-close">&times;</button>
            </div>
            <div id="chatbot-messages">
                <div class="message bot"><?php echo htmlspecialchars($chatbot_settings['welcome_message'] ?? 'Hello! How can I help you?'); ?></div>
            </div>
            <div id="chatbot-input-container">
                <input type="text" id="chatbot-input" placeholder="Type a message...">
                <button id="chatbot-send">Send</button>
            </div>
        </div>
    </div>
    <script src="<?php echo SITE_URL; ?>/assets/js/chatbot.js"></script>
    <?php endif; ?>
</body>
</html>