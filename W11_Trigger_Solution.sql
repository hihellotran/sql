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
KQID int,
MaSV varchar(10) foreign key references SV (MaSV),
MonThi nvarchar(10),
Diem int,
constraint pk_KetQua primary key (KQID)
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
(1, '3121410001', N'Toán', 9),
(2, '3121410001', N'Lý', 9),
(3, '3121410001', N'Hóa', 9),
(4, '3121410002', N'Toán', 8),
(5, '3121410002', N'Lý', 8),
(6, '3121410002', N'Hóa', 8),
(7, '3121410003', N'Toán', 7),
(8, '3121410003', N'Lý', 7),
(9, '3121410003', N'Hóa', 7),
(10, '3121410004', N'Toán', 6),
(11, '3121410004', N'Lý', 6),
(12, '3121410004', N'Hóa', 6),
(13, '3121410005', N'Toán', 5),
(14, '3121410005', N'Lý', 5),
(15, '3121410005', N'Hóa', 5),
(16, '3121410006', N'Toán', 4),
(17, '3121410006', N'Lý', 4),
(18, '3121410006', N'Hóa', 4)
go

--ví dụ
create trigger tgTest
on Lop
instead of update
as
begin
	print 'Trigger tgTest is running!';
	if (update(MaLop))
	begin
		print N'Không được sửa MaLop!';
		return;
	end
	select * from Lop;
	select * from inserted;
	select * from deleted;

	declare @malop varchar(10);
	set @malop = (select MaLop from inserted)

	if exists (select * from Lop where MaLop = @malop)
	begin
		--Thực hiện việc cập nhật
		--Cách 1: Trường hợp bảng ít cột
		--declare @tenlopmoi nvarchar(20);
		--set @tenlopmoi = (select TenLop from inserted);
		--update Lop set TenLop = @tenlopmoi where MaLop = @malop;		
		--Cách 2: trường hợp tổng quát
		--B1: xóa dòng cũ
		delete from Lop where MaLop = @malop;
		--B2: thêm dòng với thông tin mới
		insert into Lop select * from inserted;
	end
	else
	begin
		print N'Mã lớp không tồn tại!';
		return;
	end
end

drop trigger tgTest

select * from Lop
delete from Lop where MaLop = 'DCT1222'
insert into Lop values ('DCT1222', N'CNTT 22')

update Lop set TenLop = N'CNTT K22 - Lớp 1' where MaLop = 'DCT1222'
update Lop set TenLop = N'CNTT 22' where MaLop = 'DCT1222'

update Lop set TenLop = N'CNTT K22 - Lớp 1' where MaLop = 'DCT1223'

-- Viết các trigger thực hiện yêu cầu sau (nếu không có chỉ định cụ thể, SV tự xác định hành động làm kích hoạt trigger - INSERT|UPDATE|DELETE):

--Thông tin các trigger có trong CSDL:
select * from sys.objects where type = 'TR'

--Stored Procedure:
select * from sys.objects where type = 'P'

drop proc
drop trigger

--Câu 1: Khi cập nhật dữ liệu bảng Lop thì không cho phép cập nhật giá trị MaLop và thông báo.
create trigger tgCau1
on Lop
after update
as
begin
	if (update(MaLop))
	begin
		print N'Không được sửa MaLop!';
		rollback tran;
	end
end

drop trigger tgCau1

select * from Lop
update Lop set MaLop = 'DCM1222' where MaLop = 'DCT1222'

--Câu 2a: AFTER Trigger cho bảng Lop, kiểm tra TenLop không được phép trùng hoặc null.
create trigger tg2a
on Lop
after insert, update
as begin
	--Kiểm tra null
	if exists (select * from inserted where TenLop is null)
	begin
		print N'Tên lớp không được có giá trị null';
		rollback tran;--transaction
	end
	declare @tenlop nvarchar(20);
	set @tenlop = (select TenLop from inserted);
	--Kiểm tra số dòng có TenLop = giá trị tên lớp mới thêm/sửa
	if( (select count(*) from Lop where TenLop = @tenlop) > 1)
	begin
		print N'Tên lớp không được trùng';
		rollback tran;
	end
end
drop trigger tg2a

