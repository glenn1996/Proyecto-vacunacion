Use Master
go

if exists(Select * from sys.databases  Where name='TIENDA')
Begin
	Drop Database TIENDA
End
go

create database TIENDA
go

USE TIENDA
go

set dateformat ymd
go

/****** creando las tablas ******/

CREATE TABLE USUARIOO(
	ID int IDENTITY(1,1)  not null primary key,
	nombre varchar(50) NULL,
	apellido varchar(50) NULL,
	cargo varchar(50) null,
	correo varchar(50) NULL,
	contraseña varchar(50) NULL,
)
go

CREATE TABLE CATEGORIA(
	IDE_CAT int IDENTITY(1,1) not null primary key,
	NOM_CAT varchar (50) NOT NULL,
	DESCRIPCION varchar(50) NULL,
 )
go

CREATE TABLE DISTRITO(
	ID_DIS int not null primary key,
	NOMBRE varchar(50) NULL,
)
go

 CREATE TABLE CLIENTE(
	IDE_CLIE int not null primary key,
	NOM_CLI varchar(50) NOT NULL,
	APE_CLIE varchar(50) NULL,
	CORREO varchar(50) NULL,
	CONTRASEÑA varchar(50) NULL,
	DIR_CLIE varchar(50) NOT NULL,
	ID_DIS int references DISTRITO,
	FON_CLIE varchar(50) NULL,
 )
go

CREATE TABLE PROVEEDOR(
	IDE_PROV int IDENTITY(1,1) not null primary key,
	EMPRESA_PROV varchar(50) NOT NULL,
	NOM_PROV varchar(50) NOT NULL,
	CARGO_PROV varchar(50) NOT NULL,
	IDE_DIS int references DISTRITO,
	FONO_PROV nchar(10) NOT NULL,
 )
go

CREATE TABLE TIP_EMP(
	ID_TIP int not null primary key,
	DESCRIPCION varchar(50) NOT NULL,
 )
go

CREATE TABLE PRODUCTO(
	ID_PROD int IDENTITY(1,1) not null primary key,
	NOM_PRO varchar(50) NOT NULL,
	ID_TIP_PRO int references CATEGORIA,
	STOCK_PROD int NOT NULL,
	PRECIO money NOT NULL,
	DESCRIPCION varchar(200) NOT NULL,
	ID_PROV int references PROVEEDOR,
	FOTO_PROD varchar (50) NULL,
)
go

CREATE TABLE DETALLE_PED(
	ID_PED int not null primary key,
	ID_PROD int references PRODUCTO,
	PREC_TOTAL money NOT NULL,
	CANT_PED int NOT NULL,
	DES_PED varchar(50) NOT NULL,
 ) 
 
go

CREATE TABLE EMPLEADO(
	COD_EMP int not null primary key,
	NOM_EMP varchar(50) NOT NULL,
	APE_EMP varchar(50) NOT NULL,
	CEL_EMP int NOT NULL,
	CORREO_EMP varchar(50) NOT NULL,
	DIRECCION_EMP varchar(80) NOT NULL,
	SUELDO money NOT NULL,
	ID_DIS int references DISTRITO,
	FOTO_EMP varchar(50) NULL,
	FEC_NAC_EMP date NULL,
	ID_TIP int references TIP_EMP,
) 
go

CREATE TABLE PEDIDO(
	ID_PEDIDO int not null primary key,
	ID_EMP int references EMPLEADO,
	FEC_PEDIDO date NULL,
	FIN_PEDIDO date NULL,
	ENV_PEDIDO char(1) NULL,
	CANT_PEDIDO int NULL,
	ID_CLIE int references CLIENTE,
	DET_PEDIDO varchar(50) NOT NULL,
	ID_DIS int references DISTRITO,
)
go

/****** creando los procedimientos almacenados 2  ******/

insert into USUARIOO( nombre,apellido,cargo,correo,contraseña) values('glenn','mejia','admin','glenn@glenn.com','03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e')

/****** RegistrarUsuario  ******/
create proc sp_RegistrarUsuario(
@cargo varchar(50),
@correo varchar(50),
@contraseña varchar(50),
@Registrado bit output,
@Mensaje varchar(100) output
)
as
begin
if(not exists(select * from USUARIOO where correo =@correo ))
begin 
insert into USUARIOO(cargo,correo,contraseña) values(@cargo,@correo,@contraseña)
set @Registrado = 1
set @Mensaje = 'usuario registrado'
end
else
begin
set @Registrado = 0
set @Mensaje = 'correo ya existe'
end
end
go

