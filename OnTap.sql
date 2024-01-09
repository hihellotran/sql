/*
CREATE PROCEDURE prCau1
    @mahd nvarchar(10),
    @masp nvarchar(10),
    @sl int
AS
BEGIN
    -- Kiểm tra mã hóa đơn có hợp lệ hay không
    IF NOT EXISTS(SELECT * FROM HoaDon WHERE MaHD = @mahd)
    BEGIN
        PRINT N'Mã hóa đơn không hợp lệ'
        RETURN
    END
    
    -- Kiểm tra số lượng có hợp lệ hay không
    IF @sl <= 0 
        OR @sl > (SELECT TonKho FROM SanPham WHERE MaSP = @masp)
    BEGIN
        PRINT N'Số lượng không hợp lệ'
        RETURN
    END
    
    -- Kiểm tra sản phẩm đã được mua trong hóa đơn hay chưa
    IF EXISTS(SELECT * FROM CTHD WHERE MaHD = @mahd AND MaSP = @masp)
    BEGIN
        PRINT N'Sản phẩm đã được mua trong hóa đơn'
        RETURN
    END
    
    -- Thêm sản phẩm vào bảng CTHD
    INSERT INTO CTHD (MaHD, MaSP, SoLuong, ThanhTien)
    SELECT @mahd, @masp, @sl, NULL
    
    -- Cập nhật số lượng sản phẩm trong bảng SanPham
    UPDATE SanPham SET TonKho = TonKho - @sl WHERE MaSP = @masp
    
END

DROP PROCEDURE prCau1;*/

create proc Cau1
	@mahd nvarchar(10),
	@masp nvarchar(10),
	@sl int
as
begin 
	if not exists(select * from HoaDon where MaHD = @mahd)
	begin
	print N'mã hóa đơn không hợp lệ'
	return
	end
	if @sl>=0 and @sl>=(select TonKho from SanPham where MaSP = @masp)
	begin
	print N'số lượng không hợp lệ'
	return 
	end
	if  exists (select * from CTHD, SanPham where CTHD.MaSP = SanPham.MaSP and CTHD.MaHD = @mahd)
	begin 
	print N'hóa đơn đã mua sản phẩm'
	end

	insert into CTHD values (@mahd, @masp, @sl, null)
	update SanPham set TonKho = TonKho - @sl where SanPham.MaSP = @masp

end

exec Cau1 'HD004','SP001', '5'

select * from CTHD