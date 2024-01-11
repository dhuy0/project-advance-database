﻿--tạo csdl
use master --chuyển csdl hiện hành về master
go 
if DB_ID('QLNhaKhoa') IS NOT NULL
	alter database QLNhaKhoa set single_user with rollback immediate
	DROP DATABASE  QLNhaKhoa
GO
CREATE DATABASE QLNhaKhoa
GO
USE QLNhaKhoa
GO
SET DATEFORMAT DMY
---------------------------------------- TẠO BẢNG ----------------------------------------
CREATE TABLE NGUOIDUNG
(
    MANGUOIDUNG INT IDENTITY(1,1),
    TENDANGNHAP CHAR(30) NOT NULL CHECK (TENDANGNHAP <> ''),
    MATKHAU CHAR(30) NOT NULL CHECK (MATKHAU <> ''),
    TENNGUOIDUNG NVARCHAR(50) NOT NULL CHECK (TENNGUOIDUNG <> ''),
    NGAYSINH DATE NOT NULL CHECK (NGAYSINH <= GETDATE()),
    DIACHI NVARCHAR(100) NOT NULL CHECK (DIACHI <> ''),
    SODIENTHOAI CHAR(10) NOT NULL CHECK (SODIENTHOAI <> ''),
    ROLES NVARCHAR(20) NOT NULL CHECK (UPPER(ROLES) IN (N'NHA SĨ', N'QUẢN TRỊ VIÊN', N'NHÂN VIÊN')),
    --KHÓA CHÍNH
    CONSTRAINT PK_NGUOIDUNG
    PRIMARY KEY(MANGUOIDUNG)
)
GO

CREATE TABLE NHASI
(
    MABACSI INT IDENTITY(1,1),
    CHUYENMON NVARCHAR(50) NOT NULL CHECK(CHUYENMON <> ''),
    KINHNGHIEM NVARCHAR(50) NOT NULL CHECK (KINHNGHIEM <> ''),
    --KHÓA CHÍNH
    CONSTRAINT PK_NHASI
    PRIMARY KEY(MABACSI)
)
GO


CREATE TABLE NHANVIEN
(
    MANHANVIEN INT IDENTITY(1,1),
    PHONGBAN NVARCHAR(50) NOT NULL CHECK (PHONGBAN <> ''),
    --KHÓA CHÍNH
    CONSTRAINT PK_NHANVIEN
    PRIMARY KEY(MANHANVIEN)
)
GO

CREATE TABLE QUANTRIVIEN
(
    MAQTV INT IDENTITY(1,1),
    CHUCVU NVARCHAR(50) NOT NULL CHECK (CHUCVU <> ''),
    --KHÓA CHÍNH
    CONSTRAINT PK_QUANTRIVIEN
    PRIMARY KEY(MAQTV)
)
GO


CREATE TABLE BENHNHAN
(
    MABENHNHAN INT IDENTITY(1,1),
    HOTEN NVARCHAR(50) NOT NULL CHECK (HOTEN <> ''),
    SODIENTHOAI CHAR(10) NOT NULL CHECK (SODIENTHOAI <> ''),
    DIACHI NVARCHAR(100) NOT NULL CHECK (DIACHI <> ''),
    EMAIL NVARCHAR(50) NOT NULL CHECK (EMAIL <> ''),
    NGAYSINH DATE NOT NULL CHECK (NGAYSINH <= GETDATE()),
    NHASI INT, --Nha sĩ mặc định có thể chứa giá trị null
    --KHÓA CHÍNH
    CONSTRAINT PK_BENHNHAN
    PRIMARY KEY(MABENHNHAN)
)
GO

CREATE TABLE CHITIETHOSOBENHNHAN
(
    MABENHNHAN INT,
    TUOI VARCHAR(3),
    GIOITINH NVARCHAR(3) CHECK (UPPER(GIOITINH) IN (N'NAM', N'NỮ')),
    TONGTIENDIEUTRI INT CHECK (TONGTIENDIEUTRI >= 0),
    DATHANHTOAN INT CHECK (DATHANHTOAN >= 0), -- SỐ TIỀN ĐÃ THANH TOÁN PHẢI NHỎ HƠN HOẶC BẰNG TỔNG TIỀN ĐIỀU TRỊ
    SUCKHOERANGMIENG NVARCHAR(50),
    TINHTRANGDIUNG NVARCHAR(50),
    --KHÓA CHÍNH
    CONSTRAINT PK_CTHOSOBENHNHAN
    PRIMARY KEY(MABENHNHAN)
)
GO

