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
grant SELECT on THONGTIN_DUAN to GIAMDOC ;




-- 12/5/2017 SU DUNG CO CHE VPD


-- yeu cau 4 ----- cai dat co che VPD: NHAN VIEN BINH THUONG (...) CHI XEM DUOC
-----THONG TIN CUA NHANVIEN CUNG PHONG BAN, VA CHI DUOC XEM LUONG CUA CHINH MINH



--tao context va context_package
CREATE CONTEXT quantri USING quantri.context_package;
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
                    FROM quantri.PHONGBAN pb
                    WHERE pb.truongPhong=v_user;
      SELECT COUNT(*) INTO countTCN
                    FROM quantri.CHINHANH CN
                    WHERE CN.TRUONGCHINHANH=v_user;
      SELECT COUNT(*) INTO countTDA
                    FROM quantri.DUAN DA
                    WHERE DA.truongDA=v_user;
     IF(countTP>0)
      THEN
          DBMS_SESSION.set_context('quantri','POSITION','TRUONGPHONG');
      END IF;
     IF(countTCN>0)
      THEN
          DBMS_SESSION.set_context('quantri','POSITION','TRUONGCHINHANH');
      END IF;
     IF(countTDA>0)
      THEN
          DBMS_SESSION.set_context('quantri','POSITION','TRUONGDUAN');
      END IF;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_SESSION.set_context('quantri','POSITION','none');
    END;
   END set_context;
End context_package;


--cap quyen cho moi nguoi dung deu su dung duoc package tren

GRANT EXECUTE ON context_package TO PUBLIC;
CREATE OR REPLACE PUBLIC SYNONYM context_package FOR quantri.context_package;

-- TAO TRIGGER EP BUOC SU DUNG NGU CANH SAU KHI DANG NHAP
CREATE OR REPLACE TRIGGER quantri.set_security_context
AFTER LOGON ON DATABASE
BEGIN
  quantri.context_package.set_context;
END;

-- luc nay co the su dung ngu canh vao trong ham
-- 1. ham de moi nhan vien chi xem duoc thong tin luong cua minh
create or replace function xemLuong(p_schema in varchar2,p_obj in varchar2)
return varchar2
as
  user varchar2(100);
