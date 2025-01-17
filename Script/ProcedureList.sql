﻿USE HYT
GO

----SP phần của Đức

-- DROP PROC SP_KTTenDangNhap
-- Kiểm tra tên đăng nhập
CREATE PROC SP_KTTenDangNhap
	@TENDN VARCHAR(50)
AS
BEGIN	
	-- kiểm tra	
	IF EXISTS (SELECT TENDN FROM TAIKHOAN WHERE TENDN = @TENDN)
	RETURN 1
	ELSE RETURN 0
END
GO

-- DROP PROC SP_KTMatKhau
-- Kiểm tra mật khẩu
CREATE PROC SP_KTMatKhau
	@TENDN VARCHAR(50),
	@MATKHAU  VARCHAR(50)
AS
BEGIN	
	-- kiểm tra	
	IF EXISTS (SELECT MATKHAU FROM TAIKHOAN WHERE TENDN = @TENDN AND MATKHAU = @MATKHAU)
	RETURN 1
	ELSE RETURN 0
END
GO

-- DROP PROC Sp_DangNhap
-- Xử lí đăng nhập tài khoản
CREATE PROC Sp_DangNhap
	@TENDN VARCHAR(50),
	@MATKHAU VARCHAR(50),
	@ID VARCHAR(15) OUTPUT,
	@LOAITK INT OUTPUT
AS
BEGIN	
	SET @ID = 'NULL'

	-- lấy mã tài khoản		
	SET @ID = (SELECT ID
				FROM TAIKHOAN
				WHERE TENDN = @TENDN
				AND MATKHAU = @MATKHAU)

	-- lấy loại tài khoản		
	SET @LOAITK = (SELECT LOAITK
				FROM TAIKHOAN
				WHERE TENDN = @TENDN
				AND MATKHAU = @MATKHAU)

	-- xử lí đăng nhập
	if (@ID != 'NULL')
	BEGIN
		PRINT N'Đăng nhập thành công'
		RETURN 1
	END
	ELSE RETURN 0	
END
GO

-- DROP PROC Sp_KH_TimKiemSP
-- Xử lí tìm kiếm sản phẩm
CREATE PROC Sp_KH_TimKiemSP
	@TUKHOA NVARCHAR(50)	
AS
BEGIN	

	SELECT MASP, TENSP, THANHPHANCHINH ,GIAGOC, KHUYENMAI, MOTA, CHITIETSP, HINHANH, SOLUONGTON
	FROM SANPHAM
	WHERE THANHPHANCHINH LIKE N'%'+ @TUKHOA + '%' 	
END
GO

-- DROP PROC Sp_ThemDH
-- Xử lí thêm đơn hàng
CREATE PROC Sp_ThemDH
	@MADH VARCHAR(15),
	@MAKH VARCHAR(15) = NULL,
	@MANV VARCHAR(15) = NULL,
	@TENNGUOINHAN NVARCHAR(255) ,
	@DIACHI_NGUOINHAN NVARCHAR(255) ,
	@SDT_NGUOINHAN NVARCHAR(255) ,
	@PHIVANCHUYEN DECIMAL(19,4) ,
	@HINHTHUCTHANHTOAN INT ,
	@NGAYMUONGIAO DATETIME ,
	@NGAYLAP DATE ,
	@TINHTRANG INT,
	@TONGTIEN DECIMAL(19,4) 	
AS
BEGIN	
	--Kiểm tra mã DH (KIỂM TRA KHÓA CHÍNH)
	IF EXISTS (SELECT MADH FROM DONHANG WHERE MADH = @MADH)
	BEGIN
		PRINT N'MÃ DH ĐÃ TỒN TẠI'
		RETURN 0
	END

	--Kiểm tra mã KH	
	IF (@MAKH != NULL)
		IF (@MAKH != NULL AND NOT EXISTS (SELECT MAKH FROM KHACHHANG WHERE MAKH = @MAKH))
		BEGIN
			PRINT N'MÃ KH KHÔNG TỒN TẠI'
			RETURN -1
		END

	--Kiểm tra mã NV	
	IF (@MANV != NULL)
		IF (@MANV != NULL AND NOT EXISTS (SELECT MANV FROM NHANVIEN WHERE MANV = @MANV))
		BEGIN
			PRINT N'MÃ NV KHÔNG TỒN TẠI'
			RETURN -2
		END

	-- XỬ LÍ THÊM DH
	INSERT INTO DONHANG
	VALUES
	(@MADH,@MAKH,@MANV,N''+@TENNGUOINHAN+'',N''+@DIACHI_NGUOINHAN+'',@SDT_NGUOINHAN,@PHIVANCHUYEN,@HINHTHUCTHANHTOAN
	,@NGAYMUONGIAO,@NGAYLAP,@TINHTRANG,@TONGTIEN)
	RETURN 1
