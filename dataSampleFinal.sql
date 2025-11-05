/*
*********************************************************************
 SCRIPT INSERT DỮ LIỆU MẪU (V9 - SỬA LỖI @vet_id)
 Chạy script này SAU KHI đã chạy script tạo DB (Script 1).
*********************************************************************
*/
USE SweetimalPetCare;
GO

PRINT '===============================================';
PRINT 'Bắt đầu chèn dữ liệu mẫu (V9 - Đã sửa lỗi)...';
PRINT '===============================================';

/* ==================== 1. USERS (Target: 15) ==================== */
PRINT 'Inserting 15 Users (Admin, Vets, Staff, Customers)...'
GO

DECLARE @pass_hash NVARCHAR(255) = 'e10adc3949ba59abbe56e057f20f883e';
-- 1 Admin
INSERT INTO Users(username, email, password_hash, full_name, role_id, gender)
SELECT 'admin','admin@example.com', @pass_hash, N'Quản Trị Viên', role_id, 1 FROM Roles WHERE role_name='Admin';
-- 3 Vets
INSERT INTO Users(username, email, password_hash, full_name, role_id, gender, is_veterinarian, position_title, specialty, license_number, hire_date)
SELECT 'vet1','vet1@example.com', @pass_hash, N'Trần Bác Sĩ 1', role_id, 1, 1, N'Bác sĩ chính', N'Thú y tổng quát', 'VET123', '2023-10-01' FROM Roles WHERE role_name='Vet';
INSERT INTO Users(username, email, password_hash, full_name, role_id, gender, is_veterinarian, position_title, specialty, license_number, hire_date)
SELECT 'vet2','vet2@example.com', @pass_hash, N'Hoàng Anh Tuấn', role_id, 1, 1, N'Bác sĩ', N'Chẩn đoán hình ảnh', 'VET456', '2024-02-01' FROM Roles WHERE role_name='Vet';
INSERT INTO Users(username, email, password_hash, full_name, role_id, gender, is_veterinarian, position_title, specialty, license_number, hire_date)
SELECT 'vet3','vet3@example.com', @pass_hash, N'Nguyễn Thị Lan', role_id, 2, 1, N'Bác sĩ phẫu thuật', N'Ngoại khoa', 'VET789', '2024-05-15' FROM Roles WHERE role_name='Vet';
-- 4 Staff
INSERT INTO Users(username, email, password_hash, full_name, role_id, gender, is_veterinarian, position_title, specialty, hire_date)
SELECT 'staff1','staff1@example.com', @pass_hash, N'Lê Nhân Viên 1', role_id, 2, 0, N'Groomer chính', N'Grooming', '2024-01-01' FROM Roles WHERE role_name='Staff';
INSERT INTO Users(username, email, password_hash, full_name, role_id, gender, is_veterinarian, position_title, specialty, hire_date)
SELECT 'staff2','staff2@example.com', @pass_hash, N'Huỳnh Thị Mai', role_id, 2, 0, N'Groomer', N'Grooming', '2024-03-01' FROM Roles WHERE role_name='Staff';
INSERT INTO Users(username, email, password_hash, full_name, role_id, gender, is_veterinarian, position_title, specialty, hire_date)
SELECT 'staff3','staff3@example.com', @pass_hash, N'Ngô Văn Bảo', role_id, 1, 0, N'Nhân viên lưu trú', N'Boarding', '2024-05-01' FROM Roles WHERE role_name='Staff';
INSERT INTO Users(username, email, password_hash, full_name, role_id, gender, is_veterinarian, position_title, specialty, hire_date)
SELECT 'staff4','staff4@example.com', @pass_hash, N'Trịnh Văn An', role_id, 1, 0, N'Lễ tân / Bán hàng', N'Chăm sóc khách hàng', '2024-06-01' FROM Roles WHERE role_name='Staff';
-- 7 Customers
INSERT INTO Users(username, email, password_hash, full_name, role_id, gender, birthday, is_veterinarian)
SELECT 'customer1','customer1@example.com', @pass_hash, N'Nguyễn Khách 1', role_id, 1,'1995-05-10', 0 FROM Roles WHERE role_name='Customer';
INSERT INTO Users(username, email, password_hash, full_name, role_id, gender, birthday, is_veterinarian)
SELECT 'customer2','customer2@example.com', @pass_hash, N'Trần Văn An', role_id, 1,'1990-01-15', 0 FROM Roles WHERE role_name='Customer';
INSERT INTO Users(username, email, password_hash, full_name, role_id, gender, birthday, is_veterinarian)
SELECT 'customer3','customer3@example.com', @pass_hash, N'Lê Thị Bình', role_id, 2,'1998-03-20', 0 FROM Roles WHERE role_name='Customer';
INSERT INTO Users(username, email, password_hash, full_name, role_id, gender, birthday, is_veterinarian)
SELECT 'customer4','customer4@example.com', @pass_hash, N'Phạm Hùng Cường', role_id, 1,'1985-11-02', 0 FROM Roles WHERE role_name='Customer';
INSERT INTO Users(username, email, password_hash, full_name, role_id, gender, birthday, is_veterinarian)
SELECT 'customer5','customer5@example.com', @pass_hash, N'Võ Thanh Duyên', role_id, 2,'2000-07-30', 0 FROM Roles WHERE role_name='Customer';
INSERT INTO Users(username, email, password_hash, full_name, role_id, gender, birthday, is_veterinarian)
SELECT 'customer6','customer6@example.com', @pass_hash, N'Đặng Văn Em', role_id, 1,'1992-12-12', 0 FROM Roles WHERE role_name='Customer';
INSERT INTO Users(username, email, password_hash, full_name, role_id, gender, birthday, is_veterinarian)
SELECT 'customer7','customer7@example.com', @pass_hash, N'Hồ Thị Fa', role_id, 2,'1999-02-14', 0 FROM Roles WHERE role_name='Customer';
GO

/* ==================== 1A. USER ADDRESSES (Target: 10) ==================== */
PRINT 'Inserting 10 User Addresses...';
GO
INSERT INTO UserAddress(user_id, label, recipient_name, phone, address_line1, ward, district, city, is_default)
VALUES
((SELECT user_id FROM Users WHERE username='customer1'), N'Nhà', N'Nguyễn Khách 1', '0900000111', N'123 Đường 3/2', N'P. An Khánh', N'Q. Ninh Kiều', N'Cần Thơ', 1),
((SELECT user_id FROM Users WHERE username='customer2'), N'Nhà', N'Trần Văn An', '0900000222', N'456 Đường CMT8', N'P. Cái Khế', N'Q. Ninh Kiều', N'Cần Thơ', 1),
((SELECT user_id FROM Users WHERE username='customer3'), N'Nhà', N'Lê Thị Bình', '0900000333', N'789 Đường 30/4', N'P. Hưng Lợi', N'Q. Ninh Kiều', N'Cần Thơ', 1),
((SELECT user_id FROM Users WHERE username='customer4'), N'Nhà', N'Phạm Hùng Cường', '0900000444', N'111 Mậu Thân', N'P. Xuân Khánh', N'Q. Ninh Kiều', N'Cần Thơ', 0),
((SELECT user_id FROM Users WHERE username='customer4'), N'Công ty', N'Phạm Hùng Cường', '0900000444', N'222 Võ Văn Kiệt', N'P. An Hòa', N'Q. Bình Thủy', N'Cần Thơ', 1),
((SELECT user_id FROM Users WHERE username='customer5'), N'Nhà', N'Võ Thanh Duyên', '0900000555', N'333 Nguyễn Văn Cừ', N'P. An Bình', N'Q. Ninh Kiều', N'Cần Thơ', 1),
((SELECT user_id FROM Users WHERE username='customer6'), N'Nhà', N'Đặng Văn Em', '0900000666', N'444 Trần Hưng Đạo', N'P. An Nghiệp', N'Q. Ninh Kiều', N'Cần Thơ', 1),
((SELECT user_id FROM Users WHERE username='customer7'), N'Nhà', N'Hồ Thị Fa', '0900000777', N'555 Lý Tự Trọng', N'P. An Cư', N'Q. Ninh Kiều', N'Cần Thơ', 1),
((SELECT user_id FROM Users WHERE username='customer1'), N'Công ty', N'Nguyễn Khách 1 (Giao giờ HC)', '0900000111', N'KCN Trà Nóc', N'P. Trà Nóc', N'Q. Bình Thủy', N'Cần Thơ', 0),
((SELECT user_id FROM Users WHERE username='customer3'), N'Nhà (Mới)', N'Lê Thị Bình', '0900000333', N'KDC 91B', N'P. An Khánh', N'Q. Ninh Kiều', N'Cần Thơ', 0);
GO

