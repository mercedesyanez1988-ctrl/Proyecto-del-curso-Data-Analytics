-- Motor utilizado: MySQL 8.0 (MySQL Workbench)
-- M3 - Checkpoint: Ventas_Tech_DB | Mercedes Yañez

-- Preparación: crear la base si no existe y seleccionarla.
CREATE DATABASE IF NOT EXISTS Ventas_Tech_DB CHARACTER SET utf8mb4;
USE Ventas_Tech_DB;

-- =====================================================
-- 1. DROP TABLES
-- Elimina las tablas de este ejercicio para poder repetirlo.
-- =====================================================
DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS categorias;

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

CREATE TABLE ventas (
    id_venta INT PRIMARY KEY,
    id_cliente INT,
    id_producto INT,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    fecha_venta DATE NOT NULL,
    CONSTRAINT FK_ventas_clientes
        FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    CONSTRAINT FK_ventas_productos
        FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- =====================================================
-- 3. INSERT DATA - 25 registros
-- =====================================================
INSERT INTO categorias (id_categoria, nombre_categoria, descripcion) VALUES
    (1, N'Computación', N'Laptops, PCs y monitores'),
    (2, N'Accesorios', N'Periféricos y complementos'),
    (3, N'Audio', N'Auriculares y parlantes'),
    (4, N'Almacenamiento', N'Discos y memorias');

INSERT INTO clientes (id_cliente, nombre, email, ciudad, fecha_registro) VALUES
    (1, N'María López', 'maria@mail.com', N'Buenos Aires', '2024-01-05'),
    (2, N'Carlos Ruiz', 'carlos@mail.com', N'Córdoba', '2024-01-10'),
    (3, N'Ana Gómez', 'ana@mail.com', N'Rosario', '2024-02-01'),
    (4, N'Pedro Sanz', 'pedro@mail.com', N'Mendoza', '2024-02-15'),
    (5, N'Laura Torres', 'laura@mail.com', N'Tucumán', '2024-03-01');

INSERT INTO productos (id_producto, nombre_producto, id_categoria, precio, stock, activo) VALUES
    (1, N'Laptop Pro 15', 1, 1200.00, 15, 1),
    (2, N'Mouse Inalámbrico', 2, 28.00, 80, 1),
    (3, N'Monitor 4K 27', 1, 450.00, 12, 1),
    (4, N'Auriculares BT Pro', 3, 120.00, 35, 1),
    (5, N'SSD Externo 1TB', 4, 130.00, 18, 1),
    (6, N'Teclado Mecánico', 2, 95.00, 40, 1);

INSERT INTO ventas (id_venta, id_cliente, id_producto, cantidad, precio_unitario, fecha_venta) VALUES
    (1,  1, 1, 2, 1200.00, '2024-03-05'),
    (2,  2, 2, 5,   28.00, '2024-03-06'),
    (3,  3, 3, 1,  450.00, '2024-03-07'),
    (4,  1, 4, 2,  120.00, '2024-03-08'),
    (5,  4, 5, 3,  130.00, '2024-03-10'),
    (6,  2, 6, 4,   95.00, '2024-03-11'),
    (7,  5, 1, 1, 1200.00, '2024-03-12'),
    (8,  3, 2, 8,   28.00, '2024-03-13'),
    (9,  4, 4, 1,  120.00, '2024-03-14'),
    (10, 5, 3, 2,  450.00, '2024-03-15');

-- =====================================================
-- 4. VALIDACIÓN
-- =====================================================
SELECT * FROM categorias; -- Esperado: 4 filas
SELECT * FROM clientes;   -- Esperado: 5 filas
SELECT * FROM productos;  -- Esperado: 6 filas
SELECT * FROM ventas;     -- Esperado: 10 filas
