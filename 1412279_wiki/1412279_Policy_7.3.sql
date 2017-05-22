--YEU CAU 7.3-- TRUONG CHI NHANH DUOC QUYEN 
--TRUY XUAT CHI TIEU CUA DU AN THUOC CHI NHANH CUA MINH
--dieu kien truoc khi bat dau tao OLS
grant truongchinhanh to nv01,nv02,nv05;
grant create session to nv01,nv02,nv05;
grant select,insert on quantri.duan to truongchinhanh;




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
begin
sa_components.create_level
(policy_name => 'my_ols',
long_name => 'Thong thuong',
short_name => 'TT',
level_num => 1);
end;
BEGIN
 SA_COMPONENTS.CREATE_GROUP (
  policy_name     => 'my_ols',
  group_num       => 100,
  short_name      => 'HN',
  long_name       => 'Ha Noi');
END;
BEGIN
 SA_COMPONENTS.CREATE_GROUP (
  policy_name     => 'my_ols',
  group_num       => 200,
  short_name      => 'TPHCM',
  long_name       => 'Ho Chi Minh',
  parent_name     => 'HN'
  );
END;
BEGIN
 SA_COMPONENTS.CREATE_GROUP (
  policy_name     => 'my_ols',
  group_num       => 300,
  short_name      => 'DN',
  long_name       => 'Da Nang',
  parent_name     => 'HN'
  );
END;
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

EXECUTE SA_LABEL_ADMIN.CREATE_LABEL('my_ols',30,'TT::TPHCM',TRUE);
EXECUTE SA_LABEL_ADMIN.CREATE_LABEL('my_ols',20,'TT::DN',TRUE);
EXECUTE SA_LABEL_ADMIN.CREATE_LABEL('my_ols',10,'TT::HN',TRUE);
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
exec SA_USER_ADMIN.SET_USER_LABELS('MY_OLS','NV01','TT::HN');
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