/* ==================== 2. SPECIES & BREEDS (Target: 5 Species, 12 Breeds) ==================== */
PRINT 'Inserting Species and Breeds...'
GO
INSERT INTO PetSpecies(species_name) VALUES (N'Chó'),(N'Mèo'),(N'Thỏ'),(N'Hamster'),(N'Chim');
GO
INSERT INTO PetBreed(species_id, breed_name) 
SELECT species_id, N'Poodle' FROM PetSpecies WHERE species_name=N'Chó';
INSERT INTO PetBreed(species_id, breed_name) 
SELECT species_id, N'Corgi' FROM PetSpecies WHERE species_name=N'Chó';
INSERT INTO PetBreed(species_id, breed_name) 
SELECT species_id, N'Golden Retriever' FROM PetSpecies WHERE species_name=N'Chó';
INSERT INTO PetBreed(species_id, breed_name) 
SELECT species_id, N'Mèo Ta' FROM PetSpecies WHERE species_name=N'Mèo';
INSERT INTO PetBreed(species_id, breed_name) 
SELECT species_id, N'Anh lông ngắn' FROM PetSpecies WHERE species_name=N'Mèo';
INSERT INTO PetBreed(species_id, breed_name) 
SELECT species_id, N'Mèo Ba Tư' FROM PetSpecies WHERE species_name=N'Mèo';
INSERT INTO PetBreed(species_id, breed_name) 
SELECT species_id, N'Thỏ Lùn (Dwarf)' FROM PetSpecies WHERE species_name=N'Thỏ';
INSERT INTO PetBreed(species_id, breed_name) 
SELECT species_id, N'Thỏ Sư Tử (Lionhead)' FROM PetSpecies WHERE species_name=N'Thỏ';
INSERT INTO PetBreed(species_id, breed_name) 
SELECT species_id, N'Hamster Winter White' FROM PetSpecies WHERE species_name=N'Hamster';
INSERT INTO PetBreed(species_id, breed_name) 
SELECT species_id, N'Hamster Bear' FROM PetSpecies WHERE species_name=N'Hamster';
INSERT INTO PetBreed(species_id, breed_name) 
SELECT species_id, N'Vẹt (Parrot)' FROM PetSpecies WHERE species_name=N'Chim';
INSERT INTO PetBreed(species_id, breed_name) 
SELECT species_id, N'Yến Phụng' FROM PetSpecies WHERE species_name=N'Chim';
GO

/* ==================== 3. PETS (Target: 15) ==================== */
PRINT 'Inserting 15 Pets...'
GO
INSERT INTO Pets(owner_id,name,species_id,breed_id,gender,birthdate,weight_kg)
VALUES
((SELECT user_id FROM Users WHERE username='customer1'), N'Bông', (SELECT species_id FROM PetSpecies WHERE species_name=N'Chó'), (SELECT breed_id FROM PetBreed WHERE breed_name=N'Poodle'), 'F','2022-05-01',5.2),
((SELECT user_id FROM Users WHERE username='customer2'), N'Miu', (SELECT species_id FROM PetSpecies WHERE species_name=N'Mèo'), (SELECT breed_id FROM PetBreed WHERE breed_name=N'Mèo Ta'), 'F','2023-01-10',3.5),
((SELECT user_id FROM Users WHERE username='customer2'), N'Đốm', (SELECT species_id FROM PetSpecies WHERE species_name=N'Chó'), (SELECT breed_id FROM PetBreed WHERE breed_name=N'Corgi'), 'M','2023-06-15',6.1),
((SELECT user_id FROM Users WHERE username='customer3'), N'Vàng', (SELECT species_id FROM PetSpecies WHERE species_name=N'Chó'), (SELECT breed_id FROM PetBreed WHERE breed_name=N'Golden Retriever'), 'M','2022-08-01',22.0),
((SELECT user_id FROM Users WHERE username='customer4'), N'Sushi', (SELECT species_id FROM PetSpecies WHERE species_name=N'Mèo'), (SELECT breed_id FROM PetBreed WHERE breed_name=N'Anh lông ngắn'), 'F','2021-05-20',4.8),
((SELECT user_id FROM Users WHERE username='customer4'), N'Kiki', (SELECT species_id FROM PetSpecies WHERE species_name=N'Mèo'), (SELECT breed_id FROM PetBreed WHERE breed_name=N'Mèo Ba Tư'), 'M','2023-03-10',4.2),
((SELECT user_id FROM Users WHERE username='customer5'), N'Lulu', (SELECT species_id FROM PetSpecies WHERE species_name=N'Chó'), (SELECT breed_id FROM PetBreed WHERE breed_name=N'Poodle'), 'F','2023-11-01',4.0),
((SELECT user_id FROM Users WHERE username='customer6'), N'Tôm', (SELECT species_id FROM PetSpecies WHERE species_name=N'Mèo'), (SELECT breed_id FROM PetBreed WHERE breed_name=N'Mèo Ta'), 'M','2020-10-10',5.0),
((SELECT user_id FROM Users WHERE username='customer6'), N'Jerry', (SELECT species_id FROM PetSpecies WHERE species_name=N'Chó'), (SELECT breed_id FROM PetBreed WHERE breed_name=N'Golden Retriever'), 'M','2023-09-05',15.0),
((SELECT user_id FROM Users WHERE username='customer7'), N'Bơ', (SELECT species_id FROM PetSpecies WHERE species_name=N'Thỏ'), (SELECT breed_id FROM PetBreed WHERE breed_name=N'Thỏ Lùn (Dwarf)'), 'F','2024-01-01',1.5),
((SELECT user_id FROM Users WHERE username='customer7'), N'Mít', (SELECT species_id FROM PetSpecies WHERE species_name=N'Hamster'), (SELECT breed_id FROM PetBreed WHERE breed_name=N'Hamster Winter White'), 'M','2024-05-01',0.2),
((SELECT user_id FROM Users WHERE username='customer1'), N'Rocket', (SELECT species_id FROM PetSpecies WHERE species_name=N'Chim'), (SELECT breed_id FROM PetBreed WHERE breed_name=N'Vẹt (Parrot)'), 'M','2022-02-02',0.5),
((SELECT user_id FROM Users WHERE username='customer3'), N'Luna', (SELECT species_id FROM PetSpecies WHERE species_name=N'Mèo'), (SELECT breed_id FROM PetBreed WHERE breed_name=N'Anh lông ngắn'), 'F','2023-07-15',4.1),
((SELECT user_id FROM Users WHERE username='customer5'), N'Max', (SELECT species_id FROM PetSpecies WHERE species_name=N'Chó'), (SELECT breed_id FROM PetBreed WHERE breed_name=N'Corgi'), 'M','2024-03-01',8.0),
((SELECT user_id FROM Users WHERE username='customer7'), N'Snow', (SELECT species_id FROM PetSpecies WHERE species_name=N'Thỏ'), (SELECT breed_id FROM PetBreed WHERE breed_name=N'Thỏ Sư Tử (Lionhead)'), 'F','2024-04-10',2.0);
GO

