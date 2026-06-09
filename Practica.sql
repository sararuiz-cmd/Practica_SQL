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