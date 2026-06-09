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