/* ==================== 4. SERVICES & PACKAGES (Target: 10+ each) ==================== */
PRINT 'Inserting 11 Services...';
GO
INSERT INTO Services(service_category_id, service_code, service_name, description, base_duration_min, current_price)
VALUES
((SELECT service_category_id FROM ServiceCategory WHERE category_name=N'Grooming'),'GRM_BASIC',N'Grooming cơ bản',N'Tắm & sấy',60, 150000),
((SELECT service_category_id FROM ServiceCategory WHERE category_name=N'Grooming'),'GRM_FULL',N'Grooming cao cấp',N'Tắm, sấy, cắt tỉa, vệ sinh tai/móng', 120, 350000),
((SELECT service_category_id FROM ServiceCategory WHERE category_name=N'Grooming'),'GRM_SPA',N'Grooming Spa Thư giãn',N'Grooming cao cấp + massage bùn khoáng', 150, 500000),
((SELECT service_category_id FROM ServiceCategory WHERE category_name=N'Health'),'HLT_CHECK',N'Khám tổng quát',N'Kiểm tra sức khỏe định kỳ',30, 200000),
((SELECT service_category_id FROM ServiceCategory WHERE category_name=N'Health'),'HLT_VACCINE',N'Tiêm phòng (Vaccine)',N'Tiêm phòng dại / 5 bệnh / 7 bệnh', 15, 250000),
((SELECT service_category_id FROM ServiceCategory WHERE category_name=N'Health'),'HLT_STERILE_CAT',N'Triệt sản Mèo (Cái/Đực)',N'Phẫu thuật triệt sản trọn gói', 90, 800000),
((SELECT service_category_id FROM ServiceCategory WHERE category_name=N'Health'),'HLT_STERILE_DOG',N'Triệt sản Chó (Cái/Đực)',N'Phẫu thuật triệt sản trọn gói', 120, 1200000),
((SELECT service_category_id FROM ServiceCategory WHERE category_name=N'Health'),'HLT_ULTRASOUND',N'Siêu âm',N'Siêu âm ổ bụng, thai...', 20, 150000),
((SELECT service_category_id FROM ServiceCategory WHERE category_name=N'Boarding'),'BOARD_STD',N'Lưu trú (Tiêu chuẩn)',N'Lưu trú theo ngày, phòng tiêu chuẩn', 1440, 180000),
((SELECT service_category_id FROM ServiceCategory WHERE category_name=N'Boarding'),'BOARD_VIP',N'Lưu trú (VIP)',N'Lưu trú theo ngày, phòng VIP có camera', 1440, 300000),
((SELECT service_category_id FROM ServiceCategory WHERE category_name=N'Boarding'),'BOARD_DAYCARE',N'Chăm sóc trong ngày',N'Chăm sóc theo giờ (tối thiểu 4 tiếng)', 240, 100000);
GO

PRINT 'Inserting 10 Service Packages...';
GO
INSERT INTO ServicePackage(package_code, package_name, description, package_price)
VALUES
('PKG_GROOM5_BASIC',N'Gói 5 lần Grooming Cơ bản',N'Tiết kiệm 10% cho 5 lần GRM_BASIC', 675000),
('PKG_GROOM5_FULL',N'Gói 5 lần Grooming Cao cấp',N'Tiết kiệm 10% cho 5 lần GRM_FULL', 1575000),
('PKG_SPA3',N'Gói 3 lần Spa Thư giãn',N'Combo 3 lần GRM_SPA', 1400000),
('PKG_HEALTH_ANNUAL_DOG',N'Gói Sức khỏe Chó (Năm)',N'1 Khám tổng quát + 1 Vaccine 7 bệnh + 1 Tẩy giun', 600000),
('PKG_HEALTH_ANNUAL_CAT',N'Gói Sức khỏe Mèo (Năm)',N'1 Khám tổng quát + 1 Vaccine 4 bệnh + 1 Tẩy giun', 500000),
('PKG_PUPPY',N'Gói Puppy (Chó con)',N'3 mũi Vaccine 7 bệnh + 1 Khám tổng quát', 800000),
('PKG_KITTEN',N'Gói Kitten (Mèo con)',N'3 mũi Vaccine 4 bệnh + 1 Khám tổng quát', 700000),
('PKG_BOARD10_STD',N'Gói 10 ngày Lưu trú Tiêu chuẩn',N'Giảm 15% cho 10 ngày BOARD_STD', 1530000),
('PKG_BOARD5_VIP',N'Gói 5 ngày Lưu trú VIP',N'Gói 5 ngày BOARD_VIP', 1500000),
('PKG_DAYCARE10',N'Gói 10 buổi Daycare (4h/buổi)',N'Gói 10 buổi BOARD_DAYCARE', 900000);
GO

PRINT 'Inserting 13 Package Items...';
GO
INSERT INTO PackageItem(package_id, service_id, quantity)
VALUES
((SELECT package_id FROM ServicePackage WHERE package_code='PKG_GROOM5_BASIC'), (SELECT service_id FROM Services WHERE service_code='GRM_BASIC'), 5),
((SELECT package_id FROM ServicePackage WHERE package_code='PKG_GROOM5_FULL'), (SELECT service_id FROM Services WHERE service_code='GRM_FULL'), 5),
((SELECT package_id FROM ServicePackage WHERE package_code='PKG_SPA3'), (SELECT service_id FROM Services WHERE service_code='GRM_SPA'), 3),
((SELECT package_id FROM ServicePackage WHERE package_code='PKG_HEALTH_ANNUAL_DOG'), (SELECT service_id FROM Services WHERE service_code='HLT_CHECK'), 1),
((SELECT package_id FROM ServicePackage WHERE package_code='PKG_HEALTH_ANNUAL_DOG'), (SELECT service_id FROM Services WHERE service_code='HLT_VACCINE'), 1),
((SELECT package_id FROM ServicePackage WHERE package_code='PKG_HEALTH_ANNUAL_CAT'), (SELECT service_id FROM Services WHERE service_code='HLT_CHECK'), 1),
((SELECT package_id FROM ServicePackage WHERE package_code='PKG_HEALTH_ANNUAL_CAT'), (SELECT service_id FROM Services WHERE service_code='HLT_VACCINE'), 1),
((SELECT package_id FROM ServicePackage WHERE package_code='PKG_PUPPY'), (SELECT service_id FROM Services WHERE service_code='HLT_VACCINE'), 3),
((SELECT package_id FROM ServicePackage WHERE package_code='PKG_PUPPY'), (SELECT service_id FROM Services WHERE service_code='HLT_CHECK'), 1),
((SELECT package_id FROM ServicePackage WHERE package_code='PKG_KITTEN'), (SELECT service_id FROM Services WHERE service_code='HLT_VACCINE'), 3),
((SELECT package_id FROM ServicePackage WHERE package_code='PKG_KITTEN'), (SELECT service_id FROM Services WHERE service_code='HLT_CHECK'), 1),
((SELECT package_id FROM ServicePackage WHERE package_code='PKG_BOARD10_STD'), (SELECT service_id FROM Services WHERE service_code='BOARD_STD'), 10),
((SELECT package_id FROM ServicePackage WHERE package_code='PKG_BOARD5_VIP'), (SELECT service_id FROM Services WHERE service_code='BOARD_VIP'), 5),
((SELECT package_id FROM ServicePackage WHERE package_code='PKG_DAYCARE10'), (SELECT service_id FROM Services WHERE service_code='BOARD_DAYCARE'), 10);
GO

