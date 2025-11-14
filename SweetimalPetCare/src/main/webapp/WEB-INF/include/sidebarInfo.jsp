<%--
    Document   : sidebarInfo
    Created on : Sep 28, 2025, 10:06:25 PM
    Author     : Vo Chi Trong - CE191062
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div>
    <!-- Sidebar Overlay -->
    <div id="sidebarOverlay" class="fixed inset-0 bg-black bg-opacity-50 z-40 hidden opacity-0 transition-opacity duration-300"></div>

    <!-- Sidebar Menu -->
    <div id="userSidebar"
         class="fixed right-0 top-0 h-full w-80 bg-white shadow-2xl z-50 transform
         translate-x-full transition-transform duration-300 flex flex-col">
        <!-- Close button -->
        <button id="closeButtonSidebar" class="absolute top-4 right-4 text-white hover:text-pink-300 transition duration-200">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
        </button>
        <!-- Top Section: User Info -->
        <div class="p-6 border-b border-gray-200 bg-gradient-to-r from-blue-500 to-blue-700 text-white">
            <div class="flex items-center space-x-4">
                <img src="assets/img/logo.jpg" class="w-16 h-16 rounded-full border-4 border-white shadow-lg" alt="Profile">
                    <div>
                        <!-- Full Name -->
                        <div class="font-bold text-xl">${user.fullName}</div>
                        <!-- Role -->
                        <div class="text-blue-100">Role: ${user.roleEnum.text} <i class="${user.roleEnum.icon}" ></i> </div>
                        <!-- Email -->
                        <div class="text-blue-100 text-sm">${user.email}</div>
                        <!-- User ID -->
                        <div class="flex justify-center">
                            <button id="showCardBtn"
                                    class="mt-2 bg-gradient-to-r from-blue-500 to-purple-600 hover:from-blue-600 hover:to-purple-700 text-white font-bold py-2 px-4 rounded-xl shadow-lg transform transition duration-200 hover:scale-105 focus:outline-none focus:ring-4 focus:ring-blue-300">
                                <svg class="w-6 h-6 inline-block mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                          d="M15 9h3m-3 3h3m-3 3h3m-6 1c-.306-.613-.933-1-1.618-1H7.618c-.685 0-1.312.387-1.618 1M4 5h16a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V6a1 1 0 0 1 1-1Zm7 5a2 2 0 1 1-4 0 2 2 0 0 1 4 0Z"/>
                                </svg>
                                Card ID: ${user.id}
                            </button>
                        </div>
                    </div>
            </div>

            <div class="mt-4">
                <div class="text-sm text-blue-100">Number of pets: ${user.nop}</div>
                <div class="mt-2 bg-blue-800 bg-opacity-30 rounded-lg p-2 text-sm">
                    <div class="font-semibold">
                        Pet Owner Since: <span class="text-green-300"> <fmt:formatDate value="${user.create}" type="date" /> </span>
                    </div>
                </div>
            </div>
        </div>



        <!-- Middle Section: Useful Information -->
        <div class="flex-1 overflow-y-auto p-4 bg-gray-50">
            <h3 class="font-bold text-gray-700 mb-3">Utilities</h3>
            <div class="space-y-2">
                <a href="${pageContext.request.contextPath}/pets"
                   class="flex items-center p-2 rounded-lg hover:bg-blue-100 transition-colors duration-200 group">
                    <svg class="h-5 w-5 text-blue-600 mr-2 group-hover:text-blue-800 transition-colors duration-200"
                         xmlns="http://www.w3.org/2000/svg" width="20" height="20"
                         viewBox="0 0 14 14" fill="currentColor">
                        <g fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M.75 11.018v-7.59l1.254 1.004c.633.506 1.42.782 2.23.782H7L8.292 2.63a1.786 1.786 0 0 1 1.597-.987h.682v2.232l2.679.893v.893c0 .986-.8 1.785-1.786 1.785H9.68v3.572a1.34 1.34 0 1 1-2.679 0v-.447c0-.493-.4-.892-.893-.892H4.321c-.493 0-.892.4-.892.892v.447a1.34 1.34 0 1 1-2.679 0"/>
                            <path d="M7.012 5.097c.175.717 1 2.195 2.895 2.375"/>
                        </g>
                    </svg>
                    <span class="text-gray-700 group-hover:text-blue-800 transition-colors duration-200">Quản lý Pets</span>
                </a>

                <a href="https://github.com/vctrong/CacBaiThuyetTrinh" class="flex items-center p-2 rounded-lg hover:bg-blue-100 transition-colors duration-200">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-blue-600 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-6l-2-2H5a2 2 0 00-2 2z" />
                    </svg>
                    <span class="text-gray-700">CacBaiThuyetTrinh</span>
                </a>
                <a href="https://github.com/vctrong/projectSWP391" class="flex items-center p-2 rounded-lg hover:bg-blue-100 transition-colors duration-200">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-blue-600 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-6l-2-2H5a2 2 0 00-2 2z" />
                    </svg>
                    <span class="text-gray-700">projectSWP391</span>
                </a>
            </div>

            <div class="mt-6">
                <h3 class="font-bold text-gray-700 mb-3">Quick Links</h3>
                <div class="grid grid-cols-2 gap-2">
                    <a href="${pageContext.request.contextPath}/profile" class="bg-white p-3 rounded-lg shadow-sm border border-gray-200 hover:shadow-md transition-shadow duration-200 flex flex-col items-center">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-blue-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                        </svg>
                        <span class="text-sm text-gray-600 mt-1">Profile</span>
                    </a>
                    <a href="settings" class="bg-white p-3 rounded-lg shadow-sm border border-gray-200 hover:shadow-md transition-shadow duration-200 flex flex-col items-center">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-blue-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                        </svg>
                        <span class="text-sm text-gray-600 mt-1">Settings</span>
                    </a>
                    <c:if test="${user.role != 1}" >
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="bg-white p-3 rounded-lg shadow-sm border border-gray-200 hover:shadow-md transition-shadow duration-200 flex flex-col items-center">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-blue-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                            </svg>
                            <span class="text-sm text-gray-600 mt-1">Dashboard</span>
                        </a>
                    </c:if>

                    <a href="${pageContext.request.contextPath}/services"
                       class="bg-white p-3 rounded-lg shadow-sm border border-gray-200 hover:shadow-md transition-shadow duration-200 flex flex-col items-center">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-blue-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                        </svg>
                        <span class="text-sm text-gray-600 mt-1">Services</span>
                    </a>
                       
                   
                        <a href="${pageContext.request.contextPath}/vet/visits"
                           class="bg-white p-3 rounded-lg shadow-sm border border-gray-200 hover:shadow-md transition-shadow duration-200 flex flex-col items-center">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-blue-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                            </svg>
                            <span class="text-sm text-gray-600 mt-1">Vet feedback</span>
                        </a>
            
                       
                </div>
            </div>

            <div class="mt-6 bg-blue-50 rounded-lg p-4">
                <h3 class="font-bold text-blue-700 flex items-center">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                    Activity Status
                </h3>
                <div class="mt-2 text-sm text-gray-600">
                    <div class="flex justify-between items-center mb-1">
                        <span>Completed Tasks</span>
                        <span class="font-bold text-blue-700">12/15</span>
                    </div>
                    <div class="w-full bg-gray-200 rounded-full h-2">
                        <div class="bg-blue-600 h-2 rounded-full" style="width: 80%"></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bottom Section: Logout Button -->
        <form action="logout" method="GET">
            <div class="p-4 border-t border-gray-200">
                <button type="submit" class="w-full py-2 px-4 bg-gradient-to-r from-red-500 to-red-600 hover:from-red-600 hover:to-red-700 text-white rounded-lg transition duration-200 flex items-center justify-center">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                    </svg>
                    Logout
                </button>
        </form>

    </div>

</div>
