CREATE DATABASE MYKINGDOM
GO
USE MYKINGDOM
GO

-- Bảng lưu trữ thông tin danh mục sản phẩm
CREATE TABLE DanhMucSanPham (
    MaDanhMuc INT IDENTITY(1,1) PRIMARY KEY,
    TenDanhMuc NVARCHAR(255) NOT NULL,
	ImageDanhMuc VARCHAR(255)
);

-- Bảng lưu trữ thông tin thương hiệu
CREATE TABLE ThuongHieu (
	MaThuongHieu INT IDENTITY(1,1) PRIMARY KEY,
    TenThuongHieu NVARCHAR(MAX),
);

-- Bảng lưu trữ thông tin sản phẩm
CREATE TABLE SanPham (
    MaSanPham INT IDENTITY(1,1) PRIMARY KEY,
    TenSanPham NVARCHAR(255) NOT NULL,
	GioiTinh NVARCHAR(255),
	XuatXu NVARCHAR(255),
    MoTa NVARCHAR(MAX),
    GiaGoc FLOAT NOT NULL,
	GiaGiam FLOAT NOT NULL,
    --SoLuongTrongKho INT NOT NULL,
    MaDanhMuc INT,
	MaThuongHieu INT,
    CONSTRAINT FK_MaDanhMuc_SP FOREIGN KEY (MaDanhMuc) REFERENCES DanhMucSanPham(MaDanhMuc),
	CONSTRAINT FK_MaThuongHieu_SP FOREIGN KEY (MaThuongHieu) REFERENCES ThuongHieu(MaThuongHieu)
);

--Bảng lưu list ảnh của SP
CREATE TABLE ImageSanPham
(
	ImageID INT IDENTITY(1,1) PRIMARY KEY,
	MaSanPham INT NOT NULL,
	ImageURL VARCHAR(255) NOT NULL,
	CONSTRAINT FK_MaSanPham_SP FOREIGN KEY(MaSanPham) REFERENCES SanPham(MaSanPham)
)

-- Bảng lưu trữ thông tin khách hàng
CREATE TABLE KhachHang (
    MaKhachHang INT IDENTITY(1,1) PRIMARY KEY,
    HoTenDem NVARCHAR(255) NOT NULL,
    Ten NVARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL,
    SoDienThoai VARCHAR(20) NOT NULL,
    DiaChi NVARCHAR(255)
);

--Bảng lưu trữ thông tin tài khoản của khách hàng
CREATE TABLE TaiKhoanKhachHang (
    MaTaiKhoan INT IDENTITY(1,1) PRIMARY KEY,
    TaiKhoan VARCHAR(100) UNIQUE NOT NULL,
    MatKhau VARCHAR(100) NOT NULL,
	MaKhachHang INT NOT NULL,
    HoatDong NVARCHAR(50), 
    FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(MaKhachHang)
);

-- Bảng lưu trữ thông tin nhân viên
CREATE TABLE NhanVien (
    MaNhanVien INT IDENTITY(1,1) PRIMARY KEY,
    HoTen NVARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
	NgaySinh DATE,
    SoDienThoai VARCHAR(20),
	CCCD VARCHAR(12),
    DiaChi NVARCHAR(255),
);

GO

CREATE TABLE Voucher (
		MaVoucher INT IDENTITY(1,1) PRIMARY KEY,
		Code VARCHAR(20) UNIQUE,
		GiamGia INT,
		NgayHetHan DATE
	);

GO

INSERT INTO Voucher (Code, GiamGia, NgayHetHan)
VALUES 
    ('mykingdom10', 10, '2023-12-31'),
    ('mykingdom20', 20, '2023-12-15'),
    ('mykingdom30', 30, '2023-11-30'),
    ('mykingdom40', 40, '2023-12-05'),
    ('mykingdom50', 50, '2023-12-10');

GO

CREATE TABLE VoucherKhachHang (
		MaVoucherKhachHang INT IDENTITY(1,1) PRIMARY KEY,
		MaKhachHang INT,
		MaVoucher INT,
		FOREIGN KEY (MaKhachHang) REFERENCES KhachHang (MaKhachHang),
		FOREIGN KEY (MaVoucher) REFERENCES Voucher (MaVoucher),
		UNIQUE(MaKhachHang, MaVoucher)
	);
	
GO
 --Bảng lưu trữ thông tin đơn hàng
CREATE TABLE DonHang (
    MaDonHang INT IDENTITY(1,1) PRIMARY KEY,
    MaKhachHang INT,
    MaNhanVien INT,
    NgayDatHang DATE NOT NULL,
    TongTien DECIMAL(10, 2) NOT NULL,
	MaVoucher INT,
    TrangThai NVARCHAR(50) NOT NULL,
	GhiChu NVARCHAR(MAX),
    FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(MaKhachHang),
    FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien),
	FOREIGN KEY (MaVoucher) REFERENCES Voucher(MaVoucher)
);

-- Bảng lưu trữ thông tin chi tiết đơn hàng
CREATE TABLE ChiTietDonHang (
    MaChiTietDonHang INT IDENTITY(1,1) PRIMARY KEY,
    MaDonHang INT,
    MaSanPham INT,
    SoLuong INT NOT NULL,
    Gia DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (MaDonHang) REFERENCES DonHang(MaDonHang),
    FOREIGN KEY (MaSanPham) REFERENCES SanPham(MaSanPham)
);

-- Bảng lưu trữ thông tin nhập kho hàng
CREATE TABLE NhapKho (
    MaNhapKho INT IDENTITY(1,1) PRIMARY KEY,
    MaNhanVien INT,
    NgayNhapKho DATE NOT NULL,
	TrangThai NVARCHAR(50) DEFAULT N'Đang nhập kho'
    FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien)
);

-- Bảng lưu trữ thông tin chi tiết nhập kho hàng
CREATE TABLE ChiTietNhapKho (
    MaChiTietNhapKho INT IDENTITY(1,1) PRIMARY KEY,
    MaNhapKho INT,
    MaSanPham INT,
    SoLuongNhapKho INT NOT NULL,
    FOREIGN KEY (MaNhapKho) REFERENCES NhapKho(MaNhapKho),
    FOREIGN KEY (MaSanPham) REFERENCES SanPham(MaSanPham)
);

--Bảng kho hàng
CREATE TABLE KhoHang(
	MaKhoHang INT IDENTITY(1,1) PRIMARY KEY,
	MaSanPham INT UNIQUE NOT NULL,
    SoLuongTonKho INT DEFAULT 0,
    FOREIGN KEY (MaSanPham) REFERENCES SanPham(MaSanPham),
)

-- Bảng lưu trữ thông tin tài khoản
CREATE TABLE TaiKhoanNhanVien (
    MaNhanVien INT PRIMARY KEY,
    TaiKhoan VARCHAR(100) UNIQUE,
	MatKhau VARCHAR(100),
	HoatDong NVARCHAR(50),
	Quyen NVARCHAR(20),
	FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien)
);

-- Bảng GioHang
CREATE TABLE GioHang (
    MaGioHang INT IDENTITY(1,1) PRIMARY KEY,
    MaKhachHang INT,
	TongSoLuongSP INT,
    CONSTRAINT FK_MaKhachHang_GH FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(MaKhachHang)
);

-- Bảng chi tiết giỏ hàng
CREATE TABLE ChiTietGioHang (
    MaChiTietGioHang INT IDENTITY(1,1) PRIMARY KEY,
    MaGioHang INT,
    MaSanPham INT,
    SoLuong INT NOT NULL,
    CONSTRAINT FK_MaGioHang_CTGH FOREIGN KEY (MaGioHang) REFERENCES GioHang(MaGioHang),
    CONSTRAINT FK_MaSanPham_CTGH FOREIGN KEY (MaSanPham) REFERENCES SanPham(MaSanPham)
);

--Bảng hóa đơn
CREATE TABLE HoaDon(
	MaHoaDon VARCHAR(10) PRIMARY KEY,
	MaDonHang INT,
	MaNhanVien INT,
	MaKhachHang INT,
	NgayLap DATETIME,
	TrangThai NVARCHAR(30),
	TongTien DECIMAL(14, 2),
	FOREIGN KEY (MaDonHang) REFERENCES DonHang(MaDonHang),
	FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien),
	FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(MaKhachHang),
);

--Bảng chi tiết hóa đơn
CREATE TABLE ChiTietHoaDon(
	MaChiTietHoaDon INT IDENTITY(1,1) PRIMARY KEY,
	MaHoaDon VARCHAR(10),
	MaSanPham INT,
    SoLuong INT NOT NULL,
	FOREIGN KEY (MaHoaDon) REFERENCES HoaDon(MaHoaDon),
	FOREIGN KEY (MaSanPham) REFERENCES SanPham(MaSanPham),
);

--Bảng hóa đơn ofline
CREATE TABLE HoaDonOffline(
	MaHoaDon VARCHAR(10) PRIMARY KEY,
	MaNhanVien INT,
	NgayLap DATETIME,
	TrangThai NVARCHAR(30) DEFAULT N'Chưa thanh toán',
	TongTien FLOAT DEFAULT 0,
	FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien),
);

--Bảng chi tiết hóa đơn
CREATE TABLE ChiTietHoaDonOffline(
	MaChiTietHoaDon INT IDENTITY(1,1) PRIMARY KEY,
	MaHoaDon VARCHAR(10),
	MaSanPham INT,
    SoLuong INT NOT NULL,
	FOREIGN KEY (MaHoaDon) REFERENCES HoaDonOffline(MaHoaDon),
	FOREIGN KEY (MaSanPham) REFERENCES SanPham(MaSanPham),
);

go

CREATE PROCEDURE ThemHoaDonOffline
	@idnv INT,
	@ngaylap DATETIME
AS
BEGIN
    DECLARE @MaHoaDon NVARCHAR(10);
    DECLARE @MaHoaDonMax NVARCHAR(10);
    SELECT @MaHoaDonMax = MAX(MaHoaDon) FROM HoaDonOffline;
    
    IF @MaHoaDonMax IS NULL
        SET @MaHoaDon = 'HD00001'
    ELSE
        SET @MaHoaDon = 'HD' + RIGHT('00000' + CAST(CAST(RIGHT(@MaHoaDonMax, 5) AS INT) + 1 AS NVARCHAR(5)), 5);
    
    INSERT INTO HoaDonOffline (MaHoaDon, MaNhanVien, NgayLap, TrangThai, TongTien)
    VALUES (@MaHoaDon, @idnv, @ngaylap, N'Chưa thanh toán', 0);
END;
GO

CREATE PROCEDURE ThemChiTietHoaDonOffline
    @MaHoaDon VARCHAR(10),
    @MaSanPham INT,
    @SoLuong INT
AS
BEGIN
    DECLARE @SoLuongHienTai INT;
    SELECT @SoLuongHienTai = SoLuong
    FROM ChiTietHoaDonOffline
    WHERE MaHoaDon = @MaHoaDon AND MaSanPham = @MaSanPham;
    IF @SoLuongHienTai IS NOT NULL
    BEGIN
        UPDATE ChiTietHoaDonOffline
        SET SoLuong = @SoLuongHienTai + @SoLuong
        WHERE MaHoaDon = @MaHoaDon AND MaSanPham = @MaSanPham;
    END
    ELSE
    BEGIN
        INSERT INTO ChiTietHoaDonOffline (MaHoaDon, MaSanPham, SoLuong)
        VALUES (@MaHoaDon, @MaSanPham, @SoLuong);
    END;
END;
GO

