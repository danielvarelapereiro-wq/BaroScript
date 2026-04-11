-- Creación de la base de datos
CREATE DATABASE IF NOT EXISTS bs_db_api;
USE bs_db_api;

-- ============================================================
--  Tablas gestion usuarios
-- ============================================================

CREATE TABLE IF NOT EXISTS roles (
    rol_id      INT PRIMARY KEY AUTO_INCREMENT,
    nombre      VARCHAR(20) NOT NULL UNIQUE,
    descripcion TEXT
);

CREATE TABLE IF NOT EXISTS usuarios (
    usuario_id      INT PRIMARY KEY AUTO_INCREMENT,
    nombre        VARCHAR(50)  NOT NULL UNIQUE,
    email           VARCHAR(100) NOT NULL UNIQUE,
    contraseña_hash   VARCHAR(255) NOT NULL,
    rol_id          INT NOT NULL,
    fecha_registro  DATETIME DEFAULT NOW(),
    activo          BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (rol_id) REFERENCES roles(rol_id)
);

-- ============================================================
--  Tabla buceadores
-- ============================================================

CREATE TABLE IF NOT EXISTS buceadores (
    buceador_id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id  INT NOT NULL,
    nombre      VARCHAR(100) NOT NULL,
    apellidos   VARCHAR(100),
    titulacion  VARCHAR(100),
    created_at  DATETIME DEFAULT NOW(),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id) ON DELETE CASCADE
);

-- ============================================================
--  Hojas de inmersion
-- ============================================================









