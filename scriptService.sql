/********************************************************************
 Database: SweetmalPetCare
 Version: 3
*********************************************************************/
IF DB_ID('SweetimalPetCare') IS NOT NULL
BEGIN
    ALTER DATABASE SweetimalPetCare SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE SweetimalPetCare;
END
GO
CREATE DATABASE SweetimalPetCare;
GO
USE SweetimalPetCare;
GO

/* ============== SECURITY / USERS & AUTH ============== */
CREATE TABLE Roles (
    role_id         INT IDENTITY PRIMARY KEY,
    role_name       NVARCHAR(50) NOT NULL UNIQUE,
    description     NVARCHAR(255)
);

CREATE TABLE Permissions (
    permission_id   INT IDENTITY PRIMARY KEY,
    permission_code NVARCHAR(100) NOT NULL UNIQUE,
    description     NVARCHAR(255)
);

CREATE TABLE RolePermissions (
    role_id         INT NOT NULL FOREIGN KEY REFERENCES Roles(role_id),
    permission_id   INT NOT NULL FOREIGN KEY REFERENCES Permissions(permission_id),
    CONSTRAINT PK_RolePermissions PRIMARY KEY (role_id, permission_id)
);

CREATE TABLE Users (
    user_id         BIGINT IDENTITY PRIMARY KEY,
    username        NVARCHAR(50) NOT NULL UNIQUE,
    email           NVARCHAR(150) NOT NULL UNIQUE,
    phone           NVARCHAR(20),
    password_hash   nvarchar(255) NOT NULL,
    full_name       NVARCHAR(120),
    gender          INT,
    birthday        DATE NULL,
    is_active       BIT NOT NULL DEFAULT 1,
    avatar_url      NVARCHAR(300),
    role_id         INT NOT NULL FOREIGN KEY REFERENCES Roles(role_id),
    created_at      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    updated_at      DATETIME2 NULL
);
CREATE INDEX IX_Users_Role ON Users(role_id);

CREATE TABLE StaffProfile (
    staff_id        BIGINT PRIMARY KEY FOREIGN KEY REFERENCES Users(user_id),
    position_title  NVARCHAR(80),
    specialty       NVARCHAR(150),
    license_number  NVARCHAR(50),
    hire_date       DATE,
    rating_average  DECIMAL(3,2) NULL,
    is_veterinarian BIT NOT NULL DEFAULT 0
);

