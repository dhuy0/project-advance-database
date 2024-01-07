
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

	
-- 22. Xem danh sach nha si
go
create procedure Proc_XemDanhSachNhaSi
as
begin
	select NguoiDung.TENNGUOIDUNG as "Tên nha sĩ", NguoiDung.NGAYSINH as "Ngày sinh", NguoiDung.DIACHI as "Địa chỉ", 
			NguoiDung.SODIENTHOAI as "Số điện thoại", NhaSi.CHUYENMON as "Chuyên môn", NhaSi.KINHNGHIEM as "Kinh nghiệm"
	from NhaSi join NguoiDung on NhaSi.MABACSI = NguoiDung.MANGUOIDUNG
end
go

exec Proc_XemDanhSachNhaSi

-- 23. Them nha si
go
create procedure Proc_ThemNhaSi
@mabacsi int,
@chuyenmon nvarchar(50),
@kinhnghiem nvarchar(50)
as
begin
	insert into NhaSi(MABACSI, CHUYENMON, KINHNGHIEM) values (@mabacsi,@chuyenmon, @kinhnghiem)
end

-- 24. Cap nhat nha si
go
create procedure Proc_CapNhapNhaSi
@mabacsi char(6),
@chuyenmon nvarchar(50),
@kinhnghiem nvarchar(50)
as
begin
	update NHASI
	set 
		CHUYENMON = isnull(@chuyenmon,CHUYENMON), 
		KINHNGHIEM = isnull(@kinhnghiem, KINHNGHIEM)
	where MABACSI = @mabacsi
end

exec Proc_CapNhapNhaSi '000105', 'OKKCIA7', '3 năm'

-- 25. Xem danh sach nhan vien
go
create procedure Proc_XemDanhSachNhanVien
as
begin
	select NguoiDung.TENNGUOIDUNG as "Tên nhân viên", NguoiDung.NGAYSINH as "Ngày sinh", NguoiDung.DIACHI as "Địa chỉ", 
			NguoiDung.SODIENTHOAI as "Số điện thoại", NhanVien.PHONGBAN
	from NhanVien join NguoiDung on NhanVien.MaNhanVien = NguoiDung.MaNguoiDung
end

exec Proc_XemDanhSachNhanVien

-- 26. Them nhan vien
go 
create procedure Proc_ThemNhanVien
@manhanvien int,
@phongban nvarchar(50)
as
begin
	insert into NhanVien(MANHANVIEN, PHONGBAN) values (@manhanvien, @phongban)
end

-- 27. Cap nhat nhan vien
go 
create procedure Proc_CapNhatNhanVien
@manhanvien int,
@phongban nvarchar(50)
as
begin
	update NhanVien
	set 
		PhongBan = isnull(@phongban, PhongBan)
	where MaNhanVien = @manhanvien
end

exec Proc_CapNhatNhanVien '000105', null

-- 28. Ma, ten va lich lam viec cua nha si

-- 29. Them lich lam viec cho nha si

-- 30. Xem danh sach thuoc theo dang phan trang
go
create procedure Proc_XemDanhSachThuoc
@pageSize int , @pageNumber INT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @Offset INT;
	SET @Offset = @pageSize * (@pageNumber -1)


	SELECT MATHUOC, TENTHUOC, GHICHU
	FROM Thuoc
	ORDER BY MATHUOC
	DESC
	OFFSET	@Offset ROWS
	FETCH NEXT @PageSize ROWS ONLY;
END

-- 31. Cap nhat thuoc
go
create procedure Proc_CapNhatThuoc
@mathuoc int,
@tenthuoc nvarchar(50),
@ghichu nvarchar(50)
as
begin
	update Thuoc
	set 
		TenThuoc = isnull(@tenthuoc, TenThuoc),
		GhiChu = isnull(@ghichu, GhiChu)
	where MaThuoc = @mathuoc
end

-- 32. Xoa thuoc
go
create procedure Proc_XoaThuoc
@mathuoc int
as
begin
	delete Thuoc
	where MaThuoc = @mathuoc
end

-- 33. Them thuoc
go 
create procedure Proc_ThemThuoc
@mathuoc int,
@tenthuoc nvarchar(50),
@ghichu nvarchar(50)
as 
begin
	insert into Thuoc(MATHUOC,TENTHUOC, GHICHU) values(@mathuoc, @tenthuoc, @ghichu)
end

-- 34. Lay ra cac dieu tri trong ngay do voi group by ma bac si
go
create procedure Proc_DieuTriTrongNgay
@ngay date
as
begin
	select ND.MANGUOIDUNG as "Mã nha sĩ", 
			ND.TENNGUOIDUNG as "Nha sĩ", 
			DT.TENDIEUTRI as "Tên điều trị", 
			BN.HOTEN as "Bệnh nhân", 
			HDDT.NGAYDIEUTRI as "Ngày điều trị"
	from THONGTINTHANHTOAN TTTT, HoaDonDieuTri HDDT, NguoiDung ND, BenhNhan BN, DieuTri DT
	where ND.MANGUOIDUNG = TTTT.NHASI and TTTT.MATHANHTOAN = HDDT.MAHOADON and HDDT.NGAYDIEUTRI = @ngay
			and TTTT.MABENHNHAN = BN.MABENHNHAN and HDDT.MADIEUTRI = DT.MADIEUTRI
	group by ND.MANGUOIDUNG
end

-- 35. Lay ra cac cuoc hen trong khoang thoi gian, group by ma bac si
go 
create procedure Proc_CuocHenTrongKhoangThoiGian
@ngay date,
@thoigian time,
@gioketthuc time
as
begin
	select ND.TENNGUOIDUNG as "Nha sĩ", 
			LH.NGAYHENYEUCAU as "Ngày", 
			LH.THOIGIAN as "Thời gian", 
			LH.GIOKETTHUC as "Giờ kết thúc",
			LH.PHONG as "Phòng", 
			BN.HOTEN as "Bệnh nhân"
	from NguoiDung ND, LichHen LH, BenhNhan BN
	where ND.MANGUOIDUNG = LH.NHASI and LH.MABENHNHAN = BN.MABENHNHAN and 
			LH.NGAYHENYEUCAU = @ngay and LH.THOIGIAN = @thoigian and LH.GIOKETTHUC = @gioketthuc
	group by ND.MANGUOIDUNG
end
