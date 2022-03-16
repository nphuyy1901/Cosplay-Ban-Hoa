-- RANG BUOC UNIQUE--------
-- TAIKHOAN --
ALTER TABLE TAIKHOAN
ADD 
	CONSTRAINT UNIQUE_SDT_TAIKHOAN UNIQUE(SDT),
	CONSTRAINT UNIQUE_EMAIL_TAIKHOAN UNIQUE(EMAIL),
	CONSTRAINT UNIQUE_TDN_TAIKHOAN UNIQUE(TENDN)
	
GO

-- TAIXE --
ALTER TABLE TAIXE
ADD 
	CONSTRAINT UNIQUE_STK_TAIXE UNIQUE(STK),
	CONSTRAINT UNIQUE_CMND_TAIXE UNIQUE(CMND),
	CONSTRAINT UNIQUE_BIENSOXE_TAIXE UNIQUE(BIENSOXE)

GO

-- KHACHHANG --
ALTER TABLE KHACHHANG
ADD 
	CONSTRAINT UNIQUE_STK_KH UNIQUE(STK)
GO

-- RANG BUOC MIEN GIA TRI --
-- LUUVETGIA --
ALTER TABLE LUUVETGIA
ADD 
	CONSTRAINT NGAY_LVG_CHECK CHECK(NGAY <= GETDATE()),
	CONSTRAINT GIA_LVG_CHECK CHECK(GIA > 0)

GO

-- SANPHAM --
ALTER TABLE SANPHAM
ADD 
	CONSTRAINT GIAGOC_SP_CHECK CHECK(GIAGOC > 0),
	CONSTRAINT KM_SP_CHECK CHECK(KHUYENMAI BETWEEN 0 AND 100),
	CONSTRAINT SLT_SP_CHECK CHECK(SOLUONGTON >= 0)

GO

-- LICHSUNHAP --
ALTER TABLE LICHSUNHAP
ADD 
	CONSTRAINT SL_LSN_CHECK CHECK(GIAGOC >= 1),
	CONSTRAINT NN_LSN_CHECK CHECK(NGAYNHAP <= GETDATE()),
	CONSTRAINT GN_LSN_CHECK CHECK(GIANHAP > 0)

GO

-- GIAMGIA --
ALTER TABLE GIAMGIA
ADD 
	CONSTRAINT GG_GG_CHECK CHECK(GIAGIAM >= 0)
	CONSTRAINT NGAY_GG_CHECK CHECK(NGAYKT >= 0)
GO 

-- NHANVIEN --
ALTER TABLE NHANVIEN
ADD 
	CONSTRAINT L_NV_CHECK CHECK(LUONG > 0),
	CONSTRAINT LNV_NV_CHECK CHECK(LOAINV BETWEEN 0 AND 2)

GO

-- TAIKHOAN --
ALTER TABLE TAIKHOAN
ADD 
	CONSTRAINT LTK_TK_CHECK CHECK(LOAITK BETWEEN 0 AND 2)

GO

-- LUONG --
ALTER TABLE LUONG
ADD 
	CONSTRAINT L_L_CHECK CHECK(LUONG > 0),
	CONSTRAINT N_L_CHECK CHECK(NGAY <= GETDATE())

GO

-- DIEMDANH --
ALTER TABLE DIEMDANH
ADD 
	CONSTRAINT N_DD_CHECK CHECK(NGAY <= GETDATE())

GO

-- XULIDONHANG --
ALTER TABLE XULI_DONHANG
ADD 
	CONSTRAINT KH_XLDH_CHECK CHECK(NGAYKHNHAN >= NGAYTXNHAN),
	CONSTRAINT KH2_XLDH_CHECK CHECK(NGAYKHNHAN <= GETDATE())

GO

-- DONHANG --
ALTER TABLE DONHANG
ADD 
	CONSTRAINT PVC_DH_CHECK CHECK(PHIVANCHUYEN BETWEEN 30000 AND 40000),
	CONSTRAINT NMG_DH_CHECK CHECK(NGAYMUONGIAO >= NGAYLAP),
	CONSTRAINT HTTT_DH_CHECK CHECK(HINHTHUCTHANHTOAN BETWEEN 0 AND 3),
	CONSTRAINT TT_DH_CHECK CHECK(TINHTRANG BETWEEN -1 AND 4)
GO

-- CT_DONHANG --
ALTER TABLE CT_DONHANG
ADD 
	CONSTRAINT SL_CTDH_CHECK CHECK(SOLUONG > 0)
GO


--RANG BUOC LIEN QUAN HE-----
--GIAMGIA
CREATE TRIGGER KT_GIAGIAM ON GIAMGIA
FOR INSERT
	AS
	BEGIN
		DECLARE @TMP DECIMAL(19,4)
		SET @TMP = (SELECT SP.GIAGOC 
						FROM SANPHAM SP, INSERTED I 
						WHERE SP.MASP = I.MASP)
		DECLARE @TEMP DECIMAL(19,4)
		SET @TEMP = (SELECT I.GIAGIAM FROM INSERTED I)
		IF(@TEMP >= @TMP) 
			BEGIN
			PRINT N'LOI GIA GIAM'
			ROLLBACK
			RETURN 
			END
	END
GO