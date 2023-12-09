--tạo csdl
use master --chuyển csdl hiện hành về master
go 
if DB_ID('QLNhaKhoa') IS NOT NULL
	--alter database QLNhaKhoa set single_user with rollback immediate
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
    MANGUOIDUNG CHAR(6),
    TENNGUOIDUNG NVARCHAR(50) NOT NULL CHECK (TENNGUOIDUNG <> ''),
    NGAYSINH DATE NOT NULL CHECK (NGAYSINH <= GETDATE()),
    DIACHI NVARCHAR(100) NOT NULL CHECK (DIACHI <> ''),
    SODIENTHOAI CHAR(10) NOT NULL CHECK (SODIENTHOAI <> ''),
    --KHÓA CHÍNH
    CONSTRAINT PK_NGUOIDUNG
    PRIMARY KEY(MANGUOIDUNG)
)
GO

CREATE TABLE NHASI
(
    MABACSI CHAR(6),
    CHUYENMON NVARCHAR(50) NOT NULL CHECK(CHUYENMON <> ''),
    KINHNGHIEM NVARCHAR(50) NOT NULL CHECK (KINHNGHIEM <> ''),
    --KHÓA CHÍNH
    CONSTRAINT PK_NHASI
    PRIMARY KEY(MABACSI)
)
GO


CREATE TABLE NHANVIEN
(
    MANHANVIEN CHAR(6),
    PHONGBAN NVARCHAR(50) NOT NULL CHECK (PHONGBAN <> ''),
    --KHÓA CHÍNH
    CONSTRAINT PK_NHANVIEN
    PRIMARY KEY(MANHANVIEN)
)
GO

CREATE TABLE QUANTRIVIEN
(
    MAQTV CHAR(6),
    CHUCVU NVARCHAR(50) NOT NULL CHECK (CHUCVU <> ''),
    --KHÓA CHÍNH
    CONSTRAINT PK_QUANTRIVIEN
    PRIMARY KEY(MAQTV)
)
GO

CREATE TABLE BENHNHAN
(
    MABENHNHAN CHAR(6),
    HOTEN NVARCHAR(50) NOT NULL CHECK (HOTEN <> ''),
    SODIENTHOAI CHAR(10) NOT NULL CHECK (SODIENTHOAI <> ''),
    DIACHI NVARCHAR(100) NOT NULL CHECK (DIACHI <> ''),
    EMAIL NVARCHAR(50) NOT NULL CHECK (EMAIL <> ''),
    NGAYSINH DATE NOT NULL CHECK (NGAYSINH <= GETDATE()),
    NHASI CHAR(6), --Nha sĩ mặc định có thể chứa giá trị null
    --KHÓA CHÍNH
    CONSTRAINT PK_BENHNHAN
    PRIMARY KEY(MABENHNHAN)
)
GO

CREATE TABLE CHITIETHOSOBENHNHAN
(
    MABENHNHAN CHAR(6),
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
    MABENHNHAN CHAR(6),
    MATHUOC CHAR(6),
    --KHÓA CHÍNH
    CONSTRAINT PK_CHONGCHIDINH
    PRIMARY KEY(MABENHNHAN, MATHUOC)
)
GO

CREATE TABLE THUOC
(
    MATHUOC CHAR(6),
    TENTHUOC NVARCHAR(50) NOT NULL CHECK (TENTHUOC <> ''),
    GHICHU NVARCHAR(50),
    --KHÓA CHÍNH
    CONSTRAINT PK_THUOC
    PRIMARY KEY(MATHUOC)
)
GO

CREATE TABLE CHITIETDONTHUOC
(
    MADONTHUOC CHAR(6),
    MATHUOC CHAR(6),
    LIEULUONG NVARCHAR(50) NOT NULL CHECK (LIEULUONG <> ''),
    CHIDINH NVARCHAR(50) NOT NULL CHECK (CHIDINH <> ''),
    --KHÓA CHÍNH
    CONSTRAINT PK_CTDONTHUOC
    PRIMARY KEY(MADONTHUOC, MATHUOC)
)
GO

