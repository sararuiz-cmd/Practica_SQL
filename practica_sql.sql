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
	constraint ck_prueba check (id_paciente>0),
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
alter table Personal.Medicos add experiencia nvarchar(100)
go
alter table Personal.Medicos add turnos nvarchar(100)
go
alter table Personal.Medicos add observaciones nvarchar(100)
go
alter table Personal.Medicos drop column observaciones
go

--Citas
alter table Monitoreo.Citas add estado varchar(50)
go
alter table Monitoreo.Citas add costo_consulta decimal(10,2)
go
alter table Monitoreo.Citas alter column costo_consulta int
go

--Habitaciones
alter table Locacion.Habitaciones add disponibilidad bit
go

--Tabla temporal
create table dbo.Temp(
	id_tabla int identity(1,1) primary key clustered,
	validfrom datetime2 generated always as row start,
	validto datetime2 generated always as row end,
	period for system_time (validfrom,validto)
)
with (system_versioning = on (history_table = dbo.TempHistory))
go
--Eliminar tabla temporal
alter table dbo.Temp set (system_versioning=off)
go
drop table dbo.Temp
go
--Eliminar check
alter table Monitoreo.Tratamiento drop constraint ck_prueba
go

--Eliminar una restricción unique
alter table personal.medicos drop constraint uq_correo_medico
go

--Eliminar una columna
alter table personal.medicos drop column experiencia
go
--Volver a agregar
alter table personal.medicos add experiencia nvarchar(100)

--Eliminar una foreign key
alter table monitoreo.tratamiento drop constraint fk_medicamento
go

--Crear tabla de pruebas
create table dbo.tabla_pruebas(
	id_prueba int identity(1,1) primary key,
	descripcion nvarchar(100),
	created_at datetime default getdate()
)
go

--Inserts
--Insertar 10 habitaciones
insert into Locacion.Habitaciones(paciente, disponibilidad)
values
('carlos mejia', 0),
('maria lopez', 0),
('jose ramirez', 0),
('ana castillo', 0),
('pedro torres', 0),
('lucia flores', 1),
('manuel cruz', 1),
('sofia reyes', 1),
('daniel mora', 1),
('elena campos', 1)
go

--Insertar habitaciones ocupadas
insert into Locacion.Habitaciones(paciente, disponibilidad)
values
('fernando salinas', 0),
('gabriela rios', 0)
go

--Insertar habitaciones disponibles
insert into Locacion.Habitaciones(paciente, disponibilidad)
values
('sin asignar', 1),
('sin asignar', 1)
go

--Insertar 10 médicos
insert into Personal.Medicos(nombre_medico, correo_medico, edad_medico, salario, genero, tipo_sangre_medicos, fecha_nacimiento_medicos, direccion_medico, turnos)
values
('roberto alvarez', 'roberto.alvarez@hospital.com', 45, 35000.00, 1, 'o+', '19790312', 'managua', 'matutino'),
('claudia herrera', 'claudia.herrera@hospital.com', 38, 32000.00, 0, 'a+', '19860620', 'masaya', 'vespertino'),
('miguel castro', 'miguel.castro@hospital.com', 50, 40000.00, 1, 'b+', '19740110', 'granada', 'nocturno'),
('paola mendoza', 'paola.mendoza@hospital.com', 41, 36000.00, 0, 'o-', '19830905', 'leon', 'matutino'),
('andres navarro', 'andres.navarro@hospital.com', 35, 30000.00, 1, 'a-', '19891118', 'esteli', 'vespertino'),
('karla espinoza', 'karla.espinoza@hospital.com', 44, 37000.00, 0, 'b-', '19800422', 'chinandega', 'nocturno'),
('fernando ruiz', 'fernando.ruiz@hospital.com', 39, 33000.00, 1, 'o+', '19850214', 'rivas', 'matutino'),
('valeria solis', 'valeria.solis@hospital.com', 36, 31000.00, 0, 'a+', '19880730', 'carazo', 'vespertino'),
('hugo martinez', 'hugo.martinez@hospital.com', 48, 39000.00, 1, 'o-', '19761209', 'boaco', 'nocturno'),
('natalia vega', 'natalia.vega@hospital.com', 33, 29500.00, 0, 'b+', '19910517', 'matagalpa', 'matutino')
go


--Insertar 5 especialidades médicas
insert into Personal.Especialidades(nombre_especialidad, id_medico)
values
('cardiologia', 1),
('pediatria', 2),
('neurologia', 3),
('dermatologia', 4),
('medicina general', 5)
go

--Insertar médicos especialistas
insert into Personal.Especialidades(nombre_especialidad, id_medico)
values
('ginecologia', 6),
('traumatologia', 7),
('oftalmologia', 8),
('urologia', 9),
('psiquiatria', 10)
go

