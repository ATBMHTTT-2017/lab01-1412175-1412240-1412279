alter session set "_ORACLE_SCRIPT"=true; 
create user quantri identified by 123456;
grant create session to quantri;
grant connect,resource,dba to quantri;
-- tao cac role cho cac vi tri phu hop cho cong ty
-- truongchinhanh, truongphong, truongduan, nhanvien

create role truongchinhanh identified by 123456;
create role truongphong identified by 123456;
create role truongduan identified by 123456;
create role nhanvien  identified by 123456;
create role giamdoc identified by 123456;


--tao tai khoan user cho tat ca cac nhanvien co trong bang nhanvien
-- khi nao can kiem tra thi tao 
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

--CAP QUYEN CHO YEU CAU SO 3---
-- cap quyen dang nhap cho user khi can kiem tra
grant create session to nv02;
grant create session to nv01;
grant create session to nv03;
grant create session to nv18;
grant create session to nv19;
grant create session to nv20;
grant create session to nv06;
-- CAP QUYEN CHO YEU CAU SO 7.3:
grant create session to nv05;
grant create session to nv13;
grant create session to nv16;
grant create session to nv06,nv07,nv09,nv10,nv12,nv13,nv15,nv16,nv18,nv19;

-- Cap role cho user khi can kiem tra ket qua
grant truongphong to nv03;
grant truongphong to nv18;
grant nhanvien to nv19;
grant nhanvien to nv20;
grant truongchinhanh to nv01;
grant truongchinhanh to nv02;
grant truongchinhanh to nv05;
grant truongchinhanh to nv13;
grant truongchinhanh to nv16;
grant truongduan to nv06;


--CAP QUYEN CHO ROLE KHI MUON CAI DAT CHINH SACH
grant insert,update,select on quantri.duan to truongphong;
grant select on quantri.nhanvien to truongphong;
grant select on quantri.nhanvien to nhanvien;
grant select on quantri.nhanvien to truongchinhanh;
grant select on quantri.nhanvien to truongduan;
grant select on quantri.duan to truongchinhanh;

grant select,insert,update on quantri.chitieu to public;


-- 12/5/2017 SU DUNG CO CHE VPD









