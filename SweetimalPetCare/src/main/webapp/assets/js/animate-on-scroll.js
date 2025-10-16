// Adds the 'animate-fadeInUp' class to elements with the 'fade-on-scroll' class when they enter the viewport.
// Usage: add class 'fade-on-scroll' to any element, optionally add 'delay-150' etc.
(function(){
    if (typeof window === 'undefined' || !('IntersectionObserver' in window)) return;

    var observer = new IntersectionObserver(function(entries){
        entries.forEach(function(entry){
            if (entry.isIntersecting) {
                var el = entry.target;
                // if element already has any animate-* class, skip
                if (!el.classList.contains('animate-fadeInUp')) {
                    // support data-delay attribute in ms or class-based delay
                    var delay = el.getAttribute('data-delay');
                    if (delay) {
                        el.style.animationDelay = delay;
                    }
                    el.classList.add('animate-fadeInUp');
                    // unobserve to prevent re-animating
                    observer.unobserve(el);
                }
            }
        });
    }, { threshold: 0.12 });

    document.addEventListener('DOMContentLoaded', function(){
        var els = document.querySelectorAll('.fade-on-scroll');
        els.forEach(function(el){ observer.observe(el); });
    });
})();
