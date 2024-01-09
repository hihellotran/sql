create database thuvien
use thuvien

CREATE TABLE DAUSACH (
    MADS VARCHAR(10) PRIMARY KEY,
    TENDS NVARCHAR(100),
    TACGIA NVARCHAR(100),
    NHAXB NVARCHAR(100)
);


CREATE TABLE SACH (
    MAS VARCHAR(10) PRIMARY KEY,
    TENSACH NVARCHAR(100),
    NGAYNHAP DATE,
    TINHTRANG NVARCHAR(50),
    MADS VARCHAR(10) REFERENCES DAUSACH(MADS)
);


CREATE TABLE DOCGIA (
    MADG VARCHAR(10) PRIMARY KEY,
    TENDG NVARCHAR(100),
    NGAYSINH DATE,
    DIACHI NVARCHAR(200),
    DIENTHOAI VARCHAR(20)
);


CREATE TABLE PHIEUMUON (
    SOPM INT PRIMARY KEY,
    NGAYMUON DATE,
    MADG VARCHAR(10) REFERENCES DOCGIA(MADG)
);


CREATE TABLE CT_PHIEUMUON (
    SOPM INT REFERENCES PHIEUMUON(SOPM),
    MAS VARCHAR(10) REFERENCES SACH(MAS),
    PRIMARY KEY (SOPM, MAS)
);


CREATE TABLE PHIEUTRA (
    SOPT INT PRIMARY KEY,
    NGAYTRA DATE,
    SOPM INT REFERENCES PHIEUMUON(SOPM)
);



INSERT INTO DAUSACH (MADS, TENDS, TACGIA, NHAXB)
VALUES ('DS001', N'Sách 1', N'Tác giả 1', N'Nhà xuất bản 1'),
       ('DS002', N'Sách 2', N'Tác giả 2', N'Nhà xuất bản 2'),
       ('DS003', N'Sách 3', N'Tác giả 3', N'Nhà xuất bản 3'),
       ('DS004', N'Sách 4', N'Tác giả 4', N'Nhà xuất bản 4'),
       ('DS005', N'Sách 5', N'Tác giả 5', N'Nhà xuất bản 5');


INSERT INTO SACH (MAS, TENSACH, NGAYNHAP, TINHTRANG, MADS)
VALUES ('S001', N'Sách 1', '2023-01-01', N'Mới', 'DS001'),
       ('S002', N'Sách 2', '2023-02-01', N'Mới', 'DS002'),
       ('S003', N'Sách 3', '2023-03-01', N'Cũ', 'DS001'),
       ('S004', N'Sách 4', '2023-04-01', N'Hỏng', 'DS003'),
       ('S005', N'Sách 5', '2023-05-01', N'Mới', 'DS002');


INSERT INTO DOCGIA (MADG, TENDG, NGAYSINH, DIACHI, DIENTHOAI)
VALUES ('DG001', N'Độc giả 1', '1990-01-01', N'Địa chỉ 1', '0123456789'),
       ('DG002', N'Độc giả 2', '1995-02-02', N'Địa chỉ 2', '0123456789'),
       ('DG003', N'Độc giả 3', '2000-03-03', N'Địa chỉ 3', '0123456789'),
       ('DG004', N'Độc giả 4', '1985-04-04', N'Địa chỉ 4', '0123456789'),
       ('DG005', N'Độc giả 5', '1992-05-05', N'Địa chỉ 5', '0123456789');


INSERT INTO PHIEUMUON (SOPM, NGAYMUON, MADG)
VALUES (1, '2023-01-01', 'DG001'),
       (2, '2023-02-01', 'DG002'),
       (3, '2023-03-01', 'DG001'),
       (4, '2023-04-01', 'DG003'),
       (5, '2023-05-01', 'DG002');

INSERT INTO CT_PHIEUMUON (SOPM, MAS)
VALUES (1, 'S001'),
       (1, 'S002'),
       (2, 'S003'),
       (3, 'S002'),
       (4, 'S004');


-- Thêm dữ liệu vào bảng PHIEUTRA
INSERT INTO PHIEUTRA (SOPT, NGAYTRA, SOPM)
VALUES (1, '2023-02-01', 1),
       (2, '2023-03-01', 2),
       (3, '2023-04-01', 3),
       (4, '2023-05-01', 4),
       (5, '2023-06-01', 5);

go
create proc pm @sopm int
as
begin
	declare @tong int;
	set @tong = (select COUNT(*) from SACH s, PHIEUMUON p, CT_PHIEUMUON ct 
	where s.MAS = ct.MAS and p.SOPM = ct.SOPM and p.SOPM = @sopm)
	if (@tong = 0)
	begin
		print(N'Không có sách nào được mượn')
		return
	end
	else 
	begin
		 PRINT(CONVERT(NVARCHAR, @tong));
	return
	end
end


exec pm 5



go
create proc them_sach @ma varchar(10), @ten nvarchar(100), 
					@tt nvarchar(50), @mads varchar(10)
as
begin
	declare @ngay datetime
	if exists(select * from SACH where MAS = @ma)
	begin
		print(N'Mã sách này đã tồn tại')
		return 
	end


	if not exists(select * from DAUSACH where MADS = @mads )
	begin
		print(N'Mã đầu sách không tồn tại')
		return
	end

	set @ngay = GETDATE();

	insert into SACH (MAS, TENSACH, NGAYNHAP, TINHTRANG, MADS )
	values (@ma, @ten, @ngay, @tt, @mads)
end

drop proc them_sach
exec them_sach 'S007', 'Sách 7', N'Mới', 'DS005'

select * from SACH
select * from DAUSACH

go


drop trigger tra_sach


select * from PHIEUTRA
select * from PHIEUMUON
select * from CT_PHIEUMUON



declare @ngaymuon datetime
select @ngaymuon = ngaymuon from PHIEUMUON where sopm=2

declare @ngaytra datetime
select @ngaytra = GETDATE()

if @ngaymuon > @ngaytra 
	print(N'Lỗi')





--Bước  1 : Mượn sách a số phiếu mượn mã số x 
--Bước 2 : đi trả sách a 

-- Tạo trigger khi thêm	vào bảng phiếu trả (sopt, ngaytra, sopm)
-- Kiếm tra ngày trả > ngày mượn (ngày mượn của phiếu mượn có số phiếu mượn bằng giá trị được thêm vào bảng phiếu trả)

go
create trigger tra_sach on PHIEUTRA
after insert 
as begin 
	declare @ngaytra datetime, @ngaymuon datetime
	set @ngaytra = (select NGAYTRA from inserted)
	set @ngaymuon = (select NGAYMUON from PHIEUMUON where SOPM = (select SOPM from inserted))
	if(@ngaymuon > @ngaytra)
	begin
		print(N'Ngày mượn phải sau ngày trả')
		rollback tran
	end
end

insert into PHIEUTRA  values(9,'2020-06-01',2)