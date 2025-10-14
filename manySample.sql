USE SweetimalPetCare;
GO

/* ==================== RESET DATA (SAFE SEED) ==================== */
-- Tắt ràng buộc để xóa sạch dữ liệu an toàn
EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL';

/* Xóa dữ liệu ở tất cả bảng dữ liệu nghiệp vụ (trừ các bảng mã tĩnh đã có sẵn trong schema) */
DELETE FROM AuditLog;
DELETE FROM Reviews;
DELETE FROM PrescriptionItem;
DELETE FROM Prescription;
DELETE FROM VaccinationRecord;
DELETE FROM MedicalRecord;
DELETE FROM Diagnosis;
DELETE FROM VetVisit;

DELETE FROM Invoice;
DELETE FROM Payments;
DELETE FROM Shipping;
DELETE FROM OrderStatusHistory;
DELETE FROM OrderItems;
DELETE FROM Orders;

DELETE FROM BookingStaffAssignment;
DELETE FROM ScheduleSlot;
DELETE FROM BookingStatusHistory;
DELETE FROM Booking;

DELETE FROM CartItem;

DELETE FROM InventoryTransaction;
DELETE FROM InventoryLocation;

DELETE FROM ProductVariant;
DELETE FROM Product;
DELETE FROM Brand;
DELETE FROM ProductCategory;

DELETE FROM PackageItem;
DELETE FROM ServicePackage;
DELETE FROM ServicePriceHistory;
DELETE FROM Services;
DELETE FROM ServiceCategory;

DELETE FROM Pets;
DELETE FROM PetBreed;
DELETE FROM PetSpecies;

DELETE FROM UserAddress;
DELETE FROM StaffProfile;
DELETE FROM Users;

DELETE FROM RolePermissions;
DELETE FROM Permissions;
DELETE FROM Roles;

/* Reset Identity (chỉ tác động bảng có identity) */
EXEC sp_MSforeachtable '
IF OBJECTPROPERTY(OBJECT_ID(''?''), ''TableHasIdentity'') = 1
    DBCC CHECKIDENT(''?'', RESEED, 0)
';

/* Bật lại ràng buộc */
EXEC sp_MSforeachtable 'ALTER TABLE ? CHECK CONSTRAINT ALL';
GO

/* ==================== ROLES & PERMISSIONS ==================== */
INSERT INTO Roles(role_name, description) VALUES
(N'Admin', N'Quản trị viên hệ thống'),
(N'Customer', N'Khách hàng'),
(N'Vet', N'Bác sĩ thú y'),
(N'Staff', N'Nhân viên');

INSERT INTO Permissions(permission_code, description) VALUES
('VIEW_PRODUCTS', N'Xem sản phẩm'),
('MANAGE_PRODUCTS', N'Quản lý sản phẩm'),
('VIEW_ORDERS', N'Xem đơn hàng'),
('MANAGE_ORDERS', N'Quản lý đơn hàng'),
('VIEW_BOOKING', N'Xem booking'),
('MANAGE_BOOKING', N'Quản lý booking'),
('VIEW_MEDICAL', N'Xem hồ sơ y tế'),
('MANAGE_MEDICAL', N'Quản lý hồ sơ y tế'),
('VIEW_INVENTORY', N'Xem kho'),
('MANAGE_INVENTORY', N'Quản lý kho'),
('VIEW_USERS', N'Xem người dùng'),
('MANAGE_USERS', N'Quản lý người dùng');

-- Admin có tất cả quyền
INSERT INTO RolePermissions(role_id, permission_id)
SELECT r.role_id, p.permission_id
FROM Roles r CROSS JOIN Permissions p
WHERE r.role_name = N'Admin';

-- Customer
INSERT INTO RolePermissions(role_id, permission_id)
SELECT r.role_id, p.permission_id
FROM Roles r
JOIN Permissions p ON p.permission_code IN ('VIEW_PRODUCTS','VIEW_ORDERS','VIEW_BOOKING')
WHERE r.role_name = N'Customer';

-- Vet
INSERT INTO RolePermissions(role_id, permission_id)
SELECT r.role_id, p.permission_id
FROM Roles r
JOIN Permissions p ON p.permission_code IN ('VIEW_PRODUCTS','VIEW_BOOKING','MANAGE_BOOKING','VIEW_MEDICAL','MANAGE_MEDICAL')
WHERE r.role_name = N'Vet';

-- Staff
INSERT INTO RolePermissions(role_id, permission_id)
SELECT r.role_id, p.permission_id
FROM Roles r
JOIN Permissions p ON p.permission_code IN ('VIEW_PRODUCTS','MANAGE_PRODUCTS','VIEW_ORDERS','MANAGE_ORDERS','VIEW_BOOKING','MANAGE_BOOKING','VIEW_INVENTORY','MANAGE_INVENTORY','VIEW_USERS')
WHERE r.role_name = N'Staff';

/* ==================== USERS (password: 123456 -> MD5 e10adc...) ==================== */
-- Helper: VARBINARY từ hex string (style 2)
-- CONVERT(VARBINARY(256), 'e10adc3949ba59abbe56e057f20f883e', 2)

-- Admins
INSERT INTO Users(username, email, phone, password_hash, full_name, gender, birthday, is_active, role_id)
SELECT 'admin1','admin1@example.com','0908000001', 'e10adc3949ba59abbe56e057f20f883e',
       N'Nguyễn Quản Trị', 1,'1985-06-15',1, role_id FROM Roles WHERE role_name=N'Admin';
INSERT INTO Users(username, email, phone, password_hash, full_name, gender, birthday, is_active, role_id)
SELECT 'admin2','admin2@example.com','0908000002', 'e10adc3949ba59abbe56e057f20f883e',
       N'Trần Quản Lý', 2,'1988-03-20',1, role_id FROM Roles WHERE role_name=N'Admin';

-- Staff
INSERT INTO Users(username, email, phone, password_hash, full_name, gender, birthday, is_active, role_id)
SELECT 'staff1','staff1@example.com','0909000001', 'e10adc3949ba59abbe56e057f20f883e',
       N'Lê Nhân Viên 1', 2,'1992-07-10',1, role_id FROM Roles WHERE role_name=N'Staff';
INSERT INTO Users(username, email, phone, password_hash, full_name, gender, birthday, is_active, role_id)
SELECT 'staff2','staff2@example.com','0909000002', 'e10adc3949ba59abbe56e057f20f883e',
       N'Phạm Nhân Viên 2', 1,'1994-09-22',1, role_id FROM Roles WHERE role_name=N'Staff';

-- Vets
INSERT INTO Users(username, email, phone, password_hash, full_name, gender, birthday, is_active, role_id)
SELECT 'vet1','vet1@example.com','0907000001', 'e10adc3949ba59abbe56e057f20f883e',
       N'Trần Bác Sĩ 1', 1,'1980-02-18',1, role_id FROM Roles WHERE role_name=N'Vet';
INSERT INTO Users(username, email, phone, password_hash, full_name, gender, birthday, is_active, role_id)
SELECT 'vet2','vet2@example.com','0907000002','e10adc3949ba59abbe56e057f20f883e',
       N'Nguyễn Bác Sĩ 2', 2,'1987-11-14',1, role_id FROM Roles WHERE role_name=N'Vet';

