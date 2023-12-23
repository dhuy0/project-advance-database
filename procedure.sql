
DROP PROC IF EXISTS DangNhap
DROP PROC IF EXISTS DanhSachBenhNhan
DROP PROC IF EXISTS ThemBenhNhan
DROP PROC IF EXISTS CapNhatBenhNhan
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
@HoTen NCHAR(50),
@SoDienThoai CHAR(12),
@DiaChi NCHAR(100),
@Email CHAR(30),
@NgaySinh DATE,
@NhaSi CHAR(10)  = NULL
AS 
BEGIN
	DECLARE @autoID INT = 
	(SELECT TOP (1) MABENHNHAN 
	FROM dbo.BENHNHAN
	ORDER BY MABENHNHAN DESC);

	SET @autoID = @autoID + 1;

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
END
GO


CREATE PROC Proc_CapNhatBenhNhan 
@MaBenhNhan CHAR(6),
@TenBenhNhan CHAR(50),
@sdt CHAR(10),
@DiaChi CHAR(100),
@Email CHAR(30),
@NgaySinh DATE,
@NhaSi CHAR(6)
AS
BEGIN
	SET NOCOUNT ON;
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

------------------------Ho so chi tiet---------------------------------

--Them thong tin chong chi dinh 
CREATE PROC Proc_ThenThongTinChiDinh 
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
	)

END

--Xoa thong tin chong chi dinh 
CREATE PROC Proc_XoaThongTinChiDinh 
@MaBenhNhan INT,
@MaThuoc INT
AS 
BEGIN

	DELETE dbo.CHONGCHIDINH
	WHERE	MABENHNHAN = @MaBenhNhan AND MATHUOC = @MaThuoc;
	
END

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

CREATE PROC Proc_CapNhatThongTinSKRM 
@MaBenhNhan INT,
@TinhTrangSkrm CHAR(100)
AS 
BEGIN
	UPDATE dbo.CHITIETHOSOBENHNHAN 
	SET SUCKHOERANGMIENG = @TinhTrangSkrm
	WHERE MABENHNHAN = @MaBenhNhan
END

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

CREATE PROC Proc_XemCuocHenTheophongKham
@PhongKham INT
AS 
BEGIN 
SELECT l.MALICHHEN , l.THOIGIAN, l.NHASI, l.MABENHNHAN, b.HOTEN,
	l.GHICHU, l.TINHTRANG, l.THOIGIAN, l.THOIGIANYEUCAU, l.PHONG
	FROM dbo.LICHHEN l , dbo.BENHNHAN b
	WHERE l.MABENHNHAN = b.MABENHNHAN and l.PHONG = @PhongKham
END

CREATE PROC Pro_XemCuocHenTheoTheoNhaSi
@MaNhaSi INT
AS 
BEGIN
SELECT l.MALICHHEN , l.THOIGIAN, l.NHASI, l.MABENHNHAN, b.HOTEN,
	l.GHICHU, l.TINHTRANG, l.THOIGIAN, l.THOIGIANYEUCAU, l.PHONG
	FROM dbo.LICHHEN l , dbo.BENHNHAN b
	WHERE l.MABENHNHAN = b.MABENHNHAN and l.NHASI = @MaNhaSi
END