/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


document.addEventListener('DOMContentLoaded', function () {
    var userMenuButton = document.getElementById('userMenuButton');
    var userSidebar = document.getElementById('userSidebar');
    var sidebarOverlay = document.getElementById('sidebarOverlay');
    var closeButtonSidebar = document.getElementById('closeButtonSidebar');

    function openSidebar() {
        if (!userSidebar || !sidebarOverlay) return;
        userSidebar.classList.remove('translate-x-full');
        // ensure overlay is visible and starts from opacity-0 so transition can animate
        sidebarOverlay.classList.remove('hidden');
        // ensure it's at opacity 0 first, force reflow, then transition to opacity-100
        sidebarOverlay.classList.add('opacity-0');
        // force reflow so the browser registers the opacity-0 before we change it
        // eslint-disable-next-line no-unused-expressions
        sidebarOverlay.offsetWidth;
        sidebarOverlay.classList.add('opacity-100');
        sidebarOverlay.classList.remove('opacity-0');
    }

    function closeSidebar() {
        if (!userSidebar || !sidebarOverlay) return;
        userSidebar.classList.add('translate-x-full');
        // transition overlay back to transparent then hide after transition
        sidebarOverlay.classList.remove('opacity-100');
        sidebarOverlay.classList.add('opacity-0');
        setTimeout(function () { sidebarOverlay.classList.add('hidden'); }, 300);
    }

    if (userMenuButton) userMenuButton.addEventListener('click', openSidebar);
    if (sidebarOverlay) sidebarOverlay.addEventListener('click', closeSidebar);
    if (closeButtonSidebar) closeButtonSidebar.addEventListener('click', closeSidebar);
});