select * from Lop
insert into Lop values ('1', 'Lop 1')
insert into Lop values ('2', 'Lop 1')
insert into Lop values ('2', 'Lop 2')
update Lop set TenLop = 'Lop 2' where MaLop = '2'
--Câu 2b: INSTEAD OF Trigger cho bảng Lop, kiểm tra TenLop không được phép trùng hoặc null.
create trigger tg2b
on Lop
instead of insert, update
as begin
	--Kiểm tra null
	if exists (select * from inserted where TenLop is null)
	begin
		print N'Tên lớp không được có giá trị null';
		return;
	end
	--Nếu cập nhật tên lớp cùng lúc cho nhiều row --> Tên Lớp trùng nhau cho các dòng dữ liệu đó
	if( (select count(*) from inserted) > 1)
	begin
		print N'Tên lớp không được trùng';
		return;
	end
	--Xử lý các trường hợp còn lại
	declare @malop varchar(10), @tenlop nvarchar(20);
	select @malop = MaLop, @tenlop = TenLop from inserted;
	--điều kiện khi TenLop bị trùng:
	if exists (select * from Lop where MaLop <> @malop and TenLop = @tenlop)
	begin
		print N'Tên lớp không được trùng';
		return;
	end
	--Khi dữ liệu hợp lệ (tên lớp ko bị trùng)
	--nếu là update:
	if exists (select * from deleted)
	begin
		update Lop set TenLop = @tenlop where MaLop = @malop
		print N'Cập nhật thành công';
	end
	--ngược lại, là insert
	else
	begin
		insert into Lop values (@malop, @tenlop);
		print N'Thêm lớp thành công';
	end
end
drop trigger tg2b

select * from Lop
insert into Lop values ('3', 'Lop 2')
insert into Lop values ('3', 'Lop 3')
update Lop set TenLop = 'Lop 1'
update Lop set TenLop = 'Lop 1' where MaLop = '2'
update Lop set TenLop = N'Lớp 2' where MaLop = '2'
update Lop set TenLop = N'Lớp 3' where MaLop = '3'
--Câu 3: Kiem tra giá trị cột Hoten trong bảng SV không được chứa kí tự số.
create trigger tg3
on SV
after insert, update
as begin
	if exists (select * from inserted where HoTen like '%[0-9]%')
	begin
		print N'Họ tên không được chứa số';
		rollback tran;
	end
end
drop trigger tg3

select * from SV
insert into SV values ('1','Nguyen Thanh An 123', '1')
insert into SV values ('1','Nguyen123 Thanh3 1An', '1')
insert into SV values ('1','Nguyen Thanh An', '1')
--Câu 4a: Giá trị Diem trong bảng KetQua phải >=0 và <=10.
create trigger tg4a
on KetQua
after insert, update
as begin
	declare @diem int;
	set @diem = (select Diem from inserted)
	if (@diem < 0 or @diem > 10)
	begin
		print N'Điểm phải từ 0 đến 10';
		rollback tran
	end
end

select * from KetQua
insert into KetQua values (19, '1', 'T', 5)
insert into KetQua values (20, '1', 'H', 5)
insert into KetQua values (21, '1', 'L', 5)
update KetQua set Diem = Diem + 1 where MaSV = '1'
update KetQua set Diem = 8 where MaSV = '1'

--Cau 4b: AFTER TRIGGER xử lý cho trường hợp tổng quát khi sửa điểm (có thể sửa nhiều điểm cùng lúc).
create trigger tg4b
on KetQua
after insert, update
as begin
	if exists (select * from inserted where Diem <0 or Diem >10)
	begin
		print N'Điểm phải từ 0 đến 10';
		rollback tran;
	end
end
--Cau 4c: INSTEAD OF TRIGGER xử lý cho trường hợp tổng quát khi sửa điểm tất cả các môn theo sinh viên (có thể sửa điểm cho nhiều sinh viên cùng lúc).
create trigger tg4c
on KetQua
instead of update
as begin
	-- nếu điểm không hợp lệ
	if exists (select * from inserted where Diem <0 or Diem >10)
	begin
		print N'Điểm phải từ 0 đến 10';
		return;
	end
	-- nếu điểm hợp lệ
	--Xóa dữ liệu KetQua cũ
	delete from KetQua where KQID in (select KQID from deleted)
	--thêm lại các dòng dữ liệu mới
	insert into KetQua select * from inserted;
	print N'Cập nhật điểm thành công';
end
drop trigger tg4c

select * from KetQua
update KetQua set Diem = 10 where MaSV = '1' and MonThi = 'H'
update KetQua set Diem = 0 where MonThi = N'Hóa'

--Câu 5: Khi cập nhật giá trị Diem mới trong bảng KetQua phải có giá trị khác với giá trị Diem cũ.
create trigger tg5
on KetQua
after update
as begin
	declare @old int, @new int;
	set @old = (select top 1 Diem from deleted)
	set @new = (select top 1 Diem from inserted)
	if(@old = @new)
	begin
		print N'Điểm mới sửa phải khác với điểm cũ';
		rollback tran;
	end
