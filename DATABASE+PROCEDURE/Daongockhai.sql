create database Daongockhai
use Daongockhai
-- Bảng tài khoản
create table accounts(
username nvarchar(100) primary key,	
displayname nvarchar(100) not null default N'Quản lý',
password nvarchar(100) not null default 1,
type int not null  default 0 -- 1: admin && 0: staff
)
ALTER TABLE accounts ADD CONSTRAINT check_type CHECK (type=0 or type=1);
-- Bảng sản phẩm
create table sanpham(
msp char(10) primary key,
tsp nvarchar(50) not null,
loai nvarchar(50) not null,
)
-- Bảng nhân viên
create table nhanvien(
mnv char(10) primary key,
tnv nvarchar(50) not null,
gioitinh nvarchar(4) CONSTRAINT check_gioitinhnv CHECK (gioitinh=N'nam' or gioitinh=N'nữ' or gioitinh=N'khác') not null,
ngaysinh date not null,
diachi nvarchar(50) not null,
sdt char(10) CONSTRAINT check_dienthoainv CHECK (sdt like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]') not null
)
-- Bảng hóa đơn nhập
create table hoadonnhap(
mhdn char(10) primary key,
mnv char(10) constraint f9_mnv foreign key references nhanvien(mnv),
ngaynhap date not null
)
-- Bảng chi tiết hóa đơn nhập
create table chitiethoadonnhap(
mhdn char(10) constraint f1_mhdn foreign key references hoadonnhap(mhdn),
msp char(10) constraint fr_msp foreign key references sanpham(msp),
soluong int not null,
gianhap float not null,
constraint P_chitiethoadonnhap primary key (mhdn, msp)
)
-- Bảng hóa đơn bán
create table hoadonban(
mhdb char(10) primary key not null,
mnv char(10) constraint f10_mnv foreign key references nhanvien(mnv),
ngayban date not null,
tkh nvarchar(50) not null,
diachi nvarchar(50) not null
)
-- Bảng chi tiết hóa đơn bán
create table chitiethoadonban(
mhdb char(10) constraint f3_mhdb foreign key references hoadonban(mhdb),
msp char(10)constraint f8_mnv foreign key references sanpham(msp),
soluong int not null,
giaban float not null,
constraint P_chitiethoadonban primary key (mhdb, msp)
)
-- Bảng khách hàng
create table khachhang(
mkh char(10) primary key,
mhdb char(10) constraint f5_mhdb foreign key references hoadonban(mhdb),
tkh nvarchar(50) not null,
diachi nvarchar(50) not null,
sdt char(10) CONSTRAINT check_dienthoaikh CHECK (sdt like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]') not null
)
--
-- dữ liệu các bảng
--Bảng accounts
INSERT INTO accounts (username, displayname, password, type)
VALUES
  ('user1', N'Người dùng 1', 'pass1', 0),
  ('user2', N'Người dùng 2', 'pass2', 0),
  ('admin1', N'Quản trị viên 1', 'adminpass1', 1),
  ('admin2', N'Quản trị viên 2', 'adminpass2', 1);
--Bảng sanpham
INSERT INTO sanpham (msp, tsp, loai)
VALUES
  ('SP001', N'Sản phẩm 1', N'Loại 1'),
  ('SP002', N'Sản phẩm 2', N'Loại 2'),
  ('SP003', N'Sản phẩm 3', N'Loại 1'),
  ('SP004', N'Sản phẩm 4', N'Loại 2');
--Bảng nhanvien
INSERT INTO nhanvien (mnv, tnv, gioitinh, ngaysinh, diachi, sdt)
VALUES
  ('NV001', N'Nhân viên 1', N'nam', '1990-01-01', N'Địa chỉ 1', '1234567890'),
  ('NV002', N'Nhân viên 2', N'nữ', '1995-02-02', N'Địa chỉ 2', '0987654321'),
  ('NV003', N'Nhân viên 3', N'khác', '2000-03-03', N'Địa chỉ 3', '9876543210');
