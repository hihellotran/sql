/*
Part 1: Stored Procedure đơn giản, không truy xuất dữ liệu
*/
-- 1.1. Viết stored-procedure in ra dòng:
-- Xin chào + @ten.
-- *Chú ý: với @ten là tham số đầu vào là họ tên của bạn (viết tiếng việt).
go 
create proc hi @name nvarchar(30)
as
begin 
	Select N'Xin chào' + @name
end;

exec hi N'Trân'

-- 1.2. Viết stored-procedure tính tổng 2 số a, b và in kết quả theo định dạng sau:
-- ‘Tổng 2 số’ + @a + ‘và’ + @b ‘là:’ + @kq
go
create proc tong @a int, @b int
as
begin
	select  @a + @b
end;

exec tong 5, 25

-- 1.3. Viết stored-procedure tính tích 2 số a, b và in kết quả theo định dạng sau:
-- ‘Tích 2 số’ + @a + ‘và’ + @b ‘là:’ + @kq

-- 1.4. Viết stored-procedure tính thương 2 số a, b và in kết quả theo định dạng sau:
-- ‘Thương 2 số’ + @a + ‘và’ + @b ‘là:’ + @kq

-- 1.5. Viết stored-procedure tìm số lớn nhất trong 3 số a, b, c và in kết quả theo định dạng sau:
-- ‘Số lớn nhất trong 3 số’ + @a + @b + ‘và’ + @c ‘là:’ + @kq

-- 1.6. Viết stored-procedure tìm số nhỏ nhất trong 3 số a, b, c và in kết quả theo định dạng sau:
-- ‘Số nhỏ nhất trong 3 số’ + @a + @b + ‘và’ + @c ‘là:’ + @kq

-- 1.7. Viết stored-procedure truyền vào số nguyên n in ra số lượng số chẳn và tổng các số chẳn.

-- 1.8. Viết stored-procedure truyền vào 2 số nguyên, tìm ước chung lớn nhất của 2 số nguyên trên.

-- 1.9. Viết stored-procedure truyền vào n, tính tổng các số nguyên thuộc [1, n]

-- 1.10. Viết stored-procedure truyền vào n tính tổng các số chính phương thuộc [1,n].

/*
Part 2: Stored Procedure không có tham số đầu vào
*/
use classicmodels

select * from productlines
select * from employees
select * from customers
select * from offices
select * from orders
select * from orderdetails

-- 2.1 In ra danh sách các sản phẩm tỷ lệ 1:18

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