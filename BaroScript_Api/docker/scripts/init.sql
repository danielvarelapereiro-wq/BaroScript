-- Creación de la base de datos
CREATE DATABASE IF NOT EXISTS bs_db_api;
USE bs_db_api;

-- ============================================================
--  TABLAS REGISTRO USUARIO
-- ============================================================

CREATE TABLE IF NOT EXISTS roles (
    rol_id      INT PRIMARY KEY AUTO_INCREMENT,
    nombre      VARCHAR(20) NOT NULL UNIQUE,
    descripcion TEXT
);

CREATE TABLE IF NOT EXISTS usuarios (
    usuario_id      INT PRIMARY KEY AUTO_INCREMENT,
    user_name        VARCHAR(50)  NOT NULL UNIQUE,
    email           VARCHAR(100) NOT NULL UNIQUE,
    password_hash   VARCHAR(255) NOT NULL,
    rol_id          INT NOT NULL,
    fecha_registro  DATETIME DEFAULT NOW(),
    activo          BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (rol_id) REFERENCES roles(rol_id)
);

-- ============================================================
--  TABLA REGISTRO BUCEADORES
-- ============================================================

CREATE TABLE IF NOT EXISTS buceadores (
    buceador_id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id  INT NOT NULL,
    nombre      VARCHAR(100) NOT NULL,
    apellidos   VARCHAR(100) NOT NULL,
    titulacion  VARCHAR(100),
    created_at  DATETIME DEFAULT NOW(),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id) ON DELETE CASCADE
);

-- ============================================================
--  HOJAS DE INMERSION
-- ============================================================

CREATE TABLE IF NOT EXISTS hojas_inmersion (
    hoja_id               INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id            INT NOT NULL,
    fecha                 DATE NOT NULL,
    lugar                 VARCHAR(200),
    empresa               VARCHAR(100),
    finalidad             TEXT,
    profundidad_max       DECIMAL(3,1) NOT NULL,
    tiempo_fondo          INT NOT NULL,
    mezcla_descompresion  VARCHAR(20) NOT NULL DEFAULT 'AIRE',
    altura_inmersion      DECIMAL(7,1) DEFAULT 0,
    t_primera_parada      VARCHAR(10),
    profundidad_teorica   DECIMAL(5,1),
    parada_39 INT, parada_36 INT, parada_33 INT,
    parada_30 INT, parada_27 INT, parada_24 INT, parada_21 INT,
    parada_18 INT, parada_15 INT, parada_12 INT, parada_9  INT, parada_6  INT,
    tiempo_total_ascenso  VARCHAR(10),
    periodos_o2_camara    DECIMAL(4,1),
    grupo_inmersion       VARCHAR(1),
    es_inmersion_sucesiva BOOLEAN DEFAULT FALSE,
    created_at            DATETIME DEFAULT NOW(),
    synced_at             DATETIME,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id) ON DELETE CASCADE
);

-- ============================================================
--  REGISTRO DE INMERSION Y BUCEADOR
-- ============================================================

CREATE TABLE IF NOT EXISTS inmersion_buceadores (
    id           INT PRIMARY KEY AUTO_INCREMENT,
    hoja_id      INT NOT NULL,
    buceador_id  INT NOT NULL,
    es_jefe_equipo BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (hoja_id)     REFERENCES hojas_inmersion(hoja_id) ON DELETE CASCADE,
    FOREIGN KEY (buceador_id) REFERENCES buceadores(buceador_id)
);

-- ============================================================
--  CONTROL DE VERSIÓN DE TABLAS
-- ============================================================

CREATE TABLE IF NOT EXISTS tabla_versiones (
    version_id          INT PRIMARY KEY AUTO_INCREMENT,
    ultima_modificacion DATETIME NOT NULL DEFAULT NOW(),
    version_tag         VARCHAR(20) NOT NULL,
    descripcion         TEXT
);

-- ============================================================
--  TABLAS DE BUCEO
-- ============================================================
-- ============================================================
--  TABLA I - Tiempos límites sin descompresión y Grupos IS
-- ============================================================

CREATE TABLE IF NOT EXISTS tabla_I (
    tabla1_id            INT PRIMARY KEY AUTO_INCREMENT,
    profundidad          DECIMAL(3,1) NOT NULL,
    tiempo_limite_sin_deco INT,
    es_ilimitado         BOOLEAN DEFAULT FALSE,
    grupo_A INT, grupo_B INT, grupo_C INT, grupo_D INT,
    grupo_E INT, grupo_F INT, grupo_G INT, grupo_H INT,
    grupo_I INT, grupo_J INT, grupo_K INT, grupo_L INT,
    grupo_M INT, grupo_N INT, grupo_O INT, grupo_Z INT,
    UNIQUE KEY uq_tabla1_prof (profundidad)
);

-- ============================================================
--  TABLA II - Tiempos de Nitrógeno Residual
--  DOS TABLAS, TABLA II_IS Y TABLA_II_TNR;
--
--  TABLA_II_IS - Grupo inmersion previa, tiempo superficie y nuevo grupo de inmersion
--  TABLA_II_TNE - Nuevo grupo inmersion, tiempo tnr equivalente, profundidad inmersion sucesiva
-- ============================================================

CREATE TABLE IF NOT EXISTS tabla_II_is (
    tabla2is_id           INT PRIMARY KEY AUTO_INCREMENT,
    grupo_is_inicial      VARCHAR(1) NOT NULL COMMENT 'Grupo inmersion previa',
    intervalo_min_min     INT        NOT NULL COMMENT 'Inicio rango superficie (min)',
    intervalo_max_min     INT                 COMMENT 'Fin rango',
    grupo_is_final        VARCHAR(1) NOT NULL COMMENT 'Grupo final tras intervalo superficie',
    UNIQUE KEY uq_tabla2is (grupo_is_inicial, intervalo_min_min)
);

CREATE TABLE IF NOT EXISTS tabla_II_tnr (
    tabla2tnr_id          INT PRIMARY KEY AUTO_INCREMENT,
    grupo_is_final        VARCHAR(1)   NOT NULL COMMENT 'Grupo Tabla_II_is',
    profundidad_sucesiva  DECIMAL(3,1) NOT NULL COMMENT 'Profundidad inmersion sucesiva',
    tnr_minutos           INT          NOT NULL COMMENT 'TNR (min)',
    UNIQUE KEY uq_tabla2tnr (grupo_is_final, profundidad_sucesiva)
);

-- ============================================================
--  TABLA III — Descompresión con Aire
-- ============================================================

CREATE TABLE IF NOT EXISTS tabla_III (
    tabla3_id            INT PRIMARY KEY AUTO_INCREMENT,
    profundidad          DECIMAL(3,1) NOT NULL,
    tiempo_fondo         INT NOT NULL,
    t_primera_parada     VARCHAR(10) NOT NULL,
    mezcla               VARCHAR(10) NOT NULL COMMENT 'AIRE o AIRE_O2',
    d_30 INT, d_27 INT, d_24 INT, d_21 INT,
    d_18 INT, d_15 INT, d_12 INT, d_9  INT, d_6  INT,
    tiempo_total_ascenso VARCHAR(10) NOT NULL,
    periodos_o2_camara   DECIMAL(4,1),
    grupo_inmersion      VARCHAR(1),
    recomendada_dec_o2_dso2  BOOLEAN DEFAULT FALSE COMMENT 'Recomendada DECO AIRE/O2 en el agua o DSO2 ',
    excep_requi_dec_o2_dso2    BOOLEAN DEFAULT FALSE COMMENT 'Exposición Excepcional, Requiere DECO AIRE/O2 en el agua o DSO2',
    excep_requi_dec_dso2  BOOLEAN DEFAULT FALSE COMMENT 'Exposición Excepcional, Requiere DSO2 ',
    UNIQUE KEY uq_tabla3 (profundidad, tiempo_fondo, mezcla)
);

-- ============================================================
--  TABLA III — Inmersiones Excepcionales (60-90 mca)
-- ============================================================

CREATE TABLE IF NOT EXISTS tabla_III_excep (
    tabla3_excep_id      INT PRIMARY KEY AUTO_INCREMENT,
    profundidad          DECIMAL(3,1) NOT NULL,
    tiempo_fondo         INT NOT NULL,
    t_primera_parada     VARCHAR(10) NOT NULL,
    mezcla               VARCHAR(10) NOT NULL COMMENT 'AIRE o AIRE_O2',
    d_39 INT, d_36 INT, d_33 INT,
    d_30 INT, d_27 INT, d_24 INT, d_21 INT,
    d_18 INT, d_15 INT, d_12 INT, d_9  INT, d_6  INT,
    tiempo_total_ascenso VARCHAR(10) NOT NULL,
    periodos_o2_camara   DECIMAL(4,1),
    grupo_inmersion      VARCHAR(1),
    UNIQUE KEY uq_tabla3_excep (profundidad, tiempo_fondo, mezcla)
);

-- ============================================================
--  TABLA IV
--  Dos tablas, TABLA II_IS Y TABLA_II_TNR;
--
--  TABLA_IV_profundidad - Calculo de la profundidad de inmersion teorica por altitud
--  TABLA_IV_paradas - Calculo de la profundidad de paradas teorica por altitud
-- ===========================================================


CREATE TABLE IF NOT EXISTS tabla_IV_profundidad (
    tabla4i_id          INT PRIMARY KEY AUTO_INCREMENT,
    profundidad_real    DECIMAL(3,1) NOT NULL,
    altitud_m           INT NOT NULL,
    profundidad_teorica DECIMAL(3,1) NOT NULL COMMENT 'Profundiad teorica a usar',
    UNIQUE KEY uq_tabla4i (profundidad_real, altitud_m)
);

CREATE TABLE IF NOT EXISTS tabla_IV_paradas (
    tabla4p_id                 INT PRIMARY KEY AUTO_INCREMENT,
    profundidad_teorica_parada DECIMAL(3,1) NOT NULL,
    altitud_m                  INT NOT NULL,
    profundidad_real_parada    DECIMAL(3,1) NOT NULL,
    UNIQUE KEY uq_tabla4p (profundidad_teorica_parada, altitud_m)
);

-- ============================================================
--  TABLA V - Grupos de IS correspondientes al ascenso inicial aaltitud
-- ============================================================

CREATE TABLE IF NOT EXISTS tabla_V (
    tabla5_id    INT PRIMARY KEY AUTO_INCREMENT,
    altitud_m    INT NOT NULL,
    altitud_pies INT,
    grupo_is     VARCHAR(1) NOT NULL,
    UNIQUE KEY uq_tabla5 (altitud_m)
);

-- ============================================================
--  TABLA VI - Intervalo en Superficie exigido antes de ascender
--  a altitud después de bucear
-- ============================================================

CREATE TABLE IF NOT EXISTS tabla_VI (
    tabla6_id            INT PRIMARY KEY AUTO_INCREMENT,
    grupo_is             VARCHAR(1)  NOT NULL,
    aumento_altitud_m    INT         NOT NULL,
    intervalo_requerido  VARCHAR(10) NOT NULL,
    UNIQUE KEY uq_tabla6 (grupo_is, aumento_altitud_m)
);

-- ============================================================
--  TABLA VII - Tiempos límite sin descompresión y Grupos de Inmersión sucesiva
--              para inmersiones con aire en aguas poco profundas
-- ============================================================

CREATE TABLE IF NOT EXISTS tabla_VII (
    tabla7_id            INT PRIMARY KEY AUTO_INCREMENT,
    profundidad          DECIMAL(3,1) NOT NULL,
    tiempo_limite_nodeco INT NOT NULL,
    grupo_A INT, grupo_B INT, grupo_C INT, grupo_D INT,
    grupo_E INT, grupo_F INT, grupo_G INT, grupo_H INT,
    grupo_I INT, grupo_J INT, grupo_K INT, grupo_L INT,
    grupo_M INT, grupo_N INT, grupo_O INT, grupo_Z INT,
    UNIQUE KEY uq_tabla7_prof (profundidad)
);

-- ============================================================
--  INSERTS ROLES y VERSION INICIAL TABLAS
-- ============================================================

-- ROLES
INSERT INTO roles (nombre, descripcion) VALUES
('ADMIN',        'Acceso total sin restricciones'),
('USER',         'Usuario básico: 1 inmersión/día, 1 tabulación/día'),
('USER_PREMIUM', 'Sin límites diarios'),
('TEST',         'Acceso premium para pruebas del proyecto');

-- VERSIÓN INICIAL DE TABLAS
INSERT INTO tabla_versiones (ultima_modificacion, version_tag, descripcion) VALUES
(NOW(), '1.0.0', 'Carga inicial de tablas de buceo profesional D-BC-01');


-- ============================================================
--  TABLA I
-- ============================================================

INSERT INTO tabla_I (profundidad, tiempo_limite_sin_deco, es_ilimitado, grupo_A, grupo_B, grupo_C, grupo_D, grupo_E,
                    grupo_F, grupo_G, grupo_H, grupo_I, grupo_J, grupo_K, grupo_L, grupo_M, grupo_N, grupo_O, grupo_Z) VALUES
