﻿use HYT
GO

-- ADMIN 
EXEC sp_addlogin 'HYT_ADMIN', '12345', 'HYT';  
GO

EXEC sp_addsrvrolemember 'HYT_ADMIN', 'sysadmin';  
GO

-- VODANH
EXEC sp_addlogin 'HYT_VODANH', '12345', 'HYT';  

CREATE USER VODANH FOR LOGIN HYT_VODANH

GRANT SELECT, INSERT ON dbo.TAIKHOAN TO VODANH 
GRANT EXECUTE ON OBJECT::SP_KTTenDangNhap TO VODANH
GRANT EXECUTE ON OBJECT::SP_KTMatKhau TO VODANH
GRANT EXECUTE ON OBJECT::Sp_DangNhap TO VODANH
GRANT EXECUTE ON OBJECT::Sp_TaoTK_KH TO VODANH
GRANT SELECT, INSERT ON KHACHHANG TO VODANH
GO

--GRANT EXECUTE ON OBJECT::Sp_DangNhap TO VODANH
GO

-- QUANTRI
EXEC sp_addlogin 'HYT_QT', '12345', 'HYT';  

CREATE USER QUANTRI FOR LOGIN HYT_QT


GRANT SELECT, INSERT, UPDATE, DELETE ON SANPHAM TO QUANTRI
GRANT SELECT, INSERT, UPDATE, DELETE ON LUUVETGIA TO QUANTRI
GRANT SELECT ON LICHSUNHAP TO QUANTRI
GRANT SELECT ON DONHANG TO QUANTRI
GRANT SELECT ON CT_DONHANG TO QUANTRI
GRANT EXECUTE ON OBJECT::SP_QT_TatCaLSN TO QUANTRI
GRANT EXECUTE ON OBJECT::SP_QT_TimLSNTheoMaSP TO QUANTRI
GRANT EXECUTE ON OBJECT::SP_QT_TimLSNTheoNgayNhap TO QUANTRI
GRANT EXECUTE ON OBJECT::SP_QT_TatCaLSX TO QUANTRI
GRANT EXECUTE ON OBJECT::SP_QT_TimLSXTheoMaSP TO QUANTRI
GRANT EXECUTE ON OBJECT::SP_QT_TimLSXTheoNgayLap TO QUANTRI
GRANT EXECUTE ON OBJECT::SP_QT_TatCaSP TO QUANTRI

GRANT EXECUTE ON OBJECT::SP_QT_THEMSP TO QUANTRI
GRANT EXECUTE ON OBJECT::SP_QT_XOASP TO QUANTRI
GRANT EXECUTE ON OBJECT::SP_QT_CAPNHAT TO QUANTRI
GO

-- KHACHHANG
EXEC sp_addlogin 'HYT_KHACHHANG', '12345', 'HYT';  

CREATE USER KHACHHANG FOR LOGIN HYT_KHACHHANG

GRANT SELECT, INSERT, UPDATE ON KHACHHANG TO KHACHHANG
GRANT SELECT ON SANPHAM(MASP, TENSP, GIAGOC, THANHPHANCHINH, KHUYENMAI, MOTA, CHITIETSP, HINHANH, SOLUONGTON) TO KHACHHANG
GRANT SELECT ON GIAMGIA(GIAGIAM,MASP) TO KHACHHANG
GRANT SELECT ON TAIKHOAN(ID,SDT,DIACHI) TO KHACHHANG
GRANT SELECT,INSERT ON DONHANG TO KHACHHANG
GRANT EXECUTE ON OBJECT::Sp_KH_TimKiemSP TO KHACHHANG
GRANT EXECUTE ON OBJECT::Sp_ThemDH TO KHACHHANG
GRANT EXECUTE ON OBJECT::Sp_ThemCTDH TO KHACHHANG
GRANT EXECUTE ON OBJECT::Sp_KH_LayThongTinDH TO KHACHHANG
GRANT EXECUTE ON OBJECT::Sp_KH_LayThongTinCTDH TO KHACHHANG
GO

-- QUANLY
EXEC sp_addlogin 'HYT_QL', '12345', 'HYT';  

CREATE USER QUANLY FOR LOGIN HYT_QL

------
GRANT SELECT ON DONHANG TO QUANLY
GRANT SELECT ON CT_DONHANG TO QUANLY
GRANT SELECT ON SANPHAM TO QUANLY
----

GRANT EXECUTE ON OBJECT::SP_QL_DSBC TO QUANLY
GRANT EXECUTE ON OBJECT::SP_QL_DSBC_NUM TO QUANLY
GRANT EXECUTE ON OBJECT::SP_QL_TONGDHDB TO QUANLY
GRANT EXECUTE ON OBJECT::SP_QL_TONG_SLSP_DB TO QUANLY
GRANT EXECUTE ON OBJECT::SP_QL_TONG_CHIPHI TO QUANLY

GRANT EXECUTE ON OBJECT::SP_QL_DOANHTHU_BANCHAY TO QUANLY
GRANT EXECUTE ON OBJECT::SP_QL_TatCaSP  TO QUANLY
GRANT EXECUTE ON OBJECT::SP_QL_TimSPByName TO QUANLY
GRANT EXECUTE ON OBJECT::SP_QL_UpdateGiaGiam  TO QUANLY

