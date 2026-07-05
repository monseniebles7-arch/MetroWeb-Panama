-- 1. Crear y usar la Base de Datos
CREATE DATABASE MetroWebPanama2;
USE MetroWebPanama;

-- 2. TABLAS CATÁLOGO
CREATE TABLE Rol (id_rol INT AUTO_INCREMENT PRIMARY KEY, nombre_rol VARCHAR(30) NOT NULL);
CREATE TABLE EstadoTarjeta (id_estado INT AUTO_INCREMENT PRIMARY KEY, descripcion VARCHAR(30) NOT NULL);
CREATE TABLE TipoTarjeta (id_tipo_tarjeta INT AUTO_INCREMENT PRIMARY KEY, descripcion VARCHAR(30) NOT NULL);
CREATE TABLE MetodoPago (id_metodo INT AUTO_INCREMENT PRIMARY KEY, descripcion VARCHAR(30) NOT NULL);
CREATE TABLE TipoTransporte (id_tipo_transporte INT AUTO_INCREMENT PRIMARY KEY, descripcion VARCHAR(30) NOT NULL);
CREATE TABLE Estacion (id_estacion INT AUTO_INCREMENT PRIMARY KEY, nombre_estacion VARCHAR(80) NOT NULL UNIQUE);
CREATE TABLE RutaBus (id_ruta INT AUTO_INCREMENT PRIMARY KEY, codigo_ruta VARCHAR(10) NOT NULL UNIQUE, troncal VARCHAR(5) NOT NULL);

-- 3. TABLAS PRINCIPALES
CREATE TABLE Usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL, 
    apellido VARCHAR(50) NOT NULL,
    correo VARCHAR(100) NOT NULL UNIQUE, 
    hash_contrasena VARCHAR(255) NOT NULL,
    id_rol INT NOT NULL, FOREIGN KEY (id_rol) REFERENCES Rol(id_rol)
);

CREATE TABLE Tarjeta (
    id_tarjeta INT AUTO_INCREMENT PRIMARY KEY, 
    numero_tarjeta VARCHAR(25) NOT NULL UNIQUE,
    alias_tarjeta VARCHAR(50), 
    saldo DECIMAL(10,2) DEFAULT 0.00,
    id_estado INT NOT NULL, 
    id_tipo_tarjeta INT NOT NULL, 
    id_usuario INT NOT NULL,
    FOREIGN KEY (id_estado) REFERENCES EstadoTarjeta(id_estado),
    FOREIGN KEY (id_tipo_tarjeta) REFERENCES TipoTarjeta(id_tipo_tarjeta),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario) ON DELETE CASCADE
);

-- 4. MOVIMIENTOS E HISTORIAL
CREATE TABLE Recarga (
    id_recarga INT AUTO_INCREMENT PRIMARY KEY, monto DECIMAL(10,2) NOT NULL, fecha_hora DATETIME NOT NULL,
    id_metodo INT NOT NULL, id_usuario INT NOT NULL, id_tarjeta INT NOT NULL,
    FOREIGN KEY (id_metodo) REFERENCES MetodoPago(id_metodo),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (id_tarjeta) REFERENCES Tarjeta(id_tarjeta)
);

CREATE TABLE Viaje (
    id_viaje INT AUTO_INCREMENT PRIMARY KEY, fecha_hora DATETIME NOT NULL, costo DECIMAL(10,2) NOT NULL,
    id_usuario INT NOT NULL, id_tipo_transporte INT NOT NULL, id_estacion_origen INT NULL,
    id_estacion_destino INT NULL, id_ruta INT NULL,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (id_tipo_transporte) REFERENCES TipoTransporte(id_tipo_transporte),
    FOREIGN KEY (id_estacion_origen) REFERENCES Estacion(id_estacion),
    FOREIGN KEY (id_estacion_destino) REFERENCES Estacion(id_estacion),
    FOREIGN KEY (id_ruta) REFERENCES RutaBus(id_ruta)
);

