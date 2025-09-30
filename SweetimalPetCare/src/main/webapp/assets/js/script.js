/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


const userMenuButton = document.getElementById('userMenuButton');
const userSidebar = document.getElementById('userSidebar');
const sidebarOverlay = document.getElementById('sidebarOverlay');
const closeButtonSidebar = document.getElementById('closeButtonSidebar');

function openSidebar() {
    userSidebar.classList.remove('translate-x-full');
    sidebarOverlay.classList.remove('hidden');
    setTimeout(() => {
        sidebarOverlay.classList.add('opacity-100');
    }, 10);
}

function closeSidebar() {
    userSidebar.classList.add('translate-x-full');
    sidebarOverlay.classList.remove('opacity-100');
    setTimeout(() => {
        sidebarOverlay.classList.add('hidden');
    }, 300);
}

userMenuButton.addEventListener('click', openSidebar);
sidebarOverlay.addEventListener('click', closeSidebar);
closeButtonSidebar.addEventListener('click', closeSidebar);