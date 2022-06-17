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

CREATE TABLE CATEGORIA(
	IDE_CAT int IDENTITY(1,1) not null primary key,
	NOM_CAT varchar (50) NOT NULL,
	DESCRIPCION varchar(50) NULL,
 )
 go

 CREATE TABLE CLIENTE(
	IDE_CLIE int not null primary key,
	NOM_CLI varchar(50) NOT NULL,
	APE_CLIE varchar(50) NULL,
	CORREO varchar(50) NULL,
	CONTRASEÑA varchar(50) NULL,
	DIR_CLIE varchar(50) NOT NULL,
	ID_DIS int NOT NULL,
	FON_CLIE varchar(50) NULL,
 )
 go

 CREATE TABLE DETALLE_PED(
	ID_PED int not null primary key,
	ID_PROD int NOT NULL,
	PREC_TOTAL money NOT NULL,
	CANT_PED int NOT NULL,
	DES_PED varchar(50) NOT NULL,
 ) 
 go

 CREATE TABLE DISTRITO(
	ID_DIS int not null primary key,
	NOMBRE varchar(50) NULL,
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
	ID_DIS int NULL,
	FOTO_EMP varchar(50) NULL,
	FEC_NAC_EMP date NULL,
	ID_TIP int NULL,
) 
go

CREATE TABLE PEDIDO(
	ID_PEDIDO int not null primary key,
	ID_EMP int NULL,
	FEC_PEDIDO date NULL,
	FIN_PEDIDO date NULL,
	ENV_PEDIDO char(1) NULL,
	CANT_PEDIDO int NULL,
	ID_CLIE int NULL,
	DET_PEDIDO varchar(50) NOT NULL,
	ID_EMPLEADO int NOT NULL,
	ID_DIS int NULL,
)
go

CREATE TABLE PRODUCTO(
	ID_PROD int IDENTITY(1,1) not null primary key,
	NOM_PRO varchar(50) NOT NULL,
	ID_TIP_PRO int NOT NULL,
	STOCK_PROD int NOT NULL,
	PRECIO money NOT NULL,
	DESCRIPCION varchar(200) NOT NULL,
	ID_PROV int NOT NULL,
	FOTO_PROD varchar (50) NULL,
)
go

CREATE TABLE PROVEEDOR(
	IDE_PROV int IDENTITY(1,1) not null primary key,
	EMPRESA_PROV varchar(50) NOT NULL,
	NOM_PROV varchar(50) NOT NULL,
	CARGO_PROV varchar(50) NOT NULL,
	IDE_DIS int NOT NULL,
	FONO_PROV nchar(10) NOT NULL,
 )
GO

CREATE TABLE TIP_EMP(
	ID_TIP int not null primary key,
	DESCRIPCION varchar(50) NOT NULL,
 )
GO

CREATE TABLE Usua(
	codigo int IDENTITY(1,1) not null primary key,
	usuario varchar(50) NULL,
	correo varchar(50) NULL,
	contraseña varchar(50) NULL,
)
go

CREATE TABLE USUARIO(
	ID int IDENTITY(1,1)  not null primary key,
	usuario varchar(50) NULL,
	correo varchar(50) NULL,
	contraseña varchar(50) NULL,
)
go

CREATE TABLE tb_user(
id int primary key references EMPLEADO,
logins varchar(20) unique,
clave varchar(10),
intentos int check(intentos<=3) default(0),
fecBloque datetime null
);
go

/****** creando las coneciones entre tablas ******/

ALTER TABLE [dbo].[CLIENTE]  WITH CHECK ADD  CONSTRAINT [FK_CLIENTE_DISTRITO] FOREIGN KEY([ID_DIS])
REFERENCES [dbo].[DISTRITO] ([ID_DIS])
go

ALTER TABLE [dbo].[CLIENTE] CHECK CONSTRAINT [FK_CLIENTE_DISTRITO]
go

ALTER TABLE [dbo].[DETALLE_PED]  WITH CHECK ADD  CONSTRAINT [FK_DETALLE_PED] FOREIGN KEY([ID_PED])
REFERENCES [dbo].[PEDIDO] ([ID_PEDIDO])
go

ALTER TABLE [dbo].[DETALLE_PED] CHECK CONSTRAINT [FK_DETALLE_PED]
go

ALTER TABLE [dbo].[DETALLE_PED]  WITH CHECK ADD  CONSTRAINT [FK_DETALLE_PED_PRODUCTO] FOREIGN KEY([ID_PROD])
REFERENCES [dbo].[PRODUCTO] ([ID_PROD])
go

ALTER TABLE [dbo].[DETALLE_PED] CHECK CONSTRAINT [FK_DETALLE_PED_PRODUCTO]
go

ALTER TABLE [dbo].[EMPLEADO]  WITH CHECK ADD  CONSTRAINT [FK_EMPLEADO_DISTRITO] FOREIGN KEY([ID_DIS])
REFERENCES [dbo].[DISTRITO] ([ID_DIS])
go