CREATE TABLE DONTHUOC
(
    MADONTHUOC CHAR(6),
    KEHOACHDIEUTRI CHAR(6) NOT NULL CHECK (KEHOACHDIEUTRI <> ''),
    --KHÓA CHÍNH
    CONSTRAINT PK_DONTHUOC
    PRIMARY KEY(MADONTHUOC)
)
GO

CREATE TABLE KEHOACHDIEUTRI
(
    MAKEHOACH CHAR(6),
    MOTA NVARCHAR(100) NOT NULL CHECK (MOTA <> ''),
    NGAYDIEUTRI DATE NOT NULL CHECK(NGAYDIEUTRI >= GETDATE()),
    TINHTRANG NVARCHAR(50) NOT NULL CHECK(UPPER(TINHTRANG) IN (N'KẾ HOẠCH', N'ĐÃ HOÀN THÀNH', N'ĐÃ HỦY')),
    MABENHNHAN CHAR(6) NOT NULL CHECK (MABENHNHAN <> '')
    --KHÓA CHÍNH
    CONSTRAINT PK_KEHOACHDT
    PRIMARY KEY(MAKEHOACH)
)
GO

CREATE TABLE RANG
(
    MAKEHOACH CHAR(6),
    RANG NVARCHAR(12) CHECK(UPPER(RANG) IN (N'RĂNG CỬA', N'RĂNG NANH', N'RĂNG HÀM NHỎ', N'RĂNG HÀM LỚN')),
    BEMATRANG VARCHAR(7) NOT NULL CHECK(UPPER(BEMATRANG) IN ('LINGUAL', 'FACIAL', 'DISTAL', 'MESIAL', 'TOP', 'ROOT') AND BEMATRANG <> ''),
    --KHÓA CHÍNH
    CONSTRAINT PK_MAKEHOACH
    PRIMARY KEY(MAKEHOACH, RANG)
)
GO

CREATE TABLE KEHOACH_DIEUTRI
(
    KEHOACHDIEUTRI CHAR(6),
    DIEUTRI CHAR(6),
    --KHÓA CHÍNH
    CONSTRAINT PK_KH_DT
    PRIMARY KEY(KEHOACHDIEUTRI, DIEUTRI)
)
GO

CREATE TABLE DIEUTRI
(
    MADIEUTRI CHAR(6),
    TENDIEUTRI NVARCHAR(50) NOT NULL CHECK (TENDIEUTRI <> ''),
    --KHÓA CHÍNH
    CONSTRAINT PK_DIEUTRI
    PRIMARY KEY(MADIEUTRI)
)
GO

CREATE TABLE HOADONDIEUTRI
(
    MAHOADON CHAR(6),
    MADIEUTRI CHAR(6),
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
    MATHANHTOAN CHAR(6),
    NHASI CHAR(6) NOT NULL CHECK (NHASI <> ''),
    BENHNHAN CHAR(6) NOT NULL,
    NGAYTHANHTOAN DATE NOT NULL CHECK(NGAYTHANHTOAN <= GETDATE()),
    NGAYGIAODICH DATE NOT NULL CHECK(NGAYGIAODICH <= GETDATE()),
    TONGTIENTHANHTOAN INT CHECK (TONGTIENTHANHTOAN >= 0),
    TIENDATRA INT NOT NULL CHECK (TIENDATRA >= 0),
    TIENTHOI INT CHECK (TIENTHOI >= 0),
    LOAITHANHTOAN NVARCHAR(50) NOT NULL CHECK(UPPER(LOAITHANHTOAN) IN (N'TIỀN MẶT', N'THANH TOÁN ONLINE') AND LOAITHANHTOAN <> ''),
    --KHÓA CHÍNH
    CONSTRAINT PK_THONGTINTT
    PRIMARY KEY(MATHANHTOAN)
)
GO

CREATE TABLE TROKHAM
(
    NHASI CHAR(6),
    LICHHEN CHAR(6),
    --KHÓA CHÍNH
    CONSTRAINT PK_TROKHAM
    PRIMARY KEY(NHASI, LICHHEN)
)
GO

