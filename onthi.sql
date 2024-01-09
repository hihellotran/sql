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
create trigger cau1 on Lop after update as
begin 
	if UPDATE(MaLop)
	begin
	print('khong duoc sua ma lop')
	rollback tran
	end
end

select * from Lop 
insert into Lop values ('C3','cntt')
update Lop set MaLop = 'C3' where TenLop = 'cntt'

--Câu 2a: AFTER Trigger cho bảng Lop, kiểm tra TenLop không được phép trùng hoặc null.
go
create trigger cau2a on Lop after insert
as
begin 
	if (select COUNT (*) from Lop where TenLop = (select TenLop from inserted))>=2 
	begin
		print('ten lop khong duoc trung ')
		rollback tran
	end
	if exists (select TenLop from Lop where TenLop = null)
	begin
		print('ten lop khong duoc de trong')
		rollback tran
	end
end
drop trigger cau2a
select * from Lop
insert into Lop values ('c2','cntt')
delete Lop where MaLop = 'c2'
--Câu 2b: INSTEAD OF Trigger cho bảng Lop, kiểm tra TenLop không được phép trùng hoặc null.

--Câu 3: Kiem tra giá trị cột Hoten trong bảng SV không được chứa kí tự số.
go
create trigger cau3 on SV after insert
as
begin
	if exists (select * from SV where HoTen LIKE '%[0-9]%')
	begin
		print('Ho ten khhong duoc co so')
		select * from inserted
	rollback tran
	end
end

select * from SV
drop trigger cau3
insert into SV values('57','57', 'c3')
select * from inserted
--Câu 4a: Giá trị Diem trong bảng KetQua phải >=0 và <=10.
go
create trigger cau4a on KetQua after insert
as
begin 
	if exists(select * from KetQua where Diem <0 or Diem >10)
	begin
		print(N'Điểm không được bé hơn 0 và lớn hơn 10')
	rollback tran
	end
end

insert into KetQua values('57','Toán','10')
select * from KetQua
select * from SV
insert into sv values('57',N'trân', 'c3')
--Cau 4b: AFTER TRIGGER xử lý cho trường hợp tổng quát khi sửa điểm (có thể sửa nhiều điểm cùng lúc).
go
create trigger cau4b on KetQua after update
as
begin 
	if exists(select * from inserted where Diem <0 or Diem >10 )
	begin
		print(N'lỗi')
	rollback tran
	end
end
update KetQua set Diem = '100' where MaSV = 57
update KetQua set Diem = '-1'
select * from KetQua
--Cau 4c: INSTEAD OF TRIGGER xử lý cho trường hợp tổng quát khi sửa điểm tất cả các môn theo sinh viên (có thể sửa điểm cho nhiều sinh viên cùng lúc).

--Câu 5: Khi cập nhật giá trị Diem mới trong bảng KetQua phải có giá trị khác với giá trị Diem cũ.
go
create trigger cau5 on KetQua for update
as
begin
	declare @diemcu int , 
    @diemmoi int;
	set @diemcu = (select Diem from deleted)
	set @diemmoi = (select Diem from inserted)
	if(@diemcu = @diemmoi)
	begin
		print(N'Điểm mới không thể bằng điểm cũ')
	rollback tran
	end
end

select * from KetQua
update KetQua set Diem = 9 where MaSV = '3121410002'or MaSV ='3121410001' and MonThi = N'Hóa'

--Câu 6: Kiểm tra khi thêm mới thì giá trị cột MaSV bên bảng TongKet phải tồn tại bên bảng SV và không được trùng với các giá trị đã có.
go
create trigger cau6 on TongKet for insert
as
begin
	if not exists (select * from SV,TongKet where SV.MaSV = TongKet.MaSV)
	begin
		print(N'Sinh viên này không tồn tại')
		rollback tran
	end
end 
select * from TongKet
delete TongKet where MaSV = '57'
insert into TongKet values ('58', 8.5, 'khá')

--Câu 7: Đảm bảo mỗi SV chỉ có tối đa 3 điểm thi
go
create trigger cau7 on KetQua for insert
as
begin
	if exists (select  COUNT(MaSV) from KetQua group by MaSV having COUNT(Diem) > 3)
	begin
		print(N'Mỗi sinh viên chỉ có tối đa 3 điểm thi')
	rollback tran
	end
end
drop trigger cau7
select * from KetQua
insert into KetQua values ('3121410001', N'Văn', 7)
--Câu 8: Khi thêm dữ liệu vào bảng TongKet phải đảm bảo:
-- SV đã có điểm,
-- TongDiem là tổng các điểm thi của SV đó,
-- GhiChu có giá trị là 'Pass' nếu điểm trung bình các môn >=5 và không có điểm nào dưới 2 còn lại là 'Fail'.

--Câu 9: Khi thay đổi thông tin Diem bên bảng KetQua thì
-- Nếu đã có dòng dữ liệu bên KetQua thì cập nhật giá trị TongDiem và Ghi chú bên bảng TongKet tương ứng với điều kiện như trên câu 7
-- Nếu chưa có thì thêm dòng dữ liệu cho bảng TongKet.