use master
go
if exists(select * from sys.databases where name = 'EmpresaSQL')
begin
	drop database EmpresaSQL
end
go
create database EmpresaSQL
go
use EmpresaSQL
go
create schema Ubicacion
go
create schema Empleados
go
create schema Proyecto
go
create table Ubicacion.TDepartamento(
	nDepartamentoID int identity(1,1) primary key,
	cNombreDepartamento nvarchar(100) not null unique,
	created_at datetime default getdate(),
	updated_at datetime,
	deleted_at datetime
)
go
create table Empleados.TCargo(
	nCargoID int identity(1,1) primary key,
	cNombreCargo nvarchar(100) not null unique,
	created_at datetime default getdate(),
	updated_at datetime,
	deleted_at datetime
)
go
create table Empleados.TEmpleado(
	nEmpleadoID int identity(1,1) primary key,
	cNIF varchar(8) not null unique,
	cNombre nvarchar(100) not null,
	cApellido nvarchar(100) not null,
	nDepartamentoID int,
	nCargoID int,
	dFechaContratacion datetime not null default getdate(),
	nSalario decimal(10,2) not null,
	created_at datetime default getdate(),
	updated_at datetime,
	deleted_at datetime,
	constraint ck_salario check(nSalario>300),
	constraint fk_departamento foreign key(nDepartamentoID) references Ubicacion.TDepartamento(nDepartamentoID),
	constraint fk_cargo foreign key(nCargoID) references Empleados.TCargo(nCargoID)
)
go
create table Proyecto.TProyecto(
	id_proyecto int identity(1,1) primary key,
	nombre_proyecto nvarchar(100) not null,
	fecha_inicio datetime not null,
	fecha_finalizacion datetime,
	created_at datetime default getdate(),
	updated_at datetime,
	deleted_at datetime

)
go
create table Proyecto.TEmpleadoProyecto(
	id_proyecto int not null,
	id_empleado int not null,
	constraint pk_proyecto_empleado primary key(id_proyecto,id_empleado),
	constraint fk_proyecto foreign key (id_proyecto) references Proyecto.TProyecto(id_proyecto),
	constraint fk_empleado foreign key (id_empleado) references Empleados.TEmpleado(nEmpleadoID)
)
go

