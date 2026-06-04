use master
go
if exists(select 1 from sys.databases where name = 'HospitalDB')
begin
	drop database HospitalDB
end
go
create database HospitalDB
go
--Mostrar todas las bases de datos existentes.
--select * from sys.databases
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
--Habitaciones
create table Locacion.Habitaciones(
	id_habitacion int identity(1,1) primary key,
	paciente nvarchar(50) not null,
	created_at datetime default getdate(),
	updated_at datetime null,
	deleted_at datetime null
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
	updated_at datetime null,
	deleted_at datetime null,
	constraint uq_correo_medico unique (correo_medico),
	constraint ck_edad_medico check (edad_medico>0),
	constraint ck_salario check (salario>0)

)
go
--Paciente
create table Personal.Pacientes(
	id_paciente int identity(1,1) primary key,
	nombre_paciente nvarchar(50) not null,
	correo_paciente nvarchar(50),
	edad_paciente int,
	habitacion int not null,
	created_at datetime default getdate(),
	uptaded_at datetime null,
	deleted_at datetime null,
	constraint uq_correo_paciente unique (correo_paciente),
	constraint ck_edad_paciente check (edad_paciente>0),
	constraint fk_habitacion foreign key (habitacion) references Locacion.Habitaciones (id_habitacion)
)
go

--Especialidades 
create table Personal.Especialidades(
	id_especialidad int identity(1,1) primary key,
	nombre_especialidad nvarchar(50) not null,
	id_medico int not null,
	created_at datetime default getdate(),
	updated_at datetime null,
	deleted_at datetime null,
	constraint fk_medico_especialidad foreign key (id_medico) references Personal.Medicos(id_medico)

)
go
--Citas
create table Monitoreo.Citas(
	id_cita int identity(1,1) primary key,
	id_paciente int not null,
	id_medico int not null,
	created_at datetime default getdate(),
	updated_at datetime null,
	deleted_at datetime null,
	constraint fk_paciente foreign key (id_paciente) references Personal.Pacientes (id_paciente),
	constraint fk_medico foreign key (id_medico) references Personal.Medicos (id_medico)
)
go
--Medicamentos
create table Monitoreo.Medicamento(
	id_medicamento int identity(1,1) primary key,
	nombre_medicamento nvarchar(50) not null,
	tratamiento nvarchar(50),
	created_at datetime default getdate(),
	updated_at datetime null,
	deleted_at datetime null

)
go


--Tratamiento
create table Monitoreo.Tratamiento(
	id_tratamiento int identity(1,1) primary key,
	nombre_tratamiento nvarchar(50) not null,
	id_paciente int,
	costo decimal(10,2) not null,
	medicamento int not null,
	created_at datetime default getdate(),
	updated_at datetime null,
	deleted_at datetime null,
	constraint fk_paciente_tratamiento foreign key (id_paciente) references Personal.Pacientes (id_paciente),
	constraint fk_medicamento foreign key (medicamento) references Monitoreo.Medicamento (id_medicamento)
)
go
--Modificacion de estructuras
--Pacientes
alter table Personal.Pacientes add telefono int
go
alter table Personal.Pacientes add direccion nvarchar(200)
go
alter table Personal.Pacientes add genero bit --(1 hombre, 0 mujer)
go
alter table Personal.Pacientes add tipo_sangre varchar(2)
go
alter table Personal.Pacientes add fecha_nacimiento datetime
go
alter table Personal.Pacientes add direccion_paciente nvarchar(100)
go
alter table Personal.Pacientes alter column nombre_paciente nvarchar(100)
go
alter table Personal.Pacientes alter column direccion_paciente nvarchar(200)
go
--Medicos
alter table Personal.Medicos add genero bit 
alter table Personal.Medicos add tipo_sangre_medicos varchar(2)
go
alter table Personal.Medicos add fecha_nacimiento_medicos datetime
go
alter table Personal.Medicos add direccion_medico nvarchar(100)
go
alter table Personal.Pacientes alter column nombre_medico nvarchar(100)
go
alter table Personal.Pacientes alter column direccion_medico nvarchar(200)
go

select * from Personal.Pacientes

alter table Personal.Pacientes drop column fecha_nacimiento_medicos
go