BEGIN
  user:=SYS_CONTEXT('quantri','POSITION');
  CASE user
    WHEN 'TRUONGPHONG' THEN RETURN '1=1';
    WHEN 'TRUONGCHINHANH' THEN RETURN '1=1';
    WHEN 'TRUONGDUAN' THEN RETURN '1=1';
    ELSE
     BEGIN
       user:=concat('''',SYS_CONTEXT('userenv','SESSION_USER'));
       user:=concat(user,'''');
       return 'maNV='||lower(user); 
     END;
  END CASE;
END;
--gan chinh sach 1 theo ham nay
execute DBMS_RLS.ADD_POLICY(
          object_schema => 'quantri',
          object_name => 'nhanvien',
          policy_name => 'sec_Luong',
          policy_function => 'xemLuong',                  
          statement_types => 'select,update,insert',
          SEC_RELEVNT_COLS => 'luong',
          sec_relevant_cols_opt => dbms_rls.ALL_ROWS
  );

----2. ham de moi nhan vien chi xem duoc nhan vien cung phong ban
create or replace function xemNhanvien(p_schema in varchar2,p_obj in varchar2)
return varchar2
as
usera VARCHAR2(20);
mphong number;
temp VARCHAR2(20);
BEGIN
  usera:=SYS_CONTEXT('quantri','POSITION');
  CASE usera
    WHEN 'TRUONGPHONG' THEN RETURN '1=1';
    WHEN 'TRUONGCHINHANH' THEN RETURN '1=1';
    WHEN 'TRUONGDUAN' THEN RETURN '1=1';
    ELSE
      BEGIN  
        usera:=SYS_CONTEXT('userenv','SESSION_USER');
        usera:=lower(usera);
        SELECT nv.MAPHONG INTO mphong FROM quantri.NHANVIEN NV WHERE NV.MANV=usera;
        temp := 'maPhong =' || TO_CHAR(mphong);
        RETURN temp;
      END;
    end case;
END;
--gan ham chinh sach
execute DBMS_RLS.ADD_POLICY(
          object_schema => 'quantri',
          object_name => 'nhanvien',
          policy_name => 'sec_Nhanvien',
          policy_function => 'xemNhanvien'            
  );




--YEU CAU 7.3-- TRUONG CHI NHANH DUOC QUYEN 
--TRUY XUAT CHI TIEU CUA DU AN THUOC CHI NHANH CUA MINH
--dieu kien truoc khi bat dau tao OLS
--0.1. grant quyen can thiet cho quantri, UNLOCK ACCOUNT LBACSYS
GRANT CONNECT, RESOURCE, SELECT_CATALOG_ROLE TO quantri;
ALTER USER lbacsys IDENTIFIED BY lbacsys ACCOUNT UNLOCK;
--cac lenh sau su dung tai khoan [CONN lbacsys/lbacsys]--
GRANT EXECUTE ON sa_components TO quantri WITH GRANT OPTION;
GRANT EXECUTE ON sa_user_admin TO quantri WITH GRANT OPTION;
GRANT EXECUTE ON sa_label_admin TO quantri WITH GRANT OPTION;
GRANT EXECUTE ON sa_policy_admin TO quantri WITH GRANT OPTION;
GRANT EXECUTE ON sa_audit_admin  TO quantri WITH GRANT OPTION;
GRANT EXECUTE ON CHAR_TO_LABEL TO quantri ;
GRANT LBAC_DBA TO quantri;
GRANT EXECUTE ON sa_sysdba TO quantri;
GRANT EXECUTE ON to_lbac_data_label TO quantri;
--1+2. tao ham chinh sach 
begin
SA_SYSDBA.CREATE_POLICY (
policy_name => 'my_ols',
column_name => 'olscolumn0'
);
end;

--3. Sau khi chinh sach duoc khai bao, mot quyen dba ung voi chinh sach se duoc tao
-- ta cap quyen nay cho quantri;
EXECUTE SA_USER_ADMIN.SET_USER_PRIVS('MY_OLS','quantri','FULL,PROFILE_ACCESS');
GRANT MY_OLS_DBA TO quantri;

--4. Dinh nghia cac thanh phan cua Label:
-- Da duoc dinh nghia trong sctipt taoCSDL_QLDUAN
--5. Gan Policy cho Table:

BEGIN
 SA_POLICY_ADMIN.APPLY_TABLE_POLICY(
     policy_name    => 'MY_OLS',
     schema_name    => 'QUANTRI',
     table_name     => 'DUAN',
     table_options  => 'NO_CONTROL' 
     );
 END;
--6: Tao cac Nhan can thiet, la su ket hop giua 3 thanh phan

EXECUTE SA_LABEL_ADMIN.CREATE_LABEL('my_ols',400,'TT::HN,TPHCM,DN',TRUE);
EXECUTE SA_LABEL_ADMIN.CREATE_LABEL('my_ols',300,'TT::TPHCM',TRUE);
EXECUTE SA_LABEL_ADMIN.CREATE_LABEL('my_ols',200,'TT::DN',TRUE);
EXECUTE SA_LABEL_ADMIN.CREATE_LABEL('my_ols',100,'TT::HN',TRUE);
--7: gan Nhan can thiet cho du lieu trong bang DUAN
-- DU AN THUOC CHI NHANH HANOI
UPDATE DUAN SET olscolumn0=CHAR_TO_LABEL('my_ols','TT::HN')
    where (PHONGCHUTRI IN (SELECT DA.PHONGCHUTRI
                    FROM  DUAN DA,PHONGBAN PB, CHINHANH CN 
                    WHERE DA.PHONGCHUTRI=PB.MAPHONG
                          AND PB.CHINHANH=CN.MACN
                          AND CN.TENCN='Hà N?i'));
-- DU AN THUOC CHI NHANH TP.HCM
UPDATE DUAN SET olscolumn0=CHAR_TO_LABEL('my_ols','TT::TPHCM')
    where (PHONGCHUTRI IN (SELECT DA.PHONGCHUTRI
                    FROM  DUAN DA,PHONGBAN PB, CHINHANH CN 
                    WHERE DA.PHONGCHUTRI=PB.MAPHONG
                          AND PB.CHINHANH=CN.MACN
                          AND CN.TENCN='TP.HCM'));
-- DU AN THUOC CHI NHANH DANANG
UPDATE DUAN SET olscolumn0=CHAR_TO_LABEL('my_ols','TT::DN')
    where (PHONGCHUTRI IN (SELECT DA.PHONGCHUTRI
                    FROM  DUAN DA,PHONGBAN PB, CHINHANH CN 
                    WHERE DA.PHONGCHUTRI=PB.MAPHONG
                          AND PB.CHINHANH=CN.MACN
                          AND CN.TENCN='?à N?ng'));
-- CAC DU AN CON LAI TAM THOI GAN NHAN THUOC DU AN HANOI
UPDATE DUAN SET olscolumn0=CHAR_TO_LABEL('my_ols','TT::HN')
    where (PHONGCHUTRI IN (SELECT DA.PHONGCHUTRI
                    FROM  DUAN DA,PHONGBAN PB, CHINHANH CN 
                    WHERE DA.PHONGCHUTRI=PB.MAPHONG
                          AND PB.CHINHANH=CN.MACN
                          AND CN.TENCN IN('Nha Trang','Biên Hòa')));


--8: GAN NHAN CAN THIET CHO CAC TRUONG CHI NHANH 
--NV02: CH tphcm
--NV01 : Ha Noi
--NV05: Da Nang
--nv13: Nha Trang
--nv16: Bien Hoa
exec SA_USER_ADMIN.SET_USER_LABELS('MY_OLS','NV01','TT::HN,TPHCM,DN');
exec SA_USER_ADMIN.SET_USER_LABELS('MY_OLS','NV02','TT::TPHCM');
exec SA_USER_ADMIN.SET_USER_LABELS('MY_OLS','NV05','TT::DN');
exec SA_USER_ADMIN.SET_USER_LABELS('MY_OLS','NV13','TT::HN');
exec SA_USER_ADMIN.SET_USER_LABELS('MY_OLS','NV16','TT::HN');
-- Re-apply lai chinh sach

EXEC SA_POLICY_ADMIN.REMOVE_TABLE_POLICY('MY_OLS','QUANTRI','DUAN');
BEGIN
 SA_POLICY_ADMIN.APPLY_TABLE_POLICY(
     policy_name    => 'MY_OLS',
     schema_name    => 'QUANTRI',
     table_name     => 'DUAN',
     table_options  => 'READ_CONTROL,WRITE_CONTROL' 
     );
 END;


