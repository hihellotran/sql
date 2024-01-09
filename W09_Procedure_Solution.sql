use classicmodels;
go
/*
Part 1: Stored Procedure đơn giản, không truy xuất dữ liệu
*/
-- 1.1. Viết stored-procedure in ra dòng:
-- Xin chào + @ten.
-- *Chú ý: với @ten là tham số đầu vào là họ tên của bạn (viết tiếng việt).
create proc spBai11 @ten nvarchar(20)
as
begin
	print N'Xin chào ' + @ten + '!';
end

drop proc spBai11

exec spBai11 N'Hoàng Mạnh Hà'
go
-- 1.2. Viết stored-procedure tính tổng 2 số a, b và in kết quả theo định dạng sau:
-- ‘Tổng 2 số’ + @a + ‘và’ + @b ‘là:’ + @kq
-- 1.3. Viết stored-procedure tính tích 2 số a, b và in kết quả theo định dạng sau:
-- ‘Tích 2 số’ + @a + ‘và’ + @b ‘là:’ + @kq
-- 1.4. Viết stored-procedure tính thương 2 số a, b và in kết quả theo định dạng sau:
-- ‘Thương 2 số’ + @a + ‘và’ + @b ‘là:’ + @kq
create proc spBai1234 @a int, @b int
as
begin
	declare @tong int;
	declare @tich int;
	declare @thuong float;
	set @tong = @a + @b;
	set @tich = @a * @b;
	set @thuong = cast(@a as float) / cast(@b as float);
	print N'Tổng 2 số ' + cast(@a as nvarchar(5)) + ' và ' + cast(@b as nvarchar(5)) + ' là: ' + cast(@tong as nvarchar(5));
	print N'Tích 2 số ' + cast(@a as nvarchar(5)) + ' và ' + cast(@b as nvarchar(5)) + ' là: ' + cast(@tich as nvarchar(5));
	print N'Thương 2 số ' + cast(@a as nvarchar(5)) + ' và ' + cast(@b as nvarchar(5)) + ' là: ' + cast(@thuong as nvarchar(5));
end

drop proc spBai1234

exec spBai1234 8, 10

go
-- 1.5. Viết stored-procedure tìm số lớn nhất trong 3 số a, b, c và in kết quả theo định dạng sau:
-- ‘Số lớn nhất trong 3 số’ + @a + @b + ‘và’ + @c ‘là:’ + @kq
create proc spBai15 @a int, @b int, @c int
as
begin
	declare @max int;
	set @max = @a;
	if(@b > @max)
		set @max = @b;
	if(@c > @max)
		set @max = @c;
	print N'Số lớn nhất trong 3 số ' + cast(@a as nvarchar(5)) + ', ' + cast(@b as nvarchar(5)) + ' và ' + cast(@c as nvarchar(5)) +' là: ' + cast(@max as nvarchar(5));
end

drop proc spBai15

exec spBai15 15, 17, 9

go
-- 1.6. Viết stored-procedure tìm số nhỏ nhất trong 3 số a, b, c và in kết quả theo định dạng sau:
-- ‘Số nhỏ nhất trong 3 số’ + @a + @b + ‘và’ + @c ‘là:’ + @kq
create proc spBai16 @a int, @b int, @c int
as
begin
	declare @min int;
	set @min = @a;
	if(@b < @min)
		set @min = @b;
	if(@c < @min)
		set @min = @c;
	print N'Số nhỏ nhất trong 3 số ' + cast(@a as nvarchar(5)) + ', ' + cast(@b as nvarchar(5)) + ' và ' + cast(@c as nvarchar(5)) +' là: ' + cast(@min as nvarchar(5));
end

drop proc spBai16

exec spBai16 5, 7, 9

go
-- 1.7. Viết stored-procedure truyền vào số nguyên n in ra số lượng số chẳn và tổng các số chẳn.
create proc spBai17 @n int
as
begin
	declare @i int, @tong int;
	set @i = 1;
	set @tong = 0;
	while (@i <= @n)
	begin
		print 2*@i;
		set @tong = @tong + 2*@i;
		set @i = @i + 1;
	end
	print N'Tổng: ' + cast(@tong as varchar(10));