/****** Para ejecutar  ******/
declare @registrado bit, @mensaje varchar(100)
exec sp_RegistrarUsuario 'usuario','glenn@glenn.com','03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e',@registrado output, @mensaje output
select @registrado
select @mensaje
go

/****** Validar acceso de Usuarios ******/
create proc sp_ValidarUsuario(
@correo varchar(50),
@contraseña varchar(50)
)
as
begin
if(exists(select * from USUARIOO where correo = @correo and contraseña = @contraseña ))
select cargo from USUARIOO where correo = @correo and contraseña = @contraseña 
else
    select 'ninguno'
end
go

/****** lista de usuarios admin ******/
CREATE PROC SP_LISTAADMIN
AS
SELECT ID,nombre,apellido,cargo,correo,contraseña FROM USUARIOO where cargo='admin';
go

/****** registrar nuevo admin  ******/
CREATE PROC SP_NUEVOADMIN(
@nombre varchar(50),
@apellido varchar(50),
@cargo varchar(50),
@correo varchar(50),
@contraseña varchar(50))
AS
insert into USUARIOO(nombre,apellido,cargo,correo,contraseña) values(@nombre,@apellido,@cargo,@correo,@contraseña)
go

/****** actualizar admin  ******/
CREATE PROC SP_ACTUALIZAADMIN(
@ID INT,
@nombre varchar(50),
@apellido varchar(50),
@cargo varchar(50),
@correo varchar(50),
@contraseña varchar(50)
)
AS
	UPDATE USUARIOO
	SET nombre= @nombre,apellido=@apellido,cargo=@cargo, correo=@correo,contraseña=@contraseña
	WHERE ID=@ID
GO

/****** eliminar admin  ******/
CREATE PROC SP_ELIMINAADMN(@IDE INT)
AS
DELETE USUARIOO WHERE ID=@IDE
GO

/****** lista de proveedor  ******/
CREATE PROC SP_LISTAPROVEEDOR
AS
SELECT PRO.IDE_PROV,PRO.EMPRESA_PROV,PRO.NOM_PROV, PRO.CARGO_PROV,
D.NOMBRE as DISTRITO,PRO.FONO_PROV
FROM PROVEEDOR PRO
INNER JOIN DISTRITO D 
ON PRO.IDE_DIS=D.ID_DIS
GO

/****** lista de categoria ******/
CREATE PROC SP_LISTACATEGORIA
AS
SELECT IDE_CAT,NOM_CAT,DESCRIPCION FROM CATEGORIA;
go

/****** registrar nuevo categoria  ******/
CREATE PROC SP_NUEVOCATEGORIA(
@nombre varchar (50),
@descripcion varchar(50)
)
AS
insert into CATEGORIA(NOM_CAT,DESCRIPCION) values(@nombre,@descripcion)
go

/****** actualizar categoria  ******/
CREATE PROC SP_ACTUALIZACATEGORIA(
@ID INT,
@nombre varchar (50),
@descripcion varchar(50)
)
AS
	UPDATE CATEGORIA
	SET NOM_CAT= @nombre,DESCRIPCION=@descripcion
	WHERE IDE_CAT=@ID
GO

/****** eliminar categoria  ******/
CREATE PROC SP_ELIMINACATEGORIA(@IDE INT)
AS
DELETE CATEGORIA WHERE IDE_CAT=@IDE
GO

/******  ******/
CREATE PROC SP_ACTUALIZAPRODUCTO (@IDE INT,@NOM VARCHAR(50),@CAT INT,@STO INT,@PRE money,
@DES VARCHAR(200),@PROV INT,@FOT VARCHAR(50))
AS
UPDATE PRODUCTO
SET NOM_PRO=@NOM,ID_TIP_PRO=@CAT,STOCK_PROD=@STO,
PRECIO=@PRE,DESCRIPCION=@DES,ID_PROV=@PROV,FOTO_PROD=@FOT
WHERE ID_PROD=@IDE
GO

CREATE PROC SP_BUSCAR_PRODUCTO (@nom varchar(50) )
AS
SELECT P.ID_PROD, P.NOM_PRO,P.DESCRIPCION,P.PRECIO,P.FOTO_PROD,C.NOM_CAT,PR.EMPRESA_PROV 
FROM DBO.PRODUCTO P 
INNER JOIN DBO.PROVEEDOR PR ON P.ID_PROV=PR.IDE_PROV
INNER JOIN dbo.CATEGORIA C ON P.ID_TIP_PRO=C.IDE_CAT

WHERE P.NOM_PRO LIKE @nom+'%';
GO

