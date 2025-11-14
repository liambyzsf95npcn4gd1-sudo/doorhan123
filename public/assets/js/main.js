document.addEventListener('DOMContentLoaded', function () {
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

    const accordion = document.querySelector('.accordion');

    if (accordion) {
        accordion.addEventListener('click', function (event) {
            const header = event.target.closest('.accordion-header');

            if (!header) {
                return;
            }

            const accordionItem = header.parentElement;
            const accordionContent = header.nextElementSibling;

            accordionItem.classList.toggle('active');

            if (accordionContent.style.maxHeight) {
                accordionContent.style.maxHeight = null;
            } else {
                accordionContent.style.maxHeight = accordionContent.scrollHeight + 'px';
            }
        });
    }

    // Cookie Consent
    const cookieBanner = document.getElementById('cookie-consent-banner');
    const cookieButton = document.getElementById('cookie-consent-button');

    if (cookieBanner) {
        if (!localStorage.getItem('cookieConsent')) {
            cookieBanner.style.display = 'block';
        }

        cookieButton.addEventListener('click', () => {
            localStorage.setItem('cookieConsent', 'true');
            cookieBanner.style.display = 'none';
        });
    }
});
