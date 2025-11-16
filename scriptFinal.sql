 /********************************************************************
 Database: SweetmalPetCare - FINAL VERSION (Services + Basic E-commerce)
 Version: 6
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

/* ============== 1. SECURITY / USERS & AUTH ============== */
CREATE TABLE Roles (
    role_id         INT IDENTITY PRIMARY KEY,
    role_name       NVARCHAR(50) NOT NULL UNIQUE,
    description     NVARCHAR(255)
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
    -- Thông tin chuyên môn (Gộp từ StaffProfile)
    position_title  NVARCHAR(80) NULL,
    specialty       NVARCHAR(150) NULL,
    license_number  NVARCHAR(50) NULL,
    hire_date       DATE NULL,
    rating_average  DECIMAL(3,2) NULL,
    is_veterinarian BIT NOT NULL DEFAULT 0,
    created_at      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    updated_at      DATETIME2 NULL
);
CREATE INDEX IX_Users_Role ON Users(role_id);

CREATE TABLE UserAddress (
    address_id      BIGINT IDENTITY PRIMARY KEY,
    user_id         BIGINT NOT NULL FOREIGN KEY REFERENCES Users(user_id),
    label           NVARCHAR(50), -- 'Nhà', 'Công ty'
    recipient_name  NVARCHAR(120),
    phone           NVARCHAR(20),
    address_line1   NVARCHAR(150) NOT NULL,
    ward            NVARCHAR(80),
    district        NVARCHAR(80),
    city            NVARCHAR(80),
    is_default      BIT NOT NULL DEFAULT 0,
    created_at      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
CREATE INDEX IX_UserAddress_User ON UserAddress(user_id);

/* ============== 2. PET DOMAIN (CORE) ============== */
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

/* ============== 3. SERVICE DOMAIN (CORE) ============== */
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
    current_price   DECIMAL(12,2) NOT NULL CHECK (current_price >= 0),
    status          VARCHAR(20) NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE','INACTIVE')),
    created_at      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
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

/* ============== 4. BOOKING / SCHEDULING (CORE) ============== */
CREATE TABLE BookingStatus (
    booking_status_code VARCHAR(30) PRIMARY KEY,
    description         NVARCHAR(150)
);

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
    payment_status  VARCHAR(30) NOT NULL DEFAULT 'PENDING' CHECK (payment_status IN ('PENDING','PAID','REFUNDED')),
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

/* ============== 5. PRODUCT & E-COMMERCE (BASIC) ============== */
CREATE TABLE ProductCategory (
    product_category_id INT IDENTITY PRIMARY KEY,
    category_name       NVARCHAR(100) NOT NULL UNIQUE,
    parent_id           INT NULL FOREIGN KEY REFERENCES ProductCategory(product_category_id),
    description         NVARCHAR(255)
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
    attribute_json  NVARCHAR(500), -- Vd: {"weight":"1kg", "flavor":"Beef"}
    price           DECIMAL(12,2) NOT NULL,
    stock_quantity  INT NOT NULL DEFAULT 0,
    image_url       NVARCHAR(300),
    is_active       BIT NOT NULL DEFAULT 1,
    created_at      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
CREATE INDEX IX_ProductVariant_Product ON ProductVariant(product_id);

/* ============== BỔ SUNG: CART ITEMS (GỘP) ============== */
    CREATE TABLE CartItems (
        cart_item_id    BIGINT IDENTITY PRIMARY KEY,
        user_id         BIGINT NOT NULL FOREIGN KEY REFERENCES Users(user_id) ON DELETE CASCADE, -- Món hàng thuộc về user nào
        variant_id      BIGINT NOT NULL FOREIGN KEY REFERENCES ProductVariant(variant_id),
        quantity        INT NOT NULL DEFAULT 1 CHECK (quantity > 0),
        added_at        DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT UQ_User_Variant UNIQUE (user_id, variant_id) -- Một user chỉ có 1 dòng cho mỗi loại sản phẩm trong giỏ
    );
    PRINT 'Table CartItems (merged version) created.';
    CREATE INDEX IX_CartItems_User ON CartItems(user_id);


	/* Thêm bảng ProductImg */
CREATE TABLE ProductImg (
    product_img_id  BIGINT IDENTITY PRIMARY KEY,
    product_id      BIGINT NOT NULL FOREIGN KEY REFERENCES Product(product_id),
    image_url       NVARCHAR(300) NOT NULL,
    caption         NVARCHAR(200) NULL,
    sort_order      INT NOT NULL DEFAULT 1,
    is_main         BIT NOT NULL DEFAULT 0,
    uploaded_at     DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
CREATE INDEX IX_ProductImg_Product ON ProductImg(product_id);

/* ============== 6. ORDER DOMAIN (BASIC) ============== */
CREATE TABLE OrderStatus (
    order_status_code VARCHAR(30) PRIMARY KEY,
    description       NVARCHAR(150)
);

CREATE TABLE PaymentMethod (
    payment_method_code VARCHAR(30) PRIMARY KEY,
    description         NVARCHAR(100)
);

CREATE TABLE Orders (
    order_id        BIGINT IDENTITY PRIMARY KEY,
    order_code      NVARCHAR(50) NOT NULL UNIQUE,
    customer_id     BIGINT NOT NULL FOREIGN KEY REFERENCES Users(user_id),
    shipping_address_id BIGINT NULL FOREIGN KEY REFERENCES UserAddress(address_id),
    order_status    VARCHAR(30) NOT NULL FOREIGN KEY REFERENCES OrderStatus(order_status_code),
    payment_method_code VARCHAR(30) NULL FOREIGN KEY REFERENCES PaymentMethod(payment_method_code),
    payment_status  VARCHAR(30) NOT NULL DEFAULT 'PENDING' CHECK (payment_status IN ('PENDING','PAID','REFUNDED')),
    subtotal_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
    shipping_fee    DECIMAL(12,2) NOT NULL DEFAULT 0,
    total_amount    DECIMAL(12,2) NOT NULL DEFAULT 0,
    notes           NVARCHAR(500),
    created_at      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    updated_at      DATETIME2 NULL
);

CREATE TABLE OrderItems (
    order_item_id   BIGINT IDENTITY PRIMARY KEY,
    order_id        BIGINT NOT NULL FOREIGN KEY REFERENCES Orders(order_id),
    variant_id      BIGINT NOT NULL FOREIGN KEY REFERENCES ProductVariant(variant_id),
    unit_price      DECIMAL(12,2) NOT NULL, -- Giá tại thời điểm mua
    quantity        INT NOT NULL CHECK (quantity > 0),
    line_total      AS (unit_price * quantity) PERSISTED
);
CREATE INDEX IX_OrderItems_Order ON OrderItems(order_id);

/* ============== 7. VETERINARY / MEDICAL (SIMPLIFIED CORE) ============== */
CREATE TABLE VetVisitType (
    visit_type_code VARCHAR(30) PRIMARY KEY,
    description     NVARCHAR(150)
);

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
    diagnosis_summary NVARCHAR(500),
    treatment_notes NVARCHAR(1000),
    follow_up_date  DATE NULL,
    created_at      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

/* ============== 8. FEEDBACK / CONSULTATION ============== */
CREATE TABLE Reviews (
    review_id       BIGINT IDENTITY PRIMARY KEY,
    service_id      BIGINT NULL FOREIGN KEY REFERENCES Services(service_id),
    product_id      BIGINT NULL FOREIGN KEY REFERENCES Product(product_id), -- Mở rộng cho review sản phẩm
    staff_id        BIGINT NULL FOREIGN KEY REFERENCES Users(user_id),
    customer_id     BIGINT NOT NULL FOREIGN KEY REFERENCES Users(user_id),
    rating          TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment         NVARCHAR(1000),
    created_at      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT CK_Review_Target CHECK ( -- Đảm bảo review có 1 target
        (service_id IS NOT NULL AND product_id IS NULL AND staff_id IS NULL) OR
        (service_id IS NULL AND product_id IS NOT NULL AND staff_id IS NULL) OR
        (service_id IS NULL AND product_id IS NULL AND staff_id IS NOT NULL)
    )
);
CREATE INDEX IX_Reviews_Service ON Reviews(service_id);
CREATE INDEX IX_Reviews_Product ON Reviews(product_id);
CREATE INDEX IX_Reviews_Staff ON Reviews(staff_id);


CREATE TABLE ReviewReply (
    reply_id        BIGINT IDENTITY PRIMARY KEY,
    review_id       BIGINT NOT NULL FOREIGN KEY REFERENCES Reviews(review_id) UNIQUE, -- UNIQUE để đảm bảo mỗi review chỉ có 1 phản hồi chính thức
    replied_by_staff_id BIGINT NOT NULL FOREIGN KEY REFERENCES Users(user_id), -- Staff/Admin ID
    reply_content   NVARCHAR(1000) NOT NULL,
    created_at      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
CREATE INDEX IX_ReviewReply_Review ON ReviewReply(review_id);
CREATE INDEX IX_ReviewReply_Staff ON ReviewReply(replied_by_staff_id);




-- 1. Tạo bảng trạng thái
CREATE TABLE ConsultationStatus (
    status_code     VARCHAR(30) PRIMARY KEY,
    description     NVARCHAR(150)
);

-- 2. Tạo bảng loại tư vấn (MỚI - Thay cho Subject)
CREATE TABLE ConsultationTypes (
    type_id         INT IDENTITY(1,1) PRIMARY KEY,
    type_name       NVARCHAR(100) NOT NULL UNIQUE, 
    description     NVARCHAR(255) NULL,
    is_active       BIT DEFAULT 1
);

-- 3. Tạo bảng yêu cầu tư vấn (Đã cập nhật FK sang ConsultationTypes)
CREATE TABLE ConsultationRequests (
    request_id          BIGINT IDENTITY PRIMARY KEY,
    customer_name       NVARCHAR(120) NOT NULL,
    email               NVARCHAR(150) NOT NULL,
    phone               NVARCHAR(20) NULL,
    
    -- FK trỏ sang bảng loại tư vấn
    consultation_type_id INT NOT NULL FOREIGN KEY REFERENCES ConsultationTypes(type_id),
    
    request_message     NVARCHAR(MAX) NOT NULL,
    
    -- Giả định bảng Users đã tồn tại trong DB của bạn
    user_id             BIGINT NULL FOREIGN KEY REFERENCES Users(user_id), 
    
    status_code         VARCHAR(30) NOT NULL DEFAULT 'PENDING' FOREIGN KEY REFERENCES ConsultationStatus(status_code),
    created_at          DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    assigned_staff_id   BIGINT NULL FOREIGN KEY REFERENCES Users(user_id),
    response_message    NVARCHAR(MAX) NULL,
    responded_at        DATETIME2 NULL
);

-- Tạo Index để tối ưu tìm kiếm
CREATE INDEX IX_ConsultationRequests_User ON ConsultationRequests(user_id);
CREATE INDEX IX_ConsultationRequests_Status ON ConsultationRequests(status_code);
CREATE INDEX IX_ConsultationRequests_Type ON ConsultationRequests(consultation_type_id);

INSERT INTO ConsultationTypes (type_name, description) VALUES 
(N'Tư vấn dịch vụ', N'Hỏi về các gói dịch vụ chăm sóc'),
(N'Hỗ trợ kỹ thuật', N'Gặp lỗi khi sử dụng website'),
(N'Đặt lịch hẹn', N'Muốn đặt lịch trước'),
(N'Khác', N'Các vấn đề khác');

-- Thêm trạng thái (nếu chưa có)
INSERT INTO ConsultationStatus (status_code, description) VALUES 
('PENDING', N'Chờ xử lý'),
('PROCESSING', N'Đang xử lý'),
('COMPLETED', N'Đã hoàn thành');

GO

/* ============== 9. TRIGGERS ============== */
CREATE OR ALTER TRIGGER TRG_UpdateStockOnOrder
ON OrderItems
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Trừ số lượng tồn kho trong ProductVariant
    UPDATE pv
        SET pv.stock_quantity = pv.stock_quantity - i.quantity
    FROM ProductVariant pv
    JOIN inserted i ON pv.variant_id = i.variant_id
    WHERE pv.stock_quantity >= i.quantity;
    
    -- (Optional: Xử lý nếu stock < quantity, nhưng để đơn giản ta giả định stock luôn đủ)
END
GO

/* ============== 10. INSERT LOOKUP DATA (BẢNG TRA CỨU) ============== */
PRINT 'Inserting Lookup Table Data...';
GO
INSERT INTO Roles(role_name, description) VALUES
(N'Customer',N'Khách hàng'),
(N'Staff',N'Nhân viên chung (Grooming, Boarding)'),
(N'Vet',N'Bác sĩ thú y'),
(N'Admin',N'Quản trị');

INSERT INTO BookingStatus(booking_status_code, description)
VALUES ('PENDING',N'Chờ xác nhận'),
       ('CONFIRMED',N'Đã xác nhận'),
       ('IN_PROGRESS',N'Đang thực hiện'),
       ('COMPLETED',N'Hoàn tất'),
       ('CANCELLED',N'Đã hủy'),
       ('NO_SHOW',N'Không đến');

INSERT INTO VetVisitType(visit_type_code, description)
VALUES ('CHECKUP',N'Khám tổng quát'),
       ('VACCINE',N'Tiêm phòng'),
       ('SURGERY',N'Phẫu thuật'),
       ('EMERGENCY',N'Cấp cứu'),
       ('ULTRASOUND',N'Siêu âm');

INSERT INTO ConsultationStatus(status_code, description)
VALUES ('PENDING',N'Chờ xử lý'),
       ('ANSWERED',N'Đã trả lời'),
       ('CLOSED',N'Đã đóng');

INSERT INTO ServiceCategory(category_name, description)
VALUES (N'Grooming',N'Tắm, cắt tỉa'),
       (N'Health',N'Dịch vụ y tế'),
       (N'Boarding',N'Lưu trú, khách sạn thú cưng');

INSERT INTO OrderStatus(order_status_code, description)
VALUES ('PENDING',N'Chờ xử lý'),
       ('PAID',N'Đã thanh toán'),
       ('PROCESSING',N'Đang xử lý'),
       ('SHIPPED',N'Đã gửi'),
       ('COMPLETED',N'Hoàn tất'),
       ('CANCELLED',N'Hủy');

INSERT INTO PaymentMethod(payment_method_code, description)
VALUES ('CASH',N'Tiền mặt (Tại cửa hàng)'),
       ('BANK',N'Chuyển khoản'),
       ('EWALLET',N'Ví điện tử (MoMo, ZaloPay)'),
       ('COD',N'Thanh toán khi nhận hàng');
GO

PRINT '================================================'
PRINT ' SCRIPT 1: TẠO DB (V6) HOÀN TẤT!'
PRINT ' Đã bao gồm E-commerce cơ bản và Consultation (Rỗng).'
PRINT '================================================'
GO