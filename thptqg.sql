CREATE DATABASE THPTQG

USE THPTQG

CREATE TABLE TRUONG (
    MATRUONG INT PRIMARY KEY,
    TENTRUONG NVARCHAR(50)
);

CREATE TABLE THISINH (
    SOBD INT PRIMARY KEY,
    HOTEN NVARCHAR(50),
    NGAYSINH DATE,
    NOISINH NVARCHAR(50),
    NAMDUTHI INT,
    MATRUONG INT,
    FOREIGN KEY (MATRUONG) REFERENCES TRUONG(MATRUONG)
);

CREATE TABLE MONTHI (
    MAMT INT PRIMARY KEY,
    TENMT NVARCHAR(50)
);

CREATE TABLE KETQUA (
    SOBD INT,
    MAMT INT,
    DIEM FLOAT,
    GHICHU NVARCHAR(100),
    PRIMARY KEY (SOBD, MAMT),
    FOREIGN KEY (SOBD) REFERENCES THISINH(SOBD),
    FOREIGN KEY (MAMT) REFERENCES MONTHI(MAMT)
);



INSERT INTO TRUONG (MATRUONG, TENTRUONG)
VALUES (1, 'Trường A'),
       (2, 'Trường B'),
       (3, 'Trường C');


INSERT INTO THISINH (SOBD, HOTEN, NGAYSINH, NOISINH, NAMDUTHI, MATRUONG)
VALUES (1, 'Nguyễn Văn A', '2000-01-01', 'Hà Nội', 2023, 1),
       (2, 'Trần Thị B', '2001-02-02', 'Hải Phòng', 2023, 2),
       (3, 'Lê Minh C', '2002-03-03', 'Đà Nẵng', 2023, 1);

INSERT INTO MONTHI (MAMT, TENMT)
VALUES (1, 'Môn A'),
       (2, 'Môn B'),
       (3, 'Môn C');


INSERT INTO KETQUA (SOBD, MAMT, DIEM, GHICHU)
VALUES (1, 1, 8.5, 'Đạt'),
       (1, 2, 7.2, 'Chưa đạt'),
       (2, 1, 9.0, 'Đạt'),
       (2, 2, 8.8, 'Đạt'),
       (3, 3, 7.9, 'Chưa đạt');

select * from THISINH

insert into THISINH values(4,N'Nguyễn Thị Mỹ Duyên','2001-05-05',N'Hồ Chí Minh',2023, 3)
insert into THISINH values(5,N'Trần Mỹ Kim','2001-06-07',N'Hồ Chí Minh',2023, 2)
insert into THISINH values(6,N'Lê Lan Anh','2001-10-11',N'Hồ Chí Minh',2023, 2)
insert into KETQUA values(4,1,6.5,N'Đạt')

insert into KETQUA values(5,2,1,N'Rớt')

insert into KETQUA values(6,3,0,N'Rớt')
select* from KETQUA


go
create proc dem_ts @matruong int 
as
begin 
	declare @dem int
	set @dem =(select COUNT(SOBD) from THISINH where MATRUONG = @matruong group by(MATRUONG))
	if @dem > 0
	begin
		print(@dem)
		return
	end

	else
	begin
		print(N'Không có thí sinh nào trong trường này')
		return
	end
end

select * from THISINH

exec dem_ts '4'
go
CREATE FUNCTION diem_liet
(
	@matruong INT
)
RETURNS nvarchar(max)
AS
BEGIN 
	DECLARE @rs nvarchar(max)
	SELECT @rs = CONCAT(N'Trường ', TENTRUONG, N': Số thí sinh bị điểm liệt ', COUNT(kq.SOBD))
	FROM TRUONG t
	JOIN THISINH ts ON t.MATRUONG = ts.MATRUONG 
	JOIN KETQUA kq ON ts.SOBD = kq.SOBD 
	WHERE kq.DIEM <= 1 AND t.MATRUONG = @matruong
	GROUP BY TENTRUONG
	RETURN @rs
END

drop function diem_liet
DECLARE @result nvarchar(max)
SET @result = dbo.diem_liet(2) -- Truyền mã trường vào đây
PRINT @result


/*CREATE FUNCTION diem_liet
(
	@matruong INT
)
RETURNS TABLE
AS
RETURN
(
	SELECT TENTRUONG, COUNT(kq.SOBD) AS SoThiSinhDiemLiet
	FROM TRUONG t, THISINH ts, KETQUA kq
	WHERE t.MATRUONG = ts.MATRUONG AND ts.SOBD = kq.SOBD 
		AND kq.DIEM <= 1 AND t.MATRUONG = @matruong
	GROUP BY t.TENTRUONG
); */


select * from THISINH
select * from KETQUA
go
CREATE TRIGGER dieu_kien ON THISINH AFTER INSERT, UPDATE
AS
BEGIN
	DECLARE @sobd NVARCHAR(50),
		@tuoi NVARCHAR(50),
		@nam NVARCHAR(50)

	SELECT @sobd = CAST(SOBD AS NVARCHAR(50)) FROM inserted
	SELECT @tuoi = CAST(NGAYSINH AS NVARCHAR(50)) FROM inserted
	SELECT @nam = CAST(NAMDUTHI AS NVARCHAR(50)) FROM inserted

	IF (YEAR(GETDATE()) - YEAR(CAST(@tuoi AS DATETIME))) < 18
	BEGIN
		PRINT(N'Phải trên 18 tuổi mới được thi')
		rollback tran
	END

	IF YEAR(GETDATE()) != CAST(@nam AS INT)
	BEGIN
		PRINT(N'Năm thi không được khác năm hiện tại')
		rollback tran
	END
END
drop trigger dieu_kien
select * from THISINH

insert into THISINH values (8, 'Trương Phú Mỹ', '2008-01-10', 'HCM', '2024', 2)
delete THISINH where SOBD = 7

go
create trigger diem on KETQUA after insert, update
as begin
	declare @diem_thi float, @ghichu nvarchar(100)
	select @diem_thi = DIEM from inserted
	select @ghichu = GHICHU from KETQUA


	if(@diem_thi<0 or @diem_thi>10)
	begin
		print(N'Điểm thi không hợp lệ')
		rollback tran
	end

	if(@diem_thi = 0)
	begin 
		set @ghichu = N'Vắng thi'
	end
	update KETQUA set GHICHU = @ghichu  WHERE SOBD IN (SELECT SOBD FROM inserted WHERE DIEM = 0) 
            AND MAMT IN (SELECT MAMT FROM inserted WHERE DIEM = 0);
end

select * from KETQUA
drop trigger diem

insert into KETQUA values (6,1,10,N'Qua')
delete from KETQUA where SOBD = '6'