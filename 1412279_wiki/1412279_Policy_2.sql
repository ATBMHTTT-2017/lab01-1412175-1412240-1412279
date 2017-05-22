
-- YEU CAU 2: DANH CHO GIAMDOC: duoc phep xem thong tin du an gom :
--maDAn,TenDuan,KinhPhi, TenPhongChuTri, TenChiNhanh, tenTruongDuAn,TongChi
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