END
GO

-- DROP PROC Sp_ThemCTDH
-- Xử lí thêm chi tiết đơn hàng
CREATE PROC Sp_ThemCTDH
	@MADH VARCHAR(15),
	@MASP VARCHAR(15),
	@SOLUONG INT ,
	@THANHTIEN DECIMAL(19,4)
AS
BEGIN	
	--Kiểm tra mã SP
	IF NOT EXISTS (SELECT MASP FROM SANPHAM WHERE MASP = @MASP)
	BEGIN
		PRINT N'MÃ SP KHÔNG TỒN TẠI'
		RETURN 0
	END

	--Kiểm tra mã DH
	IF NOT EXISTS (SELECT MADH FROM DONHANG WHERE MADH = @MADH)
	BEGIN
		PRINT N'MÃ DH KHÔNG TỒN TẠI'
		RETURN -1
	END

	-- XỬ LÍ THÊM CTDH
	INSERT INTO CT_DONHANG
	VALUES
	(@MADH, @MASP, @SOLUONG, @THANHTIEN )
	RETURN 1
END
GO


-- DROP PROC Sp_KH_LayThongTinDH
-- Xử lí lấy thông tin đơn hàng
CREATE PROC Sp_KH_LayThongTinDH
	@MAKH VARCHAR(15)	
AS
BEGIN	
	--Kiểm tra mã KH
	IF NOT EXISTS (SELECT MAKH FROM KHACHHANG WHERE MAKH = @MAKH)
	BEGIN
		PRINT N'MÃ KH KHÔNG TỒN TẠI'
		RETURN 0
	END
	
	-- lấy thông tin
	SELECT * FROM DONHANG WHERE MAKH = @MAKH
	RETURN 1
END
GO


-- DROP PROC Sp_KH_LayThongTinCTDH
-- Xử lí lấy thông tin chi tiết đơn hàng
CREATE PROC Sp_KH_LayThongTinCTDH
	@MADH VARCHAR(15)	
AS
BEGIN	
	--Kiểm tra mã DH
	IF NOT EXISTS (SELECT MADH FROM DONHANG WHERE MADH = @MADH)
	BEGIN
		PRINT N'MÃ DH KHÔNG TỒN TẠI'
		RETURN 0
	END
	
	-- lấy thông tin
	SELECT CTDH.MADH, CTDH.MASP , SP.TENSP ,SP.GIAGOC, SP.KHUYENMAI, GG.GIAGIAM, CTDH.SOLUONG, CTDH.THANHTIEN, SP.HINHANH
	FROM CT_DONHANG CTDH, SANPHAM SP, GIAMGIA GG
	WHERE CTDH.MADH = @MADH
	AND SP.MASP = CTDH.MASP
	AND GG.MASP = SP.MASP
	RETURN 1
END
GO

-- DROP PROC Sp_TaoTK_KH
-- Xử lí tạo tài khoản khách hàng
CREATE PROC Sp_TaoTK_KH
	@ID VARCHAR(15),
	@TENDN VARCHAR(50) ,
	@MATKHAU VARCHAR(50) ,
	@LOAITK INT ,
	@SDT CHAR(15) ,
	@EMAIL VARCHAR(255) ,
	@DIACHI NVARCHAR(255) ,
	@MAKH VARCHAR(15),
	@TENKH NVARCHAR(50) ,
	@STK VARCHAR(30) = NULL