-- Customers
INSERT INTO Users(username, email, phone, password_hash, full_name, gender, birthday, is_active, role_id)
SELECT 'customer1','customer1@example.com','0911000001','e10adc3949ba59abbe56e057f20f883e',
       N'Nguyễn Khách 1', 1,'1995-05-10',1, role_id FROM Roles WHERE role_name=N'Customer';
INSERT INTO Users(username, email, phone, password_hash, full_name, gender, birthday, is_active, role_id)
SELECT 'customer2','customer2@example.com','0911000002', 'e10adc3949ba59abbe56e057f20f883e',
       N'Lê Khách 2', 2,'1993-10-05',1, role_id FROM Roles WHERE role_name=N'Customer';

-- StaffProfile
INSERT INTO StaffProfile(staff_id, position_title, specialty, license_number, hire_date, rating_average, is_veterinarian)
SELECT user_id, N'Groomer', N'Chăm sóc & Grooming', NULL, '2024-01-01', NULL, 0 FROM Users WHERE username='staff1';
INSERT INTO StaffProfile(staff_id, position_title, specialty, license_number, hire_date, rating_average, is_veterinarian)
SELECT user_id, N'Quản lý', N'Quản lý cửa hàng', NULL, '2023-06-01', NULL, 0 FROM Users WHERE username='staff2';
INSERT INTO StaffProfile(staff_id, position_title, specialty, license_number, hire_date, rating_average, is_veterinarian)
SELECT user_id, N'Bác sĩ thú y', N'Y học thú y tổng quát', 'VET123', '2022-09-15', 4.7, 1 FROM Users WHERE username='vet1';
INSERT INTO StaffProfile(staff_id, position_title, specialty, license_number, hire_date, rating_average, is_veterinarian)
SELECT user_id, N'Bác sĩ thú y', N'Vaccine & Nội khoa', 'VET456', '2021-03-20', 4.5, 1 FROM Users WHERE username='vet2';

/* ==================== ADDRESS ==================== */
INSERT INTO UserAddress(user_id,label,recipient_name,phone,address_line1,ward,district,city,province,is_default)
SELECT user_id, N'Nhà', full_name, phone, N'123 Đường A', N'Phường 1', N'Quận 1', N'Hồ Chí Minh', N'Hồ Chí Minh', 1
FROM Users WHERE username='customer1';

INSERT INTO UserAddress(user_id,label,recipient_name,phone,address_line1,ward,district,city,province,is_default)
SELECT user_id, N'Nhà', full_name, phone, N'456 Đường B', N'Phường 7', N'Quận 3', N'Hồ Chí Minh', N'Hồ Chí Minh', 1
FROM Users WHERE username='customer2';

/* ==================== PETS ==================== */
INSERT INTO PetSpecies(species_name, description) VALUES
(N'Chó',N'Canis lupus familiaris'),
(N'Mèo',N'Felis catus');

INSERT INTO PetBreed(species_id, breed_name, description)
SELECT species_id, N'Poodle', N'Chó xù thông minh' FROM PetSpecies WHERE species_name=N'Chó';
INSERT INTO PetBreed(species_id, breed_name, description)
SELECT species_id, N'Golden Retriever', N'Thân thiện, thông minh' FROM PetSpecies WHERE species_name=N'Chó';
INSERT INTO PetBreed(species_id, breed_name, description)
SELECT species_id, N'Anh lông ngắn', N'Mèo lông ngắn Anh' FROM PetSpecies WHERE species_name=N'Mèo';

-- Thú cưng của customer1
INSERT INTO Pets(owner_id,name,species_id,breed_id,gender,birthdate,weight_kg,color,notes)
SELECT (SELECT user_id FROM Users WHERE username='customer1'),
       N'Bông',
       (SELECT species_id FROM PetSpecies WHERE species_name=N'Chó'),
       (SELECT TOP 1 breed_id FROM PetBreed WHERE breed_name=N'Poodle'),
       'F','2022-05-01',5.2,N'Trắng',N'Thích chạy nhảy';

-- Thú cưng của customer2
INSERT INTO Pets(owner_id,name,species_id,breed_id,gender,birthdate,weight_kg,color,notes)
SELECT (SELECT user_id FROM Users WHERE username='customer2'),
       N'Lucky',
       (SELECT species_id FROM PetSpecies WHERE species_name=N'Chó'),
       (SELECT TOP 1 breed_id FROM PetBreed WHERE breed_name=N'Golden Retriever'),
       'M','2021-11-20',27.3,N'Vàng',N'Ngoan và thân thiện';
INSERT INTO Pets(owner_id,name,species_id,breed_id,gender,birthdate,weight_kg,color,notes)
SELECT (SELECT user_id FROM Users WHERE username='customer2'),
       N'Miu',
       (SELECT species_id FROM PetSpecies WHERE species_name=N'Mèo'),
       (SELECT TOP 1 breed_id FROM PetBreed WHERE breed_name=N'Anh lông ngắn'),
       'F','2023-02-10',3.6,N'Xám',N'Ít tiếng' ;

/* ==================== SERVICES ==================== */
INSERT INTO ServiceCategory(category_name, description) VALUES
(N'Grooming',N'Tắm, sấy, cắt tỉa'),
(N'Boarding',N'Lưu trú'),
(N'Health',N'Y tế');

-- Services
INSERT INTO Services(service_category_id, service_code, service_name, description, base_duration_min)
SELECT service_category_id,'GRM_BASIC',N'Grooming cơ bản',N'Tắm & sấy',60 FROM ServiceCategory WHERE category_name=N'Grooming';
INSERT INTO Services(service_category_id, service_code, service_name, description, base_duration_min)
SELECT service_category_id,'GRM_PREMIUM',N'Grooming cao cấp',N'Tắm, sấy, cắt tỉa',90 FROM ServiceCategory WHERE category_name=N'Grooming';

INSERT INTO Services(service_category_id, service_code, service_name, description, base_duration_min)
SELECT service_category_id,'HLT_CHECK',N'Khám tổng quát',N'Khám sức khỏe',30 FROM ServiceCategory WHERE category_name=N'Health';
INSERT INTO Services(service_category_id, service_code, service_name, description, base_duration_min)
SELECT service_category_id,'HLT_VACC',N'Tiêm phòng',N'Tiêm vaccine',20 FROM ServiceCategory WHERE category_name=N'Health';

-- Price history
INSERT INTO ServicePriceHistory(service_id,effective_from,price)
SELECT service_id,'2024-01-01',150000 FROM Services WHERE service_code='GRM_BASIC';
INSERT INTO ServicePriceHistory(service_id,effective_from,price)
SELECT service_id,'2024-01-01',250000 FROM Services WHERE service_code='GRM_PREMIUM';
INSERT INTO ServicePriceHistory(service_id,effective_from,price)
SELECT service_id,'2024-01-01',200000 FROM Services WHERE service_code='HLT_CHECK';
INSERT INTO ServicePriceHistory(service_id,effective_from,price)
SELECT service_id,'2024-01-01',250000 FROM Services WHERE service_code='HLT_VACC';

-- Packages
INSERT INTO ServicePackage(package_code, package_name, description, package_price)
VALUES ('PKG_GROOM3',N'Combo Groom 3 lần',N'3 lần grooming cơ bản',420000);