end
drop proc spBai17
exec spBai17 4
-- 1.8. Viết stored-procedure truyền vào 2 số nguyên, tìm ước chung lớn nhất của 2 số nguyên trên.
create proc spBai18 @a int, @b int
as
begin
	--Giải thuật Euclid về tìm UCLN
	declare @t int;
	while (@b != 0)
	begin
		set @t = @b;
		set @b = @a % @b;
		set @a = @t;
	end
	print N'Ước chung lớn nhất: ' + cast(@a as varchar(10));
end
drop proc spBai18
exec spBai18 50, 125
-- 1.9. Viết stored-procedure truyền vào n, tính tổng các số nguyên thuộc [1, n]
create proc spBai19 @n int
as
begin
	declare @i int, @tong int;
	set @i = 1;
	set @tong = 0;
	while (@i <= @n)
	begin
		print @i;
		set @tong = @tong + @i;
		set @i = @i + 1;
	end
	print N'Tổng: ' + cast(@tong as varchar(10));
end
drop proc spBai19
exec spBai19 6
-- 1.10. Viết stored-procedure truyền vào n tính tổng các số chính phương thuộc [1,n].
create proc spBai110 @n int
as
begin
	declare @i int, @tong int;
	set @i = 1;
	set @tong = 0;
	while (@i*@i <= @n)
	begin
		print @i*@i;
		set @tong = @tong + @i*@i;
		set @i = @i + 1;
	end
	print N'Tổng: ' + cast(@tong as varchar(10));
end
drop proc spBai110
exec spBai110 50

/*
Part 2: Stored Procedure không có tham số đầu vào
*/

select * from productlines
select * from employees
select * from customers
select * from offices
select * from orders
select * from orderdetails

-- 2.1 In ra danh sách các sản phẩm tỷ lệ 1:18
select * from products

create proc spBai21 @tl varchar(10)
as
begin
	select * from products where productScale = @tl;
	declare @rc int;
	--set @rc = (select count(*) from products where productScale = @tl);
	select @rc = count(*) from products where productScale = @tl;
	print N'Có ' + cast(@rc as varchar(10)) + N' sản phẩm có productScale là ' +@tl;
end

drop proc spBai21
exec spBai21 '1:18'
exec spBai21 '1:12'

-- 2.2 In ra danh sách khách hàng có contactLastName là 'Young'

-- 2.3 In ra danh sách các khách hàng chỉ có 1 dòng thông tin địa chỉ.

-- 2.4 In ra thông tin các văn phòng ở 'USA'.

-- 2.5 In ra thông tin các nhân viên thuộc văn phòng ở thành phố 'San Francisco'.

-- 2.6 In ra thông tin các đơn hàng cùng với tổng giá trị đơn hàng đó.

-- 2.7 In ra thông tin khách hàng cùng với số lượng đơn hàng đã mua.

-- 2.8 In ra thông tin productLine chưa có sản phẩm nào

-- 2.9 In ra danh sách các sản phẩm có productCode không tương ứng với productScale (VD: sản phẩm có tỷ lệ 1:18 sẽ có mã bắt đầu bằng S18)

/*
Part 3: Stored Procedure có tham số đầu vào
*/
-- 3.1. Viết lại các Stored Procedure ở Part 2 nếu cần nhận tham số đầu vào là các thông tin tương ứng

-- 3.2 Viết stored procedure nhận vào @productLineName và @textDescription, thực hiện việc thêm mới 1 productLine với thông tin tương ứng, các dữ liệu khác mang giá trị NULL.
create proc spBai32 @plName varchar(20) = 'Ships', @text nvarchar(100) = 'ABC'
as
begin
	-- Check plName đã tồn tại
	if EXISTS (select * from productlines where productLine=@plName)
		--Nếu đã tồn tại
		print N'ProductLine ('+@plName+N') đã tồn tại!';
	else
		insert into productlines (productLine, textDescription) values (@plName, @text);
end

