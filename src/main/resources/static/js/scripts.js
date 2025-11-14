/*!
    * Start Bootstrap - SB Admin v7.0.7 (https://startbootstrap.com/template/sb-admin)
    * Copyright 2013-2023 Start Bootstrap
    * Licensed under MIT (https://github.com/StartBootstrap/startbootstrap-sb-admin/blob/master/LICENSE)
    */
// 
// Scripts
// 

// Show bootstrap toasts on pages when the toast elements are present
function showAdminToasts() {
    try {
        // ensure we only show once per page load
        if (window._adminToastsShown) return;
        window._adminToastsShown = true;

        const showToastIfExists = (id) => {
            const el = document.getElementById(id);
            if (el) {
                console.log(`Showing toast: ${id}`); // Debug log
                const bsToast = new bootstrap.Toast(el, {
                    delay: 5000,  // Show for 5 seconds
                    autohide: true
                });
                bsToast.show();

                // Debug: log when toast is shown
                el.addEventListener('shown.bs.toast', () => {
                    console.log(`Toast ${id} displayed successfully`);
                });
            } else {
                console.log(`Toast element ${id} not found`); // Debug log
            }
        };

        showToastIfExists('toast-success');
        showToastIfExists('toast-error');
    } catch (e) {
        // Better error logging
        console.error('Toast show failed:', e);
    }
}

// run after DOM loaded (keeps existing behavior)
window.addEventListener('DOMContentLoaded', () => {

    // Toggle the side navigation
    const sidebarToggle = document.body.querySelector('#sidebarToggle');
    if (sidebarToggle) {
        // Uncomment Below to persist sidebar toggle between refreshes
        // if (localStorage.getItem('sb|sidebar-toggle') === 'true') {
        //     document.body.classList.toggle('sb-sidenav-toggled');
        // }
        sidebarToggle.addEventListener('click', event => {
            event.preventDefault();
            document.body.classList.toggle('sb-sidenav-toggled');
            localStorage.setItem('sb|sidebar-toggle', document.body.classList.contains('sb-sidenav-toggled'));
        });
    }

    // show admin toasts (if any)
    showAdminToasts();

});

// In some environments the script may be executed after DOMContentLoaded has already fired
// (for example when included dynamically). Call the function immediately if the document
// is already in an interactive/complete state to ensure toasts are shown.
if (document.readyState === 'interactive' || document.readyState === 'complete') {
    // call async to avoid blocking if bootstrap isn't initialized yet
    setTimeout(showAdminToasts, 10);
}