end
drop trigger tg5
select * from KetQua
update KetQua set Diem = 10
--Câu 6: Kiểm tra khi thêm mới thì giá trị cột MaSV bên bảng TongKet phải tồn tại bên bảng SV và không được trùng với các giá trị đã có trong bảng TongKet.
create trigger tg6
on TongKet
after insert
as begin
	declare @masv varchar(10);
	set @masv = (select MaSV from inserted);
	-- MaSV đã tồn tại bên bảng SV (kiểm tra khóa ngoại)
	if not exists (select * from SV where MaSV = @masv)
	begin
		print N'MaSV chưa tồn tại!';
		rollback tran;
	end
	-- MaSV khi thêm mới không trùng với MaSV đã có trong bảng TongKet (kiểm tra khóa chính)
	select * from TongKet
	--Điều kiện sau là sai với trigger after vì dữ liệu insert mới đã được lưu vào bảng TongKet:
	--if exists (select * from TongKet where MaSV = @masv)
	if ((select count(*) from TongKet where MaSV = @masv) > 1)
	begin
		print N'Đã có thông tin TongKet của SV';
		rollback tran;
	end
end
drop trigger tg6

select * from SV
select * from TongKet
delete from TongKet
insert into TongKet(MaSV) values ('1')

--Câu 7: Đảm bảo mỗi SV chỉ có tối đa 3 điểm thi
create trigger tg7 
on KetQua
after insert
as
begin
	declare @masv varchar(10);
	set @masv = (select MaSV from inserted);
	if ((select count(*) from KetQua where MaSV = @masv) > 3)
	begin
		print N'Mỗi SV có tối đa 3 điểm thi';
		rollback tran
	end
end
drop trigger tg7
--Câu 8: Khi thêm dữ liệu vào bảng TongKet phải đảm bảo:
-- SV đã có điểm,
-- TongDiem là tổng các điểm thi của SV đó,
-- GhiChu có giá trị là 'Pass' nếu điểm trung bình các môn >=5 và không có điểm nào dưới 2 còn lại là 'Fail'.
create trigger tg8
on TongKet
after insert
as begin
	declare @masv varchar(10);
	set @masv = (select MaSV from inserted);
	--SV đã có điểm => đã có dòng dữ liệu bên bảng KetQua của SV
	if not exists (select * from KetQua where MaSV = @masv)
	begin
		print N'SV phải có điểm thi bên bảng KetQua';
		rollback tran
	end
	declare @tongdiem int, @ghichu varchar(20);
	--Tính giá trị TongDiem tương ứng của SV
	set @tongdiem = (select sum(Diem) from KetQua where MaSV = @masv);
	--Xử lý giá trị ghichu
	if ((select AVG(Diem) from KetQua where MaSV = @masv) >=5)
		set @ghichu = 'PASS';
	else
		set @ghichu = 'FAIL (DTB<5)';
	if exists (select * from KetQua where MaSV = @masv and Diem < 2)
		set @ghichu = 'FAIL (Diem<2)';
	-- Cập nhật giá trị cho TongDiem và GhiChu
	update TongKet set TongDiem = @tongdiem, GhiChu = @ghichu where MaSV = @masv;
end
drop trigger tg8

select * from KetQua where MaSV = '1'
select * from TongKet
delete from TongKet
insert into TongKet(MaSV) values ('1')
update KetQua set Diem = 10 where KQID = 19
update KetQua set Diem = 2 where KQID = 21

--Câu 9: Khi thay đổi thông tin Diem bên bảng KetQua thì
-- Nếu đã có dòng dữ liệu bên KetQua thì cập nhật giá trị TongDiem và Ghi chú bên bảng TongKet tương ứng với điều kiện như trên câu 7
-- Nếu chưa có thì thêm dòng dữ liệu cho bảng TongKet.

--Sử dụng trigger tg8
create trigger tg9
on KetQua
after update
as begin
	declare @masv varchar(10);
	set @masv = (select MaSV from inserted);
	delete from TongKet where MaSV = @masv;
	insert into TongKet(MaSV) values (@masv);
end
drop trigger tg9

--Không sử dụng trigger tg8
create trigger tg9
on KetQua
after update
as begin
	declare @masv varchar(10);
	set @masv = (select MaSV from inserted);
	declare @tongdiem int, @ghichu varchar(20);
	--Tính giá trị TongDiem tương ứng của SV
	set @tongdiem = (select sum(Diem) from KetQua where MaSV = @masv);
	--Xử lý giá trị ghichu
	if ((select AVG(Diem) from KetQua where MaSV = @masv) >=5)
		set @ghichu = 'PASS';
	else
		set @ghichu = 'FAIL (DTB<5)';
	if exists (select * from KetQua where MaSV = @masv and Diem < 2)
		set @ghichu = 'FAIL (Diem<2)';
	if exists (select * from TongKet where MaSV = @masv)
		update TongKet set TongDiem = @tongdiem, GhiChu=@ghichu where MaSV = @masv;
	else
		insert into TongKet values (@masv, @tongdiem, @ghichu);
end