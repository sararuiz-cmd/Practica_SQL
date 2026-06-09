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
)go
create table Empleados.TCargo(
	nCargoID int identity(1,1) primary key,
	cNombreCargo nvarchar(100) not null unique,
	created_at datetime default getdate(),
	updated_at datetime,
	deleted_at datetime
)go
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
)go
create table Proyecto.TProyecto(
	id_proyecto int identity(1,1) primary key,
	nombre_proyecto nvarchar(100) not null,
	fecha_inicio datetime not null,
	fecha_finalizacion datetime,
	created_at datetime default getdate(),
	updated_at datetime,
	deleted_at datetime

)go
create table Proyecto.TEmpleadoProyecto(
	id_proyecto int not null,
	id_empleado int not null,
	constraint pk_proyecto_empleado primary key(id_proyecto,id_empleado),
	constraint fk_proyecto foreign key (id_proyecto) references Proyecto.TProyecto(id_proyecto),
	constraint fk_empleado foreign key (id_empleado) references Empleados.TEmpleado(nEmpleadoID)
)go

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
