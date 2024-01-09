create database kt
use kt

-- Tạo bảng THANHVIEN
CREATE TABLE THANHVIEN (
    matv VARCHAR(10) PRIMARY KEY,
    hoten NVARCHAR(50),
    ngaysinh DATETIME,
    tongDiem FLOAT,
    hangtv VARCHAR(10)
);

-- Tạo bảng DONHANG
CREATE TABLE DONHANG (
    madh INT PRIMARY KEY,
    matv VARCHAR(10),
    tongtien INT,
    diemtichluy FLOAT,
    ngaydh DATETIME,
    FOREIGN KEY (Matv) REFERENCES THANHVIEN(Matv)
);

INSERT INTO THANHVIEN (matv, hoten, ngaysinh, tongDiem, hangtv)
VALUES ('TV001', 'Nguyễn Văn A', '1990-01-01', 100.5, 'Hang1'),
('TV002', 'Trần Thị B', '1995-05-10', 75.2, 'Hang2'),
('TV003', 'Lê Minh C', '1988-12-20', 120.7, 'Hang1');


INSERT INTO DONHANG (madh, matv, tongtien, diemtichluy, ngaydh)
VALUES (1, 'TV001', 500000, 50.5, '2023-05-01 10:30:00'),
(2, 'TV001', 750000, 75.0, '2023-05-10 14:20:00'),
(3, 'TV002', 300000, 30.0, '2023-05-12 09:45:00');

go
CREATE PROCEDURE ThemDonHang
    @matv VARCHAR(10),
    @tongtien INT
AS
BEGIN
    DECLARE @madh INT;
    DECLARE @dtl FLOAT;
    DECLARE @ngaygio DATETIME;

    IF NOT EXISTS (SELECT * FROM THANHVIEN WHERE matv = @matv)
    BEGIN
        PRINT(N'Mã thành viên không tồn tại');
        RETURN;
    END;

    IF EXISTS (SELECT madh FROM DONHANG)
    BEGIN
        SET @madh = (SELECT MAX(madh) + 1 FROM DONHANG);
    END;
    ELSE
    BEGIN
        SET @madh = 1;
    END;

    SET @dtl = @tongtien / 10000.0;
    SET @ngaygio = GETDATE();

    -- Thêm dòng vào bảng DONHANG
    INSERT INTO DONHANG (madh, matv, tongtien, diemtichluy, ngaydh)
    VALUES (@madh, @matv, @tongtien, @dtl, @ngaygio);
END;

EXEC ThemDonHang @matv = 'TV003', @tongtien = 250000;

select * from DONHANG
select * from THANHVIEN

go
CREATE TRIGGER tgDonHang ON DONHANG
AFTER INSERT 
AS
BEGIN
	DECLARE @matv VARCHAR(10), 
	@tongdiem FLOAT,
	@diemtichluy FLOAT,
	@diemcapnhat FLOAT,
	@hangtv varchar(10)
	SELECT @matv = matv FROM inserted;
	SELECT @tongdiem = tongDiem FROM THANHVIEN WHERE matv = @matv;
	SELECT @diemtichluy = diemtichluy FROM inserted;
	SET @diemcapnhat = @tongdiem + @diemtichluy;
	UPDATE THANHVIEN SET tongDiem = @diemcapnhat WHERE matv = @matv;

	select @hangtv = hangtv from THANHVIEN where @matv = matv
	if(@tongdiem < 50)
	begin
		set @hangtv = 'green';
	end

	if(@tongdiem >=50 and @tongdiem < 100 )
	begin
		set @hangtv = 'silver';
	end
	if(@tongdiem>=100 and @tongdiem <500)
	begin
		set @hangtv = 'gold';
	end

	if(@tongdiem >= 500)
	begin
		set @hangtv = 'diamond'
	end

	update THANHVIEN set hangtv = @hangtv where matv = @matv;
END


drop trigger tgDonHang

insert into DONHANG (madh, matv, tongtien, diemtichluy, ngaydh) values ('6', 'TV002', 98000, 400, '2023-06-10')
delete DONHANG where madh = 6

select * from DONHANG

select * from THANHVIEN