drop proc spBai32
exec spBai32
exec spBai32 'Bicycle', 'A bicycle, also called a pedal cycle, bike, push-bike or cycle, is a human-powered or motor-powered assisted, pedal-driven, single-track vehicle, having two wheels attached to a frame, one behind the other.'
select * from productlines
-- 3.3 Viết SP nhận tham số đầu vào là giá trị @customerNumber và in ra câu thông báo:
-- 'Khách hàng mã số @customerNumber (@customerName, @country) đã mua @sl đơn hàng!'
select * from customers
select * from orders order by customerNumber

create proc spBai27P @cn varchar(10)
as
begin
	declare @name varchar(50), @c varchar(50), @sl int;
	select @name=customerName, @c = country from customers where customerNumber = @cn;
	set @sl = (select count(*) from orders where customerNumber = @cn);
	print N'Khách hàng mã số '+@cn+' ('+@name+' , '+@c+N') đã mua '+cast(@sl as varchar(10))+N' đơn hàng!'
end

drop proc spBai27P
exec spBai27P '103'
exec spBai27P '112'
exec spBai27P '114'

-- 3.4 Viết sp nhận vào mã nhân viên và in ra thông tin như sau:
-- [EmployeeNumber] ([firstName] [lastName]) ...
-- + Nếu nhân viên đó là quản lý: 1056 (Mary Patterson) có 4 nhân viên:1088 ,1102 ,1143 ,1621
-- + Nếu nhân viên đó không phải quản lý: 1076 (Jeff Firrelli) không có quản lý nhân viên nào!
-- Tham khảo thêm hàm STRING_AGG (T-SQL) hoặc GROUP_CONCAT (MySQL)
create proc spBai34 @bNo varchar(50) = '1056'
as
begin
	declare @emCount int, @bFName varchar(50), @bLName varchar(50), @emList varchar(100);
	select @emCount=count(*) from employees where reportsTo = @bNo;
	select @bFName=firstName, @bLName=lastName from employees where employeeNumber = @bNo;	
	if(@emCount = 0)
		print @bNo + ' (' + @bFName + ' ' +@bLName + N') không có quản lý nhân viên nào!';
	else
	begin
		select @emList=STRING_AGG(employeeNumber, ' ,') from employees where reportsTo = @bNo;
		print @bNo + ' (' + @bFName + ' ' +@bLName + N') có ' + cast(@emCount as varchar(10)) + N' nhân viên:' + @emList;
	end
end

select * from employees

drop proc spBai34
exec spBai34
exec spBai34 '1002'
exec spBai34 '1076'

-- 3.5 Viết SP nhận vào mã khách hàng và in ra thông tin thanh toán của khách hàng như sau:
-- Khách hàng [customerNumber] ([customerName]) - ([contactLastName] : [phone] : [country]) ...
-- + Khách hàng 103 (Atelier graphique) - (Schmitt : 40.32.2555 : France) đã thanh toán đủ!
-- + Khách hàng 119 (La Rochelle Gifts) - (Labrune : 40.67.8555 : France) còn nợ: [số tiền nợ]

select *
from
	(select customerNumber, SUM(quantityOrdered*priceEach) 'Order Value'
	from orders o join orderdetails od on o.orderNumber=od.orderNumber
	group by customerNumber) a
join
	(select customerNumber, SUM(amount) 'Payment Value'
	from payments
	group by customerNumber) b on a.customerNumber=b.customerNumber

select *
from
	(select customerNumber, SUM(quantityOrdered*priceEach) 'Order Value'
	from orders o join orderdetails od on o.orderNumber=od.orderNumber
	group by customerNumber) a
join
	(select customerNumber, SUM(amount) 'Payment Value'
	from payments
	group by customerNumber) b on a.customerNumber=b.customerNumber
where a.[Order Value]>b.[Payment Value]

