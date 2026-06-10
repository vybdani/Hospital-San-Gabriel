


USE master;
GO

IF DB_ID('HospitalDB') IS NOT NULL
BEGIN
    ALTER DATABASE HospitalDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE HospitalDB;
END
GO

CREATE DATABASE HospitalDB;
GO

select name as BaseDeDatos
from sys.databases
order by name;
go

use HospitalDB;
go

create table Especialidades (
    id_especialidad int identity (1,1),
    nombre          nvarchar(100),
    descripcion     nvarchar(255)
);
go

create table Pacientes (
    id_paciente      int identity(1,1),
    nombre           nvarchar(100),
    apellido         nvarchar(100),
    correo           nvarchar(150),
    edad             int,
    fecha_registro   date
);
go

create table Medicos (
    id_medico       int identity(1,1),
    nombre          nvarchar(100),
    apellido        nvarchar(100),
    correo          nvarchar(150),
    salario         decimal(10,2),
    id_especialidad int
);
go

create table Citas (
    id_cita     int identity(1,1),
    id_paciente int,
    id_medico   int,
    fecha_cita  datetime
);
go

create table Habitaciones (
    id_habitacion int identity(1,1),
    numero        nvarchar(10),
    piso          int,
    id_paciente   int
);
go

create table Tratamientos (
    id_tratamiento int identity(1,1),
    id_paciente    int,
    descripcion    nvarchar(255),
    fecha_inicio   date,
    fecha_fin      date,
    estado         nvarchar(20)
);
go

create table Medicamentos (
    id_medicamento int identity(1,1),
    nombre         nvarchar(100),
    dosis          nvarchar(50),
    id_tratamiento int,
    fecha_vencimiento date
);
go




alter table Pacientes
    add constraint PK_Pacientes primary key (id_paciente);
go

alter table Medicos
    add constraint PK_Medicos primary key (id_medico);
go

alter table Especialidades
    add constraint PK_Especialidades primary key (id_especialidad);
go
alter table Citas
    add constraint PK_Citas primary key (id_cita);
go
alter table Habitaciones
    add constraint PK_Habitaciones primary key (id_habitacion);
go
alter table Tratamientos
    add constraint PK_Tratamientos primary key (id_tratamiento);
go
alter table Medicamentos
    add constraint PK_Medicamentos primary key (id_medicamento);
go

alter table Pacientes
    alter column nombre nvarchar(100) NOT NULL;
go

alter table Medicos
    alter column nombre nvarchar(100) NOT NULL;
go

alter table Pacientes
    add constraint UQ_Pacientes_Correo unique (correo);
GO

alter table Medicos
    add constraint UQ_Medicos_Correo unique (correo);
go

alter table Pacientes
    add constraint CHK_Pacientes_Edad check (edad >= 0);
go

alter table Medicos
    add constraint CHK_Medicos_Salario check (salario > 0);
go

alter table Pacientes
    add constraint DF_Pacientes_FechaRegistro default getdate() for fecha_registro;
go

alter table Medicos
    add constraint FK_Medicos_Especialidades
    foreign key (id_especialidad) references Especialidades(id_especialidad);
go

alter table Citas
    add constraint FK_Citas_Pacientes
    foreign key (id_paciente) references Pacientes(id_paciente);
go

alter table Citas
    add constraint FK_Citas_Medicos
    foreign key (id_medico) references Medicos(id_medico);
go

alter table Tratamientos
    add constraint FK_Tratamientos_Pacientes
    foreign key (id_paciente) references Pacientes(id_paciente);
go

alter table Medicamentos
    add constraint FK_Medicamentos_Tratamientos
    foreign key (id_tratamiento) references Tratamientos(id_tratamiento);
go

alter table Habitaciones
    add constraint FK_Habitaciones_Pacientes
    foreign key (id_paciente) references Pacientes(id_paciente);
go


alter table Pacientes add telefono nvarchar(15);
go

alter table Pacientes add direccion nvarchar(200);
go

alter table Pacientes add genero nchar(1);
go

alter table Pacientes add tipo_sangre nvarchar(5);
go

alter table Pacientes add fecha_nacimiento date;
go