(3,    NULL,  TRUE,    57,   101, 158, 245,  426, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(4.5,  NULL,  TRUE,    36,    60,  88, 121,  163,  217,  297,  449, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(6,    NULL,  TRUE,    26,    43,  61,  82,  106,  133,  165,  205,  256,  330,  461, NULL, NULL, NULL, NULL, NULL),
(7.5,  1102, FALSE,    20,    33,  47,  62,   78,   97,  117,  140,  166,  198,  236,  285,  354,  469,  992, 1102),
(9,     371,  FALSE,   17,    27,  38,  50,   62,   76,   91,  107,  125,  145,  167,  193,  223,  260,  307,  371),
(10.5,  232,  FALSE,   14,    23,  32,  42,   52,   63,   74,   87,  100,  115,  131,  148,  168,  190,  215,  232),
(12,    163,  FALSE,   12,    20,  27,  36,   44,   53,   63,   73,   84,   95,  108,  121,  135,  151,  163, NULL),
(13.5,  125,  FALSE,   11,    17,  24,  31,   39,   46,   55,   63,   72,   82,   92,  102,  114,  125, NULL, NULL),
(15,     92,  FALSE,    9,    15,  21,  28,   34,   41,   48,   56,   63,   71,   80,   89,   92, NULL, NULL, NULL),
(16.5,   74,  FALSE,    8,    14,  19,  25,   31,   37,   43,   50,   56,   63,   71,   74, NULL, NULL, NULL, NULL),
(18,     63,  FALSE,    7,    12,  17,  22,   28,   33,   39,   45,   51,   57,   63, NULL, NULL, NULL, NULL, NULL),
(21,     48,  FALSE,    6,    10,  14,  19,   23,   28,   32,   37,   42,   47,   48, NULL, NULL, NULL, NULL, NULL),
(24,     39,  FALSE,    5,     9,  12,  16,   20,   24,   28,   32,   36,   39, NULL, NULL, NULL, NULL, NULL, NULL),
(27,     33,  FALSE,    4,     7,  11,  14,   17,   21,   24,   28,   31,   33, NULL, NULL, NULL, NULL, NULL, NULL),
(30,     25,  FALSE,    4,     6,   9,  12,   15,   18,   21,   25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(33,     20,  FALSE,    3,     6,   8,  11,   14,   16,   19,   20, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(36,     15,  FALSE,    3,     5,   7,  10,   12,   15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(39,     12,  FALSE,    2,     4,   6,   9,   11,   12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(42,     10,  FALSE,    2,     4,   6,   8,   10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(45,      8,  FALSE, NULL,     3,   5,   7,    8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(48,      7,  FALSE, NULL,     3,   5,   6,    7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(51,      6,  FALSE, NULL,  NULL,   4,   6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(54,      6,  FALSE, NULL,  NULL,   4,   5,    6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(57,      5,  FALSE, NULL,  NULL,   3,   5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- ============================================================
--  TABLAS II - Tiempos de Nitrógeno Residual (TNR) para inmersiones sucesivas
--              con aire
-- ============================================================
-- ============================================================
--  TABLA II - TABLA_II_IS -
-- ============================================================
INSERT INTO tabla_II_is (grupo_is_inicial, intervalo_min_min, intervalo_max_min, grupo_is_final) VALUES
-- Grupo Z inicial
('Z', 10 , 52 , 'Z'),
('Z', 53 , 104, 'O'),
('Z', 105, 157, 'N'),
('Z', 158, 209, 'M'),
('Z', 210, 261, 'L'),
('Z', 262, 313, 'K'),
('Z', 314, 366, 'J'),
('Z', 367, 418, 'I'),
('Z', 419, 470, 'H'),
('Z', 471, 522, 'G'),
('Z', 523, 574, 'F'),
('Z', 575, 627, 'E'),
('Z', 628, 679, 'D'),
('Z', 680, 733, 'C'),
('Z', 734, 810, 'B'),
('Z', 811, 950, 'A'),

-- Grupo O inicial
('O', 10 , 52 , 'O'),
('O', 53 , 104, 'N'),
('O', 105, 157, 'M'),
('O', 158, 209, 'L'),
('O', 210, 261, 'K'),
('O', 262, 313, 'J'),
('O', 314, 366, 'I'),
('O', 367, 418, 'H'),
('O', 419, 470, 'G'),
('O', 471, 522, 'F'),
('O', 523, 574, 'E'),
('O', 575, 627, 'D'),
('O', 628, 681, 'C'),
('O', 682, 757, 'B'),
('O', 758, 898, 'A'),

-- Grupo N inicial
('N', 10 , 52 , 'N'),
('N', 53 , 104, 'M'),
('N', 105, 157, 'L'),
('N', 158, 209, 'K'),
('N', 210, 261, 'J'),
('N', 262, 313, 'I'),
('N', 314, 366, 'H'),
('N', 367, 418, 'G'),
('N', 419, 470, 'F'),
('N', 471, 522, 'E'),
('N', 523, 574, 'D'),
('N', 575, 629, 'C'),
('N', 630, 715, 'B'),
('N', 716, 845, 'A'),

-- Grupo M inicial
('M', 10 , 52 , 'M'),
('M', 53 , 104, 'L'),
('M', 105, 157, 'K'),
('M', 158, 209, 'J'),
('M', 210, 261, 'I'),
('M', 262, 313, 'H'),
('M', 314, 366, 'G'),
('M', 367, 418, 'F'),
('M', 419, 470, 'E'),
('M', 471, 522, 'D'),
('M', 523, 577, 'C'),
('M', 578, 653, 'B'),
('M', 654, 793, 'A'),

-- Grupo L inicial
('L', 10 , 52 , 'L'),
('L', 53 , 104, 'K'),
('L', 105, 157, 'J'),
('L', 158, 209, 'I'),
('L', 210, 261, 'H'),
('L', 262, 313, 'G'),
('L', 314, 366, 'F'),
('L', 367, 418, 'E'),
('L', 419, 470, 'D'),
('L', 471, 524, 'C'),
('L', 525, 601, 'B'),
('L', 602, 741, 'A'),

-- Grupo K inicial
('K', 10 , 52 , 'K'),
('K', 53 , 104, 'J'),
('K', 105, 157, 'I'),
('K', 158, 209, 'H'),
('K', 210, 261, 'G'),
('K', 262, 313, 'F'),
('K', 314, 366, 'E'),
('K', 367, 418, 'D'),
('K', 419, 472, 'C'),
('K', 473, 549, 'B'),
('K', 550, 689, 'A'),

-- Grupo J inicial
('J', 10 , 52 , 'J'),
('J', 53 , 104, 'I'),
('J', 105, 157, 'H'),
('J', 158, 209, 'G'),
('J', 210, 261, 'F'),
('J', 262, 313, 'E'),
('J', 314, 366, 'D'),
('J', 367, 420, 'C'),
('J', 421, 496, 'B'),
('J', 497, 636, 'A'),

-- Grupo I inicial
('I', 10 , 52 , 'I'),
('I', 53 , 104, 'H'),
('I', 105, 157, 'G'),
('I', 158, 209, 'F'),
('I', 210, 261, 'E'),
('I', 262, 313, 'D'),
('I', 314, 368, 'C'),
('I', 369, 444, 'B'),
('I', 445, 588, 'A'),

-- Grupo H inicial
('H', 10 , 52 , 'H'),
('H', 53 , 104, 'G'),
('H', 105, 157, 'F'),
('H', 158, 209, 'E'),
('H', 210, 261, 'D'),
('H', 262, 316, 'C'),
('H', 317, 392, 'B'),
('H', 393, 532, 'A'),

-- Grupo G inicial
('G', 10 , 52 , 'G'),
('G', 53 , 104, 'F'),
('G', 105, 157, 'E'),
('G', 158, 209, 'D'),
('G', 210, 263, 'C'),
('G', 264, 340, 'B'),
('G', 341, 480, 'A'),

-- Grupo F inicial
('F', 10 , 52 , 'F'),
('F', 53 , 104, 'E'),
('F', 105, 157, 'D'),
('F', 158, 211, 'C'),
('F', 212, 288, 'B'),
('F', 289, 428, 'A'),

-- Grupo E inicial
('E', 10 , 52 , 'E'),
('E', 53 , 104, 'D'),
('E', 105, 159, 'C'),
('E', 160, 235, 'B'),
('E', 236, 375, 'A'),

-- Grupo D inicial
('D', 10 , 52 , 'D'),
('D', 53 , 107, 'C'),
('D', 108, 183, 'B'),
('D', 184, 323, 'A'),

-- Grupo C inicial
('C', 10 , 55 , 'C'),
('C', 56 , 191, 'B'),
('C', 192, 271, 'A'),

-- Grupo B inicial
('B', 10, 76 , 'B'),
('B', 77, 216, 'A'),

-- Grupo A inicial
('A', 10,  140, 'A');

-- ============================================================
--  TABLA II - TABLA_II_TNR -
-- ============================================================
INSERT INTO tabla_II_tnr (grupo_is_final, profundidad_sucesiva, tnr_minutos) VALUES
-- profundidad 7.5 mca († leer como 9 mca según nota del PDF)
('Z',7.5,470),('O',7.5,354),('N',7.5,286),('M',7.5,237),('L',7.5,198),
('K',7.5,168),('J',7.5,146),('I',7.5,126),('H',7.5,108),('G',7.5,92),
('F',7.5,77), ('E',7.5,63), ('D',7.5,51), ('C',7.5,39), ('B',7.5,28),('A',7.5,18),

-- profundidad 9 mca
('Z',9,372),('O',9,308),('N',9,261),('M',9,224),('L',9,194),
('K',9,168),('J',9,146),('I',9,126),('H',9,108),('G',9,92),
('F',9,77), ('E',9,63), ('D',9,51), ('C',9,39), ('B',9,28),('A',9,18),

-- profundidad 10.5 mca
('Z',10.5,245),('O',10.5,216),('N',10.5,191),('M',10.5,169),('L',10.5,149),
('K',10.5,132),('J',10.5,116),('I',10.5,101),('H',10.5,88),('G',10.5,75),
('F',10.5,64),('E',10.5,53),('D',10.5,43),('C',10.5,33),('B',10.5,24),('A',10.5,15),

-- profundidad 12 mca
('Z',12,188),('O',12,169),('N',12,152),('M',12,136),('L',12,122),
('K',12,109),('J',12,97),('I',12,85),('H',12,74),('G',12,64),
('F',12,55),('E',12,45),('D',12,37),('C',12,29),('B',12,21),('A',12,13),

-- profundidad 13.5 mca
('Z',13.5,154),('O',13.5,140),('N',13.5,127),('M',13.5,115),('L',13.5,104),
('K',13.5,93),('J',13.5,83),('I',13.5,73),('H',13.5,64),('G',13.5,56),
('F',13.5,48),('E',13.5,40),('D',13.5,32),('C',13.5,25),('B',13.5,18),('A',13.5,12),

-- profundidad 15 mca
('Z',15,131),('O',15,120),('N',15,109),('M',15,99),('L',15,90),
('K',15,81),('J',15,73),('I',15,65),('H',15,57),('G',15,49),
('F',15,42),('E',15,35),('D',15,29),('C',15,23),('B',15,17),('A',15,11),

-- profundidad 16.5 mca
('Z',16.5,114),('O',16.5,105),('N',16.5,96),('M',16.5,88),('L',16.5,80),
('K',16.5,72),('J',16.5,65),('I',16.5,58),('H',16.5,51),('G',16.5,44),
('F',16.5,38),('E',16.5,32),('D',16.5,26),('C',16.5,20),('B',16.5,15),('A',16.5,10),

-- profundidad 18 mca
('Z',18,101),('O',18,93),('N',18,86),('M',18,79),('L',18,72),
('K',18,65),('J',18,58),('I',18,52),('H',18,46),('G',18,40),
('F',18,35),('E',18,29),('D',18,24),('C',18,19),('B',18,14),('A',18,9),

-- profundidad 21 mca
('Z',21,83),('O',21,77),('N',21,71),('M',21,65),('L',21,59),
('K',21,54),('J',21,49),('I',21,44),('H',21,39),('G',21,34),
('F',21,29),('E',21,25),('D',21,20),('C',21,16),('B',21,12),('A',21,8),

-- profundidad 24 mca
('Z',24,70),('O',24,65),('N',24,60),('M',24,55),('L',24,51),
('K',24,46),('J',24,42),('I',24,38),('H',24,33),('G',24,29),
('F',24,25),('E',24,22),('D',24,18),('C',24,14),('B',24,10),('A',24,7),

-- profundidad 27 mca
('Z',27,61),('O',27,57),('N',27,52),('M',27,48),('L',27,44),
('K',27,41),('J',27,37),('I',27,33),('H',27,29),('G',27,26),
('F',27,22),('E',27,19),('D',27,16),('C',27,12),('B',27,9),('A',27,6),

-- profundidad 30 mca
('Z',30,54),('O',30,50),('N',30,47),('M',30,43),('L',30,40),
('K',30,36),('J',30,33),('I',30,30),('H',30,26),('G',30,23),
('F',30,20),('E',30,17),('D',30,14),('C',30,11),('B',30,8),('A',30,5),

-- profundidad 33 mca
('Z',33,48),('O',33,45),('N',33,42),('M',33,39),('L',33,35),
('K',33,32),('J',33,30),('I',33,27),('H',33,24),('G',33,21),
('F',33,18),('E',33,16),('D',33,13),('C',33,10),('B',33,8),('A',33,5),

-- profundidad 36 mca
('Z',36,44),('O',36,41),('N',36,38),('M',36,35),('L',36,32),
('K',36,30),('J',36,27),('I',36,24),('H',36,22),('G',36,19),
('F',36,17),('E',36,14),('D',36,12),('C',36,9),('B',36,7),('A',36,5),

-- profundidad 39 mca
('Z',39,40),('O',39,37),('N',39,35),('M',39,32),('L',39,30),
('K',39,27),('J',39,25),('I',39,22),('H',39,20),('G',39,18),
('F',39,15),('E',39,13),('D',39,11),('C',39,9),('B',39,6),('A',39,4),

-- profundidad 42 mca
('Z',42,37),('O',42,34),('N',42,32),('M',42,30),('L',42,27),
('K',42,25),('J',42,23),('I',42,21),('H',42,19),('G',42,16),
('F',42,14),('E',42,12),('D',42,10),('C',42,8),('B',42,6),('A',42,4),

-- profundidad 45 mca
('Z',45,34),('O',45,32),('N',45,30),('M',45,28),('L',45,26),
('K',45,23),('J',45,21),('I',45,19),('H',45,17),('G',45,15),
('F',45,13),('E',45,11),('D',45,9),('C',45,8),('B',45,6),('A',45,4),

-- profundidad 48 mca
('Z',48,32),('O',48,30),('N',48,28),('M',48,26),('L',48,24),
('K',48,22),('J',48,20),('I',48,18),('H',48,16),('G',48,14),
('F',48,13),('E',48,11),('D',48,9),('C',48,7),('B',48,5),('A',48,4),

-- profundidad 51 mca
('Z',51,30),('O',51,28),('N',51,26),('M',51,24),('L',51,22),
('K',51,21),('J',51,19),('I',51,17),('H',51,15),('G',51,14),
('F',51,12),('E',51,10),('D',51,8),('C',51,7),('B',51,5),('A',51,3),

-- profundidad 54 mca
('Z',54,28),('O',54,26),('N',54,25),('M',54,23),('L',54,21),
('K',54,19),('J',54,18),('I',54,16),('H',54,14),('G',54,13),
('F',54,11),('E',54,10),('D',54,8),('C',54,6),('B',54,5),('A',54,3),

-- profundidad 57 mca
('Z',57,26),('O',57,25),('N',57,23),('M',57,22),('L',57,20),
('K',57,18),('J',57,17),('I',57,15),('H',57,14),('G',57,12),
('F',57,11),('E',57,9),('D',57,8),('C',57,6),('B',57,5),('A',57,3);

-- ============================================================
--  TABLA III —
-- ============================================================
INSERT INTO tabla_III (profundidad, tiempo_fondo, t_primera_parada, mezcla,
                        d_30, d_27, d_24, d_21, d_18, d_15, d_12, d_9, d_6,
                        tiempo_total_ascenso, periodos_o2_camara, grupo_inmersion, recomendada_dec_o2_dso2,
                        excep_requi_dec_o2_dso2, excep_requi_dec_dso2) VALUES
-- profundidad 9 mca
(9,371,'1:00','AIRE'   , NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0  ,'1:00'  ,0   ,'Z' ,FALSE,FALSE,FALSE),
(9,371,'1:00','AIRE_O2', NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0  ,'1:00'  ,NULL,'Z' ,FALSE,FALSE,FALSE),
(9,380,'0:20','AIRE'   , NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5  ,'6:00'  ,0.5 ,'Z' ,FALSE,FALSE,FALSE),
(9,380,'0:20','AIRE_O2', NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1  ,'2:00'  ,NULL,'Z' ,FALSE,FALSE,FALSE),
(9,420,'0:20','AIRE'   , NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,22 ,'23:00' ,0.5 ,'Z' ,TRUE,FALSE,FALSE),
(9,420,'0:20','AIRE_O2', NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5  ,'6:00'  ,NULL,'Z' ,TRUE,FALSE,FALSE),
(9,480,'0:20','AIRE'   , NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,42 ,'43:00' ,0.5 ,NULL,TRUE,FALSE,FALSE),
(9,480,'0:20','AIRE_O2', NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,9  ,'10:00' ,NULL,NULL,TRUE,FALSE,FALSE),
(9,540,'0:20','AIRE'   , NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,71 ,'72:00' ,1   ,NULL,TRUE,FALSE,FALSE),
(9,540,'0:20','AIRE_O2', NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,14 ,'15:00' ,NULL,NULL,TRUE,FALSE,FALSE),
(9,600,'0:20','AIRE'   , NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,92 ,'93:00' ,1   ,NULL,FALSE,TRUE,FALSE),
(9,600,'0:20','AIRE_O2', NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,19 ,'20:00' ,NULL,NULL,FALSE,TRUE,FALSE),
(9,660,'0:20','AIRE'   , NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,120,'121:00',1   ,NULL,FALSE,TRUE,FALSE),
(9,660,'0:20','AIRE_O2', NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,22 ,'23:00' ,NULL,NULL,FALSE,TRUE,FALSE),
(9,720,'0:20','AIRE'   , NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,158,'159:00',1   ,NULL,FALSE,TRUE,FALSE),
(9,720,'0:20','AIRE_O2', NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,27 ,'28:00' ,NULL,NULL,FALSE,TRUE,FALSE),

-- profundidad 10.5 mca
(10.5,232,'1:10','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'1:10',0,'Z',FALSE,FALSE,FALSE),
(10.5,232,'1:10','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'1:10',NULL,'Z',FALSE,FALSE,FALSE),
(10.5,240,'0:30','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,4,'5:10',0.5,'Z',FALSE,FALSE,FALSE),
(10.5,240,'0:30','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,'3:10',NULL,'Z',FALSE,FALSE,FALSE),
(10.5,270,'0:30','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,28,'29:10',0.5,'Z',TRUE,FALSE,FALSE),
(10.5,270,'0:30','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,7,'8:10',NULL,'Z',TRUE,FALSE,FALSE),
(10.5,300,'0:30','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,53,'54:10',0.5,'Z',TRUE,FALSE,FALSE),
(10.5,300,'0:30','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,13,'14:10',NULL,'Z',TRUE,FALSE,FALSE),
(10.5,330,'0:30','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,71,'72:10',1,'Z',TRUE,FALSE,FALSE),
(10.5,330,'0:30','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,18,'19:10',NULL,'Z',TRUE,FALSE,FALSE),
(10.5,360,'0:30','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,88,'89:10',1,NULL,TRUE,FALSE,FALSE),
(10.5,360,'0:30','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,22,'23:10',NULL,NULL,FALSE,TRUE,FALSE),
(10.5,420,'0:30','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,134,'135:10',1.5,NULL,FALSE,TRUE,FALSE),
(10.5,420,'0:30','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,29,'30:10',NULL,NULL,FALSE,TRUE,FALSE),
(10.5,480,'0:30','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,173,'174:10',1.5,NULL,FALSE,TRUE,FALSE),
(10.5,480,'0:30','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,38,'44:10',NULL,NULL,FALSE,TRUE,FALSE),
(10.5,540,'0:30','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,228,'229:10',2,NULL,FALSE,TRUE,FALSE),
(10.5,540,'0:30','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,45,'51:10',NULL,NULL,FALSE,TRUE,FALSE),
(10.5,600,'0:30','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,277,'278:10',2,NULL,FALSE,TRUE,FALSE),
(10.5,600,'0:30','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,53,'59:10',NULL,NULL,FALSE,TRUE,FALSE),
(10.5,660,'0:30','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,314,'315:10',2.5,NULL,FALSE,TRUE,FALSE),
(10.5,660,'0:30','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,63,'69:10',NULL,NULL,FALSE,TRUE,FALSE),
(10.5,720,'0:30','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,342,'343:10',3,NULL,FALSE,TRUE,FALSE),
(10.5,720,'0:30','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,71,'82:10',NULL,NULL,FALSE,TRUE,FALSE),

-- profundidad 12 mca
(12,163,'1:20','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'1:20',0,'O',FALSE,FALSE,FALSE),
(12,163,'1:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'1:20',NULL,'O',FALSE,FALSE,FALSE),
(12,170,'0:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,6,'7:20',0.5,'O',FALSE,FALSE,FALSE),
(12,170,'0:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,'3:20',NULL,'O',FALSE,FALSE,FALSE),
(12,180,'0:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,14,'15:20',0.5,'Z',FALSE,FALSE,FALSE),
(12,180,'0:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5,'6:20',NULL,'Z',FALSE,FALSE,FALSE),
(12,190,'0:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,21,'22:20',0.5,'Z',TRUE,FALSE,FALSE),
(12,190,'0:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,7,'8:20',NULL,'Z',TRUE,FALSE,FALSE),
(12,200,'0:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,27,'28:20',0.5,'Z',TRUE,FALSE,FALSE),
(12,200,'0:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,9,'10:20',NULL,'Z',TRUE,FALSE,FALSE),
(12,210,'0:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,39,'40:20',0.5,'Z',TRUE,FALSE,FALSE),
(12,210,'0:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,11,'12:20',NULL,'Z',TRUE,FALSE,FALSE),
(12,220,'0:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,52,'53:20',0.5,'Z',TRUE,FALSE,FALSE),
(12,220,'0:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,12,'13:20',NULL,'Z',TRUE,FALSE,FALSE),
(12,230,'0:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,64,'65:20',1,'Z',TRUE,FALSE,FALSE),
(12,230,'0:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,16,'17:20',NULL,'Z',TRUE,FALSE,FALSE),
(12,240,'0:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,75,'76:20',1,'Z',TRUE,FALSE,FALSE),
(12,240,'0:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,19,'20:20',NULL,'Z',TRUE,FALSE,FALSE),
(12,270,'0:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,101,'102:20',1,'Z',FALSE,TRUE,FALSE),
(12,270,'0:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,26,'27:20',NULL,'Z',FALSE,TRUE,FALSE),
(12,300,'0:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,128,'129:20',1.5,NULL,FALSE,TRUE,FALSE),
(12,300,'0:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,33,'34:20',NULL,NULL,FALSE,TRUE,FALSE),
(12,330,'0:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,160,'161:20',1.5,NULL,FALSE,TRUE,FALSE),
(12,330,'0:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,38,'44:20',NULL,NULL,FALSE,TRUE,FALSE),
(12,360,'0:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,184,'185:20',2,NULL,FALSE,TRUE,FALSE),
(12,360,'0:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,44,'50:20',NULL,NULL,FALSE,TRUE,FALSE),
(12,420,'0:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,248,'249:20',2.5,NULL,FALSE,TRUE,FALSE),
(12,420,'0:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,56,'62:20',NULL,NULL,FALSE,TRUE,FALSE),
(12,480,'0:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,321,'322:20',2.5,NULL,FALSE,TRUE,FALSE),
(12,480,'0:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,68,'79:20',NULL,NULL,FALSE,TRUE,FALSE),
(12,540,'0:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,372,'373:20',3,NULL,FALSE,FALSE,TRUE),
(12,540,'0:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,80,'91:20',NULL,NULL,FALSE,FALSE,TRUE),
(12,600,'0:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,410,'411:20',3.5,NULL,FALSE,FALSE,TRUE),
(12,600,'0:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,93,'104:20',NULL,NULL,FALSE,FALSE,TRUE),
(12,660,'0:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,439,'440:20',4,NULL,FALSE,FALSE,TRUE),
(12,660,'0:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,103,'119:20',NULL,NULL,FALSE,FALSE,TRUE),
(12,720,'0:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,461,'462:20',4.5,NULL,FALSE,FALSE,TRUE),
(12,720,'0:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,112,'128:20',NULL,NULL,FALSE,FALSE,TRUE),

-- profundidad 13.5 mca
(13.5,125,'1:30','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'1:30',0,'N',FALSE,FALSE,FALSE),
(13.5,125,'1:30','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'1:30',NULL,'N',FALSE,FALSE,FALSE),
(13.5,130,'0:50','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,'3:30',0.5,'O',FALSE,FALSE,FALSE),
(13.5,130,'0:50','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2:30',NULL,'O',FALSE,FALSE,FALSE),
(13.5,140,'0:50','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,14,'15:30',0.5,'O',FALSE,FALSE,FALSE),
(13.5,140,'0:50','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5,'6:30',NULL,'O',FALSE,FALSE,FALSE),
(13.5,150,'0:50','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,25,'26:30',0.5,'Z',TRUE,FALSE,FALSE),
(13.5,150,'0:50','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,8,'9:30',NULL,'Z',TRUE,FALSE,FALSE),
(13.5,160,'0:50','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,34,'35:30',0.5,'Z',TRUE,FALSE,FALSE),
(13.5,160,'0:50','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,11,'12:30',NULL,'Z',TRUE,FALSE,FALSE),
(13.5,170,'0:50','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,41,'42:30',1,'Z',TRUE,FALSE,FALSE),
(13.5,170,'0:50','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,14,'15:30',NULL,'Z',TRUE,FALSE,FALSE),
(13.5,180,'0:50','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,59,'60:30',1,'Z',TRUE,FALSE,FALSE),
(13.5,180,'0:50','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,17,'18:30',NULL,'Z',TRUE,FALSE,FALSE),
(13.5,190,'0:50','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,75,'76:30',1,'Z',TRUE,FALSE,FALSE),
(13.5,190,'0:50','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,19,'20:30',NULL,'Z',TRUE,FALSE,FALSE),
(13.5,200,'0:50','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,89,'90:30',1,'Z',FALSE,TRUE,FALSE),
(13.5,200,'0:50','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,23,'24:30',NULL,'Z',FALSE,TRUE,FALSE),
(13.5,210,'0:50','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,101,'102:30',1,'Z',FALSE,TRUE,FALSE),
(13.5,210,'0:50','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,27,'28:30',NULL,'Z',FALSE,TRUE,FALSE),
(13.5,220,'0:50','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,112,'113:30',1.5,'Z',FALSE,TRUE,FALSE),
(13.5,220,'0:50','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,30,'31:30',NULL,'Z',FALSE,TRUE,FALSE),
(13.5,230,'0:50','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,121,'122:30',1.5,'Z',FALSE,TRUE,FALSE),
(13.5,230,'0:50','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,33,'34:30',NULL,'Z',FALSE,TRUE,FALSE),
(13.5,240,'0:50','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,130,'131:30',1.5,'Z',FALSE,TRUE,FALSE),
(13.5,240,'0:50','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,37,'43:30',NULL,'Z',FALSE,TRUE,FALSE),
(13.5,270,'0:50','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,173,'174:30',2,NULL,FALSE,TRUE,FALSE),
(13.5,270,'0:50','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,45,'51:30',NULL,NULL,FALSE,TRUE,FALSE),
(13.5,300,'0:50','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,206,'207:30',2,NULL,FALSE,TRUE,FALSE),
(13.5,300,'0:50','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,51,'57:30',NULL,NULL,FALSE,TRUE,FALSE),
(13.5,330,'0:50','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,243,'244:30',2.5,NULL,FALSE,TRUE,FALSE),
(13.5,330,'0:50','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,61,'67:30',NULL,NULL,FALSE,TRUE,FALSE),
(13.5,360,'0:50','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,288,'289:30',3,NULL,FALSE,TRUE,FALSE),
(13.5,360,'0:50','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,69,'80:30',NULL,NULL,FALSE,TRUE,FALSE),
(13.5,420,'0:50','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,373,'374:30',3.5,NULL,FALSE,FALSE,TRUE),
(13.5,420,'0:50','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,84,'95:30',NULL,NULL,FALSE,FALSE,TRUE),
(13.5,480,'0:50','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,431,'432:30',4,NULL,FALSE,FALSE,TRUE),
(13.5,480,'0:50','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,101,'117:30',NULL,NULL,FALSE,FALSE,TRUE),
(13.5,540,'0:50','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,473,'474:30',4.5,NULL,FALSE,FALSE,TRUE),
(13.5,540,'0:50','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,117,'133:30',NULL,NULL,FALSE,FALSE,TRUE),

-- profundidad 15 mca
(15,92,'1:40','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'1:40', 0,  'M',FALSE,FALSE,FALSE),
(15,92,'1:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'1:40',NULL,'M',FALSE,FALSE,FALSE),
(15,95,'1:00','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,'3:40', 0.5,'M',FALSE,FALSE,FALSE),
(15,95,'1:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2:40',NULL,'M',FALSE,FALSE,FALSE),
(15,100,'1:00','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,4,'5:40', 0.5,'N',FALSE,FALSE,FALSE),
(15,100,'1:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,'3:40',NULL,'N',FALSE,FALSE,FALSE),
(15,110,'1:00','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,8,'9:40', 0.5,'O',FALSE,FALSE,FALSE),
(15,110,'1:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,4,'5:40',NULL,'O',FALSE,FALSE,FALSE),
(15,120,'1:00','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,21,'22:40',0.5,'O',TRUE,FALSE,FALSE),
(15,120,'1:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,7,'8:40',NULL,'O',TRUE,FALSE,FALSE),
(15,130,'1:00','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,34,'35:40',0.5,'Z',TRUE,FALSE,FALSE),
(15,130,'1:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,12,'13:40',NULL,'Z',TRUE,FALSE,FALSE),
(15,140,'1:00','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,45,'46:40',1,'Z',TRUE,FALSE,FALSE),
(15,140,'1:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,16,'17:40',NULL,'Z',TRUE,FALSE,FALSE),
(15,150,'1:00','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,56,'57:40',1,'Z',TRUE,FALSE,FALSE),
(15,150,'1:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,19,'20:40',NULL,'Z',TRUE,FALSE,FALSE),
(15,160,'1:00','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,78,'79:40',1,'Z',TRUE,FALSE,FALSE),
(15,160,'1:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,23,'24:40',NULL,'Z',TRUE,FALSE,FALSE),
(15,170,'1:00','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,96,'97:40',1,'Z',FALSE,TRUE,FALSE),
(15,170,'1:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,26,'27:40',NULL,'Z',FALSE,TRUE,FALSE),
(15,180,'1:00','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,111,'112:40',1.5,'Z',FALSE,TRUE,FALSE),
(15,180,'1:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,30,'31:40',NULL,'Z',FALSE,TRUE,FALSE),
(15,190,'1:00','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,125,'126:40',1.5,'Z',FALSE,TRUE,FALSE),
(15,190,'1:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,35,'36:40',NULL,'Z',FALSE,TRUE,FALSE),
(15,200,'1:00','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,136,'137:40',1.5,'Z',FALSE,TRUE,FALSE),
(15,200,'1:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,39,'45:40',NULL,'Z',FALSE,TRUE,FALSE),
(15,210,'1:00','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,147,'148:40',2,NULL,FALSE,TRUE,FALSE),
(15,210,'1:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,43,'49:40',NULL,NULL,FALSE,TRUE,FALSE),
(15,220,'1:00','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,166,'167:40',2,NULL,FALSE,TRUE,FALSE),
(15,220,'1:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,47,'53:40',NULL,NULL,FALSE,TRUE,FALSE),
(15,230,'1:00','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,183,'184:40',2,NULL,FALSE,TRUE,FALSE),
(15,230,'1:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,50,'56:40',NULL,NULL,FALSE,TRUE,FALSE),
(15,240,'1:00','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,198,'199:40',2,NULL,FALSE,TRUE,FALSE),
(15,240,'1:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,53,'59:40',NULL,NULL,FALSE,TRUE,FALSE),
(15,270,'1:00','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,236,'237:40',2.5,NULL,FALSE,TRUE,FALSE),
(15,270,'1:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,62,'68:40',NULL,NULL,FALSE,TRUE,FALSE),
(15,300,'1:00','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,285,'286:40',3,NULL,FALSE,TRUE,FALSE),
(15,300,'1:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,74,'85:40',NULL,NULL,FALSE,TRUE,FALSE),
(15,330,'1:00','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,345,'346:40',3.5,NULL,FALSE,FALSE,TRUE),
(15,330,'1:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,83,'94:40',NULL,NULL,FALSE,FALSE,TRUE),
(15,360,'1:00','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,393,'394:40',3.5,NULL,FALSE,FALSE,TRUE),
(15,360,'1:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,92,'103:40',NULL,NULL,FALSE,FALSE,TRUE),
(15,420,'1:00','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,464,'465:40',4.5,NULL,FALSE,FALSE,TRUE),
(15,420,'1:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,113,'129:40',NULL,NULL,FALSE,FALSE,TRUE),

-- profundidad 16.5 mca
(16.5,74,'1:50','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'1:50', 0,  'L',FALSE,FALSE,FALSE),
(16.5,74,'1:50','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'1:50',NULL,'L',FALSE,FALSE,FALSE),
(16.5,75,'1:10','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2:50', 0.5,'L',FALSE,FALSE,FALSE),
(16.5,75,'1:10','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2:50',NULL,'L',FALSE,FALSE,FALSE),
(16.5,80,'1:10','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,4,'5:50', 0.5,'M',FALSE,FALSE,FALSE),
(16.5,80,'1:10','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,'3:50',NULL,'M',FALSE,FALSE,FALSE),
(16.5,90,'1:10','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,10,'11:50',0.5,'N',FALSE,FALSE,FALSE),
(16.5,90,'1:10','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5,'6:50',NULL,'N',FALSE,FALSE,FALSE),
(16.5,100,'1:10','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,17,'18:50',0.5,'O',TRUE,FALSE,FALSE),
(16.5,100,'1:10','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,8,'9:50',NULL,'O',TRUE,FALSE,FALSE),
(16.5,110,'1:10','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,34,'35:50',0.5,'O',TRUE,FALSE,FALSE),
(16.5,110,'1:10','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,12,'13:50',NULL,'O',TRUE,FALSE,FALSE),
(16.5,120,'1:10','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,48,'49:50',1,'Z',TRUE,FALSE,FALSE),
(16.5,120,'1:10','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,17,'18:50',NULL,'Z',TRUE,FALSE,FALSE),
(16.5,130,'1:10','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,59,'60:50',1,'Z',TRUE,FALSE,FALSE),
(16.5,130,'1:10','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,22,'23:50',NULL,'Z',TRUE,FALSE,FALSE),
(16.5,140,'1:10','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,84,'85:50',1,'Z',TRUE,FALSE,FALSE),
(16.5,140,'1:10','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,26,'27:50',NULL,'Z',TRUE,FALSE,FALSE),
(16.5,150,'1:10','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,105,'106:50',1.5,'Z',FALSE,TRUE,FALSE),
(16.5,150,'1:10','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,30,'31:50',NULL,'Z',FALSE,TRUE,FALSE),
(16.5,160,'1:10','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,123,'124:50',1.5,'Z',FALSE,TRUE,FALSE),
(16.5,160,'1:10','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,34,'35:50',NULL,'Z',FALSE,TRUE,FALSE),
(16.5,170,'1:10','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,138,'139:50',1.5,'Z',FALSE,TRUE,FALSE),
(16.5,170,'1:10','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,40,'46:50',NULL,'Z',FALSE,TRUE,FALSE),
(16.5,180,'1:10','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,151,'152:50',2,'Z',FALSE,TRUE,FALSE),
(16.5,180,'1:10','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,45,'51:50',NULL,'Z',FALSE,TRUE,FALSE),
(16.5,190,'1:10','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,169,'170:50',2,NULL,FALSE,TRUE,FALSE),
(16.5,190,'1:10','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,50,'56:50',NULL,NULL,FALSE,TRUE,FALSE),
(16.5,200,'1:10','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,190,'191:50',2,NULL,FALSE,TRUE,FALSE),
(16.5,200,'1:10','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,54,'60:50',NULL,NULL,FALSE,TRUE,FALSE),
(16.5,210,'1:10','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,208,'209:50',2.5,NULL,FALSE,TRUE,FALSE),
(16.5,210,'1:10','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,58,'64:50',NULL,NULL,FALSE,TRUE,FALSE),
(16.5,220,'1:10','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,224,'225:50',2.5,NULL,FALSE,TRUE,FALSE),
(16.5,220,'1:10','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,62,'68:50',NULL,NULL,FALSE,TRUE,FALSE),
(16.5,230,'1:10','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,239,'240:50',2.5,NULL,FALSE,TRUE,FALSE),
(16.5,230,'1:10','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,66,'77:50',NULL,NULL,FALSE,TRUE,FALSE),
(16.5,240,'1:10','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,254,'255:50',3,NULL,FALSE,TRUE,FALSE),
(16.5,240,'1:10','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,69,'80:50',NULL,NULL,FALSE,TRUE,FALSE),
(16.5,270,'1:10','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,313,'314:50',3.5,NULL,FALSE,FALSE,TRUE),
(16.5,270,'1:10','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,83,'94:50',NULL,NULL,FALSE,FALSE,TRUE),
(16.5,300,'1:10','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,380,'381:50',3.5,NULL,FALSE,FALSE,TRUE),
(16.5,300,'1:10','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,94,'105:50',NULL,NULL,FALSE,FALSE,TRUE),
(16.5,330,'1:10','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,432,'433:50',4,NULL,FALSE,FALSE,TRUE),
(16.5,330,'1:10','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,106,'122:50',NULL,NULL,FALSE,FALSE,TRUE),
(16.5,360,'1:10','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,474,'475:50',4.5,NULL,FALSE,FALSE,TRUE),
(16.5,360,'1:10','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,118,'134:50',NULL,NULL,FALSE,FALSE,TRUE),

-- profundidad 18 mca
(18,63,'2:00', 'AIRE',    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2:00', 0,   'K',FALSE,FALSE,FALSE),
(18,63,'2:00', 'AIRE_O2', NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2:00', NULL,'K',FALSE,FALSE,FALSE),
(18,65,'1:20', 'AIRE',    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,'4:00', 0.5, 'L',FALSE,FALSE,FALSE),
(18,65,'1:20', 'AIRE_O2', NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'3:00', NULL,'L',FALSE,FALSE,FALSE),
(18,70,'1:20', 'AIRE',    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,7,'9:00', 0.5, 'L',FALSE,FALSE,FALSE),
(18,70,'1:20', 'AIRE_O2', NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,4,'6:00', NULL,'L',FALSE,FALSE,FALSE),
(18,80,'1:20', 'AIRE',    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,14,'16:00',0.5, 'N',FALSE,FALSE,FALSE),
(18,80,'1:20', 'AIRE_O2', NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,7,'9:00', NULL,'N',FALSE,FALSE,FALSE),
(18,90,'1:20', 'AIRE',    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,23,'25:00',0.5, 'O',TRUE,FALSE,FALSE),
(18,90,'1:20', 'AIRE_O2', NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,10,'12:00',NULL,'O',TRUE,FALSE,FALSE),
(18,100,'1:20','AIRE',    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,42,'44:00',1,   'Z',TRUE,FALSE,FALSE),
(18,100,'1:20','AIRE_O2', NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,15,'17:00',NULL,'Z',TRUE,FALSE,FALSE),
(18,110,'1:20','AIRE',    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,57,'59:00',1,   'Z',TRUE,FALSE,FALSE),
(18,110,'1:20','AIRE_O2', NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,21,'23:00',NULL,'Z',TRUE,FALSE,FALSE),
(18,120,'1:20','AIRE',    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,75,'77:00',1,   'Z',TRUE,FALSE,FALSE),
(18,120,'1:20','AIRE_O2', NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,26,'28:00',NULL,'Z',TRUE,FALSE,FALSE),
(18,130,'1:20','AIRE',    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,102,'104:00',1.5,'Z',FALSE,TRUE,FALSE),
(18,130,'1:20','AIRE_O2', NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,31,'33:00',NULL,'Z',FALSE,TRUE,FALSE),
(18,140,'1:20','AIRE',    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,124,'126:00',1.5,'Z',FALSE,TRUE,FALSE),
(18,140,'1:20','AIRE_O2', NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,35,'37:00',NULL,'Z',FALSE,TRUE,FALSE),
(18,150,'1:20','AIRE',    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,143,'145:00',2,  'Z',FALSE,TRUE,FALSE),
(18,150,'1:20','AIRE_O2', NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,41,'48:00',NULL,'Z',FALSE,TRUE,FALSE),
(18,160,'1:20','AIRE',    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,158,'160:00',2,  'Z',FALSE,TRUE,FALSE),
(18,160,'1:20','AIRE_O2', NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,48,'55:00',NULL,'Z',FALSE,TRUE,FALSE),
(18,170,'1:20','AIRE',    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,178,'180:00',2,  NULL,FALSE,TRUE,FALSE),
(18,170,'1:20','AIRE_O2', NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,53,'60:00',NULL,NULL,FALSE,TRUE,FALSE),
(18,180,'1:20','AIRE',    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,201,'203:00',2.5,NULL,FALSE,TRUE,FALSE),
(18,180,'1:20','AIRE_O2', NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,59,'66:00',NULL,NULL,FALSE,TRUE,FALSE),
(18,190,'1:20','AIRE',    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,222,'224:00',2.5,NULL,FALSE,TRUE,FALSE),
(18,190,'1:20','AIRE_O2', NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,64,'71:00',NULL,NULL,FALSE,TRUE,FALSE),
(18,200,'1:20','AIRE',    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,240,'242:00',2.5,NULL,FALSE,TRUE,FALSE),
(18,200,'1:20','AIRE_O2', NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,68,'80:00',NULL,NULL,FALSE,TRUE,FALSE),
(18,210,'1:20','AIRE',    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,256,'258:00',3,  NULL,FALSE,TRUE,FALSE),
(18,210,'1:20','AIRE_O2', NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,73,'85:00',NULL,NULL,FALSE,TRUE,FALSE),
(18,220,'1:20','AIRE',    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,278,'280:00',3,  NULL,FALSE,TRUE,FALSE),
(18,220,'1:20','AIRE_O2', NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,77,'89:00',NULL,NULL,FALSE,TRUE,FALSE),
(18,230,'1:20','AIRE',    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,300,'302:00',3.5,NULL,FALSE,FALSE,TRUE),
(18,230,'1:20','AIRE_O2', NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,82,'94:00',NULL,NULL,FALSE,FALSE,TRUE),
(18,240,'1:20','AIRE',    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,321,'323:00',3.5,NULL,FALSE,FALSE,TRUE),
(18,240,'1:20','AIRE_O2', NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,88,'100:00',NULL,NULL,FALSE,FALSE,TRUE),
(18,270,'1:20','AIRE',    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,398,'400:00',4,  NULL,FALSE,FALSE,TRUE),
(18,270,'1:20','AIRE_O2', NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,102,'119:00',NULL,NULL,FALSE,FALSE,TRUE),
(18,300,'1:20','AIRE',    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,456,'458:00',4.5,NULL,FALSE,FALSE,TRUE),
(18,300,'1:20','AIRE_O2', NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,115,'132:00',NULL,NULL,FALSE,FALSE,TRUE),

-- profundidad 21 mca
(21,48,'2:20','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2:20', 0,  'K',FALSE,FALSE,FALSE),
(21,48,'2:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2:20',NULL,'K',FALSE,FALSE,FALSE),
(21,50,'1:40','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,'4:20', 0.5,'K',FALSE,FALSE,FALSE),
(21,50,'1:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'3:20',NULL,'K',FALSE,FALSE,FALSE),
(21,55,'1:40','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,9,'11:20',0.5,'L',FALSE,FALSE,FALSE),
(21,55,'1:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5,'7:20',NULL,'L',FALSE,FALSE,FALSE),
(21,60,'1:40','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,14,'16:20',0.5,'M',FALSE,FALSE,FALSE),
(21,60,'1:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,8,'10:20',NULL,'M',FALSE,FALSE,FALSE),
(21,70,'1:40','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,24,'26:20',0.5,'N',TRUE,FALSE,FALSE),
(21,70,'1:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,13,'15:20',NULL,'N',TRUE,FALSE,FALSE),
(21,80,'1:40','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,44,'46:20',1,'O',TRUE,FALSE,FALSE),
(21,80,'1:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,17,'19:20',NULL,'O',TRUE,FALSE,FALSE),
(21,90,'1:40','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,64,'66:20',1,'Z',TRUE,FALSE,FALSE),
(21,90,'1:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,24,'26:20',NULL,'Z',TRUE,FALSE,FALSE),
(21,100,'1:40','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,88,'90:20',1.5,'Z',FALSE,TRUE,FALSE),
(21,100,'1:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,31,'33:20',NULL,'Z',FALSE,TRUE,FALSE),
(21,110,'1:40','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,120,'122:20',1.5,'Z',FALSE,TRUE,FALSE),
(21,110,'1:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,38,'45:20',NULL,'Z',FALSE,TRUE,FALSE),
(21,120,'1:40','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,145,'147:20',2,'Z',FALSE,TRUE,FALSE),
(21,120,'1:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,44,'51:20',NULL,'Z',FALSE,TRUE,FALSE),
(21,130,'1:40','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,167,'169:20',2,'Z',FALSE,TRUE,FALSE),
(21,130,'1:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,51,'58:20',NULL,'Z',FALSE,TRUE,FALSE),
(21,140,'1:40','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,189,'191:20',2.5,NULL,FALSE,TRUE,FALSE),
(21,140,'1:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,59,'66:20',NULL,NULL,FALSE,TRUE,FALSE),
(21,150,'1:40','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,219,'221:20',2.5,NULL,FALSE,TRUE,FALSE),
(21,150,'1:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,66,'78:20',NULL,NULL,FALSE,TRUE,FALSE),
(21,160,'1:20','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,244,'247:00',3,NULL,FALSE,TRUE,FALSE),
(21,160,'1:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,72,'85:00',NULL,NULL,FALSE,TRUE,FALSE),
(21,170,'1:20','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,265,'269:00',3,NULL,FALSE,FALSE,TRUE),
(21,170,'1:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,78,'91:00',NULL,NULL,FALSE,FALSE,TRUE),
(21,180,'1:20','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,4,289,'295:00',3.5,NULL,FALSE,FALSE,TRUE),
(21,180,'1:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,83,'97:00',NULL,NULL,FALSE,FALSE,TRUE),
(21,190,'1:20','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,5,316,'323:00',3.5,NULL,FALSE,FALSE,TRUE),
(21,190,'1:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,3,88,'103:00',NULL,NULL,FALSE,FALSE,TRUE),
(21,200,'1:20','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,9,345,'356:00',4,NULL,FALSE,FALSE,TRUE),
(21,200,'1:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,5,93,'115:00',NULL,NULL,FALSE,FALSE,TRUE),
(21,210,'1:20','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,13,378,'393:00',4,NULL,FALSE,FALSE,TRUE),
(21,210,'1:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,7,98,'122:00',NULL,NULL,FALSE,FALSE,TRUE),
(21,240,'1:20','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,25,454,'481:00',5,NULL,FALSE,FALSE,TRUE),
(21,240,'1:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,13,110,'140:00',NULL,NULL,FALSE,FALSE,TRUE),

-- profundidad 24 mca
(24,39,'2:40','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2:40', 0,  'J',FALSE,FALSE,FALSE),
(24,39,'2:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2:40',NULL,'J',FALSE,FALSE,FALSE),
(24,40,'2:00','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'3:40', 0.5,'J',FALSE,FALSE,FALSE),
(24,40,'2:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'3:40',NULL,'J',FALSE,FALSE,FALSE),
(24,45,'2:00','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,10,'12:40',0.5,'K',FALSE,FALSE,FALSE),
(24,45,'2:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5,'7:40',NULL,'K',FALSE,FALSE,FALSE),
(24,50,'2:00','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,17,'19:40',0.5,'M',TRUE,FALSE,FALSE),
(24,50,'2:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,9,'11:40',NULL,'M',TRUE,FALSE,FALSE),
(24,55,'2:00','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,24,'26:40',0.5,'M',TRUE,FALSE,FALSE),
(24,55,'2:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,13,'15:40',NULL,'M',TRUE,FALSE,FALSE),
(24,60,'2:00','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,30,'32:40',1,'N',TRUE,FALSE,FALSE),
(24,60,'2:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,16,'18:40',NULL,'N',TRUE,FALSE,FALSE),
(24,70,'2:00','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,54,'56:40',1,'O',TRUE,FALSE,FALSE),
(24,70,'2:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,22,'24:40',NULL,'O',TRUE,FALSE,FALSE),
(24,80,'2:00','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,77,'79:40',1.5,'Z',TRUE,FALSE,FALSE),
(24,80,'2:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,30,'32:40',NULL,'Z',TRUE,FALSE,FALSE),
(24,90,'2:00','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,114,'116:40',1.5,'Z',FALSE,TRUE,FALSE),
(24,90,'2:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,39,'46:40',NULL,'Z',FALSE,TRUE,FALSE),
(24,100,'1:40','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,147,'150:20',2,'Z',FALSE,TRUE,FALSE),
(24,100,'1:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,46,'54:20',NULL,'Z',FALSE,TRUE,FALSE),
(24,110,'1:40','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,6,171,'179:20',2,'Z',FALSE,TRUE,FALSE),
(24,110,'1:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,3,51,'61:20',NULL,'Z',FALSE,TRUE,FALSE),
(24,120,'1:40','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,10,200,'212:20',2.5,NULL,FALSE,TRUE,FALSE),
(24,120,'1:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,5,59,'71:20',NULL,NULL,FALSE,TRUE,FALSE),
(24,130,'1:40','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,14,232,'248:20',3,NULL,FALSE,TRUE,FALSE),
(24,130,'1:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,7,67,'86:20',NULL,NULL,FALSE,TRUE,FALSE),
(24,140,'1:40','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,17,258,'277:20',3.5,NULL,FALSE,FALSE,TRUE),
(24,140,'1:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,9,73,'94:20',NULL,NULL,FALSE,FALSE,TRUE),
(24,150,'1:40','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,19,285,'306:20',3.5,NULL,FALSE,FALSE,TRUE),
(24,150,'1:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,10,80,'102:20',NULL,NULL,FALSE,FALSE,TRUE),
(24,160,'1:40','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,21,318,'341:20',4,NULL,FALSE,FALSE,TRUE),
(24,160,'1:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,11,86,'114:20',NULL,NULL,FALSE,FALSE,TRUE),
(24,170,'1:40','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,27,354,'383:20',4,NULL,FALSE,FALSE,TRUE),
(24,170,'1:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,14,90,'121:20',NULL,NULL,FALSE,FALSE,TRUE),
(24,180,'1:40','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,33,391,'426:20',4.5,NULL,FALSE,FALSE,TRUE),
(24,180,'1:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,17,96,'130:20',NULL,NULL,FALSE,FALSE,TRUE),
(24,210,'1:40','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,51,473,'526:20',5,NULL,FALSE,FALSE,TRUE),
(24,210,'1:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,26,110,'158:20',NULL,NULL,FALSE,FALSE,TRUE),

-- profundidad 27 mca
(27,33,'3:00','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'3:00', 0,  'J',FALSE,FALSE,FALSE),
(27,33,'3:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'3:00',NULL,'J',FALSE,FALSE,FALSE),
(27,35,'2:20','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,4,'7:00', 0.5,'J',FALSE,FALSE,FALSE),
(27,35,'2:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,'5:00',NULL,'J',FALSE,FALSE,FALSE),
(27,40,'2:20','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,14,'17:00',0.5,'L',FALSE,FALSE,FALSE),
(27,40,'2:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,7,'10:00',NULL,'L',FALSE,FALSE,FALSE),
(27,45,'2:20','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,23,'26:00',0.5,'M',TRUE,FALSE,FALSE),
(27,45,'2:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,12,'15:00',NULL,'M',TRUE,FALSE,FALSE),
(27,50,'2:20','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,31,'34:00',1,'N',TRUE,FALSE,FALSE),
(27,50,'2:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,17,'20:00',NULL,'N',TRUE,FALSE,FALSE),
(27,55,'2:20','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,39,'42:00',1,'O',TRUE,FALSE,FALSE),
(27,55,'2:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,21,'24:00',NULL,'O',TRUE,FALSE,FALSE),
(27,60,'2:20','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,56,'59:00',1,'O',TRUE,FALSE,FALSE),
(27,60,'2:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,24,'27:00',NULL,'O',TRUE,FALSE,FALSE),
(27,70,'2:20','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,83,'86:00',1.5,'Z',TRUE,FALSE,FALSE),
(27,70,'2:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,32,'35:00',NULL,'Z',TRUE,FALSE,FALSE),
(27,80,'2:00','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,5,125,'132:40',2,'Z',FALSE,TRUE,FALSE),
(27,80,'2:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,3,40,'50:40',NULL,'Z',FALSE,TRUE,FALSE),
(27,90,'2:00','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,13,158,'173:40',2,'Z',FALSE,TRUE,FALSE),
(27,90,'2:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,7,46,'60:40',NULL,'Z',FALSE,TRUE,FALSE),
(27,100,'2:00','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,19,185,'206:40',2.5,NULL,FALSE,TRUE,FALSE),
(27,100,'2:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,10,53,'70:40',NULL,NULL,FALSE,TRUE,FALSE),
(27,110,'2:00','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,25,224,'251:40',3,NULL,FALSE,TRUE,FALSE),
(27,110,'2:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,13,61,'86:40',NULL,NULL,FALSE,TRUE,FALSE),
(27,120,'1:40','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,2,28,256,'288:20',3.5,NULL,FALSE,FALSE,TRUE),
(27,120,'1:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,2,14,70,'98:40',NULL,NULL,FALSE,FALSE,TRUE),
(27,130,'1:40','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,5,28,291,'326:20',3.5,NULL,FALSE,FALSE,TRUE),
(27,130,'1:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,5,14,79,'110:40',NULL,NULL,FALSE,FALSE,TRUE),
(27,140,'1:40','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,8,28,330,'368:20',4,NULL,FALSE,FALSE,TRUE),
(27,140,'1:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,8,14,87,'126:40',NULL,NULL,FALSE,FALSE,TRUE),
(27,150,'1:40','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,11,34,378,'425:20',4.5,NULL,FALSE,FALSE,TRUE),
(27,150,'1:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,11,17,94,'139:40',NULL,NULL,FALSE,FALSE,TRUE),
(27,160,'1:40','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,13,40,418,'473:20',4.5,NULL,FALSE,FALSE,TRUE),
(27,160,'1:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,13,20,101,'151:40',NULL,NULL,FALSE,FALSE,TRUE),
(27,170,'1:40','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,15,45,451,'513:20',5,NULL,FALSE,FALSE,TRUE),
(27,170,'1:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,15,23,106,'166:40',NULL,NULL,FALSE,FALSE,TRUE),
(27,180,'1:40','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,16,51,479,'548:20',5.5,NULL,FALSE,FALSE,TRUE),
(27,180,'1:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,16,26,112,'176:40',NULL,NULL,FALSE,FALSE,TRUE),
(27,240,'1:40','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,42,68,592,'704:20',7.5,NULL,FALSE,FALSE,TRUE),
(27,240,'1:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,42,34,159,'267:40',NULL,NULL,FALSE,FALSE,TRUE),

-- profundidad 30 mca
(30,25 ,'3:20','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'3:20', 0,  'H',FALSE,FALSE,FALSE),
(30,25 ,'3:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'3:20',NULL,  'H',FALSE,FALSE,FALSE),
(30,30 ,'2:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,3,'6:20', 0.5,'J',FALSE,FALSE,FALSE),
(30,30 ,'2:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,'5:20',NULL,'J',FALSE,FALSE,FALSE),
(30,35 ,'2:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,15,'18:20',0.5,'L',FALSE,FALSE,FALSE),
(30,35 ,'2:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,8,'11:20',NULL,'L',FALSE,FALSE,FALSE),
(30,40 ,'2:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,26,'29:20',1,'M',TRUE,FALSE,FALSE),
(30,40 ,'2:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,14,'17:20',NULL,'M',TRUE,FALSE,FALSE),
(30,45 ,'2:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,36,'39:20',1,'N',TRUE,FALSE,FALSE),
(30,45 ,'2:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,19,'22:20',NULL,'N',TRUE,FALSE,FALSE),
(30,50 ,'2:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,47,'50:20',1,'O',TRUE,FALSE,FALSE),
(30,50 ,'2:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,24,'27:20',NULL,'O',TRUE,FALSE,FALSE),
(30,55 ,'2:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,65,'68:20',1.5,'Z',TRUE,FALSE,FALSE),
(30,55 ,'2:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,28,'31:20',NULL,'Z',TRUE,FALSE,FALSE),
(30,60 ,'2:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,81,'84:20',1.5,'Z',TRUE,FALSE,FALSE),
(30,60 ,'2:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,33,'36:20',NULL,'Z',TRUE,FALSE,FALSE),
(30,70 ,'2:20','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,11,124,'138:00',2,'Z',FALSE,TRUE,FALSE),
(30,70 ,'2:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,6,39,'53:00',NULL,'Z',FALSE,TRUE,FALSE),
(30,80 ,'2:20','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,21,160,'184:00',2.5,'Z',FALSE,TRUE,FALSE),
(30,80 ,'2:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,11,45,'64:00',NULL,'Z',FALSE,TRUE,FALSE),
(30,90 ,'2:00','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,2,28,196,'228:40',2.5,NULL,FALSE,TRUE,FALSE),
(30,90 ,'2:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,2,14,53,'82:00',NULL,NULL,FALSE,TRUE,FALSE),
(30,100,'2:00','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,9,28,241,'280:40',3,NULL,FALSE,FALSE,TRUE),
(30,100,'2:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,9,14,66,'102:00',NULL,NULL,FALSE,FALSE,TRUE),
(30,110,'2:00','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,14,28,278,'322:40',3.5,NULL,FALSE,FALSE,TRUE),
(30,110,'2:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,14,14,76,'117:00',NULL,NULL,FALSE,FALSE,TRUE),
(30,120,'2:00','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,19,28,324,'373:40',4,NULL,FALSE,FALSE,TRUE),
(30,120,'2:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,19,14,85,'136:00',NULL,NULL,FALSE,FALSE,TRUE),
(30,150,'1:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,3,26,46,461,'538:20',5,NULL,FALSE,FALSE,TRUE),
(30,150,'1:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,3,26,23,109,'183:40',NULL,NULL,FALSE,FALSE,TRUE),

-- profundidad 33 mca
(33,20,'3:40','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,  '3:40', 0,   'H',FALSE,FALSE,FALSE),
(33,20,'3:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,  '3:40', NULL,'H',FALSE,FALSE,FALSE),
(33,25,'3:00','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5,  '8:40', 0.5, 'I',FALSE,FALSE,FALSE),
(33,25,'3:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,3,  '6:40', NULL,'I',FALSE,FALSE,FALSE),
(33,30,'3:00','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,14, '17:40',0.5, 'K',FALSE,FALSE,FALSE),
(33,30,'3:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,7,  '10:40',NULL,'K',FALSE,FALSE,FALSE),
(33,35,'3:00','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,27, '30:40',1,   'M',TRUE,FALSE,FALSE),
(33,35,'3:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,14, '17:40',NULL,'M',TRUE,FALSE,FALSE),
(33,40,'3:00','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,39, '42:40',1,   'N',TRUE,FALSE,FALSE),
(33,40,'3:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20, '23:40',NULL,'N',TRUE,FALSE,FALSE),
(33,45,'3:00','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,50, '53:40',1,   'O',TRUE,FALSE,FALSE),
(33,45,'3:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,26, '29:40',NULL,'O',TRUE,FALSE,FALSE),
(33,50,'3:00','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,71, '74:40',1.5, 'Z',TRUE,FALSE,FALSE),
(33,50,'3:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,32, '35:40',NULL,'Z',TRUE,FALSE,FALSE),
(33,55,'2:40','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,5,   85, '93:20',1.5, 'Z',FALSE,TRUE,FALSE),
(33,55,'2:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,3,   33, '44:20',NULL,'Z',FALSE,TRUE,FALSE),
(33,60,'2:40','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,13,  111,'127:20',2,   'Z',FALSE,TRUE,FALSE),
(33,60,'2:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,7,   36, '51:20', NULL,'Z',FALSE,TRUE,FALSE),
(33,70,'2:40','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,26,  155,'184:20',2.5, 'Z',FALSE,TRUE,FALSE),
(33,70,'2:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,14,  42, '64:20', NULL,'Z',FALSE,TRUE,FALSE),
(33,80,'2:20','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,9,   28,  200,'240:00',2.5, NULL,FALSE,FALSE,TRUE),
(33,80,'2:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,9,   14,  54, '90:20', NULL,NULL,FALSE,FALSE,TRUE),
(33,90,'2:20','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,18,  28,  249,'298:00',3.5, NULL,FALSE,FALSE,TRUE),
(33,90,'2:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,18,  14,  68, '113:20',NULL,NULL,FALSE,FALSE,TRUE),
(33,100,'2:20','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,25,  28,  295,'351:00',3.5, NULL,FALSE,FALSE,TRUE),
(33,100,'2:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,25,  14,  79, '131:20',NULL,NULL,FALSE,FALSE,TRUE),
(33,110,'2:00','AIRE',  NULL,NULL,NULL,NULL,NULL,5,   26,  28,  353,'414:40',4,   NULL,FALSE,FALSE,TRUE),
(33,110,'2:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,5,   26,  14,  91, '154:00',NULL,NULL,FALSE,FALSE,TRUE),
(33,120,'2:00','AIRE',  NULL,NULL,NULL,NULL,NULL,10,  26,  35,  413,'486:40',4.5, NULL,FALSE,FALSE,TRUE),
(33,120,'2:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,10,  26,  18,  101,'173:00',NULL,NULL,FALSE,FALSE,TRUE),
(33,180,'1:40','AIRE',  NULL,NULL,NULL,NULL,3,   23,  47,  68,  593,'736:20',7.5, NULL,FALSE,FALSE,TRUE),
(33,180,'1:40','AIRE_O2',NULL,NULL,NULL,NULL,3,   23,  47,  34,  159,'298:40',NULL,NULL,FALSE,FALSE,TRUE),

-- profundidad 36 mca
(36,15 ,'4:00','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'4:00', 0,'F',FALSE,FALSE,FALSE),
(36,15 ,'4:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'4:00', NULL,'F',FALSE,FALSE,FALSE),
(36,20 ,'3:20','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,4,'8:00', 0.5,'H',FALSE,FALSE,FALSE),
(36,20 ,'3:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,'6:00', NULL,'H',FALSE,FALSE,FALSE),
(36,25 ,'3:20','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,9,'13:00',0.5,'J',FALSE,FALSE,FALSE),
(36,25 ,'3:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5,'9:00', NULL,'J',FALSE,FALSE,FALSE),
(36,30 ,'3:20','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,24,'28:00',0.5,'L',TRUE,FALSE,FALSE),
(36,30 ,'3:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,13,'17:00',NULL,'L',TRUE,FALSE,FALSE),
(36,35 ,'3:20','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,38,'42:00',1,'N',TRUE,FALSE,FALSE),
(36,35 ,'3:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20,'24:00',NULL,'N',TRUE,FALSE,FALSE),
(36,40 ,'3:00','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,49,'54:40',1,'O',TRUE,FALSE,FALSE),
(36,40 ,'3:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,26,'30:40',NULL,'O',TRUE,FALSE,FALSE),
(36,45 ,'3:00','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,3,71,'77:40',1.5,'Z',TRUE,FALSE,FALSE),
(36,45 ,'3:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,31,'36:40',NULL,'Z',TRUE,FALSE,FALSE),
(36,50 ,'3:00','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,10,85,'98:40',1.5,'Z',FALSE,TRUE,FALSE),
(36,50 ,'3:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,5,33,'46:40',NULL,'Z',FALSE,TRUE,FALSE),
(36,55 ,'3:00','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,19,116,'138:40',2,'Z',FALSE,TRUE,FALSE),
(36,55 ,'3:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,10,35,'53:40',NULL,'Z',FALSE,TRUE,FALSE),
(36,60 ,'3:00','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,27,142,'172:40',2,'Z',FALSE,TRUE,FALSE),
(36,60 ,'3:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,14,39,'61:40',NULL,'Z',FALSE,TRUE,FALSE),
(36,70 ,'2:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,13,28,190,'234:20',2.5, NULL,FALSE,FALSE,TRUE),
(36,70 ,'2:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,13,14,51,'86:40',NULL,NULL,FALSE,FALSE,TRUE),
(36,80 ,'2:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,24,28,246,'301:20',3,NULL,FALSE,FALSE,TRUE),
(36,80 ,'2:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,24,14,67,'118:40',NULL,NULL,FALSE,FALSE,TRUE),
(36,90 ,'2:20','AIRE'   ,NULL,NULL,NULL,NULL,NULL,7, 26,28,303,'367:00',3.5, NULL,FALSE,FALSE,TRUE),
(36,90 ,'2:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,7, 26,14,80,'140:20',NULL,NULL,FALSE,FALSE,TRUE),
(36,100,'2:20','AIRE'   ,NULL,NULL,NULL,NULL,NULL,15,25,28,372,'443:00',4,NULL,FALSE,FALSE,TRUE),
(36,100,'2:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,15,25,14,95,'167:20',NULL,NULL,FALSE,FALSE,TRUE),
(36,110,'2:20','AIRE'   ,NULL,NULL,NULL,NULL,NULL,21,25,38,433,'520:00',5,NULL,FALSE,FALSE,TRUE),
(36,110,'2:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,21,25,19,105,'188:20',NULL,NULL,FALSE,FALSE,TRUE),
(36,120,'2:00','AIRE'   ,NULL,NULL,NULL,NULL,3,23,25,47,480,'580:40',5.5,NULL,FALSE,FALSE,TRUE),
(36,120,'2:00','AIRE_O2',NULL,NULL,NULL,NULL,3,23,25,24,113,'211:00',NULL,NULL,FALSE,FALSE,TRUE),

-- profundidad39 mca
(39,12,'4:20','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,  '4:20', 0,   'F',FALSE,FALSE,FALSE),
(39,12,'4:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,  '4:20', NULL,'F',FALSE,FALSE,FALSE),
(39,15,'3:40','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,3,  '7:20', 0.5, 'G',FALSE,FALSE,FALSE),
(39,15,'3:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,  '6:20', NULL,'G',FALSE,FALSE,FALSE),
(39,20,'3:40','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,8,  '12:20',0.5, 'I',FALSE,FALSE,FALSE),
(39,20,'3:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5,  '9:20', NULL,'I',FALSE,FALSE,FALSE),
(39,25,'3:40','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,17, '21:20',0.5, 'K',TRUE,FALSE,FALSE),
(39,25,'3:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,9,  '13:20',NULL,'K',TRUE,FALSE,FALSE),
(39,30,'3:20','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,   32, '38:00',1,   'M',TRUE,FALSE,FALSE),
(39,30,'3:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,   17, '22:00',NULL,'M',TRUE,FALSE,FALSE),
(39,35,'3:20','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,5,   44, '53:00',1,   'O',TRUE,FALSE,FALSE),
(39,35,'3:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,3,   23, '30:00',NULL,'O',TRUE,FALSE,FALSE),
(39,40,'3:20','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,6,   66, '76:00',1.5, 'Z',TRUE,FALSE,FALSE),
(39,40,'3:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,3,   30, '37:00',NULL,'Z',TRUE,FALSE,FALSE),
(39,45,'3:00','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,1,   11,  84, '99:40',1.5, 'Z',FALSE,TRUE,FALSE),
(39,45,'3:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,1,   6,   33, '49:00',NULL,'Z',FALSE,TRUE,FALSE),
(39,50,'3:00','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,2,   20,  118,'143:40',2,   'Z',FALSE,TRUE,FALSE),
(39,50,'3:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,2,   10,  36, '57:00', NULL,'Z',FALSE,TRUE,FALSE),
(39,55,'3:00','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,4,   28,  146,'181:40',2,   'Z',FALSE,TRUE,FALSE),
(39,55,'3:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,4,   14,  40, '67:00', NULL,'Z',FALSE,TRUE,FALSE),
(39,60,'3:00','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,12,  28,  170,'213:40',2.5, 'Z',FALSE,TRUE,FALSE),
(39,60,'3:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,12,  15,  46, '81:00', NULL,'Z',FALSE,TRUE,FALSE),
(39,70,'2:40','AIRE',   NULL,NULL,NULL,NULL,NULL,1,   26,  28,  235,'293:20',3,   NULL,FALSE,FALSE,TRUE),
(39,70,'2:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,1,   26,  14,  63, '117:40',NULL,NULL,FALSE,FALSE,TRUE),
(39,80,'2:40','AIRE',   NULL,NULL,NULL,NULL,NULL,12,  26,  28,  297,'366:20',3.5, NULL,FALSE,FALSE,TRUE),
(39,80,'2:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,12,  26,  14,  79, '144:40',NULL,NULL,FALSE,FALSE,TRUE),
(39,90,'2:40','AIRE',   NULL,NULL,NULL,NULL,NULL,22,  25,  28,  375,'453:20',4,   NULL,FALSE,FALSE,TRUE),
(39,90,'2:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,22,  25,  14,  95, '174:40',NULL,NULL,FALSE,FALSE,TRUE),
(39,100,'2:20','AIRE',  NULL,NULL,NULL,NULL,6,   23,  26,  38,  444,'540:00',5,   NULL,FALSE,FALSE,TRUE),
(39,100,'2:20','AIRE_O2',NULL,NULL,NULL,NULL,6,   23,  26,  20,  106,'204:20',NULL,NULL,FALSE,FALSE,TRUE),
(39,120,'2:20','AIRE',  NULL,NULL,NULL,NULL,17,  24,  27,  57,  534,'662:00',6,   NULL,FALSE,FALSE,TRUE),
(39,120,'2:20','AIRE_O2',NULL,NULL,NULL,NULL,17,  24,  27,  29,  130,'255:20',NULL,NULL,FALSE,FALSE,TRUE),
(39,180,'2:00','AIRE',  NULL,NULL,NULL,13,  21,  45,  57,  94,  658,'890:40',9,   NULL,FALSE,FALSE,TRUE),
(39,180,'2:00','AIRE_O2',NULL,NULL,NULL,13,  21,  45,  57,  46,  198,'418:00',NULL,NULL,FALSE,FALSE,TRUE),

-- profundidad 42 mca
(42,10,'4:40','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,  '4:40', 0,   'E',FALSE,FALSE,FALSE),
(42,10,'4:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,  '4:40', NULL,'E',FALSE,FALSE,FALSE),
(42,15,'4:00','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5,  '9:40', 0.5, 'H',FALSE,FALSE,FALSE),
(42,15,'4:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,3,  '7:40', NULL,'H',FALSE,FALSE,FALSE),
(42,20,'4:00','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,13, '17:40',0.5, 'J',FALSE,FALSE,FALSE),
(42,20,'4:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,7,  '11:40',NULL,'J',FALSE,FALSE,FALSE),
(42,25,'3:40','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,3,   24, '31:20',1,   'L',TRUE,FALSE,FALSE),
(42,25,'3:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,   12, '18:20',NULL,'L',TRUE,FALSE,FALSE),
(42,30,'3:40','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,7,   37, '48:20',1,   'N',TRUE,FALSE,FALSE),
(42,30,'3:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,4,   19, '27:20',NULL,'N',TRUE,FALSE,FALSE),
(42,35,'3:20','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,2,   7,  58,'71:00',1.5,'O',TRUE,FALSE,FALSE),
(42,35,'3:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,2,   4,  26,'36:20',NULL,'O',TRUE,FALSE,FALSE),
(42,40,'3:20','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,4,   7,  82,'97:00',1.5,'Z',FALSE,TRUE,FALSE),
(42,40,'3:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,4,   4,   33, '50:20', NULL,'Z',FALSE,TRUE,FALSE),
(42,45,'3:20','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,5,   18,  114,'141:00',2,   'Z',FALSE,TRUE,FALSE),
(42,45,'3:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,5,   9,   36, '59:20', NULL,'Z',FALSE,TRUE,FALSE),
(42,50,'3:20','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,8,   27,  145,'184:00',2,   'Z',FALSE,TRUE,FALSE),
(42,50,'3:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,8,   14,  39, '70:20', NULL,'Z',FALSE,TRUE,FALSE),
(42,55,'3:00','AIRE',   NULL,NULL,NULL,NULL,NULL,1,   15,  29,  171,'219:40',2.5, 'Z',FALSE,TRUE,FALSE),
(42,55,'3:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,1,   15,  15,  45, '85:00', NULL,'Z',FALSE,TRUE,FALSE),
(42,60,'3:00','AIRE',   NULL,NULL,NULL,NULL,NULL,2,   23,  28,  209,'265:40',3,   NULL,FALSE,FALSE,TRUE),
(42,60,'3:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,2,   23,  14,  56, '109:00',NULL,NULL,FALSE,FALSE,TRUE),
(42,70,'3:00','AIRE',   NULL,NULL,NULL,NULL,NULL,14,  25,  29,  276,'347:40',3.5, NULL,FALSE,FALSE,TRUE),
(42,70,'3:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,14,  25,  15,  74, '142:00',NULL,NULL,FALSE,FALSE,TRUE),
(42,80,'2:40','AIRE',   NULL,NULL,NULL,NULL,2,   24,  25,  29,  362,'445:20',4,   NULL,FALSE,FALSE,TRUE),
(42,80,'2:40','AIRE_O2',NULL,NULL,NULL,NULL,2,   24,  25,  15,  91, '175:40',NULL,NULL,FALSE,FALSE,TRUE),
(42,90,'2:40','AIRE',   NULL,NULL,NULL,NULL,12,  23,  26,  38,  443,'545:20',5,   NULL,FALSE,FALSE,TRUE),
(42,90,'2:40','AIRE_O2',NULL,NULL,NULL,NULL,12,  23,  26,  19,  107,'210:40',NULL,NULL,FALSE,FALSE,TRUE),

-- profundidad 45 mca
(45,8,'5:00','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,  '5:00', 0,   'E',FALSE,FALSE,FALSE),
(45,8,'5:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,  '5:00', NULL,'E',FALSE,FALSE,FALSE),
(45,10,'4:20','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,  '7:00', 0.5, 'F',FALSE,FALSE,FALSE),
(45,10,'4:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,  '6:00', NULL,'F',FALSE,FALSE,FALSE),
(45,15,'4:20','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,8,  '13:00',0.5, 'H',FALSE,FALSE,FALSE),
(45,15,'4:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5,  '10:00',NULL,'H',FALSE,FALSE,FALSE),
(45,20,'4:00','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,   15, '21:40',0.5, 'K',TRUE,FALSE,FALSE),
(45,20,'4:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,   8,  '13:40',NULL,'K',TRUE,FALSE,FALSE),
(45,25,'4:00','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,7,   29, '40:40',1,   'M',TRUE,FALSE,FALSE),
(45,25,'4:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,4,   14, '22:40',NULL,'M',TRUE,FALSE,FALSE),
(45,30,'3:40','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,4,   7,   45, '60:20',1.5, 'O',TRUE,FALSE,FALSE),
(45,30,'3:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,4,   4,   22, '34:40',NULL,'O',TRUE,FALSE,FALSE),
(45,35,'3:40','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,6,   7,   74, '91:20',1.5, 'Z',FALSE,TRUE,FALSE),
(45,35,'3:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,6,   4,   30, '44:40',NULL,'Z',FALSE,TRUE,FALSE),
(45,40,'3:20','AIRE',  NULL,NULL,NULL,NULL,NULL,2,   6,   14,  106,'132:00',2,   'Z',FALSE,TRUE,FALSE),
(45,40,'3:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,2,   6,   7,   35, '59:20', NULL,'Z',FALSE,TRUE,FALSE),
(45,45,'3:20','AIRE',  NULL,NULL,NULL,NULL,NULL,3,   8,   24,  142,'181:00',2,   'Z',FALSE,TRUE,FALSE),
(45,45,'3:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,3,   8,   12,  40, '72:20', NULL,'Z',FALSE,TRUE,FALSE),
(45,50,'3:20','AIRE',  NULL,NULL,NULL,NULL,NULL,4,   14,  28,  170,'220:00',2.5, 'Z',FALSE,TRUE,FALSE),
(45,50,'3:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,4,   14,  14,  46, '87:20', NULL,'Z',FALSE,TRUE,FALSE),
(45,55,'3:20','AIRE',  NULL,NULL,NULL,NULL,NULL,7,   21,  28,  212,'272:00',3,   NULL,FALSE,FALSE,TRUE),
(45,55,'3:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,7,   21,  14,  57, '113:20',NULL,NULL,FALSE,FALSE,TRUE),
(45,60,'3:20','AIRE',  NULL,NULL,NULL,NULL,NULL,11,  26,  28,  248,'317:00',3,   NULL,FALSE,FALSE,TRUE),
(45,60,'3:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,11,  26,  14,  67, '132:20',NULL,NULL,FALSE,FALSE,TRUE),
(45,70,'3:00','AIRE',  NULL,NULL,NULL,NULL,3,   24,  25,  28,  330,'413:40',4,   NULL,FALSE,FALSE,TRUE),
(45,70,'3:00','AIRE_O2',NULL,NULL,NULL,NULL,3,   24,  25,  14,  85, '170:00',NULL,NULL,FALSE,FALSE,TRUE),
(45,80,'3:00','AIRE',  NULL,NULL,NULL,NULL,15,  23,  26,  35,  430,'532:40',4.5, NULL,FALSE,FALSE,TRUE),
(45,80,'3:00','AIRE_O2',NULL,NULL,NULL,NULL,15,  23,  26,  18,  104,'205:00',NULL,NULL,FALSE,FALSE,TRUE),
(45,90,'2:40','AIRE',  NULL,NULL,NULL,3,   22,  23,  26,  47,  496,'620:20',5.5, NULL,FALSE,FALSE,TRUE),
(45,90,'2:40','AIRE_O2',NULL,NULL,NULL,3,   22,  23,  26,  24,  118,'239:40',NULL,NULL,FALSE,FALSE,TRUE),
(45,120,'2:20','AIRE', NULL,NULL,3,   20,  22,  23,  50,  75,  608,'804:00',8,   NULL,FALSE,FALSE,TRUE),
(45,120,'2:20','AIRE_O2',NULL,NULL,3,   20,  22,  23,  50,  37,  168,'356:20',NULL,NULL,FALSE,FALSE,TRUE),
(45,180,'2:00','AIRE', NULL,2,   19,  20,  42,  48,  79,  121, 694,'1027:40',10.5,NULL,FALSE,FALSE,TRUE),
(45,180,'2:00','AIRE_O2',NULL,2,   19,  20,  42,  48,  79,  58,  222,'538:00', NULL,NULL,FALSE,FALSE,TRUE),

-- profundidad 48 mca
(48,7,'5:20','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,  '5:20', 0,   'E',FALSE,FALSE,FALSE),
(48,7,'5:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,  '5:20', NULL,'E',FALSE,FALSE,FALSE),
(48,10,'4:40','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,4,  '9:20', 0.5, 'F',FALSE,FALSE,FALSE),
(48,10,'4:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,  '7:20', NULL,'F',FALSE,FALSE,FALSE),
(48,15,'4:20','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,   10, '17:00',0.5, 'I',FALSE,FALSE,FALSE),
(48,15,'4:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,   6,  '12:00',NULL,'I',FALSE,FALSE,FALSE),
(48,20,'4:00','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,1,   4,  19,'28:40',0.5,'L',TRUE,FALSE,FALSE),
(48,20,'4:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,1,   2,  10,'18:00',NULL,'L',TRUE,FALSE,FALSE),
(48,25,'4:00','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,4,   7,   35, '50:40', 1,   'N',TRUE,FALSE,FALSE),
(48,25,'4:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,4,   4,   17, '30:00', NULL,'N',TRUE,FALSE,FALSE),
(48,30,'3:40','AIRE',  NULL,NULL,NULL,NULL,NULL,2,   6,   7,   62, '81:20', 1.5, 'Z',TRUE,FALSE,FALSE),
(48,30,'3:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,2,   6,   4,   26, '42:40', NULL,'Z',TRUE,FALSE,FALSE),
(48,35,'3:40','AIRE',  NULL,NULL,NULL,NULL,NULL,4,   6,   8,   89, '111:20',1.5, 'Z',FALSE,TRUE,FALSE),
(48,35,'3:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,4,   6,   4,   34, '57:40', NULL,'Z',FALSE,TRUE,FALSE),
(48,40,'3:40','AIRE',  NULL,NULL,NULL,NULL,NULL,6,   6,   21,  134,'171:20',2,   'Z',FALSE,TRUE,FALSE),
(48,40,'3:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,6,   6,   11,  38, '70:40', NULL,'Z',FALSE,TRUE,FALSE),
(48,45,'3:20','AIRE',  NULL,NULL,NULL,NULL,2,   5,   11,  28,  166,'216:00',2.5, 'Z',FALSE,TRUE,FALSE),
(48,45,'3:20','AIRE_O2',NULL,NULL,NULL,NULL,2,   5,   11,  14,  45, '86:20', NULL,'Z',FALSE,TRUE,FALSE),
(48,50,'3:20','AIRE',  NULL,NULL,NULL,NULL,2,   8,   19,  28,  207,'268:00',3,   NULL,FALSE,FALSE,TRUE),
(48,50,'3:20','AIRE_O2',NULL,NULL,NULL,NULL,2,   8,   19,  15,  55, '113:20',NULL,NULL,FALSE,FALSE,TRUE),
(48,55,'3:20','AIRE',  NULL,NULL,NULL,NULL,3,   11,  26,  28,  248,'320:00',3,   NULL,FALSE,FALSE,TRUE),
(48,55,'3:20','AIRE_O2',NULL,NULL,NULL,NULL,3,   11,  26,  14,  67, '135:20',NULL,NULL,FALSE,FALSE,TRUE),
(48,60,'3:20','AIRE',  NULL,NULL,NULL,NULL,6,   17,  25,  29,  291,'372:00',3.5, NULL,FALSE,FALSE,TRUE),
(48,60,'3:20','AIRE_O2',NULL,NULL,NULL,NULL,6,   17,  25,  15,  77, '154:20',NULL,NULL,FALSE,FALSE,TRUE),
(48,70,'3:20','AIRE',  NULL,NULL,NULL,NULL,15,  23,  26,  29,  399,'496:00',4.5, NULL,FALSE,FALSE,TRUE),
(48,70,'3:20','AIRE_O2',NULL,NULL,NULL,NULL,15,  23,  26,  15,  99, '197:20',NULL,NULL,FALSE,FALSE,TRUE),
(48,80,'3:00','AIRE',  NULL,NULL,NULL,6,   21,  24,  25,  44,  482,'605:40',5.5, NULL,FALSE,FALSE,TRUE),
(48,80,'3:00','AIRE_O2',NULL,NULL,NULL,6,   21,  24,  25,  23,  114,'237:00',NULL,NULL,FALSE,FALSE,TRUE),

-- profundidad 51 mca
(51,6,'5:40','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,  '5:40', 0,   'D',FALSE,FALSE,FALSE),
(51,6,'5:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,  '5:40', NULL,'D',FALSE,FALSE,FALSE),
(51,10,'5:00','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,6,  '11:40',0.5, 'G',FALSE,FALSE,FALSE),
(51,10,'5:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,3,  '8:40', NULL,'G',FALSE,FALSE,FALSE),
(51,15,'4:40','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,3,   13, '21:20',0.5, 'J',TRUE,FALSE,FALSE),
(51,15,'4:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,   6,  '13:20',NULL,'J',TRUE,FALSE,FALSE),
(51,20,'4:20','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,3,   6,   24, '38:00',1,   'M',TRUE,FALSE,FALSE),
(51,20,'4:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,3,   3,   12, '23:20',NULL,'M',TRUE,FALSE,FALSE),
(51,25,'4:00','AIRE',  NULL,NULL,NULL,NULL,NULL,1,   7,   7,   41, '60:40',1,   'O',TRUE,FALSE,FALSE),
(51,25,'4:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,1,   7,   4,   20, '37:00',NULL,'O',TRUE,FALSE,FALSE),
(51,30,'4:00','AIRE',  NULL,NULL,NULL,NULL,NULL,5,   7,   7,   77, '100:40',1.5, 'Z',FALSE,TRUE,FALSE),
(51,30,'4:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,5,   7,   3,   30, '50:00', NULL,'Z',FALSE,TRUE,FALSE),
(51,35,'3:40','AIRE',  NULL,NULL,NULL,NULL,2,   6,   6,   15,  120,'153:20',2,   'Z',FALSE,TRUE,FALSE),
(51,35,'3:40','AIRE_O2',NULL,NULL,NULL,NULL,2,   6,   6,   8,   37, '68:40', NULL,'Z',FALSE,TRUE,FALSE),
(51,40,'3:40','AIRE',  NULL,NULL,NULL,NULL,4,   6,   9,   25,  158,'206:20',2.5, 'Z',FALSE,TRUE,FALSE),
(51,40,'3:40','AIRE_O2',NULL,NULL,NULL,NULL,4,   6,   9,   12,  44, '84:40', NULL,'Z',FALSE,TRUE,FALSE),
(51,45,'3:40','AIRE',  NULL,NULL,NULL,NULL,5,   7,   16,  28,  197,'257:20',2.5, 'Z',FALSE,FALSE,TRUE),
(51,45,'3:40','AIRE_O2',NULL,NULL,NULL,NULL,5,   7,   16,  14,  53, '109:40',NULL,'Z',FALSE,FALSE,TRUE),
(51,50,'3:20','AIRE',  NULL,NULL,NULL,1,   5,   11,  23,  28,  244,'316:00',3,   NULL,FALSE,FALSE,TRUE),
(51,50,'3:20','AIRE_O2',NULL,NULL,NULL,1,   5,   11,  23,  14,  66, '134:20',NULL,NULL,FALSE,FALSE,TRUE),
(51,55,'3:20','AIRE',  NULL,NULL,NULL,2,   7,   16,  26,  28,  289,'372:00',3.5, NULL,FALSE,FALSE,TRUE),
(51,55,'3:20','AIRE_O2',NULL,NULL,NULL,2,   7,   16,  26,  14,  77, '156:20',NULL,NULL,FALSE,FALSE,TRUE),
(51,60,'3:20','AIRE',  NULL,NULL,NULL,2,   11,  21,  26,  28,  344,'436:00',4,   NULL,FALSE,FALSE,TRUE),
(51,60,'3:20','AIRE_O2',NULL,NULL,NULL,2,   11,  21,  26,  14,  88, '181:20',NULL,NULL,FALSE,FALSE,TRUE),
(51,70,'3:20','AIRE',  NULL,NULL,NULL,7,   19,  24,  25,  39,  454,'572:00',5,   NULL,FALSE,FALSE,TRUE),
(51,70,'3:20','AIRE_O2',NULL,NULL,NULL,7,   19,  24,  25,  20,  109,'228:20',NULL,NULL,FALSE,FALSE,TRUE),
(51,80,'3:20','AIRE',  NULL,NULL,NULL,17,  22,  23,  26,  53,  525,'670:00',6,   NULL,FALSE,FALSE,TRUE),
(51,80,'3:20','AIRE_O2',NULL,NULL,NULL,17,  22,  23,  26,  27,  128,'267:20',NULL,NULL,FALSE,FALSE,TRUE),
(51,90,'3:00','AIRE',  NULL,NULL,8,   19,  22,  23,  37,  66,  574,'752:40',7,   NULL,FALSE,FALSE,TRUE),
(51,90,'3:00','AIRE_O2',NULL,NULL,8,   19,  22,  23,  37,  33,  148,'319:00',NULL,NULL,FALSE,FALSE,TRUE),
(51,120,'2:40','AIRE', NULL,9,   19,  20,  22,  42,  60,  94,  659,'928:20',9,   NULL,FALSE,FALSE,TRUE),
(51,120,'2:40','AIRE_O2',NULL,9,   19,  20,  22,  42,  60,  46,  198,'454:40',NULL,NULL,FALSE,FALSE,TRUE),
(51,180,'2:20','AIRE', 10,  18,  19,  40,  43,  70,  97,  156, 703,'1159:00',11.5,NULL,FALSE,FALSE,TRUE),
(51,180,'2:20','AIRE_O2',10,  18,  19,  40,  43,  70,  97,  74,  229,'648:00', NULL,NULL,FALSE,FALSE,TRUE),

-- profundidad 54 mca
(54,6,'6:00','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,  '6:00', 0,   'E',FALSE,FALSE,FALSE),
(54,6,'6:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,  '6:00', NULL,'E',FALSE,FALSE,FALSE),
(54,10,'5:20','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,8,  '14:00',0.5, 'G',FALSE,FALSE,FALSE),
(54,10,'5:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,4,  '10:00',NULL,'G',FALSE,FALSE,FALSE),
(54,15,'4:40','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,2,   3,   14, '24:20',0.5, 'K',TRUE,FALSE,FALSE),
(54,15,'4:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,2,   2,   7,  '16:40',NULL,'K',TRUE,FALSE,FALSE),
(54,20,'4:20','AIRE',  NULL,NULL,NULL,NULL,NULL,1,   5,   7,   29, '47:00',1,   'M',TRUE,FALSE,FALSE),
(54,20,'4:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,1,   5,   3,   15, '29:20',NULL,'M',TRUE,FALSE,FALSE),
(54,25,'4:20','AIRE',  NULL,NULL,NULL,NULL,NULL,5,   6,   7,   57, '80:00',1.5, 'O',TRUE,FALSE,FALSE),
(54,25,'4:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,5,   6,   4,   24, '44:20',NULL,'O',TRUE,FALSE,FALSE),
(54,30,'4:00','AIRE',  NULL,NULL,NULL,NULL,3,   6,   6,   7,   95, '121:40',1.5, 'Z',FALSE,TRUE,FALSE),
(54,30,'4:00','AIRE_O2',NULL,NULL,NULL,NULL,3,   6,   6,   4,   34, '63:00', NULL,'Z',FALSE,TRUE,FALSE),
(54,35,'3:40','AIRE',  NULL,NULL,NULL,1,   5,   6,   6,   22,  144,'188:20',2,   'Z',FALSE,TRUE,FALSE),
(54,35,'3:40','AIRE_O2',NULL,NULL,NULL,1,   5,   6,   6,   11,  41, '79:40', NULL,'Z',FALSE,TRUE,FALSE),
(54,40,'3:40','AIRE',  NULL,NULL,NULL,2,   6,   5,   13,  28,  178,'236:20',2.5, NULL,FALSE,FALSE,TRUE),
(54,40,'3:40','AIRE_O2',NULL,NULL,NULL,2,   6,   5,   13,  14,  48, '97:40', NULL,NULL,FALSE,FALSE,TRUE),
(54,45,'3:40','AIRE',  NULL,NULL,NULL,4,   5,   10,  20,  28,  235,'306:20',3,   NULL,FALSE,FALSE,TRUE),
(54,45,'3:40','AIRE_O2',NULL,NULL,NULL,4,   5,   10,  20,  14,  63, '130:40',NULL,NULL,FALSE,FALSE,TRUE),
(54,50,'3:40','AIRE',  NULL,NULL,NULL,4,   8,   13,  25,  29,  277,'360:20',3.5, NULL,FALSE,FALSE,TRUE),
(54,50,'3:40','AIRE_O2',NULL,NULL,NULL,4,   8,   13,  25,  15,  75, '154:40',NULL,NULL,FALSE,FALSE,TRUE),
(54,55,'3:40','AIRE',  NULL,NULL,NULL,5,   11,  19,  26,  28,  336,'429:20',4,   NULL,FALSE,FALSE,TRUE),
(54,55,'3:40','AIRE_O2',NULL,NULL,NULL,5,   11,  19,  26,  14,  87, '181:40',NULL,NULL,FALSE,FALSE,TRUE),
(54,60,'3:20','AIRE',  NULL,NULL,1,   8,   13,  23,  25,  31,  406,'511:00',4.5, NULL,FALSE,FALSE,TRUE),
(54,60,'3:20','AIRE_O2',NULL,NULL,1,   8,   13,  23,  25,  16,  100,'205:20',NULL,NULL,FALSE,FALSE,TRUE),
(54,70,'3:20','AIRE',  NULL,NULL,4,   12,  21,  24,  25,  48,  499,'637:00',5.5, NULL,FALSE,FALSE,TRUE),
(54,70,'3:20','AIRE_O2',NULL,NULL,4,   12,  21,  24,  25,  24,  119,'253:20',NULL,NULL,FALSE,FALSE,TRUE),

-- profundidad 57 mca
(57,5,'6:20','AIRE',   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,  '6:20', 0,   'D',FALSE,FALSE,FALSE),
(57,5,'6:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,  '6:20', NULL,'D',FALSE,FALSE,FALSE),
(57,10,'5:20','AIRE',  NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,   8,  '16:00',0.5, 'H',FALSE,FALSE,FALSE),
(57,10,'5:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,   4,  '11:00',NULL,'H',FALSE,FALSE,FALSE),
(57,15,'4:40','AIRE',  NULL,NULL,NULL,NULL,NULL,1,   3,   3,   16, '28:20',0.5, 'K',TRUE,FALSE,FALSE),
(57,15,'4:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,1,   3,   2,   8,  '19:40',NULL,'K',TRUE,FALSE,FALSE),
(57,20,'4:20','AIRE',  NULL,NULL,NULL,NULL,1,   2,   6,   7,   34, '55:00',1,   'N',TRUE,FALSE,FALSE),
(57,20,'4:20','AIRE_O2',NULL,NULL,NULL,NULL,1,   2,   6,   4,   17, '35:20',NULL,'N',TRUE,FALSE,FALSE),
(57,25,'4:20','AIRE',  NULL,NULL,NULL,NULL,2,   6,   7,   7,   72, '99:00',1.5, 'Z',FALSE,TRUE,FALSE),
(57,25,'4:20','AIRE_O2',NULL,NULL,NULL,NULL,2,   6,   7,   3,   28, '51:20', NULL,'Z',FALSE,TRUE,FALSE),
(57,30,'4:00','AIRE',  NULL,NULL,NULL,1,   6,   5,   7,   13,  122,'158:40',2,   'Z',FALSE,TRUE,FALSE),
(57,30,'4:00','AIRE_O2',NULL,NULL,NULL,1,   6,   5,   7,   7,   38, '74:00', NULL,'Z',FALSE,TRUE,FALSE),
(57,35,'4:00','AIRE',  NULL,NULL,NULL,4,   5,   6,   8,   26,  165,'218:40',2.5, 'Z',FALSE,FALSE,TRUE),
(57,35,'4:00','AIRE_O2',NULL,NULL,NULL,4,   5,   6,   8,   13,  45, '91:00', NULL,'Z',FALSE,FALSE,TRUE),
(57,40,'3:40','AIRE',  NULL,NULL,1,   5,   5,   8,   17,  28,  217,'285:20',3,   NULL,FALSE,FALSE,TRUE),
(57,40,'3:40','AIRE_O2',NULL,NULL,1,   5,   5,   8,   17,  15,  58, '123:40',NULL,NULL,FALSE,FALSE,TRUE),
(57,45,'3:40','AIRE',  NULL,NULL,2,   5,   6,   12,  24,  29,  264,'346:20',3.5, NULL,FALSE,FALSE,TRUE),
(57,45,'3:40','AIRE_O2',NULL,NULL,2,   5,   6,   12,  24,  15,  71, '149:40',NULL,NULL,FALSE,FALSE,TRUE),
(57,50,'3:40','AIRE',  NULL,NULL,3,   5,   10,  17,  26,  28,  324,'417:20',4,   NULL,FALSE,FALSE,TRUE),
(57,50,'3:40','AIRE_O2',NULL,NULL,3,   5,   10,  17,  26,  14,  85, '179:40',NULL,NULL,FALSE,FALSE,TRUE),
(57,55,'3:40','AIRE',  NULL,NULL,4,   8,   10,  24,  25,  30,  397,'502:20',4.5, NULL,FALSE,FALSE,TRUE),
(57,55,'3:40','AIRE_O2',NULL,NULL,4,   8,   10,  24,  25,  15,  99, '204:40',NULL,NULL,FALSE,FALSE,TRUE),
(57,60,'3:40','AIRE',  NULL,NULL,5,   10,  16,  24,  25,  40,  454,'578:20',5,   NULL,FALSE,FALSE,TRUE),
(57,60,'3:40','AIRE_O2',NULL,NULL,5,   10,  16,  24,  25,  20,  109,'233:40',NULL,NULL,FALSE,FALSE,TRUE),
(57,90,'3:20','AIRE',  NULL,11,  19,  20,  21,  28,  51,  83,  626,'863:00',8.5, NULL,FALSE,FALSE,TRUE),
(57,90,'3:20','AIRE_O2',NULL,11,  19,  20,  21,  28,  51,  41,  178,'408:20',NULL,NULL,FALSE,FALSE,TRUE),
(57,120,'3:00','AIRE', 15,  17,  19,  20,  37,  46,  79,  113, 691,'1040:40',10.5,NULL,FALSE,FALSE,TRUE),
(57,120,'3:00','AIRE_O2',15,  17,  19,  20,  37,  46,  79,  55,  219,'551:00', NULL,NULL,FALSE,FALSE,TRUE);

-- ============================================================
--  TABLA III EXCEPCIONALES
-- ============================================================

INSERT INTO tabla_III_excep (profundidad, tiempo_fondo, t_primera_parada, mezcla,
                        d_39, d_36, d_33, d_30, d_27, d_24, d_21, d_18, d_15, d_12, d_9, d_6,
                        tiempo_total_ascenso, periodos_o2_camara, grupo_inmersion) VALUES

-- profundidad 60 mca (Exposicion Excepcional)
(60,5 ,'6:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'6:40',0,'E'),
(60,5 ,'6:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'6:40',NULL,'E'),
(60,10,'5:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,3,8,'17:20',0.5,'H'),
(60,10,'5:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,4,'12:20',NULL,'H'),
(60,15,'5:00','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,3,5,19,'34:40',0.5,'L'),
(60,15,'5:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,3,3,9, '23:00',NULL,'L'),
(60,20,'4:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,4,6,7,43,'67:20',1,'O'),
(60,20,'4:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,4,6,4,20,'41:40',NULL,'O'),
(60,25,'4:20','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,1,5,6,6,7,85, '115:00',1.5,'Z'),
(60,25,'4:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,1,5,6,6,4,32,'64:20',NULL,'Z'),
(60,30,'4:20','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,4,6,5,7,19,145,'191:00',2,'Z'),
(60,30,'4:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,4,6,5,7,10,42,'84:20',NULL,'Z'),
(60,35,'4:00','AIRE'   ,NULL,NULL,NULL,NULL,NULL,2,5,5,6,13,28,188,'251:40',2.5,NULL),
(60,35,'4:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,2,5,5,6,13,14,51,'106:00',NULL,NULL),
(60,40,'4:00','AIRE'   ,NULL,NULL,NULL,NULL,NULL,4,5,5,11,21,28,249,'327:40',3.5,NULL),
(60,40,'4:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,4,5,5,11,21,14,68,'143:00',NULL,NULL),
(60,45,'3:40','AIRE'   ,NULL,NULL,NULL,NULL,1,4,5,10,14,25,28,306,'397:20',3.5,NULL),
(60,45,'3:40','AIRE_O2',NULL,NULL,NULL,NULL,1,4,5,10,14,25,14,81,'168:40',NULL,NULL),
(60,50,'3:40','AIRE'   ,NULL,NULL,NULL,NULL,2,4,8,10,21,26,28,382,'485:20',4.5,NULL),
(60,50,'3:40','AIRE_O2',NULL,NULL,NULL,NULL,2,4,8,10,21,26,14,97,'201:40',NULL,NULL),

-- profundidad 63 mca (Exposición Excepcional)
(63,4 ,'7:00','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'7:00',0,'D'),
(63,4 ,'7:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'7:00',NULL,'D'),
(63,5 ,'6:20','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,'9:00',0.5,'E'),
(63,5 ,'6:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'8:00',NULL,'E'),
(63,10,'5:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,3,9,'20:20',0.5,'I'),
(63,10,'5:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,2,4,'14:40',NULL,'I'),
(63,15,'5:00','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,3,3,6,24,'42:40',1,'M'),
(63,15,'5:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,3,3,3,12,'28:00',NULL,'M'),
(63,20,'4:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,1,3,5,6,7,57,'84:20',1,'O'),
(63,20,'4:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,1,3,5,6,4,23,'47:40',NULL,'O'),
(63,25,'4:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,3,6,5,7,8,110,'144:20',2,'Z'),
(63,25,'4:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,3,6,5,7,4,38,'73:40',NULL,'Z'),
(63,30,'4:20','AIRE'   ,NULL,NULL,NULL,NULL,NULL,2,5,6,6,6,26,163,'219:00',2.5,'Z'),
(63,30,'4:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,2,5,6,6,6,13,45,'93:20',NULL,'Z'),
(63,35,'4:00','AIRE'   ,NULL,NULL,NULL,NULL,1,4,5,6,7,8,28,223,'296:40',3,NULL),
(63,35,'4:00','AIRE_O2',NULL,NULL,NULL,NULL,1,4,5,6,7,18,14,60,'130:00',NULL,NULL),
(63,40,'4:00','AIRE'   ,NULL,NULL,NULL,NULL,2,5,5,7,11,26,28,278,'366:40',3.5,NULL),
(63,40,'4:00','AIRE_O2',NULL,NULL,NULL,NULL,2,5,5,7,11,26,14,76,'161:00',NULL,NULL),
(63,45,'4:00','AIRE'   ,NULL,NULL,NULL,NULL,4,4,6,11,18,26,28,355,'456:40',4,NULL),
(63,45,'4:00','AIRE_O2',NULL,NULL,NULL,NULL,4,4,6,11,18,26,14,91,'194:00',NULL,NULL),
(63,50,'3:40','AIRE'   ,NULL,NULL,NULL,1,4,5,10,12,23,26,36,432,'553:20',5,NULL),
(63,50,'3:40','AIRE_O2',NULL,NULL,NULL,1,4,5,10,12,23,26,18,105,'223:40',NULL,NULL),

-- profundidad 66 mca (Exposicion Excepcional)
(66,4,'7:20' ,'AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'7:20', 0,'E'),
(66,4,'7:20' ,'AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'7:20', NULL,'E'),
(66,5,'6:40' ,'AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,3,'10:20',0.5,'E'),
(66,5,'6:40' ,'AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,'9:20', NULL,'E'),
(66,10,'6:00','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,3,4,10,'23:40',0.5,'J'),
(66,10,'6:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,3,2,5,'17:00',NULL,'J'),
(66,15,'5:20','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,3,2,4,7,28,'50:00',1,'N'),
(66,15,'5:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,3,2,4,4,14,'33:20',NULL,'N'),
(66,20,'5:00','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,2,4,6,6,7,70,'100:40',1.5,'Z'),
(66,20,'5:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,2,4,6,6,4,26,'54:00',NULL,'Z'),
(66,25,'4:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,1,5,6,6,6,14,133,'176:20',2,'Z'),
(66,25,'4:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,1,5,6,6,6,7,41,'82:40',NULL,'Z'),
(66,30,'4:20','AIRE'   ,NULL,NULL,NULL,NULL,1,4,5,6,6,10,28,183,'248:00',2.5,NULL),
(66,30,'4:20','AIRE_O2',NULL,NULL,NULL,NULL,1,4,5,6,6,10,14,50,'106:20',NULL,NULL),
(66,35,'4:20','AIRE'   ,NULL,NULL,NULL,NULL,3,5,5,5,10,22,28,251,'334:00',3.5,NULL),
(66,35,'4:20','AIRE_O2',NULL,NULL,NULL,NULL,3,5,5,5,10,22,14,68,'147:20',NULL,NULL),
(66,40,'4:00','AIRE'   ,NULL,NULL,NULL,1,4,5,5,9,15,26,28,319,'416:40',4,NULL),
(66,40,'4:00','AIRE_O2',NULL,NULL,NULL,1,4,5,5,9,15,26,14,84,'183:00',NULL,NULL),

-- profundidad 75 mca (Exposicion Excepcional)
(75,4 ,'7:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,4,'12:20',0.5,'F'),
(75,4 ,'7:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,'10:20',NULL,'F'),
(75,5 ,'7:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,7,'15:20',0.5,'G'),
(75,5 ,'7:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,4,'12:20',NULL,'G'),
(75,10,'6:20','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,2,4,3,15,'33:00',0.5,'L'),
(75,10,'6:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,2,4,2,7,'24:20',NULL,'L'),
(75,15,'5:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,2,2,3,4,6,7,53,'83:20',1,'O'),
(75,15,'5:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,2,2,3,4,6,4,22,'49:40',NULL,'O'),
(75,20,'5:20','AIRE'   ,NULL,NULL,NULL,NULL,2,2,4,6,6,6,11,125,'168:00',2,'Z'),
(75,20,'5:20','AIRE_O2',NULL,NULL,NULL,NULL,2,2,4,6,6,6,6,39,'82:20',NULL,'Z'),
(75,25,'5:00','AIRE'   ,NULL,NULL,NULL,1,4,4,5,6,6,10,28,189,'258:40',2.5,NULL),
(75,25,'5:00','AIRE_O2',NULL,NULL,NULL,1,4,4,5,6,6,10,14,51,'112:00',NULL,NULL),
(75,30,'4:40','AIRE'   ,NULL,NULL,1,4,4,4,5,6,9,25,28,267,'358:20',3.5,NULL),
(75,30,'4:40','AIRE_O2',NULL,NULL,1,4,4,4,5,6,9,25,15,72,'160:40',NULL,NULL),
(75,35,'4:40','AIRE'   ,NULL,NULL,3,4,4,5,5,10,19,26,28,363,'472:20',4,NULL),
(75,35,'4:40','AIRE_O2',NULL,NULL,3,4,4,5,5,10,19,26,14,93,'203:40',NULL,NULL),

-- profundidad 90 mca (Exposición Excepcional)
(90,4 ,'9:00','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,3,7,'19:40',0.5,'G'),
(90,4 ,'9:00','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,4,'15:40',NULL,'G'),
(90,5 ,'8:40','AIRE'   ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,3,2,8,'23:20',0.5,'I'),
(90,5 ,'8:40','AIRE_O2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,3,2,4,'18:40',NULL,'I'),
(90,10,'7:20','AIRE'   ,NULL,NULL,NULL,NULL,NULL,2,3,2,3,4,7,35,'64:00',1,'N'),
(90,10,'7:20','AIRE_O2',NULL,NULL,NULL,NULL,NULL,2,3,2,3,4,4,18,'44:20',NULL,'N'),
(90,15,'6:20','AIRE'   ,NULL,NULL,1,2,2,3,3,5,6,7,11,125,'172:00',2,'Z'),
(90,15,'6:20','AIRE_O2',NULL,NULL,1,2,2,3,3,5,6,7,6,39,'86:20',NULL,'Z'),
(90,20,'6:00','AIRE'   ,NULL,2,2,2,4,5,5,5,6,16,28,219,'300:40',3,NULL),
(90,20,'6:00','AIRE_O2',NULL,2,2,2,4,5,5,5,6,16,14,59,'137:00',NULL,NULL),
(90,25,'5:40','AIRE'   ,1,3,4,4,4,5,5,5,18,26,28,324,'433:20',4,NULL),
(90,25,'5:40','AIRE_O2',1,3,4,4,4,5,5,5,18,26,14,85,'195:40',NULL,NULL);

-- ============================================================
--  TABLA IV — Profundidad teórica para inmersiones en altitud y profundidad real de
--  las paradas de descompresión para inmersiones en altitud
-- ============================================================
-- ============================================================
--  TABLA IV INMERSION
-- ============================================================

INSERT INTO tabla_IV_profundidad (profundidad_real, altitud_m, profundidad_teorica) VALUES
-- profundidad real 3 mca
(3, 300, 3), (3, 600, 4.5), (3, 900, 4.5), (3, 1200, 4.5), (3, 1500, 4.5),
(3, 1800, 4.5), (3, 2100, 4.5), (3, 2400, 4.5), (3, 2700, 4.5), (3, 3000, 4.5),
-- profundidad real 4.5 mca
(4.5, 300, 4.5), (4.5, 600, 6), (4.5, 900, 6), (4.5, 1200, 6), (4.5, 1500, 6),
(4.5, 1800, 6), (4.5, 2100, 6), (4.5, 2400, 7.5), (4.5, 2700, 7.5), (4.5, 3000, 7.5),
-- profundidad real 6 mca
(6, 300, 6), (6, 600, 7.5), (6, 900, 7.5), (6, 1200, 7.5), (6, 1500, 7.5),
(6, 1800, 7.5), (6, 2100, 9), (6, 2400, 9), (6, 2700, 9), (6, 3000, 9),
-- profundidad real 7.5 mca
(7.5, 300, 7.5), (7.5, 600, 9), (7.5, 900, 9), (7.5, 1200, 9), (7.5, 1500, 10.5),
(7.5, 1800, 10.5), (7.5, 2100, 10.5), (7.5, 2400, 10.5), (7.5, 2700, 10.5), (7.5, 3000, 12),
-- profundidad real 9 mca
(9, 300, 9), (9, 600, 10.5), (9, 900, 10.5), (9, 1200, 10.5), (9, 1500, 12),
(9, 1800, 12), (9, 2100, 12), (9, 2400, 13.5), (9, 2700, 13.5), (9, 3000, 13.5),
-- profundidad real 10.5 mca
(10.5, 300, 10.5), (10.5, 600, 12), (10.5, 900, 12), (10.5, 1200, 13.5), (10.5, 1500, 13.5),
(10.5, 1800, 13.5), (10.5, 2100, 15), (10.5, 2400, 15), (10.5, 2700, 15), (10.5, 3000, 18),
-- profundidad real 12 mca
(12, 300, 12), (12, 600, 13.5), (12, 900, 13.5), (12, 1200, 15), (12, 1500, 15),
(12, 1800, 15), (12, 2100, 16.5), (12, 2400, 16.5), (12, 2700, 18), (12, 3000, 18),
-- profundidad real 13.5 mca
(13.5, 300, 13.5), (13.5, 600, 15), (13.5, 900, 16.5), (13.5, 1200, 16.5), (13.5, 1500, 16.5),
(13.5, 1800, 18), (13.5, 2100, 18), (13.5, 2400, 21), (13.5, 2700, 21), (13.5, 3000, 21),
-- profundidad real 15 mca
(15, 300, 15), (15, 600, 16.5), (15, 900, 18), (15, 1200, 18), (15, 1500, 21),
(15, 1800, 21), (15, 2100, 21), (15, 2400, 21), (15, 2700, 21), (15, 3000, 24),
-- profundidad real 16.5 mca
(16.5, 300, 16.5), (16.5, 600, 18), (16.5, 900, 21), (16.5, 1200, 21), (16.5, 1500, 21),
(16.5, 1800, 21), (16.5, 2100, 24), (16.5, 2400, 24), (16.5, 2700, 24), (16.5, 3000, 24),
-- profundidad real 18 mca
(18, 300, 18), (18, 600, 21), (18, 900, 21), (18, 1200, 21), (18, 1500, 24),
(18, 1800, 24), (18, 2100, 24), (18, 2400, 27), (18, 2700, 27), (18, 3000, 27),
-- profundidad real 19.5 mca
(19.5, 300, 19.5), (19.5, 600, 21), (19.5, 900, 24), (19.5, 1200, 24), (19.5, 1500, 24),
(19.5, 1800, 27), (19.5, 2100, 27), (19.5, 2400, 27), (19.5, 2700, 30), (19.5, 3000, 30),
-- profundidad real 21 mca
(21, 300, 21), (21, 600, 24), (21, 900, 24), (21, 1200, 27), (21, 1500, 27),
(21, 1800, 27), (21, 2100, 30), (21, 2400, 30), (21, 2700, 30), (21, 3000, 33),
-- profundidad real 22.5 mca
(22.5, 300, 22.5), (22.5, 600, 27), (22.5, 900, 27), (22.5, 1200, 27), (22.5, 1500, 30),
(22.5, 1800, 30), (22.5, 2100, 30), (22.5, 2400, 33), (22.5, 2700, 33), (22.5, 3000, 33),
-- profundidad real 24 mca
(24, 300, 24), (24, 600, 27), (24, 900, 27), (24, 1200, 30), (24, 1500, 30),
(24, 1800, 30), (24, 2100, 33), (24, 2400, 33), (24, 2700, 36), (24, 3000, 36),
-- profundidad real 25.5 mca
(25.5, 300, 25.5), (25.5, 600, 30), (25.5, 900, 30), (25.5, 1200, 30), (25.5, 1500, 33),
(25.5, 1800, 33), (25.5, 2100, 36), (25.5, 2400, 36), (25.5, 2700, 36), (25.5, 3000, 39),
-- profundidad real 27 mca
(27, 300, 27), (27, 600, 30), (27, 900, 33), (27, 1200, 33), (27, 1500, 33),
(27, 1800, 36), (27, 2100, 36), (27, 2400, 39), (27, 2700, 39), (27, 3000, 42),
-- profundidad real 28.5 mca
(28.5, 300, 28.5), (28.5, 600, 33), (28.5, 900, 33), (28.5, 1200, 33), (28.5, 1500, 36),
(28.5, 1800, 36), (28.5, 2100, 39), (28.5, 2400, 39), (28.5, 2700, 42), (28.5, 3000, 42),
-- profundidad real 30 mca
(30, 300, 30), (30, 600, 33), (30, 900, 36), (30, 1200, 36), (30, 1500, 39),
(30, 1800, 39), (30, 2100, 39), (30, 2400, 42), (30, 2700, 42), (30, 3000, 45),
-- profundidad real 31.5 mca
(31.5, 300, 31.5), (31.5, 600, 36), (31.5, 900, 36), (31.5, 1200, 39), (31.5, 1500, 39),
(31.5, 1800, 42), (31.5, 2100, 42), (31.5, 2400, 45), (31.5, 2700, 45), (31.5, 3000, 48),
-- profundidad real 33 mca
(33, 300, 33), (33, 600, 36), (33, 900, 39), (33, 1200, 39), (33, 1500, 42),
(33, 1800, 42), (33, 2100, 45), (33, 2400, 45), (33, 2700, 48), (33, 3000, 48),
-- profundidad real 34.5 mca
(34.5, 300, 34.5), (34.5, 600, 39), (34.5, 900, 39), (34.5, 1200, 42), (34.5, 1500, 42),
(34.5, 1800, 45), (34.5, 2100, 45), (34.5, 2400, 48), (34.5, 2700, 51), (34.5, 3000, 51),
-- profundidad real 36 mca
(36, 300, 36), (36, 600, 39), (36, 900, 42), (36, 1200, 42), (36, 1500, 45),
(36, 1800, 45), (36, 2100, 48), (36, 2400, 51), (36, 2700, 51), (36, 3000, 54),
-- profundidad real 37.5 mca
(37.5, 300, 37.5), (37.5, 600, 42), (37.5, 900, 42), (37.5, 1200, 45), (37.5, 1500, 48),
(37.5, 1800, 48), (37.5, 2100, 51), (37.5, 2400, 51), (37.5, 2700, 54), (37.5, 3000, 57),
-- profundidad real 39 mca
(39, 300, 39), (39, 600, 42), (39, 900, 45), (39, 1200, 48), (39, 1500, 48),
(39, 1800, 51), (39, 2100, 51), (39, 2400, 54), (39, 2700, 57), (39, 3000, 57),
-- profundidad real 40.5 mca
(40.5, 300, 40.5), (40.5, 600, 45), (40.5, 900, 48), (40.5, 1200, 48), (40.5, 1500, 51),
(40.5, 1800, 51), (40.5, 2100, 54), (40.5, 2400, 57), (40.5, 2700, 57), (40.5, 3000, 60),
-- profundidad real 42 mca
(42, 300, 42), (42, 600, 48), (42, 900, 48), (42, 1200, 51), (42, 1500, 51),
(42, 1800, 54), (42, 2100, 57), (42, 2400, 57), (42, 2700, 60), (42, 3000, 63),
-- profundidad real 43.5 mca
(43.5, 300, 43.5), (43.5, 600, 48), (43.5, 900, 51), (43.5, 1200, 51), (43.5, 1500, 54),
(43.5, 1800, 57), (43.5, 2100, 57), (43.5, 2400, 60), (43.5, 2700, 63),
-- profundidad real 45 mca
(45, 300, 48), (45, 600, 51), (45, 900, 51), (45, 1200, 54), (45, 1500, 57),
(45, 1800, 57), (45, 2100, 60), (45, 2400, 63),
-- profundidad real 46.5 mca
(46.5, 300, 51), (46.5, 600, 51), (46.5, 900, 54), (46.5, 1200, 54), (46.5, 1500, 57),
(46.5, 1800, 60), (46.5, 2100, 63),
-- profundidad real 48 mca
(48, 300, 51), (48, 600, 54), (48, 900, 54), (48, 1200, 57), (48, 1500, 60),
(48, 1800, 60),
-- profundidad real 49.5 mca
(49.5, 300, 54), (49.5, 600, 54), (49.5, 900, 57), (49.5, 1200, 60), (49.5, 1500, 60),
-- profundidad real 51 mca
(51, 300, 54), (51, 600, 57), (51, 900, 57), (51, 1200, 60),
-- profundidad real 52.5 mca
(52.5, 300, 57), (52.5, 600, 57), (52.5, 900, 60),
-- profundidad real 54 mca
(54, 300, 57), (54, 600, 60), (54, 900, 63),
-- profundidad real 55.5 mca
(55.5, 300, 60), (55.5, 600, 60),
-- profundidad real 57 mca
(57, 300, 60);

-- ============================================================
--  TABLA IV PARADAS
-- ============================================================

INSERT INTO tabla_IV_paradas (profundidad_teorica_parada, altitud_m, profundidad_real_parada) VALUES
-- profundidad real parada 6 mca
(6, 300, 5.5), (6, 600, 5.5), (6, 900, 5.5), (6, 1200, 5.0), (6, 1500, 5.0),
(6, 1800, 5.0), (6, 2100, 4.5), (6, 2400, 4.5), (6, 2700, 4.0), (6, 3000, 4.0),
-- profundidad real parada 9 mca
(9, 300, 8.5), (9, 600, 8.5), (9, 900, 8.0), (9, 1200, 8.0), (9, 1500, 7.5),
(9, 1800, 7.0), (9, 2100, 7.0), (9, 2400, 6.5), (9, 2700, 6.5), (9, 3000, 6.5),
-- profundidad real parada 12 mca
(12, 300, 11.5), (12, 600, 11.0), (12, 900, 11.0), (12, 1200, 10.5), (12, 1500, 10.0),
(12, 1800, 9.5), (12, 2100, 9.5), (12, 2400, 9.0), (12, 2700, 8.5), (12, 3000, 8.5),
-- profundidad real parada 15 mca
(15, 300, 14.5), (15, 600, 14.0), (15, 900, 13.5), (15, 1200, 13.0), (15, 1500, 12.5),
(15,1800, 12.0), (15, 2100, 11.5), (15, 2400, 11.0), (15, 2700, 11.0), (15, 3000, 10.0),
-- profundidad real parada 18 mca
(18, 300, 17.5), (18, 600, 17.0), (18, 900, 16.0), (18, 1200, 15.5), (18, 1500, 15.0),
(18, 1800, 14.5), (18, 2100, 14.0), (18, 2400, 13.5), (18, 2700, 13.0), (18, 3000, 12.5);

-- ============================================================
--  TABLA V —  Grupos de Inmersión Sucesiva correspondientes al ascenso inicial a
--  altitud
-- ============================================================

INSERT INTO tabla_V (altitud_m, altitud_pies, grupo_is) VALUES
(300, 1000, 'A'),
(600, 2000, 'A'),
(900, 3000, 'B'),
(1200, 4000, 'C'),
(1500, 5000, 'D'),
(1800, 6000, 'E'),
(2100, 7000, 'F'),
(2400, 8000, 'G'),
(2700, 9000, 'H'),
(3000, 10000, 'I');

-- ============================================================
--  TABLA VI — Intervalo en Superficie exigido antes de volar
-- ============================================================
INSERT INTO tabla_VI (grupo_is, aumento_altitud_m, intervalo_requerido) VALUES
-- grupo A
('A', 300, '0:00'), ('A', 600, '0:00'), ('A', 900, '0:00'), ('A', 1200, '0:00'),
('A', 1500, '0:00'), ('A', 1800, '0:00'), ('A', 2100, '0:00'), ('A', 2400, '0:00'),
('A', 2700, '0:00'), ('A', 3000, '0:00'),
-- grupo B
('B', 300, '0:00'), ('B', 600, '0:00'), ('B', 900, '0:00'), ('B', 1200, '0:00'),
('B', 1500, '0:00'), ('B', 1800, '0:00'), ('B', 2100, '0:00'), ('B', 2400, '0:00'),
('B', 2700, '0:00'), ('B', 3000, '1:42'),
-- grupo C
('C', 300, '0:00'), ('C', 600, '0:00'), ('C', 900, '0:00'), ('C', 1200, '0:00'),
('C', 1500, '0:00'), ('C', 1800, '0:00'), ('C', 2100, '0:00'), ('C', 2400, '0:00'),
('C', 2700, '1:48'), ('C', 3000, '6:23'),
-- grupo D
('D', 300, '0:00'), ('D', 600, '0:00'), ('D', 900, '0:00'), ('D', 1200, '0:00'),
('D', 1500, '0:00'), ('D', 1800, '0:00'), ('D', 2100, '0:00'), ('D', 2400, '1:45'),
('D', 2700, '5:24'), ('D', 3000, '9:59'),
-- grupo E
('E', 300, '0:00'), ('E', 600, '0:00'), ('E', 900, '0:00'), ('E', 1200, '0:00'),
('E', 1500, '0:00'), ('E', 1800, '0:00'), ('E', 2100, '1:37'), ('E', 2400, '4:39'),
('E', 2700, '8:18'), ('E', 3000, '12:54'),
-- grupo F
('F', 300, '0:00'), ('F', 600, '0:00'), ('F', 900, '0:00'), ('F', 1200, '0:00'),
('F', 1500, '0:00'), ('F', 1800, '1:32'), ('F', 2100, '4:04'), ('F', 2400, '7:06'),
('F', 2700, '10:45'), ('F', 3000, '15:20'),
-- grupo G
('G', 300, '0:00'), ('G', 600, '0:00'), ('G', 900, '0:00'), ('G', 1200, '0:00'),
('G', 1500, '1:19'), ('G', 1800, '3:38'), ('G', 2100, '6:10'), ('G', 2400, '9:13'),
('G', 2700, '12:52'), ('G', 3000, '17:27'),
-- grupo H
('H', 300, '0:00'), ('H', 600, '0:00'), ('H', 900, '0:00'), ('H', 1200, '1:06'),
('H', 1500, '3:10'), ('H', 1800, '5:29'), ('H', 2100, '8:02'), ('H', 2400, '11:04'),
('H', 2700, '14:43'), ('H', 3000, '19:18'),
-- grupo I
('I', 300, '0:00'), ('I', 600, '0:00'), ('I', 900, '0:56'), ('I', 1200, '2:45'),
('I', 1500, '4:50'), ('I', 1800, '7:09'), ('I', 2100, '9:41'), ('I', 2400, '12:44'),
('I', 2700, '16:22'), ('I', 3000, '20:58'),
-- grupo J
('J', 300, '0:00'), ('J', 600, '0:41'), ('J', 900, '2:25'), ('J', 1200, '4:15'),
('J', 1500, '6:19'), ('J', 1800, '8:39'), ('J', 2100, '11:11'), ('J', 2400, '14:13'),
('J', 2700, '17:52'), ('J', 3000, '22:27'),
-- grupo K
('K', 300, '0:30'), ('K', 600, '2:03'), ('K', 900, '3:47'), ('K', 1200, '5:37'),
('K', 1500, '7:41'), ('K', 1800, '10:00'), ('K', 2100, '12:33'), ('K', 2400, '15:35'),
('K', 2700, '19:14'), ('K', 3000, '23:49'),
-- grupo L
('L', 300, '1:45'), ('L', 600, '3:18'), ('L', 900, '5:02'), ('L', 1200, '6:52'),
('L', 1500, '8:56'), ('L', 1800, '11:15'), ('L', 2100, '13:48'), ('L', 2400, '16:50'),
('L', 2700, '20:29'), ('L', 3000, '25:04'),
-- grupo M
('M', 300, '2:54'), ('M', 600, '4:28'), ('M', 900, '6:12'), ('M', 1200, '8:01'),
('M', 1500, '10:06'), ('M', 1800, '12:25'), ('M', 2100, '14:57'), ('M', 2400, '18:00'),
('M', 2700, '21:38'), ('M', 3000, '26:14'),
-- grupo N
('N', 300, '3:59'), ('N', 600, '5:32'), ('N', 900, '7:16'), ('N', 1200, '9:06'),
('N', 1500, '11:10'), ('N', 1800, '13:29'), ('N', 2100, '16:02'), ('N', 2400, '19:04'),
('N', 2700, '22:43'), ('N', 3000, '27:18'),
-- grupo O
('O', 300, '4:59'), ('O', 600, '6:33'), ('O', 900, '8:17'), ('O', 1200, '10:06'),
('O', 1500, '12:11'), ('O', 1800, '14:30'), ('O', 2100, '17:02'), ('O', 2400, '20:05'),
('O', 2700, '23:43'), ('O', 3000, '28:19'),
-- grupo Z
('Z', 300, '5:56'), ('Z', 600, '7:29'), ('Z', 900, '9:13'), ('Z', 1200, '11:03'),
('Z', 1500, '13:07'), ('Z', 1800, '15:26'), ('Z', 2100, '17:59'), ('Z', 2400, '21:01'),
('Z', 2700, '24:40'), ('Z', 3000, '29:15');

-- ============================================================
--  TABLA VII — Aguas poco profundas 9-15 mca (pasos de 0.3)
-- ============================================================
INSERT INTO tabla_VII (profundidad, tiempo_limite_nodeco, grupo_A, grupo_B, grupo_C, grupo_D, grupo_E, grupo_F, grupo_G, grupo_H, grupo_I, grupo_J, grupo_K, grupo_L, grupo_M, grupo_N, grupo_O, grupo_Z) VALUES
(9.0, 371, 17, 27, 38, 50, 62, 76, 91, 107, 125, 145, 167, 193, 223, 260, 307, 371),
(9.3, 334, 16, 26, 37, 48, 60, 73, 87, 102, 119, 138, 158, 182, 209, 242, 282, 334),
(9.6, 304, 15, 25, 35, 46, 58, 70, 83, 98, 114, 131, 150, 172, 197, 226, 261, 304),
(9.9, 281, 15, 24, 34, 45, 56, 67, 80, 94, 109, 125, 143, 163, 186, 212, 243, 281),
(10.2, 256, 14, 23, 33, 43, 54, 65, 77, 90, 104, 120, 137, 155, 176, 200, 228, 256),
(10.5, 232, 14, 23, 32, 42, 52, 63, 74, 87, 100, 115, 131, 148, 168, 190, 215, 232),
(10.8, 212, 14, 22, 31, 40, 50, 61, 72, 84, 97, 110, 125, 142, 160, 180, 204, 212),
(11.1, 197, 13, 21, 30, 39, 49, 59, 69, 81, 93, 106, 120, 136, 153, 172, 193, 197),
(11.4, 184, 13, 21, 29, 38, 47, 57, 67, 78, 90, 102, 116, 131, 147, 164, 184, NULL),
(11.7, 173, 12, 20, 28, 37, 46, 55, 65, 76, 87, 99, 112, 126, 141, 157, 173, NULL),
(12.0, 163, 12, 20, 27, 36, 44, 53, 63, 73, 84, 95, 108, 121, 135, 151, 163, NULL),
(12.3, 155, 12, 19, 27, 35, 43, 52, 61, 71, 81, 92, 104, 117, 130, 145, 155, NULL),
(12.6, 147, 11, 19, 26, 34, 42, 50, 59, 69, 79, 89, 101, 113, 126, 140, 147, NULL),
(12.9, 140, 11, 18, 25, 33, 41, 49, 58, 67, 76, 87, 98, 109, 122, 135, 140, NULL),
(13.2, 134, 11, 18, 25, 32, 40, 48, 56, 65, 74, 84, 95, 106, 118, 130, 134, NULL),
(13.5, 125, 11, 17, 24, 31, 39, 46, 55, 63, 72, 82, 92, 102, 114, 125, NULL, NULL),
(13.8, 116, 10, 17, 23, 30, 38, 45, 53, 61, 70, 79, 89, 99, 110, 116, NULL, NULL),
(14.1, 109, 10, 16, 23, 30, 37, 44, 52, 60, 68, 77, 87, 97, 107, 109, NULL, NULL),
(14.4, 102, 10, 16, 22, 29, 36, 43, 51, 58, 67, 75, 84, 94, 102, NULL, NULL, NULL),
(14.7, 97, 10, 16, 22, 28, 35, 42, 49, 57, 65, 73, 82, 91, 97, NULL, NULL, NULL),
(15.0, 92, 9, 15, 21, 28, 34, 41, 48, 56, 63, 71, 80, 89, 92, NULL, NULL, NULL);