CREATE PROC SP_BUSCARPRODUCTOID(@ide INT)
AS
SELECT P.ID_PROD,P.NOM_PRO,P.ID_TIP_PRO,P.STOCK_PROD,P.PRECIO, P.DESCRIPCION,
P.ID_PROV,P.FOTO_PROD FROM PRODUCTO P 
WHERE P.ID_PROD = @IDE
GO

CREATE PROC SP_CATEGORIA
AS
SELECT C.IDE_CAT,C.NOM_CAT
FROM CATEGORIA C
GO

CREATE PROC SP_ELIMINAPRODUCTO (@IDE INT)
AS
DELETE PRODUCTO WHERE ID_PROD=@IDE
GO

CREATE PROC SP_LISTADISTRITO
AS 
  SELECT * FROM DBO.DISTRITO
GO

CREATE PROC SP_LISTAPRODUCTOS
AS
SELECT P.ID_PROD,P.NOM_PRO,P.DESCRIPCION,P.PRECIO,P.STOCK_PROD,C.NOM_CAT,PRO.EMPRESA_PROV,P.FOTO_PROD
FROM dbo.PRODUCTO P 
INNER JOIN dbo.PROVEEDOR PRO
ON P.ID_PROV=PRO.IDE_PROV
INNER JOIN DBO.CATEGORIA C 
ON P.ID_TIP_PRO=C.IDE_CAT
GO

CREATE PROC SP_NUEVOPRODUCTO (@NOM VARCHAR(50),@CAT INT,@STO INT,@PRE money,
@DES VARCHAR(200),@PROV INT,@FOT VARCHAR(50))
AS
INSERT INTO PRODUCTO VALUES(@NOM,@CAT,@STO,@PRE,@DES,@PROV,@FOT)
GO

CREATE PROC SP_NUEVOUSUARIO(@USUARIO VARCHAR(50),@CORREO VARCHAR(50),@CONTRASEÑA VARCHAR(50))
AS
INSERT INTO Usuario VALUES(@USUARIO,@CORREO,@CONTRASEÑA)
GO

CREATE PROC SP_PRODUCTO
AS
SELECT P.ID_PROD,P.NOM_PRO,P.DESCRIPCION,P.PRECIO,P.STOCK_PROD,P.ID_TIP_PRO,P.ID_PROV,P.FOTO_PROD
FROM dbo.PRODUCTO P 
GO

/****** insertando informacion en las tablas ******/

INSERT CATEGORIA (NOM_CAT, DESCRIPCION) VALUES ('Abarrotes', 'papas , lechuga , etc');
INSERT CATEGORIA (NOM_CAT, DESCRIPCION) VALUES ('Baño', 'papel, colinos');
INSERT CATEGORIA (NOM_CAT, DESCRIPCION) VALUES ('Bebes', 'pañales, pañitos');
INSERT CATEGORIA (NOM_CAT, DESCRIPCION) VALUES ('Insumos de cocina', 'cafe , leche');
INSERT CATEGORIA (NOM_CAT, DESCRIPCION) VALUES ('Frutas', 'platano , mandarina');
go

INSERT DISTRITO ( ID_DIS,NOMBRE) VALUES (1,'La esperanza');
INSERT DISTRITO ( ID_DIS,NOMBRE) VALUES (2,'Trujillo');
INSERT DISTRITO ( ID_DIS,NOMBRE) VALUES (3,'San Isidro');
go

INSERT CLIENTE (IDE_CLIE ,NOM_CLI, APE_CLIE, CORREO, CONTRASEÑA, DIR_CLIE, ID_DIS, FON_CLIE) VALUES (1,'Glenn', 'Mejia', 'glenn@gmail.com', 'glenn', 'Valle sagrado', 2, '434323454')
INSERT CLIENTE (IDE_CLIE ,NOM_CLI, APE_CLIE, CORREO, CONTRASEÑA, DIR_CLIE, ID_DIS, FON_CLIE) VALUES (2,'Juan', 'Palacios', 'juan@gmail.com', 'juan', 'Av. sin salida', 1, '545436789')
go

INSERT TIP_EMP (ID_TIP,DESCRIPCION) VALUES (1,'Administrador')
INSERT TIP_EMP (ID_TIP,DESCRIPCION) VALUES (2,'CAJERA')
INSERT TIP_EMP (ID_TIP,DESCRIPCION) VALUES (3,'AUXILIAR TECNICO')
INSERT TIP_EMP (ID_TIP,DESCRIPCION) VALUES (4,'SECRETARIA')
INSERT TIP_EMP (ID_TIP,DESCRIPCION) VALUES (5,'ASISTENTE')
go