/* ==================== 5. BOOKINGS (Target: 20) ==================== */
PRINT 'Inserting 20 Bookings (Services and Packages)...';
GO
INSERT INTO Booking(customer_id, pet_id, service_id, package_id, booking_time, requested_date, requested_start, current_status, total_price, payment_status)
VALUES
-- 5 PENDING
((SELECT user_id FROM Users WHERE username='customer1'), (SELECT pet_id FROM Pets WHERE name=N'Bông'), (SELECT service_id FROM Services WHERE service_code='GRM_BASIC'), NULL, '2025-10-28 09:00', '2025-11-01', '09:00', 'PENDING', 150000, 'PENDING'),
((SELECT user_id FROM Users WHERE username='customer2'), (SELECT pet_id FROM Pets WHERE name=N'Miu'), (SELECT service_id FROM Services WHERE service_code='HLT_CHECK'), NULL, '2025-10-28 10:00', '2025-11-01', '10:00', 'PENDING', 200000, 'PENDING'),
((SELECT user_id FROM Users WHERE username='customer3'), (SELECT pet_id FROM Pets WHERE name=N'Vàng'), (SELECT service_id FROM Services WHERE service_code='BOARD_STD'), NULL, '2025-10-28 11:00', '2025-11-05', '08:00', 'PENDING', 180000, 'PENDING'),
((SELECT user_id FROM Users WHERE username='customer4'), (SELECT pet_id FROM Pets WHERE name=N'Sushi'), NULL, (SELECT package_id FROM ServicePackage WHERE package_code='PKG_GROOM5_BASIC'), '2025-10-28 14:00', '2025-11-02', '11:00', 'PENDING', 675000, 'PENDING'),
((SELECT user_id FROM Users WHERE username='customer5'), (SELECT pet_id FROM Pets WHERE name=N'Lulu'), (SELECT service_id FROM Services WHERE service_code='GRM_FULL'), NULL, '2025-10-29 08:00', '2025-11-02', '14:00', 'PENDING', 350000, 'PENDING'),
-- 5 CONFIRMED
((SELECT user_id FROM Users WHERE username='customer6'), (SELECT pet_id FROM Pets WHERE name=N'Tôm'), (SELECT service_id FROM Services WHERE service_code='HLT_VACCINE'), NULL, '2025-10-27 10:00', '2025-11-03', '09:30', 'CONFIRMED', 250000, 'PENDING'),
((SELECT user_id FROM Users WHERE username='customer7'), (SELECT pet_id FROM Pets WHERE name=N'Bơ'), (SELECT service_id FROM Services WHERE service_code='HLT_CHECK'), NULL, '2025-10-27 11:00', '2025-11-03', '10:30', 'CONFIRMED', 200000, 'PENDING'),
((SELECT user_id FROM Users WHERE username='customer1'), (SELECT pet_id FROM Pets WHERE name=N'Rocket'), (SELECT service_id FROM Services WHERE service_code='HLT_CHECK'), NULL, '2025-10-27 13:00', '2025-11-04', '11:00', 'CONFIRMED', 200000, 'PENDING'),
((SELECT user_id FROM Users WHERE username='customer2'), (SELECT pet_id FROM Pets WHERE name=N'Đốm'), (SELECT service_id FROM Services WHERE service_code='GRM_FULL'), NULL, '2025-10-28 15:00', '2025-11-04', '14:00', 'CONFIRMED', 350000, 'PAID'),
((SELECT user_id FROM Users WHERE username='customer3'), (SELECT pet_id FROM Pets WHERE name=N'Luna'), NULL, (SELECT package_id FROM ServicePackage WHERE package_code='PKG_KITTEN'), '2025-10-29 10:00', '2025-11-05', '10:00', 'CONFIRMED', 700000, 'PAID'),
-- 5 COMPLETED
((SELECT user_id FROM Users WHERE username='customer4'), (SELECT pet_id FROM Pets WHERE name=N'Kiki'), (SELECT service_id FROM Services WHERE service_code='GRM_SPA'), NULL, '2025-10-20 09:00', '2025-10-25', '09:00', 'COMPLETED', 500000, 'PAID'),
((SELECT user_id FROM Users WHERE username='customer5'), (SELECT pet_id FROM Pets WHERE name=N'Max'), (SELECT service_id FROM Services WHERE service_code='HLT_CHECK'), NULL, '2025-10-21 10:00', '2025-10-26', '10:00', 'COMPLETED', 200000, 'PAID'),
((SELECT user_id FROM Users WHERE username='customer6'), (SELECT pet_id FROM Pets WHERE name=N'Jerry'), (SELECT service_id FROM Services WHERE service_code='BOARD_VIP'), NULL, '2025-10-15 11:00', '2025-10-20', '08:00', 'COMPLETED', 300000, 'PAID'),
((SELECT user_id FROM Users WHERE username='customer7'), (SELECT pet_id FROM Pets WHERE name=N'Mít'), (SELECT service_id FROM Services WHERE service_code='HLT_CHECK'), NULL, '2025-10-22 14:00', '2025-10-27', '11:00', 'COMPLETED', 200000, 'PAID'),
((SELECT user_id FROM Users WHERE username='customer1'), (SELECT pet_id FROM Pets WHERE name=N'Bông'), NULL, (SELECT package_id FROM ServicePackage WHERE package_code='PKG_GROOM5_BASIC'), '2025-10-01 10:00', '2025-10-10', '10:00', 'COMPLETED', 675000, 'PAID'),
-- 5 CANCELLED
((SELECT user_id FROM Users WHERE username='customer2'), (SELECT pet_id FROM Pets WHERE name=N'Miu'), (SELECT service_id FROM Services WHERE service_code='GRM_BASIC'), NULL, '2025-10-25 09:00', '2025-10-28', '09:00', 'CANCELLED', 150000, 'PENDING'),
((SELECT user_id FROM Users WHERE username='customer3'), (SELECT pet_id FROM Pets WHERE name=N'Vàng'), (SELECT service_id FROM Services WHERE service_code='HLT_ULTRASOUND'), NULL, '2025-10-26 10:00', '2025-10-29', '10:00', 'CANCELLED', 150000, 'PENDING'),
((SELECT user_id FROM Users WHERE username='customer4'), (SELECT pet_id FROM Pets WHERE name=N'Sushi'), (SELECT service_id FROM Services WHERE service_code='BOARD_STD'), NULL, '2025-10-27 11:00', '2025-10-30', '08:00', 'CANCELLED', 180000, 'PENDING'),
((SELECT user_id FROM Users WHERE username='customer5'), (SELECT pet_id FROM Pets WHERE name=N'Lulu'), (SELECT service_id FROM Services WHERE service_code='GRM_BASIC'), NULL, '2025-10-28 14:00', '2025-10-31', '11:00', 'CANCELLED', 150000, 'PENDING'),
((SELECT user_id FROM Users WHERE username='customer6'), (SELECT pet_id FROM Pets WHERE name=N'Tôm'), NULL, (SELECT package_id FROM ServicePackage WHERE package_code='PKG_SPA3'), '2025-10-29 08:00', '2025-11-01', '14:00', 'CANCELLED', 1400000, 'PENDING');
GO

/* ==================== 6. BOOKING STATUS HISTORY (Target: 20+) ==================== */
PRINT 'Inserting 30 Booking Status Histories...';
GO
INSERT INTO BookingStatusHistory(booking_id, status_code, changed_by, comment)
SELECT booking_id, current_status, customer_id, N'Hệ thống tự động ghi nhận'
FROM Booking;
GO
INSERT INTO BookingStatusHistory(booking_id, status_code, changed_by, comment)
SELECT booking_id, 'CONFIRMED', (SELECT user_id FROM Users WHERE username='admin'), N'Admin xác nhận lịch hẹn'
FROM Booking WHERE current_status IN ('CONFIRMED', 'COMPLETED');
GO
INSERT INTO BookingStatusHistory(booking_id, status_code, changed_by, comment)
SELECT booking_id, 'COMPLETED', (SELECT user_id FROM Users WHERE username='staff1'), N'Dịch vụ đã hoàn tất'
FROM Booking WHERE current_status = 'COMPLETED';
GO