CREATE TABLE CHONGCHIDINH
(
    MABENHNHAN INT,
    MATHUOC INT,
    --KHÓA CHÍNH
    CONSTRAINT PK_CHONGCHIDINH
    PRIMARY KEY(MABENHNHAN, MATHUOC)
)
GO

CREATE TABLE THUOC
(
    MATHUOC INT IDENTITY(1,1),
    TENTHUOC NVARCHAR(50) NOT NULL CHECK (TENTHUOC <> ''),
    GHICHU NVARCHAR(50),
    --KHÓA CHÍNH
    CONSTRAINT PK_THUOC
    PRIMARY KEY(MATHUOC)
)
GO

CREATE TABLE CHITIETDONTHUOC
(
    MADONTHUOC INT,
    MATHUOC INT,
    LIEULUONG NVARCHAR(50) NOT NULL CHECK (LIEULUONG <> ''),
    CHIDINH NVARCHAR(50) NOT NULL CHECK (CHIDINH <> ''),
    --KHÓA CHÍNH
    CONSTRAINT PK_CTDONTHUOC
    PRIMARY KEY(MADONTHUOC, MATHUOC)
)
GO

CREATE TABLE DONTHUOC
(
    MADONTHUOC INT IDENTITY(1,1),
    KEHOACHDIEUTRI INT NOT NULL CHECK (KEHOACHDIEUTRI <> ''),
    --KHÓA CHÍNH
    CONSTRAINT PK_DONTHUOC
    PRIMARY KEY(MADONTHUOC)
)
GO

CREATE TABLE KEHOACHDIEUTRI
(
    MAKEHOACH INT IDENTITY(1,1),
    MOTA NVARCHAR(100) NOT NULL CHECK (MOTA <> ''),
    NGAYDIEUTRI DATE NOT NULL CHECK(NGAYDIEUTRI >= GETDATE()),
    TINHTRANG NVARCHAR(50) NOT NULL CHECK(UPPER(TINHTRANG) IN (N'KẾ HOẠCH', N'ĐÃ HOÀN THÀNH', N'ĐÃ HỦY')),
    MABENHNHAN INT NOT NULL CHECK (MABENHNHAN <> ''),
    MANHASI INT,
    MATROKHAM INT
    --KHÓA CHÍNH
    CONSTRAINT PK_KEHOACHDT
    PRIMARY KEY(MAKEHOACH)
)
GO

CREATE TABLE RANG
(
    MAKEHOACH INT,
    RANG NVARCHAR(12) CHECK(UPPER(RANG) IN (N'RĂNG CỬA', N'RĂNG NANH', N'RĂNG HÀM NHỎ', N'RĂNG HÀM LỚN')),
    BEMATRANG VARCHAR(7) NOT NULL CHECK(UPPER(BEMATRANG) IN ('LINGUAL', 'FACIAL', 'DISTAL', 'MESIAL', 'TOP', 'ROOT') AND BEMATRANG <> ''),
    --KHÓA CHÍNH
    CONSTRAINT PK_MAKEHOACH
    PRIMARY KEY(MAKEHOACH, RANG)
)
GO

CREATE TABLE KEHOACH_DIEUTRI
(
    KEHOACHDIEUTRI INT,
    DIEUTRI INT,
    --KHÓA CHÍNH
    CONSTRAINT PK_KH_DT
    PRIMARY KEY(KEHOACHDIEUTRI, DIEUTRI)
)
GO

CREATE TABLE DIEUTRI
(
    MADIEUTRI INT IDENTITY(1,1),
    TENDIEUTRI NVARCHAR(50) NOT NULL CHECK (TENDIEUTRI <> ''),
    --KHÓA CHÍNH
    CONSTRAINT PK_DIEUTRI
    PRIMARY KEY(MADIEUTRI)
)
GO