--Bảng hoadonnhap
INSERT INTO hoadonnhap (mhdn, mnv, ngaynhap)
VALUES
  ('HDN001', 'NV001', '2022-01-01'),
  ('HDN002', 'NV002', '2022-02-02');
--Bảng chitiethoadonnhap
INSERT INTO chitiethoadonnhap (mhdn, msp, soluong, gianhap)
VALUES
  ('HDN001', 'SP001', 5, 10.5),
  ('HDN001', 'SP002', 3, 7.2),
  ('HDN002', 'SP003', 2, 15.3);
--Bảng hoá đơn bán 
INSERT INTO hoadonban (mhdb, mnv, ngayban, tkh, diachi)
VALUES
  ('HDB001', 'NV001', '2022-01-01', N'Khách hàng 1', N'Địa chỉ 1'),
  ('HDB002', 'NV002', '2022-02-02', N'Khách hàng 2', N'Địa chỉ 2');
--Bảng chi tiết hóa đơn bán 
INSERT INTO chitiethoadonban (mhdb, msp, soluong, giaban)
VALUES
  ('HDB001', 'SP001', 3, 20.5),
  ('HDB001', 'SP002', 2, 15.2),
  ('HDB002', 'SP003', 4, 12.3);
--Bảng khach_hang
INSERT INTO khachhang (mkh, mhdb, tkh, diachi, sdt)
VALUES
  ('KH001', 'HDB001', N'Khách hàng 1', N'Địa chỉ 1', '1234567890'),
  ('KH002', 'HDB002', N'Khách hàng 2', N'Địa chỉ 2', '0987654321');
Select * from sanpham
Select * from nhanvien
Select * from chitiethoadonban
Select * from chitiethoadonnhap
Select * from hoadonban
Select * from hoadonnhap
Select * from khachhang
Select * from accounts
--Hàm login
CREATE PROC Login
@userName nvarchar(100), @passWord nvarchar(100)
AS
BEGIN
	SELECT * FROM dbo.Account WHERE UserName = @userName AND PassWord = @passWord