create proc spBai35 @cN varchar(10) = '103'
as
begin
	declare @ov decimal, @pv decimal, @cName varchar(50), @ctLN varchar(50), @phone varchar(20), @country varchar(50);
	--Lấy giá trị đặt hàng theo mã khách hàng
	set @ov = (select SUM(quantityOrdered*priceEach)
			from orders o join orderdetails od on o.orderNumber=od.orderNumber
			where customerNumber = @cN);
	--Lấy giá trị payments theo mã khách hàng
	set @pv = (select SUM(amount) from payments where customerNumber = @cN);
	--Lấy các thông tin khác theo yêu cầu
	select @cName=customerName, @ctLN=contactLastName, @phone=phone, @country=country from customers where customerNumber=@cN;
	--So sánh giữa Order value và payment value
	if(@ov > @pv)
		print N'Khách hàng '+@cN+' ('+@cName+') - ('+@ctLN +' : '+@phone+' : '+@country+N') còn nợ: '+cast(@ov-@pv as varchar(20));
	else
		print N'Khách hàng '+@cN+' ('+@cName+') - ('+@ctLN +' : '+@phone+' : '+@country+N') đã thanh toán đủ!';
end

exec spBai35
exec spBai35 '119'

drop proc spBai35;

-- 3.6 Viết SP nhận vào productCode và in ra thông tin như sau:
-- Sản phẩm [productCode] thuộc nhóm [productLine] đã được mua bởi [số lượng đơn hàng] đơn hàng và [số lượng khách hàng không trùng lặp] khách hàng.
select * from products
select * from orderdetails where productCode = 'S10_1678'
select orderNumber from orderdetails where productCode = 'S10_1678'
select count(DISTINCT orderNumber) from orderdetails where productCode = 'S10_1678'
select * from orders o join orderdetails od on o.orderNumber=od.orderNumber where productCode = 'S10_1678' order by customerNumber
select count(DISTINCT customerNumber) from orders o join orderdetails od on o.orderNumber=od.orderNumber where productCode = 'S10_1678'

create proc spBai36 @pC varchar(20) = 'S10_1678'
as
begin
	declare @pL varchar(20), @orderCount int, @cusCount int;
	set @pL = (select productLine from products where productCode=@pC);

	select DISTINCT orderNumber from orderdetails where productCode=@pC;
	set @orderCount = @@ROWCOUNT;
	select DISTINCT customerNumber from orders o join orderdetails od on o.orderNumber=od.orderNumber where productCode=@pC;
	set @cusCount = @@ROWCOUNT;
	print N'Sản phẩm '+@pC+N' thuộc nhóm '+@pL+N' đã được mua bởi '+cast(@orderCount as varchar(10))+N' đơn hàng và '+cast(@cusCount as varchar(10))+N' khách hàng.';
end

drop proc spBai36
exec spBai36
exec spBai36 'S10_1949'
exec spBai36 'S18_4933'

/*
Part 4: Bài tập trên database khác
*/
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
--Câu 1: Viết procedure thực hiện các yêu cầu sau:
--Procedure prThemLop nhận vào @malop và @tenlop. Kiểm tra: 
--Mã lớp không được trùng. 
--Tên lớp không được trùng. 
--Nếu trùng thông báo cho người dùng, nếu không thực hiện việc thêm dữ liệu tương ứng vào bảng Lop và thông báo thành công.
create proc prThemLop @malop varchar(10), @tenlop nvarchar(20)
as
begin
	--Mã lớp không được trùng.
	if exists (select * from Lop where MaLop = @malop)
	begin
		print N'Mã lớp đã tồn tại!';
		return;
	end
	--Tên lớp không được trùng. 
	if exists (select * from Lop where TenLop = @tenlop)
	begin
		print N'Tên lớp đã tồn tại!';
		return;
	end
	--Dữ liệu input đã thỏa:
	insert into Lop values(@malop, @tenlop);
	print N'Thêm lớp ('+@malop+' ,'+@tenlop+N') thành công!';
	select * from Lop;
end

exec prThemLop 'DCT1231', N'CNTT Khóa 23 - Lớp 1'
exec prThemLop 'DCT1232', N'CNTT Khóa 23 - Lớp 1'
exec prThemLop 'DCT1232', N'CNTT Khóa 23 - Lớp 2'
exec prThemLop 'DCT1233', N'CNTT Khóa 23 - Lớp 3'

