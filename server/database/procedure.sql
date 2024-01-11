USE [QLNhaKhoa]

DROP PROC IF EXISTS Proc_DangNhap
DROP PROC IF EXISTS Proc_DanhSachBenhNhan
DROP PROC IF EXISTS Proc_ThemBenhNhan
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
	DECLARE @autoID INT = 
	(SELECT TOP (1) MABENHNHAN 
	FROM dbo.BENHNHAN
	ORDER BY MABENHNHAN DESC);

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

ALTER PROCEDURE InsertSampleData
AS
BEGIN
    -- SET NOCOUNT ON;

    -- -- Thêm dữ liệu cho bảng NGUOIDUNG
    -- DECLARE @i INT = 1
    -- WHILE @i <= 1000
    -- BEGIN
	-- 	--SET IDENTITY_INSERT NGUOIDUNG ON
    --     INSERT INTO NGUOIDUNG (TENDANGNHAP, MATKHAU, TENNGUOIDUNG, NGAYSINH, DIACHI, SODIENTHOAI, ROLES)
    --     VALUES (
    --         'User' + CAST(@i AS NVARCHAR(10)),
    --         'Password' + CAST(@i AS NVARCHAR(10)),
    --         'User Name' + CAST(@i AS NVARCHAR(10)),
    --         DATEADD(DAY, -FLOOR(RAND() * 36525), GETDATE()), -- Ngày sinh ngẫu nhiên trong khoảng 100 năm trở lại đây
    --         'Address' + CAST(@i AS NVARCHAR(10)),
    --         '1234567890',
    --         --CASE WHEN @i % 3 = 0 THEN 
	-- 		N'NHA SĨ' 
	-- 		--WHEN @i % 3 = 1 THEN N'QUẢN TRỊ VIÊN' ELSE N'NHÂN VIÊN' END
    --     )
	-- 	--SET IDENTITY_INSERT NGUOIDUNG OFF

    --     SET @i = @i + 1
    -- END
	WITH
		L0   AS (SELECT c FROM (SELECT 1 UNION ALL SELECT 1) AS D(c)), -- 2^1
		L1   AS (SELECT 1 AS c FROM L0 AS A CROSS JOIN L0 AS B),       -- 2^2
		L2   AS (SELECT 1 AS c FROM L1 AS A CROSS JOIN L1 AS B),       -- 2^4
		L3   AS (SELECT 1 AS c FROM L2 AS A CROSS JOIN L2 AS B),       -- 2^8
		L4   AS (SELECT 1 AS c FROM L3 AS A CROSS JOIN L3 AS B),       -- 2^16
		L5   AS (SELECT 1 AS c FROM L4 AS A CROSS JOIN L4 AS B),       -- 2^32
		Nums AS (SELECT ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS k FROM L5)

-- Thêm dữ liệu cho bảng NGUOIDUNG
	INSERT INTO NGUOIDUNG (TENDANGNHAP, MATKHAU, TENNGUOIDUNG, NGAYSINH, DIACHI, SODIENTHOAI, ROLES)
	SELECT 
		'user_' + CAST(k AS VARCHAR) AS TENDANGNHAP,
		'password_' + CAST(k AS VARCHAR) AS MATKHAU,
		'User ' + CAST(k AS VARCHAR) AS TENNGUOIDUNG,
		DATEADD(DAY, k, '19900101') AS NGAYSINH,
		N'Địa chỉ ' + CAST(k AS VARCHAR) AS DIACHI,
		'098' + RIGHT('0000' + CAST(k AS VARCHAR), 4) AS SODIENTHOAI,
		CASE WHEN k % 3 = 0 THEN N'NHA SĨ' WHEN k % 3 = 1 THEN N'QUẢN TRỊ VIÊN' ELSE N'NHÂN VIÊN' END AS ROLES
	FROM Nums
	WHERE k <= 1000000;
	

    PRINT 'Sample data inserted successfully.'
END
GO