/* ==================== 7. SCHEDULE SLOTS & ASSIGNMENTS (Target: 10+ Slots, 10+ Assignments) ==================== */
PRINT 'Inserting 10 Slots (Booked) and 10 Assignments...';
GO
;WITH BookingsToSlot AS (
    SELECT 
        b.booking_id,
        CAST(CONCAT(b.requested_date, ' ', b.requested_start) AS DATETIME2) AS start_time,
        DATEADD(MINUTE, COALESCE(s.base_duration_min, 60), CAST(CONCAT(b.requested_date, ' ', b.requested_start) AS DATETIME2)) AS end_time,
        CASE 
            WHEN sc.category_name = 'Grooming' THEN (SELECT user_id FROM Users WHERE username='staff1')
            WHEN sc.category_name = 'Health' THEN (SELECT user_id FROM Users WHERE username='vet1')
            WHEN sc.category_name = 'Boarding' THEN (SELECT user_id FROM Users WHERE username='staff3')
            ELSE (SELECT user_id FROM Users WHERE username='staff2')
        END AS staff_id,
        b.current_status
    FROM Booking b
    LEFT JOIN Services s ON b.service_id = s.service_id
    LEFT JOIN ServiceCategory sc ON s.service_category_id = sc.service_category_id
    WHERE b.current_status IN ('CONFIRMED', 'COMPLETED')
)
INSERT INTO ScheduleSlot(booking_id, staff_id, room_name, start_time, end_time, status)
SELECT 
    booking_id, staff_id, 
    CASE WHEN staff_id = (SELECT user_id FROM Users WHERE username='vet1') THEN 'Clinic-1' ELSE 'Groom-1' END,
    start_time, end_time,
    CASE WHEN current_status = 'COMPLETED' THEN 'DONE' ELSE 'BOOKED' END
FROM BookingsToSlot;
GO

INSERT INTO BookingStaffAssignment(booking_id, staff_id, role_in_service)
SELECT booking_id, staff_id, N'Nhân viên chính'
FROM ScheduleSlot WHERE booking_id IS NOT NULL AND staff_id IS NOT NULL;
GO

PRINT 'Inserting 10 OPEN Slots...';
GO
INSERT INTO ScheduleSlot(booking_id, staff_id, room_name, start_time, end_time, status)
VALUES
(NULL, (SELECT user_id FROM Users WHERE username='vet1'), 'Clinic-1', '2025-11-10 09:00', '2025-11-10 09:30', 'OPEN'),
(NULL, (SELECT user_id FROM Users WHERE username='vet2'), 'Clinic-2', '2025-11-10 10:00', '2025-11-10 10:30', 'OPEN'),
(NULL, (SELECT user_id FROM Users WHERE username='vet3'), 'Surgery-1', '2025-11-10 10:00', '2025-11-10 12:00', 'OPEN'),
(NULL, (SELECT user_id FROM Users WHERE username='staff1'), 'Groom-1', '2025-11-10 09:00', '2025-11-10 11:00', 'OPEN'),
(NULL, (SELECT user_id FROM Users WHERE username='staff2'), 'Groom-2', '2025-11-10 14:00', '2025-11-10 16:00', 'OPEN'),
(NULL, (SELECT user_id FROM Users WHERE username='staff3'), 'Boarding-A1', '2025-11-10 08:00', '2025-11-10 17:00', 'OPEN'),
(NULL, (SELECT user_id FROM Users WHERE username='vet1'), 'Clinic-1', '2025-11-11 09:00', '2025-11-11 09:30', 'OPEN'),
(NULL, (SELECT user_id FROM Users WHERE username='vet2'), 'Clinic-2', '2025-11-11 10:00', '2025-11-11 10:30', 'OPEN'),
(NULL, (SELECT user_id FROM Users WHERE username='staff1'), 'Groom-1', '2025-11-11 09:00', '2025-11-11 11:00', 'OPEN'),
(NULL, (SELECT user_id FROM Users WHERE username='staff2'), 'Groom-2', '2025-11-11 14:00', '2025-11-11 16:00', 'OPEN');
GO

/* ==================== 8. E-COMMERCE DATA (Target: 10+ each) ==================== */
PRINT 'Inserting 10 Product Categories...';
GO
INSERT INTO ProductCategory(category_name, parent_id, description)
VALUES
(N'Thức ăn', NULL, N'Thức ăn khô, ướt, hạt...'),
(N'Đồ chơi', NULL, N'Đồ chơi gặm, cào móng...'),
(N'Phụ kiện', NULL, N'Vòng cổ, dây dắt, nhà, nệm...'),
(N'Thuốc & Dinh dưỡng', NULL, N'Thuốc, vitamin, thực phẩm chức năng...'),
(N'Vệ sinh & Chăm sóc', NULL, N'Cát vệ sinh, dầu gội, lược...');
GO
INSERT INTO ProductCategory(category_name, parent_id, description)
VALUES
(N'Thức ăn Chó', (SELECT product_category_id FROM ProductCategory WHERE category_name=N'Thức ăn'), NULL),
(N'Thức ăn Mèo', (SELECT product_category_id FROM ProductCategory WHERE category_name=N'Thức ăn'), NULL),
(N'Thuốc trị ve', (SELECT product_category_id FROM ProductCategory WHERE category_name=N'Thuốc & Dinh dưỡng'), NULL),
(N'Dây dắt', (SELECT product_category_id FROM ProductCategory WHERE category_name=N'Phụ kiện'), NULL),
(N'Cát Mèo', (SELECT product_category_id FROM ProductCategory WHERE category_name=N'Vệ sinh & Chăm sóc'), NULL);
GO

PRINT 'Inserting 10 Brands...';
GO
INSERT INTO Brand(brand_name, description)
VALUES
(N'Royal Canin', N'Hãng thức ăn cao cấp từ Pháp'),
(N'Pedigree', N'Thức ăn phổ thông cho chó'),
(N'Whiskas', N'Thức ăn phổ thông cho mèo'),
(N'Me-O', N'Thức ăn mèo'),
(N'Frontline', N'Thuốc trị ve rận'),
(N'NexGard', N'Thuốc trị ve (viên nhai)'),
(N'Hartz', N'Dầu gội, phụ kiện'),
(N'CatSan', N'Cát vệ sinh'),
(N'PetSafe', N'Đồ chơi, phụ kiện thông minh'),
(N'Kong', N'Đồ chơi siêu bền cho chó');
GO

PRINT 'Inserting 10 Products...';
GO
INSERT INTO Product(product_code, product_name, product_category_id, brand_id, description)
VALUES
('RC_MINIPUPPY', N'Royal Canin Mini Puppy', (SELECT product_category_id FROM ProductCategory WHERE category_name=N'Thức ăn Chó'), (SELECT brand_id FROM Brand WHERE brand_name=N'Royal Canin'), N'Hạt cho chó con dòng mini'),
('RC_KITTEN', N'Royal Canin Kitten', (SELECT product_category_id FROM ProductCategory WHERE category_name=N'Thức ăn Mèo'), (SELECT brand_id FROM Brand WHERE brand_name=N'Royal Canin'), N'Hạt cho mèo con'),
('PDG_ADULT', N'Pedigree Adult', (SELECT product_category_id FROM ProductCategory WHERE category_name=N'Thức ăn Chó'), (SELECT brand_id FROM Brand WHERE brand_name=N'Pedigree'), N'Hạt cho chó trưởng thành'),
('WSK_OCEAN', N'Whiskas Ocean Fish', (SELECT product_category_id FROM ProductCategory WHERE category_name=N'Thức ăn Mèo'), (SELECT brand_id FROM Brand WHERE brand_name=N'Whiskas'), N'Hạt vị cá biển'),
('NEX_SPECTRA', N'NexGard Spectra', (SELECT product_category_id FROM ProductCategory WHERE category_name=N'Thuốc trị ve'), (SELECT brand_id FROM Brand WHERE brand_name=N'NexGard'), N'Viên nhai trị ve, rận, giun'),
('FL_PLUS_CAT', N'Frontline Plus (Mèo)', (SELECT product_category_id FROM ProductCategory WHERE category_name=N'Thuốc trị ve'), (SELECT brand_id FROM Brand WHERE brand_name=N'Frontline'), N'Thuốc nhỏ gáy trị ve mèo'),
('KONG_CLASSIC', N'Kong Classic', (SELECT product_category_id FROM ProductCategory WHERE category_name=N'Đồ chơi'), (SELECT brand_id FROM Brand WHERE brand_name=N'Kong'), N'Đồ chơi cao su siêu bền'),
('CATSAN_ULTRA', N'CatSan Ultra Clumping', (SELECT product_category_id FROM ProductCategory WHERE category_name=N'Cát Mèo'), (SELECT brand_id FROM Brand WHERE brand_name=N'CatSan'), N'Cát vón cục khử mùi'),
('HARZ_LEASH', N'Hartz Leash', (SELECT product_category_id FROM ProductCategory WHERE category_name=N'Dây dắt'), (SELECT brand_id FROM Brand WHERE brand_name=N'Hartz'), N'Dây dắt chó'),
('MEO_PERSIAN', N'Me-O Persian Cat', (SELECT product_category_id FROM ProductCategory WHERE category_name=N'Thức ăn Mèo'), (SELECT brand_id FROM Brand WHERE brand_name=N'Me-O'), N'Hạt cho mèo Ba Tư');
GO