AS
BEGIN	
	--Kiểm tra mã KH
	IF EXISTS (SELECT MAKH FROM KHACHHANG WHERE MAKH = @MAKH)
	BEGIN
		PRINT N'MÃ KH ĐÃ TỒN TẠI'
		RETURN 0
	END

	--Kiểm tra ID
	IF EXISTS (SELECT ID FROM TAIKHOAN WHERE ID = @ID)
	BEGIN
		PRINT N'ID ĐÃ TỒN TẠI'
		RETURN -1
	END
	
	-- xử lí thêm bảng TAIKHOAN
	INSERT INTO TAIKHOAN
	VALUES
	(@ID,@TENDN,@MATKHAU,@LOAITK,@SDT,@EMAIL,N''+@DIACHI+'')

	-- xử lí thêm bảng KHACHHANG
	INSERT INTO KHACHHANG
	VALUES
	(@MAKH,@ID,@TENKH,@STK)

	RETURN 1
END
GO

-- DROP PROC Sp_TatCaSanPham
-- Xử lí lấy thông tin tất cả sản phẩm
CREATE PROC Sp_TatCaSanPham
AS
BEGIN
	-- xử lí lấy thông tin
	SELECT SP.MASP, SP.TENSP, SP.THANHPHANCHINH ,SP.SOLUONGTON, SP.GIAGOC, SP.KHUYENMAI, LSN.GIANHAP, GG.GIAGIAM, SP.HINHANH
	FROM SANPHAM SP, LICHSUNHAP LSN, GIAMGIA GG
	WHERE SP.MASP = LSN.MASP
	AND SP.MASP = GG.MASP
               

	RETURN 1
END
GO

--------------------------------------------------------------

--------------------------------------------------------------

----------- Phần SP của Tuấn

-- Phân hệ Nhân Sự

-- Thêm nhân viên mới
CREATE PROCEDURE SP_NhanSu_ThemNV
	@MANV VARCHAR(15),
	@ID VARCHAR(15),
	@TENNV NVARCHAR(255),
	@CHINHANHLV VARCHAR(15),
	@LOAINV INT,
	@LUONG DECIMAL(19,4)
AS
BEGIN
	-- Them thông tin vào bảng NHANVIEN
	INSERT dbo.NHANVIEN (MANV, ID, TENNV, CHINHANHLV, LOAINV)
	VALUES( @MANV, @ID, @TENNV, @CHINHANHLV, @LOAINV)
	
	-- Them thông tin về lương của nhân viên mới vào bảng LUONG
	INSERT dbo.LUONG(MANV, NGAY, LUONG)
	VALUES(@MANV, GETDATE(), @LUONG)
END
GO

-- Cập nhật thông tin nhân viên
CREATE PROCEDURE SP_NhanSu_CapNhatNV
	@MANV VARCHAR(15),
	@ID VARCHAR(15),
	@TENNV NVARCHAR(255),
	@CHINHANHLV VARCHAR(15),
	@LOAINV INT,
	@LUONG DECIMAL(19,4)
AS
BEGIN
	-- Cập nhật bảng NHANVIEN
	UPDATE NHANVIEN 
	SET 
		ID = @ID,
		TENNV = @TENNV,
		CHINHANHLV = @CHINHANHLV,
		LOAINV = @LOAINV
	WHERE MANV = @MANV
	
	-- Cập nhật bảng LUONG
	UPDATE dbo.LUONG
	SET
		LUONG = @LUONG,
		NGAY = GETDATE()
	WHERE MANV = @MANV
END
GO

-- Xóa 1 một nhân viên
CREATE PROCEDURE SP_NhanSu_XoaNV
	@MANV VARCHAR(15)
AS
BEGIN
	UPDATE dbo.LICHSUNHAP SET NGUOINHAP=NULL WHERE NGUOINHAP=@MANV
	DELETE dbo.DIEMDANH WHERE MANV = @MANV
	DELETE dbo.LUONG WHERE MANV = @MANV
	DELETE dbo.NHANVIEN WHERE MANV = @MANV
END
GO

-- Tìm danh sách nhân viên theo chi nhánh
CREATE PROCEDURE SP_NhanSu_TimNVtheoCN
	@MACN VARCHAR(15)
