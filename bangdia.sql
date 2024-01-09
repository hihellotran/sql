create database bangdia
use bangdia
drop database bangdia


-- Bảng KHACHHANG
CREATE TABLE KHACHHANG (
    MAKH INT PRIMARY KEY,
    HOTEN VARCHAR(50),
    DIACHI VARCHAR(100),
    SODT VARCHAR(20),
    LOAIKH VARCHAR(20)
);

INSERT INTO KHACHHANG (MAKH, HOTEN, DIACHI, SODT, LOAIKH)
VALUES (1, 'Nguyen Van A', '123 ABC Street', '0123456789', 'VIP'),
       (2, 'Tran Thi B', '456 XYZ Street', '0987654321', 'Normal'),
       (3, 'Le Thi C', '789 DEF Street', '0123456789', 'Normal'),
       (4, 'Pham Van D', '987 GHI Street', '0987654321', 'VIP'),
       (5, 'Hoang Van E', '321 JKL Street', '0123456789', 'Normal');

-- Bảng PHIEUTHUE
CREATE TABLE PHIEUTHUE (
    MAPT INT PRIMARY KEY,
    MAKH INT,
    NGAYTHUE DATE,
    NGAYTRA DATE,
    SOLUONG INT,
    FOREIGN KEY (MAKH) REFERENCES KHACHHANG(MAKH)
);

INSERT INTO PHIEUTHUE (MAPT, MAKH, NGAYTHUE, NGAYTRA, SOLUONG)
VALUES (1, 1, '2023-01-01', '2023-01-05', 3),
       (2, 2, '2023-02-01', '2023-02-05', 2),
       (3, 3, '2023-03-01', '2023-03-05', 4),
       (4, 4, '2023-04-01', '2023-04-05', 1),
       (5, 5, '2023-05-01', '2023-05-05', 2);
insert into PHIEUTHUE values (6,1,'2023-02-01', '2023-01-05', 2 )


-- Bảng CHITIET_THUE
CREATE TABLE CHITIET_THUE (
    MAPT INT,
    MABD INT,
    PRIMARY KEY (MAPT, MABD),
    FOREIGN KEY (MAPT) REFERENCES PHIEUTHUE(MAPT),
    FOREIGN KEY (MABD) REFERENCES BANG_DIA(MABD)
);

INSERT INTO CHITIET_THUE (MAPT, MABD)
VALUES (1, 1),
       (1, 2),
       (2, 3),
       (3, 1),
       (3, 2);
insert into CHITIET_THUE values (1,1)


INSERT INTO CHITIET_THUE (MAPT, MABD)
VALUES(6,2)
-- Bảng BANG_DIA
CREATE TABLE BANG_DIA (
    MABD INT PRIMARY KEY,
    TENBD VARCHAR(50),
    THELOAI VARCHAR(50)
);

INSERT INTO BANG_DIA (MABD, TENBD, THELOAI)
VALUES (1, 'Movie 1', 'Action'),
       (2, 'Movie 2', 'Comedy'),
       (3, 'Movie 3', 'Drama'),
       (4, 'Movie 4', 'Thriller'),
       (5, 'Movie 5', 'Sci-Fi');






go
create proc SumBD @makh int 
as begin 
	declare @sl int
	select @sl = SUM(SOLUONG) from PHIEUTHUE pt where  PT.MAKH = @makh 
	if (@sl > 0)
	begin
		print(@sl)
		return
	end
	else
	begin 
		print(N'Khách hàng không thuê đĩa nào')
	    return 
	end
end 

drop proc SumBD
exec SumBD 2


go
CREATE PROCEDURE CountBangDiaDaThue
    @MAKH INT
AS
BEGIN
    DECLARE @SoLuongBangDia INT;

    SELECT @SoLuongBangDia = COUNT(CHITIET_THUE.MABD)
    FROM KHACHHANG
    JOIN PHIEUTHUE ON KHACHHANG.MAKH = PHIEUTHUE.MAKH
    JOIN CHITIET_THUE ON PHIEUTHUE.MAPT = CHITIET_THUE.MAPT
    WHERE KHACHHANG.MAKH = @MAKH;

    PRINT 'Tong so bang dia da thue: ' + CAST(@SoLuongBangDia AS VARCHAR);
END;

exec CountBangDiaDaThue 3


go

go
CREATE FUNCTION dbo.GetMostRentedCategory (
    @makh INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT TOP 1 KHACHHANG.MAKH, KHACHHANG.HOTEN, BANG_DIA.THELOAI
    FROM KHACHHANG
    INNER JOIN PHIEUTHUE ON KHACHHANG.MAKH = PHIEUTHUE.MAKH
    INNER JOIN CHITIET_THUE ON PHIEUTHUE.MAPT = CHITIET_THUE.MAPT
    INNER JOIN BANG_DIA ON CHITIET_THUE.MABD = BANG_DIA.MABD
    WHERE KHACHHANG.MAKH = @makh
    GROUP BY KHACHHANG.MAKH, KHACHHANG.HOTEN, BANG_DIA.THELOAI
    ORDER BY COUNT(*) DESC
);
select * from GetMostRentedCategory(1)


SELECT *

FROM dbo.GetMostRentedCategory(3);

go
create function caub (
	@makh int
	)
returns table 
as
return(
	select top 1 SUM(SOLUONG) as N'Số lượng', pt.MAKH, HOTEN ,THELOAI from BANG_DIA bd, CHITIET_THUE ct, PHIEUTHUE pt, KHACHHANG kh
	where bd.MABD = ct.MABD and pt.MAPT = ct.MAPT and kh.MAKH = pt.MAKH and pt.MAKH = @makh
	group by pt.MAKH ,HOTEN, THELOAI order by(SUM(SOLUONG)) desc
)



drop function caub

select * from dbo.caub(3)

create trigger soluong on CHITIET_THUE after insert, delete
as begin
	
end


