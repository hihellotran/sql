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
create proc spBai22 @ln nvarchar(20)
as
begin
	select * from customers where contactLastName = @ln;
end

exec spBai22 'Young'
exec spBai22 'Nelson'
-- 2.3 In ra danh sách các khách hàng chỉ có 1 dòng thông tin địa chỉ.
create proc spBai23
as
begin
	select * from customers where addressLine2 is null
end

exec spBai23
-- 2.4 In ra thông tin các văn phòng ở 'USA'.
create proc spBai24 @c nvarchar(20)
as
begin
	select * from offices where country = @c;
end

exec spBai24 'USA'
exec spBai24 'UK'
-- 2.5 In ra thông tin các nhân viên thuộc văn phòng ở thành phố 'San Francisco'.
create proc spBai25 @city nvarchar(20)
as
begin
	select * from employees e join offices o on e.officeCode = o.officeCode
	where city = @city;
end
exec spBai25 'San Francisco'
exec spBai25 'Boston'
-- 2.6 In ra thông tin các đơn hàng cùng với tổng giá trị đơn hàng đó.
select * from orderdetails
select * from orders
create proc spBai26
as
begin
	select o.orderNumber, SUM(quantityOrdered*priceEach) 'Order Value'
	from orders o join orderdetails od on o.orderNumber = od.orderNumber
	group by o.orderNumber
end

drop proc spBai26
exec spBai26

create proc spBai261 @n varchar(10)
as
begin
	declare @od datetime, @rd datetime, @sd datetime, @s varchar(50), @c varchar(100), @ov int;
	select @od = orderDate, @rd = requiredDate, @sd = shippedDate, @s = status, @c = comments
	from orders
	where orderNumber = @n;

	select @ov = SUM(quantityOrdered*priceEach)
	from orderdetails where orderNumber = @n
	group by orderNumber

	print 'Order Number: ' + @n;
	print 'Order Date: ' + cast(@od as varchar(50));
	print 'Required Date: ' + cast(@rd as varchar(50));
	print 'Shipped Date: ' + cast(@sd as varchar(50));
	print 'Status: ' + cast(@s as varchar(50));
	if(@c is null)
		print 'Comments: no comment'
	else
		print 'Comments: ' + cast(@c as varchar(50));
	print 'Order Value: ' + cast(@ov as varchar(50));
end

drop proc spBai261
exec spBai261 '10100'
exec spBai261 '10101'
select * from orders

-- 2.7 In ra thông tin khách hàng cùng với số lượng đơn hàng đã mua. -> 3.3

-- 2.8 In ra thông tin productLine chưa có sản phẩm nào

-- 2.9 In ra danh sách các sản phẩm có productCode không tương ứng với productScale (VD: sản phẩm có tỷ lệ 1:18 sẽ có mã bắt đầu bằng S18)

/*
Part 3: Stored Procedure có tham số đầu vào
*/
-- 3.1. Viết lại các Stored Procedure ở Part 2 nếu cần nhận tham số đầu vào là các thông tin tương ứng

-- 3.2 Viết stored procedure nhận vào @productLineName và @textDescription, thực hiện việc thêm mới 1 productLine với thông tin tương ứng, các dữ liệu khác mang giá trị NULL.

-- 3.3 Viết SP nhận tham số đầu vào là giá trị @customerNumber và in ra câu thông báo:
-- 'Khách hàng mã số @customerNumber (@customerName, @country) đã mua @sl đơn hàng!'

-- 3.4 Viết sp nhận vào mã nhân viên và in ra thông tin như sau:
-- [EmployeeNumber] ([firstName] [lastName]) ...
-- + Nếu nhân viên đó là quản lý: 1056 (Mary Patterson) có 4 nhân viên:1088 ,1102 ,1143 ,1621
-- + Nếu nhân viên đó không phải quản lý: 1076 (Jeff Firrelli) không có quản lý nhân viên nào!
-- Tham khảo thêm hàm STRING_AGG (T-SQL) hoặc GROUP_CONCAT (MySQL)

-- 3.5 Viết SP nhận vào mã khách hàng và in ra thông tin thanh toán của khách hàng như sau:
-- Khách hàng [customerNumber] ([customerName]) - ([contactLastName] : [phone] : [country]) ...
-- + Khách hàng 103 (Atelier graphique) - (Schmitt : 40.32.2555 : France) đã thanh toán đủ!
-- + Khách hàng 119 (La Rochelle Gifts) - (Labrune : 40.67.8555 : France) còn nợ: [số tiền nợ]

-- 3.6 Viết SP nhận vào productCode và in ra thông tin như sau:
-- Sản phẩm [productCode] thuộc nhóm [productLine] đã được mua bởi [số lượng đơn hàng] đơn hàng và [số lượng khách hàng không trùng lặp] khách hàng.

/*
Part 4: Bài tập trên database khác
*/

create database CacHeQTCSDL
go
use CacHeQTCSDL
go
--Tao bang
create table Lop
(
MaLop varchar(10) primary key,
TenLop varchar (20)
)
go
create table SV
(
MaSV varchar(10) primary key,
HoTen varchar(20),
MaLop varchar(10) foreign key references Lop (MaLop)
)
go
create table KetQua
(
MaSV varchar(10) foreign key references SV (MaSV),
MonThi varchar(10),
Diem int,
constraint pk_KetQua primary key (MaSV, MonThi)
)
go
create table TongKet
(
MaSV varchar(10),
TongDiem int,
GhiChu varchar(20)
)

--Câu 1: Viết procedure thực hiện các yêu cầu sau:
--Procedure prThemLop nhận vào @malop và @tenlop. Kiểm tra: 
--Mã lớp không được trùng. 
--Tên lớp không được trùng. 
--Nếu trùng thông báo cho người dùng, nếu không thực hiện việc thêm dữ liệu tương ứng vào bảng Lop và thông báo thành công.

--Câu 2: Procedure prThemSV nhận vào @masv, @hoten, @malop. Kiểm tra: 
--Mã sinh viên không được trùng, mã lớp phải hợp lệ (có trong bảng Lop), họ tên không được rỗng. 
--Nếu sai thông báo lỗi cho người dùng, ngược lại thêm dữ liệu vào bảng SV.

--Câu 3: Procedure prThemDiem nhận vào @masv, @monthi, @diem. Kiểm tra: 
--Mã SV phải tồn tại bên bảng SV.
--Monthi không rỗng.
--Mã SV và Môn thi là duy nhất.
--Điểm thi là số >=0 và <=10.

--Câu 4: Viết procedure prXoaLop nhận vào mã lớp cần xóa. Kiểm tra:
--Nếu mã lớp này không tồn tại thì thông báo.
--Nếu mã lớp tồn tại thực hiện việc xóa mã lớp đó (và các dữ liệu liên quan) rồi thông báo xóa thành công.

--Câu 5: Viết procedure prSuaLop nhận vào @malop, @malopmoi. Kiểm tra:
--Kiểm tra các trường hợp lỗi liên quan đến mã lớp cũ và mới.
--Nếu @malop hợp lệ, thực hiện việc đổi mã lớp từ @malop sang @malopmoi trong bảng Lop và các dữ liệu liên quan rồi thông báo đổi mã lớp thành công.