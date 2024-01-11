USE [QLNhaKhoa]

DROP PROC IF EXISTS Proc_DangNhap
DROP PROC IF EXISTS Proc_DanhSachBenhNhan
DROP PROC IF EXISTS Proc_ThemBenhNhan
DROP PROC IF EXISTS Proc_ThemNhaSi 
DROP PROC IF EXISTS Proc_CapNhatBenhNhan
DROP PROC IF EXISTS Proc_ThemThongTinChiDinh
DROP PROC IF EXISTS Proc_XoaThongTinChiDinh 
DROP PROC IF EXISTS Proc_CapNhatThongTinChiDinh 
DROP PROC IF EXISTS Proc_CapNhatThongTinSkrm
DROP PROC IF EXISTS Proc_XemKeHoachDieuTri
DROP PROC IF EXISTS Proc_XemCuocHenTheoNhaSi
DROP PROC IF EXISTS Proc_XemCuocHenTheoPhongKham
DROP PROC IF EXISTS Proc_XemCuocHenTheoNgay
DROP PROC IF EXISTS	Proc_CapNhatTtThanhToan
DROP PROC IF EXISTS Proc_XemThongTinThanhToan
DROP PROC IF EXISTS Proc_ThemKeHoachDieuTri
DROP PROC IF EXISTS Proc_SuaKeHoachDieuTri
DROP PROC IF EXISTS Proc_XoaKeHoachDieuTri
DROP PROC IF EXISTS Proc_CapNhatThongTInChongChiDinh
GO

--Dang nhap
CREATE PROC Proc_DangNhap 
@tenDangNhap CHAR(20)
AS 
BEGIN
	SELECT U.MANGUOIDUNG, U.TENNGUOIDUNG, U.MATKHAU, U.TENDANGNHAP 
	FROM NGUOIDUNG U WHERE U.TENDANGNHAP = @tenDangNhap
	RETURN
END;
GO

---------------------------------Quan ly benh nhan------------------------------------
---------------------------Thong tin chung------------------------------------

-- Danh sach benh nhan
CREATE PROC Proc_DanhSachBenhNhan 
@pageSize int , @pageNumber INT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @Offset INT;
	SET @Offset = @pageSize * (@pageNumber -1)


	SELECT [MABENHNHAN]
      ,[HOTEN]
      ,[SODIENTHOAI]
      ,[DIACHI]
      ,[EMAIL]
      ,[NGAYSINH]
      ,[NHASI]
	FROM dbo.BENHNHAN 
	ORDER BY MABENHNHAN
	DESC
	OFFSET	@Offset ROWS
	FETCH NEXT @PageSize ROWS ONLY;
END
GO



-- Them Benh Nhan 
CREATE PROC Proc_ThemBenhNhan 
@HoTen NCHAR(50) = NULL,
@SoDienThoai CHAR(12) = NULL,
@DiaChi NCHAR(100) = NULL,
@Email CHAR(30) = NULL,
@NgaySinh DATE =NULL,
@NhaSi INT  = NULL
AS 
BEGIN
	DECLARE @autoID INT = (SELECT COUNT(*) FROM dbo.BENHNHAN);
	SET @autoID = @autoID + 1;

	SET IDENTITY_INSERT BENHNHAN ON
	INSERT INTO dbo.BENHNHAN
	(
		MABENHNHAN,
	    HOTEN,
	    SODIENTHOAI,
	    DIACHI,
	    EMAIL,
	    NGAYSINH,
	    NHASI
	)
	VALUES
	(
		@autoID,
	    @HoTen,       -- HOTEN - nvarchar(50)
	    @SoDienThoai,        -- SODIENTHOAI - char(10)
	    @DiaChi,       -- DIACHI - nvarchar(100)
	    @Email,       -- EMAIL - nvarchar(50)
	    @NgaySinh, -- NGAYSINH - date
	    @NhaSi      -- NHASI - char(6)
	 );
	SET IDENTITY_INSERT BENHNHAN off
END
GO

ALTER PROC Proc_ThemNhaSi 
    @TenDangNhap CHAR(30),
    @MatKhau CHAR(30),
    @TenNguoiDung NVARCHAR(50),
    @NgaySinh DATE ,
    @DiaChi NVARCHAR(100),
    @SoDienThoai CHAR(10),
    @Roles NVARCHAR(20),
    @ChuyenMon NVARCHAR(50),
    @KinhNghiem NVARCHAR(50)