ALTER TABLE [dbo].[EMPLEADO] CHECK CONSTRAINT [FK_EMPLEADO_DISTRITO]
go

ALTER TABLE [dbo].[EMPLEADO]  WITH CHECK ADD  CONSTRAINT [FK_EMPLEADO_TIP_EMP] FOREIGN KEY([ID_TIP])
REFERENCES [dbo].[TIP_EMP] ([ID_TIP])
go

ALTER TABLE [dbo].[EMPLEADO] CHECK CONSTRAINT [FK_EMPLEADO_TIP_EMP]
go

ALTER TABLE [dbo].[PEDIDO]  WITH CHECK ADD  CONSTRAINT [FK_PEDIDO_CLIENTE] FOREIGN KEY([ID_CLIE])
REFERENCES [dbo].[CLIENTE] ([IDE_CLIE])
go

ALTER TABLE [dbo].[PEDIDO] CHECK CONSTRAINT [FK_PEDIDO_CLIENTE]
go

ALTER TABLE [dbo].[PEDIDO]  WITH CHECK ADD  CONSTRAINT [FK_PEDIDO_EMPLEADO] FOREIGN KEY([ID_EMPLEADO])
REFERENCES [dbo].[EMPLEADO] ([COD_EMP])
go

ALTER TABLE [dbo].[PEDIDO] CHECK CONSTRAINT [FK_PEDIDO_EMPLEADO]
go

ALTER TABLE [dbo].[PRODUCTO]  WITH CHECK ADD  CONSTRAINT [FK_PRODUCTO_CATEGORIA] FOREIGN KEY([ID_TIP_PRO])
REFERENCES [dbo].[CATEGORIA] ([IDE_CAT])
go

ALTER TABLE [dbo].[PRODUCTO] CHECK CONSTRAINT [FK_PRODUCTO_CATEGORIA]
go

ALTER TABLE [dbo].[PRODUCTO]  WITH CHECK ADD  CONSTRAINT [FK_PRODUCTO_PROVEEDOR] FOREIGN KEY([ID_PROV])
REFERENCES [dbo].[PROVEEDOR] ([IDE_PROV])
go

ALTER TABLE [dbo].[PRODUCTO] CHECK CONSTRAINT [FK_PRODUCTO_PROVEEDOR]
go


/****** creando los procedimientos almacenados 2  ******/










































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

INSERT PRODUCTO (NOM_PRO, ID_TIP_PRO, STOCK_PROD, PRECIO, DESCRIPCION, ID_PROV, FOTO_PROD) VALUES ('Palta', 1, 90, 5.00, 'Palta Fuerte', 1, '~/img/1.jpg')
INSERT PRODUCTO (NOM_PRO, ID_TIP_PRO, STOCK_PROD, PRECIO, DESCRIPCION, ID_PROV, FOTO_PROD) VALUES ('Coca cola', 4, 20, 2.50, 'Gaseosa COCA COLA Botella 2.25L Paquete', 4, '~/img/2.jpg')
INSERT PRODUCTO (NOM_PRO, ID_TIP_PRO, STOCK_PROD, PRECIO, DESCRIPCION, ID_PROV, FOTO_PROD) VALUES ('Huggies', 3, 20, 1.50, 'Pañales para Bebé HUGGIES Puro y Natural Talla XXG Paquete 38un', 2, '~/img/3.jpg')
INSERT PRODUCTO (NOM_PRO, ID_TIP_PRO, STOCK_PROD, PRECIO, DESCRIPCION, ID_PROV, FOTO_PROD) VALUES ('Vaselina', 3, 50, 2.00, 'Vaselina para Bebé PORTUGAL Pote 100g', 4, '~/img/4.jpg')
INSERT PRODUCTO (NOM_PRO, ID_TIP_PRO, STOCK_PROD, PRECIO, DESCRIPCION, ID_PROV, FOTO_PROD) VALUES ('Arroz', 1, 120, 3.00, 'Arroz Extra COSTEÑO Bolsa 5Kg', 4, '~/img/5.jpg')
INSERT PRODUCTO (NOM_PRO, ID_TIP_PRO, STOCK_PROD, PRECIO, DESCRIPCION, ID_PROV, FOTO_PROD) VALUES ('Ace', 4, 30, 8.00, 'Detergente en Polvo ACE Floral Bolsa 780g', 2, '~/img/6.jpg')
INSERT PRODUCTO (NOM_PRO, ID_TIP_PRO, STOCK_PROD, PRECIO, DESCRIPCION, ID_PROV, FOTO_PROD) VALUES ('Choclo', 1, 40,5.00, 'Choclo Desgranado FIFU Bolsa 500g', 3, '~/img/7.jpg')
go

