# SweetimalPetCare – Coding Backlog (Features Only)

Scope: Implementation tasks for application features only. Excludes tests, security hardening, CI/CD, and non-coding ops.

## 1) Tài khoản & Xác thực người dùng
- Đăng ký tài khoản
  - Controller: `RegisterServlet` – nhận form, validate dữ liệu cơ bản, tạo user nháp.
  - Service: tạo user, sinh OTP đăng ký, gửi email OTP (call Mail helper), lưu trạng thái.
  - DAO/Model: bảng User, trường trạng thái/OTP/expiry.
  - View (JSP): Form đăng ký, trang nhập OTP, trang thành công (`registerSuccessServlet`).
- Xác minh OTP đăng ký
  - Controller: `VerifyOTPRegisterServlet` – nhận OTP, kiểm tra hạn OTP, kích hoạt user.
  - Service/DAO: xác nhận OTP, cập nhật trạng thái user.
  - View: Trang nhập OTP + thông báo kết quả.
- Đăng nhập/Đăng xuất
  - Controller: `loginServlet`, `logoutServlet` – tạo/huỷ session, xử lý redirect.
  - Service/DAO: tìm user, kiểm tra mật khẩu.
  - View: Form login, trang sau đăng nhập.
- Quản lý tài khoản & hồ sơ
  - Controller: `accountSettingServlet`, `profileServlet`, `UploadImageServlet` – cập nhật thông tin, avatar.
  - Service/DAO: cập nhật profile, lưu đường dẫn ảnh.
  - View: Trang hồ sơ, form cập nhật.

## 2) Khôi phục mật khẩu
- Quên mật khẩu → OTP → Đặt lại
  - Controller: `ForgotPasswordServlet` (request OTP), `VerifyOTPServlet` (xác nhận), `ResetPasswordServlet` (đổi mật khẩu).
  - Service: sinh OTP, gửi mail, đặt lại mật khẩu.
  - DAO/Model: lưu OTP reset + hạn.
  - View: 3 trang tương ứng (yêu cầu OTP, xác nhận, đặt lại). 

## 3) Nội dung công khai & liên hệ
- Trang chủ, giới thiệu, tin tức
  - Controller: `homeServlet`, `aboutUsServlet`, `newsServlet` – render nội dung từ DB hoặc tĩnh.
  - View: JSP cho mỗi trang, component chung (header/footer/breadcrumbs).
- Liên hệ
  - Controller: `contactsServlet` (user gửi liên hệ).
  - Service/DAO: lưu Contact.
  - View: Form liên hệ, trang cảm ơn.

## 4) Sản phẩm & Cửa hàng
- Danh sách & chi tiết sản phẩm
  - Controller: `shopServlet`, `productServlet`, `ProductImageServlet` – danh sách, lọc, phân trang; tải ảnh.
  - Service/DAO: truy vấn sản phẩm, ảnh theo productId.
  - View: danh sách, chi tiết, gallery ảnh.
- Đánh giá sản phẩm
  - Controller: `productReviewServlet` – thêm/hiển thị review.
  - Service/DAO: lưu review; tính điểm trung bình.
  - View: form review, danh sách review.

## 5) Giỏ hàng, thanh toán, đơn hàng
- Giỏ hàng
  - Controller: `cartServlet` – thêm/xóa/cập nhật số lượng trong session.
  - View: Trang giỏ hàng.
- Thanh toán
  - Controller: `checkoutServlet` – xác nhận thông tin, tạo order.
  - Service/DAO: tạo Order + OrderItems, tính tổng.
  - View: Trang checkout + xác nhận thành công.
- Đơn hàng (khách)
  - Controller: `ordersServlet` – danh sách/chi tiết đơn hàng theo user.
  - View: Trang danh sách/chi tiết đơn hàng.

## 6) Dịch vụ & Đánh giá dịch vụ
- Danh sách dịch vụ, chi tiết
  - Controller: `serviceServlet` – hiển thị dịch vụ, phân trang/lọc.
  - Service/DAO: truy vấn dịch vụ, danh mục, gói.
  - View: Trang danh sách/chi tiết dịch vụ.
- Đánh giá dịch vụ
  - Controller: `ServiceReviewServlet` – thêm/hiển thị review dịch vụ.
  - Service/DAO: lưu và tổng hợp rating.
  - View: form review + danh sách review.

## 7) Pet Management (người dùng)
- CRUD thú cưng
  - Controller: `PetServlet` – tạo/sửa/xoá/list pets theo user.
  - Service/DAO: thực hiện CRUD, liên kết user.
  - View: Trang danh sách + form pet.

## 8) Booking & Lịch
- Đặt lịch dịch vụ
  - Controller: `bookingServlet`, `BookingAPIServlet` – form đặt lịch; API tạo booking.
  - Service/DAO: kiểm tra slot rảnh, lưu booking, trạng thái ban đầu.
  - View: Trang đặt lịch.
- Sinh lịch/slot
  - Controller: `GenerateScheduleServlet` – tạo gợi ý slot.
  - Service: logic sinh slot; DAO: truy vấn slot có sẵn.
- Quản lý booking của người dùng
  - Controller: `bookingHistoryServlet`, `CancelBookingServlet`, `MarkNoShowServlet` – hiển thị lịch sử, hủy, đánh dấu no-show.
  - View: Trang lịch sử, nút thao tác.