AS
BEGIN
	SELECT NV.MANV, NV.ID, NV.TENNV, NV.CHINHANHLV, NV.LOAINV ,L.LUONG
	FROM NHANVIEN NV, LUONG L
	WHERE NV.MANV = L.MANV
	AND NV.CHINHANHLV = @MACN
	GROUP BY NV.MANV, L.MANV, L.NGAY, NV.ID, NV.TENNV, NV.CHINHANHLV, NV.LOAINV, L.LUONG
	HAVING ABS(DATEDIFF(day, GETDATE(), L.NGAY)) = (SELECT MIN(ABS(DATEDIFF(day, GETDATE(), L.NGAY))) FROM LUONG L1 WHERE L1.MANV = L.MANV GROUP BY L1.MANV, L1.NGAY)
END
GO

---- Phân hệ Quản lý (Sử dụng partition)

-- Xuất danh sách các nhân viên và ngày làm việc của nhân viên trong tháng
CREATE PROC SP_QuanLy_XuatNgayLamViecCuaNVTrongThang
	@THUTU INT
AS
BEGIN
	SELECT NV.MANV, NV.TENNV, NV.CHINHANHLV, NGAY
	FROM NHANVIEN NV, DIEMDANH 
	WHERE NV.MANV = dbo.DIEMDANH.MANV
	AND $Partition.[DiemDanh_PartitionFunction] (NGAY) IN (@THUTU);
END
GO

-- Số ngày đi làm của nhân viên trong tháng
CREATE PROC SP_QuanLy_SoNgayDiLamTrongThang
	@MANV VARCHAR(15),
	@THUTU INT,
	@SONGAYLAM INT OUTPUT
AS
BEGIN
	SELECT @SONGAYLAM = COUNT(*)
	FROM dbo.DIEMDANH
	WHERE MANV = @MANV
	AND $Partition.[DiemDanh_PartitionFunction] (NGAY) IN (@THUTU);
END
GO

-- Số lượng đơn hàng, doanh thu, số hàng hóa/nhân viên trong 1 tháng
-- drop proc SP_QuanLy_HieuSuatNVTrongThang
CREATE PROC SP_QuanLy_HieuSuatNVTrongThang
	@MANV VARCHAR(15),
	@THANG INT,
	@NAM INT,
	@SOLUONGDON INT OUTPUT,
	@SOLUONGHANG INT OUTPUT,
	@DOANHTHU DECIMAL(19,4) OUTPUT
AS
BEGIN
	
	DECLARE @MADH VARCHAR(15)
	-- Số đơn hàng và doanh thu
	SELECT @SOLUONGDON = COUNT(*) ,@DOANHTHU = SUM(TONGTIEN), @MADH = MADH
	FROM dbo.DONHANG 
	WHERE $Partition.[DonHangNgayNhap_PartitionFunction] (NGAYLAP) IN (@THANG + 1)
	AND MANV = @MANV
	GROUP BY MANV, MADH, NGAYLAP
	
	-- Số lượng hàng bán được
	SELECT @SOLUONGHANG = SUM(CT.SOLUONG)
	FROM dbo.CT_DONHANG CT
	WHERE CT.MADH = @MADH

END
GO


--------------------------------------------------------------

--------------------------------------------------------------

----------- Phần SP của Huy

--
--  LỊCH SỬ NHẬP
--
-- Lấy tât cả lịch sử nhập của sản phẩm

CREATE PROCEDURE SP_QT_TatCaLSN
AS
BEGIN
	SELECT LSN.MASP,LSN.NGAYNHAP,NV.TENNV,LSN.SOLUONG,LSN.GIANHAP FROM LICHSUNHAP LSN, NHANVIEN NV
	WHERE LSN.NGUOINHAP = NV.MANV
	ORDER BY LSN.NGAYNHAP DESC, LSN.MASP ASC
END
GO
-- Tìm lịch sử nhập theo mã sản phẩm
CREATE PROCEDURE SP_QT_TimLSNTheoMaSP
	@MASP VARCHAR(15)