CREATE TABLE HOADONDIEUTRI
(
    MAHOADON INT,
    MADIEUTRI INT,
    MOTA NVARCHAR(50) NOT NULL CHECK (MOTA <> ''),
    NGAYDIEUTRI DATE NOT NULL CHECK (NGAYDIEUTRI <= GETDATE()),
    PHIDIEUTRI INT NOT NULL CHECK (PHIDIEUTRI >= 0)
    --KHÓA CHÍNH
    CONSTRAINT PK_HOADONDIEUTRI
    PRIMARY KEY(MAHOADON, MADIEUTRI)
)
GO

CREATE TABLE THONGTINTHANHTOAN
(
    MATHANHTOAN INT IDENTITY(1,1),
    NHASI INT NOT NULL CHECK (NHASI <> ''),
    MABENHNHAN INT NOT NULL,
    NGAYTHANHTOAN DATE NOT NULL CHECK(NGAYTHANHTOAN <= GETDATE()),
    NGAYGIAODICH DATE NOT NULL CHECK(NGAYGIAODICH <= GETDATE()),
    TONGTIENTHANHTOAN BIGINT CHECK (TONGTIENTHANHTOAN >= 0),
    TIENDATRA BIGINT NOT NULL,
    TIENTHOI BIGINT CHECK (TIENTHOI >= 0),
    LOAITHANHTOAN NVARCHAR(50) NOT NULL CHECK(UPPER(LOAITHANHTOAN) IN (N'TIỀN MẶT', N'THANH TOÁN ONLINE') AND LOAITHANHTOAN <> ''),
    --KHÓA CHÍNH
    CONSTRAINT PK_THONGTINTT
    PRIMARY KEY(MATHANHTOAN)
)
GO

CREATE TABLE TROKHAM
(
    NHASI INT,
    LICHHEN INT,
    --KHÓA CHÍNH
    CONSTRAINT PK_TROKHAM
    PRIMARY KEY(NHASI, LICHHEN)
)
GO

CREATE TABLE LICHLAMVIEC
(
  MALICH char(6),
  MANHASI INT,
  NGAY date NOT NULL,
  GIOBATDAU time NOT NULL,
  GIOKETTHUC time NOT NULL,
  PRIMARY KEY (MALICH)
)
GO

CREATE TABLE LICHHEN
(
    MALICHHEN INT IDENTITY(1,1),
    THOIGIAN TIME NOT NULL,
    GIOKETTHUC TIME NOT NULL,
    NHASI INT NOT NULL CHECK (NHASI <> ''),
    MABENHNHAN INT NOT NULL CHECK (MABENHNHAN <> ''),
    GHICHU NVARCHAR(50),
    TINHTRANG NVARCHAR(50) NOT NULL CHECK (TINHTRANG <> ''),
    THOIGIANYEUCAU TIME NOT NULL,
    PHONG INT NOT NULL CHECK (PHONG <> ''),
    NGAYHENYEUCAU DATE NOT NULL CHECK(NGAYHENYEUCAU >= GETDATE()),
    --KHÓA CHÍNH
    CONSTRAINT PK_LICHHEN
    PRIMARY KEY(MALICHHEN)
)
GO

CREATE TABLE LICHTAIKHAM
(
    MATAIKHAM INT,
    NGAYCHIDINH DATE CHECK(NGAYCHIDINH >= GETDATE()),
    GHICHU NVARCHAR(50),
    --KHÓA CHÍNH
    CONSTRAINT PK_LICHTAIKHAM
    PRIMARY KEY(MATAIKHAM)
)
GO

-------------------------------KHÓA NGOẠI-----------------------------------
--NHASI
ALTER TABLE NHASI
ADD
    CONSTRAINT FK_NS_ND
    FOREIGN KEY(MABACSI)
    REFERENCES NGUOIDUNG
GO

--QUANTRIVIEN
ALTER TABLE QUANTRIVIEN
ADD
    CONSTRAINT FK_QTV_ND
    FOREIGN KEY(MAQTV)
    REFERENCES NGUOIDUNG
GO

--NHANVIEN
ALTER TABLE NHANVIEN
ADD
    CONSTRAINT FK_NV_ND
    FOREIGN KEY(MANHANVIEN)
    REFERENCES NGUOIDUNG
GO

--TROKHAM
ALTER TABLE TROKHAM
ADD
    CONSTRAINT FK_TK_NS
    FOREIGN KEY(NHASI)
    REFERENCES NHASI,

    CONSTRAINT FK_TK_LH
    FOREIGN KEY(LICHHEN)
    REFERENCES LICHHEN
GO

