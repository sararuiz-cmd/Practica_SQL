use master
go
if exists(select 1 from sys.databases where name like 'HospitalDB')
begin
	drop database HospitalDB
end
go
create database HospitalDB
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
--Medicos
create table Personal.Medicos(
	id_medico int identity(1,1) primary key,
	nombre_medico nvarchar(50) not null,
	correo_medico nvarchar(50),
	edad_medico int,
	salario decimal (10,2) not null,
	created_at datetime default getdate(),
	updated_at datetime default getdate(),
	deleted_at datetime default getdate()
)
go
--Especialidades 
create table Personal.Especialidades(
	id_especialidad int entity(1,1) primary key,
	nombre_especialidad nvarchar(50) not null,
	created_at datetime default getdate(),
	updated_at datetime default getdate(),
	deleted_at datetime default getdate()

)
go
--Citas
create table Monitoreo.Citas(
	id_cita int entity(1,1) primary key,
	paciente nvarchar(50) not null,
	medico nvarchar(50) not null,
	created_at datetime default getdate(),
	updated_at datetime default getdate(),
	deleted_at datetime default getdate()
)
go
--Habitaciones
create table Locacion.Habitaciones(
	id_habitacion int entity(1,1) primary key,
	paciente nvarchar(50) not null,
	created_at datetime default getdate(),
	updated_at datetime default getdate(),
	deleted_at datetime default getdate()
)
go
--Tratamiento
create table Monitoreo.Tratamiento(
	id_tratamiento int entity(1,1) primary key,
	nombre_tratamiento nvarchar(50) not null,
	paciente nvarchar(50),
	medico nvarchar(50),
	costo decimal(10,2) not null,
	created_at datetime default getdate(),
	updated_at datetime default getdate(),
	deleted_at datetime default getdate()

)
go
--Medicamentos
create table Monitoreo.Medicamento(
	id_medicamento int entity(1,1) primary key,
	nombre_medicamento nvarchar(50) not null,
	tratamiento nvarchar(50),
	created_at datetime default getdate(),
	updated_at datetime default getdate(),
	deleted_at datetime default getdate()

)
go