PRINT 'Inserting 15 Product Variants (with Stock)...';
GO
INSERT INTO ProductVariant(product_id, sku, attribute_json, price, stock_quantity)
VALUES
((SELECT product_id FROM Product WHERE product_code='RC_MINIPUPPY'), 'RCMP_1KG', '{"weight":"1kg"}', 250000, 100),
((SELECT product_id FROM Product WHERE product_code='RC_MINIPUPPY'), 'RCMP_3KG', '{"weight":"3kg"}', 650000, 50),
((SELECT product_id FROM Product WHERE product_code='RC_KITTEN'), 'RCK_1KG', '{"weight":"1kg"}', 280000, 100),
((SELECT product_id FROM Product WHERE product_code='RC_KITTEN'), 'RCK_4KG', '{"weight":"4kg"}', 900000, 40),
((SELECT product_id FROM Product WHERE product_code='PDG_ADULT'), 'PDGA_10KG', '{"weight":"10kg", "flavor":"Beef"}', 800000, 30),
((SELECT product_id FROM Product WHERE product_code='WSK_OCEAN'), 'WSKO_1.2KG', '{"weight":"1.2kg"}', 120000, 150),
((SELECT product_id FROM Product WHERE product_code='NEX_SPECTRA'), 'NEXS_M', '{"size":"M (7.5-15kg)"}', 200000, 80),
((SELECT product_id FROM Product WHERE product_code='NEX_SPECTRA'), 'NEXS_L', '{"size":"L (15-30kg)"}', 250000, 70),
((SELECT product_id FROM Product WHERE product_code='FL_PLUS_CAT'), 'FLPC', '{"unit":"1 tuýp"}', 150000, 120),
((SELECT product_id FROM Product WHERE product_code='KONG_CLASSIC'), 'KONGC_M', '{"size":"M"}', 300000, 60),
((SELECT product_id FROM Product WHERE product_code='KONG_CLASSIC'), 'KONGC_L', '{"size":"L"}', 450000, 40),
((SELECT product_id FROM Product WHERE product_code='CATSAN_ULTRA'), 'CATSAN_10L', '{"volume":"10L"}', 220000, 90),
((SELECT product_id FROM Product WHERE product_code='HARZ_LEASH'), 'HARZ_M_RED', '{"size":"M", "color":"Red"}', 180000, 50),
((SELECT product_id FROM Product WHERE product_code='MEO_PERSIAN'), 'MEOP_1.1KG', '{"weight":"1.1kg"}', 110000, 70),
((SELECT product_id FROM Product WHERE product_code='PDG_ADULT'), 'PDGA_3KG', '{"weight":"3kg", "flavor":"Chicken"}', 280000, 60);
GO

/* ==================== 9. ORDERS & ORDER ITEMS (Target: 10 Orders) ==================== */
PRINT 'Inserting 10 Orders...';
GO

DECLARE @order1_id BIGINT, @order2_id BIGINT, @order3_id BIGINT, @order4_id BIGINT, @order5_id BIGINT;
DECLARE @order6_id BIGINT, @order7_id BIGINT, @order8_id BIGINT, @order9_id BIGINT, @order10_id BIGINT;
INSERT INTO Orders(order_code, customer_id, shipping_address_id, order_status, payment_method_code, payment_status, subtotal_amount, shipping_fee, total_amount)
VALUES ('ORD001', (SELECT user_id FROM Users WHERE username='customer1'), (SELECT address_id FROM UserAddress WHERE user_id=(SELECT user_id FROM Users WHERE username='customer1') AND is_default=1), 'COMPLETED', 'EWALLET', 'PAID', 250000, 15000, 265000);
SET @order1_id = SCOPE_IDENTITY();
INSERT INTO OrderItems(order_id, variant_id, unit_price, quantity) VALUES (@order1_id, (SELECT variant_id FROM ProductVariant WHERE sku='RCMP_1KG'), 250000, 1);

INSERT INTO Orders(order_code, customer_id, shipping_address_id, order_status, payment_method_code, payment_status, subtotal_amount, shipping_fee, total_amount)
VALUES ('ORD002', (SELECT user_id FROM Users WHERE username='customer2'), (SELECT address_id FROM UserAddress WHERE user_id=(SELECT user_id FROM Users WHERE username='customer2') AND is_default=1), 'COMPLETED', 'COD', 'PAID', 400000, 15000, 415000);
SET @order2_id = SCOPE_IDENTITY();
INSERT INTO OrderItems(order_id, variant_id, unit_price, quantity) VALUES (@order2_id, (SELECT variant_id FROM ProductVariant WHERE sku='RCK_1KG'), 280000, 1);
INSERT INTO OrderItems(order_id, variant_id, unit_price, quantity) VALUES (@order2_id, (SELECT variant_id FROM ProductVariant WHERE sku='FLPC'), 120000, 1); 

INSERT INTO Orders(order_code, customer_id, shipping_address_id, order_status, payment_method_code, payment_status, subtotal_amount, shipping_fee, total_amount)
VALUES ('ORD003', (SELECT user_id FROM Users WHERE username='customer3'), (SELECT address_id FROM UserAddress WHERE user_id=(SELECT user_id FROM Users WHERE username='customer3') AND is_default=1), 'SHIPPED', 'BANK', 'PAID', 800000, 30000, 830000);
SET @order3_id = SCOPE_IDENTITY();
INSERT INTO OrderItems(order_id, variant_id, unit_price, quantity) VALUES (@order3_id, (SELECT variant_id FROM ProductVariant WHERE sku='PDGA_10KG'), 800000, 1);

INSERT INTO Orders(order_code, customer_id, shipping_address_id, order_status, payment_method_code, payment_status, subtotal_amount, shipping_fee, total_amount)
VALUES ('ORD004', (SELECT user_id FROM Users WHERE username='customer4'), (SELECT address_id FROM UserAddress WHERE user_id=(SELECT user_id FROM Users WHERE username='customer4') AND is_default=1), 'PROCESSING', 'EWALLET', 'PAID', 750000, 0, 750000);
SET @order4_id = SCOPE_IDENTITY();
INSERT INTO OrderItems(order_id, variant_id, unit_price, quantity) VALUES (@order4_id, (SELECT variant_id FROM ProductVariant WHERE sku='KONGC_M'), 300000, 1);
INSERT INTO OrderItems(order_id, variant_id, unit_price, quantity) VALUES (@order4_id, (SELECT variant_id FROM ProductVariant WHERE sku='KONGC_L'), 450000, 1);

INSERT INTO Orders(order_code, customer_id, shipping_address_id, order_status, payment_method_code, payment_status, subtotal_amount, shipping_fee, total_amount)
VALUES ('ORD005', (SELECT user_id FROM Users WHERE username='customer5'), (SELECT address_id FROM UserAddress WHERE user_id=(SELECT user_id FROM Users WHERE username='customer5') AND is_default=1), 'PENDING', 'COD', 'PENDING', 240000, 15000, 255000);
SET @order5_id = SCOPE_IDENTITY();
INSERT INTO OrderItems(order_id, variant_id, unit_price, quantity) VALUES (@order5_id, (SELECT variant_id FROM ProductVariant WHERE sku='WSKO_1.2KG'), 120000, 2);