CREATE PROCEDURE ThemSanPham
    @TenSanPham NVARCHAR(255),
    @GioiTinh NVARCHAR(255),
    @XuatXu NVARCHAR(255),
    @MoTa NVARCHAR(MAX),
    @GiaGoc FLOAT,
    @GiaGiam FLOAT,
    --@SoLuongTrongKho INT,
    @MaDanhMuc INT,
    @MaThuongHieu INT
AS
BEGIN
    INSERT INTO SanPham (
        TenSanPham, GioiTinh, XuatXu, MoTa, GiaGoc, GiaGiam, MaDanhMuc, MaThuongHieu
    )
    VALUES (
        @TenSanPham, @GioiTinh, @XuatXu, @MoTa, @GiaGoc, @GiaGiam, @MaDanhMuc, @MaThuongHieu
    );
    RETURN;
END;

go

CREATE PROCEDURE Them_DanhMucSanPham
    @ten_danh_muc NVARCHAR(255),
    @image_danh_muc VARCHAR(255)
AS
BEGIN
    INSERT INTO DanhMucSanPham (TenDanhMuc, ImageDanhMuc)
    VALUES (@ten_danh_muc, @image_danh_muc);
END;
GO

-- Stored procedure thêm thương hiệu
CREATE PROCEDURE Them_ThuongHieuSanPham
    @ten_thuong_hieu NVARCHAR(MAX)
AS
BEGIN
    INSERT INTO ThuongHieu (TenThuongHieu)
    VALUES (@ten_thuong_hieu);
END;
GO

CREATE PROCEDURE ThemKhachHang
    @ho_ten_dem NVARCHAR(255),
    @ten NVARCHAR(255),
    @email VARCHAR(255),
    @so_dien_thoai VARCHAR(20),
    @dia_chi NVARCHAR(255)
AS
BEGIN
    INSERT INTO KhachHang (HoTenDem, Ten, Email,SoDienThoai, DiaChi)
    VALUES (@ho_ten_dem, @ten, @email, @so_dien_thoai, @dia_chi);
END;
GO

-- Procedure for adding a new entry to NhapKho table
CREATE PROCEDURE ThemNhapKho
    @MaNhanVien INT,
    @NgayNhapKho DATE
AS
BEGIN
    INSERT INTO NhapKho (MaNhanVien, NgayNhapKho)
    VALUES (@MaNhanVien, @NgayNhapKho);
END;
GO

-- Procedure for adding a new entry to ChiTietNhapKho table
CREATE PROCEDURE ThemChiTietNhapKho
    @MaNhapKho INT,
    @MaSanPham INT,
    @SoLuongNhapKho INT
AS
BEGIN
    INSERT INTO ChiTietNhapKho (MaNhapKho, MaSanPham, SoLuongNhapKho)
    VALUES (@MaNhapKho, @MaSanPham, @SoLuongNhapKho);
END;
GO

-- Stored procedure thêm nhân viên
CREATE PROCEDURE Them_Nhan_Vien
    @ho_ten NVARCHAR(255),
    @email VARCHAR(255),
    @so_dien_thoai VARCHAR(20),
    @dia_chi NVARCHAR(255),
	@ngaysinh DATE,
	@CCCD VARCHAR(12)
AS
BEGIN
    INSERT INTO NhanVien (HoTen, Email, NgaySinh, SoDienThoai, CCCD, DiaChi)
    VALUES (@ho_ten, @email, @ngaysinh, @so_dien_thoai, @CCCD, @dia_chi);
END;
GO

CREATE PROCEDURE TinhTongTienHoaDonOffline
    @MaHoaDon VARCHAR(10)
AS
BEGIN
    DECLARE @TongTien FLOAT = 0;

    SELECT @TongTien += (SP.GiaGiam * CT.SoLuong) 
    FROM ChiTietHoaDonOffline CT
    INNER JOIN SanPham SP ON CT.MaSanPham = SP.MaSanPham
    WHERE CT.MaHoaDon = @MaHoaDon;

    UPDATE HoaDonOffline
    SET TongTien = @TongTien
    WHERE MaHoaDon = @MaHoaDon;
END;

GO


CREATE PROCEDURE CapNhatHoaDonOffline
    @MaHoaDon VARCHAR(10),
    @TongTien FLOAT
AS
BEGIN
    UPDATE HoaDonOffline
    SET TongTien = @TongTien, TrangThai = N'Đã Thanh Toán'
    WHERE MaHoaDon = @MaHoaDon;
END;

GO

CREATE PROCEDURE ThemHoaDon
    @MaDonHang INT,
    @MaNhanVien INT,
    @MaKhachHang INT,
    @NgayLap DATETIME,
    @TrangThai NVARCHAR(30),
    @TongTien FLOAT
AS
BEGIN
    DECLARE @MaHoaDon NVARCHAR(10);
    DECLARE @MaHoaDonMax NVARCHAR(10);
    SELECT @MaHoaDonMax = MAX(MaHoaDon) FROM HoaDon;
    IF @MaHoaDonMax IS NULL
        SET @MaHoaDon = 'HD00000001'
    ELSE
        SET @MaHoaDon = 'HD' + RIGHT('00000000' + CAST(CAST(RIGHT(@MaHoaDonMax, 8) AS INT) + 1 AS NVARCHAR(8)), 8);
    INSERT INTO HoaDon (MaHoaDon, MaDonHang, MaNhanVien, MaKhachHang, NgayLap, TrangThai, TongTien)
    VALUES (@MaHoaDon, @MaDonHang, @MaNhanVien, @MaKhachHang, @NgayLap, @TrangThai, @TongTien);
END;

GO

insert into DanhMucSanPham values(N'Đồ chơi lắp ghép', 'danh-muc-lap-ghep.jpg')
insert into DanhMucSanPham values(N'Đồ dùng học tập', 'danh-muc-hoc-tap.jpg')
insert into DanhMucSanPham values(N'Đồ chơi sáng tạo', 'danh-muc-sang-tao.jpg')
insert into DanhMucSanPham values(N'Đồ thời trang', 'danh-muc-thoi-trang.jpg')
insert into DanhMucSanPham values(N'Thế giới động vật', 'danh-muc-dong-vat.jpg')
insert into DanhMucSanPham values(N'Búp bê', 'danh-muc-bup-be.jpg')
insert into DanhMucSanPham values(N'Đồ chơi mô phỏng', 'danh-muc-mo-phong.jpg')
insert into DanhMucSanPham values(N'Thú bông', 'danh-muc-thu-bong.jpg')
insert into DanhMucSanPham values(N'Robot', 'danh-muc-robot.jpg')
insert into DanhMucSanPham values(N'Đồ chơi mầm non', 'danh-muc-mam-non.jpg')
go
insert into ThuongHieu values(N'LEGO')
insert into ThuongHieu values(N'CLEVERHIPPO')
insert into ThuongHieu values(N'MINIVERSE')
insert into ThuongHieu values(N'MAKE IT REAL')
insert into ThuongHieu values(N'JURASSIC WORLD MATTEL')
insert into ThuongHieu values(N'BARBIE')
insert into ThuongHieu values(N'SWEET HEART')
insert into ThuongHieu values(N'SWEET HEART PLUSH')
insert into ThuongHieu values(N'VECTO')
insert into ThuongHieu values(N'PEEK A BOO')

go

EXEC ThemSanPham N'Đồ chơi lắp ráp Ngôi nhà gia đình 3 trong 1 LEGO DUPLO 10994','BOY',N'TRUNG QUỐC',N'Đồ chơi LEGO DUPLO 10946 Chuyến phiêu lưu cắm trại gia đình (30 chi tiết) giúp trẻ vừa học vừa chơi cùng cha mẹ. Tham gia một chuyến đi cắm trại trong rừng với con bạn và chia sẻ nhiều hoạt động vui vẻ của gia đình. 3 trong số các nhân vật thân thiện nằm gọn trong xe tải cắm trại, với nửa trên có thể tháo rời cho phép dễ dàng tiếp cận. Các thiết bị xếp chồng lên nhau trên mái nhà, mang đến nhiều niềm vui khi chiếc xe tải được điều khiển, cẩn thận, đến khu cắm trại. Lều vải được lắp đặt nhanh chóng và dễ dàng. Có một chiếc ca nô cho những chuyến phiêu lưu trên sông và đốt lửa trại để pha trà và ngồi quây quần bên gia đình hát cùng guitar. Đừng quên ghi lại những kỷ niệm cắm trại của gia đình bằng máy ảnh! Đồ chơi LEGO DUPLO đặt niềm vui, sự tự thể hiện bản thân và việc học tập vui vẻ vào tay trẻ mẫu giáo. Với bộ chơi DUPLO, cha mẹ và trẻ nhỏ có thể chia sẻ những cột mốc phát triển quý giá khi chúng chơi cùng nhau.',5329000,4329000,1,1
EXEC ThemSanPham N'Đồ chơi lắp ráp Công viên giải trí ven biển LEGO FRIENDS 41737','BOY',N'NGA',N'Autumn rất yêu động vật. Người bạn của cô ấy - Leo thích thám hiểm và phiêu lưu, vì vậy cô ấy đã mời Leo tham gia Trung tâm cứu hộ sinh vật biển. Hôm nay, Leo sẽ cùng mọi người đến giúp đỡ chăm sóc cho những chú rái cá bị thương. Kéo chiếc xe máng của bạn rái cá bị thương lên bến tàu. Đưa những người bạn rái cá vào bên trong để tắm rửa, chụp x-quang và cho ăn. Sau đó giúp chúng di chuyển vào khu phục hồi chức năng. Khi khỏe trở lại, rái cá có thể quay trở lại biển.',4929000,4129000,1,2
EXEC ThemSanPham N'Đồ chơi lắp ráp Ngôi nhà ngoại ô của Autumn LEGO FRIENDS 41745','BOY',N'TRUNG QUỐC',N'Cùng chăm sóc các chú ngựa tại Ngôi nhà ngoại ô của Autumn. Aliya, bạn của Autumn sẵn sàng giúp đỡ cô ấy. Sử dụng chướng ngại vật để huấn luyện ngựa. Dọn dẹp chuồng ngựa, sau đó chải lông cho những ngựa. Cho chúng ăn nhẹ trong khi Autumn và Aliya đang pha đồ uống trong bếp. Tận hưởng chuyến đi bằng xe ngựa trước khi đặt lưng người trên những chiếc giường cỏ khô ấm cúng để ngủ qua đêm tại chuồng ngựa.',2959000,1959000,1,6
EXEC ThemSanPham N'Đồ chơi lắp ráp Tiệm ăn trung tâm thành phố Heartlake LEGO FRIENDS 41747','UNISEX',N'ANH QUỐC',N'Hãy tham gia cùng Leo và Alba khi bà ngoại dẫn 2 bạn đi tham quan nhà bếp cộng đồng. Leo đang học các công thức nấu ăn mới và Alba chơi đùa cùng chú mèo Churro. Leo sẽ nấu món gì hôm nay? Có rất nhiều phụ kiện nhà bếp và nguyên liệu để tạo ra các công thức nấu ăn sáng tạo. Sau khi nấu ăn xong, Leo và Alba có thể đi chơi với bạn bè trên sân thượng. Một ngày dài vừa vất vả vừa thú vị!',4329000,2329000,1,4
EXEC ThemSanPham N'Đồ chơi lắp ráp Trận chiến tại trường Hogwarts LEGO HARRY POTTER 76415','BOY',N'CANADA',N'Đội quân của Voldemort đang tấn công Lâu đài Hogwarts™! Liên minh với Molly Weasley™ để chống lại Bellatrix Lestrange. Sử dụng Thanh kiếm của Gryffindor™ để giúp Neville Longbottom™ tiêu diệt Nagini, sau đó tham gia cùng Harry Potter™ trên cây cầu và trong sân để thực hiện một câu thần chú - chiến đấu với Voldemort™. Ai sẽ chiến thắng trong phần cuối của phần cuối bộ phim Harry Potter và Bảo bối Tử thần™ – Phần 2',3599000,2599000,1,8
EXEC ThemSanPham N'Đồ chơi lắp ráp Nhân Vật LEGO Marvel Series 2 LEGO MINIFIGURES 71039','BOY',N'TRUNG QUỐC',N'Khám phá thế giới hành động của Marvel với hộp LEGO® Minifigures chứa các nhân vật từ một chương trình trên kênh Disney+ nổi tiếng của Marvel. Có 12 nhân vật độc đáo để thu thập, bao gồm Người sói Wolverine, Moon Knight, She-Hulk, Echo,…. Mỗi nhân vật đều đi kèm ít nhất 1 phụ kiện có độ chi tiết cao. Bạn sẽ tìm thấy ai trong hộp LEGO mìnigure của mình?',129000,99000,1,7
EXEC ThemSanPham N'Đồ chơi lắp ráp Phi thuyền X-Wing Starfighter™ LEGO STAR WARS 75355','UNISEX',N'ĐAN MẠCH',N'Tái hiện những pha hành động đầy kịch tính của bộ phim Star Wars: The Mandalorian khi xây dựng phiên bản Phi thuyền X-Wing Starfighter thuộc bộ sưu tập cao cấp. Bộ lắp ráp mang đầy đủ chi tiết theo phong cách LEGO®. Người chơi có thể trưng bày chiếc X-wing với 2 hình thái khác nhau, chế độ do thám hoặc chế độ tấn công cùng với chân đế đi kèm. Bộ lắp ráp gồm một Phi thuyền X-Wing Starfighter, một nhân vật minifigure Luke Skywalker và Robot R2-D2.',7559000,6999000,1,10
EXEC ThemSanPham N'Đồ chơi lắp ráp Học viện Ma thuật và Pháp thuật Hogwarts LEGO HARRY POTTER 76419','UNISEX',N'TRUNG QUỐC',N'Đắm mình trong trải nghiệm sáng tạo kỳ diệu với mô hình LEGO® đầu tiên của Học viện Ma thuật và Pháp thuật Hogwarts. Xây dựng Tòa Tháp Chính, Tháp Thiên văn, Đại sảnh đường, v.v. Khám phá những căn phòng mang tính biểu tượng như Phòng Chứa Bí mật™ và Phòng học môn Độc dược. Bên cạnh đó mô hình thu nhỏ của kiến trúc sư Hogwarts, Durmstrang Ship và các công trình xây dựng khác mà bạn sẽ nhận ra ngay lần đầu chiêm ngưỡng và hoàn thành bộ lâu đài pháp thuật đầy huyền bí.',5299000,4799000,1,5
EXEC ThemSanPham N'Đồ chơi lắp ráp Khám phá và nghĩ dưỡng tại lều tuyết LEGO FRIENDS 41760','BOY',N'ĐAN MẠCH',N'Bạn đã sẵn sàng cho một cuộc phiêu lưu đáng nhớ chưa nào? Paisley đã thực hiện một chuyến đi đến vùng núi tuyêt với bạn của cô ấy là Aliya và em gái Ella. Đi bằng xe trượt tuyết là cách hoàn hảo để đến lều tuyết. Aliya ngâm mình trong hồ bơi hơi nước. Paisley chụp ảnh phong cảnh. Sau đó, những người bạn sưởi ấm bên đống lửa trước khi có một giấc ngủ ấm cúng bên trong mái vòm.',1639000,1500000,1,3
EXEC ThemSanPham N'Đồ chơi lắp ráp Siêu xe Người Dơi đối đầu Joker LEGO SUPERHEROES 76354','BOY',N'TRUNG QUỐC',N'Joker™ đã lừa đảo và đánh cắp một số tiền quan trọng! Nhưng Batman™ không để cho tội ác trở thành chiến thắng. Anh ta nhanh chóng nhảy vào chiếc Batmobile™ và khởi động đuổi theo tên ác nhân này. Ngọn lửa phun ra từ ống pô khi Batman đuổi kịp Joker, tạo nên một cảnh tượng rực rỡ.',799000,629000,1,9