AS
BEGIN
	SELECT LSN.MASP,LSN.NGAYNHAP,NV.TENNV,LSN.SOLUONG,LSN.GIANHAP FROM LICHSUNHAP LSN, NHANVIEN NV
	WHERE LSN.NGUOINHAP = NV.MANV AND LSN.MASP=@MASP 
	ORDER BY LSN.NGAYNHAP DESC, LSN.MASP ASC
END
GO

-- Tìm lịch sử nhập theo theo ngày nhập
CREATE PROCEDURE SP_QT_TimLSNTheoNgayNhap
	@NGAYNHAP DATE
AS
BEGIN
	SELECT LSN.MASP,LSN.NGAYNHAP,NV.TENNV,LSN.SOLUONG, LSN.GIANHAP FROM LICHSUNHAP LSN, NHANVIEN NV
	WHERE LSN.NGUOINHAP = NV.MANV AND LSN.NGAYNHAP = @NGAYNHAP 
	ORDER BY LSN.NGAYNHAP DESC, LSN.MASP ASC
END
GO
--
--  LỊCH SỬ XUẤT
--
-- Lấy lịch sử xuất của sản phẩm
CREATE PROCEDURE SP_QT_TatCaLSX
AS
BEGIN
	SELECT CTDH.MASP, DH.NGAYLAP, CTDH.SOLUONG FROM DONHANG DH, CT_DONHANG CTDH
WHERE DH.MADH=CTDH.MADH
ORDER BY DH.NGAYLAP DESC, CTDH.MASP ASC
END
GO

-- Lấy lịch sử xuất theo masp
CREATE PROCEDURE SP_QT_TimLSXTheoMaSP
	@MASP VARCHAR(15)
AS
BEGIN
	SELECT CTDH.MASP, DH.NGAYLAP, CTDH.SOLUONG FROM DONHANG DH, CT_DONHANG CTDH
WHERE DH.MADH=CTDH.MADH AND CTDH.MASP=@MASP
ORDER BY DH.NGAYLAP DESC, CTDH.MASP ASC
END
GO

-- Lấy lịch sử xuất của sản phẩm theo ngày
CREATE PROCEDURE SP_QT_TimLSXTheoNgayLap 
	@NGAYNHAP DATE
AS
BEGIN
	SELECT CTDH.MASP, DH.NGAYLAP, CTDH.SOLUONG FROM DONHANG DH, CT_DONHANG CTDH
WHERE DH.MADH=CTDH.MADH AND DH.NGAYLAP = @NGAYNHAP
ORDER BY DH.NGAYLAP DESC, CTDH.MASP ASC
END
GO

--
--  QUẢN TRỊ - TẤT CẢ SP
--
--DROP PROCEDURE SP_QT_TatCaSP
CREATE PROCEDURE SP_QT_TatCaSP 
AS
BEGIN
	SELECT SP.MASP,SP.TENSP,SP.THANHPHANCHINH, SP.MOTA,SP.SOLUONGTON,SP.GIAGOC,SP.CHITIETSP,SP.KHUYENMAI,SP.HINHANH FROM SANPHAM SP
	ORDER BY SP.MASP ASC
END
GO


CREATE PROC SP_QT_THEMSP 
	@MASP VARCHAR(15),
	@TENSP NVARCHAR(255),
	@THANHPHANCHINH NVARCHAR(255),
	@HINHANH VARCHAR(255),
	@MOTA NVARCHAR(255),
	@GIAGOC DECIMAL(19,4),
	@CHITIETSP NVARCHAR(255),
	@KHUYENMAI INT,
	@SOLUONGTON INT
AS
	BEGIN	
		INSERT INTO SANPHAM(MASP,TENSP,THANHPHANCHINH,HINHANH,MOTA,GIAGOC,
		CHITIETSP,KHUYENMAI,SOLUONGTON)
		VALUES
		(@MASP,@TENSP,@THANHPHANCHINH,@HINHANH,@MOTA,@GIAGOC,@CHITIETSP,
		@KHUYENMAI,@SOLUONGTON)
	END
GO

CREATE PROC SP_QT_XOASP 
	@MASP VARCHAR(15)
AS
	BEGIN	
		DELETE SANPHAM
		WHERE MASP=@MASP
	END
GO