CREATE TABLE LICHHEN
(
    MALICHHEN CHAR(6),
    THOIGIAN TIME NOT NULL,
    GIOKETTHUC TIME NOT NULL,
    NHASI CHAR(6) NOT NULL CHECK (NHASI <> ''),
    MABENHNHAN CHAR(6) NOT NULL CHECK (MABENHNHAN <> ''),
    GHICHU NVARCHAR(50),
    TINHTRANG NVARCHAR(50) NOT NULL CHECK (TINHTRANG <> ''),
    THOIGIANYEUCAU TIME NOT NULL,
    PHONG CHAR(6) NOT NULL CHECK (PHONG <> ''),
    NGAYHENYEUCAU DATE NOT NULL CHECK(NGAYHENYEUCAU >= GETDATE()),
    --KHÓA CHÍNH
    CONSTRAINT PK_LICHHEN
    PRIMARY KEY(MALICHHEN)
)
GO

CREATE TABLE LICHTAIKHAM
(
    MATAIKHAM CHAR(6),
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
    REFERENCES CHITIETHOSOBENHNHAN
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
    FOREIGN KEY(BENHNHAN)
    REFERENCES CHITIETHOSOBENHNHAN
GO
---------------------------------------- TẠO CÁC TRIGGER ----------------------------------------
--BENH NHAN
GO
CREATE TRIGGER TRIGGER_BN
ON BENHNHAN
FOR INSERT
AS
	BEGIN
		IF EXISTS (SELECT * FROM inserted I, BENHNHAN BN WHERE I.MABENHNHAN = BN.MABENHNHAN AND
				   I.HOTEN LIKE '%[0-9]%')
				   BEGIN
					RAISERROR('HOTEN KHONG THE CHUA KY TU SO', 16, 1)--HỌ TÊN KHÔNG THỂ CÓ KÍ TỰ SỐ 
					ROLLBACK TRANSACTION					
				   END
        IF EXISTS (SELECT * FROM inserted I, BENHNHAN BN WHERE I.MABENHNHAN = BN.MABENHNHAN AND
				   ISNUMERIC(I.SODIENTHOAI) = 0)
				   BEGIN
					RAISERROR('SODIENTHOAI KHONG THE CHUA CHU CAI', 16, 1)--SỐ ĐIỆN THOẠI KHÔNG THỂ CÓ CHỮ CÁI
					ROLLBACK TRANSACTION					
				   END
	END
GO  

--THONGTINTHANHTOAN
-- GO
-- CREATE TRIGGER TRIGGER_THONGTINTT_TIENTHOI --TRIGGER DÙNG ĐỂ TÍNH TOÁN TIỀN THÔI CHO BẢNG THÔNG TIN THANH TOÁN
-- ON THONGTINTHANHTOAN
-- FOR INSERT
-- AS
-- 	BEGIN
-- 		IF EXISTS (SELECT * FROM inserted I, THONGTINTHANHTOAN T WHERE I.MATHANHTOAN = T.MATHANHTOAN AND I.TONGTIENTHANHTOAN < I.TIENDATRA)
-- 				   BEGIN -- TỰ ĐỘNG TÍNH TIỀN THỐI DỰA TRÊN TIỀN CẦN THANH TOÁN VÀ TIỀN ĐÃ TRẢ NẾU TIỀN ĐÃ TRẢ LỚN HƠN TIỀN THANH TOÁN
--                         UPDATE T2
--                         SET T2.TIENTHOI = I.TIENDATRA - I.TONGTIENTHANHTOAN
--                         FROM THONGTINTHANHTOAN T2 JOIN inserted I ON T2.MATHANHTOAN = I.MATHANHTOAN
-- 				   END
--         ELSE 
--         --NẾU TIỀN CẦN THANH TOÁN LỚN HƠN HOẶC BẰNG TIỀN ĐÃ TRẢ THÌ TIỀN THỐI BẰNG 0
--                     BEGIN
--                         UPDATE T2
--                         SET T2.TIENTHOI = 0
--                         FROM THONGTINTHANHTOAN T2 JOIN inserted I ON T2.MATHANHTOAN = I.MATHANHTOAN
--                     END
-- 	END
-- GO  

CREATE TRIGGER TRIGGER_THONGTINTT_TONGTIEN --TRIGGER CHO BẢNG THÔNG TIN THANH TOÁN ĐỂ TÍNH TỔNG TIỀN ĐIỀU TRỊ DỰA TRÊN BẢNG HÓA ĐƠN THANH TOÁN
ON THONGTINTHANHTOAN
FOR INSERT
AS
    BEGIN
        IF EXISTS (SELECT * FROM inserted I, THONGTINTHANHTOAN T WHERE I.MATHANHTOAN = T.MATHANHTOAN AND I.NGAYGIAODICH < I.NGAYTHANHTOAN) 
            BEGIN
                --PHẦN NÀY ĐỂ KIỂM TRA MỖI LẦN THÊM MỘT THÔNG TIN THANH TOÁN, ĐẢM BẢO PHẦN TỔNG TIỀN ĐIỀU TRỊ TRONG BẢNG HỒ SƠ CHI TIẾT BỆNH NHÂN CŨNG ĐƯỢC UPDATE
                IF EXISTS (SELECT * FROM THONGTINTHANHTOAN T JOIN CHITIETHOSOBENHNHAN CTHS ON CTHS.MABENHNHAN = T.BENHNHAN JOIN INSERTED I ON I.MATHANHTOAN = T.MATHANHTOAN)
                        BEGIN
                            --TÍNH TỔNG TIỀN ĐIỀU TRỊ CHO HỒ SƠ CHI TIẾT BỆNH NHÂN BẰNG CÁCH TÍNH TỔNG TẤT CẢ TIỀN CẦN THANH TOÁN CỦA BỆNH NHÂN NÀY
                            DECLARE @TONGDIEUTRI INT = (SELECT SUM(T1.TONGTIENTHANHTOAN)
                                            FROM THONGTINTHANHTOAN T1 JOIN CHITIETHOSOBENHNHAN CTHS1 ON CTHS1.MABENHNHAN = T1.BENHNHAN JOIN INSERTED I ON I.BENHNHAN = CTHS1.MABENHNHAN
                                            GROUP BY T1.BENHNHAN)
                                UPDATE CTHSBN
                                SET CTHSBN.TONGTIENDIEUTRI = @TONGDIEUTRI
                                FROM CHITIETHOSOBENHNHAN CTHSBN JOIN INSERTED I ON I.BENHNHAN = CTHSBN.MABENHNHAN 
                            
                            --TÍNH TỔNG TIỀN ĐÃ TRẢ CỦA BỆNH NHÂN
                            DECLARE @TONGTHANHTOAN INT = (SELECT SUM(T2.TIENDATRA)
                                            FROM THONGTINTHANHTOAN T2 JOIN CHITIETHOSOBENHNHAN CTHS2 ON CTHS2.MABENHNHAN = T2.BENHNHAN JOIN INSERTED I ON I.BENHNHAN = CTHS2.MABENHNHAN
                                            GROUP BY T2.BENHNHAN)
                                UPDATE CTHSBN
                                SET CTHSBN.DATHANHTOAN = @TONGTHANHTOAN
                                FROM CHITIETHOSOBENHNHAN CTHSBN JOIN INSERTED I ON I.BENHNHAN = CTHSBN.MABENHNHAN 
                        END

                --TÍNH TỔNG TIỀN THANH TOÁN CỦA MỖI THANH TOÁN BẰNG CÁCH LẤY TỔNG PHÍ ĐIỀU TRỊ CỦA TẤT CẢ HOÁ ĐƠN ĐIỀU TRỊ CỦA THANH TOÁN NÀY
                IF EXISTS (SELECT * FROM THONGTINTHANHTOAN T JOIN HOADONDIEUTRI HD ON HD.MAHOADON = T.MATHANHTOAN JOIN INSERTED I ON I.MATHANHTOAN = T.MATHANHTOAN)
                    BEGIN
                        DECLARE @TONGTIEN INT = (SELECT SUM(HD.PHIDIEUTRI)
                                    FROM THONGTINTHANHTOAN T JOIN HOADONDIEUTRI HD ON T.MATHANHTOAN = HD.MAHOADON
                                    GROUP BY T.MATHANHTOAN)
                        UPDATE THONGTINTHANHTOAN
                        SET TONGTIENTHANHTOAN = @TONGTIEN
                        FROM THONGTINTHANHTOAN T JOIN INSERTED I ON I.MATHANHTOAN = T.MATHANHTOAN 
                    END
                ELSE 
                --NẾU THANH TOÁN NÀY CHƯA CÓ KẾ HOẠCH ĐIỀU TRỊ NÀO THÌ TỔNG TIỀN CẦN THANH TOÁN LÀ 0
                    BEGIN
                        UPDATE THONGTINTHANHTOAN
                        SET TONGTIENTHANHTOAN = 0
                        FROM THONGTINTHANHTOAN T JOIN INSERTED I ON I.MATHANHTOAN = T.MATHANHTOAN 

                    END

                -- TỰ ĐỘNG TÍNH TIỀN THỐI DỰA TRÊN TIỀN CẦN THANH TOÁN VÀ TIỀN ĐÃ TRẢ NẾU TIỀN ĐÃ TRẢ LỚN HƠN TIỀN THANH TOÁN
                IF EXISTS (SELECT * FROM inserted I, THONGTINTHANHTOAN T WHERE I.MATHANHTOAN = T.MATHANHTOAN AND I.TONGTIENTHANHTOAN < I.TIENDATRA)
                        BEGIN 
                                UPDATE T2
                                SET T2.TIENTHOI = T2.TIENDATRA - T2.TONGTIENTHANHTOAN
                                FROM THONGTINTHANHTOAN T2 JOIN inserted I ON T2.MATHANHTOAN = I.MATHANHTOAN
                        END
                ELSE 
                --NẾU TIỀN CẦN THANH TOÁN LỚN HƠN HOẶC BẰNG TIỀN ĐÃ TRẢ THÌ TIỀN THỐI BẰNG 0
                        BEGIN
                                UPDATE T2
                                SET T2.TIENTHOI = 0
                                FROM THONGTINTHANHTOAN T2 JOIN inserted I ON T2.MATHANHTOAN = I.MATHANHTOAN
                        END
                
            END
        ELSE 
            BEGIN
                RAISERROR('NGAY THANH TOAN PHAI LON HON NGAY GIAO DICH', 16, 1)--SỐ ĐIỆN THOẠI KHÔNG THỂ CÓ CHỮ CÁI
				ROLLBACK TRANSACTION
            END
    END
GO


--TRIGGER KIỂM TRA LỊCH HẸN CÓ TRÙNG VỚI CÁC LỊCH KHÁC CỦA BỆNH NHÂN HOẶC BÁC SĨ KHÔNG
CREATE TRIGGER TRIGGER_LICHHEN 
ON LICHHEN
INSTEAD OF INSERT
AS
	BEGIN
		IF EXISTS (SELECT * FROM inserted I, LICHHEN LH WHERE (I.MABENHNHAN = LH.MABENHNHAN OR I.NHASI = LH.NHASI) AND I.THOIGIAN >= LH.THOIGIAN AND I.GIOKETTHUC <= LH.GIOKETTHUC)
			BEGIN
					RAISERROR('LICH HEN KHONG DUOC TRUNG VOI LICH CUA BENH NHAN HOAC NHA SI', 16, 1)--HỌ TÊN KHÔNG THỂ CÓ KÍ TỰ SỐ 
					ROLLBACK TRANSACTION	
			END
        ELSE
            BEGIN
                    INSERT INTO LICHHEN(MALICHHEN, THOIGIAN, GIOKETTHUC, NHASI, MABENHNHAN,  THOIGIANYEUCAU, NGAYHENYEUCAU, PHONG, TINHTRANG, GHICHU)
                    SELECT MALICHHEN, THOIGIAN, GIOKETTHUC, NHASI, MABENHNHAN,  THOIGIANYEUCAU, NGAYHENYEUCAU, PHONG, TINHTRANG, GHICHU
                    FROM inserted
            END
	END
GO

--TÍNH TUỔI TRÊN BẢNG CHI TIẾT HSBN
CREATE TRIGGER TRIGGER_TINHTUOI
ON CHITIETHOSOBENHNHAN
FOR INSERT
AS
    BEGIN
        IF EXISTS (SELECT * FROM inserted I, BENHNHAN BN WHERE I.MABENHNHAN = BN.MABENHNHAN)
            BEGIN
                UPDATE CTHSBN
                SET CTHSBN.TUOI = DATEDIFF(YY, BN.NGAYSINH, GETDATE())
                FROM BENHNHAN BN JOIN CHITIETHOSOBENHNHAN CTHSBN ON CTHSBN.MABENHNHAN = BN.MABENHNHAN
            END
    END
GO

--TÍNH TỔNG TIỀN ĐIỀU TRỊ TRÊN BẢNG CHITIETHOSOBENHNHAN
CREATE TRIGGER TRIGGER_HSCTBN_TINHTIEN 
ON CHITIETHOSOBENHNHAN
FOR INSERT
AS
    BEGIN
        IF EXISTS (SELECT * FROM inserted I, CHITIETHOSOBENHNHAN BN WHERE I.MABENHNHAN = BN.MABENHNHAN)
            BEGIN
                IF EXISTS (SELECT * FROM THONGTINTHANHTOAN T JOIN CHITIETHOSOBENHNHAN CTHS ON CTHS.MABENHNHAN = T.BENHNHAN JOIN INSERTED I ON I.MABENHNHAN = CTHS.MABENHNHAN)
                    BEGIN
                        DECLARE @TONGDIEUTRI INT = (SELECT SUM(T1.TONGTIENTHANHTOAN)
                                        FROM THONGTINTHANHTOAN T1 JOIN CHITIETHOSOBENHNHAN CTHS1 ON CTHS1.MABENHNHAN = T1.BENHNHAN JOIN INSERTED I ON I.MABENHNHAN = CTHS1.MABENHNHAN
                                        GROUP BY T1.BENHNHAN)
                            UPDATE CTHSBN
                            SET CTHSBN.TONGTIENDIEUTRI = @TONGDIEUTRI
                            FROM CHITIETHOSOBENHNHAN CTHSBN JOIN INSERTED I ON I.MABENHNHAN = CTHSBN.MABENHNHAN 
                        
                        DECLARE @TONGTHANHTOAN INT = (SELECT SUM(T2.TIENDATRA)
                                        FROM THONGTINTHANHTOAN T2 JOIN CHITIETHOSOBENHNHAN CTHS2 ON CTHS2.MABENHNHAN = T2.BENHNHAN JOIN INSERTED I ON I.MABENHNHAN = CTHS2.MABENHNHAN
                                        GROUP BY T2.BENHNHAN)
                            UPDATE CTHSBN
                            SET CTHSBN.DATHANHTOAN = @TONGTHANHTOAN
                            FROM CHITIETHOSOBENHNHAN CTHSBN JOIN INSERTED I ON I.MABENHNHAN = CTHSBN.MABENHNHAN 
                    END
                ELSE
                    BEGIN
                        UPDATE CTHSBN
                        SET CTHSBN.TONGTIENDIEUTRI = 0
                        FROM CHITIETHOSOBENHNHAN CTHSBN JOIN INSERTED I ON I.MABENHNHAN = CTHSBN.MABENHNHAN 

                        UPDATE CTHSBN
                        SET CTHSBN.DATHANHTOAN = 0
                        FROM CHITIETHOSOBENHNHAN CTHSBN JOIN INSERTED I ON I.MABENHNHAN = CTHSBN.MABENHNHAN 
                    END
            END
    END
GO



--UPDATE LẠI GIÁ TRỊ TỔNG TIỀN THANH TOÁN CỦA BẢNG THÔNG TIN THANH TOÁN MỖI KHI HÓA ĐƠN TƯƠNG ỨNG VỚI THANH TOÁN NÀY ĐƯỢC NHẬP
CREATE TRIGGER TRIGGER_HOADONDIEUTRI
ON HOADONDIEUTRI
FOR INSERT
AS
    BEGIN
        IF EXISTS (SELECT * FROM inserted I, HOADONDIEUTRI HD WHERE I.MAHOADON = HD.MAHOADON)
            BEGIN
                IF EXISTS (SELECT * FROM THONGTINTHANHTOAN T JOIN HOADONDIEUTRI HD ON HD.MAHOADON = T.MATHANHTOAN JOIN INSERTED I ON I.MAHOADON = T.MATHANHTOAN)
                    BEGIN
                        DECLARE @TONGTHANHTOAN INT = (SELECT SUM(HD.PHIDIEUTRI)
                                    FROM THONGTINTHANHTOAN T JOIN HOADONDIEUTRI HD ON T.MATHANHTOAN = HD.MAHOADON JOIN INSERTED I ON I.MAHOADON = T.MATHANHTOAN
                                    GROUP BY T.MATHANHTOAN)
                        UPDATE THONGTINTHANHTOAN
                        SET TONGTIENTHANHTOAN = @TONGTHANHTOAN
                        FROM THONGTINTHANHTOAN TTTT JOIN INSERTED I ON I.MAHOADON = TTTT.MATHANHTOAN 
                    END
            END
        --UPDATE LẠI GIÁ TRỊ TỔNG TIỀN CẦN THANH TOÁN TRONG HỒ SƠ CHI TIẾT BỆNH NHÂN LUÔN
        IF EXISTS (SELECT * FROM THONGTINTHANHTOAN T JOIN CHITIETHOSOBENHNHAN CTHS ON CTHS.MABENHNHAN = T.BENHNHAN JOIN INSERTED I ON T.MATHANHTOAN = I.MAHOADON)
            BEGIN
                DECLARE @MABENHNHAN CHAR(6) = (SELECT BN.MABENHNHAN FROM BENHNHAN BN JOIN THONGTINTHANHTOAN TT ON BN.MABENHNHAN = TT.BENHNHAN JOIN inserted I ON I.MAHOADON = TT.MATHANHTOAN)
                DECLARE @TONGDIEUTRI INT = (SELECT SUM(T1.TONGTIENTHANHTOAN)
                                FROM THONGTINTHANHTOAN T1 JOIN CHITIETHOSOBENHNHAN CTHS1 ON CTHS1.MABENHNHAN = T1.BENHNHAN
                                WHERE T1.BENHNHAN = @MABENHNHAN)
                    UPDATE CTHSBN
                    SET CTHSBN.TONGTIENDIEUTRI = @TONGDIEUTRI
                    FROM CHITIETHOSOBENHNHAN CTHSBN JOIN THONGTINTHANHTOAN T ON T.BENHNHAN = CTHSBN.MABENHNHAN JOIN INSERTED I ON I.MAHOADON = T.MATHANHTOAN
                        
            END

        -- TỰ ĐỘNG TÍNH TIỀN THỐI DỰA TRÊN TIỀN CẦN THANH TOÁN VÀ TIỀN ĐÃ TRẢ NẾU TIỀN ĐÃ TRẢ LỚN HƠN TIỀN THANH TOÁN
        IF EXISTS (SELECT * FROM inserted I, THONGTINTHANHTOAN T WHERE I.MAHOADON = T.MATHANHTOAN AND T.TONGTIENTHANHTOAN < T.TIENDATRA)
            BEGIN 
                    UPDATE T2
                    SET T2.TIENTHOI = T2.TIENDATRA - T2.TONGTIENTHANHTOAN
                    FROM THONGTINTHANHTOAN T2 JOIN inserted I ON T2.MATHANHTOAN = I.MAHOADON
            END
        ELSE 
        --NẾU TIỀN CẦN THANH TOÁN LỚN HƠN HOẶC BẰNG TIỀN ĐÃ TRẢ THÌ TIỀN THỐI BẰNG 0
            BEGIN
                    UPDATE T2
                    SET T2.TIENTHOI = 0
                    FROM THONGTINTHANHTOAN T2 JOIN inserted I ON T2.MATHANHTOAN = I.MAHOADON
            END
    END
GO




-- DELETE FROM CHITIETHOSOBENHNHAN WHERE MABENHNHAN = '002'
-- DELETE FROM BENHNHAN WHERE MABENHNHAN = '002'

--  INSERT INTO BENHNHAN(MABENHNHAN, HOTEN, DIACHI, SODIENTHOAI, EMAIL, NGAYSINH)
--  VALUES ('003', 'duc huy', 'abc1', '1243454', 'HUYV7264', '12/6/2003')

--  INSERT INTO CHITIETHOSOBENHNHAN(MABENHNHAN, TUOI, GIOITINH, TONGTIENDIEUTRI, DATHANHTOAN, SUCKHOERANGMIENG, TINHTRANGDIUNG)
--  VALUES ('003', 3, 'NAM', 1000000, 1, NULL, NULL)

--   INSERT INTO BENHNHAN(MABENHNHAN, HOTEN, DIACHI, SODIENTHOAI, EMAIL, NGAYSINH)
--  VALUES ('002', 'duc huy', 'abc1', '1243454', 'HUYV7264', '12/6/2002')

--  INSERT INTO CHITIETHOSOBENHNHAN(MABENHNHAN, TUOI, GIOITINH, TONGTIENDIEUTRI, DATHANHTOAN, SUCKHOERANGMIENG, TINHTRANGDIUNG)
--  VALUES ('002', 3, 'NAM', 1000000, 1, NULL, NULL)


-- -- --  INSERT INTO BENHNHAN(MABENHNHAN, HOTEN, DIACHI, SODIENTHOAI, EMAIL, NGAYSINH)
-- -- --  VALUES ('001', 'duc huy', 'abc1', '1243454', 'HUYV7264', '21/2/2002')

--  SELECT * FROM BENHNHAN

-- -- --   INSERT INTO CHITIETHOSOBENHNHAN(MABENHNHAN, TUOI, GIOITINH, TONGTIENDIEUTRI, DATHANHTOAN, SUCKHOERANGMIENG, TINHTRANGDIUNG)
-- -- --  VALUES ('001', NULL, 'NAM', NULL, NULL, NULL, NULL)

--  SELECT * FROM CHITIETHOSOBENHNHAN

--  SELECT * FROM CHITIETHOSOBENHNHAN CTHSBN

-- INSERT INTO NGUOIDUNG(MANGUOIDUNG, TENNGUOIDUNG, NGAYSINH, DIACHI, SODIENTHOAI)
-- VALUES ('002', 'duc huy', '03/04/2003', 'ANAUD', '176252')

-- INSERT INTO NHASI(MABACSI, CHUYENMON, KINHNGHIEM)
-- VALUES ('002', 'BGGDG', 'HUADAD')
-- SELECT * FROM NHASI

-- INSERT INTO LICHHEN(MALICHHEN, THOIGIAN, GIOKETTHUC, NHASI, MABENHNHAN,  THOIGIANYEUCAU, NGAYHENYEUCAU, PHONG, TINHTRANG)
-- VALUES ('002', '08:30', '9:30', '003', '002', '12/06/2021', '12/6/2024', 'P098', 'LICH MOI')

-- INSERT INTO THONGTINTHANHTOAN(MATHANHTOAN, NHASI, NGAYGIAODICH, NGAYTHANHTOAN, TONGTIENTHANHTOAN, TIENDATRA, TIENTHOI, LOAITHANHTOAN)
-- VALUES ('001', '003', '01/01/2020', '02/02/2022', 500, 600, 200, N'TIỀN MẶT')

-- INSERT INTO THONGTINTHANHTOAN(MATHANHTOAN, NHASI, NGAYGIAODICH, NGAYTHANHTOAN, TONGTIENTHANHTOAN, TIENDATRA, TIENTHOI, LOAITHANHTOAN, BENHNHAN)
-- VALUES ('007', '002', '01/01/2020', '02/02/2022', 1, 500, 1, N'TIỀN MẶT', '001')

-- SELECT * FROM THONGTINTHANHTOAN

-- -- SELECT * FROM THONGTINTHANHTOAN
-- INSERT INTO HOADONDIEUTRI(MAHOADON, MADIEUTRI, MOTA, NGAYDIEUTRI, PHIDIEUTRI)
-- VALUES ('007', '003', 'DEO CO MO TA', '21/12/2022', 10)

-- SELECT * FROM HOADONDIEUTRI

-- INSERT DIEUTRI(MADIEUTRI, TENDIEUTRI)
-- VALUES ('003', 'E')