--LICHHEN
ALTER TABLE LICHHEN
ADD
    CONSTRAINT FK_LH_NS
    FOREIGN KEY(NHASI)
    REFERENCES NHASI,

    CONSTRAINT FK_LH_BN
    FOREIGN KEY(MABENHNHAN)
    REFERENCES BENHNHAN
GO

--LICHTAIKHAM
ALTER TABLE LICHTAIKHAM
ADD
    CONSTRAINT FK_LTK_LH
    FOREIGN KEY(MATAIKHAM)
    REFERENCES LICHHEN
GO

--BENHNHAN
ALTER TABLE BENHNHAN
ADD
    CONSTRAINT FK_BN_NS
    FOREIGN KEY(NHASI)
    REFERENCES NHASI
GO

--CHITIETHOSOBENHNHAN
ALTER TABLE CHITIETHOSOBENHNHAN
ADD
    CONSTRAINT FK_CTHSBN_BN
    FOREIGN KEY(MABENHNHAN)
    REFERENCES BENHNHAN
GO

--CHONGCHIDINH
ALTER TABLE CHONGCHIDINH
ADD
    CONSTRAINT FK_CCD_CTHSBN
    FOREIGN KEY(MABENHNHAN)
    REFERENCES CHITIETHOSOBENHNHAN,

    CONSTRAINT FK_CCD_T
    FOREIGN KEY(MATHUOC)
    REFERENCES THUOC
GO

--CHITIETDONTHUOC
ALTER TABLE CHITIETDONTHUOC
ADD
    CONSTRAINT FK_CTDT_T
    FOREIGN KEY(MATHUOC)
    REFERENCES THUOC,

    CONSTRAINT FK_CTDT_DT
    FOREIGN KEY(MADONTHUOC)
    REFERENCES DONTHUOC
GO

--DONTHUOC
ALTER TABLE DONTHUOC
ADD
    CONSTRAINT FK_DT_KHDT
    FOREIGN KEY(KEHOACHDIEUTRI)
    REFERENCES KEHOACHDIEUTRI
GO

--KEHOACH_DIEUTRI
ALTER TABLE KEHOACH_DIEUTRI
ADD
    CONSTRAINT FK_KH_DT_KHDT
    FOREIGN KEY(KEHOACHDIEUTRI)
    REFERENCES KEHOACHDIEUTRI,

    CONSTRAINT FK_KH_DT_DT
    FOREIGN KEY(DIEUTRI)
    REFERENCES DIEUTRI
GO

--KEHOACHDIEUTRI
ALTER TABLE KEHOACHDIEUTRI
ADD
    CONSTRAINT FK_KHDT_HSCT
    FOREIGN KEY(MABENHNHAN)
    REFERENCES CHITIETHOSOBENHNHAN,

    CONSTRAINT FK_KHDT_NHASI
    FOREIGN KEY(MANHASI)
    REFERENCES NHASI,

    CONSTRAINT FK_KHDT_TROKHAM
    FOREIGN KEY(MATROKHAM)
    REFERENCES NHASI
GO

--RANG
ALTER TABLE RANG
ADD
    CONSTRAINT FK_R_KHDT
    FOREIGN KEY(MAKEHOACH)
    REFERENCES KEHOACHDIEUTRI
GO

--HOADONDIEUTRI
ALTER TABLE HOADONDIEUTRI
ADD
    CONSTRAINT FK_HDDT_DT
    FOREIGN KEY(MADIEUTRI)
    REFERENCES DIEUTRI,

    CONSTRAINT FK_HDDT_TTTT
    FOREIGN KEY(MAHOADON)
    REFERENCES THONGTINTHANHTOAN
GO

--THONGTINTHANHTOAN
ALTER TABLE THONGTINTHANHTOAN
ADD
    CONSTRAINT FK_TTTT_NS
    FOREIGN KEY(NHASI)
    REFERENCES NHASI,

    CONSTRAINT FK_TTTT_BN
    FOREIGN KEY(MABENHNHAN)
    REFERENCES CHITIETHOSOBENHNHAN
GO

--LICHLAMVIEC
ALTER TABLE LICHLAMVIEC
ADD CONSTRAINT
FK_LICHLAMVIEC_NHASI
FOREIGN KEY (MANHASI)
REFERENCES NHASI(MABACSI)
GO
                  