EXEC ThemSanPham N'Máy đọc chữ thông minh cho bé PEEK A BOO PAB043','UNISEX',N'VIỆT NAM',N'Cùng học tiếng Anh vừa vui vừa hiệu quả cùng với Bộ máy đọc chữ thông minh của PEEK A BOO! Với đa dạng chủ để để khám phá, bé có thể nhanh chóng học nhiều từ vựng và câu nói thường ngày, rèn luyện khả năng phối hợp tai-mắt.',399000,299000,2,10
EXEC ThemSanPham N'Bóp viết 3D Người nhện Spider-Man CLEVERHIPPO HLS1103','UNISEX',N'VIỆT NAM',N'Bóp viết 3D Spider-Man với hình ảnh chàng người nhện dũng mãnh cùng màu sắc xanh đỏ vừa cá tính vừa mạnh mẽ',350000,289000,2,2
EXEC ThemSanPham N'Ba lô Zipit Người nhện Spider-Man CLEVERHIPPO BLS9206','UNISEX',N'VIỆT NAM',N'Bóp viết 3D Spider-Man với hình ảnh chàng người nhện dũng mãnh cùng màu sắc xanh đỏ vừa cá tính vừa mạnh mẽ',699000,629000,2,7
EXEC ThemSanPham N'Lô 5 quyển Vở 4 ô ly 96 trang Clever Hippo CLEVERHIPPO V019605','UNISEX',N'VIỆT NAM',N'Set gồm 5 cuốn vở 4 ô li Clever Hippo 96 trang luôn bìa, với 4 thiết kế khác nhau dựa trên biểu tượng đặc trung của thương hiệu sẽ mag lại cho bé những . Với chất liệu 100gsm, các bé có thể tự tin thoải mái dùng lực để viết mà không ngại bị lem hay nhoè, in sang trang. Bề mặt giấy lán mịn, giúp các bé viết êm tay hơn.',90000,59000,2,9
EXEC ThemSanPham N'Combo 16 Màu Sáp và 16 Màu Chì Colorful CLEVERHIPPO CB161601','UNISEX',N'VIỆT NAM',N'Combo màu sáp và màu chì là sự kết hợp giữa 16 cây bút chì màu thân gỗ kèm 16 cây bút màu sáp Colorful thuộc dòng sản phẩm bút màu chất lượng đạt tiêu chuẩn Châu Âu của Clever Hippo. Sản phẩm bao gồm cả bút sáp và bút chì màu nên các bé có thể dễ dàng hoàn thiện bức tranh của mình với nhiều màu sắc khác nhau.',105000,95000,2,1
EXEC ThemSanPham N'Bóp viết Classic Biệt đội Avengers CLEVERHIPPO HLM0104','UNISEX',N'VIỆT NAM',N'Bóp viết Classic Marvel với họa tiết những vũ khí mạnh mẽ, quyền năng như búa Mjolnir, tấm khiên Captain America,... cực kì phù hợp cho các bé yêu thích vũ trụ Marvel',399000,369000,2,10
EXEC ThemSanPham N'Ba lô Fancy Frozen CLEVERHIPPO BLF1235','GIRL',N'VIỆT NAM',N'Bước chân vào thế giới tuyết cùng nữ hoàng Elsa và những người bạn. Bộ sưu tập chủ đề Frozen mới nhất, với nhân vật Elsa cùng tông màu xanh pastel quen thuộc',799000,699000,2,10
EXEC ThemSanPham N'Combo sổ và bút Follow Your Heart 3C4G 12043','UNISEX',N'VIỆT NAM',N'Combo sổ và bút Follow Your Heart là sản phẩm đến từ 3C4G - một thương hiệu nổi tiếng về các sản phẩm văn phòng phẩm và phụ kiện cho bé gái của Vương quốc Anh. Với bộ sản phẩm, bé có thể thoả sức sáng tạo và lưu giữ những ý tưởng, kiến thức hay thông tin cần thiết. Với thiết kế là sổ A5 nhỏ gọn, bé có thể dễ dàng bỏ vào cặp hay túi tote để mang theo đến trường và kể cả những chuyến đi dã ngoại. ',405000,379000,2,10
EXEC ThemSanPham N'Đồ chơi bảng vẽ nam châm sáng tạo cho bé PEEK A BOO PAB031','UNISEX',N'VIỆT NAM',N'Ba mẹ muốn bé nhà mình phát triển tư duy logic, tập cho bé sự tập trung và phát triển 1 cách toàn diện từ vận động tinh đến các giác quan. Thì Bảng Chơi Nam Châm – Vịt vàng là lựa chọn tốt nhất.',199000,99000,2,10
EXEC ThemSanPham N'Bộ sổ tay, bút chì màu - Butterfly 3C4G 12025','UNISEX',N'VIỆT NAM',N'Bộ văn phòng phẩm Butterfly – 12025 với họa tiết lấy cảm hứng từ chú bướm khoe sắc đậm chất thần tiên dành cho các cô bé đáng yêu mộng mơ, là nơi lưu lại những kỷ niệm đẹp của bé. Ngoài ra, với những dụng cụ học tập đi kèm Bộ văn phòng phẩm hứa hẹn là sẽ "item" yêu thích của bé vì đây là nơi các tác phẩm của bé được sáng tạo và lưu giữ.',242000,200000,2,10

