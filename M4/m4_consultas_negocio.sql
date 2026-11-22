-- Motor utilizado: MySQL 8.0 (MySQL Workbench)
-- M4 - Consultas SQL de negocio | Mercedes Yañez

USE Ventas_Tech_DB;

-- =====================================================
-- CONSULTA 1: Resumen ejecutivo mensual
-- =====================================================
SELECT
    YEAR(fecha_venta) AS anio,
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    ROUND(AVG(cantidad * precio_unitario), 2) AS ticket_promedio
FROM ventas
GROUP BY YEAR(fecha_venta), MONTH(fecha_venta)
ORDER BY anio, mes;

-- =====================================================
-- CONSULTA 2: Ranking de los 5 productos por facturación
-- En MySQL, LIMIT 5 equivale a TOP 5 de SQL Server.
-- =====================================================
SELECT
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC, id_producto ASC
LIMIT 5;

-- =====================================================
-- CONSULTA 3: Clientes recurrentes
-- =====================================================
SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC, id_cliente ASC;

-- =====================================================
-- CONSULTA 4: Comparación con el promedio por producto
-- =====================================================
WITH facturacion_productos AS (
    SELECT
        id_producto,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY id_producto
)
SELECT
    id_producto,
    total_facturado,
    CASE
        WHEN total_facturado > (SELECT AVG(total_facturado) FROM facturacion_productos)
            THEN 'Por encima'
        WHEN total_facturado < (SELECT AVG(total_facturado) FROM facturacion_productos)
            THEN 'Por debajo'
        ELSE 'Igual al promedio'
    END AS clasificacion
FROM facturacion_productos
ORDER BY total_facturado DESC, id_producto ASC;

-- =====================================================
-- HALLAZGOS DE NEGOCIO (datos de marzo de 2024)
-- =====================================================
-- 1. La facturación total fue de 6.444,00 en 10 pedidos,
--    con un ticket promedio de 644,40.
-- 2. El producto 1 lideró la facturación con 3.600,00,
--    equivalente al 55,87% de las ventas totales.
-- 3. Los cinco clientes realizaron dos pedidos cada uno;
--    el 100% de los clientes compradores fueron recurrentes.