delete from Lop
drop proc prThemLop
go
--Câu 2: Procedure prThemSV nhận vào @masv, @hoten, @malop. Kiểm tra: 
--Mã sinh viên không được trùng, mã lớp phải hợp lệ (có trong bảng Lop), họ tên không được rỗng. 
--Nếu sai thông báo lỗi cho người dùng, ngược lại thêm dữ liệu vào bảng SV.
create proc prThemSV @masv varchar(10), @hoten nvarchar(20), @malop varchar(10)
as
begin
	if exists (select * from SV where MaSV=@masv)
	begin
		print N'Mã sinh viên '+@masv+N' đã tồn tại!';
		return;
	end
	if not exists (select * from Lop where MaLop = @malop)
	begin
		print N'Mã lớp '+@malop+' chưa có thông tin!';
		return;
	end
	if (@hoten = '' or @hoten is null)
	begin
		print N'Họ tên không được rỗng!';
		return;
	end
	--Dữ liệu đã hợp lệ, thực hiện việc thêm SV
	insert into SV values (@masv, @hoten, @malop);
	print N'Thêm SV '+@masv+' - '+@hoten+' thành công!';
	select * from SV;
end

exec prThemSV 'SV01', N'Nguyễn Văn An', 'DCT1231'
exec prThemSV 'SV02', N'Nguyễn Văn Bé', 'DCT1231'
exec prThemSV 'SV03', N'Trần Thị Nhỏ', 'DCT1234'
exec prThemSV 'SV03', N'Trần Thị Nhỏ', 'DCT1231'
exec prThemSV 'SV04', N'Hoàng Thị Hồng', 'DCT1232'
exec prThemSV 'SV05', N'Nguyễn Tiến Linh', 'DCT1232'
exec prThemSV 'SV06', N'Dương Anh Đức', 'DCT1232'
exec prThemSV 'SV07', N'Hồ Văn Huê', 'DCT1233'

drop proc prThemSV
--Câu 3: Procedure prThemDiem nhận vào @masv, @monthi, @diem. Kiểm tra: 
--Mã SV phải tồn tại bên bảng SV.
--Monthi không rỗng.
--Mã SV và Môn thi là duy nhất.
--Điểm thi là số >=0 và <=10.
create proc prThemDiem @masv varchar(10), @monthi nvarchar(20), @diem int
as
begin
	--Mã SV phải tồn tại bên bảng SV.
	if not exists (select * from SV where MaSV = @masv)
	begin
		print @masv+N' chưa có!';
		return;
	end
	--Monthi không rỗng.
	if (@monthi = '' or @monthi is null)
	begin
		print N'Tên môn thi không được rỗng!';
		return
	end
	--Mã SV và Môn thi là duy nhất.
	if exists (select * from KetQua where MaSV = @masv and MonThi = @monthi)
	begin
		print N'Đã nhập điểm môn '+@monthi+N' của sinh viên '+@masv;
		return
	end
	--Điểm thi là số >=0 và <=10.
	if (@diem <0 or @diem >10)
	begin
		print N'Điểm phải từ 0 đến 10';
		return;
	end
	--Dữ liệu hợp lệ, tiến hành thêm điểm cho SV
	insert into KetQua values (@masv, @monthi, @diem);
	print N'Thêm điểm môn '+@monthi+N' của sinh viên '+@masv+N' thành công';
	select * from KetQua
end

exec prThemDiem 'SV01', N'Toán', 9
exec prThemDiem 'SV01', N'', 9
exec prThemDiem 'SV01', N'Lý', 8
exec prThemDiem 'SV01', N'Hóa', 9
exec prThemDiem 'SV02', N'Toán', 5
exec prThemDiem 'SV02', null , 9
exec prThemDiem 'SV02', N'Lý', 6
exec prThemDiem 'SV02', N'Hóa', 7
exec prThemDiem 'SV03', N'Toán', 4
exec prThemDiem 'SV03', N'Lý', 4
exec prThemDiem 'SV03', N'Hóa', 4
exec prThemDiem 'SV04', N'Toán', 1
exec prThemDiem 'SV04', N'Lý', 1
exec prThemDiem 'SV04', N'Hóa', 1

drop proc prThemDiem