INSERT INTO PackageItem(package_id, service_id, quantity)
SELECT (SELECT package_id FROM ServicePackage WHERE package_code='PKG_GROOM3'),
       (SELECT service_id FROM Services WHERE service_code='GRM_BASIC'),3;

/* ==================== PRODUCTS & INVENTORY ==================== */
-- Categories
INSERT INTO ProductCategory(category_name, description) VALUES
(N'Thức ăn',N'Đồ ăn cho thú cưng'), (N'Phụ kiện',N'Phụ kiện cho thú cưng');

-- Brands
INSERT INTO Brand(brand_name, description) VALUES
(N'PetBrandA',N'Thương hiệu A'),(N'PetBrandB',N'Thương hiệu B');

-- Products
INSERT INTO Product(product_code,product_name,product_category_id,brand_id,description)
SELECT 'FD_DOG_A1',N'Hạt khô cho chó A1',
       (SELECT product_category_id FROM ProductCategory WHERE category_name=N'Thức ăn'),
       (SELECT brand_id FROM Brand WHERE brand_name=N'PetBrandA'),
       N'Hạt dinh dưỡng cho chó';

INSERT INTO Product(product_code,product_name,product_category_id,brand_id,description)
SELECT 'ACC_LEASH_B1',N'Dây dắt B1',
       (SELECT product_category_id FROM ProductCategory WHERE category_name=N'Phụ kiện'),
       (SELECT brand_id FROM Brand WHERE brand_name=N'PetBrandB'),
       N'Dây dắt bền, 5m';

-- Variants
INSERT INTO ProductVariant(product_id,sku,attribute_json,price,cost,stock_quantity,image_url)
SELECT p.product_id,'FD_DOG_A1_1KG','{"weight":"1kg"}',120000,80000,60,'https://example.com/fd_dog_a1_1kg.jpg'
FROM Product p WHERE p.product_code='FD_DOG_A1';

INSERT INTO ProductVariant(product_id,sku,attribute_json,price,cost,stock_quantity,image_url)
SELECT p.product_id,'FD_DOG_A1_5KG','{"weight":"5kg"}',480000,350000,30,'https://example.com/fd_dog_a1_5kg.jpg'
FROM Product p WHERE p.product_code='FD_DOG_A1';

INSERT INTO ProductVariant(product_id,sku,attribute_json,price,cost,stock_quantity,image_url)
SELECT p.product_id,'LEASH_B1_M_RED','{"size":"M","color":"Red"}',180000,120000,40,'https://example.com/leash_b1_m_red.jpg'
FROM Product p WHERE p.product_code='ACC_LEASH_B1';

-- Inventory locations
INSERT INTO InventoryLocation(location_code,name,address)
VALUES ('MAIN',N'Kho chính',N'123 Nguyễn Văn Linh, Q7, HCM'),
       ('STORE',N'Cửa hàng',N'456 Lê Lợi, Q1, HCM');

-- Initial stock in transactions (nhập kho theo tồn đầu)
INSERT INTO InventoryTransaction(variant_id, location_id, txn_type_code, quantity, reference_no, note)
SELECT variant_id, 1, 'PURCHASE', stock_quantity, 'INIT-2024', N'Nhập kho ban đầu'
FROM ProductVariant;

/* ==================== CART ITEMS ==================== */
INSERT INTO CartItem(customer_id, variant_id, quantity)
SELECT (SELECT user_id FROM Users WHERE username='customer1'),
       (SELECT variant_id FROM ProductVariant WHERE sku='FD_DOG_A1_1KG'), 2;

INSERT INTO CartItem(customer_id, variant_id, quantity)
SELECT (SELECT user_id FROM Users WHERE username='customer2'),
       (SELECT variant_id FROM ProductVariant WHERE sku='LEASH_B1_M_RED'), 1;

/* ==================== BOOKING ==================== */
-- Booking 1: customer1 đặt GRM_BASIC cho Bông (PENDING)
INSERT INTO Booking(customer_id,pet_id,service_id,booking_time,requested_date,requested_start,notes,current_status,total_price)
SELECT (SELECT user_id FROM Users WHERE username='customer1'),
       (SELECT pet_id FROM Pets WHERE name=N'Bông'),
       (SELECT service_id FROM Services WHERE service_code='GRM_BASIC'),
       SYSUTCDATETIME(),'2025-10-05','09:00',N'Vệ sinh tai kỹ','PENDING',150000;

-- Booking 2: customer2 đặt HLT_CHECK cho Lucky (CONFIRMED)
INSERT INTO Booking(customer_id,pet_id,service_id,booking_time,requested_date,requested_start,notes,current_status,total_price)
SELECT (SELECT user_id FROM Users WHERE username='customer2'),
       (SELECT pet_id FROM Pets WHERE name=N'Lucky'),
       (SELECT service_id FROM Services WHERE service_code='HLT_CHECK'),
       SYSUTCDATETIME(),'2025-10-06','14:00',N'Khám tổng quát định kỳ','CONFIRMED',200000;

-- Booking 3: customer2 đặt HLT_VACC cho Miu (COMPLETED)
INSERT INTO Booking(customer_id,pet_id,service_id,booking_time,requested_date,requested_start,notes,current_status,total_price)
SELECT (SELECT user_id FROM Users WHERE username='customer2'),
       (SELECT pet_id FROM Pets WHERE name=N'Miu'),
       (SELECT service_id FROM Services WHERE service_code='HLT_VACC'),
       DATEADD(DAY,-7,SYSUTCDATETIME()),DATEADD(DAY,-7,CAST(SYSUTCDATETIME() AS DATE)),'10:00',
       N'Tiêm 4in1','COMPLETED',250000;

-- Booking status history
INSERT INTO BookingStatusHistory(booking_id,status_code,changed_by,comment)
SELECT b.booking_id,'PENDING',b.customer_id,N'Đặt mới' FROM Booking b WHERE b.current_status='PENDING';

INSERT INTO BookingStatusHistory(booking_id,status_code,changed_by,comment)
SELECT b.booking_id,'CONFIRMED',(SELECT user_id FROM Users WHERE username='staff2'),N'Xác nhận lịch'
FROM Booking b WHERE b.current_status='CONFIRMED';

INSERT INTO BookingStatusHistory(booking_id,status_code,changed_by,comment)
SELECT b.booking_id,'COMPLETED',(SELECT user_id FROM Users WHERE username='vet1'),N'Đã hoàn tất'
FROM Booking b WHERE b.current_status='COMPLETED';

-- Schedule slot + assignment
-- For booking1 (PENDING -> BOOKED)
INSERT INTO ScheduleSlot(booking_id, staff_id, room_name, start_time, end_time, status)
SELECT b.booking_id,(SELECT user_id FROM Users WHERE username='staff1'),N'Groom-1',
       DATEADD(HOUR,9,CAST(b.requested_date AS DATETIME2)),
       DATEADD(MINUTE,(SELECT base_duration_min FROM Services s WHERE s.service_id=b.service_id),
               DATEADD(HOUR,9,CAST(b.requested_date AS DATETIME2))),
       'BOOKED'
FROM Booking b WHERE b.current_status='PENDING';

INSERT INTO BookingStaffAssignment(booking_id, staff_id, role_in_service)
SELECT b.booking_id,(SELECT user_id FROM Users WHERE username='staff1'),N'Groomer chính'
FROM Booking b WHERE b.current_status='PENDING';

