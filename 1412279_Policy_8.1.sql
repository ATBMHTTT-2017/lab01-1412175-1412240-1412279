--Yeu cau: Nhan vien phu trach du cac linh vuc chi tieu, co cap do phu hop moi 
-- duoc phep truy xuat du lieu thu chi

--[conn quantri/quantri]

--1: Tao ham chinh sach lien quan den nhanvien
begin
SA_SYSDBA.CREATE_POLICY (
  policy_name => 'nhanvien_ols',
  column_name => 'nhanvien_label'
  );
end;
--2: Sau khi chinh sach duoc khai bao, mot quyen dba ung voi chinh sach se duoc tao
-- ta cap quyen nay cho quantri; bang quyen lbacsys
EXECUTE SA_USER_ADMIN.SET_USER_PRIVS('NHANVIEN_OLS','quantri','FULL,PROFILE_ACCESS');
GRANT NHANVIEN_OLS_DBA TO quantri;

--3.Dinh nghia cac thanh phan cua Label:
BEGIN
sa_components.create_level
(policy_name => 'NHANVIEN_OLS',
long_name => 'khong nhay cam',
short_name => 'KNC',
level_num => 9100);
END;
BEGIN
sa_components.create_level
(policy_name => 'NHANVIEN_OLS',
long_name => 'nhay cam',
short_name => 'NC',
level_num => 9200);
END;
BEGIN
sa_components.create_level
(policy_name => 'NHANVIEN_OLS',
long_name => 'BI MAT',
short_name => 'BMT',
level_num => 9300);
END;

-- Ta tao them 3 compartment cho phu hop voi loai chi tieu: L,QL,VL.
-- Level cua du lieu co 3 cap bac, nhu da duoc dinh nghia

BEGIN
  SA_COMPONENTS.CREATE_COMPARTMENT (
   policy_name     => 'nhanvien_ols',
   comp_num        => '130',
   short_name      => 'L',
   long_name       => 'Luong');
END;
BEGIN
  SA_COMPONENTS.CREATE_COMPARTMENT (
   policy_name     => 'nhanvien_ols',
   comp_num        => '120',
   short_name      => 'QL',
   long_name       => 'Quan Ly');
END;
BEGIN
  SA_COMPONENTS.CREATE_COMPARTMENT (
   policy_name     => 'nhanvien_ols',
   comp_num        => '110',
   short_name      => 'VL',
   long_name       => 'Vat lieu');
END;



--4. Gan Policy cho Table: CHITIEU
EXEC SA_POLICY_ADMIN.REMOVE_TABLE_POLICY('NHANVIEN_OLS','QUANTRI','CHITIEU');
BEGIN
 SA_POLICY_ADMIN.APPLY_TABLE_POLICY(
     policy_name    => 'NHANVIEN_OLS',
     schema_name    => 'QUANTRI',
     table_name     => 'CHITIEU',
     table_options  => 'NO_CONTROL' 
     );
 END;
 
 --5:Tao cac Nhan can thiet, la su ket hop giua 3 thanh phan, sao cho nhan vien
 -- co cap do phu hop moi duoc xem thong tin chi tieu
BEGIN
  sa_label_admin.create_label
(policy_name => 'NHANVIEN_OLS',
label_tag => 1,
label_value => 'BMT:L,QL,VL');
END;
BEGIN
  sa_label_admin.create_label
(policy_name => 'NHANVIEN_OLS',
label_tag => 2,
label_value => 'BMT:L');
END;
BEGIN
  sa_label_admin.create_label
(policy_name => 'NHANVIEN_OLS',
label_tag => 3,
label_value => 'BMT:QL');
END;
BEGIN
  sa_label_admin.create_label
(policy_name => 'NHANVIEN_OLS',
label_tag => 4,
label_value => 'BMT:VL');
END;
BEGIN
  sa_label_admin.create_label
(policy_name => 'NHANVIEN_OLS',
label_tag => 5,
label_value => 'NC:L');
END;
BEGIN
  sa_label_admin.create_label
(policy_name => 'NHANVIEN_OLS',
label_tag => 6,
label_value => 'NC:QL');
END;
BEGIN
  sa_label_admin.create_label
(policy_name => 'NHANVIEN_OLS',
label_tag => 7,
label_value => 'NC:VL');
END;
BEGIN
  sa_label_admin.create_label
