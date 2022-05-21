Use Master
go

if exists(Select * from sys.databases  Where name='pon_el_hombro')
Begin
	Drop Database pon_el_hombro
End
go

create database pon_el_hombro
go

USE pon_el_hombro
go

set dateformat ymd
go

CREATE TABLE tb_estado (
  id_esta int identity (1,1) not null primary key,
  nom_esta varchar(100) not null
)
go

INSERT INTO tb_estado (nom_esta) VALUES('No vacunado')
INSERT INTO tb_estado (nom_esta) VALUES('Vacunado')
go

CREATE TABLE tb_tipo_vacuna (
  id_tpva int identity (1,1) not null primary key,
  nom_tpva varchar(100) not null unique,
  dosis_tpva char(4) not null,
  pais_tpva varchar(100) NOT NULL
)
go

INSERT INTO tb_tipo_vacuna (nom_tpva, dosis_tpva, pais_tpva) VALUES ('sinorphan', '2', 'China');
INSERT INTO tb_tipo_vacuna (nom_tpva, dosis_tpva, pais_tpva) VALUES ('Pfizer', '2', 'USA');
go

CREATE TABLE tb_cargo(
id_car int identity (1,1) not null primary key,
nom_car varchar(100) NOT NULL unique
);
go

INSERT INTO tb_cargo (nom_car) values ('Administrador');
INSERT INTO tb_cargo (nom_car) values ('Doctor');
INSERT INTO tb_cargo (nom_car) values ('Doctora');
go

CREATE TABLE tb_empleados(
id_emp  int identity (1,1) not null primary key,
nom_emp varchar(100) NOT NULL unique,
ape_emp varchar(100) NOT NULL,
tlf_emp char(9) NOT NULL unique,
edad_emp varchar(2) not null,
idcargo int references tb_cargo
);
go

INSERT INTO tb_empleados (nom_emp,ape_emp,tlf_emp,edad_emp,idcargo) values ('Juan Diego','Mejia',234543217,26,2);
INSERT INTO tb_empleados (nom_emp,ape_emp,tlf_emp,edad_emp,idcargo) values ('Anna Patricia','Mamani',564789834,21,1);
INSERT INTO tb_empleados (nom_emp,ape_emp,tlf_emp,edad_emp,idcargo) values ('Oliver Luis','Palacios',665478978,25,2);
INSERT INTO tb_empleados (nom_emp,ape_emp,tlf_emp,edad_emp,idcargo) values ('Pepe Juan','Velasuqez',435667898,26,1);
INSERT INTO tb_empleados (nom_emp,ape_emp,tlf_emp,edad_emp,idcargo) values ('Brenda Luana','Chuquilin',330098908,20,3);
INSERT INTO tb_empleados (nom_emp,ape_emp,tlf_emp,edad_emp,idcargo) values ('Carol Rut','Palacios',456600989,29,3);
INSERT INTO tb_empleados (nom_emp,ape_emp,tlf_emp,edad_emp,idcargo) values ('Antonio Arturo','De las casas',567748909,26,2);
INSERT INTO tb_empleados (nom_emp,ape_emp,tlf_emp,edad_emp,idcargo) values ('Glenn Arturo','Mejia',009098643,24,2);
go

CREATE TABLE tb_ciudadanos(
id_ciud int identity (1,1) not null primary key,
nom_ciud varchar(100) NOT NULL unique,
ape_ciud varchar(100) NOT NULL,
tlf_ciud char(9) NOT NULL unique,
direccion_ciud varchar(200) NOT NULL,
dni_ciud char(9) NOT NULL unique,
nacim_ciud date NOT NULL,
idestado int references tb_cargo
);
go

INSERT INTO tb_ciudadanos (nom_ciud,ape_ciud,tlf_ciud,direccion_ciud,dni_ciud,nacim_ciud,idestado) values ('Juan','Mejia',12345678,'La esperanza','22222222','1999-12-20',1);
INSERT INTO tb_ciudadanos (nom_ciud,ape_ciud,tlf_ciud,direccion_ciud,dni_ciud,nacim_ciud,idestado) values ('Martin','Mejia',12345677,'La esperanza','11111111','2001-12-21',1);
INSERT INTO tb_ciudadanos (nom_ciud,ape_ciud,tlf_ciud,direccion_ciud,dni_ciud,nacim_ciud,idestado) values ('Glenn','Mejia',12345666,'La esperanza','10101010','2018-12-21',1);
INSERT INTO tb_ciudadanos (nom_ciud,ape_ciud,tlf_ciud,direccion_ciud,dni_ciud,nacim_ciud,idestado) values ('Diego','Mejia',12345656,'La esperanza','20987290','2018-12-21',1);
INSERT INTO tb_ciudadanos (nom_ciud,ape_ciud,tlf_ciud,direccion_ciud,dni_ciud,nacim_ciud,idestado) values ('Pepe','Mejia',12323432,'La esperanza','23789000','2018-12-21',1);
INSERT INTO tb_ciudadanos (nom_ciud,ape_ciud,tlf_ciud,direccion_ciud,dni_ciud,nacim_ciud,idestado) values ('Arturo','Mejia',10094356,'La esperanza','23435654','2018-12-21',1);
INSERT INTO tb_ciudadanos (nom_ciud,ape_ciud,tlf_ciud,direccion_ciud,dni_ciud,nacim_ciud,idestado) values ('Alan','Mejia',11100045,'La esperanza','34543490','2018-12-21',1);
INSERT INTO tb_ciudadanos (nom_ciud,ape_ciud,tlf_ciud,direccion_ciud,dni_ciud,nacim_ciud,idestado) values ('Alverto','Mejia',12343276,'La esperanza','00985643','2018-12-21',1);
INSERT INTO tb_ciudadanos (nom_ciud,ape_ciud,tlf_ciud,direccion_ciud,dni_ciud,nacim_ciud,idestado) values ('Aldair','Mejia',12300980,'La esperanza','23437655','2018-12-21',1);
go

CREATE TABLE tb_detalle_ciudadanos(
iddetalle int identity (1,1) not null primary key,
idempleados  int references tb_empleados,
idvacuna    int references tb_tipo_vacuna,
idciudadanos int references tb_ciudadanos,
fecha_dosis date ,
numero_vacu char(4)
);
go

CREATE TABLE tb_user(
id int primary key references tb_empleados,
logins varchar(20) unique,
clave varchar(10),
intentos int check(intentos<=3) default(0),
fecBloque datetime null
);
go

INSERT INTO tb_user (id,logins,clave) values (1,'juand26','2345');
INSERT INTO tb_user (id,logins,clave) values (2,'annap21','9876');
INSERT INTO tb_user (id,logins,clave) values (3,'oliverl25','7768');
INSERT INTO tb_user (id,logins,clave) values (4,'pepej26','2232');
INSERT INTO tb_user (id,logins,clave) values (5,'brendal20','1111');
INSERT INTO tb_user (id,logins,clave) values (6,'carolr29','4456');
INSERT INTO tb_user (id,logins,clave) values (7,'antonioa26','4530');
INSERT INTO tb_user (id,logins,clave) values (8,'glenna24','2222');
go

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
							  set @fullname = (select concat(p.nom_emp,' ',p.ape_emp) from tb_empleados p where p.id_emp=@id)
					   end
end
go

--ejecutar procedimiento verificar el usuario si existe = usp_verifica_acceso
declare @nombre varchar(40), @sw varchar(1)
exec usp_verifica_acceso 'juand26' ,234, @nombre output, @sw output
print @nombre
print @sw