alter table Pacientes alter column nombre nvarchar(150) NOT NULL;
go

alter table Pacientes alter column direccion nvarchar(300);
go

alter table Medicos add experiencia int;
go

alter table Medicos add turno nvarchar(20);
go

alter table Medicos add observaciones nvarchar(500);
go

alter table Medicos drop column observaciones;
go

alter table Citas add estado nvarchar(20);
go

alter table Citas ADD costo_consulta float;
go

alter table Citas alter column costo_consulta decimal(10,2);
go

alter table Habitaciones add disponibilidad bit default 1;
go



create table TablaTemp (id int, descripcion nvarchar(50));
go
drop table TablaTemp;
go

alter table Pacientes add constraint CHK_Test_Edad check (edad < 200);
go
alter table Pacientes drop constraint CHK_Test_Edad;
go

create table PruebaTmp (correo_tmp nvarchar(100));
go
alter table PruebaTmp add constraint UQ_Test_Correo unique (correo_tmp);
go
alter table PruebaTmp drop constraint UQ_Test_Correo;
go

alter table PruebaTmp add columna_extra nvarchar(50);
go
alter table PruebaTmp drop column columna_extra;
go

drop table PruebaTmp;
go

create table Auditoria (
    id_auditoria int identity (1,1) primary key,
    tabla        nvarchar(50),
    accion       nvarchar(20),
    fecha        datetime default getdate()
);
go
drop table Auditoria;
go

create table Logs (
    id_log   int identity(1,1) primary key,
    mensaje  nvarchar(500),
    fecha    datetime default getdate()
);
go
drop table Logs;
go

alter table Habitaciones drop constraint FK_Habitaciones_Pacientes;
go
alter table Habitaciones
    add constraint FK_Habitaciones_Pacientes
    foreign key (id_paciente) references Pacientes(id_paciente);
go

create table MedicamentosPrueba (
    id   int identity(1,1) primary key,
    nombre nvarchar(100)
);
go
drop table MedicamentosPrueba;
go

create database HospitalDB_Test;
go
drop database HospitalDB_Test;
go

use HospitalDB;
go



insert into Especialidades (nombre, descripcion) values
    ('Cardiología',    'Especialidad del corazón y sistema cardiovascular'),
    ('Neurología',     'Especialidad del sistema nervioso'),
    ('Pediatría',      'Atención médica para niños y adolescentes'),
    ('Ortopedia',      'Especialidad del sistema músculo-esquelético'),
    ('Dermatología',   'Especialidad de la piel, cabello y uñas');
go

insert into Medicos (nombre, apellido, correo, salario, id_especialidad, experiencia, turno) values
    ('Carlos',    'Méndez',    'carlos.mendez@hospital.com',    5500.00, 1, 10, 'Matutino'),
    ('Sofía',     'Ramírez',   'sofia.ramirez@hospital.com',    6000.00, 2, 8,  'Vespertino'),
    ('Luis',      'Torres',    'luis.torres@hospital.com',      4800.00, 3, 5,  'Nocturno'),
    ('Ana',       'Gómez',     'ana.gomez@hospital.com',        5200.00, 4, 7,  'Matutino'),
    ('Roberto',   'Herrera',   'roberto.herrera@hospital.com',  7000.00, 5, 15, 'Vespertino'),
    ('Patricia',  'López',     'patricia.lopez@hospital.com',   5800.00, 1, 12, 'Matutino'),
    ('Miguel',    'Castillo',  'miguel.castillo@hospital.com',  4500.00, 2, 3,  'Nocturno'),
    ('Laura',     'Flores',    'laura.flores@hospital.com',     6200.00, 3, 9,  'Matutino'),
    ('Jorge',     'Martínez',  'jorge.martinez@hospital.com',   5100.00, 4, 6,  'Vespertino'),
    ('Valeria',   'Gutiérrez', 'valeria.gutierrez@hospital.com',6500.00, 5, 11, 'Matutino');
go

