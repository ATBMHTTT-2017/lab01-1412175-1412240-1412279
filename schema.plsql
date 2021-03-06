--tạo bảng------
create table chinhanh(
	maCN number(2,0) not null,
	tenCN varchar2(50 char),
	truongChiNhanh varchar2(5 char) not null,
	primary key(maCN)
);

create table phongban(
	maPhong number(2,0) not null,
	tenPhong varchar2(50 char),
	truongPhong varchar2(5 char),
	ngayNhanChuc date,
	soNhanVien number,
	chiNhanh number(2,0) not null,
	primary key(maPhong)
);

create table duan(
	maDA number(2,0) not null,
	tenDA varchar2(50 char),
	kinhPhi number(9,0),
	phongChuTri number(2,0) not null,
	truongDA varchar2(5 char) not null,
	primary key(maDA)
);

create table nhanvien(
	maNV varchar2(5 char) not null,
	hoTen varchar2(50 char),
	diaChi varchar2(50 char),
	dienThoai varchar2(11 char),
	email varchar2(50 char),
	maPhong number(2,0) not null,
	chiNhanh number(2,0) not null,
	luong number(9,0),
	primary key(maNV)
);

create table phancong(
	maNV varchar2(5 char) not null,
	duAn number(2,0) not null,
	vaiTro varchar2(50 char),
	phuCap number(9,0),
	primary key(maNV,duAn)
);

create table chitieu(
	maChiTieu number(2,0) not null,
	tenChiTieu varchar2(50 char),
	soTien number(9,0),
	duAn number(2,0) not null,
	primary key(maChiTieu)
);

-- tạo khóa ngoại có tổng cộng 10 khóa ngoại tham chiếu, trong đó để thêm dữ liệu 
-- được tốt ta không thêm ban đầu tất cả 10 khóa ngoại ngay, mà chỉ thêm sau khi insert dữ liệu một vài bảng


alter table nhanvien
	add constraint kf_nhanvien_chinhanh
	foreign key (chiNhanh)
	references chinhanh(maCN);

alter table phongban
	add constraint kf_phongban_chinhanh
	foreign key (chiNhanh)
	references chinhanh(maCN);


alter table chitieu
	add constraint kf_chitieu_duan
	foreign key (duAn)
	references duan(maDA);

alter table duan
	add constraint kf_duan_truongduan
	foreign key (truongDA)
	references nhanvien(maNV);

alter table duan
	add constraint kf_duan_phongchutri
	foreign key (phongChuTri)
	references phongban(maPhong);

alter table nhanvien
	add constraint kf_nhanvien_phongban
	foreign key (maPhong)
	references phongban(maPhong);

alter table phancong
	add constraint kf_phancong_nhanvien
	foreign key (maNV)
	references nhanvien(maNV);

alter table phancong
	add constraint kf_phancong_duan
	foreign key (duAn)
	references duan(maDA);




---tạo Dữ liệu mẫu, thứ tự insert dữ liệu phải đúng như thứ tự bên dưới

--1. bảng Chi nhánh 
insert into chinhanh(maCN,tenCN,truongChiNhanh) 
			values(1,'TP.HCM','nv02');
insert into chinhanh(maCN,tenCN,truongChiNhanh) 
			values(2,'Hà Nội','nv01');
insert into chinhanh(maCN,tenCN,truongChiNhanh) 
			values(3,'�?à Nẵng','nv05');
insert into chinhanh(maCN,tenCN,truongChiNhanh) 
			values(4,'Nha Trang','nv13');
insert into chinhanh(maCN,tenCN,truongChiNhanh) 
			values(5,'Biên Hòa','nv16');
--2. bảng phongban
insert into phongban(maPhong,tenPhong,truongPhong,ngayNhanChuc,soNhanVien,chiNhanh)
			values(1,'Nhan Su', 'nv03',to_date('27-04-2016','dd-MM-yyyy'),10,1);
insert into phongban(maPhong,tenPhong,truongPhong,ngayNhanChuc,soNhanVien,chiNhanh)
			values(2,'Ke toan', 'nv04',to_date('27-04-2016','dd-MM-yyyy'),10,1);
insert into phongban(maPhong,tenPhong,truongPhong,ngayNhanChuc,soNhanVien,chiNhanh)
			values(3,'Ke hoach','nv06',to_date('27-04-2016','dd-MM-yyyy'),10,1);
