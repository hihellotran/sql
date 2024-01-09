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
    
    -- Ki?m tra m? ho� ��n (@mahd) c� h?p l? hay kh�ng.
    IF NOT EXISTS(SELECT * FROM HoaDon WHERE MaHD = @mahd)
    BEGIN
        print ('M? h�a ��n kh�ng h?p l?')
        RETURN
    END
    
    -- Ki?m tra gi� tr? s? l�?ng (@sl) c� h?p l? hay kh�ng.
    IF @sl <= 0
    BEGIN
        print ('S? l�?ng ph?i l?n h�n 0')
        RETURN
    END
    
    DECLARE @TonKho int
    -- L?y s? l�?ng t?n kho c?a s?n ph?m
    SELECT @TonKho = TonKho FROM SanPham WHERE MaSP = @masp
    
    -- Ki?m tra s? l�?ng t?n kho c?a s?n ph?m ��
    IF @sl > @TonKho
    BEGIN
        print('S? l�?ng mua v�?t qu� s? l�?ng t?n kho')
        RETURN
    END
    
    -- Ki?m tra xem s?n ph?m �? ��?c mua trong h�a ��n hay ch�a
    IF EXISTS(SELECT * FROM CTHD WHERE MaHD = @mahd AND MaSP = @masp)
    BEGIN
        print('S?n ph?m �? ��?c mua trong h�a ��n')
        RETURN
    END
    
    -- Th�m d? li?u v�o b?ng CTHD
    INSERT INTO CTHD(MaHD, MaSP, SoLuong, ThanhTien)
    VALUES(@mahd, @masp, @sl, NULL)
    
    -- L?y gi� tr? ��n gi� c?a s?n ph?m
    DECLARE @DonGia int
    SELECT @DonGia = DonGia FROM SanPham WHERE MaSP = @masp
    
    -- T�nh gi� tr? th�nh ti?n v� c?p nh?t l?i gi� tr? c?a c?t ThanhTien trong b?ng CTHD
    UPDATE CTHD SET ThanhTien = @sl * @DonGia WHERE MaHD = @mahd AND MaSP = @masp
    
    -- C?p nh?t s? l�?ng t?n kho c?a s?n ph?m
    UPDATE SanPham SET TonKho = TonKho - @sl WHERE MaSP = @masp
END



--C�u 2 
Create trigger tgcau2
on CTHD
AFTER INSERT 
AS
BEGIN
--C?p nh?t c?t th�nh ti?n theo ��ng c�ng th?c quy �?nh
	UPDATE CTHD
	SET ThanhTien = SoLuong * GiaBan

--C?p nh?t s? l�?ng t?n kho c?a s?n ph?m t��ng ?ng
	UPDATE SanPham
	SET SoLuongTon = SoLuongTon - inserted.SoLuong
	FROM SanPham
	INNER JOIN inserted ON SanPham.MaSP = inserted.MaSP

--Th�m d? li?u t��ng ?ng cho b?ng h�a ��n
	IF NOT EXISTS(SELECT * FROM HoaDon WHERE MaHD = inserted.MaHD)
	begin 
		--Th�m m?i h�a ��n n?u ch�a t?n t?i 
		INSERT INTO HoaDon(MaHD, NgayLap, TongTien)
		SELECT inserted.MaHD, GETDATE(), inserted.ThanhTien 
		from inserted
	end
	else
	begin 
		--C?p nh?t t?ng ti?n c?a h�a ��n n?u �? t?n t?i
		UPDATE HoaDon
		SET TongTien = TongTien + inserted.ThanhTien
		from HoaDon
		inner join inserted on HoaDon.MaHD = inserted.MaHD
	end
end
