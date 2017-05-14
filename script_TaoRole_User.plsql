alter session set "_ORACLE_SCRIPT"=true; 

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

--CAP QUYEN CHO YEU CAU SO 3---
--Tao thu nv3 thay cho nv03 de kiem tra phan quyen

-- nv3 la truong phong nen gan quyen truongphong cho nv3  
grant truongphong to nv03;
grant create session to nv03;
alter user nv03 default role truongphong;
-- cap quyen select, insert, update cho truongphong
grant insert,update,select on admin.duan to truongphong;

-- GIAI DOAN 2--  9/5/2017----TIEP TUC LAM BAI----
-- YEU CAU 4: DANH CHO GIAMDOC
-- T?O 1 USER là giám ??c :

create user giamdoc1 identified by giamdoc1 DEFAULT TABLESPACE users 
TEMPORARY TABLESPACE temp QUOTA UNLIMITED ON users;
grant giamdoc to giamdoc1;
grant create session to giamdoc1;
-- c?p quy?n cho giamdoc và ki?m tra th?
-- ta tao view dap ung yeu cau de bai
--view bo tro
CREATE VIEW TONG_CHITIEU
AS 
SELECT ct.duan as MADA,SUM(ct.SOTIEN) AS TONGCHITIEU
FROM CHITIEU ct
group by ct.duan;
-- view chinh thuc
create view THONGTIN_DUAN 
as 
select da.MADA,da.TENDA,da.KINHPHI,
       pb.TENPHONG as PHONGCHUTRI,
       cn.TENCN as CHINHANHCHUTRI,
       nv.HOTEN as TRUONGDUAN,
       sumct.TONGCHITIEU as TONGCHITIEU
        
from DUAN da, PHONGBAN pb, NHANVIEN nv, CHINHANH cn,TONG_CHITIEU sumct 
where da.PHONGCHUTRI=pb.MAPHONG
    AND cn.MACN=pb.CHINHANH
    AND da.TRUONGDA=nv.MANV
    AND da.MADA=sumct.MADA;
    
-- CAP QUYEN CHO GIAMDOC TREN VIEW NAY
grant SELECT on "ADMIN"."THONGTIN_DUAN" to "GIAMDOC" ;




-- 12/5/2017 SU DUNG CO CHE VPD


-- yeu cau 5 ----- ta chia nho thanh 2 chinh sach ung voi 2 ham duoi day
-- 1. ham de moi nhan vien chi xem duoc thong tin luong cua minh
create or replace function xemLuong(p_schema in varchar2,p_obj in varchar2)
return varchar2
as
  user varchar2(100);
BEGIN
  user:=concat('''',SYS_CONTEXT('userenv','SESSION_USER'));
  user:=concat(user,'''');
  return 'maNV='||lower(user); 
END;
--gan chinh sach 1 theo ham nay
execute DBMS_RLS.ADD_POLICY(
          object_schema => 'admin',
          object_name => 'nhanvien',
          policy_name => 'sec_Luong',
          policy_function => 'xemLuong',                  
          statement_types => 'select,update,insert',
          update_check=> TRUE
  );

----2. ham de moi nhan vien chi xem duoc nhan vien cung phong ban
create or replace function xemNhanvien(p_schema in varchar2,p_obj in varchar2)
return varchar2
as
PRAGMA AUTONOMOUS_TRANSACTION;
usera VARCHAR2(10);
mphong number;
temp VARCHAR2(20);
BEGIN
  usera:=SYS_CONTEXT('userenv','SESSION_USER');
  usera:=lower(usera);
  SELECT nv.maphong INTO mphong FROM ADMIN.NHANVIEN nv WHERE nv.manv=usera;
temp := 'maPhong =' ||TO_CHAR(mphong);
RETURN temp;
END;
--gan ham chinh sach
execute DBMS_RLS.ADD_POLICY(
          object_schema => 'admin',
          object_name => 'nhanvien',
          policy_name => 'sec_Nhanvien',
          policy_function => 'xemNhanvien'            
  );