insert into phongban(maPhong,tenPhong,truongPhong,ngayNhanChuc,soNhanVien,chiNhanh)
			values(4,'Nhan Su', 'nv07',to_date('27-04-2016','dd-MM-yyyy'),10,2);
insert into phongban(maPhong,tenPhong,truongPhong,ngayNhanChuc,soNhanVien,chiNhanh)
			values(5,'Ke toan', 'nv08',to_date('27-04-2016','dd-MM-yyyy'),10,2);
insert into phongban(maPhong,tenPhong,truongPhong,ngayNhanChuc,soNhanVien,chiNhanh)
			values(6,'Ke hoach','nv09',to_date('27-04-2016','dd-MM-yyyy'),10,2);
insert into phongban(maPhong,tenPhong,truongPhong,ngayNhanChuc,soNhanVien,chiNhanh)
			values(7,'Nhan Su', 'nv10',to_date('27-04-2016','dd-MM-yyyy'),10,3);
insert into phongban(maPhong,tenPhong,truongPhong,ngayNhanChuc,soNhanVien,chiNhanh)
			values(8,'Ke toan', 'nv11',to_date('27-04-2016','dd-MM-yyyy'),10,3);
insert into phongban(maPhong,tenPhong,truongPhong,ngayNhanChuc,soNhanVien,chiNhanh)
			values(9,'Ke hoach','nv12',to_date('27-04-2016','dd-MM-yyyy'),10,3);

insert into phongban(maPhong,tenPhong,truongPhong,ngayNhanChuc,soNhanVien,chiNhanh)
			values(10,'Nhan Su','nv13',to_date('27-04-2016','dd-MM-yyyy'),10,4);
insert into phongban(maPhong,tenPhong,truongPhong,ngayNhanChuc,soNhanVien,chiNhanh)
			values(11,'Ke toan','nv14',to_date('27-04-2016','dd-MM-yyyy'),10,4);
insert into phongban(maPhong,tenPhong,truongPhong,ngayNhanChuc,soNhanVien,chiNhanh)
			values(12,'Ke hoach','nv15',to_date('27-04-2016','dd-MM-yyyy'),10,4);
insert into phongban(maPhong,tenPhong,truongPhong,ngayNhanChuc,soNhanVien,chiNhanh)
			values(13,'Nhan Su','nv16',to_date('27-04-2016','dd-MM-yyyy'),10,5);
insert into phongban(maPhong,tenPhong,truongPhong,ngayNhanChuc,soNhanVien,chiNhanh)
			values(14,'Ke toan','nv17',to_date('27-04-2016','dd-MM-yyyy'),10,5);
insert into phongban(maPhong,tenPhong,truongPhong,ngayNhanChuc,soNhanVien,chiNhanh)
			values(15,'Ke hoach','nv18',to_date('27-04-2016','dd-MM-yyyy'),10,5);
--3. bảng nhanvien
insert into nhanvien(maNV,hoTen,diaChi,dienThoai,email,maPhong,chiNhanh,luong)
			values('nv01','Trần Văn An','�?inh quyết P Quận 14-TP. HCM','096939407','', 4,2, 6000000);
insert into nhanvien(maNV,hoTen,diaChi,dienThoai,email,maPhong,chiNhanh,luong)
			values('nv02','Nguyễn Tiến Tấn','Trương viết J Quận 7-TP. HCM','0934764519','',1 ,1,6000000 );
insert into nhanvien(maNV,hoTen,diaChi,dienThoai,email,maPhong,chiNhanh,luong)
			values('nv03','Triệu Xuân Bảo','Bạch đình E Quận 4-TP. HCM','0963215433','', 1,1,6000000 );
insert into nhanvien(maNV,hoTen,diaChi,dienThoai,email,maPhong,chiNhanh,luong)
			values('nv04','Châu Tiến Dung','�?ổ sơn W Quận 4-TP. HCM','0935472370','', 2, 1,6000000 );
insert into nhanvien(maNV,hoTen,diaChi,dienThoai,email,maPhong,chiNhanh,luong)
			values('nv05','Nguyễn Sơn Châu','Bạch thị R Quận 3-�?à nẳng','0939859707','', 7, 3, 6000000);
insert into nhanvien(maNV,hoTen,diaChi,dienThoai,email,maPhong,chiNhanh,luong)
			values('nv06','Dương Minh Tân','Hà thế H Quận 14-TP. HCM','0978781517','', 3, 1, 6000000);
