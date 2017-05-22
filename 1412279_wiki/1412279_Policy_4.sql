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
        DBMS_SESSION.set_context('quantri','POSITION','NHANVIEN');
    END;
   END set_context;
End context_package;


--cap quyen cho moi nguoi dung deu su dung duoc package tren

GRANT EXECUTE ON context_package TO PUBLIC;
CREATE OR REPLACE PUBLIC SYNONYM context_package FOR quantri.context_package;

-- TAO TRIGGER EP BUOC SU DUNG NGU CANH SAU KHI DANG NHAP
drop trigger quantri.set_security_context;
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
exec DBMS_RLS.DROP_POLICY('QUANTRI','NHANVIEN','sec_Luong');
BEGIN
DBMS_RLS.ADD_POLICY(
          object_schema => 'quantri',
          object_name => 'nhanvien',
          policy_name => 'sec_Luong',
          policy_function => 'xemLuong',                  
          statement_types => 'select',
          sec_relevant_cols => 'luong',
          sec_relevant_cols_opt => DBMS_RLS.ALL_ROWS
  );
END;
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
exec DBMS_RLS.DROP_POLICY('QUANTRI','NHANVIEN','sec_Nhanvien');
BEGIN
DBMS_RLS.ADD_POLICY(
          object_schema => 'quantri',
          object_name => 'nhanvien',
          policy_name => 'sec_Nhanvien',
          policy_function => 'xemNhanvien'            
  );
END;