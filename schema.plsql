create   table ChiNhanh(
maCN char(10) not null,
tenCN nvarchar2(50),
truongChiNhanh char(10) not null,
primary key(maCN)
);

create  table ChiTieu(
maChiTieu char(10) not null,
tenChiTieu nvarchar2(50),
soTien number(12,0) not null,
duAn char(10) not null, 
primary key(maChiTieu)
);

create  table DuAn(
maDA char(10) not null,
kinhPhi number(12,0), 
phongChuTri char(10) not null,
truongDA char(10) not null,
primary key(maDA)
);

create  table PhongBan(
maPhong char(10) not null,
tenPhong nvarchar2(50),
truongPhong char(10),
ngayNhanChuc date, 
soNhanVien number(5,0), 
chiNhanh char(10) not null,
primary key (maPhong)
);

create  table NhanVien (
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

create  table PhanCong(
maNV char(10) not null, 
duAn char(10) not null, 
vaiTro nvarchar2(30), 
phuCap number(10,0), 
primary key(maNV, duAn)
);

alter table ChiTieu
add constraint fk_chitieu_duan
foreign key (duAn)
references DuAn(maDA);



alter table DuAn
add constraint fk_duan_phongban
foreign key (phongChuTri)
references PhongBan(maPhong);

alter table DuAn
add constraint fk_duan_truongduan
foreign key (truongDA)
references NhanVien(maNV);

alter table PhongBan
add constraint fk_phongban_chinhanh
foreign key (chiNhanh)
references ChiNhanh(maCN);

alter table PhongBan
add constraint fk_phongban_truongphong
foreign key (truongPhong)
references NhanVien(maNV);

alter table PhanCong
add constraint fk_phancong_nhanvien
foreign key (maNV)
references NhanVien(maNV);

alter table PhanCong
add constraint fk_phancong_duan
foreign key (duAn)
references DuAn(maDA);

alter table NhanVien
add constraints fk_nhanvien_phongban
foreign key (maPhong)
references PhongBan(maPhong);

alter  table NhanVien
add constraints fk_nhanvien_chinhanh
foreign key (chiNhanh)
references ChiNhanh(maCN);

alter table ChiNhanh
add constraints fk_chinhanh_truongchinhanh
foreign key (truongChiNhanh)
references NhanVien(maNV);