END
--============================================================================================================
-- Quản lý người dùng
--1. tạo login
exec sp_addlogin ql1,'1'
exec sp_addlogin ql2,'2'
exec sp_addlogin nv1,'1'
exec sp_addlogin nv2,'2'
exec sp_addlogin nv3,'3'
--2.Tạo user
exec sp_adduser ql1,quanly1
exec sp_adduser ql2,quanly2
exec sp_adduser nv1,nhanvien1
exec sp_adduser nv2,nhanvien2
exec sp_adduser nv3,nhanvien3
--3.Tạo roles
exec sp_addrole quanly
--Thêm user vào role
exec sp_addrolemember quanly,quanly1
exec sp_addrolemember quanly,quanly2
--4.Cấp quyền cho nhóm 'quanly' có toàn quyền
grant create table,insert,update,delete,select,references to quanly
--5.Cấp quyền cho nhanvien1 có quyền thêm, xem dữ liệu trong bảng sanpham
grant insert,select on sanpham to nhanvien1
--6.Cấp quyền cho nhanvien2 có quyền xóa, sửa dữ liệu trong bảng sanpham
grant delete,update on sanpham to nhanvien2
--7. Thu hồi toàn bộ quyền của 2 tài khoản nhân viên(nv1, nv2)
revoke insert,select on sanpham from nhanvien1
revoke delete,update on sanpham from nhanvien2
--===========================================================
-- Tạo chỉ mục
-- Tạo chỉ mục tìm tên của nhân viên
create nonclustered index idhoten on nhanvien(tnv) 
-- Tìm kiếm tất cả các nhân viên có họ "Nguyễn"
SELECT * 
FROM nhanvien WITH (INDEX=idhoten)
WHERE tnv like N'Ng%'
-- Tạo chỉ mục tìm tên sản phẩm và loại
create nonclustered index idtsp on sanpham(tsp,loai) 
-- Tìm kiếm tất cả các sản phẩm có tên "Đàn" và loại "Piano"
SELECT * 
FROM sanpham WITH (INDEX=idtsp)
WHERE tsp like N'Đàn %' and loai like N'Piano'
-- Tạo chỉ mục tìm tên của khách hàng
create nonclustered index idhotenkh on khachhang(tkh) 
go
-- Tìm kiếm tất cả các khách hàng có họ "Trần"
SELECT * 
FROM khachhang WITH (INDEX=idhotenkh)
WHERE tkh like N'Tr%'
-- Tạo chỉ mục tìm số lượng nhập, giá nhập trong bảng chi tiết hóa đơn nhập
create nonclustered index idcthdn on chitiethoadonnhap(soluong,gianhap) 
go
-- Tìm kiếm tất cả các sản phẩm có có số lượng nhập > 5, giá nhập > 1000000
SELECT * FROM 
chitiethoadonnhap WITH (INDEX=idcthdn)
WHERE soluong > 5 and gianhap > 1000000
-- chỉ mục toàn văn
CREATE FULLTEXT CATALOG search_ht_2
--12. Tìm kiếm tất cả các nhân viên có chứa từ 'Nguyễn' và 'Văn'
USE Daongockhai;
GO
EXEC sp_fulltext_database 'enable';
GO
--=============================================================================================================================================
-- Tạo view
-- 1.Tạo View có tên là vw_cau1 lưu trữ các thông tin: Họ tên nhân viên, giới tính, địa chỉ, sdt của nhân viên đó
create view vw_cau1
as select tnv,gioitinh,diachi,sdt from nhanvien
go
select * from vw_cau1
-- 2.Tạo View có tên là vw_cau2 lưu trữ các thông tin: Họ tên khách hàng, địa chỉ, sdt của khách hàng đó
DROP VIEW IF EXISTS vw_cau2;
-- 3.Tạo View có tên là vw_cau3 lưu trữ các thông tin: Mã kh, họ tên khách hàng, địa chỉ, sdt, mã hóa đơn, số lượng, giá của khách hàng đó
CREATE VIEW vw_cau3
AS
SELECT mkh, tkh, diachi, sdt, hdb.mhdb, soluong, cthd.giaban 
FROM khachhang kh 
JOIN hoadonban hdb ON kh.mhdb = hdb.mhdb
JOIN chitiethoadonban cthd ON hdb.mhdb = cthd.mhdb
WHERE hdb.ngayban >= '2022-01-01'
GROUP BY mkh, tkh, diachi, sdt, hdb.mhdb, soluong, cthd.giaban
GO
-- 4.Tạo View có tên là vw_cau4lưu trữ các thông tin: msp, tsp, loai, ngaynhap, gianhap của sản phẩm
create view vw_cau4
as select sp.msp,tsp,loai,soluong,cthdn.gianhap,ngaynhap
from sanpham sp join chitiethoadonnhap cthdn on sp.msp=cthdn.msp
join hoadonnhap hdn on cthdn.mhdn=hdn.mhdn
group by sp.msp,tsp,loai,soluong,cthdn.gianhap,ngaynhap
go
select * from vw_cau4
-- 5.Tạo View có tên là vw_cau5 lưu trữ các thông tin: mã nhân viên, số lượng hóa đơn bán mà nhân viên đó đã bán
create view vw_cau5
as select nv.mnv,soluonghdb=COUNT(hdb.mhdb)
from nhanvien nv join hoadonban hdb on nv.mnv=hdb.mnv
group by nv.mnv
go
select * from vw_cau5
--6
create view Vw_cau6
as select mnv,tnv,gioitinh,diachi,sdt 
from nhanvien
go
UPDATE Vw_cau6
   SET gioitinh=N'nam'
   WHERE mnv = 'nv10'