CREATE PROC SP_QT_CAPNHAT
	@MASP VARCHAR(15),
	@TENSP NVARCHAR(255),
	@THANHPHANCHINH NVARCHAR(255),
	@HINHANH VARCHAR(255),
	@MOTA NVARCHAR(255),
	@GIAGOC DECIMAL(19,4),
	@CHITIETSP NVARCHAR(255),
	@KHUYENMAI INT,
	@SOLUONGTON INT

AS
	BEGIN	
		UPDATE SANPHAM
		SET TENSP=@TENSP,
			THANHPHANCHINH=@THANHPHANCHINH,
			HINHANH=@HINHANH,
			MOTA=@MOTA,
			GIAGOC=@GIAGOC,
			CHITIETSP=@CHITIETSP,
			KHUYENMAI=@KHUYENMAI,
			SOLUONGTON=@SOLUONGTON	
		WHERE MASP=@MASP
	END
GO

--
--  QUẢN LÝ - TẤT CẢ SP
--
--DROP PROC SP_QL_TatCaSP
CREATE PROCEDURE SP_QL_TatCaSP 
AS
BEGIN
	SELECT SP.MASP,SP.TENSP,SP.GIAGOC,SP.KHUYENMAI, GG.GIAGIAM,SP.HINHANH FROM SANPHAM SP, GIAMGIA GG
	WHERE SP.MASP=GG.MASP
	ORDER BY SP.MASP ASC
END
-- Tìm sản phẩm theo tên ở quản lý
--DROP PROC SP_QL_TimSPByName
GO
CREATE PROCEDURE SP_QL_TimSPByName
	@TENSP NVARCHAR(255)
AS
BEGIN
	SELECT SP.MASP,SP.TENSP,SP.GIAGOC,SP.KHUYENMAI, GG.GIAGIAM,SP.HINHANH FROM SANPHAM SP, GIAMGIA GG
	WHERE SP.MASP=GG.MASP AND SP.THANHPHANCHINH like '%' + @TENSP +'%'
	ORDER BY SP.MASP ASC
END

-- Update giá giảm
--DROP PROC SP_QL_TimSPByName
GO
CREATE PROCEDURE SP_QL_UpdateGiaGiam 
	@MASP VARCHAR(15),
	@GIAGIAM DECIMAL(19,4)
AS
BEGIN
	UPDATE GIAMGIA
	SET GIAGIAM=@GIAGIAM
	WHERE MASP=@MASP
END
GO
-----------------------------------------------------------------------
--sp của Bình Minh đẹp trai nhất nhóm
-- DROP PROC SP_QL_DSBC
--proc xem danh sách mặt hàng bán chạy theo tháng
CREATE PROC SP_QL_DSBC @THANG INT, @NAM INT
AS
	BEGIN
		SELECT SP.MASP, SP.TENSP, SP.SOLUONGTON
		FROM SANPHAM SP
		WHERE SP.MASP IN (
			SELECT TOP(30) SP1.MASP
			FROM SANPHAM SP1, DONHANG DH, CT_DONHANG CT
			WHERE SP1.MASP = CT.MASP AND DH.MADH = CT.MADH AND DH.TINHTRANG = 2 AND MONTH(DH.NGAYLAP) = @THANG AND YEAR(DH.NGAYLAP) = @NAM
			GROUP BY SP1.MASP
			ORDER BY SUM(CT.SOLUONG) DESC)
	END
GO

--proc xem SỐ LƯỢNG mặt hàng bán chạy theo tháng
--DROP PROC SP_QL_DSBC_NUM
CREATE PROC SP_QL_DSBC_NUM @THANG INT, @NAM INT
AS
	BEGIN
		SELECT TOP(30) SUM(CT.SOLUONG) AS SLDB
		FROM SANPHAM SP1, DONHANG DH, CT_DONHANG CT
		WHERE SP1.MASP = CT.MASP AND DH.MADH = CT.MADH AND DH.TINHTRANG = 2 AND MONTH(DH.NGAYLAP) = @THANG AND YEAR(DH.NGAYLAP) = @NAM
		GROUP BY SP1.MASP
		ORDER BY SUM(CT.SOLUONG) DESC
	END