INSERT USUARIO (usuario, correo, contraseña) VALUES ('deyvis', 'deyvis@gmail.com', '1234')
INSERT USUARIO (usuario, correo, contraseña) VALUES ('aaa', 'aaa', 'aaa')
INSERT USUARIO (usuario, correo, contraseña) VALUES ('aaa', 'www', 'www')
INSERT USUARIO (usuario, correo, contraseña) VALUES ('eee', 'eeee', 'eee')
INSERT USUARIO (usuario, correo, contraseña) VALUES ('wwww', 'wwww', 'wwwww')
INSERT USUARIO (usuario, correo, contraseña) VALUES ('Deyvis', 'deyvis@gmail.com', '1234')
INSERT USUARIO (usuario, correo, contraseña) VALUES ('Jorge', 'jorge@gmail.comn', '1234')
INSERT USUARIO (usuario, correo, contraseña) VALUES ('Jorge', 'jorge@gmail.com', '1234')
INSERT USUARIO (usuario, correo, contraseña) VALUES ('Juan', 'juan@gmail.com', '1234')
INSERT USUARIO (usuario, correo, contraseña) VALUES ('Juan', 'juan@gmail.com', '1234')
go

INSERT tb_user (id,logins,clave) values (1,'juan26','2222');
INSERT tb_user (id,logins,clave) values (2,'pedro26','1111');

go



/****** creando los procedimientos almacenados ******/

-- procedimiento de verificar el usuario si existe
create or alter proc usp_verifica_acceso
@login varchar(20),
@clave varchar (10),
@fullname varchar (150) output,
@sw varchar(1) output
as
begin
       declare @id int = (select id from tb_user where logins=@login and clave=@clave)
	   if(@id is null)
	                   begin 
					          set @sw = '0'
							  set @fullname = 'Usuario o clave incorrecta, intentar nueva mente por favor'
					   end
	   else
	                   begin 
					          set @sw = '1'
							  set @fullname = (select concat(p.NOM_EMP,' ',p.APE_EMP) from EMPLEADO p where p.COD_EMP=@id)
					   end
end
go

--ejecutar procedimiento verificar el usuario si existe = usp_verifica_acceso
declare @nombre varchar(40), @sw varchar(1)
exec usp_verifica_acceso 'juand26' ,234, @nombre output, @sw output
print @nombre
print @sw
go

CREATE PROC SP_ACTUALIZAPRODUCTO (@IDE INT,@NOM VARCHAR(50),@CAT INT,@STO INT,@PRE money,
@DES VARCHAR(200),@PROV INT,@FOT VARCHAR(50))
AS
UPDATE PRODUCTO
SET NOM_PRO=@NOM,ID_TIP_PRO=@CAT,STOCK_PROD=@STO,
PRECIO=@PRE,DESCRIPCION=@DES,ID_PROV=@PROV,FOTO_PROD=@FOT
WHERE ID_PROD=@IDE
GO

CREATE PROC SP_ACTUALIZAPROVEEDOR(@IDPROV INT,@EMPRESA VARCHAR(50),@NOMBREPROVEEDOR VARCHAR(50),@CARGOPROVEEDOR VARCHAR(50),
@IDDIS INT,@TELEFONO NCHAR(10))
AS
	UPDATE PROVEEDOR
	SET EMPRESA_PROV= @EMPRESA,NOM_PROV=@NOMBREPROVEEDOR,CARGO_PROV=@CARGOPROVEEDOR, IDE_DIS=@IDDIS,FONO_PROV=@TELEFONO
	WHERE IDE_PROV=@IDPROV
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

CREATE PROC SP_ELIMINAPROVEEDOR(@IDE INT)
AS
DELETE PROVEEDOR WHERE IDE_PROV=@IDE
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

CREATE PROC SP_LISTAPROVEEDOR
AS
SELECT PRO.IDE_PROV,PRO.EMPRESA_PROV,PRO.NOM_PROV, PRO.CARGO_PROV,
D.NOMBRE as DISTRITO,PRO.FONO_PROV
FROM PROVEEDOR PRO
INNER JOIN DISTRITO D 
ON PRO.IDE_DIS=D.ID_DIS
GO
--------------------------------------------------------------------------------------------------
--CREATE PROC SP_LOGIN(@correo varchar(50),@contraseña varchar(20))
--AS
   
--BEGIN 
 --    SELECT E.CORREO_EMP,E.CONTRASEÑA FROM DBO.EMPLEADO E
--	 WHERE E.CORREO_EMP=@correo and E.CONTRASEÑA=@contraseña;
--END
--GO
------------------------------------------------------------------------------------

CREATE PROC SP_NUEVOPRODUCTO (@NOM VARCHAR(50),@CAT INT,@STO INT,@PRE money,
@DES VARCHAR(200),@PROV INT,@FOT VARCHAR(50))
AS
INSERT INTO PRODUCTO VALUES(@NOM,@CAT,@STO,@PRE,@DES,@PROV,@FOT)
GO

CREATE PROC SP_NUEVOPROVEEDOR(@emp VARCHAR(50),@NOM VARCHAR(50),@cargo VARCHAR(20),
@DIS INT,@FON VARCHAR(15))
AS
INSERT INTO PROVEEDOR VALUES(@emp,@NOM,@cargo,@DIS,@Fon)
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

CREATE PROC SP_PROVEEDOR
AS
SELECT *
FROM PROVEEDOR
GO




