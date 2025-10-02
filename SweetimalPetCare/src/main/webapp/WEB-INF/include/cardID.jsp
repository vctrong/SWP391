<%-- 
    Document   : cardID
    Created on : Sep 30, 2025, 4:48:47 PM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div 
    id="userCardOverlay"
    class="hidden fixed inset-0 bg-black bg-opacity-60 backdrop-blur z-50 flex items-center justify-center p-4"
    >
    <div 
        id="userCard"
        class="bg-white rounded-2xl shadow-2xl max-w-md w-full overflow-hidden"
        >
        <!-- Header với GitHub theme -->
        <div class="relative bg-gradient-to-r from-violet-700 via-violet-800 to-indigo-800 text-white p-6">
            <button 
                id="closeCardBtn"
                class="absolute top-4 right-4 text-gray-300 hover:text-white focus:outline-none transition-colors z-10"
                >
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                </svg>
            </button>

            <div class="flex items-center space-x-4">
                <div class="w-16 h-16 bg-white bg-opacity-10 rounded-full p-1">
                    <img src="https://github.com/vctrong.png" alt="Avatar" class="w-full h-full rounded-full object-cover">
                </div>
                <div>
                    <h3 class="font-bold text-xl">${user.username}</h3>
                    <p class="text-gray-300">${user.fullName}</p>
                    <div class="flex items-center mt-1">
                        <svg class="w-4 h-4 text-green-400 mr-1" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path>
                        </svg>
                        <span class="text-green-400 text-sm">Active Developer</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Thông tin chi tiết -->
        <div class="p-6 space-y-4">
            <!-- User ID & Basic Info -->
            <div class="flex justify-between">
                <div  class="flex gap-2">
                    <span class="text-gray-500 text-sm font-medium block">User ID: </span>
                    <span class="text-gray-800 font-mono bg-gray-100 px-2 py-1 rounded text-sm">#${user.id}</span>
                </div>
                <div class="flex gap-2">
                    <span class="text-gray-500 text-sm font-medium block">Member Since: </span>
                    <span class="text-gray-800 text-sm font-mono bg-gray-100 px-2 py-1 rounded">2023</span>
                </div>
            </div>

            <!-- Contact Info -->
            <div class="space-y-2">
                <div class="flex items-center justify-between">
                    <span class="text-gray-500 text-sm font-medium">Email:</span>
                    <span class="text-gray-800 text-sm font-mono bg-gray-100 px-2 py-1 rounded">${user.email}</span>
                </div>
                <div class="flex items-center justify-between">
                    <span class="text-gray-500 text-sm font-medium">Phone:</span>
                    <span class="text-gray-800 text-sm font-mono bg-gray-100 px-2 py-1 rounded">${user.phone}</span>
                </div>
                <div class="flex items-center justify-between">
                    <span class="text-gray-500 text-sm font-medium">Location:</span>
                    <span class="text-gray-800 text-sm font-mono bg-gray-100 px-2 py-1 rounded">Vietnam</span>
                </div>
            </div>

            <!-- GitHub Stats -->
            <div class="bg-gray-50 rounded-lg p-4">
                <h4 class="font-semibold text-gray-800 mb-3">GitHub Statistics</h4>
                <div class="grid grid-cols-3 gap-4 text-center">
                    <div>
                        <div class="text-2xl font-bold text-blue-600">5</div>
                        <div class="text-xs text-gray-500">Repositories</div>
                    </div>
                    <div>
                        <div class="text-2xl font-bold text-green-600">47</div>
                        <div class="text-xs text-gray-500">Commits</div>
                    </div>
                    <div>
                        <div class="text-2xl font-bold text-purple-600">2</div>
                        <div class="text-xs text-gray-500">Stars</div>
                    </div>
                </div>
            </div>

            <!-- Role & Status -->
            <div class="flex items-center justify-between">
                <span class="text-gray-500 text-sm font-medium">Role:</span>
                <span class="bg-blue-100 text-blue-800 text-xs font-semibold px-3 py-1 rounded-full">
                    ${user.roleEnum.text}
                </span>
            </div>

            <!-- Top Repositories -->


            <!-- Last Activity -->
            <div class="bg-blue-50 rounded-lg p-3">
                <div class="flex items-center justify-between">
                    <span class="text-blue-700 text-sm font-medium">Last Activity:</span>
                    <span class="text-blue-800 text-sm font-semibold">2025-09-30</span>
                </div>
            </div>
        </div>

        <!-- Footer Actions -->
        <div class="px-6 pb-6 flex space-x-3">
            <a href="https://github.com/vctrong" target="_blank" class="flex-1 bg-fuchsia-500 hover:bg-fuchsia-600 text-white font-medium py-3 px-4 rounded-lg transition duration-200 text-center">
                Edit Profile
            </a>
            <button onclick="hideCard()" class="flex-1 bg-gray-500 hover:bg-gray-600 text-white font-medium py-3 px-4 rounded-lg transition duration-200">
                Close
            </button>
        </div>
    </div>
</div>

<script src="assets/js/cardID.js" ></script>