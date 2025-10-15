-- Script de inicialización de la base de datos del Instituto
-- Se ejecuta automáticamente al crear el contenedor si es la primera vez
SET NAMES utf8mb4; -- Fuerza la codificación de la conexión

CREATE DATABASE IF NOT EXISTS instituto_db; -- Crea la database si no existe
USE instituto_db; -- Se selecciona la base de datos

-- Tabla de Familias Profesionales
CREATE TABLE IF NOT EXISTS familias_profesionales (
    id_familia INT AUTO_INCREMENT PRIMARY KEY,
    nombre_familia VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_nombre_familia (nombre_familia)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla de Cursos
CREATE TABLE IF NOT EXISTS cursos (
    id_curso INT AUTO_INCREMENT PRIMARY KEY,
    nombre_curso VARCHAR(100) NOT NULL,
    id_familia INT NOT NULL,
    nivel ENUM('1', '2', '3', '4') NOT NULL,
    capacidad_maxima INT DEFAULT 50,
    alumnos_matriculados INT DEFAULT 0,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_familia) REFERENCES familias_profesionales(id_familia) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_nombre_curso (nombre_curso),
    INDEX idx_familia (id_familia),
    CONSTRAINT chk_capacidad CHECK (alumnos_matriculados <= capacidad_maxima)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla de Alumnos
CREATE TABLE IF NOT EXISTS alumnos (
    dni VARCHAR(9) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    telefono VARCHAR(15),
    email VARCHAR(100),
    id_curso INT NOT NULL,
    fecha_matricula TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_curso) REFERENCES cursos(id_curso) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_apellidos_nombre (apellidos, nombre),
    INDEX idx_curso (id_curso),
    CONSTRAINT chk_dni CHECK (dni REGEXP '^[0-9]{8}[A-Z]$'),
    CONSTRAINT chk_telefono CHECK (telefono REGEXP '^[0-9]{9}$' OR telefono IS NULL)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insertar las 9 Familias Profesionales
INSERT INTO familias_profesionales (nombre_familia, descripcion) VALUES
('Informática y Comunicaciones', 'Desarrollo de software, sistemas y redes'),
('Sanidad', 'Atención sanitaria y cuidados auxiliares'),
('Administración y Gestión', 'Gestión administrativa y financiera'),
('Comercio y Marketing', 'Técnicas de venta y marketing digital'),
('Electricidad y Electrónica', 'Instalaciones eléctricas y sistemas electrónicos'),
('Hostelería y Turismo', 'Servicios de restauración y alojamiento'),
('Imagen Personal', 'Estética y peluquería profesional'),
('Transporte y Mantenimiento de Vehículos', 'Mecánica y electromecánica de vehículos'),
('Fabricación Mecánica', 'Mecanizado y soldadura');

-- Insertar 4 cursos por cada familia profesional (36 cursos en total)
-- Informática y Comunicaciones (id_familia = 1)
INSERT INTO cursos (nombre_curso, id_familia, nivel, capacidad_maxima) VALUES
('1º Desarrollo de Aplicaciones Multiplataforma (DAM)', 1, '1', 30),
('2º Desarrollo de Aplicaciones Multiplataforma (DAM)', 1, '2', 30),
('1º Desarrollo de Aplicaciones Web (DAW)', 1, '1', 30),
('2º Desarrollo de Aplicaciones Web (DAW)', 1, '2', 30);

-- Sanidad (id_familia = 2)
INSERT INTO cursos (nombre_curso, id_familia, nivel, capacidad_maxima) VALUES
('1º Técnico en Cuidados Auxiliares de Enfermería', 2, '1', 25),
('2º Técnico en Cuidados Auxiliares de Enfermería', 2, '2', 25),
('1º Técnico en Emergencias Sanitarias', 2, '1', 25),
('2º Técnico en Emergencias Sanitarias', 2, '2', 25);

-- Administración y Gestión (id_familia = 3)
INSERT INTO cursos (nombre_curso, id_familia, nivel, capacidad_maxima) VALUES
('1º Gestión Administrativa', 3, '1', 30),
('2º Gestión Administrativa', 3, '2', 30),
('1º Asistencia a la Dirección', 3, '1', 25),
('2º Asistencia a la Dirección', 3, '2', 25);

-- Comercio y Marketing (id_familia = 4)
INSERT INTO cursos (nombre_curso, id_familia, nivel, capacidad_maxima) VALUES
('1º Actividades Comerciales', 4, '1', 30),
('2º Actividades Comerciales', 4, '2', 30),
('1º Marketing y Publicidad', 4, '1', 25),
('2º Marketing y Publicidad', 4, '2', 25);

-- Electricidad y Electrónica (id_familia = 5)
INSERT INTO cursos (nombre_curso, id_familia, nivel, capacidad_maxima) VALUES
('1º Instalaciones Eléctricas y Automáticas', 5, '1', 25),
('2º Instalaciones Eléctricas y Automáticas', 5, '2', 25),
('1º Sistemas Electrotécnicos y Automatizados', 5, '1', 25),
('2º Sistemas Electrotécnicos y Automatizados', 5, '2', 25);

-- Hostelería y Turismo (id_familia = 6)
INSERT INTO cursos (nombre_curso, id_familia, nivel, capacidad_maxima) VALUES
('1º Cocina y Gastronomía', 6, '1', 20),
('2º Cocina y Gastronomía', 6, '2', 20),
('1º Servicios en Restauración', 6, '1', 20),
('2º Servicios en Restauración', 6, '2', 20);

-- Imagen Personal (id_familia = 7)
INSERT INTO cursos (nombre_curso, id_familia, nivel, capacidad_maxima) VALUES
('1º Peluquería y Cosmética Capilar', 7, '1', 20),
('2º Peluquería y Cosmética Capilar', 7, '2', 20),
('1º Estética y Belleza', 7, '1', 20),
('2º Estética y Belleza', 7, '2', 20);

-- Transporte y Mantenimiento de Vehículos (id_familia = 8)
INSERT INTO cursos (nombre_curso, id_familia, nivel, capacidad_maxima) VALUES
('1º Electromecánica de Vehículos Automóviles', 8, '1', 25),
('2º Electromecánica de Vehículos Automóviles', 8, '2', 25),
('1º Carrocería', 8, '1', 20),
('2º Carrocería', 8, '2', 20);

-- Fabricación Mecánica (id_familia = 9)
INSERT INTO cursos (nombre_curso, id_familia, nivel, capacidad_maxima) VALUES
('1º Mecanizado', 9, '1', 20),
('2º Mecanizado', 9, '2', 20),
('1º Soldadura y Calderería', 9, '1', 20),
('2º Soldadura y Calderería', 9, '2', 20);

-- Insertar algunos alumnos de ejemplo
INSERT INTO alumnos (dni, nombre, apellidos, telefono, email, id_curso) VALUES
('12345678A', 'Juan', 'García López', '666111222', 'juan.garcia@instituto.es', 1),
('23456789B', 'María', 'Martínez Sánchez', '666222333', 'maria.martinez@instituto.es', 1),
('34567890C', 'Pedro', 'Rodríguez Fernández', '666333444', 'pedro.rodriguez@instituto.es', 2),
('45678901D', 'Ana', 'López García', '666444555', 'ana.lopez@instituto.es', 3),
('56789012E', 'Carlos', 'Fernández Martín', '666555666', 'carlos.fernandez@instituto.es', 5),
('67890123F', 'Laura', 'Sánchez Pérez', '666666777', 'laura.sanchez@instituto.es', 9),
('78901234G', 'David', 'Pérez González', '666777888', 'david.perez@instituto.es', 13),
('89012345H', 'Sara', 'González Ruiz', '666888999', 'sara.gonzalez@instituto.es', 17);

INSERT INTO alumnos (dni, nombre, apellidos, telefono, email, id_curso) VALUES
('11111111A', 'Alejandro', 'Ruiz Martín', '666111111', 'alejandro.ruiz@instituto.es', 1),
('22222222B', 'Lucía', 'Herrera Gómez', '666222222', 'lucia.herrera@instituto.es', 1),
('33333333C', 'Daniel', 'Jiménez López', '666333333', 'daniel.jimenez@instituto.es', 1),
('44444444D', 'Paula', 'Díaz Sánchez', '666444444', 'paula.diaz@instituto.es', 1),
('55555555E', 'Adrián', 'Moreno Fernández', '666555555', 'adrian.moreno@instituto.es', 2),
('66666666F', 'Carmen', 'Álvarez Pérez', '666666666', 'carmen.alvarez@instituto.es', 2),
('77777777G', 'Javier', 'Gutiérrez Rodríguez', '666777777', 'javier.gutierrez@instituto.es', 2),
('88888888H', 'Sara', 'Torres Navarro', '666888888', 'sara.torres@instituto.es', 2),
('99999999I', 'Miguel', 'Romero Castro', '666999999', 'miguel.romero@instituto.es', 3),
('10101010J', 'Elena', 'Vargas Ortiz', '666101010', 'elena.vargas@instituto.es', 3),
('12121212K', 'Pablo', 'Serrano Delgado', '666121212', 'pablo.serrano@instituto.es', 3),
('13131313L', 'Ana', 'Blanco Márquez', '666131313', 'ana.blanco@instituto.es', 3),
('14141414M', 'Carlos', 'Ramos Vidal', '666141414', 'carlos.ramos@instituto.es', 4),
('15151515N', 'Marina', 'Peña Flores', '666151515', 'marina.pena@instituto.es', 4),
('16161616O', 'Raúl', 'Cano Iglesias', '666161616', 'raul.cano@instituto.es', 4),
('17171717P', 'Clara', 'Mendoza Pascual', '666171717', 'clara.mendoza@instituto.es', 4),
('18181818Q', 'Diego', 'León Cortés', '666181818', 'diego.leon@instituto.es', 5),
('19191919R', 'Nuria', 'Calvo Suárez', '666191919', 'nuria.calvo@instituto.es', 5),
('20202020S', 'Óscar', 'Nieto Núñez', '666202020', 'oscar.nieto@instituto.es', 5),
('21212121T', 'Silvia', 'Quintana Morales', '666212121', 'silvia.quintana@instituto.es', 5),
('22222223U', 'Hugo', 'Cortina Méndez', '666222223', 'hugo.cortina@instituto.es', 6),
('23232323V', 'Alicia', 'Alarcón Gutiérrez', '666232323', 'alicia.alarcon@instituto.es', 6),
('24242424W', 'Víctor', 'Valero Navarro', '666242424', 'victor.valero@instituto.es', 6),
('25252525X', 'Miriam', 'Pinto Romero', '666252525', 'miriam.pinto@instituto.es', 6),
('26262626Y', 'Ángel', 'Peña Vargas', '666262626', 'angel.pena@instituto.es', 7),
('27272727Z', 'Carla', 'Márquez López', '666272727', 'carla.marquez@instituto.es', 7),
('28282828A', 'Sergio', 'Ortiz Sánchez', '666282828', 'sergio.ortiz@instituto.es', 7),
('29292929B', 'Ainhoa', 'García Ruiz', '666292929', 'ainhoa.garcia@instituto.es', 7),
('30303030C', 'Iker', 'Sánchez Gómez', '666303030', 'iker.sanchez@instituto.es', 8),
('31313131D', 'Aitana', 'Díaz Fernández', '666313131', 'aitana.diaz@instituto.es', 8),
('32323232E', 'Unai', 'Pérez Martínez', '666323232', 'unai.perez@instituto.es', 8),
('33333333F', 'June', 'Gómez Sánchez', '666333333', 'june.gomez@instituto.es', 8),
('34343434G', 'Markel', 'López Rodríguez', '666343434', 'markel.lopez@instituto.es', 9),
('35353535H', 'Maialen', 'Fernández Díaz', '666353535', 'maialen.fernandez@instituto.es', 9),
('36363636I', 'Asier', 'Martínez Pérez', '666363636', 'asier.martinez@instituto.es', 9),
('37373737J', 'Leire', 'García Gómez', '666373737', 'leire.garcia@instituto.es', 9),
('38383838K', 'Imanol', 'Serrano Díaz', '666383838', 'imanol.serrano@instituto.es', 10),
('39393939L', 'Ane', 'Hernández Sánchez', '666393939', 'ane.hernandez@instituto.es', 10),
('40404040M', 'Miguel Ángel', 'López García', '666404040', 'miguel.angel.lopez@instituto.es', 10),
('41414141N', 'Carmen', 'Martínez Fernández', '666414141', 'carmen.martinez@instituto.es', 10),
('42424242O', 'Pedro', 'Gómez Pérez', '666424242', 'pedro.gomez@instituto.es', 11),
('43434343P', 'Ana', 'Sánchez Rodríguez', '666434343', 'ana.sanchez@instituto.es', 11),
('44444445Q', 'Luis', 'Fernández López', '666444445', 'luis.fernandez@instituto.es', 11),
('45454545R', 'Elena', 'Pérez García', '666454545', 'elena.perez@instituto.es', 11),
('46464646S', 'José', 'Díaz Martínez', '666464646', 'jose.diaz@instituto.es', 12),
('47474747T', 'Isabel', 'Gómez Sánchez', '666474747', 'isabel.gomez@instituto.es', 12),
('48484848U', 'Francisco', 'Rodríguez Fernández', '666484848', 'francisco.rodriguez@instituto.es', 12),
('49494949V', 'Dolores', 'López Pérez', '666494949', 'dolores.lopez@instituto.es', 12),
('50505050W', 'Manuel', 'Martínez Gómez', '666505050', 'manuel.martinez@instituto.es', 13),
('51515151X', 'Cristina', 'Sánchez Díaz', '666515151', 'cristina.sanchez@instituto.es', 13),
('52525252Y', 'Antonio', 'Fernández Rodríguez', '666525252', 'antonio.fernandez@instituto.es', 13),
('53535353Z', 'Pilar', 'Pérez López', '666535353', 'pilar.perez@instituto.es', 13),
('54545454A', 'Rosa', 'García Martínez', '666545454', 'rosa.garcia@instituto.es', 14),
('55555556B', 'Jesús', 'Hernández Gómez', '666555556', 'jesus.hernandez@instituto.es', 14),
('56565656C', 'Teresa', 'López Sánchez', '666565656', 'teresa.lopez@instituto.es', 14),
('57575757D', 'Fernando', 'Martínez Pérez', '666575757', 'fernando.martinez@instituto.es', 14),
('58585858E', 'Mercedes', 'Gómez Fernández', '666585858', 'mercedes.gomez@instituto.es', 15),
('59595959F', 'José Luis', 'Sánchez Rodríguez', '666595959', 'jose.luis.sanchez@instituto.es', 15),
('60606060G', 'Carmen', 'Fernández López', '666606060', 'carmen.fernandez@instituto.es', 15),
('61616161H', 'Juan Carlos', 'Pérez García', '666616161', 'juan.carlos.perez@instituto.es', 15),
('62626262I', 'Laura', 'Díaz Martínez', '666626262', 'laura.diaz@instituto.es', 16),
('63636363J', 'David', 'Gómez Sánchez', '666636363', 'david.gomez@instituto.es', 16),
('64646464K', 'Sara', 'Rodríguez Fernández', '666646464', 'sara.rodriguez@instituto.es', 16),
('65656565L', 'Pablo', 'López Pérez', '666656565', 'pablo.lopez@instituto.es', 16),
('66666667M', 'Marta', 'Martínez Gómez', '666666667', 'marta.martinez@instituto.es', 17),
('67676767N', 'Carlos', 'Sánchez Díaz', '666676767', 'carlos.sanchez@instituto.es', 17),
('68686868O', 'Ana', 'Fernández Rodríguez', '666686868', 'ana.fernandez@instituto.es', 17),
('69696969P', 'Javier', 'Pérez López', '666696969', 'javier.perez@instituto.es', 17),
('70707070Q', 'José', 'García Martínez', '666707070', 'jose.garcia@instituto.es', 18),
('71717171R', 'Rosa', 'Hernández Gómez', '666717171', 'rosa.hernandez@instituto.es', 18),
('72727272S', 'Francisco', 'López Sánchez', '666727272', 'francisco.lopez@instituto.es', 18),
('73737373T', 'Dolores', 'Martínez Pérez', '666737373', 'dolores.martinez@instituto.es', 18),
('74747474U', 'Jesús', 'Gómez Fernández', '666747474', 'jesus.gomez@instituto.es', 19),
('75757575V', 'Teresa', 'Sánchez Rodríguez', '666757575', 'teresa.sanchez@instituto.es', 19),
('76767676W', 'Fernando', 'Fernández López', '666767676', 'fernando.fernandez@instituto.es', 19),
('77777778X', 'Mercedes', 'Pérez García', '666777778', 'mercedes.perez@instituto.es', 19),
('78787878Y', 'José Luis', 'Díaz Martínez', '666787878', 'jose.luis.diaz@instituto.es', 20),
('79797979Z', 'Carmen', 'Gómez Sánchez', '666797979', 'carmen.gomez@instituto.es', 20),
('80808080A', 'Juan Carlos', 'Rodríguez Fernández', '666808080', 'juan.carlos.rodriguez@instituto.es', 20),
('81818181B', 'Laura', 'López Pérez', '666818181', 'laura.lopez@instituto.es', 20),
('82828282C', 'David', 'Martínez Gómez', '666828282', 'david.martinez@instituto.es', 21),
('83838383D', 'Sara', 'Sánchez Díaz', '666838383', 'sara.sanchez@instituto.es', 21),
('84848484E', 'Pablo', 'Fernández Rodríguez', '666848484', 'pablo.fernandez@instituto.es', 21),
('85858585F', 'Marta', 'Pérez López', '666858585', 'marta.perez@instituto.es', 21),
('86868686G', 'Carlos', 'García Martínez', '666868686', 'carlos.garcia@instituto.es', 22),
('87878787H', 'Ana', 'Hernández Gómez', '666878787', 'ana.hernandez@instituto.es', 22),
('88888889I', 'Javier', 'López Sánchez', '666888889', 'javier.lopez@instituto.es', 22),
('89898989J', 'Pedro', 'Martínez Pérez', '666898989', 'pedro.martinez@instituto.es', 22),
('90909090K', 'María', 'Gómez Fernández', '666909090', 'maria.gomez@instituto.es', 23),
('91919191L', 'Luis', 'Sánchez Rodríguez', '666919191', 'luis.sanchez@instituto.es', 23),
('92929292M', 'Elena', 'Fernández López', '666929292', 'elena.fernandez@instituto.es', 23),
('93939393N', 'José', 'Pérez García', '666939393', 'jose.perez@instituto.es', 23),
('94949494O', 'Carmen', 'Díaz Martínez', '666949494', 'carmen.diaz@instituto.es', 24),
('95959595P', 'Antonio', 'Gómez Sánchez', '666959595', 'antonio.gomez@instituto.es', 24),
('96969696Q', 'Pilar', 'Rodríguez Fernández', '666969696', 'pilar.rodriguez@instituto.es', 24),
('97979797R', 'Rosa', 'López Pérez', '666979797', 'rosa.lopez@instituto.es', 24),
('98989898S', 'Francisco', 'Martínez Gómez', '666989898', 'francisco.martinez@instituto.es', 25),
('99999990T', 'Dolores', 'Sánchez Díaz', '666999990', 'dolores.sanchez@instituto.es', 25),
('01010101U', 'Jesús', 'Fernández Rodríguez', '666010101', 'jesus.fernandez@instituto.es', 25),
('02020202V', 'Teresa', 'Pérez López', '666020202', 'teresa.perez@instituto.es', 25),
('03030303W', 'Fernando', 'García Martínez', '666030303', 'fernando.garcia@instituto.es', 26),
('04040404X', 'Mercedes', 'Hernández Gómez', '666040404', 'mercedes.hernandez@instituto.es', 26),
('05050505Y', 'José Luis', 'López Sánchez', '666050505', 'jose.luis.lopez@instituto.es', 26),
('06060606Z', 'Carmen', 'Martínez Pérez', '666060606', 'carmen.martinez@instituto.es', 26),
('07070707A', 'Juan Carlos', 'Gómez Fernández', '666070707', 'juan.carlos.gomez@instituto.es', 27),
('08080808B', 'Laura', 'Sánchez Rodríguez', '666080808', 'laura.sanchez@instituto.es', 27),
('09090909C', 'David', 'Fernández López', '666090909', 'david.fernandez@instituto.es', 27),
('10101011D', 'Sara', 'Pérez García', '666101011', 'sara.perez@instituto.es', 27),
('11111112E', 'Pablo', 'Díaz Martínez', '666111112', 'pablo.diaz@instituto.es', 28),
('12121213F', 'Marta', 'Gómez Sánchez', '666121213', 'marta.gomez@instituto.es', 28),
('13131314G', 'Carlos', 'Rodríguez Fernández', '666131314', 'carlos.rodriguez@instituto.es', 28),
('14141415H', 'Ana', 'López Pérez', '666141415', 'ana.lopez@instituto.es', 28),
('15151516I', 'Javier', 'Martínez Gómez', '666151516', 'javier.martinez@instituto.es', 29),
('16161617J', 'Pedro', 'Sánchez Díaz', '666161617', 'pedro.sanchez@instituto.es', 29),
('17171718K', 'María', 'Fernández Rodríguez', '666171718', 'maria.fernandez@instituto.es', 29),
('18181819L', 'Luis', 'Pérez López', '666181819', 'luis.perez@instituto.es', 29),
('19191920M', 'Elena', 'García Martínez', '666191920', 'elena.garcia@instituto.es', 30),
('20202021N', 'José', 'Hernández Gómez', '666202021', 'jose.hernandez@instituto.es', 30),
('21212122O', 'Carmen', 'López Sánchez', '666212122', 'carmen.lopez@instituto.es', 30),
('22222224P', 'Francisco', 'Martínez Pérez', '666222224', 'francisco.martinez@instituto.es', 30),
('23232325Q', 'Dolores', 'Gómez Fernández', '666232325', 'dolores.gomez@instituto.es', 31),
('24242426R', 'Jesús', 'Sánchez Rodríguez', '666242426', 'jesus.sanchez@instituto.es', 31),
('25252527S', 'Teresa', 'Fernández López', '666252527', 'teresa.fernandez@instituto.es', 31),
('26262628T', 'Fernando', 'Pérez García', '666262628', 'fernando.perez@instituto.es', 31),
('27272729U', 'Mercedes', 'Díaz Martínez', '666272729', 'mercedes.diaz@instituto.es', 32),
('28282830V', 'José Luis', 'Gómez Sánchez', '666282830', 'jose.luis.gomez@instituto.es', 32),
('29292931W', 'Carmen', 'Rodríguez Fernández', '666292931', 'carmen.rodriguez@instituto.es', 32),
('30303032X', 'Juan Carlos', 'López Pérez', '666303032', 'juan.carlos.lopez@instituto.es', 32),
('31313133Y', 'Laura', 'Martínez Gómez', '666313133', 'laura.martinez@instituto.es', 33),
('32323234Z', 'David', 'Sánchez Díaz', '666323234', 'david.sanchez@instituto.es', 33),
('33333335A', 'Sara', 'Fernández Rodríguez', '666333335', 'sara.fernandez@instituto.es', 33),
('34343436B', 'Pablo', 'Pérez López', '666343436', 'pablo.perez@instituto.es', 33),
('35353537C', 'Marta', 'García Martínez', '666353537', 'marta.garcia@instituto.es', 34),
('36363638D', 'Carlos', 'Hernández Gómez', '666363638', 'carlos.hernandez@instituto.es', 34),
('37373739E', 'Ana', 'López Sánchez', '666373739', 'ana.lopez@instituto.es', 34),
('38383840F', 'Javier', 'Martínez Pérez', '666383840', 'javier.martinez@instituto.es', 34),
('39393941G', 'Pedro', 'Gómez Fernández', '666393941', 'pedro.gomez@instituto.es', 35),
('40404042H', 'María', 'Sánchez Rodríguez', '666404042', 'maria.sanchez@instituto.es', 35),
('41414143I', 'Luis', 'Fernández López', '666414143', 'luis.fernandez@instituto.es', 35),
('42424244J', 'Elena', 'Pérez García', '666424244', 'elena.perez@instituto.es', 35),
('43434345K', 'José', 'Díaz Martínez', '666434345', 'jose.diaz@instituto.es', 36),
('44444446L', 'Rosa', 'Gómez Sánchez', '666444446', 'rosa.gomez@instituto.es', 36),
('45454547M', 'Francisco', 'Rodríguez Fernández', '666454547', 'francisco.rodriguez@instituto.es', 36),
('46464648N', 'Dolores', 'López Pérez', '666464648', 'dolores.lopez@instituto.es', 36);

INSERT INTO alumnos (dni, nombre, apellidos, telefono, email, id_curso) VALUES
('47474749O', 'Víctor', 'Molina Serrano', '666474749', 'victor.molina@instituto.es', 1),
('48484850P', 'Natalia', 'Iglesias Castro', '666484850', 'natalia.iglesias@instituto.es', 1),
('49494951Q', 'Roberto', 'Ruíz Pascual', '666494951', 'roberto.ruiz@instituto.es', 1),
('50505052R', 'Sonia', 'Herrera Mendoza', '666505052', 'sonia.herrera@instituto.es', 1),
('51515153S', 'Jesús', 'Calvo Alarcón', '666515153', 'jesus.calvo@instituto.es', 2),
('52525254T', 'Cristina', 'Valero Navarro', '666525254', 'cristina.valero@instituto.es', 2),
('53535355U', 'Álvaro', 'Pinto Romero', '666535355', 'alvaro.pinto@instituto.es', 2),
('54545456V', 'Miriam', 'Peña Vargas', '666545456', 'miriam.pena@instituto.es', 2),
('55555557W', 'Ángel', 'Márquez López', '666555557', 'angel.marquez@instituto.es', 3),
('56565658X', 'Carla', 'Ortiz Sánchez', '666565658', 'carla.ortiz@instituto.es', 3),
('57575759Y', 'Sergio', 'García Ruiz', '666575759', 'sergio.garcia@instituto.es', 3),
('58585860Z', 'Ainhoa', 'Sánchez Gómez', '666585860', 'ainhoa.sanchez@instituto.es', 3),
('59595961A', 'Iker', 'Díaz Fernández', '666595961', 'iker.diaz@instituto.es', 4),
('60606062B', 'Aitana', 'Pérez Martínez', '666606062', 'aitana.perez@instituto.es', 4),
('61616163C', 'Unai', 'Gómez Sánchez', '666616163', 'unai.gomez@instituto.es', 4),
('62626264D', 'June', 'López Rodríguez', '666626264', 'june.lopez@instituto.es', 4),
('63636365E', 'Markel', 'Fernández Díaz', '666636365', 'markel.fernandez@instituto.es', 5),
('64646466F', 'Maialen', 'Martínez Pérez', '666646466', 'maialen.martinez@instituto.es', 5),
('65656567G', 'Asier', 'García Gómez', '666656567', 'asier.garcia@instituto.es', 5),
('66666668H', 'Leire', 'Serrano Díaz', '666666668', 'leire.serrano@instituto.es', 5),
('67676769I', 'Imanol', 'Hernández Sánchez', '666676769', 'imanol.hernandez@instituto.es', 6),
('68686870J', 'Ane', 'López García', '666686870', 'ane.lopez@instituto.es', 6),
('69696971K', 'Miguel Ángel', 'Martínez Fernández', '666696971', 'miguel.angel.martinez@instituto.es', 6),
('70707072L', 'Carmen', 'Gómez Pérez', '666707072', 'carmen.gomez@instituto.es', 6),
('71717173M', 'Pedro', 'Sánchez Rodríguez', '666717173', 'pedro.sanchez@instituto.es', 7),
('72727274N', 'Ana', 'Fernández López', '666727274', 'ana.fernandez@instituto.es', 7),
('73737375O', 'Luis', 'Pérez García', '666737375', 'luis.perez@instituto.es', 7),
('74747476P', 'Elena', 'Díaz Martínez', '666747476', 'elena.diaz@instituto.es', 7),
('75757577Q', 'José', 'Gómez Sánchez', '666757577', 'jose.gomez@instituto.es', 8),
('76767678R', 'Isabel', 'Rodríguez Fernández', '666767678', 'isabel.rodriguez@instituto.es', 8),
('77777779S', 'Francisco', 'López Pérez', '666777779', 'francisco.lopez@instituto.es', 8),
('78787880T', 'Dolores', 'Martínez Gómez', '666787880', 'dolores.martinez@instituto.es', 8),
('79797981U', 'Manuel', 'Sánchez Díaz', '666797981', 'manuel.sanchez@instituto.es', 9),
('80808082V', 'Cristina', 'Fernández Rodríguez', '666808082', 'cristina.fernandez@instituto.es', 9),
('81818183W', 'Antonio', 'Pérez López', '666818183', 'antonio.perez@instituto.es', 9),
('82828284X', 'Pilar', 'García Martínez', '666828284', 'pilar.garcia@instituto.es', 9),
('83838385Y', 'Rosa', 'Hernández Gómez', '666838385', 'rosa.hernandez@instituto.es', 10),
('84848486Z', 'Jesús', 'López Sánchez', '666848486', 'jesus.lopez@instituto.es', 10),
('85858587A', 'Teresa', 'Martínez Pérez', '666858587', 'teresa.martinez@instituto.es', 10),
('86868688B', 'Fernando', 'Gómez Fernández', '666868688', 'fernando.gomez@instituto.es', 10),
('87878789C', 'Mercedes', 'Sánchez Rodríguez', '666878789', 'mercedes.sanchez@instituto.es', 11),
('88888890D', 'José Luis', 'Fernández López', '666888890', 'jose.luis.fernandez@instituto.es', 11),
('89898991E', 'Carmen', 'Pérez García', '666898991', 'carmen.perez@instituto.es', 11),
('90909092F', 'Juan Carlos', 'Díaz Martínez', '666909092', 'juan.carlos.diaz@instituto.es', 11),
('91919193G', 'Laura', 'Gómez Sánchez', '666919193', 'laura.gomez@instituto.es', 12),
('92929294H', 'David', 'Rodríguez Fernández', '666929294', 'david.rodriguez@instituto.es', 12),
('93939395I', 'Sara', 'López Pérez', '666939395', 'sara.lopez@instituto.es', 12),
('94949496J', 'Pablo', 'Martínez Gómez', '666949496', 'pablo.martinez@instituto.es', 12),
('95959597K', 'Marta', 'Sánchez Díaz', '666959597', 'marta.sanchez@instituto.es', 13),
('96969698L', 'Carlos', 'Fernández Rodríguez', '666969698', 'carlos.fernandez@instituto.es', 13),
('97979799M', 'Ana', 'Pérez López', '666979799', 'ana.perez@instituto.es', 13),
('98989900N', 'Javier', 'García Martínez', '666989900', 'javier.garcia@instituto.es', 13),
('99999901O', 'Pedro', 'Hernández Gómez', '666999901', 'pedro.hernandez@instituto.es', 14),
('00000002P', 'María', 'López Sánchez', '666000002', 'maria.lopez@instituto.es', 14),
('01010103Q', 'Luis', 'Martínez Pérez', '666010103', 'luis.martinez@instituto.es', 14),
('02020204R', 'Elena', 'Gómez Fernández', '666020204', 'elena.gomez@instituto.es', 14),
('03030305S', 'José', 'Sánchez Rodríguez', '666030305', 'jose.sanchez@instituto.es', 15),
('04040406T', 'Carmen', 'Fernández López', '666040406', 'carmen.fernandez@instituto.es', 15),
('05050507U', 'Antonio', 'Pérez García', '666050507', 'antonio.perez@instituto.es', 15),
('06060608V', 'Pilar', 'Díaz Martínez', '666060608', 'pilar.diaz@instituto.es', 15),
('07070709W', 'Manuel', 'Gómez Sánchez', '666070709', 'manuel.gomez@instituto.es', 16),
('08080810X', 'Rosa', 'Rodríguez Fernández', '666080810', 'rosa.rodriguez@instituto.es', 16),
('09090911Y', 'Francisco', 'López Pérez', '666090911', 'francisco.lopez@instituto.es', 16),
('10101012Z', 'Dolores', 'Martínez Gómez', '666101012', 'dolores.martinez@instituto.es', 16),
('11111113A', 'Jesús', 'Sánchez Díaz', '666111113', 'jesus.sanchez@instituto.es', 17),
('12121214B', 'Teresa', 'Fernández Rodríguez', '666121214', 'teresa.fernandez@instituto.es', 17),
('13131315C', 'Fernando', 'Pérez López', '666131315', 'fernando.perez@instituto.es', 17),
('14141416D', 'Mercedes', 'García Martínez', '666141416', 'mercedes.garcia@instituto.es', 17),
('15151517E', 'José Luis', 'Hernández Gómez', '666151517', 'jose.luis.hernandez@instituto.es', 18),
('16161618F', 'Carmen', 'López Sánchez', '666161618', 'carmen.lopez@instituto.es', 18),
('17171719G', 'Juan Carlos', 'Martínez Pérez', '666171719', 'juan.carlos.martinez@instituto.es', 18),
('18181820H', 'Laura', 'Gómez Fernández', '666181820', 'laura.gomez@instituto.es', 18),
('19191921I', 'David', 'Sánchez Rodríguez', '666191921', 'david.sanchez@instituto.es', 19),
('20202022J', 'Sara', 'Fernández López', '666202022', 'sara.fernandez@instituto.es', 19),
('21212123K', 'Pablo', 'Pérez García', '666212123', 'pablo.perez@instituto.es', 19),
('22222225L', 'Marta', 'Díaz Martínez', '666222225', 'marta.diaz@instituto.es', 19),
('23232326M', 'Carlos', 'Gómez Sánchez', '666232326', 'carlos.gomez@instituto.es', 20),
('24242427N', 'Ana', 'Rodríguez Fernández', '666242427', 'ana.rodriguez@instituto.es', 20),
('25252528O', 'Javier', 'López Pérez', '666252528', 'javier.lopez@instituto.es', 20),
('26262629P', 'Pedro', 'Martínez Gómez', '666262629', 'pedro.martinez@instituto.es', 20),
('27272730Q', 'María', 'Sánchez Díaz', '666272730', 'maria.sanchez@instituto.es', 21),
('28282831R', 'Luis', 'Fernández Rodríguez', '666282831', 'luis.fernandez@instituto.es', 21),
('29292932S', 'Elena', 'Pérez López', '666292932', 'elena.perez@instituto.es', 21),
('30303033T', 'José', 'García Martínez', '666303033', 'jose.garcia@instituto.es', 21),
('31313134U', 'Carmen', 'Hernández Gómez', '666313134', 'carmen.hernandez@instituto.es', 22),
('32323235V', 'Antonio', 'López Sánchez', '666323235', 'antonio.lopez@instituto.es', 22),
('33333336W', 'Pilar', 'Martínez Pérez', '666333336', 'pilar.martinez@instituto.es', 22),
('34343437X', 'Manuel', 'Gómez Fernández', '666343437', 'manuel.gomez@instituto.es', 22),
('35353538Y', 'Rosa', 'Sánchez Rodríguez', '666353538', 'rosa.sanchez@instituto.es', 23),
('36363639Z', 'Francisco', 'Fernández López', '666363639', 'francisco.fernandez@instituto.es', 23),
('37373740A', 'Dolores', 'Pérez García', '666373740', 'dolores.perez@instituto.es', 23),
('38383841B', 'Jesús', 'Díaz Martínez', '666383841', 'jesus.diaz@instituto.es', 23),
('39393942C', 'Teresa', 'Gómez Sánchez', '666393942', 'teresa.gomez@instituto.es', 24),
('40404043D', 'Fernando', 'Rodríguez Fernández', '666404043', 'fernando.rodriguez@instituto.es', 24),
('41414144E', 'Mercedes', 'López Pérez', '666414144', 'mercedes.lopez@instituto.es', 24),
('42424245F', 'José Luis', 'Martínez Gómez', '666424245', 'jose.luis.martinez@instituto.es', 24),
('43434346G', 'Carmen', 'Sánchez Díaz', '666434346', 'carmen.sanchez@instituto.es', 25),
('44444447H', 'Juan Carlos', 'Fernández Rodríguez', '666444447', 'juan.carlos.fernandez@instituto.es', 25),
('45454548I', 'Laura', 'Pérez López', '666454548', 'laura.perez@instituto.es', 25),
('46464649J', 'David', 'García Martínez', '666464649', 'david.garcia@instituto.es', 25),
('47474750K', 'Sara', 'Hernández Gómez', '666474750', 'sara.hernandez@instituto.es', 26),
('48484851L', 'Pablo', 'López Sánchez', '666484851', 'pablo.lopez@instituto.es', 26),
('49494952M', 'Marta', 'Martínez Pérez', '666494952', 'marta.martinez@instituto.es', 26),
('50505053N', 'Carlos', 'Gómez Fernández', '666505053', 'carlos.gomez@instituto.es', 26),
('51515154O', 'Ana', 'Sánchez Rodríguez', '666515154', 'ana.sanchez@instituto.es', 27),
('52525255P', 'Javier', 'Fernández López', '666525255', 'javier.fernandez@instituto.es', 27),
('53535356Q', 'Pedro', 'Pérez García', '666535356', 'pedro.perez@instituto.es', 27),
('54545457R', 'María', 'Díaz Martínez', '666545457', 'maria.diaz@instituto.es', 27),
('55555558S', 'Luis', 'Gómez Sánchez', '666555558', 'luis.gomez@instituto.es', 28),
('56565659T', 'Elena', 'Rodríguez Fernández', '666565659', 'elena.rodriguez@instituto.es', 28),
('57575760U', 'José', 'López Pérez', '666575760', 'jose.lopez@instituto.es', 28),
('58585861V', 'Carmen', 'Martínez Gómez', '666585861', 'carmen.martinez@instituto.es', 28),
('59595962W', 'Antonio', 'Sánchez Díaz', '666595962', 'antonio.sanchez@instituto.es', 29),
('60606063X', 'Pilar', 'Fernández Rodríguez', '666606063', 'pilar.fernandez@instituto.es', 29),
('61616164Y', 'Manuel', 'Pérez López', '666616164', 'manuel.perez@instituto.es', 29),
('62626265Z', 'Rosa', 'García Martínez', '666626265', 'rosa.garcia@instituto.es', 29),
('63636366A', 'Francisco', 'Hernández Gómez', '666636366', 'francisco.hernandez@instituto.es', 30),
('64646467B', 'Dolores', 'López Sánchez', '666646467', 'dolores.lopez@instituto.es', 30),
('65656568C', 'Jesús', 'Martínez Pérez', '666656568', 'jesus.martinez@instituto.es', 30),
('66666669D', 'Teresa', 'Gómez Fernández', '666666669', 'teresa.gomez@instituto.es', 30),
('67676770E', 'Fernando', 'Sánchez Rodríguez', '666676770', 'fernando.sanchez@instituto.es', 31),
('68686871F', 'Mercedes', 'Fernández López', '666686871', 'mercedes.fernandez@instituto.es', 31),
('69696972G', 'José Luis', 'Pérez García', '666696972', 'jose.luis.perez@instituto.es', 31),
('70707073H', 'Carmen', 'Díaz Martínez', '666707073', 'carmen.diaz@instituto.es', 31),
('71717174I', 'Juan Carlos', 'Gómez Sánchez', '666717174', 'juan.carlos.gomez@instituto.es', 32),
('72727275J', 'Laura', 'Rodríguez Fernández', '666727275', 'laura.rodriguez@instituto.es', 32),
('73737376K', 'David', 'López Pérez', '666737376', 'david.lopez@instituto.es', 32),
('74747477L', 'Sara', 'Martínez Gómez', '666747477', 'sara.martinez@instituto.es', 32),
('75757578M', 'Pablo', 'Sánchez Díaz', '666757578', 'pablo.sanchez@instituto.es', 33),
('76767679N', 'Marta', 'Fernández Rodríguez', '666767679', 'marta.fernandez@instituto.es', 33),
('77777780O', 'Carlos', 'Pérez López', '666777780', 'carlos.perez@instituto.es', 33),
('78787881P', 'Ana', 'García Martínez', '666787881', 'ana.garcia@instituto.es', 33),
('79797982Q', 'Javier', 'Hernández Gómez', '666797982', 'javier.hernandez@instituto.es', 34),
('80808083R', 'Pedro', 'López Sánchez', '666808083', 'pedro.lopez@instituto.es', 34),
('81818184S', 'María', 'Martínez Pérez', '666818184', 'maria.martinez@instituto.es', 34),
('82828285T', 'Luis', 'Gómez Fernández', '666828285', 'luis.gomez@instituto.es', 34),
('83838386U', 'Elena', 'Sánchez Rodríguez', '666838386', 'elena.sanchez@instituto.es', 35),
('84848487V', 'José', 'Fernández López', '666848487', 'jose.fernandez@instituto.es', 35),
('85858588W', 'Carmen', 'Pérez García', '666858588', 'carmen.perez@instituto.es', 35),
('86868689X', 'Antonio', 'Díaz Martínez', '666868689', 'antonio.diaz@instituto.es', 35),
('87878790Y', 'Pilar', 'Gómez Sánchez', '666878790', 'pilar.gomez@instituto.es', 36),
('88888891Z', 'Manuel', 'Rodríguez Fernández', '666888891', 'manuel.rodriguez@instituto.es', 36),
('89898992A', 'Rosa', 'López Pérez', '666898992', 'rosa.lopez@instituto.es', 36),
('90909093B', 'Francisco', 'Martínez Gómez', '666909093', 'francisco.martinez@instituto.es', 36);

INSERT INTO alumnos (dni, nombre, apellidos, telefono, email, id_curso) VALUES
('91919194C', 'Nuria', 'Calvo Suárez', '666919194', 'nuria.calvo@instituto.es', 1),
('92929295D', 'Óscar', 'Nieto Núñez', '666929295', 'oscar.nieto@instituto.es', 1),
('93939396E', 'Silvia', 'Quintana Morales', '666939396', 'silvia.quintana@instituto.es', 1),
('94949497F', 'Hugo', 'Cortina Méndez', '666949497', 'hugo.cortina@instituto.es', 1),
('95959598G', 'Alicia', 'Alarcón Gutiérrez', '666959598', 'alicia.alarcon@instituto.es', 2),
('96969699H', 'Víctor', 'Valero Navarro', '666969699', 'victor.valero@instituto.es', 2),
('97979700I', 'Miriam', 'Pinto Romero', '666979700', 'miriam.pinto@instituto.es', 2),
('98989801J', 'Ángel', 'Peña Vargas', '666989801', 'angel.pena@instituto.es', 2),
('99999902K', 'Carla', 'Márquez López', '666999902', 'carla.marquez@instituto.es', 3),
('00000003L', 'Sergio', 'Ortiz Sánchez', '666000003', 'sergio.ortiz@instituto.es', 3),
('01010104M', 'Ainhoa', 'García Ruiz', '666010104', 'ainhoa.garcia@instituto.es', 3),
('02020205N', 'Iker', 'Sánchez Gómez', '666020205', 'iker.sanchez@instituto.es', 3),
('03030306O', 'Aitana', 'Díaz Fernández', '666030306', 'aitana.diaz@instituto.es', 4),
('04040407P', 'Unai', 'Pérez Martínez', '666040407', 'unai.perez@instituto.es', 4),
('05050508Q', 'June', 'Gómez Sánchez', '666050508', 'june.gomez@instituto.es', 4),
('06060609R', 'Markel', 'López Rodríguez', '666060609', 'markel.lopez@instituto.es', 4),
('07070710S', 'Maialen', 'Fernández Díaz', '666070710', 'maialen.fernandez@instituto.es', 5),
('08080811T', 'Asier', 'Martínez Pérez', '666080811', 'asier.martinez@instituto.es', 5),
('09090912U', 'Leire', 'García Gómez', '666090912', 'leire.garcia@instituto.es', 5),
('10101013V', 'Imanol', 'Serrano Díaz', '666101013', 'imanol.serrano@instituto.es', 5),
('11111114W', 'Ane', 'Hernández Sánchez', '666111114', 'ane.hernandez@instituto.es', 6),
('12121215X', 'Miguel Ángel', 'López García', '666121215', 'miguel.angel.lopez@instituto.es', 6),
('13131316Y', 'Carmen', 'Martínez Fernández', '666131316', 'carmen.martinez@instituto.es', 6),
('14141417Z', 'Pedro', 'Gómez Pérez', '666141417', 'pedro.gomez@instituto.es', 6),
('15151518A', 'Ana', 'Sánchez Rodríguez', '666151518', 'ana.sanchez@instituto.es', 7),
('16161619B', 'Luis', 'Fernández López', '666161619', 'luis.fernandez@instituto.es', 7),
('17171720C', 'Elena', 'Pérez García', '666171720', 'elena.perez@instituto.es', 7),
('18181821D', 'José', 'Díaz Martínez', '666181821', 'jose.diaz@instituto.es', 7),
('19191922E', 'Isabel', 'Gómez Sánchez', '666191922', 'isabel.gomez@instituto.es', 8),
('20202023F', 'Francisco', 'Rodríguez Fernández', '666202023', 'francisco.rodriguez@instituto.es', 8),
('21212124G', 'Dolores', 'López Pérez', '666212124', 'dolores.lopez@instituto.es', 8),
('22222226H', 'Manuel', 'Martínez Gómez', '666222226', 'manuel.martinez@instituto.es', 8),
('23232327I', 'Cristina', 'Sánchez Díaz', '666232327', 'cristina.sanchez@instituto.es', 9),
('24242428J', 'Antonio', 'Fernández Rodríguez', '666242428', 'antonio.fernandez@instituto.es', 9),
('25252529K', 'Pilar', 'Pérez López', '666252529', 'pilar.perez@instituto.es', 9),
('26262630L', 'Rosa', 'García Martínez', '666262630', 'rosa.garcia@instituto.es', 9),
('27272731M', 'Jesús', 'Hernández Gómez', '666272731', 'jesus.hernandez@instituto.es', 10),
('28282832N', 'Teresa', 'López Sánchez', '666282832', 'teresa.lopez@instituto.es', 10),
('29292933O', 'Fernando', 'Martínez Pérez', '666292933', 'fernando.martinez@instituto.es', 10),
('30303034P', 'Mercedes', 'Gómez Fernández', '666303034', 'mercedes.gomez@instituto.es', 10),
('31313135Q', 'José Luis', 'Sánchez Rodríguez', '666313135', 'jose.luis.sanchez@instituto.es', 11),
('32323236R', 'Carmen', 'Fernández López', '666323236', 'carmen.fernandez@instituto.es', 11),
('33333337S', 'Juan Carlos', 'Pérez García', '666333337', 'juan.carlos.perez@instituto.es', 11),
('34343438T', 'Laura', 'Díaz Martínez', '666343438', 'laura.diaz@instituto.es', 11),
('35353539U', 'David', 'Gómez Sánchez', '666353539', 'david.gomez@instituto.es', 12),
('36363640V', 'Sara', 'Rodríguez Fernández', '666363640', 'sara.rodriguez@instituto.es', 12),
('37373741W', 'Pablo', 'López Pérez', '666373741', 'pablo.lopez@instituto.es', 12),
('38383842X', 'Marta', 'Martínez Gómez', '666383842', 'marta.martinez@instituto.es', 12),
('39393943Y', 'Carlos', 'Sánchez Díaz', '666393943', 'carlos.sanchez@instituto.es', 13),
('40404044Z', 'Ana', 'Fernández Rodríguez', '666404044', 'ana.fernandez@instituto.es', 13),
('41414145A', 'Javier', 'Pérez López', '666414145', 'javier.perez@instituto.es', 13),
('42424246B', 'José', 'García Martínez', '666424246', 'jose.garcia@instituto.es', 13),
('43434347C', 'Rosa', 'Hernández Gómez', '666434347', 'rosa.hernandez@instituto.es', 14),
('44444448D', 'Francisco', 'López Sánchez', '666444448', 'francisco.lopez@instituto.es', 14),
('45454549E', 'Dolores', 'Martínez Pérez', '666454549', 'dolores.martinez@instituto.es', 14),
('46464650F', 'Jesús', 'Gómez Fernández', '666464650', 'jesus.gomez@instituto.es', 14),
('47474751G', 'Teresa', 'Sánchez Rodríguez', '666474751', 'teresa.sanchez@instituto.es', 15),
('48484852H', 'Fernando', 'Fernández López', '666484852', 'fernando.fernandez@instituto.es', 15),
('49494953I', 'Mercedes', 'Pérez García', '666494953', 'mercedes.perez@instituto.es', 15),
('50505054J', 'José Luis', 'Díaz Martínez', '666505054', 'jose.luis.diaz@instituto.es', 15),
('51515155K', 'Carmen', 'Gómez Sánchez', '666515155', 'carmen.gomez@instituto.es', 16),
('52525256L', 'Juan Carlos', 'Rodríguez Fernández', '666525256', 'juan.carlos.rodriguez@instituto.es', 16),
('53535357M', 'Laura', 'López Pérez', '666535357', 'laura.lopez@instituto.es', 16),
('54545458N', 'David', 'Martínez Gómez', '666545458', 'david.martinez@instituto.es', 16),
('55555559O', 'Sara', 'Sánchez Díaz', '666555559', 'sara.sanchez@instituto.es', 17),
('56565660P', 'Pablo', 'Fernández Rodríguez', '666565660', 'pablo.fernandez@instituto.es', 17),
('57575761Q', 'Marta', 'Pérez López', '666575761', 'marta.perez@instituto.es', 17),
('58585862R', 'Carlos', 'García Martínez', '666585862', 'carlos.garcia@instituto.es', 17),
('59595963S', 'Ana', 'Hernández Gómez', '666595963', 'ana.hernandez@instituto.es', 18),
('60606064T', 'Javier', 'López Sánchez', '666606064', 'javier.lopez@instituto.es', 18),
('61616165U', 'Pedro', 'Martínez Pérez', '666616165', 'pedro.martinez@instituto.es', 18),
('62626266V', 'María', 'Gómez Fernández', '666626266', 'maria.gomez@instituto.es', 18),
('63636367W', 'Luis', 'Sánchez Rodríguez', '666636367', 'luis.sanchez@instituto.es', 19),
('64646468X', 'Elena', 'Fernández López', '666646468', 'elena.fernandez@instituto.es', 19),
('65656569Y', 'José', 'Pérez García', '666656569', 'jose.perez@instituto.es', 19),
('66666670Z', 'Carmen', 'Díaz Martínez', '666666770', 'carmen.diaz@instituto.es', 19),
('67676771A', 'Antonio', 'Gómez Sánchez', '666676771', 'antonio.gomez@instituto.es', 20),
('68686872B', 'Pilar', 'Rodríguez Fernández', '666686872', 'pilar.rodriguez@instituto.es', 20),
('69696973C', 'Rosa', 'López Pérez', '666696973', 'rosa.lopez@instituto.es', 20),
('70707074D', 'Francisco', 'Martínez Gómez', '666707074', 'francisco.martinez@instituto.es', 20),
('71717175E', 'Dolores', 'Sánchez Díaz', '666717175', 'dolores.sanchez@instituto.es', 21),
('72727276F', 'Jesús', 'Fernández Rodríguez', '666727276', 'jesus.fernandez@instituto.es', 21),
('73737377G', 'Teresa', 'Pérez López', '666737377', 'teresa.perez@instituto.es', 21),
('74747478H', 'Fernando', 'García Martínez', '666747478', 'fernando.garcia@instituto.es', 21),
('75757579I', 'Mercedes', 'Hernández Gómez', '666757579', 'mercedes.hernandez@instituto.es', 22),
('76767680J', 'José Luis', 'López Sánchez', '666767680', 'jose.luis.lopez@instituto.es', 22),
('77777781K', 'Carmen', 'Martínez Pérez', '666777781', 'carmen.martinez@instituto.es', 22),
('78787882L', 'Juan Carlos', 'Gómez Fernández', '666787882', 'juan.carlos.gomez@instituto.es', 22),
('79797983M', 'Laura', 'Sánchez Rodríguez', '666797983', 'laura.sanchez@instituto.es', 23),
('80808084N', 'David', 'Fernández López', '666808084', 'david.fernandez@instituto.es', 23),
('81818185O', 'Sara', 'Pérez García', '666818185', 'sara.perez@instituto.es', 23),
('82828286P', 'Pablo', 'Díaz Martínez', '666828286', 'pablo.diaz@instituto.es', 23),
('83838387Q', 'Marta', 'Gómez Sánchez', '666838387', 'marta.gomez@instituto.es', 24),
('84848488R', 'Carlos', 'Rodríguez Fernández', '666848488', 'carlos.rodriguez@instituto.es', 24),
('85858589S', 'Ana', 'López Pérez', '666858589', 'ana.lopez@instituto.es', 24),
('86868690T', 'Javier', 'Martínez Gómez', '666868690', 'javier.martinez@instituto.es', 24),
('87878791U', 'Pedro', 'Sánchez Díaz', '666878791', 'pedro.sanchez@instituto.es', 25),
('88888892V', 'María', 'Fernández Rodríguez', '666888892', 'maria.fernandez@instituto.es', 25),
('89898993W', 'Luis', 'Pérez López', '666898993', 'luis.perez@instituto.es', 25),
('90909094X', 'Elena', 'García Martínez', '666909094', 'elena.garcia@instituto.es', 25),
('91919195Y', 'José', 'Hernández Gómez', '666919195', 'jose.hernandez@instituto.es', 26),
('92929296Z', 'Carmen', 'López Sánchez', '666929296', 'carmen.lopez@instituto.es', 26),
('93939397A', 'Francisco', 'Martínez Pérez', '666939397', 'francisco.martinez@instituto.es', 26),
('94949498B', 'Dolores', 'Gómez Fernández', '666949498', 'dolores.gomez@instituto.es', 26),
('95959599C', 'Jesús', 'Sánchez Rodríguez', '666959599', 'jesus.sanchez@instituto.es', 27),
('96969600D', 'Teresa', 'Fernández López', '666969600', 'teresa.fernandez@instituto.es', 27),
('97979701E', 'Fernando', 'Pérez García', '666979701', 'fernando.perez@instituto.es', 27),
('98989802F', 'Mercedes', 'Díaz Martínez', '666989802', 'mercedes.diaz@instituto.es', 27),
('99999903G', 'José Luis', 'Gómez Sánchez', '666999903', 'jose.luis.gomez@instituto.es', 28),
('00000004H', 'Carmen', 'Rodríguez Fernández', '666000004', 'carmen.rodriguez@instituto.es', 28),
('01010105I', 'Juan Carlos', 'López Pérez', '666010105', 'juan.carlos.lopez@instituto.es', 28),
('02020206J', 'Laura', 'Martínez Gómez', '666020206', 'laura.martinez@instituto.es', 28),
('03030307K', 'David', 'Sánchez Díaz', '666030307', 'david.sanchez@instituto.es', 29),
('04040408L', 'Sara', 'Fernández Rodríguez', '666040408', 'sara.fernandez@instituto.es', 29),
('05050509M', 'Pablo', 'Pérez López', '666050509', 'pablo.perez@instituto.es', 29),
('06060610N', 'Marta', 'García Martínez', '666060610', 'marta.garcia@instituto.es', 29),
('07070711O', 'Carlos', 'Hernández Gómez', '666070711', 'carlos.hernandez@instituto.es', 30),
('08080812P', 'Ana', 'López Sánchez', '666080812', 'ana.lopez@instituto.es', 30),
('09090913Q', 'Javier', 'Martínez Pérez', '666090913', 'javier.martinez@instituto.es', 30),
('10101014R', 'Pedro', 'Gómez Fernández', '666101014', 'pedro.gomez@instituto.es', 30),
('11111115S', 'María', 'Sánchez Rodríguez', '666111115', 'maria.sanchez@instituto.es', 31),
('12121216T', 'Luis', 'Fernández López', '666121216', 'luis.fernandez@instituto.es', 31),
('13131317U', 'Elena', 'Pérez García', '666131317', 'elena.perez@instituto.es', 31),
('14141418V', 'José', 'Díaz Martínez', '666141418', 'jose.diaz@instituto.es', 31),
('15151519W', 'Rosa', 'Gómez Sánchez', '666151519', 'rosa.gomez@instituto.es', 32),
('16161620X', 'Francisco', 'Rodríguez Fernández', '666161620', 'francisco.rodriguez@instituto.es', 32),
('17171721Y', 'Dolores', 'López Pérez', '666171721', 'dolores.lopez@instituto.es', 32),
('18181822Z', 'Jesús', 'Martínez Gómez', '666181822', 'jesus.martinez@instituto.es', 32),
('19191923A', 'Teresa', 'Sánchez Díaz', '666191923', 'teresa.sanchez@instituto.es', 33),
('20202024B', 'Fernando', 'Fernández Rodríguez', '666202024', 'fernando.fernandez@instituto.es', 33),
('21212125C', 'Mercedes', 'Pérez López', '666212125', 'mercedes.perez@instituto.es', 33),
('22222227D', 'José Luis', 'García Martínez', '666222227', 'jose.luis.garcia@instituto.es', 33),
('23232328E', 'Carmen', 'Hernández Gómez', '666232328', 'carmen.hernandez@instituto.es', 34),
('24242429F', 'Juan Carlos', 'López Sánchez', '666242429', 'juan.carlos.lopez@instituto.es', 34),
('25252530G', 'Laura', 'Martínez Pérez', '666252530', 'laura.martinez@instituto.es', 34),
('26262631H', 'David', 'Gómez Fernández', '666262631', 'david.gomez@instituto.es', 34),
('27272732I', 'Sara', 'Sánchez Rodríguez', '666272732', 'sara.sanchez@instituto.es', 35),
('28282833J', 'Pablo', 'Fernández López', '666282833', 'pablo.fernandez@instituto.es', 35),
('29292934K', 'Marta', 'Pérez García', '666292934', 'marta.perez@instituto.es', 35),
('30303035L', 'Carlos', 'Díaz Martínez', '666303035', 'carlos.diaz@instituto.es', 35),
('31313136M', 'Ana', 'Gómez Sánchez', '666313136', 'ana.gomez@instituto.es', 36),
('32323237N', 'Javier', 'Rodríguez Fernández', '666323237', 'javier.rodriguez@instituto.es', 36),
('33333338O', 'Pedro', 'López Pérez', '666333338', 'pedro.lopez@instituto.es', 36),
('34343439P', 'María', 'Martínez Gómez', '666343439', 'maria.martinez@instituto.es', 36);

-- CRÍTICO: Actualizar el contador de alumnos_matriculados en cada curso
UPDATE cursos c
SET alumnos_matriculados = (
    SELECT COUNT(*)
    FROM alumnos a
    WHERE a.id_curso = c.id_curso AND a.activo = TRUE
);

-- Crear trigger para mantener sincronizado el contador al insertar alumnos
DELIMITER $
CREATE TRIGGER tr_alumno_insert
AFTER INSERT ON alumnos
FOR EACH ROW
BEGIN
    IF NEW.activo = TRUE THEN
        UPDATE cursos 
        SET alumnos_matriculados = alumnos_matriculados + 1
        WHERE id_curso = NEW.id_curso;
    END IF;
END$

-- Trigger para mantener sincronizado el contador al actualizar alumnos
CREATE TRIGGER tr_alumno_update
AFTER UPDATE ON alumnos
FOR EACH ROW
BEGIN
    -- Si el alumno se activa
    IF OLD.activo = FALSE AND NEW.activo = TRUE THEN
        UPDATE cursos 
        SET alumnos_matriculados = alumnos_matriculados + 1
        WHERE id_curso = NEW.id_curso;
    END IF;
    
    -- Si el alumno se desactiva
    IF OLD.activo = TRUE AND NEW.activo = FALSE THEN
        UPDATE cursos 
        SET alumnos_matriculados = alumnos_matriculados - 1
        WHERE id_curso = NEW.id_curso;
    END IF;
    
    -- Si el alumno cambia de curso (y está activo)
    IF OLD.id_curso != NEW.id_curso AND NEW.activo = TRUE THEN
        UPDATE cursos 
        SET alumnos_matriculados = alumnos_matriculados - 1
        WHERE id_curso = OLD.id_curso;
        
        UPDATE cursos 
        SET alumnos_matriculados = alumnos_matriculados + 1
        WHERE id_curso = NEW.id_curso;
    END IF;
END$

-- Trigger para mantener sincronizado el contador al eliminar alumnos
CREATE TRIGGER tr_alumno_delete
AFTER DELETE ON alumnos
FOR EACH ROW
BEGIN
    IF OLD.activo = TRUE THEN
        UPDATE cursos 
        SET alumnos_matriculados = alumnos_matriculados - 1
        WHERE id_curso = OLD.id_curso;
    END IF;
END$

DELIMITER ;

-- Vista: Listado general de todos los alumnos (ordenado alfabéticamente)
CREATE OR REPLACE VIEW v_listado_general_alumnos AS
SELECT 
    a.dni,
    a.nombre,
    a.apellidos,
    CONCAT(a.apellidos, ', ', a.nombre) AS nombre_completo,
    a.telefono,
    a.email,
    c.nombre_curso,
    fp.nombre_familia,
    a.fecha_matricula,
    a.activo
FROM alumnos a
INNER JOIN cursos c ON a.id_curso = c.id_curso
INNER JOIN familias_profesionales fp ON c.id_familia = fp.id_familia
ORDER BY a.apellidos, a.nombre;

-- Vista: Estadísticas generales del instituto
CREATE OR REPLACE VIEW v_estadisticas_instituto AS
SELECT 
    (SELECT COUNT(*) FROM alumnos WHERE activo = TRUE) AS total_alumnos_activos,
    2000 - (SELECT COUNT(*) FROM alumnos WHERE activo = TRUE) AS plazas_disponibles,
    (SELECT COUNT(*) FROM familias_profesionales) AS total_familias,
    (SELECT COUNT(*) FROM cursos) AS total_cursos,
    (SELECT COUNT(*) FROM alumnos WHERE activo = TRUE) / 2000.0 * 100 AS porcentaje_ocupacion;

-- Vista: Cursos con disponibilidad
CREATE OR REPLACE VIEW v_cursos_disponibilidad AS
SELECT 
    c.id_curso,
    c.nombre_curso,
    fp.nombre_familia,
    c.nivel,
    c.alumnos_matriculados,
    c.capacidad_maxima,
    (c.capacidad_maxima - c.alumnos_matriculados) AS plazas_disponibles,
    ROUND((c.alumnos_matriculados / c.capacidad_maxima * 100), 2) AS porcentaje_ocupacion
FROM cursos c
INNER JOIN familias_profesionales fp ON c.id_familia = fp.id_familia
ORDER BY fp.nombre_familia, c.nivel;

-- Mensaje final
SELECT 'Base de datos inicializada correctamente' AS estado,
       (SELECT COUNT(*) FROM familias_profesionales) AS familias_creadas,
       (SELECT COUNT(*) FROM cursos) AS cursos_creados,
       (SELECT COUNT(*) FROM alumnos) AS alumnos_ejemplo,
       (SELECT SUM(alumnos_matriculados) FROM cursos) AS total_matriculados;