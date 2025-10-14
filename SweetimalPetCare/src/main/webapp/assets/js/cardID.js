/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


const showCardBtn = document.getElementById('showCardBtn');
const userCardOverlay = document.getElementById('userCardOverlay');
const userCard = document.getElementById('userCard');
const closeCardBtn = document.getElementById('closeCardBtn');
let isAnimating = false;

// Hiển thị card với animation rơi từ trên
showCardBtn.addEventListener('click', () => {
    if (isAnimating)
        return;

    isAnimating = true;
    userCardOverlay.classList.remove('hidden');
    userCard.classList.remove('fall-up');
    userCard.classList.add('fall-down');

    // Prevent scrolling when overlay is open
    document.body.style.overflow = 'hidden';

    setTimeout(() => {
        isAnimating = false;
    }, 600);
});

// Function để ẩn card
function hideCard() {
    if (isAnimating)
        return;

    isAnimating = true;
    userCard.classList.remove('fall-down');
    userCard.classList.add('fall-up');

    setTimeout(() => {
        userCardOverlay.classList.add('hidden');
        userCard.classList.remove('fall-up');
        document.body.style.overflow = 'auto';
        isAnimating = false;
    }, 400);
}

// Ẩn card khi click nút đóng
closeCardBtn.addEventListener('click', hideCard);

// Ẩn card khi click overlay (không click vào card)
userCardOverlay.addEventListener('click', (e) => {
    if (e.target === userCardOverlay) {
        hideCard();
    }
});

// Đóng card khi nhấn ESC
document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && !userCardOverlay.classList.contains('hidden')) {
        hideCard();
    }
});

// Prevent card click from closing
userCard.addEventListener('click', (e) => {
    e.stopPropagation();
});