CREATE TABLE HistorialSaldo (
    id_historial INT AUTO_INCREMENT PRIMARY KEY, fecha_hora DATETIME NOT NULL,
    monto_usado DECIMAL(10,2) NOT NULL, saldo_restante DECIMAL(10,2) NOT NULL,
    id_tarjeta INT NOT NULL, FOREIGN KEY (id_tarjeta) REFERENCES Tarjeta(id_tarjeta) ON DELETE CASCADE
);

-- agregamos la columna para enlazar los viajes con una tarjeta especifica
ALTER TABLE Viaje ADD COLUMN id_tarjeta INT NOT NULL;

-- 5. INSERCIONES DE DATOS (Sin 'Efectivo')
INSERT INTO Rol (nombre_rol) VALUES ('Administrador'), ('Usuario');
INSERT INTO EstadoTarjeta (descripcion) VALUES ('Activa'), ('Bloqueada'), ('Vencida');
INSERT INTO TipoTarjeta (descripcion) VALUES ('General'), ('Estudiante'), ('Jubilado');
INSERT INTO MetodoPago (descripcion) VALUES ('Tarjeta de Crédito'), ('Yappy'); 
INSERT INTO TipoTransporte (descripcion) VALUES ('Metro'), ('Metrobús');

INSERT INTO Estacion (nombre_estacion) VALUES ('Albrook'), ('5 de Mayo'), ('Lotería'), ('Santo Tomás'), ('Iglesia del Carmen'), ('Vía Argentina'), ('Fernández de Córdoba'), ('Pueblo Nuevo'), ('12 de Octubre'), ('El Ingenio'), ('San Miguelito'), ('Pan de Azúcar'), ('Los Andes'), ('San Isidro'), ('Villa Zaíta'), ('San Miguelito L2'), ('Paraíso'), ('Cincuentenario'), ('Villa Lucre'), ('El Crisol'), ('Brisas del Golf'), ('Cerro Viento'), ('San Antonio'), ('Pedregal'), ('Don Bosco'), ('Corredor Sur'), ('Las Mañanitas'), ('Hospital del Este'), ('Altos de Tocumen'), ('24 de Diciembre'), ('Nuevo Tocumen');