-- For booking2 (CONFIRMED -> BOOKED) assign vet
INSERT INTO ScheduleSlot(booking_id, staff_id, room_name, start_time, end_time, status)
SELECT b.booking_id,(SELECT user_id FROM Users WHERE username='vet1'),N'Clinic-1',
       DATEADD(HOUR,14,CAST(b.requested_date AS DATETIME2)),
       DATEADD(MINUTE,(SELECT base_duration_min FROM Services s WHERE s.service_id=b.service_id),
               DATEADD(HOUR,14,CAST(b.requested_date AS DATETIME2))),
       'BOOKED'
FROM Booking b WHERE b.current_status='CONFIRMED';

INSERT INTO BookingStaffAssignment(booking_id, staff_id, role_in_service)
SELECT b.booking_id,(SELECT user_id FROM Users WHERE username='vet1'),N'Bác sĩ chính'
FROM Booking b WHERE b.current_status='CONFIRMED';

/* ==================== ORDERS ==================== */
-- Order 1 (customer1) từ giỏ hàng
INSERT INTO Orders(order_code, customer_id, shipping_address_id, order_status, subtotal_amount, discount_amount, shipping_fee, tax_amount, total_amount)
SELECT 'ORD1001',
       (SELECT user_id FROM Users WHERE username='customer1'),
       (SELECT address_id FROM UserAddress WHERE user_id=(SELECT user_id FROM Users WHERE username='customer1') AND is_default=1),
       'PENDING', 120000*2, 0, 30000, 0, 120000*2+30000;

-- Items (trigger sẽ tự ghi giao dịch kho SALE và trừ tồn)
INSERT INTO OrderItems(order_id, variant_id, unit_price, quantity)
SELECT (SELECT order_id FROM Orders WHERE order_code='ORD1001'),
       (SELECT variant_id FROM ProductVariant WHERE sku='FD_DOG_A1_1KG'),
       120000, 2;

-- Update trạng thái + lịch sử
UPDATE Orders SET order_status='PAID', updated_at=SYSUTCDATETIME() WHERE order_code='ORD1001';
INSERT INTO OrderStatusHistory(order_id, status_code, changed_by, note)
SELECT order_id,'PENDING',(SELECT user_id FROM Users WHERE username='customer1'),N'Đặt mới' FROM Orders WHERE order_code='ORD1001';
INSERT INTO OrderStatusHistory(order_id, status_code, changed_by, note)
SELECT order_id,'PAID',(SELECT user_id FROM Users WHERE username='customer1'),N'Đã thanh toán' FROM Orders WHERE order_code='ORD1001';

-- Payment + Invoice + Shipping
INSERT INTO Payments(order_id,payment_method_code,amount,status,transaction_ref,paid_at)
SELECT order_id,'CASH', (SELECT total_amount FROM Orders WHERE order_code='ORD1001'), 'SUCCESS','TXN-1001', SYSUTCDATETIME()
FROM Orders WHERE order_code='ORD1001';

INSERT INTO Invoice(invoice_code, order_id, issue_date, total_amount, tax_amount, note)
SELECT 'INV1001', order_id, SYSUTCDATETIME(), total_amount, 0, N'Hóa đơn bán hàng'
FROM Orders WHERE order_code='ORD1001';

INSERT INTO Shipping(order_id, carrier_name, tracking_number, shipped_at, delivered_at, status, note)
SELECT order_id, N'GHN', 'GHN-TRACK-1001', DATEADD(HOUR,-2,SYSUTCDATETIME()), NULL, 'SHIPPED', N'Đang giao'
FROM Orders WHERE order_code='ORD1001';

-- Order 2 (customer2) mua dây dắt
INSERT INTO Orders(order_code, customer_id, shipping_address_id, order_status, subtotal_amount, discount_amount, shipping_fee, tax_amount, total_amount)
SELECT 'ORD1002',
       (SELECT user_id FROM Users WHERE username='customer2'),
       (SELECT address_id FROM UserAddress WHERE user_id=(SELECT user_id FROM Users WHERE username='customer2') AND is_default=1),
       'PENDING', 180000, 0, 30000, 0, 210000;

INSERT INTO OrderItems(order_id, variant_id, unit_price, quantity)
SELECT (SELECT order_id FROM Orders WHERE order_code='ORD1002'),
       (SELECT variant_id FROM ProductVariant WHERE sku='LEASH_B1_M_RED'),
       180000, 1;

UPDATE Orders SET order_status='COMPLETED', updated_at=SYSUTCDATETIME() WHERE order_code='ORD1002';
INSERT INTO OrderStatusHistory(order_id, status_code, changed_by, note)
SELECT order_id,'PENDING',(SELECT user_id FROM Users WHERE username='customer2'),N'Đặt mới' FROM Orders WHERE order_code='ORD1002';
INSERT INTO OrderStatusHistory(order_id, status_code, changed_by, note)
SELECT order_id,'PAID',(SELECT user_id FROM Users WHERE username='customer2'),N'Đã thanh toán' FROM Orders WHERE order_code='ORD1002';
INSERT INTO OrderStatusHistory(order_id, status_code, changed_by, note)
SELECT order_id,'COMPLETED',(SELECT user_id FROM Users WHERE username='staff2'),N'Hoàn tất đơn' FROM Orders WHERE order_code='ORD1002';

INSERT INTO Payments(order_id,payment_method_code,amount,status,transaction_ref,paid_at)
SELECT order_id,'EWALLET', (SELECT total_amount FROM Orders WHERE order_code='ORD1002'), 'SUCCESS','TXN-1002', SYSUTCDATETIME()
FROM Orders WHERE order_code='ORD1002';

INSERT INTO Invoice(invoice_code, order_id, issue_date, total_amount, tax_amount, note)
SELECT 'INV1002', order_id, SYSUTCDATETIME(), total_amount, 0, N'Hóa đơn bán hàng'
FROM Orders WHERE order_code='ORD1002';

INSERT INTO Shipping(order_id, carrier_name, tracking_number, shipped_at, delivered_at, status, note)
SELECT order_id, N'VNPost', 'VN-TRACK-2002', DATEADD(DAY,-1,SYSUTCDATETIME()), SYSUTCDATETIME(), 'DELIVERED', N'Giao thành công'
FROM Orders WHERE order_code='ORD1002';

/* ==================== VET VISITS & MEDICAL ==================== */
-- Visit từ booking2 (CONFIRMED) cho Lucky
INSERT INTO VetVisit(booking_id, pet_id, owner_id, vet_staff_id, visit_type_code, visit_date, weight_kg, temperature_c, symptoms, notes)
SELECT b.booking_id,
       b.pet_id,
       b.customer_id,
       (SELECT user_id FROM Users WHERE username='vet1'),
       'CHECKUP',
       DATEADD(HOUR,14,CAST(b.requested_date AS DATETIME2)),
       27.5, 38.6, N'Khám định kỳ', N'Không phát hiện bất thường'
FROM Booking b WHERE b.current_status='CONFIRMED';