EXEC ThemSanPham N'Miniverse Playset Phòng Bếp Mini MINIVERSE 591832-EUC','UNISEX',N'MỸ',N'Đồ chơi phòng bếp chủ đề giáng sinh cho bé',999000,779000,3,3
EXEC ThemSanPham N'Vali Trang Điểm Hồng Sành Điệu Hello Kitty MAKE IT REAL 4800MIR','UNISEX',N'ANH QUỐC',N'Bộ trang điểm với concept vali, vừa độc đáo vừa tiện lợi cho bé mang theo. Đây sẽ là món đồ không thể thiếu cho các bé gái yêu thích cái đẹp và sành điệu.',849000,799000,3,4
EXEC ThemSanPham N'Đồ Chơi Mô Hình Giải Phẫu 4D - Chó Săn Lông Vàng STEAM 622007','UNISEX',N'TRUNG QUỐC',N'Đồ Chơi Mô Hình Giải Phẫu 4D - Chó Săn Lông Vàng là mô hình giải phẫu gồm 30 mảnh ghép cơ thể động vật và được thiết kế, sản xuất với đường nét chi tiết, tinh xảo. Bé có thể vừa chơi vừa học khi lắp ráp mô hình.',649000,519000,3,6
EXEC ThemSanPham N'Đồ chơi máy chiếu Thiên văn học STEAM 1423000801','UNISEX',N'TRUNG QUỐC',N'Đồ chơi khoa học STEAM hàng đầu nước Mỹ của nhãn hàng DISCOVERY #MINDBLOWN, hợp tác cùng kênh truyền hình nổi tiếng DISCOVERY, đem lại cho bé những trải nghiệm khoa học ứng dụng vừa học, vừa chơi.',799000,499000,3,5
EXEC ThemSanPham N'Bộ Thí Nghiệm Pha Chế Mùi hương STEAM 13010','UNISEX',N'ẤN ĐỘ',N'Nào cùng bắt tay chế tác ngay Bình nước hoa vòi xịt thơm ngát; lọ dầu thơm tinh tế có bi lăn;hay phấn phủ mùi hương riêng biệt ; đặc biệt hơn nữa, bé sẽ bất ngờ khi thư giãn với không gian thơm ngát tươi mới với bình xịt phòng & cọ dầu thơm mới tinh tươm, hay sáp thơm tuyệt đỉnh.',499000,299000,3,8
EXEC ThemSanPham N'Đồ chơi hack não Khóa Khổng Minh hình Đá Lục Bảo STEAM EQY8120','UNISEX',N'TRUNG QUỐC',N'Khoá Khổng Minh đã từng được lưu truyền rộng rãi trong nhân gian, và dần dần nhận được sự chú ý của mọi người. Nhìn tưởng chừng đơn giản nhưng lại thể hiện trí thông minh phi thường.',99000,79000,3,9
EXEC ThemSanPham N'Máy trộn bột thần kì phiên bản mới PLAYDOH F4718','UNISEX',N'MỸ',N'Tạo ra những chiếc bánh, bánh nướng nhỏ và bánh quy tuyệt vời với Play-Doh Kitchen Creations Magical Mixer Playset! Những đầu bếp bánh ngọt đầy tham vọng có thể tạo ra những sáng tạo giàu trí tưởng tượng với trò chơi trộn này. Bộ trò chơi Play-Doh này bao gồm 10 khuôn với nhiều màu sắc khác nhau và là một hoạt động thủ công và nghệ thuật thú vị dành cho trẻ em yêu thích đồ chơi nhà bếp và đồ ăn.',799000,699000,3,10
EXEC ThemSanPham N'Bộ Dụng Cụ Sơn Móng Tay In Hình Cao Cấp Thế Hệ Mới','UNISEX',N'PHÁO',N'Thương hiệu Canada. Phiên bản sơn móng cao cấp đời mới.',759000,719000,3,1
EXEC ThemSanPham N'Khối nam châm biến hình bất ngờ - phiên bản thẻ. STEAM EQY3051','UNISEX',N'TRUNG QUỐC',N'Khối nam châm biến hình bất ngờ - phiên bản thẻ là một khối cubic gồm 7 khối nam châm khác nhau hợp thành. Với 7 khối nam châm này, bé có thể thoả sức trí tưởng tượng và sáng tạo để xếp thành nhiều hình dạng khác nhau.',89000,59000,3,7
EXEC ThemSanPham N'Bộ Trang Sức Đá Quý Hoàng Gia Disney MAKE IT REAL 4210MIR','UNISEX',N'ANH QUỐC',N'Bộ trang sức lấp lánh với nhiểu phụ kiện đá quý cho bé thỏa sức sáng tạo nên những chiếc vòng tay đầy cá tính và ấn tượng.',499000,379000,3,2

EXEC ThemSanPham N'Bộ Đồ Chơi Thiết Kế Vòng Tay Siêu Tốc COOL MAKER 6067289','UNISEX',N'CANADA',N'Thể hiện sự sáng tạo của mình với bộ dụng cụ làm vòng tay tự làm này, hoàn hảo cho những người làm trẻ tuổi yêu thích vòng tay tình bạn, vòng tay gạch và làm vòng tay. Tạo và tái tạo những chiếc vòng tay độc đáo, dễ dàng hoán đổi các hạt để có vô số kiểu dáng và kết hợp chúng với trang phục. Không thắt nút, không cắt, không cài móc - chỉ cần bật và tắt các hạt.',759000,479000,4,9
EXEC ThemSanPham N'Kính mát gọng đổi màu Light Pink','UNISEX',N'HOA KỲ',N'Kính mát thời trang gọng đổi màu Light Pink 7SWILPPK thuộc hãng mắt kính thời trang REAL SHADES hàng đầu tại Mỹ. Chiếc kính nổi bật với tính năng gọng đổi màu khi ra nắng, tạo nên nét cá tính riêng cho bé. Ngoài ra, sản phẩm còn nhiều tính năng khác bảo vệ mắt bé dưới tác hại của môi trường, bụi bẩn.',372000,298000,4,7
EXEC ThemSanPham N'Túi Purse Pets - Bulldog cá tính','UNISEX',N'CANADA',N'Túi Purse Pet mèo con xinh có đôi tai màu hồng cực cute. Chiếc túi màu hồng bắt mắt, đôi mắt to tròn lấy cảm hứng từ từ các nhân vật truyện tranh, dây đeo có thể điều chỉnh và phần điều chỉnh bằng kim loại thật.',899000,629000,4,1
EXEC ThemSanPham N'Vali kéo xoay 360 Tie-Dye TD01 18 inch HEYS 16391-3209-00','UNISEX',N'CANADA',N'Vali kéo xoay 360 Tie-Dye là sản phẩm đến từ HEYS - một thương hiệu Vali hàng đầu thế giới đến từ Canada với hơn 30 năm trên thị trường nổi bật với các sản phẩm chất lượng cao. Vali với họa tiết về chủ đề Màu sắc Tie-Dye với sắc hồng là chủ đạo tạo nên cảm giác mới lạ cho bé gái, phù hợp cho các bé cá tính và dễ thương, hứa hẹn sẽ là phụ kiện du lịch thời thượng cho bé.',1567000,1097000,4,4
EXEC ThemSanPham N'Bộ 20 trang sức và cột tóc xinh xắn','GIRL',N'ANH QUỐC',N'Với những nàng công chúa nhỏ, những chiếc vòng tay xinh xắn hay những chiếc cột tóc dễ thương chắc chắn sẽ không thể thiếu đúng không nào. Với Bộ trang sức và trang trí tóc này, bé có thể phối với các bộ váy khách nhau vào tạo ra những kiểu tóc thật ấn tượng',294000,209000,4,8
EXEC ThemSanPham N'Nón bảo hiểm Clever Helmet Gradient','GIRL',N'VIỆT NAM',N'Mũ bảo hiểm xanh dành cho bé sử dụng khi tham gia những môn thể thao đường phố. Màu xanh của nón tạo nên nét cá tính và mạnh mẽ, màu sắc vô cùng nổi bật và năng động dành cho bé trai dũng mãnh.',499000,299000,4,2
EXEC ThemSanPham N'Đồng hồ Clever Watch - Camo Xanh Biển','BOY',N'VIỆT NAM',N'Thiết kế đồng hồ CAMO NAVY BLUE theo chủ đề Camo xanh nước biển phù hợp với cậu bé năng động, cá tính. Màu sắc xanh đậm nhặt khác nhau được phối hợp ăn ý trên bề mặt dây vải Ribbon, vừa đẹp vừa bền chắc. Thiết kế mặt đồng hồ bóng sáng, dễ vệ sinh và có khả năng chống nước. Chắc chắn đây sẽ là món đồ có thể đồng hành cùng cậu nhóc trong cả học tập và vui chơi. Sản phẩm này được thiết kế độc quyền bởi Clever Hippo.',359000,299000,4,3
EXEC ThemSanPham N'Huy hiệu Little Monster tinh nghịch','UNISEX',N'ANH QUỐC',N'Huy hiệu Little Monster tinh nghịch nhưng lại vô cùng đáng yêu. Màu sắc nổi bật của Monster và những người bạn phù hợp hơn với bé cá tính. Mỗi huy hiệu mang một hình ảnh khác nhau về Monster, mang theo sự vui vẻ và tinh nghịch trong tính cách.',78000,55000,4,6
EXEC ThemSanPham N'Đồng hồ thông minh cho bé 4G Cleverkid Xanh sành điệu','UNISEX',N'TRUNG QUỐC',N'Đồng hồ thông minh Cleverkid tích hợp nhiều tính năng hữu ích giúp ba mẹ có thể luôn theo sát và bên cạnh con mọi lúc, mọi nơi Với trang bị mạng di động 4G, đồng hồ Cleverkid mang lại những tính năng cực kì hiện đại và thiết kế năng động.',1864000,1305000,4,10
EXEC ThemSanPham N'Bộ bàn ghế trang điểm hồng đáng yêu','GIRL',N'ANH QUỐC',N'Bộ sản phẩm gồm 28 chi tiết với kích thước bộ bàn trang điểm sau khi lắp ráp xong là 49.5 x 24.5 x 69.5 (cm). Có đèn và âm thanh, 5 bài hát tự động phát nhờ cảm ứng ánh sáng ở gương, 3 hộc bàn cho bé đựng đồ dùng trang điểm',699000,489000,4,5

EXEC ThemSanPham N'JW khủng long UNCAGED DILOPHOSAURUS JURASSIC WORLD MATTEL HNT65','BOY',N'MỸ',N'Bộ khủng long ăn trứng để ra nhân vật Pop Egg đỏ có khả năng ăn trứng và đẻ trứng cực ngầu.',1299000,1209000,5,7
EXEC ThemSanPham N'JW Khủng Long INDOMINUS REX JURASSIC WORLD MATTEL HNT63','BOY',N'ANH QUỐC',N'Bộ khủng long ăn trứng để ra nhân vật Pop Egg đỏ có khả năng ăn trứng và đẻ trứng cực ngầu.',2139000,2099000,5,10
EXEC ThemSanPham N'JW Khủng Long T-Rex JURASSIC WORLD MATTEL HNT62','BOY',N'MỸ',N'Đồ chơi khủng long T-Rex của Jurassic World này có thể dễ dàng xoay sang bên để táp vào các đối thủ nào đó và phát ra tiếng gầm gừ y như trên phim. Điều này làm cho việc chơi trở nên thú vị hơn. Phiên bản khủng long nổi tiếng này bổ sung thêm nét đặc biệt cho bất kỳ bộ sưu tập nào.',1549000,1299000,5,6
EXEC ThemSanPham N'JW khủng long BOREALOPELTA 6 inch có khớp linh hoạt','BOY',N'TRUNG QUỐC',N'Mô hình Velociraptor dựa trên "Thần trí tuệ" của giống loài khủng long cổ đại (hay còn được gọi tắt là Raptor) có thể được coi là một trong những nhân tố chủ chốt góp phần làm nên sự thành công của thương hiệu phim Jurassic. Sở hữu chiều cao 3,3m, nặng trung bình 60kg với một bộ não thông minh để lên kế hoạch và giăng bẫy con mồi, loài khủng long này chính là những kẻ săn mồi đáng gờm trong thế giới hoang dã.',359000,279000,5,7
EXEC ThemSanPham N'JW khủng long DAKOSAURUS 6 inch có khớp linh hoạt','BOY',N'ANH QUỐC',N'Mô hình Velociraptor dựa trên "Thần trí tuệ" của giống loài khủng long cổ đại (hay còn được gọi tắt là Raptor) có thể được coi là một trong những nhân tố chủ chốt góp phần làm nên sự thành công của thương hiệu phim Jurassic. Sở hữu chiều cao 3,3m, nặng trung bình 60kg với một bộ não thông minh để lên kế hoạch và giăng bẫy con mồi, loài khủng long này chính là những kẻ săn mồi đáng gờm trong thế giới hoang dã.',494000,309000,5,3
EXEC ThemSanPham N'JW khủng long PYRORAPTOR 6 inch có khớp linh hoạt','BOY',N'ANH QUỐC',N'Mô hình Velociraptor dựa trên "Thần trí tuệ" của giống loài khủng long cổ đại (hay còn được gọi tắt là Raptor) có thể được coi là một trong những nhân tố chủ chốt góp phần làm nên sự thành công của thương hiệu phim Jurassic. Sở hữu chiều cao 3,3m, nặng trung bình 60kg với một bộ não thông minh để lên kế hoạch và giăng bẫy con mồi, loài khủng long này chính là những kẻ săn mồi đáng gờm trong thế giới hoang dã.',309000,199000,5,9
EXEC ThemSanPham N'JW Khủng long VELOCIRAPTOR (BLUE) 12 inch','BOY',N'MỸ',N'Mô hình Velociraptor dựa trên "Thần trí tuệ" của giống loài khủng long cổ đại (hay còn được gọi tắt là Raptor) có thể được coi là một trong những nhân tố chủ chốt góp phần làm nên sự thành công của thương hiệu phim Jurassic. Sở hữu chiều cao 3,3m, nặng trung bình 60kg với một bộ não thông minh để lên kế hoạch và giăng bẫy con mồi, loài khủng long này chính là những kẻ săn mồi đáng gờm trong thế giới hoang dã.',299000,189000,5,8
EXEC ThemSanPham N'JW khủng long HERRERASAURUS 12 inch','BOY',N'ANH QUỐC',N'Mô hình Velociraptor dựa trên "Thần trí tuệ" của giống loài khủng long cổ đại (hay còn được gọi tắt là Raptor) có thể được coi là một trong những nhân tố chủ chốt góp phần làm nên sự thành công của thương hiệu phim Jurassic. Sở hữu chiều cao 3,3m, nặng trung bình 60kg với một bộ não thông minh để lên kế hoạch và giăng bẫy con mồi, loài khủng long này chính là những kẻ săn mồi đáng gờm trong thế giới hoang dã.',1099000,989000,5,1
EXEC ThemSanPham N'Đồ chơi Khủng long dũng mãnh điều khiển từ xa Dilophosaurus VECTO VT401','BOY',N'ANH QUỐC',N'Đồ chơi Robot Khủng long dũng mãnh điều khiển từ xa Dilophosaurus từ VECTO chắc chắn sẽ là một món quà tuyệt vời cho các bé mê khủng long.',449000,359000,5,4
EXEC ThemSanPham N'JW khủng long tấn công PRESTOSUCHUS','BOY',N'TRUNG QUỐC',N'Hãy sẵn sàng cho cảm giác hồi hộp và phiêu lưu với những con khủng long Strike Attack, lấy cảm hứng từ Jurassic World Dominion, mỗi con có một tính năng tấn công duy nhất dành riêng cho loài.',479000,409000,5,2

