-- Dang nhap 

create proc proc_layNguoiDungTuTenDangNhap @TenDangNhap char(30)
as 
begin 
	select MANGUOIDUNG, MATKHAU
	from NGUOIDUNG u
	where u.TENDANGNHAP = @TenDangNhap
end

GO
--Quan ly ho so benh nhan
--xem danh sach benh nhan
create proc proc_xemDanhSachBenhNhan @from int, @to int
as 

begin
	

end