-- Visit vaccine từ booking3 (COMPLETED) cho Miu
INSERT INTO VetVisit(booking_id, pet_id, owner_id, vet_staff_id, visit_type_code, visit_date, weight_kg, temperature_c, symptoms, notes)
SELECT b.booking_id,
       b.pet_id,
       b.customer_id,
       (SELECT user_id FROM Users WHERE username='vet2'),
       'VACCINE',
       DATEADD(HOUR,10,CAST(b.requested_date AS DATETIME2)),
       3.7, 38.4, N'Tiêm vaccine', N'Ổn định sau tiêm'
FROM Booking b WHERE b.current_status='COMPLETED';

-- Diagnosis cho CHECKUP
INSERT INTO Diagnosis(visit_id, diagnosis_code, description, severity)
SELECT v.visit_id, 'NORMAL', N'Sức khỏe bình thường', 1
FROM VetVisit v WHERE v.visit_type_code='CHECKUP';

-- Medical record
INSERT INTO MedicalRecord(pet_id, visit_id, summary, follow_up_date)
SELECT v.pet_id, v.visit_id, N'Khuyến nghị vận động hàng ngày', DATEADD(MONTH,6,CAST(v.visit_date AS DATE))
FROM VetVisit v WHERE v.visit_type_code='CHECKUP';

-- Vaccine record
INSERT INTO VaccinationRecord(visit_id, vaccine_name, batch_number, administered_at, next_due_date)
SELECT v.visit_id, N'4in1 Fel-O-Vax', N'BATCH-4IN1-2409', v.visit_date, DATEADD(MONTH,12,CAST(v.visit_date AS DATE))
FROM VetVisit v WHERE v.visit_type_code='VACCINE';

-- Prescription (ví dụ checkup không cần thuốc, vaccine có paracetamol thú y 3 ngày)
INSERT INTO Prescription(visit_id, instructions)
SELECT visit_id, N'Không cần thuốc' FROM VetVisit WHERE visit_type_code='CHECKUP';

INSERT INTO Prescription(visit_id, instructions)
SELECT visit_id, N'Giảm đau nhẹ sau tiêm, uống sau ăn' FROM VetVisit WHERE visit_type_code='VACCINE';

-- Prescription items (thuốc tự do)
INSERT INTO PrescriptionItem(prescription_id, medicine_name, dosage, frequency, duration_days)
SELECT pr.prescription_id, N'Paracetamol thú y 120mg', N'1/2 viên', N'2 lần/ngày', 3
FROM Prescription pr
JOIN VetVisit v ON v.visit_id = pr.visit_id
WHERE v.visit_type_code='VACCINE';

/* ==================== REVIEWS ==================== */
-- Review dịch vụ GRM_BASIC
INSERT INTO Reviews(target_type_code, target_id, customer_id, rating, comment)
SELECT 'SERVICE',
       (SELECT service_id FROM Services WHERE service_code='GRM_BASIC'),
       (SELECT user_id FROM Users WHERE username='customer1'),
       5, N'Groom rất sạch sẽ, nhân viên thân thiện';

-- Review sản phẩm FD_DOG_A1
INSERT INTO Reviews(target_type_code, target_id, customer_id, rating, comment)
SELECT 'PRODUCT',
       (SELECT product_id FROM Product WHERE product_code='FD_DOG_A1'),
       (SELECT user_id FROM Users WHERE username='customer1'),
       4, N'Hạt ăn hợp, lông bóng mượt';

-- Review lần khám (visit CHECKUP)
INSERT INTO Reviews(target_type_code, target_id, customer_id, rating, comment)
SELECT 'VET_VISIT',
       v.visit_id,
       v.owner_id,
       5, N'Bác sĩ tư vấn kỹ, rất yên tâm'
FROM VetVisit v WHERE v.visit_type_code='CHECKUP';

/* ==================== AUDIT LOG (sample) ==================== */
INSERT INTO AuditLog(user_id, action_code, entity_name, entity_id, detail_json)
SELECT (SELECT user_id FROM Users WHERE username='admin1'),'USER_CREATE','Users',
       CAST((SELECT user_id FROM Users WHERE username='customer1') AS NVARCHAR(50)),
       N'{"by":"admin1","target":"customer1"}';

INSERT INTO AuditLog(user_id, action_code, entity_name, entity_id, detail_json)
SELECT (SELECT user_id FROM Users WHERE username='staff2'),'ORDER_UPDATE','Orders',
       CAST((SELECT order_id FROM Orders WHERE order_code='ORD1002') AS NVARCHAR(50)),
       N'{"status":"COMPLETED"}';

/* ==================== FINISH ==================== */
-- Đánh dấu vài slot đã DONE sau khi hoàn tất
UPDATE ScheduleSlot SET status='DONE'
WHERE booking_id IN (SELECT booking_id FROM Booking WHERE current_status IN ('COMPLETED'));

-- Tạo thanh toán trực tiếp cho booking1 (khách trả tại quầy)
INSERT INTO Payments(order_id, booking_id, payment_method_code, amount, status, transaction_ref, paid_at)
SELECT NULL,
       (SELECT booking_id FROM Booking WHERE current_status='PENDING'),
       'CASH', 150000, 'SUCCESS','BKG-PAY-0001', SYSUTCDATETIME();

-- Lập hóa đơn cho lần thanh toán booking1
INSERT INTO Invoice(invoice_code, booking_id, total_amount, tax_amount, note)
SELECT 'INV-BKG-1001',
       (SELECT booking_id FROM Booking WHERE current_status='PENDING'),
       150000, 0, N'Hóa đơn dịch vụ grooming';

GO


/* ======================================================================= */
/* ==================== BỔ SUNG DỮ LIỆU ẢO SỐ LƯỢNG LỚN ================== */
/* ======================================================================= */

USE SweetimalPetCare;
GO

/* -------- Thêm thêm khách hàng và địa chỉ -------- */
-- Customers 3..10
INSERT INTO Users(username, email, phone, password_hash, full_name, gender, birthday, is_active, role_id)
SELECT v.username, v.email, v.phone, 'e10adc3949ba59abbe56e057f20f883e', v.full_name, v.gender, v.birthday, 1, r.role_id
FROM (VALUES
('customer3','customer3@example.com','0911000003',N'Phạm Khách 3',1,CAST('1996-01-12' AS DATE)),
('customer4','customer4@example.com','0911000004',N'Trương Khách 4',2,CAST('1992-08-23' AS DATE)),
('customer5','customer5@example.com','0911000005',N'Vũ Khách 5',1,CAST('1990-12-02' AS DATE)),
('customer6','customer6@example.com','0911000006',N'Đỗ Khách 6',2,CAST('1998-04-30' AS DATE)),
('customer7','customer7@example.com','0911000007',N'Bùi Khách 7',1,CAST('1997-03-18' AS DATE)),
('customer8','customer8@example.com','0911000008',N'Hoàng Khách 8',2,CAST('1991-09-09' AS DATE)),
('customer9','customer9@example.com','0911000009',N'Đặng Khách 9',1,CAST('1993-06-06' AS DATE)),
('customer10','customer10@example.com','0911000010',N'Ngô Khách 10',2,CAST('1994-11-11' AS DATE))
) AS v(username,email,phone,full_name,gender,birthday)
CROSS JOIN (SELECT role_id FROM Roles WHERE role_name=N'Customer') r;

