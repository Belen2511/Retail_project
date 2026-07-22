-- =========================================================
-- SCRIPT: Sistema de Clientes, Productos y Ventas
-- Schema: admin
-- =========================================================

-- =========================================================
-- 1. CREACIÓN DE TABLAS
-- =========================================================

CREATE SCHEMA IF NOT EXISTS admin;

CREATE TABLE admin.clientes (
    id_cliente SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(255),
    edad INTEGER,
    fecha_registro DATE DEFAULT CURRENT_DATE,
    CONSTRAINT chk_edad_cliente CHECK (edad >= 18)
);

CREATE TABLE admin.productos (
    id_productos SERIAL PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    categoria VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    stock INTEGER DEFAULT 0,
    CONSTRAINT chk_precio_positivo CHECK (precio > 0)
);

CREATE TABLE admin.ventas (
    id_venta SERIAL PRIMARY KEY,
    id_cliente INTEGER NOT NULL REFERENCES admin.clientes(id_cliente),
    id_producto INTEGER NOT NULL REFERENCES admin.productos(id_productos),
    cantidad INTEGER NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10,2) NOT NULL,
    total DECIMAL(10,2) GENERATED ALWAYS AS (cantidad * precio_unitario) STORED,
    fecha_venta DATE NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT chk_cantidad_positiva CHECK (cantidad > 0),
    CONSTRAINT chk_precio_unitario_positivo CHECK (precio_unitario > 0)
);

-- =========================================================
-- 2. CARGA DE DATOS
-- =========================================================

BEGIN;

-- Clientes (5 registros)
INSERT INTO admin.clientes (nombre, apellido, email, edad, fecha_registro) VALUES
('Lucía', 'Fernández', 'lucia.fernandez@mail.com', 28, '2024-01-15'),
('Martín', 'Gómez', 'martin.gomez@mail.com', 34, '2024-02-10'),
('Sofía', 'Ramírez', 'sofia.ramirez@mail.com', 22, '2024-03-05'),
('Diego', 'Torres', 'diego.torres@mail.com', 45, '2024-04-20'),
('Valentina', 'López', 'valentina.lopez@mail.com', 19, '2024-05-12');

-- Productos (5 registros)
INSERT INTO admin.productos (nombre, categoria, precio, stock) VALUES
('Notebook Lenovo 15"', 'Electronica', 750000.00, 10),
('Mouse Inalámbrico', 'Electronica', 15000.00, 50),
('Silla Ergonómica', 'Muebles', 120000.00, 20),
('Escritorio de Madera', 'Muebles', 95000.00, 15),
('Auriculares Bluetooth', 'Electronica', 45000.00, 30);

-- Ventas (5 registros)
INSERT INTO admin.ventas (id_cliente, id_producto, cantidad, precio_unitario, fecha_venta) VALUES
(1, 1, 1, 750000.00, '2024-06-01'),
(2, 2, 2, 15000.00, '2024-06-03'),
(3, 3, 1, 120000.00, '2024-06-05'),
(4, 5, 3, 45000.00, '2024-06-07'),
(5, 4, 1, 95000.00, '2024-06-10');

COMMIT;

-- =========================================================
-- 3. ACTUALIZACIÓN: aumenta un 10% el precio de la categoría "Electronica"
-- =========================================================

UPDATE admin.productos
SET precio = precio * 1.10
WHERE categoria = 'Electronica';

-- =========================================================
-- 4. ELIMINACIÓN: borra la venta específica con id_venta = 4
-- =========================================================

DELETE FROM admin.ventas
WHERE id_venta = 4;