- Consultation Request
  - Controller: `ConsultationRequestServlet` – tạo yêu cầu tư vấn.
  - Service/DAO: lưu request, trạng thái.
  - View: Form yêu cầu tư vấn.

## 9) API tầng dữ liệu (JSON)
- Sản phẩm (API)
  - Controller: `ProductAPIServlet`, `ProductAddAPIServlet`, `ProductEditAPIServlet`, `ProductDetailAPIServlet`.
  - Service/DAO: CRUD + truy vấn; chuẩn JSON trả về với Gson.
- Dịch vụ (API)
  - Controller: `ServiceAPIServlet`, `ServiceEditAPIServlet`.
  - Service/DAO: CRUD + truy vấn.
- Booking (API)
  - Controller: `BookingAPIServlet`, `GenerateScheduleServlet`.
  - Service/DAO: tạo booking, sinh lịch.
- Chuẩn response JSON chung
  - Tạo wrapper `{ code, message, data }` tại tầng Controller; cấu hình Gson formatter (date/time).

## 10) Khu vực Quản trị (Admin)
- Dashboard
  - Controller: `admin/adminDashboardServlet` – tổng hợp KPI (doanh thu, số booking, sản phẩm bán chạy, tỉ lệ no-show).
  - Service/DAO: truy vấn tổng hợp.
  - View: Trang dashboard với widgets/charts (tối thiểu các chỉ số).
- Quản lý dịch vụ & gói
  - Controller: `admin/serviceServlet`, `admin/addServicePackagesServlet`, `admin/addServiceCateServlet`, `admin/searchService`.
  - Service/DAO: CRUD dịch vụ/gói/danh mục, tìm kiếm.
  - View: Trang list + form thêm/sửa.
- Quản lý sản phẩm
  - Controller: `admin/productServlet`.
  - API liên quan: `ProductAddAPIServlet`, `ProductEditAPIServlet`, `ProductDetailAPIServlet`.
  - Service/DAO: CRUD sản phẩm, cập nhật tồn kho.
  - View: Trang list + form thêm/sửa.
- Quản lý đơn hàng
  - Controller: `admin/orderServlet`, `admin/GetOrdersServlet`, `admin/GetOrderDetailsServlet`, `admin/UpdateOrderStatusServlet`.
  - Service/DAO: lấy danh sách/chi tiết, cập nhật trạng thái.
  - View: Trang list + chi tiết + nút đổi trạng thái.
- Quản lý booking (Admin)
  - Controller: `admin/bookingServlet`, `admin/GetBookingDetailServlet`, `admin/BookingDataServlet`, `admin/adminBookingStatusServlet`.
  - Service/DAO: tổng hợp booking theo trạng thái/ngày; lấy chi tiết.
  - View: Trang list + detail + export (nếu có UI export).
- Quản lý nhân sự
  - Controller: `admin/personnelServlet`, `admin/GetPersonalServlet`.
  - Service/DAO: CRUD nhân sự.
  - View: Trang list + form nhân sự.
- Quản lý liên hệ
  - Controller: `admin/contactServlet` (quản trị), `contactsServlet` (gửi từ người dùng).
  - Service/DAO: lưu, cập nhật trạng thái xử lý.
  - View: Trang quản trị liên hệ.
- Tư vấn & khám
  - Controller: `admin/ApproveConsultationRequestServlet`, `admin/DeleteConsultationRequestServlet`, `admin/VetVisitUpdateServlet`.
  - Service/DAO: duyệt/bỏ duyệt yêu cầu tư vấn, cập nhật thông tin thăm khám.
  - View: Trang danh sách + thao tác duyệt/cập nhật.

## 11) Ảnh & Upload
- Upload ảnh chung
  - Controller: `UploadImageServlet` – nhận file, lưu, trả về URL.
  - Service: xử lý tên file, lưu ổn định; DAO (nếu lưu metadata).
  - View: Tích hợp form upload vào trang hồ sơ/sản phẩm/dịch vụ.

## 12) Trang lỗi & Điều hướng cơ bản
- Điều hướng & thông báo
  - Tạo các trang thông báo thành công/thất bại cơ bản sau thao tác.
- Web.xml (fallback)
  - Đảm bảo mapping trong `src/main/webapp/WEB-INF/web.xml` cho các luồng OTP (nếu tắt annotation scan).

## 13) Phân trang & Bộ lọc (UI + Controller)
- Sản phẩm, dịch vụ, tin tức, booking admin
  - Controller: nhận `page`, `size`, `sort`, `filters`.
  - DAO: truy vấn có `LIMIT/OFFSET` tương ứng (SQL Server: `OFFSET/FETCH`).
  - View: phân trang và bộ lọc UI.

---
Gợi ý ưu tiên thực thi:
1. Hoàn thiện các luồng nền tảng: Đăng ký/Đăng nhập/Quên mật khẩu, Hồ sơ/Avatar.
2. Cửa hàng & Đơn hàng: Danh sách/Chi tiết, Giỏ hàng, Checkout, Orders.
3. Dịch vụ & Booking: Danh sách/Chi tiết, Đặt lịch, Lịch sử, Consultation.
4. Admin: Sản phẩm, Dịch vụ, Đơn hàng, Booking, Nhân sự, Liên hệ, Dashboard.
5. API JSON chuẩn hóa, phân trang/bộ lọc dùng chung, upload ảnh.