GRANT EXECUTE ON OBJECT::SP_QL_DSBanCham TO QUANLY
GRANT EXECUTE ON OBJECT::SP_QL_DSBanCham_NUM TO QUANLY
GRANT EXECUTE ON OBJECT::SP_QL_DOANHTHU_BANCHAM TO QUANLY

GRANT EXECUTE ON OBJECT::SP_QL_DSBH TO QUANLY
GRANT EXECUTE ON OBJECT::SP_QL_DSDH TO QUANLY
GRANT EXECUTE ON OBJECT::SP_QL_LOINHUAN_BANDUOC TO QUANLY
GRANT EXECUTE ON OBJECT::SP_QL_DOANHTHU_BANDUOC TO QUANLY

GRANT EXECUTE ON OBJECT::Sp_TatCaSanPham TO QUANLY
GRANT EXECUTE ON OBJECT::Sp_KH_TimKiemSP TO QUANLY

GRANT EXECUTE ON OBJECT::SP_QuanLy_XuatNgayLamViecCuaNVTrongThang TO QUANLY
GRANT EXECUTE ON OBJECT::SP_QuanLy_SoNgayDiLamTrongThang TO QUANLY
GRANT EXECUTE ON OBJECT::SP_QuanLy_HieuSuatNVTrongThang TO QUANLY
GO

-- NHANVIEN
EXEC sp_addlogin 'HYT_NHANVIEN', '12345', 'HYT';  

CREATE USER NHANVIEN FOR LOGIN HYT_NHANVIEN

GRANT SELECT ON TAIKHOAN TO NHANVIEN
GRANT SELECT, INSERT ON NHANVIEN TO NHANVIEN 
GRANT SELECT ON SANPHAM(MASP, TENSP, GIAGOC, KHUYENMAI, MOTA, CHITIETSP, HINHANH, SOLUONGTON) TO NHANVIEN
GRANT EXECUTE ON OBJECT::Sp_ThemDH TO NHANVIEN
GRANT EXECUTE ON OBJECT::Sp_KH_TimKiemSP TO NHANVIEN
GRANT SELECT ON GIAMGIA(GIAGIAM,MASP) TO NHANVIEN
GRANT SELECT ON KHACHHANG(TENKH,ID) TO NHANVIEN
GRANT SELECT ON TAIKHOAN(EMAIL,SDT,ID,DIACHI) TO NHANVIEN
GRANT SELECT,INSERT ON DONHANG TO  NHANVIEN
GRANT SELECT ON KHACHHANG(MAKH,STK) TO  NHANVIEN
GRANT EXECUTE ON OBJECT::Sp_ThemDH TO NHANVIEN
GRANT EXECUTE ON OBJECT::Sp_ThemCTDH TO NHANVIEN
GRANT EXECUTE ON OBJECT::Sp_TaoTK_KH TO NHANVIEN
GO

--NHÂN SỰ
EXEC sp_addlogin 'HYT_NHANSU', '12345', 'HYT';  

CREATE USER NHANSU FOR LOGIN HYT_NHANSU
GO

GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.NHANVIEN TO NHANSU
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.LUONG TO NHANSU
GRANT SELECT, DELETE ON dbo.DIEMDANH TO NHANSU
GRANT SELECT, UPDATE ON dbo.LICHSUNHAP TO NHANSU
GRANT SELECT, UPDATE ON dbo.TAIKHOAN TO NHANSU
GRANT SELECT, UPDATE ON dbo.CHINHANH TO NHANSU


GRANT EXECUTE ON OBJECT::dbo.SP_NhanSu_CapNhatNV TO NHANSU
GRANT EXECUTE ON OBJECT::dbo.SP_NhanSu_ThemNV TO NHANSU
GRANT EXECUTE ON OBJECT::dbo.SP_NhanSu_TimNVtheoCN TO NHANSU
GRANT EXECUTE ON OBJECT::dbo.SP_NhanSu_XoaNV TO NHANSU

--TAIXE
EXEC sp_addlogin 'HYT_TAIXE', '12345', 'HYT';  

CREATE USER TAIXE FOR LOGIN HYT_TAIXE
GO

-- TẠO ROLE
EXEC SP_ADDROLE 'ROLE_USERS'

-- ADD THÊM USER VÀO ROLE NÀY
EXEC sp_addrolemember 'ROLE_USERS', 'QUANTRI'
EXEC sp_addrolemember 'ROLE_USERS', 'KHACHHANG'
EXEC sp_addrolemember 'ROLE_USERS', 'QUANLY'
EXEC sp_addrolemember 'ROLE_USERS', 'NHANVIEN'
EXEC sp_addrolemember 'ROLE_USERS', 'NHANSU'
EXEC sp_addrolemember 'ROLE_USERS', 'TAIXE'
-- CẤP QUYỀN CHO ROLE
GRANT SELECT, UPDATE ON TAIKHOAN(MATKHAU) TO ROLE_USERS