EXEC ThemSanPham N'Búp bê Barbie thời trang - Grafitti Dress','GIRL',N'MỸ',N'Mỗi búp bê Barbie Fashionistas gồm bốn loại hình dạng cơ thể, chín tông màu da, chín màu mắt, 13 kiểu tóc và rất nhiều thời trang và phụ kiện phù hợp với xu hướng.',449000,379000,6,7
EXEC ThemSanPham N'Búp bê thời Barbie thời trang - Polka Dots, Lime Green','GIRL',N'MỸ',N'Mỗi búp bê Barbie Fashionistas gồm bốn loại hình dạng cơ thể, chín tông màu da, chín màu mắt, 13 kiểu tóc và rất nhiều thời trang và phụ kiện phù hợp với xu hướng.',299000,209000,6,9
EXEC ThemSanPham N'Búp bê Barbie thời trang - Curly Black Hair','GIRL',N'MỸ',N'Mỗi búp bê Barbie Fashionistas gồm bốn loại hình dạng cơ thể, chín tông màu da, chín màu mắt, 13 kiểu tóc và rất nhiều thời trang và phụ kiện phù hợp với xu hướng.',749000,549000,6,1
EXEC ThemSanPham N'Búp bê thời Barbie thời trang - Crochet Halter Dress','GIRL',N'MỸ',N'Mỗi búp bê Barbie Fashionistas gồm bốn loại hình dạng cơ thể, chín tông màu da, chín màu mắt, 13 kiểu tóc và rất nhiều thời trang và phụ kiện phù hợp với xu hướng.',469000,399000,6,3
EXEC ThemSanPham N'Búp bê Barbie thời trang - Heart-Print Sweater','GIRL',N'MỸ',N'Mỗi búp bê Barbie Fashionistas gồm bốn loại hình dạng cơ thể, chín tông màu da, chín màu mắt, 13 kiểu tóc và rất nhiều thời trang và phụ kiện phù hợp với xu hướng.',449000,329000,6,6
EXEC ThemSanPham N'Búp bê Barbie thời trang - Floral Dress','GIRL',N'MỸ',N'Mỗi búp bê Barbie Fashionistas gồm bốn loại hình dạng cơ thể, chín tông màu da, chín màu mắt, 13 kiểu tóc và rất nhiều thời trang và phụ kiện phù hợp với xu hướng.',199000,159000,6,8
EXEC ThemSanPham N'Mô Hình Spotlight POP MART 13th Anniversary POP MART 6941848250810','UNISEX',N'ANH QUỐC',N'Spotlight POP MART 13th Anniversary với bộ sưu tập tổng hợp các nhân vật hot của POP MART. Với một dịp đặc biệt kỉ niệm lần thứ 13, POP MART đem đến cho các fan những mô hình thật chất lượng của các nhân vật như: Skullpanda, Molly, Dimoo, Hirono, Hacipupu, The Monster, ViVicat, ...',280000,249000,6,5
EXEC ThemSanPham N'Mô Hình HACIPUPU In My Dream POP MART 6941848241887','UNISEX',N'ANH QUỐC',N'HACIPUPU In My Dream là dòng sản phẩm đồ chơi nghệ thuật do Pop Mart và Hacipupu sáng tạo, mô tả nhân vật Hacipupu trong các kịch bản giấc mơ khác nhau. Bộ sản phẩm bao gồm 12 thiết kế lấy cảm hứng từ nhiều chủ đề khác nhau như truyện cổ tích, không gian, âm nhạc và món tráng miệng.',379000,209000,6,4
EXEC ThemSanPham N'Mô Hình DUCKOO FARM POP MART 6941848238412','UNISEX',N'TRUNG QUỐC',N'DUCKOO In My Dream là dòng sản phẩm đồ chơi nghệ thuật do Pop Mart và Hacipupu sáng tạo, mô tả nhân vật Hacipupu trong các kịch bản giấc mơ khác nhau. Bộ sản phẩm bao gồm 12 thiết kế lấy cảm hứng từ nhiều chủ đề khác nhau như truyện cổ tích, không gian, âm nhạc và món tráng miệng.',240000,179000,6,10
EXEC ThemSanPham N'Mô Hình SKULLPANDA The Ink Plum Blossom POP MART 6941848238177','UNISEX',N'ANH QUỐC',N'Mô Hình SKULLPANDA The Ink Plum Blossom 6941848238177 Skullpanda trở lại với hình ảnh không thể rự rỡ hơn. Hình ảnh cô nàng Skullpanda ma mị nhưng không kém phần quyến rũ với concept hoa mận nở rộ. ',294000,199000,6,2

EXEC ThemSanPham N'Vali bác sĩ màu hồng','GIRL',N'PHÁP',N'Đồ chơi vali bác sĩ màu hồng ECOIFFIER 002875 mô phỏng dụng cụ y tế, bé cùng bạn bè sẽ đóng vai y tá hoặc bác sĩ. Thông qua món đồ chơi nhập vai này, bố mẹ có thể giúp con có nhận thức về lĩnh vực y tế, có cái nhìn bao quát về sức khỏe, hơn nữa là không làm con sợ hãi khi đi khám bệnh. ',379000,309000,7,9
EXEC ThemSanPham N'Bộ đồ ăn cho bé','GIRL',N'ANH QUỐC',N'Nâng tầm ngôi nhà, văn phòng của bạn với bộ mô hình Hoa lan LEGO® xinh đẹp này. Hãy dành thời gian thư giãn để tạo ra tất cả các chi tiết của những bông hoa trắng và hồng, cùng với chiếc bình màu xanh lam.',529000,370000,7,10
EXEC ThemSanPham N'Đồ chơi bé làm bác sĩ','UNISEX',N'TRUNG QUỐC',N'Đồ chơi B.BRAND bé làm bác sĩ BX1230Z là đồ chơi hàng đầu tại Canada, sử dụng công nghệ tiên tiến giúp bé có thể vừa vui chơi vừa làm quen với các hoạt động gần gũi với thế giới quan. Các sản phẩm đồ chơi B.Brand đều có một giá trị nhất định về giáo dục, phát triển kỹ năng vận động, tư duy logic, sự sáng tạo qua các dòng sản phẩm đồ chơi của hãng.',879000,829000,7,2
EXEC ThemSanPham N'Bộ đồ chơi bác sĩ','GIRL',N'CANADA',N'Bộ đồ chơi nhập vai bác sĩ giúp bé hóa thân thành bác sĩ để có thể hiểu biết thêm về công việc. Từ đây giúp bé hiểu hơn về 1 trong các ngành nghề trong xã hội và phần nào định hướng được nghề nghiệp của bé sau này.',439000,419000,7,1
EXEC ThemSanPham N'Bộ đồ chơi bác sĩ thú cưng','UNISEX',N'ANH QUỐC',N'Bộ đồ chơi đáng yêu này có thể giúp bé tập làm bác sĩ, khám phá về cách chăm sóc sức khỏe thú cưng.',799000,699000,7,4
EXEC ThemSanPham N'Bộ Lò Vi Sóng Và Các Món Ăn Thịnh Soạn SWEET HEART SH8610','BOY',N'ANH QUỐC',N'Lò vi sóng mini nhỏ xinh có đèn, âm thanh, chế độ rung và xoay 360 độ như thật. Màn hình điện tử hiện thời gian cần hâm nóng từng loại thức ăn riêng biệt. Bé có thể chọn từng loại thức ăn mà bé thích bằng các phím tùy chọn trên máy. Sản phẩm giúp cho bé làm quen và hứng thú với máy móc và công việc làm bếp từ bé, nuôi dưỡng ước mơ và sở thích, niềm vui được chăm sóc gia đình. Combo có 2 màu xanh nhạt và hồng nhạt cho bé lựa chọn',499000,399000,7,5
EXEC ThemSanPham N'Bộ Quầy Siêu Thị Mini SWEET HEART SH668-124','UNISEX',N'VIỆT NAM',N'Bộ quầy siêu thị với 46 chi tiết cho bé thỏa vui chơi cùng bố mẹ hoặc bạn bè.',399000,259000,7,3
EXEC ThemSanPham N'Combo Đồ Gia Dụng: Máy Hút Bụi Và Máy Giặt SWEET HEART SH471548','UNISEX',N'ANH QUỐC',N'Bộ sản phẩm đồ gia dụng được thiết kế như thật. Có sử dụng pin, có phát ra âm thanh khi chơi, hoạt động như máy thật, giúp bé phát triển kỹ năng ứng dụng thực tế.',249000,219000,7,8
EXEC ThemSanPham N'Combo Đồ Gia Dụng: Máy Xay Sinh Tố Và Máy Pha Cà Phê SWEET HEART SH471547','UNISEX',N'TRUNG QUỐC',N'Bộ sản phẩm đồ gia dụng được thiết kế như thật. Có sử dụng pin, có phát ra âm thanh khi chơi, hoạt động như máy thật, giúp bé phát triển kỹ năng ứng dụng thực tế.',899000,709000,7,7
EXEC ThemSanPham N'Đồ Chơi Đũa Phép Hội Pháp Sư Voldermort WIZARDING WORLD 20143285','UNISEX',N'ANH QUỐC',N'Thế giới phép thuật Harry Potter tràn đầy những phù thủy và pháp sư tối thượng với những chiếc đũa phép và gậy pháp sư có quyền năng vô hạn. Đũa phép chọn phù thủy, những chiếc đũa trong thế giới màu nhiệm này được ví như tấm thẻ định danh và là công cụ đắc lực trong việc thể hiện tài phép của chủ nhân chúng. Mỗi một chiếc đũa đều là một sự kết hợp độc nhất từ một loại gỗ và lõi phép thuật có một không hai cho phép thực hành và tạo ra những câu thần chú mạnh mẽ nhất.',199000,149000,7,6