--Modificacion de estructuras
alter table Empleados.TEmpleado add cEmail varchar(40)
go
alter table Empleados.TEmpleado add telefono int
go
alter table Empleados.TEmpleado alter column cNombre nvarchar(100)
go
alter table Empleados.TEmpleado alter column cApellido nvarchar(100)
go
alter table Empleados.TEmpleado add cDireccion nvarchar(100)
go
alter table Empleados.TEmpleado add nEdad int
go
alter table Empleados.TEmpleado add constraint ck_edad check(nEdad between 18 and 65)
go
alter table Empleados.TEmpleado add constraint uq_email unique(cEmail)
go
alter table Empleados.TEmpleado add bActivo  bit default 1
go
alter table Empleados.TEmpleado drop column cDireccion
go
alter table Empleados.TEmpleado alter column telefono varchar(20)
go
alter table Empleados.TEmpleado add cGenero bit 
go
alter table Empleados.TEmpleado alter column cGenero char(1)
go
alter table Empleados.TEmpleado add constraint ck_genero check(cGenero in ('M', 'F'))
go
alter table Empleados.TEmpleado add dFechaNacimiento datetime
go
create table Ubicacion.TSucursal(
	id_sucursal int identity(1,1) primary key,
	nombre_sucursal nvarchar(50) not null
)
go
--Insercion de datos
--Departamento
insert into Ubicacion.TDepartamento(cNombreDepartamento)
values ('Contabilidad')
go
insert into Ubicacion.TDepartamento(cNombreDepartamento)
values ('Recursos humanos'),('TI'),('Tesoreria'),('Gerencia')
go
--Cargos
insert into Empleados.TCargo(cNombreCargo)
values('Vendedor'),('Secretaria'),('Gerente'),('Desarrollador'),('Contador')
go
--Empleados
insert into Empleados.TEmpleado
(cNIF, cNombre, cApellido, nDepartamentoID, nCargoID, dFechaContratacion, nSalario, cEmail, telefono, nEdad, bActivo, cGenero, dFechaNacimiento)
values
('112365','Max','Martinez',1,2,'20260608',70000,'martinez@gmail.com','126544',20,0,'M','20060418'),
('112366','Andrea','Lopez',2,3,'20260609',65000,'lopez@gmail.com','126545',21,0,'F','20050214'),
('112367','Carlos','Gomez',4,1,'20260610',72000,'gomez@gmail.com','126546',26,0,'M','19990830'),
('112368','Maria','Castillo',5,2,'20260611',68000,'castillo@gmail.com','126547',38,0,'F','19871105'),
('112369','Jose','Ramirez',1,5,'20260612',75000,'ramirez@gmail.com','126548',33,0,'M','19930601'),
('112370','Valeria','Mendoza',3,4,'20260613',70000,'mendoza@gmail.com','126549',23,0,'F','20021219'),
('112371','Luis','Hernandez',2,5,'20260614',80000,'hernandez@gmail.com','126550',51,0,'M','19750425'),
('112372','Karla','Torres',5,1,'20260615',69000,'torres@gmail.com','126551',35,0,'F','19900912'),
('112373','Miguel','Navarro',4,3,'20260616',73000,'navarro@gmail.com','126552',22,0,'M','20040107'),
('112374','Daniela','Reyes',1,4,'20260617',71000,'reyes@gmail.com','126553',60,0,'F','19650720');
go
--Proyecto
insert into Proyecto.TProyecto(nombre_proyecto,fecha_inicio,fecha_finalizacion)
values('Maro','20250822','20260412')
go
insert into Proyecto.TProyecto(nombre_proyecto,fecha_inicio,fecha_finalizacion)
values('Oracle','20220822','20260422'),('UAM','20070522','20260609')
go
--Empleados a proyecto 
insert into Proyecto.TEmpleadoProyecto(id_proyecto,id_empleado)
values
(1,1),
(1,2),
(1,3),
(2,4),
(2,5),
(3,6),
(3,7),
(3,8);
go
--Empleado valor defecto
insert into Empleados.TEmpleado
(cNIF,cNombre,cApellido,nDepartamentoID,nCargoID,nSalario,cEmail,telefono,nEdad,bActivo,cGenero,dFechaNacimiento)
values
('112375','Pedro','Santos',1,1,50000,'pedro@gmail.com','126554',25,1,'M','20010115');
go
--Insertar un empleado con correo electrónico
insert into Empleados.TEmpleado
(cNIF,cNombre,cApellido,nDepartamentoID,nCargoID,nSalario,cEmail,telefono,nEdad,bActivo,cGenero,dFechaNacimiento)
values
('112376','Laura','Ruiz',2,2,52000,'laura.ruiz@gmail.com','126555',28,1,'F','19980220');
go
--Insertar un empleado sin indicar estado activo
insert into Empleados.TEmpleado
(cNIF,cNombre,cApellido,nDepartamentoID,nCargoID,nSalario,cEmail,telefono,nEdad,cGenero,dFechaNacimiento)
values
('112377','Jorge','Perez',3,4,55000,'jorge@gmail.com','126556',30,'M','19950710');
go
--Insertar registros usando múltiples VALUES
insert into Empleados.TEmpleado
(cNIF,cNombre,cApellido,nDepartamentoID,nCargoID,nSalario,cEmail,telefono,nEdad,bActivo,cGenero,dFechaNacimiento)
values
('112378','Ana','Morales',1,2,48000,'ana@gmail.com','126557',24,1,'F','20020215'),
('112379','Mario','Flores',2,1,47000,'mario@gmail.com','126558',29,1,'M','19970108'),
('112380','Gabriela','Rojas',3,3,65000,'gabriela@gmail.com','126559',40,1,'F','19860311');
go
--Intentar insertar un salario negativo y analizar el error
/*insert into Empleados.TEmpleado
(cNIF,cNombre,cApellido,nDepartamentoID,nCargoID,nSalario,cEmail,telefono,nEdad,bActivo,cGenero,dFechaNacimiento)
values
('112381','Prueba','Error',1,1,-1000,'error@gmail.com','126560',25,1,'M','20000101');
go
Lo comentareo para q no me de error
*/
--Actualizaciones
--salario al 10%
update Empleados.TEmpleado set nSalario=nSalario*1.10
go
--20% salario de todos los emp de un dep
update Empleados.TEmpleado set nSalario=nSalario*1.20 where nDepartamentoID =3
go
--Actualizar el correo electrónico de un empleado
update Empleados.TEmpleado set cEmail='pedro@uam.ni' where nEmpleadoID=1
go
--Modificar el cargo de un empleado
update Empleados.TEmpleado
set nCargoID = 3
where cNIF = '112365';
go
--Cambiar el departamento de dos empleados
update Empleados.TEmpleado
set nDepartamentoID =
case
	when cNIF='112366' then 3
	when cNIF='112367' then 2
end
where cNIF in ('112366','112367');
go
-- Marcar como inactivos a los empleados con salario inferior a 500. 
update Empleados.TEmpleado
set bActivo = 0
where nSalario < 500;
go
--Actualizar la fecha de finalización de un proyecto.
update Proyecto.TProyecto
set fecha_finalizacion = '20261231'
where nombre_proyecto = 'Oracle';
go
--Asignar un nuevo proyecto a un empleado. 
insert into Proyecto.TProyecto
(nombre_proyecto,fecha_inicio,fecha_finalizacion)
values
('Sistema Hospitalario','20260610','20271231');
go
insert into Proyecto.TEmpleadoProyecto
(id_proyecto,id_empleado)
values
(4,1);
go