select * from nhanvien where mnv='nv10'
--7 
create view Vw_cau7
as select msp,tsp,loai
from sanpham
go
delete Vw_cau7
WHERE msp = 'msp16'
go
select * from sanpham
--=====================================================================================
-- Toán tử nâng cao 
--1 nối bảng sản phẩm vs bảng chi tiết hóa đơn nhập
select sp.msp,tsp,loai,soluong,gianhap
from sanpham sp join chitiethoadonnhap cthdn
on sp.msp=cthdn.msp
--2
select sp.msp,tsp,soluong
from sanpham sp join chitiethoadonnhap cthdn
on sp.msp=cthdn.msp
where soluong > 10
--3
select hdb.mhdb,ngayban,kh.tkh,kh.diachi,sdt
from hoadonban hdb join khachhang kh
on hdb.mhdb=kh.mhdb
where kh.diachi=N'Hưng Yên'
--4
select top(3) msp,soluong,giaban from chitiethoadonban
order by giaban desc
--5
SELECT TOP 50 PERCENT mnv,tnv,namsinh=YEAR(ngaysinh) 
FROM nhanvien
ORDER BY YEAR(ngaysinh) asc
--6
select hdb.mhdb,msp,max(soluong) as soluonglonnhat
from hoadonban  hdb  join chitiethoadonban cthdb on hdb.mhdb=cthdb.mhdb 
where diachi=N'Phú Thọ' group by hdb.mhdb,msp
--7
DELETE sanpham OUTPUT deleted.* WHERE msp ='msp16'
--8
SELECT MAX(YEAR(GETDATE())-YEAR(ngaysinh)) as [Tuổi lớn nhất], 
MIN(YEAR(GETDATE())-YEAR(ngaysinh)) as [Tuổi nhỏ nhất]
FROM nhanvien WHERE diachi= N'Hưng Yên'
--9
SELECT mhdb,msp,SUM (giaban) as N'giá bán'
FROM chitiethoadonban
GROUP BY ROLLUP(mhdb,msp)
--10
SELECT RANK() OVER(ORDER BY soluong) AS[Xếp hạng theo giá nhập],
hdn.mhdn,msp,soluong,gianhap
FROM hoadonnhap hdn JOIN chitiethoadonnhap cthdn
on hdn.mhdn=cthdn.mhdn
--11
SELECT DENSE_RANK() OVER(ORDER BY soluong) AS[Xếp hạng theo số lượng],
hdb.mhdb,msp,soluong,giaban
FROM hoadonban hdb JOIN chitiethoadonban cthdb
on hdb.mhdb=cthdb.mhdb
--12
SELECT Row_number() OVER(ORDER BY ngaynhap) AS[Xếp hạng theo ngaynhap],
hdn.mhdn,msp,soluong,gianhap,ngaynhap
FROM hoadonnhap hdn JOIN chitiethoadonnhap cthdn
on hdn.mhdn=cthdn.mhdn
--13
SELECT NTILE(3) OVER (ORDER BY ngaysinh) AS [Age Groups],
tnv,diachi,tuoi=YEAR(GETDATE())-YEAR(ngaysinh)
FROM nhanvien
--14
SELECT mhdn,sp.msp,loai,SUM (gianhap) as N'giá nhập'
FROM chitiethoadonnhap cthdn join sanpham sp 
on sp.msp=cthdn.msp
GROUP BY cube(mhdn,sp.msp,loai)
--15
select sp.msp,tsp,loai,banduoc,danhgia=
	case
	    when d.banduoc >=9 then N'Hàng hot'
		when d.banduoc >=6 then N'Bán chạy'
		when d.banduoc >=3 then N'Bán ổn định'
		else N'Cần có thêm chương trình khuyến mại'
	 end
from sanpham sp,
(
	select sp.msp,
	sum(soluong) as banduoc
	FROM sanpham sp  join  chitiethoadonban cthdb on  sp.msp = cthdb.msp
WHERE  loai=N'Kèn'
GROUP BY sp.msp) as d
where d.msp = sp.msp
--=====================================================================================================================================================
-- Thủ tục
-- tìm kiếm
--1
create proc getspbymsp
@msp char(10)
as
begin
	select * from sanpham where msp=@msp