INSERT EMPLEADO (COD_EMP, NOM_EMP, APE_EMP, CEL_EMP, CORREO_EMP, DIRECCION_EMP, SUELDO, ID_DIS, FOTO_EMP, FEC_NAC_EMP, ID_TIP) VALUES (1,'Jorge','gonzales', 545678909, 'jorge@gmail.com', 'el bosque', 2000.0000, 3, '~/fotos_empleados/1.jpg', CAST('1992-12-12' AS Date), 1)
INSERT EMPLEADO (COD_EMP, NOM_EMP, APE_EMP, CEL_EMP, CORREO_EMP, DIRECCION_EMP, SUELDO, ID_DIS, FOTO_EMP, FEC_NAC_EMP, ID_TIP) VALUES (2,'Pedro','Sanchez', 545678909, 'pedro@gmail.com', 'el bosque', 2000.0000, 3, '~/fotos_empleados/1.jpg', CAST('1992-12-12' AS Date), 1)
go

INSERT PROVEEDOR ( EMPRESA_PROV, NOM_PROV, CARGO_PROV, IDE_DIS, FONO_PROV) VALUES ('Frutas ricas', 'Juan Arturo', 'GERENTE', 1, '564758654 ');
INSERT PROVEEDOR ( EMPRESA_PROV, NOM_PROV, CARGO_PROV, IDE_DIS, FONO_PROV) VALUES ( 'Bebe feliz', 'Cesar Glenn', 'GERENTE', 2, '455432345');
INSERT PROVEEDOR ( EMPRESA_PROV, NOM_PROV, CARGO_PROV, IDE_DIS, FONO_PROV) VALUES ( 'Todo a tu alcance ', 'Diego Arturo', 'GERENTE', 3, '098765643');
INSERT PROVEEDOR ( EMPRESA_PROV, NOM_PROV, CARGO_PROV, IDE_DIS, FONO_PROV) VALUES ( 'Del campo a tu mesa', 'Arian Juan', 'GERENTE', 1, '343234567');
INSERT PROVEEDOR ( EMPRESA_PROV, NOM_PROV, CARGO_PROV, IDE_DIS, FONO_PROV) VALUES ( 'Todo limpio', 'Pedro Anacleto', 'GERENTE', 3, '453456765');
go

INSERT PRODUCTO (NOM_PRO, ID_TIP_PRO, STOCK_PROD, PRECIO, DESCRIPCION, ID_PROV, FOTO_PROD) VALUES ('Palta', 1, 90, 5.00, 'Palta Fuerte', 1, '~/img/Palta.jpg')
INSERT PRODUCTO (NOM_PRO, ID_TIP_PRO, STOCK_PROD, PRECIO, DESCRIPCION, ID_PROV, FOTO_PROD) VALUES ('Cocacola', 4, 20, 2.50, 'Gaseosa COCA COLA Botella 2.25L Paquete', 4, '~/img/Cocacola.jpg')
INSERT PRODUCTO (NOM_PRO, ID_TIP_PRO, STOCK_PROD, PRECIO, DESCRIPCION, ID_PROV, FOTO_PROD) VALUES ('Huggies', 3, 20, 1.50, 'Pañales para Bebé HUGGIES Puro y Natural Talla XXG Paquete 38un', 2, '~/img/Huggies.jpg')
INSERT PRODUCTO (NOM_PRO, ID_TIP_PRO, STOCK_PROD, PRECIO, DESCRIPCION, ID_PROV, FOTO_PROD) VALUES ('Vaselina', 3, 50, 2.00, 'Vaselina para Bebé PORTUGAL Pote 100g', 4, '~/img/Vaselina.jpg')
INSERT PRODUCTO (NOM_PRO, ID_TIP_PRO, STOCK_PROD, PRECIO, DESCRIPCION, ID_PROV, FOTO_PROD) VALUES ('Arroz', 1, 120, 3.00, 'Arroz Extra COSTEÑO Bolsa 5Kg', 4, '~/img/Arroz.jpg')
INSERT PRODUCTO (NOM_PRO, ID_TIP_PRO, STOCK_PROD, PRECIO, DESCRIPCION, ID_PROV, FOTO_PROD) VALUES ('Ace', 4, 30, 8.00, 'Detergente en Polvo ACE Floral Bolsa 780g', 2, '~/img/Ace.jpg')
INSERT PRODUCTO (NOM_PRO, ID_TIP_PRO, STOCK_PROD, PRECIO, DESCRIPCION, ID_PROV, FOTO_PROD) VALUES ('Choclo', 1, 40,5.00, 'Choclo Desgranado FIFU Bolsa 500g', 3, '~/img/Choclo.jpg')
go