--Insertar 20 medicamentos
insert into Monitoreo.Medicamento(nombre_medicamento, tratamiento)
values
('paracetamol', 'dolor y fiebre'),
('ibuprofeno', 'inflamacion'),
('amoxicilina', 'infeccion'),
('loratadina', 'alergia'),
('omeprazol', 'gastritis'),
('metformina', 'diabetes'),
('losartan', 'hipertension'),
('salbutamol', 'asma'),
('diclofenaco', 'dolor muscular'),
('azitromicina', 'infeccion respiratoria'),
('enalapril', 'presion arterial'),
('cetirizina', 'alergia'),
('insulina', 'diabetes'),
('ranitidina', 'acidez'),
('naproxeno', 'dolor'),
('ceftriaxona', 'infeccion severa'),
('clonazepam', 'ansiedad'),
('atorvastatina', 'colesterol'),
('furosemida', 'retencion de liquidos'),
('prednisona', 'inflamacion')
go

--Insertar 20 pacientes
insert into Personal.Pacientes(nombre_paciente, correo_paciente, edad_paciente, habitacion, telefono, direccion, genero, tipo_sangre, fecha_nacimiento, direccion_paciente)
values
('carlos mejia', 'carlos.mejia@gmail.com', 30, 1, 88881111, 'managua', 1, 'o+', '19940210', 'barrio san judas'),
('maria lopez', 'maria.lopez@gmail.com', 25, 2, 88882222, 'masaya', 0, 'a+', '19990515', 'reparto san juan'),
('jose ramirez', 'jose.ramirez@gmail.com', 42, 3, 88883333, 'granada', 1, 'b+', '19820820', 'calle central'),
('ana castillo', 'ana.castillo@gmail.com', 37, 4, 88884444, 'leon', 0, 'o-', '19871112', 'colonia primero de mayo'),
('pedro torres', 'pedro.torres@gmail.com', 55, 5, 88885555, 'esteli', 1, 'a-', '19690125', 'barrio el rosario'),
('lucia flores', 'lucia.flores@gmail.com', 28, 6, 88886666, 'chinandega', 0, 'b-', '19960418', 'zona central'),
('manuel cruz', 'manuel.cruz@gmail.com', 33, 7, 88887777, 'rivas', 1, 'o+', '19910722', 'barrio la puebla'),
('sofia reyes', 'sofia.reyes@gmail.com', 21, 8, 88888888, 'carazo', 0, 'a+', '20030909', 'villa esperanza'),
('daniel mora', 'daniel.mora@gmail.com', 46, 9, 88889999, 'boaco', 1, 'o-', '19780303', 'sector norte'),
('elena campos', 'elena.campos@gmail.com', 52, 10, 88990000, 'matagalpa', 0, 'b+', '19721228', 'barrio guanuca'),
('fernando salinas', 'fernando.salinas@gmail.com', 29, 1, 88991111, 'managua', 1, 'a-', '19950614', 'villa libertad'),
('gabriela rios', 'gabriela.rios@gmail.com', 31, 2, 88992222, 'masaya', 0, 'o+', '19931001', 'monimbo'),
('ricardo perez', 'ricardo.perez@gmail.com', 40, 3, 88993333, 'granada', 1, 'a+', '19840521', 'calle el comercio'),
('veronica diaz', 'veronica.diaz@gmail.com', 26, 4, 88994444, 'leon', 0, 'b-', '19980808', 'subtiava'),
('julio morales', 'julio.morales@gmail.com', 60, 5, 88995555, 'esteli', 1, 'o-', '19640430', 'barrio panama soberana'),
('camila ortega', 'camila.ortega@gmail.com', 24, 6, 88996666, 'chinandega', 0, 'a+', '20000117', 'reparto los angeles'),
('oscar palma', 'oscar.palma@gmail.com', 47, 7, 88997777, 'rivas', 1, 'b+', '19770913', 'barrio san francisco'),
('isabel navas', 'isabel.navas@gmail.com', 34, 8, 88998888, 'carazo', 0, 'o+', '19900226', 'jinotepe centro'),
('marco gutierrez', 'marco.gutierrez@gmail.com', 53, 9, 88999999, 'boaco', 1, 'a-', '19710719', 'sector sur'),
('patricia luna', 'patricia.luna@gmail.com', 44, 10, 88770000, 'matagalpa', 0, 'b+', '19801111', 'barrio el progreso')
go


--Insertar pacientes con todos los campos
insert into Personal.Pacientes(nombre_paciente, correo_paciente, edad_paciente, habitacion, created_at, uptaded_at, deleted_at, telefono, direccion, genero, tipo_sangre, fecha_nacimiento, direccion_paciente)
values
('raul zamora', 'raul.zamora@gmail.com', 39, 1, getdate(), null, null, 88771111, 'managua', 1, 'o+', '19850606', 'carretera norte'),
('silvia fuentes', 'silvia.fuentes@gmail.com', 27, 2, getdate(), null, null, 88772222, 'masaya', 0, 'a-', '19970315', 'barrio san miguel')
go