AS 
BEGIN
    DECLARE @MaNguoiDung INT = (SELECT COUNT(*) FROM dbo.NGUOIDUNG);
	SET @MaNguoiDung = @MaNguoiDung + 1;
    -- Add Người Dùng
    SET IDENTITY_INSERT NGUOIDUNG ON;

    INSERT INTO dbo.NGUOIDUNG (MANGUOIDUNG, TENDANGNHAP, MATKHAU, TENNGUOIDUNG, NGAYSINH, DIACHI, SODIENTHOAI, ROLES)
    VALUES (@MaNguoiDung, @TenDangNhap, @MatKhau, @TenNguoiDung, @NgaySinh, @DiaChi, @SoDienThoai, @Roles);


    SET IDENTITY_INSERT NGUOIDUNG OFF;

    -- Add Nha Sĩ
	SET IDENTITY_INSERT NHASI ON;
    INSERT INTO dbo.NHASI (MABACSI, CHUYENMON, KINHNGHIEM)
    VALUES (@MaNguoiDung, @ChuyenMon, @KinhNghiem);
	SET IDENTITY_INSERT NHASI OFF;
END

-- EXEC Proc_ThemNhaSi
--     @TenDangNhap = 'NhaSi123',
--     @MatKhau = 'Password123',
--     @TenNguoiDung = 'Nha Sĩ 123',
--     @NgaySinh = '1980-01-01',
--     @DiaChi = '123 Nha Khoa Street',
--     @SoDienThoai = '9876543210',
--     @Roles = N'NHA SĨ',
--     @ChuyenMon = N'Răng Hàm Nhỏ',
--     @KinhNghiem = N'10 năm kinh nghiệm';

-- select * from nhasi

-- EXEC Proc_ThemBenhNhan
--     @HoTen = N'John Doe',
--     @SoDienThoai = '1234567890',
--     @DiaChi = N'Sample Address',
--     @Email = 'john.doe@example.com',
--     @NgaySinh = '1990-01-01',
--     @NhaSi = 1;

-- select * from BENHNHAN



CREATE PROC Proc_CapNhatBenhNhan 
@MaBenhNhan INT,
@TenBenhNhan CHAR(50),
@sdt CHAR(10),
@DiaChi CHAR(100),
@Email CHAR(30),
@NgaySinh DATE,
@NhaSi INT
AS
BEGIN
	UPDATE dbo.BENHNHAN
	SET
	HOTEN = ISNULL(@TenBenhNhan, HOTEN),
	SODIENTHOAI = ISNULL(@sdt, SODIENTHOAI),
	DIACHI = ISNULL(@DiaChi, DIACHI),
	EMAIL = ISNULL(@Email,EMAIL),
	NGAYSINH = ISNULL(@NgaySinh,NGAYSINH),
	NHASI = ISNULL(@NhaSi, NHASI)
	WHERE MABENHNHAN = @MaBenhNhan;
	PRINT('Update success');
END
GO
------------------------Ho so chi tiet---------------------------------
--Them thong tin chong chi dinh 

CREATE PROC Proc_ThemThongTinChiDinh 
@MaBenhNhan INT,
@MaThuoc INT
AS 
BEGIN
	INSERT INTO dbo.CHONGCHIDINH
	(
	    MABENHNHAN,
	    MATHUOC
	)
	VALUES
	(   @MaBenhNhan, -- MABENHNHAN - char(6)
	    @MaThuoc  -- MATHUOC - char(6)
	);
END
GO

--Xoa thong tin chong chi dinh 
CREATE PROC Proc_XoaThongTinChiDinh 
@MaBenhNhan INT,
@MaThuoc INT
AS 
BEGIN

	DELETE dbo.CHONGCHIDINH
	WHERE	MABENHNHAN = @MaBenhNhan AND MATHUOC = @MaThuoc;
	
END
GO

CREATE PROC Proc_CapNhatThongTinChongChiDinh
@MaBenhNhan INT, 
@MaThuocCu INT,
@MaTHuocMoi INT
AS
BEGIN
	UPDATE dbo.CHONGCHIDINH
	SET MATHUOC = @MaTHuocMoi 
	WHERE MABENHNHAN = @MaBenhNhan AND MATHUOC = @MaThuocCu
END
GO

CREATE PROC Proc_CapNhatThongTinSKRM 
@MaBenhNhan INT,
@TinhTrangSkrm CHAR(100)
AS 
BEGIN
	UPDATE dbo.CHITIETHOSOBENHNHAN 
	SET SUCKHOERANGMIENG = @TinhTrangSkrm
	WHERE MABENHNHAN = @MaBenhNhan
END
GO

CREATE PROC Proc_XemKeHoachDieuTri 
@MaBenhNhan INT
AS 
BEGIN
	SELECT [MAKEHOACH], [MOTA], [NGAYDIEUTRI],[TINHTRANG]
	FROM [dbo].[KEHOACHDIEUTRI]
	WHERE @MaBenhNhan = MABENHNHAN
	RETURN
END
GO

CREATE PROC Proc_XoaKeHoachDieuTri
@MaBenhNhan INT,
@MaKeHoach INT
AS 
BEGIN
	DELETE dbo.KEHOACHDIEUTRI 
	WHERE MABENHNHAN = @MaBenhNhan AND MAKEHOACH = @MaKeHoach
END
GO