INSERT INTO Orders(order_code, customer_id, shipping_address_id, order_status, payment_method_code, payment_status, subtotal_amount, shipping_fee, total_amount)
VALUES ('ORD006', (SELECT user_id FROM Users WHERE username='customer6'), (SELECT address_id FROM UserAddress WHERE user_id=(SELECT user_id FROM Users WHERE username='customer6') AND is_default=1), 'CANCELLED', 'BANK', 'PENDING', 220000, 15000, 235000);
SET @order6_id = SCOPE_IDENTITY();

INSERT INTO Orders(order_code, customer_id, shipping_address_id, order_status, payment_method_code, payment_status, subtotal_amount, shipping_fee, total_amount)
VALUES ('ORD007', (SELECT user_id FROM Users WHERE username='customer7'), (SELECT address_id FROM UserAddress WHERE user_id=(SELECT user_id FROM Users WHERE username='customer7') AND is_default=1), 'COMPLETED', 'CASH', 'PAID', 330000, 0, 330000);
SET @order7_id = SCOPE_IDENTITY();
INSERT INTO OrderItems(order_id, variant_id, unit_price, quantity) VALUES (@order7_id, (SELECT variant_id FROM ProductVariant WHERE sku='MEOP_1.1KG'), 110000, 3);

INSERT INTO Orders(order_code, customer_id, shipping_address_id, order_status, payment_method_code, payment_status, subtotal_amount, shipping_fee, total_amount)
VALUES ('ORD008', (SELECT user_id FROM Users WHERE username='customer1'), (SELECT address_id FROM UserAddress WHERE user_id=(SELECT user_id FROM Users WHERE username='customer1') AND label=N'Công ty'), 'COMPLETED', 'EWALLET', 'PAID', 650000, 15000, 665000);
SET @order8_id = SCOPE_IDENTITY();
INSERT INTO OrderItems(order_id, variant_id, unit_price, quantity) VALUES (@order8_id, (SELECT variant_id FROM ProductVariant WHERE sku='RCMP_3KG'), 650000, 1);

INSERT INTO Orders(order_code, customer_id, shipping_address_id, order_status, payment_method_code, payment_status, subtotal_amount, shipping_fee, total_amount)
VALUES ('ORD009', (SELECT user_id FROM Users WHERE username='customer4'), (SELECT address_id FROM UserAddress WHERE user_id=(SELECT user_id FROM Users WHERE username='customer4') AND is_default=1), 'PROCESSING', 'BANK', 'PAID', 450000, 0, 450000);
SET @order9_id = SCOPE_IDENTITY();
INSERT INTO OrderItems(order_id, variant_id, unit_price, quantity) VALUES (@order9_id, (SELECT variant_id FROM ProductVariant WHERE sku='NEXS_M'), 200000, 1);
INSERT INTO OrderItems(order_id, variant_id, unit_price, quantity) VALUES (@order9_id, (SELECT variant_id FROM ProductVariant WHERE sku='NEXS_L'), 250000, 1);

INSERT INTO Orders(order_code, customer_id, shipping_address_id, order_status, payment_method_code, payment_status, subtotal_amount, shipping_fee, total_amount)
VALUES ('ORD010', (SELECT user_id FROM Users WHERE username='customer5'), NULL, 'COMPLETED', 'CASH', 'PAID', 180000, 0, 180000);
SET @order10_id = SCOPE_IDENTITY();
INSERT INTO OrderItems(order_id, variant_id, unit_price, quantity) VALUES (@order10_id, (SELECT variant_id FROM ProductVariant WHERE sku='HARZ_M_RED'), 180000, 1);
GO

/* ==================== 10. VET VISITS (Target: 10) (VIẾT LẠI V9 - SỬA LỖI) ==================== */
PRINT 'Inserting 10 Vet Visits (Robust Method)...';
GO

-- Khai báo biến
DECLARE @booking_id BIGINT, @pet_id BIGINT, @owner_id BIGINT, @vet_id BIGINT;

-- Visit 1: Max (Completed Booking)
SELECT @pet_id = pet_id, @owner_id = owner_id FROM Pets WHERE name=N'Max';
SELECT @booking_id = booking_id FROM Booking WHERE pet_id=@pet_id AND current_status='COMPLETED';
SELECT @vet_id = user_id FROM Users WHERE username='vet1';
INSERT INTO VetVisit(booking_id, pet_id, owner_id, vet_staff_id, visit_type_code, visit_date, weight_kg, temperature_c, symptoms, diagnosis_summary, treatment_notes, follow_up_date)
VALUES (@booking_id, @pet_id, @owner_id, @vet_id, 'CHECKUP', '2025-10-26 10:00', 8.0, 38.5, N'Khám định kỳ', N'Sức khỏe tốt', N'Tẩy giun định kỳ', '2026-04-26');

-- Visit 2: Mít (Completed Booking)
SELECT @pet_id = pet_id, @owner_id = owner_id FROM Pets WHERE name=N'Mít';
SELECT @booking_id = booking_id FROM Booking WHERE pet_id=@pet_id AND current_status='COMPLETED';
SELECT @vet_id = user_id FROM Users WHERE username='vet2';
INSERT INTO VetVisit(booking_id, pet_id, owner_id, vet_staff_id, visit_type_code, visit_date, weight_kg, temperature_c, symptoms, diagnosis_summary, treatment_notes, follow_up_date)
VALUES (@booking_id, @pet_id, @owner_id, @vet_id, 'CHECKUP', '2025-10-27 11:00', 0.2, 38.0, N'Kiểm tra sức khỏe tổng quát hamster', N'Bình thường', N'Bổ sung thêm hạt dinh dưỡng', NULL);

-- Visit 3: Tôm (Confirmed Booking)
SELECT @pet_id = pet_id, @owner_id = owner_id FROM Pets WHERE name=N'Tôm';
SELECT @booking_id = booking_id FROM Booking WHERE pet_id=@pet_id AND current_status='CONFIRMED';
SELECT @vet_id = user_id FROM Users WHERE username='vet1';
INSERT INTO VetVisit(booking_id, pet_id, owner_id, vet_staff_id, visit_type_code, visit_date, weight_kg, temperature_c, symptoms, diagnosis_summary, treatment_notes, follow_up_date)
VALUES (@booking_id, @pet_id, @owner_id, @vet_id, 'VACCINE', '2025-11-03 09:30', 5.0, 38.7, N'Tiêm phòng dại nhắc lại', N'Đã tiêm Vaccine Rabisin', N'Theo dõi phản ứng 24h', '2026-11-03');

-- Visit 4: Bơ (Confirmed Booking)
SELECT @pet_id = pet_id, @owner_id = owner_id FROM Pets WHERE name=N'Bơ';
SELECT @booking_id = booking_id FROM Booking WHERE pet_id=@pet_id AND current_status='CONFIRMED';
SELECT @vet_id = user_id FROM Users WHERE username='vet2';
INSERT INTO VetVisit(booking_id, pet_id, owner_id, vet_staff_id, visit_type_code, visit_date, weight_kg, temperature_c, symptoms, diagnosis_summary, treatment_notes, follow_up_date)
VALUES (@booking_id, @pet_id, @owner_id, @vet_id, 'CHECKUP', '2025-11-03 10:30', 1.5, 38.8, N'Kiểm tra răng thỏ', N'Răng mọc đều, bình thường', N'Cho ăn thêm cỏ khô', NULL);

-- Visit 5: Rocket (Confirmed Booking)
SELECT @pet_id = pet_id, @owner_id = owner_id FROM Pets WHERE name=N'Rocket';
SELECT @booking_id = booking_id FROM Booking WHERE pet_id=@pet_id AND current_status='CONFIRMED';
SELECT @vet_id = user_id FROM Users WHERE username='vet3';
INSERT INTO VetVisit(booking_id, pet_id, owner_id, vet_staff_id, visit_type_code, visit_date, weight_kg, temperature_c, symptoms, diagnosis_summary, treatment_notes, follow_up_date)
VALUES (@booking_id, @pet_id, @owner_id, @vet_id, 'CHECKUP', '2025-11-04 11:00', 0.5, 39.0, N'Khám định kỳ cho chim', N'Lông mượt, hoạt bát', N'Sức khỏe tốt', NULL);