--Câu 4: Viết procedure prXoaLop nhận vào mã lớp cần xóa. Kiểm tra:
--Nếu mã lớp này không tồn tại thì thông báo.
--Nếu mã lớp tồn tại thực hiện việc xóa mã lớp đó (và các dữ liệu liên quan) rồi thông báo xóa thành công.
select * from Lop
select * from SV
select * from KetQua

create proc prXoaLop @malop varchar(10)
as
begin
	--Nếu mã lớp này không tồn tại thì thông báo.
	if not exists (select * from Lop where MaLop = @malop)
	begin
		print @malop +N' không tồn tại!';
		return;
	end
	--Nếu mã lớp tồn tại thực hiện việc xóa mã lớp đó (và các dữ liệu liên quan) rồi thông báo xóa thành công.
	--B1: Xóa KetQua của các sinh viên thuộc @malop
	delete from KetQua where MaSV in (select MaSV from SV where MaLop=@malop);
	--B2: Xóa các SV thuộc @malop
	delete from SV where MaLop=@malop;
	--B3: Xóa Lớp
	delete from Lop where MaLop=@malop;
	print N'Xóa '+@malop+N' thành công!';
	select * from Lop;
end

exec prXoaLop 'DCT1232'
exec prXoaLop 'DCT1233'
exec prXoaLop 'DCT1231'
drop proc prXoaLop 

--Câu 5: Viết procedure prSuaLop nhận vào @malop, @malopmoi. Kiểm tra:
--Kiểm tra các trường hợp lỗi liên quan đến mã lớp cũ và mới.
--Nếu @malop hợp lệ, thực hiện việc đổi mã lớp từ @malop sang @malopmoi trong bảng Lop và các dữ liệu liên quan rồi thông báo đổi mã lớp thành công.
create proc prSuaLop @malop varchar(10), @malopmoi varchar(10)
as
begin	
	--@malop phải tồn tại
	if not exists (select * from Lop where MaLop = @malop)
	begin
		print @malop+N' sai!';
		return;
	end
	--@malopmoi không được rỗng
	if (@malopmoi = '' or @malopmoi is null)
	begin
		print N'Mã lớp mới không được rỗng';
		return;
	end
	--Nếu @malop và @malopmoi giống nhau
	if(@malop = @malopmoi)
	begin
		print N'Mã lớp mới phải khác mã lớp cần sửa';
		return;
	end
	--Nếu mã lớp mới đã tồn tại
	if exists (select * from Lop where MaLop = @malopmoi)
	begin
		print N'Mã lớp mới đã tồn tại!';
		return;
	end
	/*
	--Cách 1: Dữ liệu đã hợp lệ, tiến hành sửa MaLop theo phương thức thêm mới Lop
	--B1: Thêm Lop mới với tên như cũ
	declare @tenlop nvarchar(20);
	set @tenlop = (select TenLop from Lop where MaLop =@malop);
	insert into Lop values (@malopmoi, @tenlop);
	--B2: Thay đổi MaLop của các sinh viên
	update SV set MaLop = @malopmoi where MaLop=@malop;
	--B3: Xóa Lớp cũ
	delete from Lop where MaLop=@malop;
	*/

	--Cách 2: Dữ liệu đã hợp lệ, tiến hành sửa MaLop theo phương thức gán khóa ngoại SV về null
	--B1: Gán null cho các SV thuộc lớp cần sửa (mã lớp cũ -> null)
	update SV set MaLop = null where MaLop=@malop;
	--B2: Đổi MaLop
	update Lop set MaLop = @malopmoi where MaLop = @malop;
	--B3: Gán MaLop cho các SV có MaLop là null
	update SV set MaLop = @malopmoi where MaLop is null;



	print N'Cập nhật MaLop thành công!';
	select * from Lop
end

exec prSuaLop 'DCT1231', 'DCT123C1'
exec prSuaLop 'DCT123C1', 'DCT123C1'
exec prSuaLop 'DCT123C1', 'DCT1232'
exec prSuaLop 'DCT123C1', 'DCT1231'

update Lop set MaLop = 'DCT123C1' where MaLop = 'DCT1231'
update SV set MaLop = null where MaLop='DCT1231';
update SV set MaLop = 'DCT123C1' where MaLop is null;
select * from Lop
select * from SV


drop proc prSuaLop