EXEC ThemSanPham N'Thú nhồi bông - Heo nằm 60cm SWEET HEART PLUSH AH23061/60','UNISEX',N'TRUNG QUỐC',N'Đồ chơi thú nhồi bông SWEET HEART – với nhiều hình dạng và kích thước khác nhau cho bé thoải mái lựa chọn. Ngoài ra, với chất lông mềm mịn, tạo cảm giác dễ chịu và an toàn cho bé khi ôm ấp.',319000,249000,8,6
EXEC ThemSanPham N'Thú nhồi bông - Vịt đội nón ếch 40cm SWEET HEART PLUSH AH23040/40','UNISEX',N'VIỆT NAM',N'Đồ chơi thú nhồi bông SWEET HEART – với nhiều hình dạng và kích thước khác nhau cho bé thoải mái lựa chọn. Ngoài ra, với chất lông mềm mịn, tạo cảm giác dễ chịu và an toàn cho bé khi ôm ấp.',199000,179000,8,2
EXEC ThemSanPham N'Thú nhồi bông - Vịt vàng 40cm SWEET HEART PLUSH AH23008/40','UNISEX',N'VIỆT NAM',N'Đồ chơi thú nhồi bông SWEET HEART – với nhiều hình dạng và kích thước khác nhau cho bé thoải mái lựa chọn. Ngoài ra, với chất lông mềm mịn, tạo cảm giác dễ chịu và an toàn cho bé khi ôm ấp.',294000,209000,8,3
EXEC ThemSanPham N'Thú nhồi bông - Heo nơ hồng 40cm SWEET HEART PLUSH AH23003/40','UNISEX',N'VIỆT NAM',N'Đồ chơi thú nhồi bông SWEET HEART – với nhiều hình dạng và kích thước khác nhau cho bé thoải mái lựa chọn. Ngoài ra, với chất lông mềm mịn, tạo cảm giác dễ chịu và an toàn cho bé khi ôm ấp.',205000,179000,8,8
EXEC ThemSanPham N'Thú nhồi bông - Khủng long hồng 90cm SWEET HEART PLUSH AH22122/90','UNISEX',N'VIỆT NAM',N'Đồ chơi thú nhồi bông SWEET HEART – với nhiều hình dạng và kích thước khác nhau cho bé thoải mái lựa chọn. Ngoài ra, với chất lông mềm mịn, tạo cảm giác dễ chịu và an toàn cho bé khi ôm ấp.',319000,229000,8,9
EXEC ThemSanPham N'Thú nhồi bông - Gấu nâu 24cm SWEET HEART PLUSH AH22035/24','UNISEX',N'TRUNG QUỐC',N'Đồ chơi thú nhồi bông SWEET HEART – với nhiều hình dạng và kích thước khác nhau cho bé thoải mái lựa chọn. Ngoài ra, với chất lông mềm mịn, tạo cảm giác dễ chịu và an toàn cho bé khi ôm ấp.',169000,100000,8,4
EXEC ThemSanPham N'Thỏ con Iris - Baby Iris Rabbit IWAYA 3183-2VN/JS','UNISEX',N'VIỆT NAM',N'Bé nào cũng luôn muốn được sở hữu một bé pet đáng yêu. Vậy thì tại sao không tậu ngay cho bé một thỏ trắng đến từ thương hiệu Iwaya của Nhật Bản',299000,279000,8,10
EXEC ThemSanPham N'Cún con R/C - Pomeranian IWAYA 3159-2VN/JS','UNISEX',N'VIỆT NAM',N'Bé nào cũng luôn muốn được sở hữu một chú cún đáng yêu. Vậy thì tại sao không tậu ngay cho bé một chú cún Iwaya đến từ Nhật Bản',399000,359000,8,1
EXEC ThemSanPham N'Cún con - Baby Retriever IWAYA 3114-6VN/JS','UNISEX',N'VIỆT NAM',N'Bé nào cũng luôn muốn được sở hữu một chú cún đáng yêu. Vậy thì tại sao không tậu ngay cho bé một chú cún Iwaya đến từ Nhật Bản',229000,157000,8,5
EXEC ThemSanPham N'Đồ chơi thú bông bạn Tigger người tuyết 8','UNISEX',N'VIỆT NAM',N'Những người bạn bước ra từ bộ phim nổi tiếng Winnie The Pooh với Pooh; Tigger; Piglet đang hóa trang thành những người tuyết thật đáng yêu cùng những phụ kiện ấm áp cho mùa Giáng sinh.',217000,179000,8,7

EXEC ThemSanPham N'Mô hình Earthspark Warrior Thrash','UNISEX',N'NHẬT BẢN',N'Đồ chơi Transformers mô hình Earthspark F6229 mô phỏng theo hoạt hình nổi tiếng được chuyển thể từ Transfomers và vẫn được đông đảo mọi người xem và theo dõi. Cho đến nay toàn bộ vũ trụ Transformers, các nhân vật đều được tạo hình robot và có thể lắp ráp thay đổi y như các nhân vật trong truyện tranh, phim ảnh.',799000,709000,9,7
EXEC ThemSanPham N'Mô hình Earthspark Warrior Megatron','UNISEX',N'NHẬT BẢN',N'Đồ chơi Transformers mô hình Earthspark F6229 mô phỏng theo hoạt hình nổi tiếng được chuyển thể từ Transfomers và vẫn được đông đảo mọi người xem và theo dõi. Cho đến nay toàn bộ vũ trụ Transformers, các nhân vật đều được tạo hình robot và có thể lắp ráp thay đổi y như các nhân vật trong truyện tranh, phim ảnh.',794000,599000,9,5
EXEC ThemSanPham N'Mô hình Earthspark Breakdown biến hình thần tốc 1 bước','UNISEX',N'NHẬT BẢN',N'Đồ chơi Transformers mô hình Earthspark F6229 mô phỏng theo hoạt hình nổi tiếng được chuyển thể từ Transfomers và vẫn được đông đảo mọi người xem và theo dõi. Cho đến nay toàn bộ vũ trụ Transformers, các nhân vật đều được tạo hình robot và có thể lắp ráp thay đổi y như các nhân vật trong truyện tranh, phim ảnh.',540000,499000,9,8
EXEC ThemSanPham N'Mô hình Earthspark Twitch biến hình thần tốc 1 bước','UNISEX',N'MỸ',N'Đồ chơi Transformers mô hình Earthspark F6229 mô phỏng theo hoạt hình nổi tiếng được chuyển thể từ Transfomers và vẫn được đông đảo mọi người xem và theo dõi. Cho đến nay toàn bộ vũ trụ Transformers, các nhân vật đều được tạo hình robot và có thể lắp ráp thay đổi y như các nhân vật trong truyện tranh, phim ảnh.',1090000,989000,9,1
EXEC ThemSanPham N'Mô hình Earthspark Megatron biến hình thần tốc 1 bước','UNISEX',N'MỸ',N'Đồ chơi Transformers mô hình Earthspark F6229 mô phỏng theo hoạt hình nổi tiếng được chuyển thể từ Transfomers và vẫn được đông đảo mọi người xem và theo dõi. Cho đến nay toàn bộ vũ trụ Transformers, các nhân vật đều được tạo hình robot và có thể lắp ráp thay đổi y như các nhân vật trong truyện tranh, phim ảnh.',549000,509000,9,3
EXEC ThemSanPham N'Mô hình Movie 7 Rhinox dòng Voyager TRANSFORMERS F5476','UNISEX',N'ANH QUỐC',N'Bộ đồ chơi robot chiến binh biến hình Core Boy Voyager Class Optimus Primal Transformers được thiết kế tỉ mỉ đã tạo nên đồ chơi lắp ráp robot có khả năng di chuyển, cử động như thật từ đó cho bé thỏa sức sáng tạo, xây dựng nên những câu chuyện thú vị.',1499000,1400000,9,6
EXEC ThemSanPham N'Đồ chơi Robot chiến binh tinh nhuệ điều khiển từ xa VECTO VTG16','UNISEX',N'ANH QUỐC',N'Robot điều khiển từ xa Trooper chiến binh tinh nhuệ từ VECTO – Món đồ chơi với ngoại hình cực ngầu và hiện đại, cùng đa dạng chức năng cho bé chơi thật vui',699000,679000,9,2
EXEC ThemSanPham N'Đồ chơi Robot biến hình Xe xúc VECTO VT35','UNISEX',N'TRUNG QUỐC',N'Robot điều khiển từ xa Trooper chiến binh tinh nhuệ từ VECTO – Món đồ chơi với ngoại hình cực ngầu và hiện đại, cùng đa dạng chức năng cho bé chơi thật vui',139000,109000,9,10
EXEC ThemSanPham N'Đồ chơi Robot biến hình Xe cứu hỏa thang nâng VECTO VT35','UNISEX',N'TRUNG QUỐC',N'Robot điều khiển từ xa Trooper chiến binh tinh nhuệ từ VECTO – Món đồ chơi với ngoại hình cực ngầu và hiện đại, cùng đa dạng chức năng cho bé chơi thật vui',129000,99000,9,4
EXEC ThemSanPham N'Đồ chơi Robot biến hình Xe cần cẩu VECTO VT35','UNISEX',N'TRUNG QUỐC',N'Robot điều khiển từ xa Trooper chiến binh tinh nhuệ từ VECTO – Món đồ chơi với ngoại hình cực ngầu và hiện đại, cùng đa dạng chức năng cho bé chơi thật vui',129000,99000,9,9