-- Visit 6: Jerry (Walk-in Emergency)
SELECT @pet_id = pet_id, @owner_id = owner_id FROM Pets WHERE name='Jerry';
SELECT @vet_id = user_id FROM Users WHERE username='vet1';
INSERT INTO VetVisit(booking_id, pet_id, owner_id, vet_staff_id, visit_type_code, visit_date, weight_kg, temperature_c, symptoms, diagnosis_summary, treatment_notes, follow_up_date)
VALUES (NULL, @pet_id, @owner_id, @vet_id, 'EMERGENCY', '2025-10-15 08:00', 15.0, 39.8, N'Nôn mửa, tiêu chảy cấp', N'Viêm ruột cấp (Parvo test Âm tính)', N'Truyền dịch, tiêm kháng sinh, nhịn ăn 12h', '2025-10-17');

-- Visit 7: Kiki (Walk-in Ultrasound)
SELECT @pet_id = pet_id, @owner_id = owner_id FROM Pets WHERE name=N'Kiki';
SELECT @vet_id = user_id FROM Users WHERE username='vet2';
INSERT INTO VetVisit(booking_id, pet_id, owner_id, vet_staff_id, visit_type_code, visit_date, weight_kg, temperature_c, symptoms, diagnosis_summary, treatment_notes, follow_up_date)
VALUES (NULL, @pet_id, @owner_id, @vet_id, 'ULTRASOUND', '2025-10-20 14:00', 4.2, 38.7, N'Nghi ngờ có thai', N'Siêu âm thấy 3 túi thai, ~30 ngày tuổi', N'Bổ sung dinh dưỡng cho mèo mẹ', '2025-11-10');

-- Visit 8: Vàng (Walk-in Surgery)
SELECT @pet_id = pet_id, @owner_id = owner_id FROM Pets WHERE name=N'Vàng';
SELECT @vet_id = user_id FROM Users WHERE username='vet3';
INSERT INTO VetVisit(booking_id, pet_id, owner_id, vet_staff_id, visit_type_code, visit_date, weight_kg, temperature_c, symptoms, diagnosis_summary, treatment_notes, follow_up_date)
VALUES (NULL, @pet_id, @owner_id, @vet_id, 'SURGERY', '2025-10-22 09:00', 22.0, 38.5, N'Triệt sản chó đực', N'Phẫu thuật triệt sản', N'Đã phẫu thuật thành công, giữ vết mổ sạch', '2025-10-29');

-- Visit 9: Bông (Walk-in Checkup)
SELECT @pet_id = pet_id, @owner_id = owner_id FROM Pets WHERE name=N'Bông';
SELECT @vet_id = user_id FROM Users WHERE username='vet1';
INSERT INTO VetVisit(booking_id, pet_id, owner_id, vet_staff_id, visit_type_code, visit_date, weight_kg, temperature_c, symptoms, diagnosis_summary, treatment_notes, follow_up_date)
VALUES (NULL, @pet_id, @owner_id, @vet_id, 'CHECKUP', '2025-10-23 11:00', 5.2, 39.1, N'Ho nhẹ, chảy nước mũi', N'Viêm hô hấp trên (Cúm chó)', N'Kê đơn kháng sinh 5 ngày', '2025-10-28');

-- Visit 10: Luna (Walk-in Surgery)
SELECT @pet_id = pet_id, @owner_id = owner_id FROM Pets WHERE name=N'Luna';
SELECT @vet_id = user_id FROM Users WHERE username='vet3';
INSERT INTO VetVisit(booking_id, pet_id, owner_id, vet_staff_id, visit_type_code, visit_date, weight_kg, temperature_c, symptoms, diagnosis_summary, treatment_notes, follow_up_date)
VALUES (NULL, @pet_id, @owner_id, @vet_id, 'SURGERY', '2025-10-24 10:00', 4.1, 38.6, N'Triệt sản mèo cái', N'Phẫu thuật triệt sản (Nội soi)', N'Đã phẫu thuật thành công, theo dõi tại nhà', '2025-10-31');
GO

/* ==================== 11. REVIEWS (Target: 12) (VIẾT LẠI V9) ==================== */
PRINT 'Inserting 12 Reviews (Services, Staff, Products) (Robust Method)...';
GO

-- 4 Review Dịch vụ
INSERT INTO Reviews(service_id, product_id, staff_id, customer_id, rating, comment)
VALUES
((SELECT service_id FROM Services WHERE service_code='GRM_SPA'), NULL, NULL, (SELECT user_id FROM Users WHERE username='customer4'), 5, N'Dịch vụ Spa rất tuyệt, bé Kiki nhà mình rất thích.'),
((SELECT service_id FROM Services WHERE service_code='HLT_CHECK'), NULL, NULL, (SELECT user_id FROM Users WHERE username='customer5'), 5, N'Khám tổng quát nhanh, bác sĩ tư vấn kỹ.'),
((SELECT service_id FROM Services WHERE service_code='BOARD_VIP'), NULL, NULL, (SELECT user_id FROM Users WHERE username='customer6'), 4, N'Dịch vụ lưu trú VIP tốt, có camera xem 24/24. Sẽ dùng lại.'),
((SELECT service_id FROM Services WHERE service_code='HLT_VACCINE'), NULL, NULL, (SELECT user_id FROM Users WHERE username='customer6'), 5, N'Tiêm phòng nhanh, hẹn lịch nhắc nhở đầy đủ.');
GO

-- 4 Review Nhân viên
INSERT INTO Reviews(service_id, product_id, staff_id, customer_id, rating, comment)
VALUES
(NULL, NULL, (SELECT user_id FROM Users WHERE username='vet1'), (SELECT user_id FROM Users WHERE username='customer6'), 5, N'Bác sĩ 1 (Trần Bác Sĩ 1) rất có tâm, chữa cho bé Jerry nhà mình khỏi ốm.'),
(NULL, NULL, (SELECT user_id FROM Users WHERE username='vet2'), (SELECT user_id FROM Users WHERE username='customer4'), 5, N'Bác sĩ Tuấn siêu âm thai cho Kiki rất kỹ, dặn dò cẩn thận.'),
(NULL, NULL, (SELECT user_id FROM Users WHERE username='vet3'), (SELECT user_id FROM Users WHERE username='customer3'), 5, N'Bác sĩ Lan phẫu thuật triệt sản mát tay, bé Vàng hồi phục nhanh.'),
(NULL, NULL, (SELECT user_id FROM Users WHERE username='staff1'), (SELECT user_id FROM Users WHERE username='customer4'), 4, N'Bạn Groomer (Lê Nhân Viên 1) cắt tỉa khéo tay.');
GO

-- 4 Review Sản phẩm
INSERT INTO Reviews(service_id, product_id, staff_id, customer_id, rating, comment)
VALUES
(NULL, (SELECT product_id FROM Product WHERE product_code='RC_MINIPUPPY'), NULL, (SELECT user_id FROM Users WHERE username='customer1'), 5, N'Bé Bông nhà mình rất thích ăn loại này.'),
(NULL, (SELECT product_id FROM Product WHERE product_code='RC_KITTEN'), NULL, (SELECT user_id FROM Users WHERE username='customer2'), 4, N'Hạt tốt, nhưng giá hơi cao so với các loại khác.'),
(NULL, (SELECT product_id FROM Product WHERE product_code='NEX_SPECTRA'), NULL, (SELECT user_id FROM Users WHERE username='customer3'), 5, N'Dùng viên nhai này rất tiện, bé Vàng hết sạch ve.'),
(NULL, (SELECT product_id FROM Product WHERE product_code='KONG_CLASSIC'), NULL, (SELECT user_id FROM Users WHERE username='customer4'), 5, N'Siêu bền! Chó nhà mình cắn không hỏng.');
GO

/* ==================== 12. CONSULTATION REQUESTS ==================== */
PRINT 'Bảng ConsultationRequests được giữ trống theo yêu cầu.';
GO

PRINT '===============================================';
PRINT ' SCRIPT 2: CHÈN DỮ LIỆU MẪU (V9) HOÀN TẤT!';
PRINT '===============================================';
GO