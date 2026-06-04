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