CREATE PROC Proc_SuaKeHoachDieuTri
@MaBenhNhan INT,
@MaKeHoach INT = NULL, 
@MoTa NCHAR(100) = NULL,
@NgayDieuTri DATE = NULL,
@TinhTrang NCHAR(100) = NULL
AS 
BEGIN 
	UPDATE dbo.KEHOACHDIEUTRI 
	SET MOTA = ISNULL(@MOTA, MOTA),
	NGAYDIEUTRI = ISNULL(@NgayDieuTri,NGAYDIEUTRI),
	TINHTRANG = ISNULL(@TinhTrang, TINHTRANG)
	WHERE MAKEHOACH = @MaKeHoach AND MABENHNHAN = @MaBenhNhan
END
GO

CREATE PROC Proc_ThemKeHoachDieuTri
@MaBenhNhan INT,
@MaKeHoach INT =NULL, 
@MoTa NCHAR(100) = NULL,
@NgayDieuTri DATE = NULL,
@TinhTrang NCHAR(100) = NULL
AS
BEGIN
	INSERT dbo.KEHOACHDIEUTRI
	(
	    MOTA,
	    NGAYDIEUTRI,
	    TINHTRANG,
	    MABENHNHAN
	)
	VALUES
	(   
	    @MoTa,       -- MOTA - nvarchar(100)
	    @NgayDieuTri, -- NGAYDIEUTRI - date
	    @TinhTrang,       -- TINHTRANG - nvarchar(50)
	    @MaBenhNhan         -- MABENHNHAN - char(6)
	   )
END
GO

CREATE PROC Proc_XemThongTinThanhToan 
@MaBenhNhan INT
 AS
 BEGIN 
	SELECT [MATHANHTOAN] , [NHASI], NGAYTHANHTOAN,NGAYGIAODICH, TONGTIENTHANHTOAN,
	TIENDATRA, TIENTHOI, LOAITHANHTOAN
	FROM dbo.THONGTINTHANHTOAN
	WHERE MABENHNHAN = @MaBenhNhan
 END
GO

CREATE PROC Proc_CapNhatTtThanhToan
@MaThanhToan INT,
@NhaSi INT = NULL,
@NgayThanhToan DATE = NULL, 
@NgayGiaoDich DATE = NULL,
@TongTienThanhToan BIGINT = NULL ,
@TienDaTra BIGINT = NULL,
@TienThoi INT = NULL,
@LoaiThanhToan NCHAR(30) = NULL,
@MaBenhNhan INT = NULL

AS 
BEGIN 
	UPDATE dbo.THONGTINTHANHTOAN 
	SET NHASI = ISNULL(@NhaSi, NHASI),
	NGAYGIAODICH = ISNULL(@NgayGiaoDich, NGAYGIAODICH),
	NGAYTHANHTOAN = ISNULL(@NgayThanhToan, NGAYTHANHTOAN),
	TONGTIENTHANHTOAN = ISNULL(@TongTienThanhToan, TONGTIENTHANHTOAN),
	TIENDATRA = ISNULL(@TienDaTra, TIENDATRA),
	TIENTHOI = ISNULL (@TienThoi, TIENTHOI),
	LOAITHANHTOAN = ISNULL(@LoaiThanhToan, LOAITHANHTOAN),
	MABENHNHAN = ISNULL(@MaBenhNhan, MABENHNHAN)
	WHERE MATHANHTOAN = @MaThanhToan
END

GO

CREATE PROC Proc_XemCuocHenTheoNgay 
@NgayHen DATE
AS 
BEGIN
	SELECT l.MALICHHEN , l.THOIGIAN, l.NHASI, l.MABENHNHAN, b.HOTEN,
	l.GHICHU, l.TINHTRANG, l.THOIGIAN, l.THOIGIANYEUCAU, l.PHONG
	FROM dbo.LICHHEN l , dbo.BENHNHAN b
	WHERE l.MABENHNHAN = b.MABENHNHAN and NGAYHENYEUCAU 
	= @NgayHen 
END
GO

CREATE PROC Proc_XemCuocHenTheoPhongKham
@PhongKham INT
AS 
BEGIN 
SELECT l.MALICHHEN , l.THOIGIAN, l.NHASI, l.MABENHNHAN, b.HOTEN,
	l.GHICHU, l.TINHTRANG, l.THOIGIAN, l.THOIGIANYEUCAU, l.PHONG
	FROM dbo.LICHHEN l , dbo.BENHNHAN b
	WHERE l.MABENHNHAN = b.MABENHNHAN and l.PHONG = @PhongKham
END
GO


CREATE PROC Proc_XemCuocHenTheoNhaSi
@MaNhaSi INT
AS 
BEGIN
SELECT l.MALICHHEN , l.THOIGIAN, l.NHASI, l.MABENHNHAN, b.HOTEN,
	l.GHICHU, l.TINHTRANG, l.THOIGIAN, l.THOIGIANYEUCAU, l.PHONG
	FROM dbo.LICHHEN l , dbo.BENHNHAN b
	WHERE l.MABENHNHAN = b.MABENHNHAN and l.NHASI = @MaNhaSi
END
GO