end
go
exec getspbymsp @msp='msp1'
--2
CREATE FUNCTION [dbo].[fuConvertToUnsign1] ( @strInput NVARCHAR(4000) ) RETURNS NVARCHAR(4000) AS BEGIN IF @strInput IS NULL RETURN @strInput IF @strInput = '' RETURN @strInput DECLARE @RT NVARCHAR(4000) DECLARE @SIGN_CHARS NCHAR(136) DECLARE @UNSIGN_CHARS NCHAR (136) SET @SIGN_CHARS = N'ăâđêôơưàảãạáằẳẵặắầẩẫậấèẻẽẹéềểễệế ìỉĩịíòỏõọóồổỗộốờởỡợớùủũụúừửữựứỳỷỹỵý ĂÂĐÊÔƠƯÀẢÃẠÁẰẲẴẶẮẦẨẪẬẤÈẺẼẸÉỀỂỄỆẾÌỈĨỊÍ ÒỎÕỌÓỒỔỖỘỐỜỞỠỢỚÙỦŨỤÚỪỬỮỰỨỲỶỸỴÝ' +NCHAR(272)+ NCHAR(208) SET @UNSIGN_CHARS = N'aadeoouaaaaaaaaaaaaaaaeeeeeeeeee iiiiiooooooooooooooouuuuuuuuuuyyyyy AADEOOUAAAAAAAAAAAAAAAEEEEEEEEEEIIIII OOOOOOOOOOOOOOOUUUUUUUUUUYYYYYDD' DECLARE @COUNTER int DECLARE @COUNTER1 int SET @COUNTER = 1 WHILE (@COUNTER <=LEN(@strInput)) BEGIN SET @COUNTER1 = 1 WHILE (@COUNTER1 <=LEN(@SIGN_CHARS)+1) BEGIN IF UNICODE(SUBSTRING(@SIGN_CHARS, @COUNTER1,1)) = UNICODE(SUBSTRING(@strInput,@COUNTER ,1) ) BEGIN IF @COUNTER=1 SET @strInput = SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)-1) ELSE SET @strInput = SUBSTRING(@strInput, 1, @COUNTER-1) +SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)- @COUNTER) BREAK END SET @COUNTER1 = @COUNTER1 +1 END SET @COUNTER = @COUNTER +1 END SET @strInput = replace(@strInput,' ','-') RETURN @strInput END
create proc getkhbuy
@diachi nvarchar(50)
as
	select mkh,kh.tkh,kh.diachi,sdt,soluong,giaban from khachhang kh  join hoadonban hdb
	on hdb.mhdb=kh.mhdb join chitiethoadonban cthdb
	on hdb.mhdb=cthdb.mhdb
	where kh.diachi = @diachi and soluong >= 5
go
exec getkhbuy @diachi = N'Hải Dương'
--3
create proc inserthdn
-- bang hoa don
@mhdn char(10),
@mnv char(10),
@ngaynhap date,
-- bang cthoadon
@Msp char(10),
@SoLuong int,
@Gianhap float
as
begin
	INSERT INTO hoadonnhap VALUES (@mhdn , @mnv , @ngaynhap);
	INSERT INTO chitiethoadonnhap VALUES (@mhdn , @Msp , @SoLuong , @Gianhap);
end
go
exec inserthdn @mhdn ='HDN10', @mnv='NV1', @ngaynhap='20211007',@Msp='msp14',@SoLuong=10,@Gianhap=100000000
select * from hoadonnhap where mhdn = 'hdn12'
select * from chitiethoadonnhap where mhdn = 'hdn12'
--4
create proc updatehdn
-- bang hoa don
@mhdn char(10),
@mnv char(10),
@ngaynhap date,
-- bang cthoadon
@Msp char(10),
@SoLuong int,
@Gianhap float
as
begin
	update chitiethoadonnhap set msp = @Msp , soluong = @SoLuong , gianhap = @Gianhap where mhdn = @mhdn;
	update hoadonnhap set mnv = @mnv , ngaynhap = @ngaynhap where mhdn = @mhdn;