-- Addresses for new customers
INSERT INTO UserAddress(user_id,label,recipient_name,phone,address_line1,ward,district,city,province,is_default)
SELECT u.user_id, N'Nhà', u.full_name, u.phone, N'789 Đường C', N'Phường 5', N'Quận 5', N'Hồ Chí Minh', N'Hồ Chí Minh', 1
FROM Users u WHERE u.username IN ('customer3','customer4','customer5','customer6','customer7','customer8','customer9','customer10');

/* -------- Thêm thêm thú cưng cho các khách mới -------- */
INSERT INTO Pets(owner_id,name,species_id,breed_id,gender,birthdate,weight_kg,color,notes)
SELECT (SELECT user_id FROM Users WHERE username='customer3'),
       N'Mướp',
       (SELECT species_id FROM PetSpecies WHERE species_name=N'Mèo'),
       (SELECT TOP 1 breed_id FROM PetBreed WHERE breed_name=N'Anh lông ngắn'),
       'F','2023-05-05',3.2,N'Vàng mướp',N'Hiền lành';

INSERT INTO Pets(owner_id,name,species_id,breed_id,gender,birthdate,weight_kg,color,notes)
SELECT (SELECT user_id FROM Users WHERE username='customer3'),
       N'Max',
       (SELECT species_id FROM PetSpecies WHERE species_name=N'Chó'),
       (SELECT TOP 1 breed_id FROM PetBreed WHERE breed_name=N'Poodle'),
       'M','2021-08-20',6.8,N'Nâu',N'Rất năng động';

INSERT INTO Pets(owner_id,name,species_id,breed_id,gender,birthdate,weight_kg,color,notes)
SELECT (SELECT user_id FROM Users WHERE username='customer4'),
       N'Rex',
       (SELECT species_id FROM PetSpecies WHERE species_name=N'Chó'),
       (SELECT TOP 1 breed_id FROM PetBreed WHERE breed_name=N'Golden Retriever'),
       'M','2020-10-10',30.5,N'Vàng',N'Thân thiện';

INSERT INTO Pets(owner_id,name,species_id,breed_id,gender,birthdate,weight_kg,color,notes)
SELECT (SELECT user_id FROM Users WHERE username='customer5'),
       N'MiMi',
       (SELECT species_id FROM PetSpecies WHERE species_name=N'Mèo'),
       (SELECT TOP 1 breed_id FROM PetBreed WHERE breed_name=N'Anh lông ngắn'),
       'F','2022-01-15',3.0,N'Trắng',N'Ít rụng lông';

INSERT INTO Pets(owner_id,name,species_id,breed_id,gender,birthdate,weight_kg,color,notes)
SELECT (SELECT user_id FROM Users WHERE username='customer6'),
       N'Đốm',
       (SELECT species_id FROM PetSpecies WHERE species_name=N'Chó'),
       (SELECT TOP 1 breed_id FROM PetBreed WHERE breed_name=N'Poodle'),
       'M','2024-02-01',4.0,N'Trắng đốm đen',N'Tò mò';

INSERT INTO Pets(owner_id,name,species_id,breed_id,gender,birthdate,weight_kg,color,notes)
SELECT (SELECT user_id FROM Users WHERE username='customer7'),
       N'Cam',
       (SELECT species_id FROM PetSpecies WHERE species_name=N'Mèo'),
       (SELECT TOP 1 breed_id FROM PetBreed WHERE breed_name=N'Anh lông ngắn'),
       'F','2023-07-07',2.8,N'Cam',N'Ăn khỏe';

INSERT INTO Pets(owner_id,name,species_id,breed_id,gender,birthdate,weight_kg,color,notes)
SELECT (SELECT user_id FROM Users WHERE username='customer8'),
       N'KiKi',
       (SELECT species_id FROM PetSpecies WHERE species_name=N'Chó'),
       (SELECT TOP 1 breed_id FROM PetBreed WHERE breed_name=N'Poodle'),
       'F','2022-03-03',5.5,N'Đen',N'Vâng lời';

INSERT INTO Pets(owner_id,name,species_id,breed_id,gender,birthdate,weight_kg,color,notes)
SELECT (SELECT user_id FROM Users WHERE username='customer9'),
       N'BíNgô',
       (SELECT species_id FROM PetSpecies WHERE species_name=N'Chó'),
       (SELECT TOP 1 breed_id FROM PetBreed WHERE breed_name=N'Golden Retriever'),
       'M','2021-01-21',29.0,N'Vàng',N'Ngoan';

INSERT INTO Pets(owner_id,name,species_id,breed_id,gender,birthdate,weight_kg,color,notes)
SELECT (SELECT user_id FROM Users WHERE username='customer10'),
       N'Snow',
       (SELECT species_id FROM PetSpecies WHERE species_name=N'Mèo'),
       (SELECT TOP 1 breed_id FROM PetBreed WHERE breed_name=N'Anh lông ngắn'),
       'F','2022-12-12',3.4,N'Trắng',N'Hiền';

/* -------- Thêm 40 booking + lịch sử + lịch + phân công -------- */
DECLARE @staff1 INT = (SELECT user_id FROM Users WHERE username='staff1');
DECLARE @staff2 INT = (SELECT user_id FROM Users WHERE username='staff2');
DECLARE @vet1   INT = (SELECT user_id FROM Users WHERE username='vet1');
DECLARE @vet2   INT = (SELECT user_id FROM Users WHERE username='vet2');

-- Danh sách booking cần thêm (ít nhất 40)
DECLARE @NewBookingRows TABLE(
  username        VARCHAR(50),
  pet_name        NVARCHAR(100),
  service_code    VARCHAR(20),
  req_date        DATE,
  req_start       CHAR(5),
  status          VARCHAR(20),
  note            NVARCHAR(255),
  price           INT
);

INSERT INTO @NewBookingRows(username,pet_name,service_code,req_date,req_start,status,note,price)
VALUES
-- customer1
('customer1',N'Bông','GRM_BASIC','2025-10-08','09:00','CONFIRMED',N'Groom định kỳ',150000),
('customer1',N'Bông','GRM_PREMIUM','2025-10-15','10:30','PENDING',N'Cắt tỉa toàn thân',250000),
('customer1',N'Bông','HLT_CHECK','2025-10-18','14:00','PENDING',N'Kiểm tra sau tiêm',200000),
('customer1',N'Bông','HLT_VACC','2025-10-03','09:30','COMPLETED',N'Nhắc tiêm vaccine',250000),

-- customer2
('customer2',N'Lucky','GRM_PREMIUM','2025-10-07','15:00','COMPLETED',N'Tắm sấy cắt tỉa',250000),
('customer2',N'Lucky','HLT_CHECK','2025-10-12','11:00','CONFIRMED',N'Khám sau vận động',200000),
('customer2',N'Miu','GRM_BASIC','2025-10-09','10:00','PENDING',N'Tắm khử mùi',150000),
('customer2',N'Miu','HLT_VACC','2025-10-13','09:30','CONFIRMED',N'Tiêm nhắc',250000),

-- customer3
('customer3',N'Mướp','GRM_BASIC','2025-10-05','11:00','COMPLETED',N'Tắm làm sạch',150000),
('customer3',N'Max','GRM_PREMIUM','2025-10-16','16:00','PENDING',N'Cắt tỉa tạo kiểu',250000),
('customer3',N'Max','HLT_CHECK','2025-10-10','14:30','CONFIRMED',N'Khám tổng quát',200000),
('customer3',N'Mướp','HLT_VACC','2025-10-02','09:00','COMPLETED',N'Tiêm phòng dại',250000),

