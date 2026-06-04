use master
go
if exists(select 1 from sys.databases where name like 'HospitalDB')
begin
	drop database HospitalDB
end 
go
create database HospitalDB
go