/* ============== ADDRESS & LOCATION ============== */
CREATE TABLE UserAddress (
    address_id      BIGINT IDENTITY PRIMARY KEY,
    user_id         BIGINT NOT NULL FOREIGN KEY REFERENCES Users(user_id),
    label           NVARCHAR(50),
    recipient_name  NVARCHAR(120),
    phone           NVARCHAR(20),
    address_line1   NVARCHAR(150) NOT NULL,
    address_line2   NVARCHAR(150),
    ward            NVARCHAR(80),
    district        NVARCHAR(80),
    city            NVARCHAR(80),
    province        NVARCHAR(80),
    country         NVARCHAR(80) DEFAULT N'Vietnam',
    postal_code     NVARCHAR(20),
    is_default      BIT NOT NULL DEFAULT 0,
    created_at      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
CREATE INDEX IX_UserAddress_User ON UserAddress(user_id);

/* ============== PET DOMAIN ============== */
CREATE TABLE PetSpecies (
    species_id      INT IDENTITY PRIMARY KEY,
    species_name    NVARCHAR(50) NOT NULL UNIQUE,
    description     NVARCHAR(255)
);

CREATE TABLE PetBreed (
    breed_id        INT IDENTITY PRIMARY KEY,
    species_id      INT NOT NULL FOREIGN KEY REFERENCES PetSpecies(species_id),
    breed_name      NVARCHAR(80) NOT NULL,
    description     NVARCHAR(255),
    CONSTRAINT UQ_PetBreed UNIQUE (species_id, breed_name)
);

CREATE TABLE Pets (
    pet_id          BIGINT IDENTITY PRIMARY KEY,
    owner_id        BIGINT NOT NULL FOREIGN KEY REFERENCES Users(user_id),
    name            NVARCHAR(80) NOT NULL,
    species_id      INT NOT NULL FOREIGN KEY REFERENCES PetSpecies(species_id),
    breed_id        INT NULL FOREIGN KEY REFERENCES PetBreed(breed_id),
    gender          CHAR(1) CHECK (gender IN ('M','F','O')),
    birthdate       DATE,
    weight_kg       DECIMAL(6,2),
    color           NVARCHAR(50),
    notes           NVARCHAR(255),
    created_at      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
CREATE INDEX IX_Pets_Owner ON Pets(owner_id);

/* ============== SERVICE DOMAIN ============== */
CREATE TABLE ServiceCategory (
    service_category_id INT IDENTITY PRIMARY KEY,
    category_name       NVARCHAR(100) NOT NULL UNIQUE,
    description         NVARCHAR(255)
);

CREATE TABLE Services (
    service_id      BIGINT IDENTITY PRIMARY KEY,
    service_category_id INT NOT NULL FOREIGN KEY REFERENCES ServiceCategory(service_category_id),
    service_code    NVARCHAR(50) NOT NULL UNIQUE,
    service_name    NVARCHAR(150) NOT NULL,
    description     NVARCHAR(MAX),
    base_duration_min INT NOT NULL CHECK (base_duration_min > 0),
    status          VARCHAR(20) NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE','INACTIVE')),
    created_at      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

CREATE TABLE ServicePriceHistory (
    price_id        BIGINT IDENTITY PRIMARY KEY,
    service_id      BIGINT NOT NULL FOREIGN KEY REFERENCES Services(service_id),
    effective_from  DATETIME2 NOT NULL,
    effective_to    DATETIME2 NULL,
    price           DECIMAL(12,2) NOT NULL CHECK (price >= 0),
    currency        CHAR(3) NOT NULL DEFAULT 'VND',
    created_at      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT UQ_ServicePriceHistory UNIQUE (service_id, effective_from)
);

CREATE TABLE ServicePackage (
    package_id      BIGINT IDENTITY PRIMARY KEY,
    package_code    NVARCHAR(50) NOT NULL UNIQUE,
    package_name    NVARCHAR(150) NOT NULL,
    description     NVARCHAR(500),
    status          VARCHAR(20) NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE','INACTIVE')),
    package_price   DECIMAL(12,2) NOT NULL CHECK (package_price >= 0),
    created_at      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

CREATE TABLE PackageItem (
    package_id      BIGINT NOT NULL FOREIGN KEY REFERENCES ServicePackage(package_id),
    service_id      BIGINT NOT NULL FOREIGN KEY REFERENCES Services(service_id),
    quantity        INT NOT NULL DEFAULT 1 CHECK (quantity > 0),
    CONSTRAINT PK_PackageItem PRIMARY KEY (package_id, service_id)
);

/* ============== BOOKING / SCHEDULING ============== */
CREATE TABLE BookingStatus (
    booking_status_code VARCHAR(30) PRIMARY KEY,
    description         NVARCHAR(150)
);
INSERT INTO BookingStatus(booking_status_code, description)
VALUES ('PENDING',N'Chờ xác nhận'),
       ('CONFIRMED',N'Đã xác nhận'),
       ('IN_PROGRESS',N'Đang thực hiện'),
       ('COMPLETED',N'Hoàn tất'),
       ('CANCELLED',N'Đã hủy'),
       ('NO_SHOW',N'Không đến');

CREATE TABLE Booking (
    booking_id      BIGINT IDENTITY PRIMARY KEY,
    customer_id     BIGINT NOT NULL FOREIGN KEY REFERENCES Users(user_id),
    pet_id          BIGINT NOT NULL FOREIGN KEY REFERENCES Pets(pet_id),
    service_id      BIGINT NULL FOREIGN KEY REFERENCES Services(service_id),
    package_id      BIGINT NULL FOREIGN KEY REFERENCES ServicePackage(package_id),
    booking_time    DATETIME2 NOT NULL,
    requested_date  DATE NOT NULL,
    requested_start TIME NOT NULL,
    notes           NVARCHAR(500),
    current_status  VARCHAR(30) NOT NULL FOREIGN KEY REFERENCES BookingStatus(booking_status_code),
    total_price     DECIMAL(12,2) NULL,
    created_at      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    updated_at      DATETIME2 NULL,
    CONSTRAINT CK_Booking_ServiceOrPackage CHECK (
        (service_id IS NOT NULL AND package_id IS NULL)
        OR (service_id IS NULL AND package_id IS NOT NULL)
    )
);

CREATE TABLE BookingStatusHistory (
    booking_status_history_id BIGINT IDENTITY PRIMARY KEY,
    booking_id      BIGINT NOT NULL FOREIGN KEY REFERENCES Booking(booking_id),
    status_code     VARCHAR(30) NOT NULL,
    changed_at      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    changed_by      BIGINT NULL FOREIGN KEY REFERENCES Users(user_id),
    comment         NVARCHAR(255)
);
CREATE INDEX IX_BookingStatusHistory_Booking ON BookingStatusHistory(booking_id);

CREATE TABLE ScheduleSlot (
    slot_id         BIGINT IDENTITY PRIMARY KEY,
    booking_id      BIGINT NULL FOREIGN KEY REFERENCES Booking(booking_id),
    staff_id        BIGINT NULL FOREIGN KEY REFERENCES Users(user_id),
    room_name       NVARCHAR(50),
    start_time      DATETIME2 NOT NULL,
    end_time        DATETIME2 NOT NULL,
    status          VARCHAR(20) NOT NULL DEFAULT 'OPEN' CHECK (status IN ('OPEN','BOOKED','DONE','CANCELLED')),
    created_at      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
CREATE INDEX IX_ScheduleSlot_Staff ON ScheduleSlot(staff_id, start_time);

CREATE TABLE BookingStaffAssignment (
    booking_id      BIGINT NOT NULL FOREIGN KEY REFERENCES Booking(booking_id),
    staff_id        BIGINT NOT NULL FOREIGN KEY REFERENCES Users(user_id),
    role_in_service NVARCHAR(50),
    CONSTRAINT PK_BookingStaffAssignment PRIMARY KEY (booking_id, staff_id)
);

/* ============== PRODUCTS & INVENTORY ============== */
CREATE TABLE ProductCategory (
    product_category_id INT IDENTITY PRIMARY KEY,
    category_name       NVARCHAR(100) NOT NULL,
    parent_id           INT NULL FOREIGN KEY REFERENCES ProductCategory(product_category_id),
    description         NVARCHAR(255),
    CONSTRAINT UQ_ProductCategory UNIQUE (category_name, parent_id)
);

CREATE TABLE Brand (
    brand_id        INT IDENTITY PRIMARY KEY,
    brand_name      NVARCHAR(100) NOT NULL UNIQUE,
    description     NVARCHAR(255)
);

CREATE TABLE Product (
    product_id      BIGINT IDENTITY PRIMARY KEY,
    product_code    NVARCHAR(50) NOT NULL UNIQUE,
    product_name    NVARCHAR(150) NOT NULL,
    product_category_id INT NOT NULL FOREIGN KEY REFERENCES ProductCategory(product_category_id),
    brand_id        INT NULL FOREIGN KEY REFERENCES Brand(brand_id),
    description     NVARCHAR(MAX),
    is_active       BIT NOT NULL DEFAULT 1,
    created_at      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

CREATE TABLE ProductVariant (
    variant_id      BIGINT IDENTITY PRIMARY KEY,
    product_id      BIGINT NOT NULL FOREIGN KEY REFERENCES Product(product_id),
    sku             NVARCHAR(60) NOT NULL UNIQUE,
    attribute_json  NVARCHAR(500),
    price           DECIMAL(12,2) NOT NULL,
    cost            DECIMAL(12,2) NULL,
    stock_quantity  INT NOT NULL DEFAULT 0,
    sold_quantity   INT NOT NULL DEFAULT 0,
    image_url       NVARCHAR(300),
    is_active       BIT NOT NULL DEFAULT 1,
    created_at      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
CREATE INDEX IX_ProductVariant_Product ON ProductVariant(product_id);

CREATE TABLE InventoryLocation (
    location_id     INT IDENTITY PRIMARY KEY,
    location_code   NVARCHAR(50) NOT NULL UNIQUE,
    name            NVARCHAR(100),
    address         NVARCHAR(255)
);

CREATE TABLE InventoryTransactionType (
    txn_type_code   VARCHAR(30) PRIMARY KEY,
    description     NVARCHAR(150),
    direction       CHAR(1) NOT NULL CHECK (direction IN ('+','-'))
);
INSERT INTO InventoryTransactionType(txn_type_code, description, direction)
VALUES ('PURCHASE',N'Nhập mua', '+'),
       ('ADJUST_IN',N'Điều chỉnh tăng', '+'),
       ('ADJUST_OUT',N'Điều chỉnh giảm', '-'),
       ('SALE',N'Bán hàng', '-'),
       ('ORDER_RESERVE',N'Giữ chỗ đơn hàng', '-'),
       ('RETURN_IN',N'Khách trả lại', '+');

CREATE TABLE InventoryTransaction (
    inventory_txn_id BIGINT IDENTITY PRIMARY KEY,
    variant_id      BIGINT NOT NULL FOREIGN KEY REFERENCES ProductVariant(variant_id),
    location_id     INT NOT NULL FOREIGN KEY REFERENCES InventoryLocation(location_id),
    txn_type_code   VARCHAR(30) NOT NULL FOREIGN KEY REFERENCES InventoryTransactionType(txn_type_code),
    quantity        INT NOT NULL CHECK (quantity > 0),
    reference_no    NVARCHAR(60),
    note            NVARCHAR(255),
    created_at      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    created_by      BIGINT NULL FOREIGN KEY REFERENCES Users(user_id)
);
CREATE INDEX IX_InventoryTransaction_Variant ON InventoryTransaction(variant_id, created_at);

/* ============== CART (TỐI GIẢN) & ORDERS ============== */
/* Chỉ còn 1 bảng CartItem */
CREATE TABLE CartItem (
    cart_item_id BIGINT IDENTITY PRIMARY KEY,
    customer_id  BIGINT NOT NULL FOREIGN KEY REFERENCES Users(user_id),
    variant_id   BIGINT NOT NULL FOREIGN KEY REFERENCES ProductVariant(variant_id),
    quantity     INT NOT NULL CHECK (quantity > 0),
    added_at     DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT UQ_CartItem UNIQUE (customer_id, variant_id)
);
CREATE INDEX IX_CartItem_Customer ON CartItem(customer_id);

CREATE TABLE OrderStatus (
    order_status_code VARCHAR(30) PRIMARY KEY,
    description       NVARCHAR(150)
);
INSERT INTO OrderStatus(order_status_code, description)
VALUES ('PENDING',N'Chờ xử lý'),
       ('PAID',N'Đã thanh toán'),
       ('PROCESSING',N'Đang xử lý'),
       ('SHIPPED',N'Đã gửi'),
       ('COMPLETED',N'Hoàn tất'),
       ('CANCELLED',N'Hủy'),
       ('REFUNDED',N'Hoàn tiền');

CREATE TABLE Orders (
    order_id        BIGINT IDENTITY PRIMARY KEY,
    order_code      NVARCHAR(50) NOT NULL UNIQUE,
    customer_id     BIGINT NOT NULL FOREIGN KEY REFERENCES Users(user_id),
    shipping_address_id BIGINT NULL FOREIGN KEY REFERENCES UserAddress(address_id),
    order_status    VARCHAR(30) NOT NULL FOREIGN KEY REFERENCES OrderStatus(order_status_code),
    subtotal_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
    discount_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
    shipping_fee    DECIMAL(12,2) NOT NULL DEFAULT 0,
    tax_amount      DECIMAL(12,2) NOT NULL DEFAULT 0,
    total_amount    DECIMAL(12,2) NOT NULL DEFAULT 0,
    currency        CHAR(3) NOT NULL DEFAULT 'VND',
    created_at      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    updated_at      DATETIME2 NULL
);

CREATE TABLE OrderItems (
    order_item_id   BIGINT IDENTITY PRIMARY KEY,
    order_id        BIGINT NOT NULL FOREIGN KEY REFERENCES Orders(order_id),
    variant_id      BIGINT NOT NULL FOREIGN KEY REFERENCES ProductVariant(variant_id),
    unit_price      DECIMAL(12,2) NOT NULL,
    quantity        INT NOT NULL CHECK (quantity > 0),
    line_total      AS (unit_price * quantity) PERSISTED
);
CREATE INDEX IX_OrderItems_Order ON OrderItems(order_id);

CREATE TABLE OrderStatusHistory (
    order_status_history_id BIGINT IDENTITY PRIMARY KEY,
    order_id        BIGINT NOT NULL FOREIGN KEY REFERENCES Orders(order_id),
    status_code     VARCHAR(30) NOT NULL,
    changed_at      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    changed_by      BIGINT NULL FOREIGN KEY REFERENCES Users(user_id),
    note            NVARCHAR(255)
);

CREATE TABLE Shipping (
    shipping_id     BIGINT IDENTITY PRIMARY KEY,
    order_id        BIGINT NOT NULL FOREIGN KEY REFERENCES Orders(order_id),
    carrier_name    NVARCHAR(80),
    tracking_number NVARCHAR(100),
    shipped_at      DATETIME2 NULL,
    delivered_at    DATETIME2 NULL,
    status          VARCHAR(30) NULL,
    note            NVARCHAR(255)
);

CREATE TABLE PaymentMethod (
    payment_method_code VARCHAR(30) PRIMARY KEY,
    description         NVARCHAR(100)
);
INSERT INTO PaymentMethod(payment_method_code, description)
VALUES ('CASH',N'Tiền mặt'),
       ('BANK',N'Chuyển khoản'),
       ('CARD',N'Thẻ'),
       ('EWALLET',N'Ví điện tử');

CREATE TABLE Payments (
    payment_id      BIGINT IDENTITY PRIMARY KEY,
    order_id        BIGINT NULL FOREIGN KEY REFERENCES Orders(order_id),
    booking_id      BIGINT NULL FOREIGN KEY REFERENCES Booking(booking_id),
    payment_method_code VARCHAR(30) NOT NULL FOREIGN KEY REFERENCES PaymentMethod(payment_method_code),
    amount          DECIMAL(12,2) NOT NULL CHECK (amount >= 0),
    status          VARCHAR(30) NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING','SUCCESS','FAILED','REFUNDED')),
    transaction_ref NVARCHAR(100),
    paid_at         DATETIME2 NULL,
    created_at      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT CK_Payments_OrderOrBooking CHECK (
        (order_id IS NOT NULL AND booking_id IS NULL)
        OR (order_id IS NULL AND booking_id IS NOT NULL)
    )
);

CREATE TABLE Invoice (
    invoice_id      BIGINT IDENTITY PRIMARY KEY,
    invoice_code    NVARCHAR(50) NOT NULL UNIQUE,
    order_id        BIGINT NULL FOREIGN KEY REFERENCES Orders(order_id),
    booking_id      BIGINT NULL FOREIGN KEY REFERENCES Booking(booking_id),
    issue_date      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    total_amount    DECIMAL(12,2) NOT NULL,
    tax_amount      DECIMAL(12,2) NOT NULL DEFAULT 0,
    note            NVARCHAR(255),
    CONSTRAINT CK_Invoice_OrderOrBooking CHECK (
        (order_id IS NOT NULL AND booking_id IS NULL)
        OR (order_id IS NULL AND booking_id IS NOT NULL)
    )
);

/* ============== VETERINARY / MEDICAL ============== */
CREATE TABLE VetVisitType (
    visit_type_code VARCHAR(30) PRIMARY KEY,
    description     NVARCHAR(150)
);
INSERT INTO VetVisitType(visit_type_code, description)
VALUES ('CHECKUP',N'Khám tổng quát'),
       ('VACCINE',N'Tiêm phòng'),
       ('SURGERY',N'Phẫu thuật'),
       ('EMERGENCY',N'Cấp cứu'),
       ('GROOM_MED',N'Chăm sóc y tế nhẹ');

CREATE TABLE VetVisit (
    visit_id        BIGINT IDENTITY PRIMARY KEY,
    booking_id      BIGINT NULL FOREIGN KEY REFERENCES Booking(booking_id),
    pet_id          BIGINT NOT NULL FOREIGN KEY REFERENCES Pets(pet_id),
    owner_id        BIGINT NOT NULL FOREIGN KEY REFERENCES Users(user_id),
    vet_staff_id    BIGINT NOT NULL FOREIGN KEY REFERENCES Users(user_id),
    visit_type_code VARCHAR(30) NOT NULL FOREIGN KEY REFERENCES VetVisitType(visit_type_code),
    visit_date      DATETIME2 NOT NULL,
    weight_kg       DECIMAL(6,2),
    temperature_c   DECIMAL(4,1),
    symptoms        NVARCHAR(500),
    notes           NVARCHAR(1000),
    created_at      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

CREATE TABLE Diagnosis (
    diagnosis_id    BIGINT IDENTITY PRIMARY KEY,
    visit_id        BIGINT NOT NULL FOREIGN KEY REFERENCES VetVisit(visit_id),
    diagnosis_code  NVARCHAR(50),
    description     NVARCHAR(500),
    severity        TINYINT NULL CHECK (severity BETWEEN 1 AND 5)
);

CREATE TABLE MedicalRecord (
    record_id       BIGINT IDENTITY PRIMARY KEY,
    pet_id          BIGINT NOT NULL FOREIGN KEY REFERENCES Pets(pet_id),
    visit_id        BIGINT NOT NULL FOREIGN KEY REFERENCES VetVisit(visit_id),
    summary         NVARCHAR(1000),
    follow_up_date  DATE NULL,
    created_at      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

CREATE TABLE VaccinationRecord (
    vaccination_id  BIGINT IDENTITY PRIMARY KEY,
    visit_id        BIGINT NOT NULL FOREIGN KEY REFERENCES VetVisit(visit_id),
    vaccine_name    NVARCHAR(100) NOT NULL,
    batch_number    NVARCHAR(50),
    administered_at DATETIME2 NOT NULL,
    next_due_date   DATE NULL
);

CREATE TABLE Prescription (
    prescription_id BIGINT IDENTITY PRIMARY KEY,
    visit_id        BIGINT NOT NULL FOREIGN KEY REFERENCES VetVisit(visit_id),
    instructions    NVARCHAR(1000),
    created_at      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

CREATE TABLE PrescriptionItem (
    prescription_item_id BIGINT IDENTITY PRIMARY KEY,
    prescription_id      BIGINT NOT NULL FOREIGN KEY REFERENCES Prescription(prescription_id),
    product_variant_id   BIGINT NULL FOREIGN KEY REFERENCES ProductVariant(variant_id),
    medicine_name        NVARCHAR(150) NULL,
    dosage               NVARCHAR(100),
    frequency            NVARCHAR(100),
    duration_days        INT,
    CONSTRAINT CK_PrescriptionItem_Name CHECK (
        product_variant_id IS NOT NULL OR medicine_name IS NOT NULL
    )
);
CREATE UNIQUE INDEX UQ_PrescriptionItem_Variant
    ON PrescriptionItem(prescription_id, product_variant_id)
    WHERE product_variant_id IS NOT NULL;
CREATE UNIQUE INDEX UQ_PrescriptionItem_MedName
    ON PrescriptionItem(prescription_id, medicine_name)
    WHERE medicine_name IS NOT NULL;

/* ============== FEEDBACK / REVIEWS ============== */
CREATE TABLE ReviewTargetType (
    target_type_code VARCHAR(30) PRIMARY KEY,
    description      NVARCHAR(150)
);
INSERT INTO ReviewTargetType(target_type_code, description)
VALUES ('SERVICE',N'Dịch vụ'),
       ('PRODUCT',N'Sản phẩm'),
       ('VET_VISIT',N'Lần khám');

CREATE TABLE Reviews (
    review_id       BIGINT IDENTITY PRIMARY KEY,
    target_type_code VARCHAR(30) NOT NULL FOREIGN KEY REFERENCES ReviewTargetType(target_type_code),
    target_id       BIGINT NOT NULL,
    customer_id     BIGINT NOT NULL FOREIGN KEY REFERENCES Users(user_id),
    rating          TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment         NVARCHAR(1000),
    created_at      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
CREATE INDEX IX_Reviews_Target ON Reviews(target_type_code, target_id);

/* ============== AUDIT / LOGGING ============== */
CREATE TABLE AuditLog (
    audit_id        BIGINT IDENTITY PRIMARY KEY,
    user_id         BIGINT NULL FOREIGN KEY REFERENCES Users(user_id),
    action_code     NVARCHAR(50) NOT NULL,
    entity_name     NVARCHAR(100),
    entity_id       NVARCHAR(50),
    detail_json     NVARCHAR(MAX),
    created_at      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

/* ============== TRIGGERS ============== */
GO
CREATE OR ALTER TRIGGER TRG_OrderItems_AfterInsert
ON OrderItems
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE pv
        SET pv.sold_quantity = pv.sold_quantity + i.quantity,
            pv.stock_quantity = pv.stock_quantity - i.quantity
    FROM ProductVariant pv
    JOIN inserted i ON pv.variant_id = i.variant_id;

    INSERT INTO InventoryTransaction(variant_id, location_id, txn_type_code, quantity, reference_no, note)
    SELECT i.variant_id, 1, 'SALE', i.quantity, o.order_code, N'Auto from order'
    FROM inserted i
    JOIN Orders o ON o.order_id = i.order_id;
END
GO

/* ============== SAMPLE DATA ============== */
-- Roles & Permissions
INSERT INTO Roles(role_name, description) VALUES
(N'Customer',N'Khách hàng'),
(N'Staff',N'Nhân viên chung'),
(N'Vet',N'Bác sĩ thú y'),
(N'Admin',N'Quản trị');

INSERT INTO Permissions(permission_code, description) VALUES
('VIEW_PRODUCTS',N'Xem sản phẩm'),
('MANAGE_PRODUCTS',N'Quản lý sản phẩm'),
('VIEW_ORDERS',N'Xem đơn hàng'),
('MANAGE_ORDERS',N'Quản lý đơn hàng'),
('VIEW_BOOKING',N'Xem booking'),
('MANAGE_BOOKING',N'Quản lý booking'),
('VIEW_MEDICAL',N'Xem hồ sơ y tế'),
('MANAGE_MEDICAL',N'Quản lý hồ sơ y tế');

INSERT INTO RolePermissions(role_id, permission_id)
SELECT r.role_id, p.permission_id
FROM Roles r CROSS JOIN Permissions p
WHERE r.role_name = N'Admin';

-- Users
INSERT INTO Users(username, email, password_hash, full_name, role_id, gender, birthday)
SELECT 'customer1','customer1@example.com', 0x01, N'Nguyễn Khách 1', role_id, 1,'1995-05-10' FROM Roles WHERE role_name='Customer';
INSERT INTO Users(username, email, password_hash, full_name, role_id, gender)
SELECT 'staff1','staff1@example.com', 0x02, N'Lê Nhân Viên 1', role_id, 2 FROM Roles WHERE role_name='Staff';
INSERT INTO Users(username, email, password_hash, full_name, role_id, gender)
SELECT 'vet1','vet1@example.com', 0x03, N'Trần Bác Sĩ 1', role_id, 1 FROM Roles WHERE role_name='Vet';
INSERT INTO Users(username, email, password_hash, full_name, role_id, gender)
SELECT 'admin','admin@example.com', 0x04, N'Quản Trị', role_id, 0 FROM Roles WHERE role_name='Admin';

INSERT INTO StaffProfile(staff_id, position_title, specialty, license_number, hire_date, is_veterinarian)
SELECT user_id, N'Groomer', N'Grooming', NULL, '2024-01-01', 0 FROM Users WHERE username='staff1';
INSERT INTO StaffProfile(staff_id, position_title, specialty, license_number, hire_date, is_veterinarian)
SELECT user_id, N'Bác sĩ', N'Thú y tổng quát', 'VET123', '2023-10-01', 1 FROM Users WHERE username='vet1';

-- Address
INSERT INTO UserAddress(user_id,label,recipient_name,phone,address_line1,city,province,is_default)
SELECT user_id,N'Nhà',full_name, N'0900000001',N'123 Đường A',N'HCM',N'HCM',1 FROM Users WHERE username='customer1';

-- Pets
INSERT INTO PetSpecies(species_name) VALUES (N'Chó'),(N'Mèo');
INSERT INTO PetBreed(species_id, breed_name) 
SELECT species_id, N'Poodle' FROM PetSpecies WHERE species_name=N'Chó';
INSERT INTO PetBreed(species_id, breed_name) 
SELECT species_id, N'Anh lông ngắn' FROM PetSpecies WHERE species_name=N'Mèo';

INSERT INTO Pets(owner_id,name,species_id,breed_id,gender,birthdate,weight_kg)
SELECT (SELECT user_id FROM Users WHERE username='customer1'),
       N'Bông',(SELECT species_id FROM PetSpecies WHERE species_name=N'Chó'),
       (SELECT TOP 1 breed_id FROM PetBreed WHERE breed_name=N'Poodle'),
       'F','2022-05-01',5.2;

-- Services & price
INSERT INTO ServiceCategory(category_name, description)
VALUES (N'Grooming',N'Tắm, cắt tỉa'),
       (N'Boarding',N'Lưu trú'),
       (N'Health',N'Dịch vụ y tế');

INSERT INTO Services(service_category_id, service_code, service_name, description, base_duration_min)
SELECT service_category_id,'GRM_BASIC',N'Grooming cơ bản',N'Tắm & sấy',60
FROM ServiceCategory WHERE category_name=N'Grooming';

INSERT INTO Services(service_category_id, service_code, service_name, description, base_duration_min)
SELECT service_category_id,'HLT_CHECK',N'Khám tổng quát',N'Khám sức khỏe',30
FROM ServiceCategory WHERE category_name=N'Health';

INSERT INTO ServicePriceHistory(service_id,effective_from,price)
SELECT service_id,'2024-01-01',150000 FROM Services WHERE service_code='GRM_BASIC';
INSERT INTO ServicePriceHistory(service_id,effective_from,price)
SELECT service_id,'2024-01-01',200000 FROM Services WHERE service_code='HLT_CHECK';

INSERT INTO ServicePackage(package_code, package_name, description, package_price)
VALUES ('PKG_GROOM3',N'Combo Groom 3 lần',N'3 lần grooming cơ bản',420000);

INSERT INTO PackageItem(package_id, service_id, quantity)
SELECT (SELECT package_id FROM ServicePackage WHERE package_code='PKG_GROOM3'),
       (SELECT service_id FROM Services WHERE service_code='GRM_BASIC'),3;

-- Products
INSERT INTO ProductCategory(category_name) VALUES (N'Thức ăn'),(N'Phụ kiện');
INSERT INTO Brand(brand_name) VALUES (N'PetBrandA'),(N'PetBrandB');

INSERT INTO Product(product_code,product_name,product_category_id,brand_id,description)
SELECT 'FD_DRY01',N'Hạt khô cho chó',
       (SELECT product_category_id FROM ProductCategory WHERE category_name=N'Thức ăn'),
       (SELECT brand_id FROM Brand WHERE brand_name=N'PetBrandA'),
       N'Hạt dinh dưỡng';

INSERT INTO ProductVariant(product_id,sku,attribute_json,price,cost,stock_quantity,image_url)
SELECT product_id,'FD_DRY01_1KG','{"weight":"1kg"}',120000,80000,50,'https://example.com/img1'
FROM Product WHERE product_code='FD_DRY01';

INSERT INTO InventoryLocation(location_code,name) VALUES ('MAIN','Kho chính');
INSERT INTO InventoryTransaction(variant_id, location_id, txn_type_code, quantity, reference_no, note)
SELECT variant_id,1,'PURCHASE',50,'PO-001',N'Nhập đầu kỳ'
FROM ProductVariant WHERE sku='FD_DRY01_1KG';

-- CartItem sample
INSERT INTO CartItem(customer_id, variant_id, quantity)
SELECT (SELECT user_id FROM Users WHERE username='customer1'),
       (SELECT variant_id FROM ProductVariant WHERE sku='FD_DRY01_1KG'),
       2;

-- Booking sample
INSERT INTO Booking(customer_id,pet_id,service_id,booking_time,requested_date,requested_start,current_status,total_price)
SELECT (SELECT user_id FROM Users WHERE username='customer1'),
       (SELECT pet_id FROM Pets WHERE name=N'Bông'),
       (SELECT service_id FROM Services WHERE service_code='GRM_BASIC'),
       SYSUTCDATETIME(),'2025-09-19','09:00','PENDING',150000;

INSERT INTO BookingStatusHistory(booking_id,status_code,changed_by,comment)
SELECT booking_id,'PENDING',(SELECT user_id FROM Users WHERE username='customer1'),N'Đặt mới'
FROM Booking;

INSERT INTO ScheduleSlot(booking_id, staff_id, start_time, end_time, status)
SELECT booking_id,(SELECT user_id FROM Users WHERE username='staff1'),
       DATEADD(HOUR,9,CAST(requested_date AS DATETIME2)),
       DATEADD(MINUTE,60,DATEADD(HOUR,9,CAST(requested_date AS DATETIME2))),
       'BOOKED'
FROM Booking;

INSERT INTO BookingStaffAssignment(booking_id, staff_id, role_in_service)
SELECT booking_id,(SELECT user_id FROM Users WHERE username='staff1'),N'Groomer chính'
FROM Booking;

-- Orders sample (giả lập tạo đơn từ giỏ)
INSERT INTO Orders(order_code, customer_id, shipping_address_id, order_status, subtotal_amount, total_amount)
SELECT 'ORD1001',
       (SELECT user_id FROM Users WHERE username='customer1'),
       (SELECT address_id FROM UserAddress WHERE user_id=(SELECT user_id FROM Users WHERE username='customer1') AND is_default=1),
       'PENDING',120000,120000;

INSERT INTO OrderItems(order_id, variant_id, unit_price, quantity)
SELECT (SELECT order_id FROM Orders WHERE order_code='ORD1001'),
       (SELECT variant_id FROM ProductVariant WHERE sku='FD_DRY01_1KG'),
       120000,1;

INSERT INTO OrderStatusHistory(order_id,status_code,changed_by,note)
SELECT order_id,'PENDING',(SELECT user_id FROM Users WHERE username='customer1'),N'Đặt mới'
FROM Orders WHERE order_code='ORD1001';

INSERT INTO Payments(order_id,payment_method_code,amount,status,paid_at)
SELECT order_id,'CASH',120000,'SUCCESS',SYSUTCDATETIME()
FROM Orders WHERE order_code='ORD1001';

INSERT INTO Invoice(invoice_code, order_id, total_amount, tax_amount)
SELECT 'INV1001', order_id, total_amount, 0
FROM Orders WHERE order_code='ORD1001';

-- Vet visit sample
INSERT INTO VetVisit(pet_id, owner_id, vet_staff_id, visit_type_code, visit_date, weight_kg, temperature_c, symptoms, notes)
SELECT (SELECT pet_id FROM Pets WHERE name=N'Bông'),
       (SELECT user_id FROM Users WHERE username='customer1'),
       (SELECT user_id FROM Users WHERE username='vet1'),
       'CHECKUP', SYSUTCDATETIME(), 5.4, 38.5, N'Hắt hơi nhẹ', N'Khám định kỳ';

INSERT INTO MedicalRecord(pet_id, visit_id, summary)
SELECT pet_id, visit_id, N'Sức khỏe tốt'
FROM VetVisit;

INSERT INTO Diagnosis(visit_id,diagnosis_code,description,severity)
SELECT visit_id,'NORMAL',N'Không bất thường',1 FROM VetVisit;

INSERT INTO Prescription(visit_id,instructions)
SELECT visit_id,N'Không cần thuốc' FROM VetVisit;

-- Review samples
INSERT INTO Reviews(target_type_code,target_id,customer_id,rating,comment)
SELECT 'SERVICE',
       (SELECT service_id FROM Services WHERE service_code='GRM_BASIC'),
       (SELECT user_id FROM Users WHERE username='customer1'),
       5,N'Rất hài lòng';

INSERT INTO Reviews(target_type_code,target_id,customer_id,rating,comment)
SELECT 'PRODUCT',
       (SELECT product_id FROM Product WHERE product_code='FD_DRY01'),
       (SELECT user_id FROM Users WHERE username='customer1'),
       4,N'Sản phẩm tốt';

GO
/********************************************************************
 Ghi chú mở rộng CartItem nếu cần sau này:
 ALTER TABLE CartItem ADD price_snapshot DECIMAL(12,2) NULL;
 ALTER TABLE CartItem ADD is_selected BIT NOT NULL DEFAULT 1;
*********************************************************************/