-- customer4
('customer4',N'Rex','GRM_BASIC','2025-10-04','09:00','COMPLETED',N'Tắm khử mùi',150000),
('customer4',N'Rex','HLT_CHECK','2025-10-11','15:00','CONFIRMED',N'Kiểm tra khớp',200000),
('customer4',N'Rex','HLT_VACC','2025-10-19','10:00','PENDING',N'Nhắc tiêm 7 bệnh',250000),

-- customer5
('customer5',N'MiMi','GRM_BASIC','2025-10-06','10:00','CONFIRMED',N'Spa mèo',150000),
('customer5',N'MiMi','HLT_CHECK','2025-10-14','13:30','PENDING',N'Kiểm tra mắt',200000),
('customer5',N'MiMi','HLT_VACC','2025-10-01','09:00','COMPLETED',N'Tiêm mũi 2',250000),

-- customer6
('customer6',N'Đốm','GRM_PREMIUM','2025-10-08','15:30','CONFIRMED',N'Cắt tỉa lông mặt',250000),
('customer6',N'Đốm','HLT_CHECK','2025-10-17','09:00','PENDING',N'Khám tiêu hóa',200000),
('customer6',N'Đốm','HLT_VACC','2025-10-05','10:00','COMPLETED',N'Vaccine 5in1',250000),

-- customer7
('customer7',N'Cam','GRM_BASIC','2025-10-09','09:30','PENDING',N'Tắm sấy nhanh',150000),
('customer7',N'Cam','HLT_CHECK','2025-10-15','11:00','CONFIRMED',N'Khám đường hô hấp',200000),
('customer7',N'Cam','HLT_VACC','2025-10-07','08:30','COMPLETED',N'Vaccine dại',250000),

-- customer8
('customer8',N'KiKi','GRM_PREMIUM','2025-10-12','16:00','CONFIRMED',N'Groom tạo kiểu',250000),
('customer8',N'KiKi','HLT_CHECK','2025-10-20','10:00','PENDING',N'Khám da liễu',200000),
('customer8',N'KiKi','HLT_VACC','2025-10-06','09:00','COMPLETED',N'Nhắc vaccine',250000),

-- customer9
('customer9',N'BíNgô','GRM_BASIC','2025-10-10','10:30','CONFIRMED',N'Tắm khử mùi',150000),
('customer9',N'BíNgô','GRM_PREMIUM','2025-10-18','14:00','PENDING',N'Cắt tỉa toàn thân',250000),
('customer9',N'BíNgô','HLT_CHECK','2025-10-03','15:00','COMPLETED',N'Khám dinh dưỡng',200000),

-- customer10
('customer10',N'Snow','GRM_BASIC','2025-10-11','09:00','CONFIRMED',N'Tắm mèo nhẹ nhàng',150000),
('customer10',N'Snow','HLT_CHECK','2025-10-16','13:00','PENDING',N'Khám răng miệng',200000),
('customer10',N'Snow','HLT_VACC','2025-10-04','10:00','COMPLETED',N'Vaccine mũi nhắc',250000),

-- Bổ sung thêm để đạt >= 40
('customer1',N'Bông','GRM_BASIC','2025-10-19','09:00','PENDING',N'Groom dọn lông rụng',150000),
('customer2',N'Lucky','GRM_BASIC','2025-10-14','10:00','CONFIRMED',N'Tắm dịp lễ',150000),
('customer3',N'Max','GRM_BASIC','2025-10-13','09:00','PENDING',N'Tắm sau chơi bẩn',150000),
('customer4',N'Rex','GRM_PREMIUM','2025-10-02','16:00','COMPLETED',N'Groom chuẩn bị thi show',250000),
('customer5',N'MiMi','GRM_PREMIUM','2025-10-17','15:00','PENDING',N'Cắt tỉa lông dài',250000),
('customer6',N'Đốm','GRM_BASIC','2025-10-09','11:00','CONFIRMED',N'Tắm khử mùi',150000),
('customer7',N'Cam','GRM_PREMIUM','2025-10-12','10:00','CONFIRMED',N'Spa toàn diện',250000),
('customer8',N'KiKi','GRM_BASIC','2025-10-07','09:00','COMPLETED',N'Tắm nhanh',150000)
;

-- Chèn booking và lưu các booking_id vừa thêm
DECLARE @InsertedBookings TABLE(
  booking_id      INT,
  customer_id     INT,
  pet_id          INT,
  service_id      INT,
  requested_date  DATE,
  requested_start CHAR(5),
  current_status  VARCHAR(20)
);

INSERT INTO Booking(customer_id,pet_id,service_id,booking_time,requested_date,requested_start,notes,current_status,total_price)
OUTPUT inserted.booking_id, inserted.customer_id, inserted.pet_id, inserted.service_id, inserted.requested_date, inserted.requested_start, inserted.current_status
SELECT u.user_id, p.pet_id, s.service_id, SYSUTCDATETIME(), n.req_date, n.req_start, n.note, n.status, n.price
FROM @NewBookingRows n
JOIN Users u ON u.username = n.username
JOIN Pets p ON p.name = n.pet_name AND p.owner_id = u.user_id
JOIN Services s ON s.service_code = n.service_code;

-- Lịch sử trạng thái
-- PENDING
INSERT INTO BookingStatusHistory(booking_id,status_code,changed_by,comment)
SELECT b.booking_id, 'PENDING', b.customer_id, N'Đặt mới'
FROM @InsertedBookings ib
JOIN Booking b ON b.booking_id = ib.booking_id;

-- CONFIRMED
INSERT INTO BookingStatusHistory(booking_id,status_code,changed_by,comment)
SELECT b.booking_id, 'CONFIRMED',
       CASE WHEN s.service_code LIKE 'GRM%' THEN @staff2 ELSE @vet1 END,
       N'Xác nhận lịch'
FROM @InsertedBookings ib
JOIN Booking b ON b.booking_id = ib.booking_id
JOIN Services s ON s.service_id = ib.service_id
WHERE ib.current_status IN ('CONFIRMED','COMPLETED');

-- COMPLETED
INSERT INTO BookingStatusHistory(booking_id,status_code,changed_by,comment)
SELECT b.booking_id, 'COMPLETED',
       CASE WHEN s.service_code LIKE 'GRM%' THEN @staff1 ELSE @vet2 END,
       N'Đã hoàn tất'
FROM @InsertedBookings ib
JOIN Booking b ON b.booking_id = ib.booking_id
JOIN Services s ON s.service_id = ib.service_id
WHERE ib.current_status = 'COMPLETED';

-- Tạo slot lịch BOOKED theo requested_date + requested_start
INSERT INTO ScheduleSlot(booking_id, staff_id, room_name, start_time, end_time, status)
SELECT b.booking_id,
       CASE WHEN s.service_code LIKE 'GRM%' THEN @staff1 ELSE @vet1 END AS staff_id,
       CASE WHEN s.service_code LIKE 'GRM%' THEN N'Groom-1' ELSE N'Clinic-1' END AS room_name,
       CAST(CONCAT(CONVERT(VARCHAR(10), ib.requested_date, 23), ' ', ib.requested_start) AS DATETIME2) AS start_time,
       DATEADD(MINUTE, s.base_duration_min,
               CAST(CONCAT(CONVERT(VARCHAR(10), ib.requested_date, 23), ' ', ib.requested_start) AS DATETIME2)) AS end_time,
       'BOOKED'