insert into Pacientes (nombre, apellido, correo, edad, genero, tipo_sangre, telefono, direccion, fecha_nacimiento) values
    ('Juan',      'Pérez',      'juan.perez@gmail.com',       35, 'M', 'O+',  '8888-0001', 'Managua, Barrio El Carmen',        '1989-03-15'),
    ('María',     'González',   'maria.gonzalez@gmail.com',   28, 'F', 'A+',  '8888-0002', 'Managua, Residencial Las Palmas',  '1996-07-22'),
    ('Pedro',     'López',      'pedro.lopez@gmail.com',      42, 'M', 'B+',  '8888-0003', 'Masaya, Calle Central',            '1982-11-08'),
    ('Lucía',     'Hernández',  'lucia.hernandez@gmail.com',  31, 'F', 'AB+', '8888-0004', 'Granada, Barrio Xalteva',          '1993-05-30'),
    ('Carlos',    'Martínez',   'carlos.m2@gmail.com',        50, 'M', 'O-',  '8888-0005', 'León, Barrio El Laborío',          '1974-01-19'),
    ('Rosa',      'Díaz',       'rosa.diaz@gmail.com',        23, 'F', 'A-',  '8888-0006', 'Managua, Barrio Largaespada',      '2001-09-12'),
    ('Andrés',    'Vargas',     'andres.vargas@gmail.com',    37, 'M', 'B-',  '8888-0007', 'Managua, Colonia Centro América',  '1987-04-25'),
    ('Elena',     'Castillo',   'elena.castillo@gmail.com',   45, 'F', 'O+',  '8888-0008', 'Chinandega, Centro',               '1979-08-03'),
    ('Fernando',  'Morales',    'fernando.morales@gmail.com', 29, 'M', 'A+',  '8888-0009', 'Managua, Barrio Monseñor Lezcano', '1995-12-07'),
    ('Daniela',   'Ruiz',       'daniela.ruiz@gmail.com',     33, 'F', 'AB-', '8888-0010', 'Matagalpa, Barrio Sandino',        '1991-06-18'),
    ('Sergio',    'Jiménez',    'sergio.jimenez@gmail.com',   55, 'M', 'O+',  '8888-0011', 'Managua, Los Robles',              '1969-02-14'),
    ('Isabela',   'Flores',     'isabela.flores@gmail.com',   27, 'F', 'A+',  '8888-0012', 'Managua, Villa Fontana',           '1997-10-01'),
    ('Ricardo',   'Mejía',      'ricardo.mejia@gmail.com',    40, 'M', 'B+',  '8888-0013', 'Estelí, Barrio El Calvario',       '1984-07-09'),
    ('Carmen',    'Reyes',      'carmen.reyes@gmail.com',     38, 'F', 'O-',  '8888-0014', 'Managua, Bolonia',                 '1986-03-27'),
    ('Héctor',    'Sandoval',   'hector.sandoval@gmail.com',  62, 'M', 'A+',  '8888-0015', 'Jinotepe, Barrio Central',         '1962-11-20'),
    ('Natalia',   'Cruz',       'natalia.cruz@gmail.com',     22, 'F', 'B+',  '8888-0016', 'Managua, Batahola Norte',          '2002-04-05'),
    ('Eduardo',   'Medina',     'eduardo.medina@gmail.com',   47, 'M', 'AB+', '8888-0017', 'Managua, Altamira',                '1977-08-30'),
    ('Patricia',  'Rojas',      'patricia.rojas@gmail.com',   34, 'F', 'O+',  '8888-0018', 'Managua, Barrio Martha Quezada',   '1990-01-15'),
    ('Manuel',    'Vega',       'manuel.vega@gmail.com',      58, 'M', 'A-',  '8888-0019', 'Rivas, Centro',                    '1966-05-22'),
    ('Gabriela',  'Soto',       'gabriela.soto@gmail.com',    26, 'F', 'O+',  '8888-0020', 'Managua, Residencial Bolonia',     '1998-09-11');
go

