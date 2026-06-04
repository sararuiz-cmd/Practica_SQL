use master
go
if exists(select 1 from sys.databases where name like 'HospitalDB')
begin
	drop database HospitalDB
end 
go
create database HospitalDB
go
--Mostrar todas las bases de datos existentes.
select * from sys.databases
use HospitalDB
go
--Creacion de schemas
create schema Personal
go
create schema Monitoreo
go
create schema Locacion
go

--crear tablas
--Paciente
create table Personal.Pacientes(
	id_paciente int identity(1,1) primary key,
	nombre_paciente nvarchar(50) not null,
	correo_paciente nvarchar(50),
	edad_paciente int,
	created_at datetime default getdate(),
	uptaded_at datetime default getdate(),
	deleted_atcdate datetime default getdate()
)
go