GO

--proc xem DOANH THU mặt hàng bán chạy theo tháng
--DROP PROC SP_QL_DOANHTHU_BANCHAY
CREATE PROC SP_QL_DOANHTHU_BANCHAY @THANG INT, @NAM INT
AS
	BEGIN
		SELECT TOP(30) SUM(CT.THANHTIEN) - (SUM(CT.SOLUONG) * LS.GIANHAP) AS DT
		FROM SANPHAM SP1, DONHANG DH, CT_DONHANG CT, LICHSUNHAP LS
		WHERE SP1.MASP = CT.MASP AND DH.MADH = CT.MADH AND DH.TINHTRANG = 2 AND MONTH(DH.NGAYLAP) = @THANG AND YEAR(DH.NGAYLAP) = @NAM
		AND LS.MASP = SP1.MASP AND LS.NGAYNHAP = (SELECT TOP 1 NGAYNHAP
													FROM LICHSUNHAP
													WHERE MASP = SP1.MASP
													ORDER BY NGAYNHAP DESC)
		GROUP BY SP1.MASP, LS.GIANHAP
		ORDER BY SUM(CT.SOLUONG) DESC
	END
GO

--proc xem danh sách mặt hàng bán chậm theo tháng
--DROP PROC SP_QL_DSBanCham
CREATE PROC SP_QL_DSBanCham @THANG INT, @NAM INT
AS
	BEGIN
		SELECT SP.MASP, SP.TENSP, SP.SOLUONGTON
		FROM SANPHAM SP
		WHERE SP.MASP IN (
			SELECT TOP(30) SP1.MASP
			FROM SANPHAM SP1, DONHANG DH, CT_DONHANG CT
			WHERE SP1.MASP = CT.MASP AND DH.MADH = CT.MADH AND DH.TINHTRANG = 2 AND MONTH(DH.NGAYLAP) = @THANG AND YEAR(DH.NGAYLAP) = @NAM
			GROUP BY SP1.MASP
			ORDER BY SUM(CT.SOLUONG) ASC)
	END
GO

--proc xem SỐ LƯỢNG mặt hàng bán chậm theo tháng
--DROP PROC SP_QL_DSBanCham_NUM
CREATE PROC SP_QL_DSBanCham_NUM @THANG INT, @NAM INT
AS
	BEGIN
		SELECT TOP(30) SUM(CT.SOLUONG) AS SLDB
		FROM SANPHAM SP1, DONHANG DH, CT_DONHANG CT
		WHERE SP1.MASP = CT.MASP AND DH.MADH = CT.MADH AND DH.TINHTRANG = 2 AND MONTH(DH.NGAYLAP) = @THANG AND YEAR(DH.NGAYLAP) = @NAM
		GROUP BY SP1.MASP
		ORDER BY SUM(CT.SOLUONG) ASC
	END
GO

--proc xem lợi nhuận mặt hàng bán chậm theo tháng
--DROP PROC SP_QL_DOANHTHU_BANCHAM
CREATE PROC SP_QL_DOANHTHU_BANCHAM @THANG INT, @NAM INT
AS
	BEGIN
		SELECT TOP(30) SUM(CT.THANHTIEN) - (SUM(CT.SOLUONG) * LS.GIANHAP) AS DT
		FROM SANPHAM SP1, DONHANG DH, CT_DONHANG CT, LICHSUNHAP LS
		WHERE SP1.MASP = CT.MASP AND DH.MADH = CT.MADH AND DH.TINHTRANG = 2 AND MONTH(DH.NGAYLAP) = @THANG AND YEAR(DH.NGAYLAP) = @NAM
		AND LS.MASP = SP1.MASP AND LS.NGAYNHAP = (SELECT TOP 1 NGAYNHAP
													FROM LICHSUNHAP
													WHERE MASP = SP1.MASP
													ORDER BY NGAYNHAP DESC)
		GROUP BY SP1.MASP, LS.GIANHAP
		ORDER BY SUM(CT.SOLUONG) ASC
	END
GO