insert into nhanvien(maNV,hoTen,diaChi,dienThoai,email,maPhong,chiNhanh,luong)
			values('nv07','Phạm Thanh Lành','Hoa văn L Quận 8-TP. HCM','0910449152','', 4, 2, 6000000);
insert into nhanvien(maNV,hoTen,diaChi,dienThoai,email,maPhong,chiNhanh,luong)
			values('nv08','Nguyễn Phước Hóa','Bạch lê I Quận 2-TP. HCM','0980169830','',5 , 2,6000000 );
insert into nhanvien(maNV,hoTen,diaChi,dienThoai,email,maPhong,chiNhanh,luong)
			values('nv09','Mai Cao Bích','�?inh văn L Quận 13-TP. HCM','0940350125','', 6, 2, 6000000);
insert into nhanvien(maNV,hoTen,diaChi,dienThoai,email,maPhong,chiNhanh,luong)
			values('nv10','Nguyễn Thế Dũng','Tô kỳ G Quận 4-Cần Thơ','0926685458','', 7, 3, 6000000);
insert into nhanvien(maNV,hoTen,diaChi,dienThoai,email,maPhong,chiNhanh,luong)
			values('nv11','Thái Sơn Giang','�?ặng minh P Quận 8-TP. HCM','0938394537','',8,3 ,6000000 );
insert into nhanvien(maNV,hoTen,diaChi,dienThoai,email,maPhong,chiNhanh,luong)
			values('nv12','Trần Tiến Hạnh','Phạm gia V Quận 4-TP. HCM','0938324631','', 9,3, 6000000);

insert into nhanvien(maNV,hoTen,diaChi,dienThoai,email,maPhong,chiNhanh,luong)
			values('nv13','Nguyễn Thế Dũng Bạch','Tô kỳ G Quận 4-Cần Thơ','09266855458','', 10, 4, 6000000);
insert into nhanvien(maNV,hoTen,diaChi,dienThoai,email,maPhong,chiNhanh,luong)
			values('nv14','Thái Sơn Giang Bảo','�?ặng minh P Quận 8-TP. HCM','09383945537','',11,4 ,6000000 );
insert into nhanvien(maNV,hoTen,diaChi,dienThoai,email,maPhong,chiNhanh,luong)
			values('nv15','Trần Tiến Hạnh An','Phạm gia V Quận 4-TP. HCM','09383245631','', 12,4, 6000000);


insert into nhanvien(maNV,hoTen,diaChi,dienThoai,email,maPhong,chiNhanh,luong)
			values('nv16','Nguyễn An','Tô kỳ G Quận 4-Cần Thơ','09266855458','', 13, 5, 6000000);
insert into nhanvien(maNV,hoTen,diaChi,dienThoai,email,maPhong,chiNhanh,luong)
			values('nv17','Thái Sơn Văn','�?ặng minh P Quận 8-TP. HCM','09383945537','',14,5 ,6000000 );
insert into nhanvien(maNV,hoTen,diaChi,dienThoai,email,maPhong,chiNhanh,luong)
			values('nv18','Trần Tiến Quận','Phạm gia V Quận 4-TP. HCM','09383245631','', 15,5, 6000000);
			
insert into nhanvien(maNV,hoTen,diaChi,dienThoai,email,maPhong,chiNhanh,luong)
			values('nv19','Trần Tiến Quận','Phạm gia V Quận 4-TP. HCM','09383245631','', 2,1, 6000000);
			-- TT:KT:TPHCM
insert into nhanvien(maNV,hoTen,diaChi,dienThoai,email,maPhong,chiNhanh,luong)
			values('nv20','Trần Tiến Quận','Phạm gia V Quận 4-TP. HCM','09383245631','', 3,1, 6000000);
			-- TT:KH:TPHCM


--- bổ sung khóa ngoại sau khi insert vào bảng NhanVien
alter table chinhanh
	add constraint kf_chinhanh_truongchinhanh
	foreign key (truongChiNhanh)
	references nhanvien(maNV);


---

--4. bảng duan
insert into duan(maDA,tenDA,kinhPhi,phongChuTri,truongDA)
			values(6,'Dự án 6',300000000,2,'nv06');
insert into duan(maDA,tenDA,kinhPhi,phongChuTri,truongDA)
			values(1,'Dự án 1',300000000,3,'nv06');