--Insertar 15 citas
insert into Monitoreo.Citas(id_paciente, id_medico, created_at, estado, costo_consulta)
values
(1, 1, getdate(), 'programada', 800),
(2, 2, getdate(), 'programada', 850),
(3, 3, getdate(), 'atendida', 900),
(4, 4, getdate(), 'programada', 750),
(5, 5, getdate(), 'atendida', 700),
(6, 6, getdate(), 'programada', 950),
(7, 7, getdate(), 'cancelada', 650),
(8, 8, getdate(), 'programada', 800),
(9, 9, dateadd(day, 1, getdate()), 'programada', 900),
(10, 10, dateadd(day, 2, getdate()), 'programada', 850),
(11, 1, dateadd(day, 3, getdate()), 'programada', 750),
(12, 2, dateadd(day, 4, getdate()), 'programada', 700),
(13, 3, dateadd(day, 5, getdate()), 'programada', 950),
(14, 4, dateadd(day, 6, getdate()), 'programada', 800),
(15, 5, dateadd(day, 7, getdate()), 'programada', 850)
go

--Insertar citas con fecha actual
insert into Monitoreo.Citas(id_paciente, id_medico, created_at, estado, costo_consulta)
values
(16, 6, getdate(), 'programada', 800),
(17, 7, getdate(), 'programada', 850)
go

--Insertar citas futuras
insert into Monitoreo.Citas(id_paciente, id_medico, created_at, estado, costo_consulta)
values
(18, 8, dateadd(day, 10, getdate()), 'programada', 900),
(19, 9, dateadd(day, 15, getdate()), 'programada', 950),
(20, 10, dateadd(day, 20, getdate()), 'programada', 1000)
go

--Insertar 10 tratamientos
insert into Monitoreo.Tratamiento(nombre_tratamiento, id_paciente, costo, medicamento, created_at, updated_at, deleted_at)
values
('control de hipertension', 1, 1500.00, 7, getdate(), null, null),
('tratamiento respiratorio', 2, 1200.00, 8, getdate(), null, null),
('control de diabetes', 3, 1800.00, 6, getdate(), null, null),
('tratamiento de alergia', 4, 900.00, 4, getdate(), null, null),
('tratamiento de gastritis', 5, 1100.00, 5, getdate(), null, null),
('tratamiento muscular', 6, 1000.00, 9, getdate(), getdate(), getdate()),
('tratamiento infeccioso', 7, 2000.00, 3, getdate(), getdate(), getdate()),
('tratamiento respiratorio severo', 8, 2200.00, 10, getdate(), getdate(), getdate()),
('control de colesterol', 9, 1600.00, 18, getdate(), null, null),
('tratamiento inflamatorio', 10, 1300.00, 20, getdate(), getdate(), getdate())
go

--Insertar tratamientos activos
insert into Monitoreo.Tratamiento(nombre_tratamiento, id_paciente, costo, medicamento, created_at, updated_at, deleted_at)
values
('seguimiento cardiaco', 11, 2500.00, 11, getdate(), null, null),
('control respiratorio', 12, 1400.00, 12, getdate(), null, null)
go

--Insertar tratamientos finalizados
insert into Monitoreo.Tratamiento(nombre_tratamiento, id_paciente, costo, medicamento, created_at, updated_at, deleted_at)
values
('recuperacion muscular', 13, 1000.00, 15, getdate(), getdate(), getdate()),
('tratamiento de infeccion', 14, 2100.00, 16, getdate(), getdate(), getdate())
go

--Sentencia update
--Actualizar teléfono de un paciente
update Personal.Pacientes
set telefono = 87654321,
	uptaded_at = getdate()
where id_paciente = 1
go

--Actualizar dirección de un paciente
update Personal.Pacientes
set direccion_paciente = 'barrio altamira, managua',
	direccion = 'managua',
	uptaded_at = getdate()
where id_paciente = 2
go

--Actualizar salario de un médico
update Personal.Medicos
set salario = 38500.00,
	updated_at = getdate()
where id_medico = 1
go

--Actualizar turno de un médico
update Personal.Medicos
set turnos = 'nocturno',
	updated_at = getdate()
where id_medico = 2
go

--Cambiar estado de una cita
update Monitoreo.Citas
set estado = 'atendida',
	updated_at = getdate()
where id_cita = 1
go

--Actualizar costo de consulta
update Monitoreo.Citas
set costo_consulta = 950,
	updated_at = getdate()
where id_cita = 2
go

