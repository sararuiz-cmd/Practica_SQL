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


)go