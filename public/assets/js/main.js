document.addEventListener('DOMContentLoaded', function () {
    // Accordion Logic (moved to top to avoid Swiper dependency blocking)
    const accordionItems = document.querySelectorAll('.accordion-item');

    accordionItems.forEach(item => {
        const header = item.querySelector('.accordion-header');
        const content = item.querySelector('.accordion-content');

        if (header && content) {
            header.addEventListener('click', (e) => {
                e.preventDefault(); // Prevent any default button behavior

                // Toggle the 'active' class on the accordion item
                item.classList.toggle('active');

                // Toggle the content's max-height
                if (content.style.maxHeight && content.style.maxHeight !== '0px') {
                    content.style.maxHeight = null;
                } else {
                    content.style.maxHeight = content.scrollHeight + 'px';
                }
            });
        }
    });

    // Initialize Swiper only if available
    if (typeof Swiper !== 'undefined') {
        try {
            if (document.querySelector('.hero-slider .swiper-container')) {
                const heroSlider = new Swiper('.hero-slider .swiper-container', {
                    loop: true,
                    pagination: {
                        el: '.swiper-pagination',
                        clickable: true,
                    },
                    navigation: {
                        nextEl: '.swiper-button-next',
                        prevEl: '.swiper-button-prev',
                    },
                });
            }

            if (document.querySelector('.news-carousel')) {
                const newsCarousel = new Swiper('.news-carousel', {
                    slidesPerView: 1,
                    spaceBetween: 30,
                    pagination: {
                        el: '.swiper-pagination',
                        clickable: true,
                    },
                    breakpoints: {
                        768: {
                            slidesPerView: 2,
                        },
                        992: {
                            slidesPerView: 3,
                        },
                    },
                });
            }

            if (document.querySelector('.partners-slider')) {
                const partnersSlider = new Swiper('.partners-slider', {
                    slidesPerView: 2,
                    spaceBetween: 30,
                    autoplay: {
                        delay: 2500,
                        disableOnInteraction: false,
                    },
                    breakpoints: {
                        768: {
                            slidesPerView: 3,
                        },
                        992: {
                            slidesPerView: 5,
                        },
                    },
                });
            }

            if (document.querySelector('.gallery-slider')) {
                const gallerySlider = new Swiper('.gallery-slider', {
                    loop: true,
                    pagination: {
                        el: '.swiper-pagination',
                        clickable: true,
                    },
                    navigation: {
                        nextEl: '.swiper-button-next',
                        prevEl: '.swiper-button-prev',
                    },
                });
            }
        } catch (e) {
            console.error('Swiper initialization error:', e);
        }
    } else {
        console.warn('Swiper not loaded. Sliders will not function.');
    }

    // Cookie Consent
    const cookieBanner = document.getElementById('cookie-consent-banner');
    const cookieButton = document.getElementById('cookie-consent-button');

    if (cookieBanner && cookieButton) {
        if (!localStorage.getItem('cookieConsent')) {
            cookieBanner.style.display = 'block';
        }

        cookieButton.addEventListener('click', () => {
            localStorage.setItem('cookieConsent', 'true');
            cookieBanner.style.display = 'none';
        });
    }
});