insert into Citas (id_paciente, id_medico, fecha_cita, estado, costo_consulta) values
    (1,  1, '2025-01-10 08:00:00', 'Completada',  500.00),
    (2,  2, '2025-01-11 09:30:00', 'Completada',  600.00),
    (3,  3, '2025-01-12 10:00:00', 'Completada',  450.00),
    (4,  4, '2025-01-13 11:00:00', 'Cancelada',   520.00),
    (5,  5, '2025-01-14 14:00:00', 'Completada',  700.00),
    (6,  6, '2025-01-15 08:30:00', 'Completada',  550.00),
    (7,  7, '2025-01-16 15:00:00', 'Pendiente',   480.00),
    (8,  8, '2025-01-17 09:00:00', 'Completada',  620.00),
    (9,  9, '2025-01-18 10:30:00', 'Cancelada',   510.00),
    (10, 10,'2025-01-19 11:30:00', 'Completada',  650.00),
    (11,  1, getdate(),            'Pendiente',   500.00),
    (12,  3, getdate(),            'Pendiente',   450.00),
    (13,  5, dateadd(DAY,2,getdate()), 'Pendiente', 700.00),
    (14,  7, dateadd(DAY,3,getdate()), 'Pendiente', 480.00),
    (15,  9, dateadd(DAY,5,getdate()), 'Pendiente', 510.00);
go

insert into Habitaciones (numero, piso, id_paciente, disponibilidad) values
    ('101', 1, 1,  0),
    ('102', 1, 2,  0),
    ('103', 1, NULL, 1),
    ('104', 1, NULL, 1),
    ('201', 2, 3,  0),
    ('202', 2, 4,  0),
    ('203', 2, NULL, 1),
    ('301', 3, 5,  0),
    ('302', 3, NULL, 1),
    ('303', 3, NULL, 1);
go

insert into Tratamientos (id_paciente, descripcion, fecha_inicio, fecha_fin, estado) values
    (1,  'Tratamiento cardíaco con betabloqueadores',      '2025-01-10', '2025-04-10', 'Activo'),
    (2,  'Terapia neurológica para migraña crónica',       '2025-01-11', '2025-03-11', 'Activo'),
    (3,  'Rehabilitación pediátrica post-fractura',        '2025-01-12', '2025-02-12', 'Finalizado'),
    (4,  'Fisioterapia ortopédica de rodilla',             '2025-01-13', '2025-06-13', 'Activo'),
    (5,  'Tratamiento dermatológico para psoriasis',       '2025-01-14', '2025-07-14', 'Activo'),
    (6,  'Rehabilitación cardíaca post-infarto',           '2025-01-15', '2025-05-15', 'Activo'),
    (7,  'Terapia de electroestimulación neurológica',     '2025-01-16', '2025-03-16', 'Finalizado'),
    (8,  'Control pediátrico de diabetes tipo 1',          '2025-01-17', '2025-12-17', 'Activo'),
    (9,  'Tratamiento ortopédico de columna vertebral',    '2025-01-18', '2025-08-18', 'Activo'),
    (10, 'Tratamiento dermatológico para acné severo',     '2025-01-19', '2025-04-19', 'Finalizado');
go

insert into Medicamentos (nombre, dosis, id_tratamiento, fecha_vencimiento) values
    ('Metoprolol',      '50mg c/12h',  1, '2026-06-01'),
    ('Atenolol',        '25mg c/24h',  1, '2026-08-15'),
    ('Topiramato',      '100mg c/12h', 2, '2026-05-20'),
    ('Amitriptilina',   '25mg c/24h',  2, '2025-12-31'),
    ('Ibuprofeno',      '400mg c/8h',  3, '2025-11-10'),
    ('Calcio 600',      '600mg c/24h', 3, '2026-03-01'),
    ('Naproxeno',       '500mg c/12h', 4, '2026-07-15'),
    ('Diclofenaco',     '75mg c/12h',  4, '2026-04-20'),
    ('Metotrexato',     '15mg semanal',5, '2026-09-01'),
    ('Ciclosporina',    '100mg c/12h', 5, '2026-02-28'),
    ('Carvedilol',      '6.25mg c/12h',6, '2026-10-01'),
    ('Ramipril',        '5mg c/24h',   6, '2026-11-15'),
    ('Gabapentina',     '300mg c/8h',  7, '2025-10-01'),
    ('Pregabalina',     '75mg c/12h',  7, '2025-09-30'),
    ('Insulina Glargina','10UI c/24h', 8, '2026-01-15'),
    ('Metformina',      '850mg c/8h',  8, '2026-05-30'),
    ('Tramadol',        '50mg c/8h',   9, '2026-06-20'),
    ('Paracetamol',     '500mg c/6h',  9, '2026-12-01'),
    ('Isotretinoína',   '20mg c/24h', 10, '2025-08-31'),
    ('Doxiciclina',     '100mg c/12h',10, '2026-02-14');
