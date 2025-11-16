<%-- 
    Document   : modalVetVisit
    Created on : Nov 14, 2025, 9:39:43 PM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div id="vetVisitModal" class="fixed inset-0 z-50 hidden overflow-y-auto" aria-labelledby="modal-title" role="dialog" aria-modal="true">
    <div class="flex items-end justify-center min-h-screen px-4 pt-4 pb-20 text-center sm:block sm:p-0">

        <div class="fixed inset-0 transition-opacity bg-gray-500 bg-opacity-75" onclick="closeVetModal()"></div>

        <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>

        <div class="inline-block overflow-hidden text-left align-bottom transition-all transform bg-white rounded-lg shadow-xl sm:my-8 sm:align-middle sm:max-w-2xl sm:w-full">

            <form id="vetVisitForm" onsubmit="submitVetVisit(event)">
                <div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">

                    <div class="flex items-center gap-3 mb-6 border-b pb-2">
                        <div class="bg-teal-100 p-2 rounded-full text-teal-600">
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"></path></svg>
                        </div>
                        <h3 class="text-lg font-medium leading-6 text-gray-900">
                            Hồ sơ bệnh án: <span id="vetPetName" class="font-bold text-blue-600">...</span>
                        </h3>
                    </div>

                    <input type="hidden" name="bookingId" id="vetBookingId">
                    <input type="hidden" name="petId" id="vetPetId">
                    <input type="hidden" name="customerId" id="vetOwnerId">

                    <div class="grid grid-cols-2 gap-4">

                        <div class="col-span-1">
                            <label class="block text-sm font-medium text-gray-700">Loại khám</label>
                            <select name="visitType" class="mt-1 block w-full border-gray-300 rounded-md shadow-sm border p-2 focus:ring-teal-500 focus:border-teal-500">
                                <option value="CHECKUP">Khám tổng quát</option>
                                <option value="VACCINE">Tiêm phòng</option>
                                <option value="SURGERY">Phẫu thuật</option>
                                <option value="EMERGENCY">Cấp cứu</option>
                                <option value="ULTRASOUND">Siêu âm</option>
                            </select>
                        </div>
                        <div class="col-span-1">
                            <label class="block text-sm font-medium text-gray-700">Thời gian khám</label>
                            <input type="datetime-local" name="visitDate" required class="mt-1 block w-full border-gray-300 rounded-md shadow-sm border p-2">
                        </div>

                        <div class="col-span-1">
                            <label class="block text-sm font-medium text-gray-700">Cân nặng (kg)</label>
                            <input type="number" step="0.01" name="weight" placeholder="Vd: 5.5" class="mt-1 block w-full border-gray-300 rounded-md shadow-sm border p-2">
                        </div>
                        <div class="col-span-1">
                            <label class="block text-sm font-medium text-gray-700">Nhiệt độ (°C)</label>
                            <input type="number" step="0.1" name="temperature" placeholder="Vd: 38.5" class="mt-1 block w-full border-gray-300 rounded-md shadow-sm border p-2">
                        </div>

                        <div class="col-span-2">
                            <label class="block text-sm font-medium text-gray-700">Triệu chứng (Symptoms)</label>
                            <textarea name="symptoms" rows="2" class="mt-1 block w-full border-gray-300 rounded-md shadow-sm border p-2" placeholder="Mô tả triệu chứng..."></textarea>
                        </div>

                        <div class="col-span-2">
                            <label class="block text-sm font-medium text-gray-700">Chẩn đoán (Diagnosis)</label>
                            <textarea name="diagnosis" rows="2" class="mt-1 block w-full border-gray-300 rounded-md shadow-sm border p-2" placeholder="Kết luận bệnh..."></textarea>
                        </div>

                        <div class="col-span-2">
                            <label class="block text-sm font-medium text-gray-700">Điều trị / Ghi chú (Treatment)</label>
                            <textarea name="treatment" rows="3" class="mt-1 block w-full border-gray-300 rounded-md shadow-sm border p-2" placeholder="Thuốc men, hướng dẫn chăm sóc..."></textarea>
                        </div>

                        <div class="col-span-1">
                            <label class="block text-sm font-medium text-gray-700">Hẹn tái khám (Nếu có)</label>
                            <input type="date" name="followUpDate" class="mt-1 block w-full border-gray-300 rounded-md shadow-sm border p-2">
                        </div>
                    </div>
                </div>

                <div class="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse gap-2">
                    <button type="submit" class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-teal-600 text-base font-medium text-white hover:bg-teal-700 sm:ml-3 sm:w-auto sm:text-sm">
                        Lưu Hồ Sơ
                    </button>
                    <button type="button" onclick="closeVetModal()" class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm">
                        Hủy bỏ
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>