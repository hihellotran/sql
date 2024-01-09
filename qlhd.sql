
drop database qlhd
create database qlhd
use qlhd


CREATE TABLE SanPham (
    MaSP nvarchar(10) PRIMARY KEY,
    TenSP nvarchar(20),
    DonGia int,
    TonKho int
);

CREATE TABLE HoaDon (
    MaHD nvarchar(10) PRIMARY KEY,
    Ngay datetime,
    TongTien int
);


CREATE TABLE CTHD (
    MaHD nvarchar(10),
    MaSP nvarchar(10),
    SoLuong int,
    ThanhTien int,
    PRIMARY KEY (MaHD, MaSP),
    FOREIGN KEY (MaHD) REFERENCES HoaDon(MaHD),
    FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)
);

INSERT INTO SanPham (MaSP, TenSP, DonGia, TonKho) VALUES 
('SP001', 'Sản phẩm 1', 100000, 50),
('SP002', 'Sản phẩm 2', 200000, 30),
('SP003', 'Sản phẩm 3', 150000, 20),
('SP004', 'Sản phẩm 4', 180000, 10);

INSERT INTO HoaDon (MaHD, Ngay, TongTien) VALUES
('HD001', '2022-04-01', 250000),
('HD002', '2022-04-02', 180000),
('HD003', '2022-04-03', 300000);

INSERT INTO CTHD (MaHD, MaSP, SoLuong, ThanhTien) VALUES
('HD001', 'SP001', 2, 220000),
('HD001', 'SP002', 1, 200000),
('HD002', 'SP003', 3, 535500),
('HD003', 'SP001', 1, 110000),
('HD003', 'SP002', 2, 400000),
('HD003', 'SP004', 1, 205200);