EXEC ThemSanPham N'Máy đọc chữ thông minh cho bé PEEK A BOO PAB043','GIRL',N'CANADA',N'Cùng học tiếng Anh vừa vui vừa hiệu quả cùng với Bộ máy đọc chữ thông minh của PEEK A BOO! Với đa dạng chủ để để khám phá, bé có thể nhanh chóng học nhiều từ vựng và câu nói thường ngày, rèn luyện khả năng phối hợp tai-mắt.',797000,609000,10,8
EXEC ThemSanPham N'Polly Pocket và Bữa Tiệc Bất Ngờ Của Hồng Hạc Flamingo POLLY POCKET HGC41','GIRL',N'PHÁP',N'Đó là một bữa tiệc nhiệt đới với vở kịch Polly Pocket Flamingo Party! Bắt đầu bữa tiệc vui vẻ bằng cách kéo các tấm lụa màu sắc ở chân chim hồng hạc và sau đó dòng hoa giấy đầy màu sắc và 26 điều bất ngờ rơi ra từ bộ đồ chơi!',859000,789000,10,7
EXEC ThemSanPham N'Polly Pocket và Gia Đình Kangaroo Đáng Yêu','GIRL',N'ANH QUỐC',N'Polly Pocket và Gia Đình Kangaroo Đáng Yêu Chiếc túi nhỏ Polly Pocket Mama và Joey Kangaroo mở ra để lộ một thế giới nhỏ đầy những cuộc phiêu lưu lớn! Chiếc túi hình kangaroo có vẻ ngoài ngọt ngào và túi bên ngoài mềm mại, vui nhộn khi chạm vào và một bé kangaroo có thể tháo rời ẩn chứa điều bất ngờ bên trong! Mở túi để lộ một bộ đồ chơi phiêu lưu bao gồm 2 em bé siêu nhỏ, 7 nhân vật động vật đáng yêu, các phụ kiện đi kèm và phòng chăm sóc động vật với các hoạt động thú vị để vui chơi cả ngày! ',429000,400000,10,6
EXEC ThemSanPham N'Siêu xe HW BOULEVARD - 77 HOLDEN TORANA A9X','BOY',N'ANH QUỐC',N'Holden Torana là một chiếc ô tô cỡ trung do Holden sản xuất từ năm 1967 đến năm 1980. Được thiết kế bởi Leo Pruneau và Joe Schemansky, LX Torana được giới thiệu vào năm 1976 để thay thế LH, nhưng với tất cả ý định và mục đích là một bản nâng cấp nhẹ. Tùy chọn A9X trên Torana đã có sẵn, giúp chiếc xe có mui xe và các cải tiến hiệu suất khác. 65.977 chiếc LX Torana được sản xuất.',399000,329000,10,10
EXEC ThemSanPham N'Polly Pocket và Tiệc Ngủ Của Cú Tuyết','GIRL',N'NGA',N'Sản phẩm đồ chơi lấy cảm hứng từ ngôi nhà của Polly ở quê hương Pollyville ™ nhỏ bé của cô. Với chủ đề giữ trẻ, Pocket House được thiết kế để trẻ em có thể xây dựng nên 4 câu chuyện khác nhau.',1199000,1000000,10,9
EXEC ThemSanPham N'Polly Pocket và Khu Vườn Thỏ Ngọc','GIRL',N'ANH QUỐC',N'Polly Pocket Flower Garden Bunny Compact này mở ra một khu vườn thỏ ngoài trời với búp bê Shani và bạn bè!',879000,659000,10,1
EXEC ThemSanPham N'Polly Pocket và Spa thư giãn với cún Poodle','GIRL',N'ANH QUỐC',N'Polly Pocket Groom & Glam Poodle Compact này mở ra chủ đề spa cho thú cưng với búp bê Lila và người bạn!',259000,219000,10,3
EXEC ThemSanPham N'Polly Pocket và Trạm Lướt Sóng Của Unicorn','GIRL',N'TRUNG QUỐC',N'Polly Pocket Groom & Glam Poodle Compact này mở ra chủ đề spa cho thú cưng với búp bê Lila và người bạn!',619000,464000,10,2
EXEC ThemSanPham N'Bộ đồ chơi banh mềm 5 món cho bé FISHER-PRICE F0906','GIRL',N'TRUNG QUỐC',N'Đây là bộ đồ chơi hổ biến cho các bé ở giai đoạn phát triển đầu đời, giúp bé phát triển vận động tinh qua việc càm nắm',619000,464000,10,5
EXEC ThemSanPham N'Hộp Nhạc Karaoke Đa năng Của Peppa Pig PEPPA PIG 1684914','GIRL',N'ANH QUỐC',N'Hộp Nhạc Hát Karaoke Sắc Màu Của Peppa Pig là bộ sản phẩm thú vị dành cho các bé mê âm nhạc và yêu thích ca hát. Khoa học đã chứng minh “âm nhạc” giúp bé tập trung và phát triển ngôn ngữ. Khi bé chơi đồ chơi phát ra âm thanh, bé sẽ rất tập trung lắng nghe và tìm hiểu. Điều này giúp khả năng tiếp',619000,509000,10,4

GO

INSERT INTO ImageSanPham(MaSanPham, ImageURL) VALUES
(1, 'sp1_img1.jpg'),(1, 'sp1_img2.jpg'),(1, 'sp1_img3.jpg'),(1, 'sp1_img4.jpg'), 
(2, 'sp2_img1.jpg'),(2, 'sp2_img2.jpg'),(2, 'sp2_img3.jpg'),(2, 'sp2_img4.jpg'),
(3, 'sp3_img1.jpg'),(3, 'sp3_img2.jpg'),(3, 'sp3_img3.jpg'),(3, 'sp3_img4.jpg'),
(4, 'sp4_img1.jpg'),(4, 'sp4_img2.jpg'),(4, 'sp4_img3.jpg'),(4, 'sp4_img4.jpg'),
(5, 'sp5_img1.jpg'),(5, 'sp5_img2.jpg'),(5, 'sp5_img3.jpg'),(5, 'sp5_img4.jpg'),
(6, 'sp6_img1.jpg'),(6, 'sp6_img2.jpg'),(6, 'sp6_img3.jpg'),(6, 'sp6_img4.jpg'),
(7, 'sp7_img1.jpg'),(7, 'sp7_img2.jpg'),(7, 'sp7_img3.jpg'),(7, 'sp7_img4.jpg'),
(8, 'sp8_img1.jpg'),(8, 'sp8_img2.jpg'),(8, 'sp8_img3.jpg'),(8, 'sp8_img4.jpg'),
(9, 'sp9_img1.jpg'),(9, 'sp9_img2.jpg'),(9, 'sp9_img3.jpg'),(9, 'sp9_img4.jpg'),
(10, 'sp10_img1.jpg'),(10, 'sp10_img2.jpg'),(10, 'sp10_img3.jpg'),(10, 'sp10_img4.jpg'),
(11, 'sp11_img1.jpg'),(11, 'sp11_img2.jpg'),(11, 'sp11_img3.jpg'),(11, 'sp11_img4.jpg'),
(12, 'sp12_img1.jpg'),(12, 'sp12_img2.jpg'),(12, 'sp12_img3.jpg'),(12, 'sp12_img4.jpg'),
(13, 'sp13_img1.jpg'),(13, 'sp13_img2.jpg'),(13, 'sp13_img3.jpg'),(13, 'sp13_img4.jpg'),
(14, 'sp14_img1.jpg'),(14, 'sp14_img2.jpg'),
(15, 'sp15_img1.jpg'),(15, 'sp15_img2.jpg'),(15, 'sp15_img3.jpg'),(15, 'sp15_img4.jpg'),
(16, 'sp16_img1.jpg'),(16, 'sp16_img2.jpg'),(16, 'sp16_img3.jpg'),(16, 'sp16_img4.jpg'),
(17, 'sp17_img1.jpg'),(17, 'sp17_img2.jpg'),(17, 'sp17_img3.jpg'),(17, 'sp17_img4.jpg'),
(18, 'sp18_img1.jpg'),(18, 'sp18_img2.jpg'),(18, 'sp18_img3.jpg'),(18, 'sp18_img4.jpg'),
(19, 'sp19_img1.jpg'),(19, 'sp19_img2.jpg'),(19, 'sp19_img3.jpg'),(19, 'sp19_img4.jpg'),
(20, 'sp20_img1.jpg'),(20, 'sp20_img2.jpg'),(20, 'sp20_img3.jpg'),(20, 'sp20_img4.jpg'),
(21, 'sp21_img1.jpg'),(21, 'sp21_img2.jpg'),(21, 'sp21_img3.jpg'),(21, 'sp21_img4.jpg'),
(22, 'sp22_img1.jpg'),(22, 'sp22_img2.jpg'),(22, 'sp22_img3.jpg'),(22, 'sp22_img4.jpg'),
(23, 'sp23_img1.jpg'),(23, 'sp23_img2.jpg'),(23, 'sp23_img3.jpg'),(23, 'sp23_img4.jpg'),
(24, 'sp24_img1.jpg'),(24, 'sp24_img2.jpg'),(24, 'sp24_img3.jpg'),(24, 'sp24_img4.jpg'),
(25, 'sp25_img1.jpg'),(25, 'sp25_img2.jpg'),
(26, 'sp26_img1.jpg'),(26, 'sp26_img2.jpg'),(26, 'sp26_img3.jpg'),	
(27, 'sp27_img1.jpg'),(27, 'sp27_img2.jpg'),(27, 'sp27_img3.jpg'),
(28, 'sp28_img1.jpg'),(28, 'sp28_img2.jpg'),(28, 'sp28_img3.jpg'),(28, 'sp28_img4.jpg'),
(29, 'sp29_img1.jpg'),(29, 'sp29_img2.jpg'),(29, 'sp29_img3.jpg'),(29, 'sp29_img4.jpg'),
(30, 'sp30_img1.jpg'),(30, 'sp30_img2.jpg'),(30, 'sp30_img3.jpg'),(30, 'sp30_img4.jpg'),
(31, 'sp31_img1.jpg'),(31, 'sp31_img2.jpg'),(31, 'sp31_img3.jpg'),(31, 'sp31_img4.jpg'),
(32, 'sp32_img1.jpg'),(32, 'sp32_img2.jpg'),(32, 'sp32_img3.jpg'),(32, 'sp32_img4.jpg'),
(33, 'sp33_img1.jpg'),(33, 'sp33_img2.jpg'),(33, 'sp33_img3.jpg'),(33, 'sp33_img4.jpg'),
(34, 'sp34_img1.jpg'),(34, 'sp34_img2.jpg'),(34, 'sp34_img3.jpg'),(34, 'sp34_img4.jpg'),
(35, 'sp35_img1.jpg'),(35, 'sp35_img2.jpg'),(35, 'sp35_img3.jpg'),(35, 'sp35_img4.jpg'),
(36, 'sp36_img1.jpg'),(36, 'sp36_img2.jpg'),(36, 'sp36_img3.jpg'),(36, 'sp36_img4.jpg'),
(37, 'sp37_img1.jpg'),(37, 'sp37_img2.jpg'),(37, 'sp37_img3.jpg'),
(38, 'sp38_img1.jpg'),(38, 'sp38_img2.jpg'),(38, 'sp38_img3.jpg'),
(39, 'sp39_img1.jpg'),(39, 'sp39_img2.jpg'),(39, 'sp39_img3.jpg'),(39, 'sp39_img4.jpg'),
(40, 'sp40_img1.jpg'),(40, 'sp40_img2.jpg'),(40, 'sp40_img3.jpg'),(40, 'sp40_img4.jpg'),
(41, 'sp41_img1.jpg'),(41, 'sp41_img2.jpg'),(41, 'sp41_img3.jpg'),(41, 'sp41_img4.jpg'),
(42, 'sp42_img1.jpg'),(42, 'sp42_img2.jpg'),(42, 'sp42_img3.jpg'),(42, 'sp42_img4.jpg'),
(43, 'sp43_img1.jpg'),(43, 'sp43_img2.jpg'),(43, 'sp43_img3.jpg'),(43, 'sp43_img4.jpg'),
(44, 'sp44_img1.jpg'),(44, 'sp44_img2.jpg'),(44, 'sp44_img3.jpg'),(44, 'sp44_img4.jpg'),
(45, 'sp45_img1.jpg'),(45, 'sp45_img2.jpg'),(45, 'sp45_img3.jpg'),(45, 'sp45_img4.jpg'),
(46, 'sp46_img1.jpg'),(46, 'sp46_img2.jpg'),(46, 'sp46_img3.jpg'),(46, 'sp46_img4.jpg'),
(47, 'sp47_img1.jpg'),(47, 'sp47_img2.jpg'),(47, 'sp47_img3.jpg'),
(48, 'sp48_img1.jpg'),(48, 'sp48_img2.jpg'),(48, 'sp48_img3.jpg'),(48, 'sp48_img4.jpg'),
(49, 'sp49_img1.jpg'),(49, 'sp49_img2.jpg'),(49, 'sp49_img3.jpg'),
(50, 'sp50_img1.jpg'),(50, 'sp50_img2.jpg'),(50, 'sp50_img3.jpg'),
(51, 'sp51_img1.jpg'),(51, 'sp51_img2.jpg'),(51, 'sp51_img3.jpg'),(51, 'sp51_img4.jpg'),
(52, 'sp52_img1.jpg'),(52, 'sp52_img2.jpg'),(52, 'sp52_img3.jpg'),(52, 'sp52_img4.jpg'),
(53, 'sp53_img1.jpg'),(53, 'sp53_img2.jpg'),(53, 'sp53_img3.jpg'),(53, 'sp53_img4.jpg'),
(54, 'sp54_img1.jpg'),(54, 'sp54_img2.jpg'),(54, 'sp54_img3.jpg'),(54, 'sp54_img4.jpg'),
(55, 'sp55_img1.jpg'),(55, 'sp55_img2.jpg'),(55, 'sp55_img3.jpg'),(55, 'sp55_img4.jpg'),
(56, 'sp56_img1.jpg'),(56, 'sp56_img2.jpg'),(56, 'sp56_img3.jpg'),(56, 'sp56_img4.jpg'),
(57, 'sp57_img1.jpg'),(57, 'sp57_img2.jpg'),(57, 'sp57_img3.jpg'),(57, 'sp57_img4.jpg'),
(58, 'sp58_img1.jpg'),(58, 'sp58_img2.jpg'),(58, 'sp58_img3.jpg'),(58, 'sp58_img4.jpg'),
(59, 'sp59_img1.jpg'),(59, 'sp59_img2.jpg'),(59, 'sp59_img3.jpg'),(59, 'sp59_img4.jpg'),
(60, 'sp60_img1.jpg'),(60, 'sp60_img2.jpg'),(60, 'sp60_img3.jpg'),(60, 'sp60_img4.jpg'),
(61, 'sp61_img1.jpg'),(61, 'sp61_img2.jpg'),(61, 'sp61_img3.jpg'),
(62, 'sp62_img1.jpg'),(62, 'sp62_img2.jpg'),
(63, 'sp63_img1.jpg'),(63, 'sp63_img2.jpg'),(63, 'sp63_img3.jpg'),(63, 'sp63_img4.jpg'),
(64, 'sp64_img1.jpg'),(64, 'sp64_img2.jpg'),(64, 'sp64_img3.jpg'),(64, 'sp64_img4.jpg'),
(65, 'sp65_img1.jpg'),(65, 'sp65_img2.jpg'),(65, 'sp65_img3.jpg'),(65, 'sp65_img4.jpg'),
(66, 'sp66_img1.jpg'),(66, 'sp66_img2.jpg'),(66, 'sp66_img3.jpg'),(66, 'sp66_img4.jpg'),
(67, 'sp67_img1.jpg'),(67, 'sp67_img2.jpg'),(67, 'sp67_img3.jpg'),(67, 'sp67_img4.jpg'),
(68, 'sp68_img1.jpg'),(68, 'sp68_img2.jpg'),(68, 'sp68_img3.jpg'),
(69, 'sp69_img1.jpg'),(69, 'sp69_img2.jpg'),(69, 'sp69_img3.jpg'),
(70, 'sp70_img1.jpg'),(70, 'sp70_img2.jpg'),(70, 'sp70_img3.jpg'),(70, 'sp70_img4.jpg'),
(71, 'sp71_img1.jpg'),(71, 'sp71_img2.jpg'),
(72, 'sp72_img1.jpg'),(72, 'sp72_img2.jpg'),
(73, 'sp73_img1.jpg'),(73, 'sp73_img2.jpg'),
(74, 'sp74_img1.jpg'),(74, 'sp74_img2.jpg'),
(75, 'sp75_img1.jpg'),(75, 'sp75_img2.jpg'),
(76, 'sp76_img1.jpg'),(76, 'sp76_img2.jpg'),
(77, 'sp77_img1.jpg'),(77, 'sp77_img2.jpg'),(77, 'sp77_img3.jpg'),(77, 'sp77_img4.jpg'),
(78, 'sp78_img1.jpg'),(78, 'sp78_img2.jpg'),(78, 'sp78_img3.jpg'),
(79, 'sp79_img1.jpg'),(79, 'sp79_img2.jpg'),(79, 'sp79_img3.jpg'),
(80, 'sp80_img1.jpg'),(80, 'sp80_img2.jpg'),(80, 'sp80_img3.jpg'),(80, 'sp80_img4.jpg'),
(81, 'sp81_img1.jpg'),(81, 'sp81_img2.jpg'),(81, 'sp81_img3.jpg'),(81, 'sp81_img4.jpg'),
(82, 'sp82_img1.jpg'),(82, 'sp82_img2.jpg'),(82, 'sp82_img3.jpg'),(82, 'sp82_img4.jpg'),
(83, 'sp83_img1.jpg'),(83, 'sp83_img2.jpg'),(83, 'sp83_img3.jpg'),(83, 'sp83_img4.jpg'),
(84, 'sp84_img1.jpg'),(84, 'sp84_img2.jpg'),(84, 'sp84_img3.jpg'),
(85, 'sp85_img1.jpg'),(85, 'sp85_img2.jpg'),(85, 'sp85_img3.jpg'),(85, 'sp85_img4.jpg'),
(86, 'sp86_img1.jpg'),(86, 'sp86_img2.jpg'),(86, 'sp86_img3.jpg'),(86, 'sp86_img4.jpg'),
(87, 'sp87_img1.jpg'),(87, 'sp87_img2.jpg'),(87, 'sp87_img3.jpg'),(87, 'sp87_img4.jpg'),
(88, 'sp88_img1.jpg'),(88, 'sp88_img2.jpg'),(88, 'sp88_img3.jpg'),(88, 'sp88_img4.jpg'),
(89, 'sp89_img1.jpg'),(89, 'sp89_img2.jpg'),(89, 'sp89_img3.jpg'),(89, 'sp89_img4.jpg'),
(90, 'sp90_img1.jpg'),(90, 'sp90_img2.jpg'),(90, 'sp90_img3.jpg'),(90, 'sp90_img4.jpg'),
(91, 'sp91_img1.jpg'),(91, 'sp91_img2.jpg'),(91, 'sp91_img3.jpg'),(91, 'sp91_img4.jpg'),
(92, 'sp92_img1.jpg'),(92, 'sp92_img2.jpg'),(92, 'sp92_img3.jpg'),(92, 'sp92_img4.jpg'),
(93, 'sp93_img1.jpg'),(93, 'sp93_img2.jpg'),(93, 'sp93_img3.jpg'),(93, 'sp93_img4.jpg'),
(94, 'sp94_img1.jpg'),(94, 'sp94_img2.jpg'),(94, 'sp94_img3.jpg'),
(95, 'sp95_img1.jpg'),(95, 'sp95_img2.jpg'),(95, 'sp95_img3.jpg'),(95, 'sp95_img4.jpg'),
(96, 'sp96_img1.jpg'),(96, 'sp96_img2.jpg'),(96, 'sp96_img3.jpg'),(96, 'sp96_img4.jpg'),
(97, 'sp97_img1.jpg'),(97, 'sp97_img2.jpg'),(97, 'sp97_img3.jpg'),(97, 'sp97_img4.jpg'),
(98, 'sp98_img1.jpg'),(98, 'sp98_img2.jpg'),(98, 'sp98_img3.jpg'),(98, 'sp98_img4.jpg'),
(99, 'sp99_img1.jpg'),(99, 'sp99_img2.jpg'),(99, 'sp99_img3.jpg'),(99, 'sp99_img4.jpg'),
(100, 'sp100_img1.jpg'),(100, 'sp100_img2.jpg'),(100, 'sp100_img3.jpg'),(100, 'sp100_img4.jpg')

