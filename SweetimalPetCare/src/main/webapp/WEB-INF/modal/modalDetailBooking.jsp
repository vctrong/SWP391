<%-- 
    Document   : modalDetailBooking
    Created on : Nov 12, 2025, 5:40:52 PM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div id="bookingModal" class="fixed inset-0 z-50 hidden overflow-y-auto" aria-labelledby="modal-title" role="dialog" aria-modal="true">
    <div class="flex items-end justify-center min-h-screen px-4 pt-4 pb-20 text-center sm:block sm:p-0">
        <div class="fixed inset-0 transition-opacity bg-gray-500 bg-opacity-75" onclick="closeModal()"></div>

        <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>

        <div class="inline-block overflow-hidden text-left align-bottom transition-all transform bg-white rounded-lg shadow-xl sm:my-8 sm:align-middle sm:max-w-lg sm:w-full">
            <div class="px-4 pt-5 pb-4 bg-white sm:p-6 sm:pb-4">
                <div class="sm:flex sm:items-start">
                    <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left w-full">
                        <h3 class="text-lg font-medium leading-6 text-gray-900" id="modalTitle">Booking Details</h3>

                        <div class="mt-4 space-y-3 text-sm text-gray-600">
                            <div class="grid grid-cols-3 gap-2"><span class="font-semibold">Time:</span><span class="col-span-2" id="modalTime">...</span></div>
                            <div class="grid grid-cols-3 gap-2"><span class="font-semibold">Customer:</span><span class="col-span-2" id="modalCustomer">...</span></div>
                            <div class="grid grid-cols-3 gap-2"><span class="font-semibold">Phone:</span><span class="col-span-2" id="modalPhone">...</span></div>
                            <div class="grid grid-cols-3 gap-2"><span class="font-semibold">Pet:</span><span class="col-span-2" id="modalPet">...</span></div>
                            <div class="grid grid-cols-3 gap-2"><span class="font-semibold">Service:</span><span class="col-span-2" id="modalService">...</span></div>
                            <div class="grid grid-cols-3 gap-2"><span class="font-semibold">Price:</span><span class="col-span-2" id="modalPrice">...</span></div>
                            <div class="grid grid-cols-3 gap-2"><span class="font-semibold">Notes:</span><span class="col-span-2 italic" id="modalNotes">...</span></div>
                            <div class="grid grid-cols-3 gap-2"><span class="font-semibold">Status:</span><span class="col-span-2 font-bold" id="modalStatus">...</span></div>
                        </div>
                    </div>
                </div>
            </div>
            <input type="hidden" id="modalBookingId" value="" />

            <div class="px-4 py-3 bg-gray-50 sm:px-6 sm:flex sm:flex-row-reverse gap-2">
                <button type="button" onclick="closeModal()" class="w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 sm:mt-0 sm:w-auto sm:text-sm">
                    Đóng
                </button>

                <button id="btnConfirm" onclick="updateBookingStatus('CONFIRMED')" class="hidden w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-green-600 text-base font-medium text-white hover:bg-green-700 sm:w-auto sm:text-sm">
                    Confirm (Xác nhận)
                </button>

                <button id="btnStart" onclick="updateBookingStatus('IN_PROGRESS')" class="hidden w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-blue-600 text-base font-medium text-white hover:bg-blue-700 sm:w-auto sm:text-sm">
                    Start (Làm dịch vụ)
                </button>
                <button id="btnNoShow" onclick="updateBookingStatus('NO_SHOW')" class="hidden w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-red-800 text-base font-medium text-white hover:bg-red-900 sm:w-auto sm:text-sm">
                    No Show (Khách vắng)
                </button>

                <button id="btnComplete" onclick="updateBookingStatus('COMPLETED')" class="hidden w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-gray-800 text-base font-medium text-white hover:bg-gray-900 sm:w-auto sm:text-sm">
                    Complete (Hoàn tất)
                </button>

                <button id="btnCancel" onclick="updateBookingStatus('CANCELLED')" class="hidden w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-red-600 text-base font-medium text-white hover:bg-red-700 sm:w-auto sm:text-sm">
                    Cancel (Hủy)
                </button>
            </div>
        </div>
    </div>
</div>