end
go
exec updatehdn @mnv='nv2',@ngaynhap='20220105',@msp='msp14',@SoLuong=8,@Gianhap=500000,@mhdn='hdn11'
--5
create proc deletehdn
@mhdn char(10)
as
begin
	delete chitiethoadonnhap where mhdn = @mhdn;
	delete hoadonnhap where mhdn = @mhdn;
end
go
exec deletehdn @mhdn='hdn11'
--6
create proc addnv
@mnv char(10),
@tnv nvarchar(50),
@gioitinh nvarchar(4),
@ngaysinh date,
@diachi nvarchar(50),
@sdt char(10)
as 
begin
if(exists(select * from nhanvien nv where nv.mnv=@mnv))
	begin
		print 'Mã nhân viên '+@mnv+N'đã tồn tại'
		return -1
	end
else
	begin
		print 'Thêm mã nhân viên '+@mnv+N'thành công'
		return 1
	end
insert into nhanvien(mnv,tnv,gioitinh,ngaysinh,diachi,sdt)
values(@mnv,@tnv,@gioitinh,@ngaysinh,@diachi,@sdt)
return 0
end
go
exec addnv 'nv11',N'đạt',N'nam','19991220',N'Hưng Yên','0123456789'
--7
create proc updatekh
@mkh char(10),
@mhdb char(10),
@tkh nvarchar(50),
@diachi nvarchar(50),
@sdt char(10)
as 
begin
if(not exists(select * from khachhang kh where kh.mkh=@mkh))
	begin
		print 'Mã khách hàng '+@mkh+N'chưa tồn tại hoặc không đúng!'
		return -1
	end
if(exists(select * from hoadonban hdb where hdb.mhdb=@mhdb))
	begin
		print'Mã hóa đơn bán'+@mhdb+N'chưa tồn tại hoặc không đúng!'
		return -1
	end
else
	begin
		print N'Sửa thông tin của khách hàng có mã'+@mkh+N'thành công'
		return 1
	end
update khachhang set mhdb = @mhdb , tkh = @tkh , diachi = @diachi , sdt = @sdt where mkh = @mkh;
return 0
end
go
exec updatekh @mhdb='hdn1',@tkh=N'Nguyễn Văn H',@diachi=N'Hà Nội',@sdt='0659554967',@mkh='kh1'
--8
create proc deletenv
@mnv char(10)
as 
begin
if(not exists(select * from nhanvien nv where nv.mnv=@mnv))
	begin
		print 'Mã nhân viên '+@mnv+N'chưa tồn tại hoặc không đúng!'
		return -1
	end
else
	begin
		print N'Xóa thông tin của nhân viên có mã'+@mnv+N'thành công'
		return 1
	end
delete nhanvien where mnv = @mnv;
return 0
end
go
exec deletenv @mnv='nv11'
--9
create proc getbillbday
@checkin date, @checkout date
as
begin
	select hdb.mhdb as N'Hóa đơn bán',mnv as N'Mã nhân viên',ngayban as N'Ngày bán',tkh as N'Tên khách hàng',diachi as N'Địa chỉ',
	soluong as N'Số lượng',giaban as N'Thành tiền' 
	from hoadonban hdb join chitiethoadonban cthdb on hdb.mhdb=cthdb.mhdb 
	where ngayban >=@checkin and ngayban<=@checkout
end
go
exec getbillbday @checkin='20210904', @checkout='20211030' 
--10
create PROC tongtiennhap
@loai nvarchar (50),
@TT int OUTPUT
AS
SELECT @TT = count(loai)
FROM  sanpham
WHERE loai=@loai 
GO
DECLARE @dem INT;
SELECT @dem =0
EXEC tongtiennhap N'Đàn Ghi-ta', @dem OUTPUT
SELECT @dem as N'Tổng số mặt hàng thuộc loại Ghi-ta'
--===================================================================================
--hàm
--1
create FUNCTION f_1(@mnv char(10))
RETURNS TABLE
AS
RETURN
		(SELECT mnv,tnv,tuoi=year(getdate())-year(ngaysinh),diachi
		FROM nhanvien where mnv=@mnv)
