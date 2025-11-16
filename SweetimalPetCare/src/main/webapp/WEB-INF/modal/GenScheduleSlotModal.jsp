<%-- 
    Document   : GenScheduleSlotModal
    Created on : Nov 14, 2025, 7:56:46 PM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div id="scheduleModal" class="fixed inset-0 z-50 hidden overflow-y-auto" aria-labelledby="modal-title" role="dialog" aria-modal="true">
    <div class="flex items-end justify-center min-h-screen px-4 pt-4 pb-20 text-center sm:block sm:p-0">

        <div class="fixed inset-0 transition-opacity bg-gray-500 bg-opacity-75" onclick="closeScheduleModal()"></div>

        <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>

        <div class="inline-block overflow-hidden text-left align-bottom transition-all transform bg-white rounded-lg shadow-xl sm:my-8 sm:align-middle sm:max-w-lg sm:w-full">

            <div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
                <div class="sm:flex sm:items-start">
                    <div class="mx-auto flex-shrink-0 flex items-center justify-center h-12 w-12 rounded-full bg-blue-100 sm:mx-0 sm:h-10 sm:w-10">
                        <svg class="h-6 w-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                        </svg>
                    </div>
                    <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left w-full">
                        <h3 class="text-lg leading-6 font-medium text-gray-900" id="modal-title">
                            Xếp lịch làm việc
                        </h3>
                        <div class="mt-2">
                            <p class="text-sm text-gray-500">
                                Tạo lịch tự động cho nhân viên: <span id="modalStaffName" class="font-bold text-blue-600">...</span>
                            </p>
                        </div>
                    </div>
                </div>

                <form id="generateScheduleForm" onsubmit="submitSchedule(event)" class="mt-5 space-y-4">
                    <input type="hidden" id="scheduleStaffId" name="staffId" />

                    <div class="grid grid-cols-2 gap-4">
                        <div class="col-span-1">
                            <label class="block text-sm font-medium text-gray-700">Từ ngày</label>
                            <input type="date" name="startDate" required 
                                   class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm">
                        </div>
                        <div class="col-span-1">
                            <label class="block text-sm font-medium text-gray-700">Đến ngày</label>
                            <input type="date" name="endDate" required 
                                   class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm">
                        </div>

                        <div class="col-span-1">
                            <label class="block text-sm font-medium text-gray-700">Bắt đầu ca</label>
                            <select name="startHour" class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm">
                                <option value="7">07:00</option>
                                <option value="8" selected>08:00</option>
                                <option value="9">09:00</option>
                            </select>
                        </div>
                        <div class="col-span-1">
                            <label class="block text-sm font-medium text-gray-700">Kết thúc ca</label>
                            <select name="endHour" class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm">
                                <option value="16">16:00</option>
                                <option value="17" selected>17:00</option>
                                <option value="18">18:00</option>
                                <option value="19">19:00</option>
                                <option value="20">20:00</option>
                            </select>
                        </div>

                        <div class="col-span-2">
                            <label class="block text-sm font-medium text-gray-700">Thời lượng mỗi Slot</label>
                            <select name="duration" class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm">
                                <option value="30">30 phút (Khám nhanh/Tiêm)</option>
                                <option value="60" selected>60 phút (Tiêu chuẩn)</option>
                                <option value="90">90 phút (Spa/Cắt tỉa)</option>
                                <option value="120">120 phút (Phẫu thuật)</option>
                            </select>
                        </div>

                        <div class="col-span-2">
                            <label class="block text-sm font-medium text-gray-700">Phòng / Vị trí</label>
                            <select name="roomName" class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm">
                                <option value="Phòng khám 1">Phòng khám 1 </option>
                                <option value="Phòng khám 2">Phòng khám 2 </option>
                                <option value="Phòng phẫu thuật">Phòng phẫu thuật (Surgery)</option>
                                <option value="Khu vực Spa A">Khu vực Spa - Bàn A</option>
                                <option value="Khu vực Spa B">Khu vực Spa - Bàn B</option>
                                <option value="Lưu trú">Khu lưu trú (Boarding)</option>
                            </select>
                        </div>

                        <div class="col-span-2 flex items-start">
                            <div class="flex items-center h-5">
                                <input id="skipLunch" name="skipLunch" type="checkbox" checked 
                                       class="focus:ring-blue-500 h-4 w-4 text-blue-600 border-gray-300 rounded">
                            </div>
                            <div class="ml-3 text-sm">
                                <label for="skipLunch" class="font-medium text-gray-700">Trừ giờ nghỉ trưa</label>
                                <p class="text-gray-500">Hệ thống sẽ không tạo slot trong khung giờ 12:00 - 13:00.</p>
                            </div>
                        </div>
                    </div>
                </form>
            </div>

            <div class="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse gap-2">
                <button type="submit" form="generateScheduleForm" 
                        class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-blue-600 text-base font-medium text-white hover:bg-blue-700 focus:outline-none sm:ml-3 sm:w-auto sm:text-sm">
                    Xác nhận tạo
                </button>
                <button type="button" onclick="closeScheduleModal()" 
                        class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm">
                    Hủy bỏ
                </button>
            </div>
        </div>
    </div>
</div>