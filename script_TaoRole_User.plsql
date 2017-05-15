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
create user nv19 identified by nv19 DEFAULT TABLESPACE users 
          TEMPORARY TABLESPACE temp QUOTA UNLIMITED ON users;
create user nv20 identified by nv20 DEFAULT TABLESPACE users 
          TEMPORARY TABLESPACE temp QUOTA UNLIMITED ON users; 

--CAP QUYEN CHO YEU CAU SO 3---
-- cap quyen dang nhap cho user khi can kiem tra
grant create session to nv03;
grant create session to nv18;
grant create session to nv19;
grant create session to nv20;



-- Cap role cho user khi can kiem tra ket qua
grant truongphong to nv03;
grant truongphong to nv18;
grant nhanvien to nv19;
grant nhanvien to nv20;


--CAP QUYEN CHO ROLE KHI MUON CAI DAT CHINH SACH
grant insert,update,select on admin.duan to truongphong;
grant select on admin.nhanvien to truongphong;
grant select on admin.nhanvien to nhanvien;
-- GIAI DOAN 2--  9/5/2017-- cai dat cac chinh sach bao mat ap dung cac co che da hoc
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


-- yeu cau 4 ----- cai dat co che VPD: NHAN VIEN BINH THUONG (...) CHI XEM DUOC
-----THONG TIN CUA NHANVIEN CUNG PHONG BAN, VA CHI DUOC XEM LUONG CUA CHINH MINH



--tao context va context_package
CREATE CONTEXT ADMIN USING ADMIN.context_package;
CREATE OR REPLACE PACKAGE context_package AS
  PROCEDURE set_context;
END;

-- cai dat procedure
CREATE OR REPLACE PACKAGE BODY context_package IS
   PROCEDURE set_context IS
    v_user VARCHAR2(30);
    countTP number;-- truongphong
    countTCN number;--truongchinhanh
    countTDA number;--truongduan
   BEGIN
    v_user:=SYS_CONTEXT('userenv','SESSION_USER');
    v_user:=lower(v_user);
    BEGIN
      SELECT COUNT(*) INTO countTP
                    FROM admin.PHONGBAN pb
                    WHERE pb.truongPhong=v_user;
      SELECT COUNT(*) INTO countTCN
                    FROM admin.CHINHANH CN
                    WHERE CN.truongChiNhanh=v_user;
      
    IF(lcount>0)
      THEN
          DBMS_SESSION.set_context('ADMIN','POSITION','TRUONGPHONG');
      END IF;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_SESSION.set_context('ADMIN','POSITION','none');
    END;
   END set_context;
End context_package;


--cap quyen cho moi nguoi dung deu su dung duoc package tren

GRANT EXECUTE ON context_package TO PUBLIC;
CREATE OR REPLACE PUBLIC SYNONYM context_package FOR ADMIN.context_package;

-- TAO TRIGGER EP BUOC SU DUNG NGU CANH SAU KHI DANG NHAP
CREATE OR REPLACE TRIGGER ADMIN.set_security_context
AFTER LOGON ON DATABASE
BEGIN
  ADMIN.context_package.set_context;
END;

-- luc nay co the su dung ngu canh vao trong ham
-- 1. ham de moi nhan vien chi xem duoc thong tin luong cua minh
create or replace function xemLuong(p_schema in varchar2,p_obj in varchar2)
return varchar2
as
  user varchar2(100);
BEGIN
  user:=SYS_CONTEXT('ADMIN','POSITION');
  IF(USER='TRUONGPHONG') 
  THEN 
      RETURN '1=1';
  ELSE
  BEGIN
      user:=concat('''',SYS_CONTEXT('userenv','SESSION_USER'));
      user:=concat(user,'''');
      return 'maNV='||lower(user); 
  END;
  END IF;
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