insert into duan(maDA,tenDA,kinhPhi,phongChuTri,truongDA)
			values(2,'Dự án 2',600000000,6,'nv09');
insert into duan(maDA,tenDA,kinhPhi,phongChuTri,truongDA)
			values(3,'Dự án 3',900000000,9,'nv12');
insert into duan(maDA,tenDA,kinhPhi,phongChuTri,truongDA)
			values(4,'Dự án 4',600000000,12,'nv15');
insert into duan(maDA,tenDA,kinhPhi,phongChuTri,truongDA)
			values(5,'Dự án 5',900000000,15,'nv18');
insert into duan(maDA,tenDA,kinhPhi,phongChuTri,truongDA)
			values(6,'Dự án 6',300000000,2,'nv06');

--5. bảng chitieu
insert into chitieu(maChiTieu,tenChiTieu,soTien,duAn)
			values(1 ,'Luong',0 , 1);
insert into chitieu(maChiTieu,tenChiTieu,soTien,duAn)
			values(2,'Quan ly',0 , 1);
insert into chitieu(maChiTieu,tenChiTieu,soTien,duAn)
			values(3 ,'Vat lieu',0 ,1 );
insert into chitieu(maChiTieu,tenChiTieu,soTien,duAn)
			values(4 ,'Luong', 0, 2);
insert into chitieu(maChiTieu,tenChiTieu,soTien,duAn)
			values(5,'Quan ly', 0, 2);
insert into chitieu(maChiTieu,tenChiTieu,soTien,duAn)
			values(6 ,'Vat lieu',0 ,2 );
insert into chitieu(maChiTieu,tenChiTieu,soTien,duAn)
			values(7 ,'Luong', 0, 3);
insert into chitieu(maChiTieu,tenChiTieu,soTien,duAn)
			values(8,'Quan ly', 0, 3);
insert into chitieu(maChiTieu,tenChiTieu,soTien,duAn)
			values(9 ,'Vat lieu',0 ,3 );
insert into chitieu(maChiTieu,tenChiTieu,soTien,duAn)
			values(10,'Luong', 0, 4);
insert into chitieu(maChiTieu,tenChiTieu,soTien,duAn)
			values(11,'Quan ly', 0, 4);
insert into chitieu(maChiTieu,tenChiTieu,soTien,duAn)
			values(12,'Vat lieu',0, 4);
insert into chitieu(maChiTieu,tenChiTieu,soTien,duAn)
			values(13 ,'Luong',0 , 5);
insert into chitieu(maChiTieu,tenChiTieu,soTien,duAn)
			values(14,'Quan ly',0 , 5);
insert into chitieu(maChiTieu,tenChiTieu,soTien,duAn)
			values(15,'Vat lieu',0 , 5);
--6. bảng phancong
insert into phancong(maNV,duAn,vaiTro,phuCap)
			values('nv06', 1,'truongDA', 0);
insert into phancong(maNV,duAn,vaiTro,phuCap)
			values('nv09', 2,'truongDA', 0);
insert into phancong(maNV,duAn,vaiTro,phuCap)
			values('nv12', 3,'truongDA', 0);
insert into phancong(maNV,duAn,vaiTro,phuCap)
			values('nv15', 4,'truongDA', 0);
insert into phancong(maNV,duAn,vaiTro,phuCap)
			values('nv18', 5,'truongDA',0 );
			
			
-- tao role
create role truongchinhanh identified by 123456;
create role truongphong identified by 123456;
create role truongduan identified by 123456;
create role nhanvien  identified by 123456;
create role giamdoc identified by 123456;
-- tao user

create user nv01 identified by nv01 DEFAULT TABLESPACE users 
          TEMPORARY TABLESPACE temp QUOTA UNLIMITED ON users;
create user nv02 identified by nv02 DEFAULT TABLESPACE users 
          TEMPORARY TABLESPACE temp QUOTA UNLIMITED ON users;
create user nv03 identified by nv03 DEFAULT TABLESPACE users 
          TEMPORARY TABLESPACE temp QUOTA UNLIMITED ON users;          
create user nv04 identified by nv04 DEFAULT TABLESPACE users 
          TEMPORARY TABLESPACE temp QUOTA UNLIMITED ON users;
create user nv05 identified by nv05 DEFAULT TABLESPACE users 
          TEMPORARY TABLESPACE temp QUOTA UNLIMITED ON users;
