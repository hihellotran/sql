create database clb
use clb

CREATE TABLE DOIBONG (
    MaDoi VARCHAR(10) PRIMARY KEY,
    TenDoi VARCHAR(100),
    NamTL INT
);

CREATE TABLE CAUTHU (
    MaCauThu VARCHAR(10) PRIMARY KEY,
    TenCauThu VARCHAR(50),
    Phai BIT,
    NgaySinh DATETIME,
    NoiSinh VARCHAR(50)
);

CREATE TABLE CT_DB (
    MaDoi VARCHAR(10),
    MaCauThu VARCHAR(10),
    NgayVaoCLB DATETIME,
    PRIMARY KEY (MaDoi, MaCauThu),
    FOREIGN KEY (MaDoi) REFERENCES DOIBONG(MaDoi),
    FOREIGN KEY (MaCauThu) REFERENCES CAUTHU(MaCauThu)
);

CREATE TABLE PENELTY (
    MaPhat VARCHAR(10),
    MaCT VARCHAR(10),
    TienPhat NUMERIC,
    LoaiThe VARCHAR(10),
    NgayPhat DATETIME,
    PRIMARY KEY (MaPhat),
    FOREIGN KEY (MaCT) REFERENCES CAUTHU(MaCauThu)
);


INSERT INTO DOIBONG (MaDoi, TenDoi, NamTL)
VALUES
    ('DB01', 'Arsenal', 1886),
    ('DB02', 'Chelsea', 1905),
    ('DB03', 'Manchester United', 1878),
    ('DB04', 'Liverpool', 1892);

INSERT INTO CAUTHU (MaCauThu, TenCauThu, Phai, NgaySinh, NoiSinh)
VALUES
    ('CT01', 'Cristiano Ronaldo', 1, '1985-02-05', 'Madeira, Portugal'),
    ('CT02', 'Lionel Messi', 1, '1987-06-24', 'Rosario, Argentina'),
    ('CT03', 'Neymar', 1, '1992-02-05', 'Mogi das Cruzes, Brazil'),
    ('CT04', 'Marta', 0, '1986-02-19', 'Dois Riachos, Brazil');

INSERT INTO CT_DB (MaDoi, MaCauThu, NgayVaoCLB)
VALUES
    ('DB01', 'CT01', '2003-08-01'),
    ('DB02', 'CT02', '2004-09-01'),
    ('DB03', 'CT03', '2013-06-03'),
    ('DB04', 'CT04', '2003-07-01');

INSERT INTO PENELTY (MaPhat, MaCT, TienPhat, LoaiThe, NgayPhat)
VALUES
    ('P01', 'CT01', 500000, 'R', '2022-03-01'),
    ('P02', 'CT02', 300000, 'Y', '2022-05-10'),
    ('P03', 'CT03', 1000000, 'R', '2022-01-15'),
    ('P04', 'CT04', 200000, 'Y', '2022-06-20');

go
create proc cau1 
   @namTL int,
   @TienPhat numeric(18,0),
   @MaDoi varchar(10),
   @MaCT varchar(10)
as
begin 
	if (@namTL <1800 or @namTL > YEAR(GETDATE()))
	begin
		print(N'Năm thành lập không hợp lệ')
		return
	end
    
	if(@TienPhat <=0)
	begin
		print(N'Tiền phạt không hợp lệ')
	end
			
	if not exists (select * from CT_DB where MaCauThu = @MaCT and MaDoi = @MaDoi)
	begin
		print(N'Cầu thủ không thuộc đội này')
		return 
	end
end

