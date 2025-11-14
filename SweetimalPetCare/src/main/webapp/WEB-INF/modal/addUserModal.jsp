<%-- 
    Document   : addUserModal
    Created on : Nov 14, 2025, 3:58:16 PM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div id="addPersonModal" class="fixed inset-0 bg-gray-900 bg-opacity-50 hidden z-50 flex items-center justify-center backdrop-blur-sm p-4 transition-opacity duration-300">

    <div class="bg-white rounded-xl shadow-2xl w-full max-w-2xl overflow-hidden transform transition-all scale-100">

        <div class="px-6 py-4 border-b border-gray-100 flex justify-between items-center bg-gray-50">
            <h3 class="text-lg font-bold text-gray-800">Add New Person</h3>
            <button id="closeModalBtn" type="button" class="text-gray-400 hover:text-gray-600 focus:outline-none transition-colors">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
            </button>
        </div>

        <form id="addPersonForm" action="${pageContext.request.contextPath}/admin/GetPersonal" method="POST">

            <input type="hidden" id="formAction" name="action" value="add">

            <input type="hidden" id="editUserId" name="user_id" value="">

            <div class="p-6 max-h-[75vh] overflow-y-auto custom-scrollbar">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">

                    <div class="space-y-4">
                        <h4 class="text-xs font-bold text-gray-400 uppercase tracking-wider border-b pb-1">Account Details</h4>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Username <span class="text-red-500">*</span></label>
                            <input type="text" name="username" required placeholder="e.g. user123" 
                                   class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none text-sm transition-all">
                        </div>

                        <div id="passwordFieldContainer">
                            <label class="block text-sm font-medium text-gray-700 mb-1">Password <span class="text-red-500">*</span></label>
                            <input type="password" id="passwordInput" name="password" required placeholder="••••••••" 
                                   class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none text-sm transition-all">
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Role <span class="text-red-500">*</span></label>
                            <select name="role_id" id="roleSelect" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none bg-white text-sm transition-all">
                                <option value="1">Customer</option>
                                <option value="2">Staff</option>
                                <option value="3">Veterinarian (Doctor)</option>
                            </select>
                        </div>
                    </div>

                    <div class="space-y-4">
                        <h4 class="text-xs font-bold text-gray-400 uppercase tracking-wider border-b pb-1">Personal Info</h4>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Full Name <span class="text-red-500">*</span></label>
                            <input type="text" name="full_name" required placeholder="e.g. Nguyen Van A" 
                                   class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none text-sm transition-all">
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Email <span class="text-red-500">*</span></label>
                            <input type="email" name="email" required placeholder="name@example.com" 
                                   class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none text-sm transition-all">
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Phone</label>
                            <input type="tel" name="phone" placeholder="090..." 
                                   class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none text-sm transition-all">
                        </div>

                        <div>
                            <span class="block text-sm font-medium text-gray-700 mb-2">Gender</span>
                            <div class="flex gap-4">
                                <label class="flex items-center gap-2 cursor-pointer hover:bg-gray-50 p-1 rounded transition-colors">
                                    <input type="radio" name="gender" value="1" checked class="text-blue-600 focus:ring-blue-500">
                                    <span class="text-sm text-gray-600">Male</span>
                                </label>
                                <label class="flex items-center gap-2 cursor-pointer hover:bg-gray-50 p-1 rounded transition-colors">
                                    <input type="radio" name="gender" value="0" class="text-blue-600 focus:ring-blue-500">
                                    <span class="text-sm text-gray-600">Female</span>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <div id="staffFields" class="hidden mt-6 pt-4 border-t border-gray-100 bg-blue-50/50 p-4 rounded-lg border border-blue-100">
                    <h4 class="text-xs font-bold text-blue-600 uppercase tracking-wider mb-3 flex items-center gap-1">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path></svg>
                        Professional Details
                    </h4>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div class="col-span-2 md:col-span-1">
                            <label class="block text-sm font-medium text-gray-700 mb-1">Position Title</label>
                            <input type="text" name="position_title" placeholder="e.g. Senior Vet, Groomer" 
                                   class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-blue-500 text-sm">
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Hire Date</label>
                            <input type="date" name="hire_date" 
                                   class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-blue-500 text-sm text-gray-600">
                        </div>

                        <div id="vetSpecificFields" class="hidden">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">Specialty (Vets only)</label>
                                <input type="text" name="specialty" placeholder="e.g. Surgery, Internal Med" 
                                       class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-blue-500 text-sm">
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">License Number (Vets only)</label>
                                <input type="text" name="license_number" placeholder="e.g. VET-2023-001" 
                                       class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-blue-500 text-sm">
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="px-6 py-4 bg-gray-50 border-t border-gray-100 flex justify-end gap-3">
                <button type="button" id="cancelModalBtn" class="px-4 py-2 bg-white border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 font-medium text-sm transition-colors focus:ring-2 focus:ring-gray-200">
                    Cancel
                </button>
                <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 font-medium text-sm shadow-sm transition-colors flex items-center gap-2 focus:ring-2 focus:ring-blue-500 focus:ring-offset-1">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>
                    Save User
                </button>
            </div>
        </form>
    </div>
</div>