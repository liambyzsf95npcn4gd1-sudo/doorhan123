document.addEventListener('DOMContentLoaded', function() {
    const mobileNavToggle = document.querySelector('.mobile-nav-toggle');
    const mainNav = document.querySelector('.main-nav');
    const body = document.querySelector('body');

    mobileNavToggle.addEventListener('click', function() {
        mainNav.classList.toggle('active');
        body.classList.toggle('mobile-nav-active');
    });

    const dropdownToggles = document.querySelectorAll('.main-nav .has-dropdown > a');

    dropdownToggles.forEach(function(toggle) {
        toggle.addEventListener('click', function(e) {
            if (window.innerWidth <= 768) {
                e.preventDefault();
                const parent = this.parentElement;
                parent.classList.toggle('active');
            }
        });
    });
});
