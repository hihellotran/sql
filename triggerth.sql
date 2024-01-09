-- Sử dụng CSDL như Part 4 Stored Procedure
use [master];
go
drop database if exists CacHeQTCSDL;
go
create database CacHeQTCSDL;
go
use CacHeQTCSDL;
go
--Tao bang
create table Lop
(
MaLop varchar(10) primary key,
TenLop nvarchar (20)
)
go
create table SV
(
MaSV varchar(10) primary key,
HoTen nvarchar(20),
MaLop varchar(10) foreign key references Lop (MaLop)
)
go
create table KetQua
(
MaSV varchar(10) foreign key references SV (MaSV),
MonThi nvarchar(10),
Diem int,
constraint pk_KetQua primary key (MaSV, MonThi)
)
go
create table TongKet
(
MaSV varchar(10),
TongDiem int,
GhiChu nvarchar(20)
)
go
--Sample data
insert into Lop values 
('DCT1211', N'CNTT K21 - Lớp 1'), 
('DCT1212', N'CNTT K21 - Lớp 2'), 
('DCT1221', N'CNTT K22 - Lớp 1')
go
insert into SV values
('3121410001', N'Diệp Thụy An', 'DCT1211'),
('3121410002', N'Nguyễn Ngọc An', 'DCT1211'),
('3121410003', N'Nguyễn Ngọc Anh', 'DCT1211'),
('3121410004', N'Nguyễn Khánh Duy', 'DCT1211'),
('3121410005', N'Nguyễn Tiến Đạt', 'DCT1212'),
('3121410006', N'Lê Công Hiếu', 'DCT1212'),
('3121410007', N'Nguyễn Duy Khang', 'DCT1212'),
('3121410008', N'Trần Hoàng Long', 'DCT1212'),
('3121410009', N'Hoàng Anh Minh', 'DCT1221'),
('3121410010', N'Phan Hoàng Nhân', 'DCT1221'),
('3121410011', N'Trần Thị Khánh Như', 'DCT1221'),
('3121410012', N'Trần Yến Phượng', 'DCT1221')
go
insert into KetQua values
('3121410001', N'Toán', 9),
('3121410001', N'Lý', 9),
('3121410001', N'Hóa', 9),
('3121410002', N'Toán', 8),
('3121410002', N'Lý', 8),
('3121410002', N'Hóa', 8),
('3121410003', N'Toán', 7),
('3121410003', N'Lý', 7),
('3121410003', N'Hóa', 7),
('3121410004', N'Toán', 6),
('3121410004', N'Lý', 6),
('3121410004', N'Hóa', 6),
('3121410005', N'Toán', 5),
('3121410005', N'Lý', 5),
('3121410005', N'Hóa', 5),
('3121410006', N'Toán', 4),
('3121410006', N'Lý', 4),
('3121410006', N'Hóa', 4)
go

-- Viết các trigger thực hiện yêu cầu sau (nếu không có chỉ định cụ thể, SV tự xác định hành động làm kích hoạt trigger - INSERT|UPDATE|DELETE):

--Câu 1: Khi cập nhật dữ liệu bảng Lop thì không cho phép cập nhật giá trị MaLop và thông báo.
create trigger c1 on lop for update
as
begin 
	if update(MaLop)
	begin
		print N'Không được cập nhật mã lớp'
		rollback
	end
end
select * from Lop
UPDATE Lop SET MaLop = 'DCT1213' WHERE TenLop = N'CNTT K21 - Lớp 1'
select * from inserted
go
--Câu 2a: AFTER Trigger cho bảng Lop, kiểm tra TenLop không được phép trùng hoặc null.
go
create trigger c2 for Lop after insert 
as
begin 
	
	

--Câu 2b: INSTEAD OF Trigger cho bảng Lop, kiểm tra TenLop không được phép trùng hoặc null.

--Câu 3: Kiem tra giá trị cột Hoten trong bảng SV không được chứa kí tự số.

--Câu 4a: Giá trị Diem trong bảng KetQua phải >=0 và <=10.
--Cau 4b: AFTER TRIGGER xử lý cho trường hợp tổng quát khi sửa điểm (có thể sửa nhiều điểm cùng lúc).
--Cau 4c: INSTEAD OF TRIGGER xử lý cho trường hợp tổng quát khi sửa điểm (có thể sửa nhiều điểm cùng lúc).

--Câu 5: Khi cập nhật giá trị Diem mới trong bảng KetQua phải có giá trị khác với giá trị Diem cũ.

--Câu 6: Kiểm tra khi thêm mới thì giá trị cột MaSV bên bảng TongKet phải tồn tại bên bảng SV và không được trùng với các giá trị đã có.

--Câu 7: Đảm bảo mỗi SV chỉ có tối đa 3 điểm thi

--Câu 8: Khi thêm dữ liệu vào bảng TongKet phải đảm bảo:
-- SV đã có điểm,
-- TongDiem là tổng các điểm thi của SV đó,
-- GhiChu có giá trị là 'Pass' nếu điểm trung bình các môn >=5 và không có điểm nào dưới 2 còn lại là 'Fail'.

--Câu 9: Khi thay đổi thông tin Diem bên bảng KetQua thì
-- Nếu đã có dòng dữ liệu bên KetQua thì cập nhật giá trị TongDiem và Ghi chú bên bảng TongKet tương ứng với điều kiện như trên câu 7
-- Nếu chưa có thì thêm dòng dữ liệu cho bảng TongKet.