CREATE DATABASE Apotek_Cemara
ON PRIMARY
   (NAME = 'Apotek_Cemara', 
    FILENAME = 'D:\DATABASE APOTEK CEMARA\Apotek_Cemara.mdf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 10MB)
LOG ON
   (NAME = 'Apotek_Cemara_Log', 
    FILENAME = 'D:\DATABASE APOTEK CEMARA\Apotek_Cemara_log.ldf',
    SIZE = 25MB,
    MAXSIZE = 50MB,
    FILEGROWTH = 5MB);
GO

Use Apotek_Cemara

CREATE TABLE Pegawai (
  ID_Pegawai CHAR(5) PRIMARY KEY,
  Nama_Pegawai VARCHAR(50) NOT NULL,
  Jenis_Kelamin CHAR(1) NOT NULL CHECK(Jenis_Kelamin IN ('L', 'P')),
  Alamat_Pegawai VARCHAR(50) NOT NULL,
  No_Telp_Pegawai char(12) NOT NULL
);

CREATE TABLE Pembeli (
  ID_Pembeli CHAR(5) PRIMARY KEY,
  Nama_Pembeli VARCHAR(50) NOT NULL,
  Jenis_Kelamin CHAR(1) NOT NULL CHECK(Jenis_Kelamin IN ('L', 'P')),
  Alamat_Pembeli VARCHAR(50),
  No_Telp_Pembeli CHAR(12) NOT NULL
);

CREATE TABLE Obat (
  ID_Obat CHAR(5) PRIMARY KEY,
  Nama_Obat VARCHAR(50) NOT NULL,
  Jenis_Obat VARCHAR(50) NOT NULL,
  Harga_Obat MONEY NOT NULL,
  ID_Supplier CHAR(5) NOT NULL,
  FOREIGN KEY (ID_Supplier) REFERENCES Supplier(ID_Supplier)
);

CREATE TABLE Stok_Obat (
ID_StokObat CHAR(5) PRIMARY KEY,
ID_Obat CHAR(5) NOT NULL,
Tanggal_Masuk DATE NOT NULL,
Jumlah_Persediaan INT NOT NULL DEFAULT 0
FOREIGN KEY (ID_Obat) REFERENCES Obat(ID_Obat)
);


CREATE TABLE Supplier (
  ID_Supplier CHAR(5) PRIMARY KEY,
  Nama_Supplier VARCHAR(50) NOT NULL,
  Alamat_Supplier VARCHAR(50) NOT NULL,
  No_Telp_Supplier char(12) NOT NULL
);

CREATE TABLE Pegawai_Obat (
  ID_Pegawai CHAR(5),
  ID_Obat char(5),
  Jumlah_Penanganan INT NOT NULL,
  PRIMARY KEY (ID_Pegawai, ID_Obat),
  FOREIGN KEY (ID_Pegawai) REFERENCES Pegawai(ID_Pegawai),
  FOREIGN KEY (ID_Obat) REFERENCES Obat(ID_Obat)
);

CREATE TABLE Pembelian (
  ID_Transaksi CHAR(5) PRIMARY KEY,
  ID_Pembeli CHAR(5) NOT NULL,
  ID_Obat CHAR(5) NOT NULL,
  ID_Pegawai CHAR(5) NOT NULL,
  Jumlah_Pembelian INT NOT NULL,
  Tanggal_transaksi DATE NOT NULL,
  Total_bayar MONEY NOT NULL,
  FOREIGN KEY (ID_Pembeli) REFERENCES Pembeli(ID_Pembeli),
  FOREIGN KEY (ID_Obat) REFERENCES Obat(ID_Obat),
  FOREIGN KEY (ID_Pegawai) REFERENCES Pegawai(ID_Pegawai)
);




CREATE TRIGGER update_jumlah_persediaan
ON Pembelian
AFTER INSERT
AS
BEGIN
  UPDATE Stok_Obat
  SET Jumlah_Persediaan = Jumlah_Persediaan - inserted.Jumlah_Pembelian
  FROM Stok_Obat
  JOIN inserted ON Stok_Obat.ID_Obat = inserted.ID_Obat;
END;


SELECT * FROM Pegawai;
SELECT * FROM Pembeli;
SELECT * FROM Obat;
SELECT * FROM Stok_Obat;
SELECT * FROM Supplier;
SELECT * FROM Pegawai_Obat;
SELECT * FROM Pembelian;

-- Insert data ke tabel Pegawai
INSERT INTO Pegawai (ID_Pegawai, Nama_Pegawai, Jenis_Kelamin, Alamat_Pegawai, No_Telp_Pegawai)
VALUES ('PG001', 'Budi', 'L', 'Jl. Sudirman No. 123', '081234567890'),
       ('PG002', 'Siti', 'P', 'Jl. Gatot Subroto No. 456', '082345678901'),
       ('PG003', 'Ahmad', 'L', 'Jl. Thamrin No. 789', '083456789012');

-- Insert data ke tabel Pembeli
INSERT INTO Pembeli (ID_Pembeli, Nama_Pembeli, Jenis_Kelamin, Alamat_Pembeli, No_Telp_Pembeli)
VALUES ('PB001', 'Ani', 'P', 'Jl. Diponegoro No. 321', '081234567890'),
       ('PB002', 'Dodi', 'L', 'Jl. Asia Afrika No. 654', '082345678901'),
       ('PB003', 'Wati', 'P', 'Jl. Pemuda No. 987', '083456789012');

-- Insert data ke tabel Supplier
INSERT INTO Supplier (ID_Supplier, Nama_Supplier, Alamat_Supplier, No_Telp_Supplier)
VALUES ('SP001', 'PT. Sehat Sentosa', 'Jl. Raya Bogor No. 1', '081234567890'),
       ('SP002', 'CV. Medika Farma', 'Jl. Cikini Raya No. 2', '082345678901');

-- Insert data ke tabel Obat
INSERT INTO Obat (ID_Obat, Nama_Obat, Jenis_Obat, Harga_Obat, ID_Supplier)
VALUES ('OB001', 'Paracetamol', 'Pil', 5000, 'SP001'),
       ('OB002', 'Amoxicillin', 'Kapsul', 10000, 'SP001'),
       ('OB003', 'Ciprofloxacin', 'Tablet', 15000, 'SP002');

-- Insert tabel Stok_Obat
INSERT INTO Stok_Obat (ID_StokObat, ID_Obat, Tanggal_Masuk, Jumlah_Persediaan)
VALUES ('SO001', 'OB001', '2023-02-01', 100),
('SO002', 'OB002', '2023-02-01', 120),
('SO003', 'OB003', '2023-02-01', 75);


-- Insert data ke tabel Pembelian
INSERT INTO Pembelian (ID_Transaksi, ID_Pembeli, ID_Pegawai, ID_Obat, Jumlah_Pembelian, Tanggal_Transaksi, Total_Bayar)
VALUES ('PJ001', 'PB001', 'PG001', 'OB001', 3, '2023-04-01', 15000),
       ('PJ002', 'PB002', 'PG002', 'OB002', 2, '2023-04-02', 20000),
       ('PJ003', 'PB003', 'PG003', 'OB003', 1, '2023-04-03', 15000);


-- Mengisi Stok_Obat
UPDATE Stok_Obat
SET Jumlah_Persediaan = Jumlah_Persediaan + 10
WHERE ID_Obat = 'OB003';

