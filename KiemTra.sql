Create database CacHeQTCSDL
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


CREATE PROCEDURE prCau1
    @mahd nvarchar(10),
    @masp nvarchar(10),
    @sl int
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Ki?m tra m? hoá ðõn (@mahd) có h?p l? hay không.
    IF NOT EXISTS(SELECT * FROM HoaDon WHERE MaHD = @mahd)
    BEGIN
        print ('M? hóa ðõn không h?p l?')
        RETURN
    END
    
    -- Ki?m tra giá tr? s? lý?ng (@sl) có h?p l? hay không.
    IF @sl <= 0
    BEGIN
        print ('S? lý?ng ph?i l?n hõn 0')
        RETURN
    END
    
    DECLARE @TonKho int
    -- L?y s? lý?ng t?n kho c?a s?n ph?m
    SELECT @TonKho = TonKho FROM SanPham WHERE MaSP = @masp
    
    -- Ki?m tra s? lý?ng t?n kho c?a s?n ph?m ðó
    IF @sl > @TonKho
    BEGIN
        print('S? lý?ng mua vý?t quá s? lý?ng t?n kho')
        RETURN
    END
    
    -- Ki?m tra xem s?n ph?m ð? ðý?c mua trong hóa ðõn hay chýa
    IF EXISTS(SELECT * FROM CTHD WHERE MaHD = @mahd AND MaSP = @masp)
    BEGIN
        print('S?n ph?m ð? ðý?c mua trong hóa ðõn')
        RETURN
    END
    
    -- Thêm d? li?u vào b?ng CTHD
    INSERT INTO CTHD(MaHD, MaSP, SoLuong, ThanhTien)
    VALUES(@mahd, @masp, @sl, NULL)
    
    -- L?y giá tr? ðõn giá c?a s?n ph?m
    DECLARE @DonGia int
    SELECT @DonGia = DonGia FROM SanPham WHERE MaSP = @masp
    
    -- Tính giá tr? thành ti?n và c?p nh?t l?i giá tr? c?a c?t ThanhTien trong b?ng CTHD
    UPDATE CTHD SET ThanhTien = @sl * @DonGia WHERE MaHD = @mahd AND MaSP = @masp
    
    -- C?p nh?t s? lý?ng t?n kho c?a s?n ph?m
    UPDATE SanPham SET TonKho = TonKho - @sl WHERE MaSP = @masp
END



--Câu 2 
Create trigger tgcau2
on CTHD
AFTER INSERT 
AS
BEGIN
--C?p nh?t c?t thành ti?n theo ðúng công th?c quy ð?nh
	UPDATE CTHD
	SET ThanhTien = SoLuong * GiaBan

--C?p nh?t s? lý?ng t?n kho c?a s?n ph?m týõng ?ng
	UPDATE SanPham
	SET SoLuongTon = SoLuongTon - inserted.SoLuong
	FROM SanPham
	INNER JOIN inserted ON SanPham.MaSP = inserted.MaSP

--Thêm d? li?u týõng ?ng cho b?ng hóa ðõn
	IF NOT EXISTS(SELECT * FROM HoaDon WHERE MaHD = inserted.MaHD)
	begin 
		--Thêm m?i hóa ðõn n?u chýa t?n t?i 
		INSERT INTO HoaDon(MaHD, NgayLap, TongTien)
		SELECT inserted.MaHD, GETDATE(), inserted.ThanhTien 
		from inserted
	end
	else
	begin 
		--C?p nh?t t?ng ti?n c?a hóa ðõn n?u ð? t?n t?i
		UPDATE HoaDon
		SET TongTien = TongTien + inserted.ThanhTien
		from HoaDon
		inner join inserted on HoaDon.MaHD = inserted.MaHD
	end
end
