/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


tailwind.config = {
    theme: {
        extend: {
            // Bạn có thể thêm màu brand ở đây nếu muốn
            colors: {
                sky: tailwind.colors.sky,
                emerald: tailwind.colors.emerald,
                amber: tailwind.colors.amber
            }
        }
    },
    // Thêm các lớp @apply từ style.css
    plugins: [
        function ( { addComponents }) {
            addComponents({
                '.btn-primary': {
                    '@apply px-4 py-2 bg-sky-600 text-white text-sm font-medium rounded-md shadow-sm hover:bg-sky-700 focus:outline-none focus:ring-2 focus:ring-sky-500 focus:ring-offset-2 transition-colors': {}
                },
                '.btn-danger': {
                    '@apply px-4 py-2 bg-red-50 text-red-600 text-sm font-medium rounded-md shadow-sm hover:bg-red-100 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2 transition-colors': {}
                },
                '.input-field': {
                    '@apply block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:border-sky-500 focus:ring-1 focus:ring-sky-500 sm:text-sm': {}
                },
                '.table-header-cell': {
                    '@apply px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider': {}
                }
            });
        }
    ]
};