GO

-- Dữ liệu cho bảng KhachHang
INSERT INTO KhachHang (HoTenDem, Ten, Email, SoDienThoai, DiaChi)
VALUES
    (N'Huỳnh Khánh', N'Duy', 'duyxanh2002@gmail.com', '0123456789', N'123 Đường Võ Văn Vân'),
    (N'Phạm Lê Tuấn', N'Anh', 'tuananhlae@gmail.com', '0987654321', N'456 Đường Lào Cai'),
    (N'Châu Minh', N'Quân', 'leminh@gmail.com', '0123456789', N'789 Đường Lê Minh Xuân'),
    (N'Phạm Hoàng', N'Duyên', 'phamhoang@gmail.com', '0987654321', N'101 Đường Văn Giàu'),
    (N'Nguyễn Thị Ngọc', N'Mai', 'ngocmai@gmail.com', '0123456789', N'202 Đường Tân Túc');

GO
-- Dữ liệu cho bảng TaiKhoanKhachHang
INSERT INTO TaiKhoanKhachHang (TaiKhoan, MatKhau, MaKhachHang, HoatDong)
VALUES
    ('duy', '123', 1, N'Hoạt động'),
    ('tuananh', '123',2, N'Hoạt động'),
    ('quan', '123', 3, N'Hoạt động'),
    ('duyen', '123', 4, N'Hoạt động'),
    ('binh', '123', 5, N'Hoạt động');

GO

INSERT INTO GioHang(MaKhachHang, TongSoLuongSP) VALUES
(1, 13),
(2, 5),
(3, 0),
(4, 0),
(5, 0);

GO

INSERT INTO ChiTietGioHang (MaGioHang, MaSanPham, SoLuong)
VALUES
    (1, 2, 3),
    (1, 3, 1),
	(1, 5, 9),
    (2, 2, 3),
    (2, 3, 2);

GO

INSERT INTO NhanVien VALUES (N'Phạm Lê Tuấn Anh', 'tuananhlae@gmail.com', '2002-12-05','0123456789', '012345678961', 'TPHCM')
INSERT INTO NhanVien VALUES (N'Châu Minh Quân'	, 'quan@gmail.com'		, '2002-12-27','0665464645', '012344498987', 'TPHCM')
INSERT INTO NhanVien VALUES (N'Huỳnh Khánh Duy'	, 'duy@gmail.com'		, '2002-09-30','0654898998', '019896569341', 'TPHCM')

GO

INSERT INTO KhoHang (MaSanPham, SoLuongTonKho)
VALUES
(1, 100),(2, 100),(3, 100),(4, 100),(5, 100),(6, 100),(7, 100),(8, 100),(9, 100),(10, 100),(11, 100),(12, 100),(13, 100),(14, 100),(15, 100),(16, 100),(17, 100),(18, 100),(19, 100),(20, 100),
(21, 100),(22, 100),(23, 100),(24, 100),(25, 100),(26, 100),(27, 100),(28, 100),(29, 100),(30, 100),(31, 100),(32, 100),(33, 100),(34, 100),(35, 100),(36, 100),(37, 100),(38, 100),(39, 100),
(40, 100),(41, 100),(42, 100),(43, 100),(44, 100),(45, 100),(46, 100),(47, 100),(48, 100),(49, 100),(50, 100),(51, 100),(52, 100),(53, 100),(54, 100),(55, 100),(56, 100),(57, 100),(58, 100),(59, 100),
(60, 100),(61, 100),(62, 100),(63, 100),(64, 100),(65, 100),(66, 100),(67, 100),(68, 100),(69, 100),(70, 100),(71, 100),(72, 100),(73, 100),(74, 100),(75, 100),(76, 100),(77, 100),(78, 100),(79, 100),
(80, 100),(81, 100),(82, 100),(83, 100),(84, 100),(85, 100),(86, 100),(87, 100),(88, 100),(89, 100),(90, 100),(91, 100),(92, 100),(93, 100),(94, 100),(95, 100),(96, 100),(97, 100),(98, 100),(99, 100),(100, 100)

GO

INSERT INTO TaiKhoanNhanVien VALUES
(1, 'tuananh', '123', 1, 'Admin'),
(2, 'quan', '123', 1, 'Admin'),
(3, 'duy', '123', 1, 'Staff');