go



update Pacientes set telefono = '8999-1234' where id_paciente = 1;
go

update Pacientes set direccion = 'Managua, Barrio Las Brisas' where id_paciente = 2;
go

update Medicos set salario = 6000.00 where id_medico = 1;
go

update Medicos set turno = 'Vespertino' where id_medico = 3;
go

update Citas set estado = 'Cancelada' where id_cita = 7;
go

update Citas set costo_consulta = 750.00 where id_cita = 5;
go

update Especialidades set nombre = 'Cardiología Clínica' where id_especialidad = 1;
go

update Habitaciones set disponibilidad = 1, id_paciente = NULL where id_habitacion = 1;
go

update Tratamientos set fecha_fin = '2025-09-10' where id_tratamiento = 1;
go

update Medicamentos set dosis = '100mg c/12h' where id_medicamento = 1;
go

update Pacientes set correo = 'juan.perez.nuevo@gmail.com' where id_paciente = 1;
go

update Medicos set correo = 'carlos.mendez.nuevo@hospital.com' where id_medico = 1;
go

update Citas set fecha_cita = dateadd(DAY, 7, fecha_cita) where id_cita = 11;
go

update Medicos set experiencia = 11 where id_medico = 1;
go

update Pacientes set tipo_sangre = 'O+' where id_paciente = 3;
go



insert into Pacientes (nombre, apellido, correo, edad) values ('Prueba', 'Borrar', 'prueba.borrar@test.com', 25);
go

delete from Pacientes where correo = 'prueba.borrar@test.com';
go

delete from Citas where id_cita = 4;
go

delete from Medicamentos where id_medicamento = 19;  -- Isotretinoína (vence 2025-08-31)
go

delete from Habitaciones where id_habitacion = 10;
go

delete from Tratamientos where id_tratamiento = 10;
go

delete from Citas where estado = 'Cancelada';
go

delete from Pacientes
WHERE id_paciente NOT IN (SELECT DISTINCT id_paciente FROM Citas WHERE id_paciente IS NOT NULL);
go

delete from Habitaciones WHERE id_paciente IS NULL AND disponibilidad = 1;
go

delete from Medicamentos WHERE fecha_vencimiento < GETDATE();
go

INSERT INTO Medicamentos (nombre, dosis, id_tratamiento, fecha_vencimiento)
    VALUES ('MedicamentoPrueba', '1mg', 1, '2020-01-01');
go
delete from Medicamentos WHERE nombre = 'MedicamentoPrueba';
go




SELECT * FROM Pacientes;
go

SELECT * FROM Medicos;
go

SELECT * FROM Especialidades;
go

SELECT * FROM Citas;
go

SELECT id_paciente, nombre, apellido, edad, telefono
FROM Pacientes
ORDER BY apellido ASC;
go

SELECT id_medico, nombre, apellido, salario, turno
FROM Medicos
ORDER BY salario DESC;
go

SELECT c.id_cita, p.nombre + ' ' + p.apellido AS paciente,
       m.nombre + ' ' + m.apellido AS medico,
       c.fecha_cita, c.estado, c.costo_consulta
FROM Citas c
JOIN Pacientes p ON c.id_paciente = p.id_paciente
JOIN Medicos   m ON c.id_medico   = m.id_medico
WHERE CAST(c.fecha_cita AS DATE) = CAST(GETDATE() AS DATE);
go

SELECT id_habitacion, numero, piso
FROM Habitaciones
WHERE disponibilidad = 1;
go

SELECT COUNT(*) AS total_pacientes FROM Pacientes;
go

SELECT m.id_medico,
       m.nombre + ' ' + m.apellido AS medico,
       COUNT(c.id_cita) AS total_citas
FROM Medicos m
LEFT JOIN Citas c ON m.id_medico = c.id_medico
GROUP BY m.id_medico, m.nombre, m.apellido
ORDER BY total_citas DESC;
go