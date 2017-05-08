create  table ChiNhanh(
maCN char(10) not null,
tenCN nvarchar2(50),
truongChiNhanh number(10,0) not null,
primary key(maCN)
);

create table ChiTieu(
maChiTieu char(10) not null,
tenChiTieu nvarchar2(50),
soTien number(12,0) not null,
duAn char(10) not null, 
primary key(maChiTieu)
);

create table DuAn(
maDA char(10) not null,
kinhPhi number(12,0), 
phongChuTri char(10) not null,
truongDA char(10) not null,
primary key(maDA)
);

create table PhongBan(
maPhong char(10) not null,
tenPhong nvarchar2(50),
ngayNhanChuc date, 
soNhanVien number(5,0), 
chiNhanh char(10) not null,
primary key (maPhong)
);

create table NhanVien (
maNV char(10) not null,
hoTen nvarchar2(50),
diaChi nvarchar2(200), 
dienThoai number(12), 
email char(30), 
maPhong char(10) not null, 
chiNhanh char(10) not null, 
luong number(10,0), 
primary key(maNV)

);

create table PhanCong(
maNV char(10) not null, 
duAn char(10) not null, 
vaiTro nvarchar2(30), 
phuCap number(10,0), 
primary key(maNV, duAn)

);