--Actualizar nombre de especialidad
update Personal.Especialidades
set nombre_especialidad = 'cardiologia pediatrica',
	updated_at = getdate()
where id_especialidad = 1
go

--Actualizar disponibilidad de habitación
update Locacion.Habitaciones
set disponibilidad = 1,
	updated_at = getdate()
where id_habitacion = 1
go

--Actualizar tratamiento activo
update Monitoreo.Tratamiento
set nombre_tratamiento = 'seguimiento activo de hipertension',
	costo = 1800.00,
	updated_at = getdate(),
	deleted_at = null
where id_tratamiento = 1
go

--Actualizar medicamento
update Monitoreo.Medicamento
set nombre_medicamento = 'acetaminofen',
	tratamiento = 'dolor y fiebre',
	updated_at = getdate()
where id_medicamento = 1
go

--Actualizar correo de paciente
update Personal.Pacientes
set correo_paciente = 'carlos.mejia.actualizado@gmail.com',
	uptaded_at = getdate()
where id_paciente = 1
go

--Actualizar correo de médico
update Personal.Medicos
set correo_medico = 'roberto.alvarez.actualizado@hospital.com',
	updated_at = getdate()
where id_medico = 1
go

--Actualizar fecha de cita
update Monitoreo.Citas
set created_at = dateadd(day, 5, getdate()),
	updated_at = getdate()
where id_cita = 3
go

--Actualizar experiencia del médico
update Personal.Medicos
set experiencia = '12 años de experiencia en atencion hospitalaria',
	updated_at = getdate()
where id_medico = 1
go

--Actualizar tipo de sangre
update Personal.Pacientes
set tipo_sangre = 'ab',
	uptaded_at = getdate()
where id_paciente = 1
go

--Modulo delete
--Eliminar un paciente específico
delete from Personal.Pacientes
where id_paciente = 22
go

--Eliminar una cita
delete from Monitoreo.Citas
where id_cita = 7
go

--Eliminar un medicamento
delete from Monitoreo.Medicamento
where id_medicamento = 14
go

--Eliminar una habitación
delete from Locacion.Habitaciones
where id_habitacion = 12
go

--Eliminar un tratamiento
delete from Monitoreo.Tratamiento
where id_tratamiento = 14
go

--Eliminar citas canceladas
delete from Monitoreo.Citas
where estado = 'cancelada'
go

--Eliminar pacientes sin citas
delete from Personal.Pacientes
where id_paciente not in (
	select id_paciente
	from Monitoreo.Citas
)
go

--Eliminar habitaciones vacías
delete from Locacion.Habitaciones
where disponibilidad = 1
and paciente = 'sin asignar'
go

--Eliminar medicamentos vencidos
delete from Monitoreo.Medicamento
where tratamiento = 'vencido'
go

--Eliminar registros de prueba
delete from Personal.Pacientes
where nombre_paciente like '%prueba%'
or correo_paciente like '%prueba%'
go

delete from Personal.Medicos
where nombre_medico like '%prueba%'
or correo_medico like '%prueba%'
go

delete from Monitoreo.Medicamento
where nombre_medicamento like '%prueba%'
or tratamiento like '%prueba%'
go
/*
Consultas:
Mostrar todos los pacientes.
Mostrar todos los médicos.
Mostrar todas las especialidades.
Mostrar todas las citas.
Mostrar pacientes ordenados por apellido.
Mostrar médicos ordenados por salario.
Mostrar citas del día actual.
Mostrar habitaciones disponibles.
Mostrar cantidad de pacientes registrados.
Mostrar cantidad de citas por médico.
*/
---1
select * from Personal.Pacientes
--2
select * from Personal.Medicos
--3
select  * from PErsonal.Especialidades
--4
select * from Monitoreo.Citas
--5
select * from Personal.Pacientes order by nombre_paciente
--6
select * from Personal.Medicos order by salario desc
--7
select 
	c.id_cita,
	p.nombre_paciente,
	m.nombre_medico,
	c.estado,
	c.costo_consulta,
	c.created_at as fecha_cita
from Monitoreo.Citas c
inner join Personal.Pacientes p on c.id_paciente = p.id_paciente
inner join Personal.Medicos m on c.id_medico = m.id_medico
where cast(c.created_at as date) = cast(getdate() as date)
go

--8
select 
	id_habitacion,
	paciente,
	disponibilidad
from Locacion.Habitaciones
where disponibilidad = 1
go

--9
select 
	count(*) as cantidad_pacientes
from Personal.Pacientes
go

--10
select 
	m.id_medico,
	m.nombre_medico,
	count(c.id_cita) as cantidad_citas
from Personal.Medicos m
left join Monitoreo.Citas c on m.id_medico = c.id_medico
group by 
	m.id_medico,
	m.nombre_medico
go