INSERT INTO RutaBus (codigo_ruta, troncal) VALUES ('S420', 'S'), ('S421', 'S'), ('S422', 'S'), ('S432', 'S'), ('S440', 'S'), ('S441', 'S'), ('S442', 'S'), ('S447', 'S'), ('S480', 'S'), ('S481', 'S'), ('S482', 'S'), ('S487', 'S'), ('S510', 'S'), ('S511', 'S'), ('S512', 'S'), ('S520', 'S'), ('S530', 'S'), ('S542', 'S'), ('S549', 'S'), ('S562', 'S'), ('S569', 'S'), ('S572', 'S'), ('S662', 'S'), ('S669', 'S'), ('T020', 'T'), ('T021', 'T'), ('T022', 'T'), ('T029', 'T'), ('T033', 'T'), ('T040', 'T'), ('T060', 'T'), ('T080', 'T'), ('T098', 'T'), ('T100', 'T'), ('T120', 'T'), ('T140', 'T'), ('T143', 'T'), ('T149', 'T'), ('T160', 'T'), ('T176', 'T'), ('T443', 'T'), ('T582', 'T'), ('A096', 'A'), ('F030', 'F'), ('I182', 'I'), ('I532', 'I'), ('I672', 'I'), ('K042', 'K'), ('K100', 'K'), ('K120', 'K'), ('K140', 'K'), ('K160', 'K'), ('K181', 'K'), ('K189', 'K'), ('K530', 'K'), ('M062', 'M'), ('M100', 'M'), ('M120', 'M'), ('M140', 'M'), ('M181', 'M'), ('M182', 'M'), ('M201', 'M'), ('M481', 'M'), ('M502', 'M'), ('M530', 'M'), ('M671', 'M'), ('M675', 'M'), ('V180', 'V'), ('V201', 'V'), ('V442', 'V'), ('V502', 'V'), ('V531', 'V'), ('V532', 'V'), ('V539', 'V'), ('V560', 'V'), ('C640', 'C'), ('C641', 'C'), ('C642', 'C'), ('C678', 'C'), ('C790', 'C'), ('C800', 'C'), ('C810', 'C'), ('C820', 'C'), ('C830', 'C'), ('C842', 'C'), ('C850', 'C'), ('C862', 'C'), ('C888', 'C'), ('C898', 'C'), ('C903', 'C'), ('C908', 'C'), ('C918', 'C'), ('C928', 'C'), ('C938', 'C'), ('C941', 'C'), ('C944', 'C'), ('C952', 'C'), ('C968', 'C'), ('C970', 'C'), ('C974', 'C'), ('C982', 'C'), ('E418', 'E'), ('E436', 'E'), ('E444', 'E'), ('E445', 'E'), ('E458', 'E'), ('E468', 'E'), ('E478', 'E'), ('E484', 'E'), ('E485', 'E'), ('E486', 'E'), ('E488', 'E'), ('E489', 'E'), ('E496', 'E'), ('E504', 'E'), ('E505', 'E'), ('E506', 'E'), ('E516', 'E'), ('E526', 'E'), ('E537', 'E'), ('E556', 'E'), ('E566', 'E'), ('E568', 'E'), ('E598', 'E'), ('E606', 'E'), ('E618', 'E'), ('E619', 'E'), ('E628', 'E'), ('E638', 'E'), ('E658', 'E'), ('E665', 'E'), ('N025', 'N'), ('N035', 'N'), ('N037', 'N'), ('N045', 'N'), ('N047', 'N'), ('N048', 'N'), ('N065', 'N'), ('N067', 'N'), ('N105', 'N'), ('N106', 'N'), ('N109', 'N'), ('N125', 'N'), ('N126', 'N'), ('N129', 'N'), ('N145', 'N'), ('N147', 'N'), ('N149', 'N'), ('N154', 'N'), ('N156', 'N'), ('N165', 'N'), ('N185', 'N'), ('N204', 'N'), ('N205', 'N'), ('N208', 'N'), ('N209', 'N');

INSERT INTO Usuario (nombre, apellido, correo, hash_contrasena, id_rol) 
VALUES ('Admin', 'MetroWeb', 'admin@metroweb.com', '$2a$12$ESiFjOBy8yl5DOzQW2KLiOH2a0wETDWvqRd6g942SB/ce5Z5rC8y.', 1);

-- 1. Insertar el Usuario de prueba (contraseña: 123)
INSERT INTO Usuario (nombre, apellido, correo, hash_contrasena, id_rol) 
VALUES ('Juan', 'Pérez', 'usuario1@metroweb.com', '$2a$12$6t3rQYdYenqL.UvPAGP6eex7fD41fA1A.4xT8zG2A.6A6A6A6A6A6', 2);

-- 2. Asignarle una Tarjeta a Juan Pérez (con saldo inicial de $5.50)
INSERT INTO Tarjeta (numero_tarjeta, alias_tarjeta, saldo, id_estado, id_tipo_tarjeta, id_usuario)
VALUES ('91040997', 'Mi Tarjeta Principal', 5.50, 1, 1, LAST_INSERT_ID());

-- 3. Insertar Movimientos de prueba en el Historial vinculados a esa tarjeta
-- (Simulando los datos exactos que querías ver en pantalla)
INSERT INTO HistorialSaldo (fecha_hora, monto_usado, saldo_restante, id_tarjeta) VALUES
('2026-07-01 07:25:00', 0.00, 4.25, 1),
('2026-07-01 09:46:00', 0.25, 4.00, 1),
('2026-07-02 12:06:00', 0.25, 3.75, 1),
('2026-07-02 16:36:00', 0.25, 3.50, 1);