FROM @InsertedBookings ib
JOIN Booking b ON b.booking_id = ib.booking_id
JOIN Services s ON s.service_id = ib.service_id;

-- Phân công nhân sự
INSERT INTO BookingStaffAssignment(booking_id, staff_id, role_in_service)
SELECT b.booking_id,
       CASE WHEN s.service_code LIKE 'GRM%' THEN @staff1 ELSE @vet1 END,
       CASE WHEN s.service_code LIKE 'GRM%' THEN N'Groomer chính' ELSE N'Bác sĩ chính' END
FROM @InsertedBookings ib
JOIN Booking b ON b.booking_id = ib.booking_id
JOIN Services s ON s.service_id = ib.service_id;

-- Tạo hồ sơ khám cho các booking y tế đã COMPLETED
-- VetVisit
INSERT INTO VetVisit(booking_id, pet_id, owner_id, vet_staff_id, visit_type_code, visit_date, weight_kg, temperature_c, symptoms, notes)
SELECT b.booking_id, b.pet_id, b.customer_id,
       CASE WHEN s.service_code='HLT_VACC' THEN @vet2 ELSE @vet1 END,
       CASE WHEN s.service_code='HLT_VACC' THEN 'VACCINE' ELSE 'CHECKUP' END,
       ss.start_time,
       CASE WHEN s.service_code='HLT_VACC' THEN 3.5 ELSE 6.0 END, -- số liệu mẫu
       CASE WHEN s.service_code='HLT_VACC' THEN 38.4 ELSE 38.6 END,
       CASE WHEN s.service_code='HLT_VACC' THEN N'Tiêm vaccine' ELSE N'Khám tổng quát' END,
       CASE WHEN s.service_code='HLT_VACC' THEN N'Ổn định sau tiêm' ELSE N'Không bất thường' END
FROM @InsertedBookings ib
JOIN Booking b ON b.booking_id = ib.booking_id
JOIN Services s ON s.service_id = ib.service_id
JOIN ScheduleSlot ss ON ss.booking_id = b.booking_id
WHERE ib.current_status = 'COMPLETED' AND s.service_code LIKE 'HLT_%';

-- Diagnosis cho CHECKUP
INSERT INTO Diagnosis(visit_id, diagnosis_code, description, severity)
SELECT v.visit_id, 'NORMAL', N'Sức khỏe bình thường', 1
FROM VetVisit v
JOIN Booking b ON b.booking_id = v.booking_id
JOIN Services s ON s.service_id = b.service_id
WHERE v.visit_type_code='CHECKUP' AND b.booking_id IN (SELECT booking_id FROM @InsertedBookings);

-- MedicalRecord cho CHECKUP
INSERT INTO MedicalRecord(pet_id, visit_id, summary, follow_up_date)
SELECT v.pet_id, v.visit_id, N'Tiếp tục chế độ ăn và vận động phù hợp',
       DATEADD(MONTH, 6, CAST(v.visit_date AS DATE))
FROM VetVisit v
WHERE v.visit_type_code='CHECKUP' AND v.booking_id IN (SELECT booking_id FROM @InsertedBookings);

-- VaccinationRecord cho VACCINE
INSERT INTO VaccinationRecord(visit_id, vaccine_name, batch_number, administered_at, next_due_date)
SELECT v.visit_id, N'Vaccine tổng hợp', N'BATCH-2025-10', v.visit_date,
       DATEADD(MONTH, 12, CAST(v.visit_date AS DATE))
FROM VetVisit v
WHERE v.visit_type_code='VACCINE' AND v.booking_id IN (SELECT booking_id FROM @InsertedBookings);

-- Prescription cho VACCINE
INSERT INTO Prescription(visit_id, instructions)
SELECT v.visit_id, N'Giảm đau nhẹ sau tiêm, uống sau ăn'
FROM VetVisit v
WHERE v.visit_type_code='VACCINE' AND v.booking_id IN (SELECT booking_id FROM @InsertedBookings);

-- PrescriptionItem cho VACCINE
INSERT INTO PrescriptionItem(prescription_id, medicine_name, dosage, frequency, duration_days)
SELECT pr.prescription_id, N'Paracetamol thú y 120mg', N'1/2 viên', N'2 lần/ngày', 3
FROM Prescription pr
JOIN VetVisit v ON v.visit_id = pr.visit_id
WHERE v.visit_type_code='VACCINE' AND v.booking_id IN (SELECT booking_id FROM @InsertedBookings);

-- Đánh dấu slot DONE cho các booking hoàn tất
UPDATE ss
SET ss.status = 'DONE'
FROM ScheduleSlot ss
JOIN @InsertedBookings ib ON ib.booking_id = ss.booking_id
WHERE ib.current_status = 'COMPLETED';

-- Tạo thanh toán + hóa đơn cho các booking COMPLETED vừa thêm
WITH cteCompleted AS (
  SELECT b.booking_id, b.total_price
  FROM Booking b
  WHERE b.booking_id IN (SELECT booking_id FROM @InsertedBookings WHERE current_status='COMPLETED')
)
INSERT INTO Payments(order_id, booking_id, payment_method_code, amount, status, transaction_ref, paid_at)
SELECT NULL, c.booking_id,
       CASE WHEN (c.booking_id % 2)=0 THEN 'CASH' ELSE 'EWALLET' END,
       c.total_price, 'SUCCESS',
       'BKG-PAY-' + CAST(c.booking_id AS NVARCHAR(20)),
       SYSUTCDATETIME()
FROM cteCompleted c;

WITH cteCompleted2 AS (
  SELECT c.booking_id, c.total_price,
         ROW_NUMBER() OVER (ORDER BY c.booking_id) AS rn
  FROM Booking c
  WHERE c.booking_id IN (SELECT booking_id FROM @InsertedBookings WHERE current_status='COMPLETED')
)
INSERT INTO Invoice(invoice_code, booking_id, total_amount, tax_amount, note)
SELECT 'INV-BKG-2' + RIGHT('0000' + CAST(rn AS VARCHAR(4)), 4),
       booking_id, total_price, 0, N'Hóa đơn dịch vụ'
FROM cteCompleted2;

-- Thêm một vài review cho các dịch vụ và lần khám mới
INSERT INTO Reviews(target_type_code, target_id, customer_id, rating, comment)
SELECT 'SERVICE', s.service_id, b.customer_id, 5, N'Dịch vụ tuyệt vời!'
FROM @InsertedBookings ib
JOIN Booking b ON b.booking_id = ib.booking_id
JOIN Services s ON s.service_id = ib.service_id
WHERE ib.current_status='COMPLETED' AND s.service_code LIKE 'GRM_%';

INSERT INTO Reviews(target_type_code, target_id, customer_id, rating, comment)
SELECT 'VET_VISIT', v.visit_id, v.owner_id, 4, N'Bác sĩ tận tâm, tư vấn rõ ràng'
FROM VetVisit v
WHERE v.booking_id IN (SELECT booking_id FROM @InsertedBookings);

GO