go
SELECT * FROM f_1('nv1')
--2
create FUNCTION f_2(@diachi nvarchar(50))
RETURNS TABLE
AS
RETURN
		(SELECT mkh,tkh,diachi,sdt
		FROM khachhang
		WHERE diachi=@diachi)
go
SELECT * FROM F_2(N'Hưng Yên')
--3
create FUNCTION f_3(@msp char(10))
RETURNS TABLE
AS
RETURN
	(select sp.msp,tsp,loai,giaban,danhgia=
	case
	    when soluong >=9 then N'Hàng hot'
		when soluong >=6 then N'Bán chạy'
		when soluong >=3 then N'Bán ổn định'
		else N'Cần có thêm chương trình khuyến mại'
	 end from chitiethoadonban cthdb join sanpham sp 
	 on cthdb.msp=sp.msp where sp.msp=@msp)
go
SELECT * FROM F_3('msp15')
--4
create FUNCTION F_c4(@loai nvarchar(50)) RETURNS TINYINT
AS
BEGIN
	DECLARE @SL TINYINT
	SELECT @SL=sum(soluong)
	FROM sanpham sp JOIN chitiethoadonban cthdb on sp.msp=cthdb.msp
	WHERE loai=@loai
	RETURN @SL
END
go
SELECT dbo.F_c4(N'Kèn') AS N'Số lượng sản phẩm đã bán'
--5
create FUNCTION F_5(@loai nvarchar(50)) RETURNS INT
AS
BEGIN
	DECLARE @SL INT
	SELECT @SL=sum(gianhap)
	FROM sanpham sp JOIN chitiethoadonnhap cthdn on sp.msp=cthdn.msp
	WHERE loai=@loai
	RETURN @SL
END
go
SELECT dbo.F_5(N'Phụ kiện') AS N'Tổng tiền nhập của sản phẩm'
--========================================================================================
-- Trigger
--1
create trigger tr_slnhap on chitiethoadonnhap
for update, insert as
if(select sum(chitiethoadonnhap.soluong)
from chitiethoadonnhap join inserted
on chitiethoadonnhap.msp=inserted.msp)
<
(select sum(chitiethoadonban.soluong)
from chitiethoadonban join inserted
on chitiethoadonban.msp=inserted.msp)
begin
	print N'Tổng số lượng nhập ít hơn số lượng bán'
	rollback
end
go
update chitiethoadonnhap set soluong=4
where msp='msp7'
select * from chitiethoadonban
--2
create trigger tr_nsnhanvien on nhanvien
for update, insert as
if(select nhanvien.ngaysinh from nhanvien join inserted
on nhanvien.mnv=inserted.mnv) < '19700101'
begin
	print N'Lỗi trong quá trình nhập ngày sinh. Ngày sinh không thể nhỏ hơn ngày 01/01/1970'
	rollback
end
go
update nhanvien set ngaysinh='19690101'
where mnv='nv1'
--3
create trigger tr_camxoasp on sanpham
instead of update,delete as
begin
	if (select msp from deleted)= 'msp1'
	begin
		print N'Không được xóa hoặc sửa sản phẩm thuộc mã này!'
		rollback
	end
	else
		delete from sanpham where msp= (select msp from deleted)
end
go
update sanpham set tsp=N'Đàn' where msp='msp1'
--4
create trigger tr_camsuanv on nhanvien
instead of update,insert as
begin
	if (select ngaysinh from inserted) < '19700101'
		print N'Không được thêm hoặc sửa các nhân viên có ngày sinh nhỏ hơn "1/1/1970"!'
		rollback
end
go
insert into nhanvien(mnv,tnv,gioitinh,ngaysinh,diachi,sdt)
values('nv11',N'Đạt',N'nam','19690101',N'Hưng Yên','0123456789')
--5

--6