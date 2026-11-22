-- Motor utilizado: MySQL 8.0 (MySQL Workbench)
-- M3 - Checkpoint: Ventas_Tech_DB | Mercedes Yañez
-- Ampliación para M5: territorios de ejemplo y relación con ventas.

-- Preparación: crear la base si no existe y seleccionarla.
CREATE DATABASE IF NOT EXISTS Ventas_Tech_DB CHARACTER SET utf8mb4;
USE Ventas_Tech_DB;
SET NAMES utf8mb4;

-- =====================================================
-- 1. DROP TABLES
-- Elimina las tablas de este ejercicio para poder repetirlo.
-- =====================================================
DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS categorias;
DROP TABLE IF EXISTS territorios;

-- =====================================================
-- 2. CREATE TABLES
-- =====================================================
CREATE TABLE categorias (
    id_categoria INT PRIMARY KEY,
    nombre_categoria VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200) NULL
);

CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    ciudad VARCHAR(50) NULL,
    fecha_registro DATE NOT NULL
);

CREATE TABLE productos (
    id_producto INT PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    id_categoria INT,
    precio DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    activo TINYINT(1) DEFAULT 1,
    CONSTRAINT FK_productos_categorias
        FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

CREATE TABLE territorios (
    id_territorio INT PRIMARY KEY,
    region VARCHAR(80) NOT NULL,
    pais VARCHAR(80) NOT NULL,
    zona VARCHAR(80) NOT NULL
);

CREATE TABLE ventas (
    id_venta INT PRIMARY KEY,
    id_cliente INT,
    id_producto INT,
    id_territorio INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    fecha_venta DATE NOT NULL,
    CONSTRAINT FK_ventas_clientes
        FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    CONSTRAINT FK_ventas_productos
        FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    CONSTRAINT FK_ventas_territorios
        FOREIGN KEY (id_territorio) REFERENCES territorios(id_territorio)
);

-- =====================================================
-- 3. INSERT DATA - 25 registros originales y 3 territorios de ejemplo
-- =====================================================
INSERT INTO categorias (id_categoria, nombre_categoria, descripcion) VALUES
    (1, 'Computación', 'Laptops, PCs y monitores'),
    (2, 'Accesorios', 'Periféricos y complementos'),
    (3, 'Audio', 'Auriculares y parlantes'),
    (4, 'Almacenamiento', 'Discos y memorias');

INSERT INTO clientes (id_cliente, nombre, email, ciudad, fecha_registro) VALUES
    (1, 'María López', 'maria@mail.com', 'Buenos Aires', '2024-01-05'),
    (2, 'Carlos Ruiz', 'carlos@mail.com', 'Córdoba', '2024-01-10'),
    (3, 'Ana Gómez', 'ana@mail.com', 'Rosario', '2024-02-01'),
    (4, 'Pedro Sanz', 'pedro@mail.com', 'Mendoza', '2024-02-15'),
    (5, 'Laura Torres', 'laura@mail.com', 'Tucumán', '2024-03-01');

INSERT INTO productos (id_producto, nombre_producto, id_categoria, precio, stock, activo) VALUES
    (1, 'Laptop Pro 15', 1, 1200.00, 15, 1),
    (2, 'Mouse Inalámbrico', 2, 28.00, 80, 1),
    (3, 'Monitor 4K 27', 1, 450.00, 12, 1),
    (4, 'Auriculares BT Pro', 3, 120.00, 35, 1),
    (5, 'SSD Externo 1TB', 4, 130.00, 18, 1),
    (6, 'Teclado Mecánico', 2, 95.00, 40, 1);

-- Territorios ilustrativos para el proyecto; no son datos geográficos originales.
INSERT INTO territorios (id_territorio, region, pais, zona) VALUES
    (1, 'Centro', 'Argentina', 'Centro-Este'),
    (2, 'Cuyo', 'Argentina', 'Oeste'),
    (3, 'NOA', 'Argentina', 'Noroeste');

-- Se conserva cada venta original y se asigna un territorio de ejemplo
-- según la ciudad del cliente, para habilitar el análisis geográfico.
INSERT INTO ventas (id_venta, id_cliente, id_producto, cantidad, precio_unitario, fecha_venta, id_territorio) VALUES
    (1,  1, 1, 2, 1200.00, '2024-03-05', 1),
    (2,  2, 2, 5,   28.00, '2024-03-06', 1),
    (3,  3, 3, 1,  450.00, '2024-03-07', 1),
    (4,  1, 4, 2,  120.00, '2024-03-08', 1),
    (5,  4, 5, 3,  130.00, '2024-03-10', 2),
    (6,  2, 6, 4,   95.00, '2024-03-11', 1),
    (7,  5, 1, 1, 1200.00, '2024-03-12', 3),
    (8,  3, 2, 8,   28.00, '2024-03-13', 1),
    (9,  4, 4, 1,  120.00, '2024-03-14', 2),
    (10, 5, 3, 2,  450.00, '2024-03-15', 3);

-- =====================================================
-- 4. VALIDACIÓN
-- =====================================================
SELECT * FROM categorias; -- Esperado: 4 filas
SELECT * FROM clientes;   -- Esperado: 5 filas
SELECT * FROM productos;  -- Esperado: 6 filas
SELECT * FROM ventas;     -- Esperado: 10 filas
SELECT * FROM territorios; -- Esperado: 3 filas (ampliación M5)