create user nv06 identified by nv06 DEFAULT TABLESPACE users 
          TEMPORARY TABLESPACE temp QUOTA UNLIMITED ON users;
create user nv07 identified by nv07 DEFAULT TABLESPACE users 
          TEMPORARY TABLESPACE temp QUOTA UNLIMITED ON users;
create user nv08 identified by nv08 DEFAULT TABLESPACE users 
          TEMPORARY TABLESPACE temp QUOTA UNLIMITED ON users;
create user nv09 identified by nv09 DEFAULT TABLESPACE users 
          TEMPORARY TABLESPACE temp QUOTA UNLIMITED ON users;
create user nv10 identified by nv10 DEFAULT TABLESPACE users 
          TEMPORARY TABLESPACE temp QUOTA UNLIMITED ON users;
create user nv11 identified by nv11 DEFAULT TABLESPACE users 
          TEMPORARY TABLESPACE temp QUOTA UNLIMITED ON users; 
create user nv12 identified by nv12 DEFAULT TABLESPACE users 
          TEMPORARY TABLESPACE temp QUOTA UNLIMITED ON users;
create user nv13 identified by nv13 DEFAULT TABLESPACE users 
          TEMPORARY TABLESPACE temp QUOTA UNLIMITED ON users;
create user nv14 identified by nv14 DEFAULT TABLESPACE users 
          TEMPORARY TABLESPACE temp QUOTA UNLIMITED ON users;
create user nv15 identified by nv15 DEFAULT TABLESPACE users 
          TEMPORARY TABLESPACE temp QUOTA UNLIMITED ON users;
create user nv16 identified by nv16 DEFAULT TABLESPACE users 
          TEMPORARY TABLESPACE temp QUOTA UNLIMITED ON users;
create user nv17 identified by nv17 DEFAULT TABLESPACE users 
          TEMPORARY TABLESPACE temp QUOTA UNLIMITED ON users;
create user nv18 identified by nv18 DEFAULT TABLESPACE users 
          TEMPORARY TABLESPACE temp QUOTA UNLIMITED ON users;  
create user nv19 identified by nv19 DEFAULT TABLESPACE users 
          TEMPORARY TABLESPACE temp QUOTA UNLIMITED ON users;
create user nv20 identified by nv20 DEFAULT TABLESPACE users 
          TEMPORARY TABLESPACE temp QUOTA UNLIMITED ON users;

-- truong chi nhanh nv01 , nv02 , nv05,nv13,nv16
 grant truongchinhanh to nv01;
 grant create session to nv01;
 
  grant truongchinhanh to nv02;
 grant create session to nv02;
 
  grant truongchinhanh to nv05;
 grant create session to nv05;
 
  grant truongchinhanh to nv13;
 grant create session to nv13;
 
  grant truongchinhanh to nv16;
 grant create session to nv16;
 
 
 ---------truong phong nv03,nv04,nv06,nv07,nv08,nv09,nv10,nv11,nv12,nv13,nv14,nv15,nv16,nv17,nv18
 grant truongphong to nv03;
 grant create session to nv03;
 
 grant truongphong to nv04;
 grant create session to nv04;
 
 grant truongphong to nv06;
 grant create session to nv06;
 
 grant truongphong to nv07;
 grant create session to nv07;
 
 grant truongphong to nv08;
 grant create session to nv08;
 
 grant truongphong to nv09;
 grant create session to nv09;
 
 grant truongphong to nv10;
 grant create session to nv10;
 
 grant truongphong to nv11;
 grant create session to nv11;
 
 grant truongphong to nv12;
 grant create session to nv12;
 
 grant truongphong to nv13;
 grant create session to nv13;
 
 grant truongphong to nv14;
 grant create session to nv14;
 
 grant truongphong to nv15;
 grant create session to nv15;
 
 grant truongphong to nv16;
 grant create session to nv16;
 
 grant truongphong to nv17;
 grant create session to nv17;
 
 grant truongphong to nv18;
 grant create session to nv18;
 
 --- nhan vien nv19 , nv20
 grant nhanvien to nv19;
grant nhanvien to nv20;
------ truong du an nv06,nv09,nv12,nv15,nv18
grant truongduan to nv06;

grant truongduan to nv09;

grant truongduan to nv12;

grant truongduan to nv15;

grant truongduan to nv18;

grant select,insert,update,delete on chitieu to truongduan;