(policy_name => 'NHANVIEN_OLS',
label_tag => 8,
label_value => 'KNC:L');
END;
BEGIN
  sa_label_admin.create_label
(policy_name => 'NHANVIEN_OLS',
label_tag => 9,
label_value => 'KNC:QL');
END;
BEGIN
  sa_label_admin.create_label
(policy_name => 'NHANVIEN_OLS',
label_tag => 11,
label_value => 'KNC:VL');
END;


--6: gan Nhan can thiet cho du lieu trong bang CHITIEU
-- TU DU AN 1 DEN 3 CO LEVEL LA KHONG NHAY CAM
-- DU AN 4 VA 5 CO LEVEL LA BI MAT
UPDATE CHITIEU SET nhanvien_label=CHAR_TO_LABEL('nhanvien_OLS','KNC:L')
    WHERE tenchitieu in('Luong') and duAn<4;
UPDATE CHITIEU SET nhanvien_label=CHAR_TO_LABEL('nhanvien_OLS','BMT:L')
    WHERE tenchitieu in('Luong') and duAn>3;
UPDATE CHITIEU SET nhanvien_label=CHAR_TO_LABEL('nhanvien_OLS','KNC:QL')
    WHERE tenchitieu in('Quan ly') and duAn<4;
UPDATE CHITIEU SET nhanvien_label=CHAR_TO_LABEL('nhanvien_OLS','BMT:QL')
    WHERE tenchitieu in('Quan ly') and duAn>3;
UPDATE CHITIEU SET nhanvien_label=CHAR_TO_LABEL('nhanvien_OLS','KNC:VL')
    WHERE tenchitieu in('Vat lieu') and duAn<4;
UPDATE CHITIEU SET nhanvien_label=CHAR_TO_LABEL('nhanvien_OLS','BMT:VL')
    WHERE tenchitieu in('Vat lieu') and duAn>3;
    
--7: GAN NHAN CAN THIET CHO CAC NHANVIEN PHU TRACH CHI TIEU DUOC PHAN CONG TRONG 
-- DU AN. 
-- VI DU TAT CA CAC NHAN VIEN DUOC DOC DU LIEU O LEVEL NHAY CAM, CAC QUAN LI DUOC DOC 
-- DU LIEU O LEVEL BI MAT
-- GAN NHAN CHO TRUONG 5 DU AN 
exec SA_USER_ADMIN.SET_USER_LABELS('NHANVIEN_OLS','NV06','BMT:L,QL,VL');
exec SA_USER_ADMIN.SET_USER_LABELS('NHANVIEN_OLS','NV09','BMT:L,QL,VL');
exec SA_USER_ADMIN.SET_USER_LABELS('NHANVIEN_OLS','NV12','BMT:L,QL,VL');
exec SA_USER_ADMIN.SET_USER_LABELS('NHANVIEN_OLS','NV15','BMT:L,QL,VL');
exec SA_USER_ADMIN.SET_USER_LABELS('NHANVIEN_OLS','NV18','BMT:L,QL,VL');
-- GAN NHAN CHO 5 THANH VIEN MOI DU AN
exec SA_USER_ADMIN.SET_USER_LABELS('NHANVIEN_OLS','NV07','NC:L,QL,VL');
exec SA_USER_ADMIN.SET_USER_LABELS('NHANVIEN_OLS','NV10','NC:L,QL,VL');
exec SA_USER_ADMIN.SET_USER_LABELS('NHANVIEN_OLS','NV13','NC:L,QL,VL');
exec SA_USER_ADMIN.SET_USER_LABELS('NHANVIEN_OLS','NV16','NC:L,QL,VL');
exec SA_USER_ADMIN.SET_USER_LABELS('NHANVIEN_OLS','NV19','NC:L,QL,VL');
-- 8: Re-apply lai chinh sach

EXEC SA_POLICY_ADMIN.REMOVE_TABLE_POLICY('NHANVIEN_OLS','QUANTRI','CHITIEU');
BEGIN
 SA_POLICY_ADMIN.APPLY_TABLE_POLICY(
     policy_name    => 'NHANVIEN_OLS',
     schema_name    => 'QUANTRI',
     table_name     => 'CHITIEU',
     table_options  => 'READ_CONTROL,WRITE_CONTROL' 
     );
 END;
 
 --nhu vay cac nhan vien binh thuong se khong doc duoc chi tieu cua du an 4 va 5,
 --chi co cac truong du an moi doc duoc cac thong tin du an 4 va 5
 