--Xem doanh thu của cửa hàng trong tháng
CREATE PROC SP_QL_DSBH @THANG INT, @NAM INT
AS
	BEGIN
		SELECT SP.MASP, SP.TENSP, SP.SOLUONGTON
		FROM SANPHAM SP
		WHERE SP.MASP IN (
			SELECT SP1.MASP
			FROM SANPHAM SP1, DONHANG DH, CT_DONHANG CT
			WHERE SP1.MASP = CT.MASP AND DH.MADH = CT.MADH AND DH.TINHTRANG = 2 AND MONTH(DH.NGAYLAP) = @THANG AND YEAR(DH.NGAYLAP) = @NAM
			GROUP BY SP1.MASP
			)
	END
GO

--proc xem SỐ LƯỢNG mặt hàng bán được theo tháng
--DROP PROC SP_QL_DSDH
CREATE PROC SP_QL_DSDH @THANG INT, @NAM INT
AS
	BEGIN
		SELECT SUM(CT.SOLUONG) AS SLDB
		FROM SANPHAM SP1, DONHANG DH, CT_DONHANG CT
		WHERE SP1.MASP = CT.MASP AND DH.MADH = CT.MADH AND DH.TINHTRANG = 2 AND MONTH(DH.NGAYLAP) = @THANG AND YEAR(DH.NGAYLAP) = @NAM
		GROUP BY SP1.MASP
	END
GO

--proc xem LOI NHUAN mặt hàng bán được theo tháng
--DROP PROC SP_QL_LOINHUAN_BANDUOC
CREATE PROC SP_QL_LOINHUAN_BANDUOC @THANG INT, @NAM INT
AS
	BEGIN
		SELECT SUM(CT.THANHTIEN) - (SUM(CT.SOLUONG) * LS.GIANHAP) AS LN
		FROM SANPHAM SP1, DONHANG DH, CT_DONHANG CT, LICHSUNHAP LS
		WHERE SP1.MASP = CT.MASP AND DH.MADH = CT.MADH AND DH.TINHTRANG = 2 AND MONTH(DH.NGAYLAP) = @THANG AND YEAR(DH.NGAYLAP) = @NAM
		AND LS.MASP = SP1.MASP AND LS.NGAYNHAP = (SELECT TOP 1 NGAYNHAP
													FROM LICHSUNHAP
													WHERE MASP = SP1.MASP
													ORDER BY NGAYNHAP DESC)
		GROUP BY SP1.MASP, LS.GIANHAP
	END
GO

--proc xem DOANH THU mặt hàng bán được theo tháng
CREATE PROC SP_QL_TONGDHDB @THANG INT, @NAM INT
AS
	BEGIN
		SELECT COUNT(DH.MADH) 
                    FROM DONHANG DH, CT_DONHANG CTDH 
                    WHERE DH.MADH = CTDH.MADH 
					AND DH.TINHTRANG= 2
                    AND YEAR(DH.NGAYLAP) = @NAM
                    AND MONTH(DH.NGAYLAP) = @THANG
	END
GO

CREATE PROC SP_QL_TONG_SLSP_DB @THANG INT, @NAM INT
AS
	BEGIN
		SELECT SUM(CAST(DH.TONGTIEN AS BIGINT)) , SUM(CAST(CTDH.SOLUONG AS BIGINT))
                    FROM DONHANG DH, CT_DONHANG CTDH 
                    WHERE DH.MADH = CTDH.MADH 
					AND DH.TINHTRANG = 2
                    AND YEAR(DH.NGAYLAP) = @NAM
                    AND MONTH(DH.NGAYLAP) = @THANG
	END
GO
CREATE PROC SP_QL_TONG_CHIPHI @THANG INT, @NAM INT
AS
	BEGIN
		SELECT SUM(CAST((SP.GIAGOC*CTDH.SOLUONG) AS BIGINT)) 
                    FROM CT_DONHANG CTDH, SANPHAM SP, DONHANG DH
                    WHERE CTDH.MASP = SP.MASP 
					AND DH.TINHTRANG=2
                    AND CTDH.MADH = DH.MADH 
                    AND YEAR(DH.NGAYLAP) = @NAM
                    AND MONTH(DH.NGAYLAP) = @THANG
	END
GO