create PROCEDURE InsertSampleData_BenhNhan
AS
BEGIN
    SET NOCOUNT ON;

    -- Thêm dữ liệu cho bảng NGUOIDUNG
    DECLARE @i INT = 1
    WHILE @i <= 1000
    BEGIN
		INSERT INTO BENHNHAN (HOTEN, SODIENTHOAI, DIACHI, EMAIL, NGAYSINH, NHASI)
        VALUES (
            'Benh nhan ' ,
            '1234567890',
            'Dia chi ' + CAST(@i AS NVARCHAR(10)),
            'email' + CAST(@i AS NVARCHAR(10)) + '@example.com',
            DATEADD(DAY, -FLOOR(RAND() * 36525), GETDATE()),
            CASE WHEN @i % 2 = 0 THEN NULL ELSE @i END
        )

        SET @i = @i + 1
    END
	

    PRINT 'Sample data inserted successfully.'
END
GO

create PROCEDURE InsertSampleData_NhaSi
AS
BEGIN
    SET NOCOUNT ON;

    -- Thêm dữ liệu cho bảng NGUOIDUNG
    DECLARE @i INT = 1
	SET IDENTITY_INSERT NHASI ON
    WHILE @i <= 1000
    BEGIN
		INSERT INTO NHASI (CHUYENMON, KINHNGHIEM, MABACSI)
        VALUES (
            'Chuyen mon ' + CAST(@i AS NVARCHAR(10)),
            'Kinh nghiem ' + CAST(@i AS NVARCHAR(10)),
            @i
        )

        SET @i = @i + 1
    END
	
	SET IDENTITY_INSERT NHASI OFF
    PRINT 'Sample data inserted successfully.'
END
GO

create PROCEDURE InsertSampleData_ChiTietBenhNhan
AS
BEGIN
    SET NOCOUNT ON;

    -- Thêm dữ liệu cho bảng NGUOIDUNG
    DECLARE @i INT = 4
    WHILE @i <= 1000
    BEGIN
		INSERT INTO CHITIETHOSOBENHNHAN (MABENHNHAN, TUOI, GIOITINH, TONGTIENDIEUTRI, DATHANHTOAN, SUCKHOERANGMIENG, TINHTRANGDIUNG)
        VALUES (
            @i,
            null,
            CASE WHEN @i % 2 = 0 THEN N'NAM' ELSE N'NỮ' END,
            NULL,
            NULL,
            N'Sức khỏe rang miệng ' + CAST(@i AS NVARCHAR(10)),
            N'Tình trạng di ung ' + CAST(@i AS NVARCHAR(10))
        )

        SET @i = @i + 1
    END
	

    PRINT 'Sample data inserted successfully.'
END
GO

create PROCEDURE InsertSampleData_ChiTietBenhNhan
AS
BEGIN
    SET NOCOUNT ON;

    -- Thêm dữ liệu cho bảng NGUOIDUNG
    DECLARE @i INT = 4
    WHILE @i <= 1000
    BEGIN
		INSERT INTO CHITIETHOSOBENHNHAN (MABENHNHAN, TUOI, GIOITINH, TONGTIENDIEUTRI, DATHANHTOAN, SUCKHOERANGMIENG, TINHTRANGDIUNG)
        VALUES (
            @i,
            null,
            CASE WHEN @i % 2 = 0 THEN N'NAM' ELSE N'NỮ' END,
            NULL,
            NULL,
            N'Sức khỏe rang miệng ' + CAST(@i AS NVARCHAR(10)),
            N'Tình trạng di ung ' + CAST(@i AS NVARCHAR(10))
        )

        SET @i = @i + 1
    END
	

    PRINT 'Sample data inserted successfully.'
END
GO

exec InsertSampleData
exec InsertSampleData_NhaSi
exec InsertSampleData_BenhNhan
exec InsertSampleData_ChiTietBenhNhan

SELECT * FROM NGUOIDUNG
select * from NHASI
SELECT * FROM BENHNHAN
select * from CHITIETHOSOBENHNHAN

delete from CHITIETHOSOBENHNHAN