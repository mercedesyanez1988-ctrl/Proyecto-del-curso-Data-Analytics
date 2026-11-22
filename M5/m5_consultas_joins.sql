-- Motor utilizado: MySQL 8.0 (MySQL Workbench)
-- M5 - Consultas con JOINs | Mercedes Yañez
-- Requisito: ejecutar primero ventas_tech_db.sql actualizado para M5.

USE Ventas_Tech_DB;

-- =====================================================
-- Consulta 1: Vista base del proyecto (INNER JOIN)
-- Propósito: enriquecer cada venta con las dimensiones descriptivas.
-- =====================================================
SELECT
    v.id_venta,
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.ciudad AS ciudad_cliente,
    p.id_producto,
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    t.region,
    t.pais,
    t.zona,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario AS total_venta
FROM ventas AS v
INNER JOIN clientes AS c ON v.id_cliente = c.id_cliente
INNER JOIN productos AS p ON v.id_producto = p.id_producto
INNER JOIN categorias AS cat ON p.id_categoria = cat.id_categoria
INNER JOIN territorios AS t ON v.id_territorio = t.id_territorio
ORDER BY v.fecha_venta, v.id_venta;
-- Hallazgo: las 10 ventas quedan identificadas por cliente, producto,
-- categoría y territorio de ejemplo, con una facturación de 6.444,00.

-- =====================================================
-- Consulta 2: Clientes sin ventas (LEFT JOIN)
-- Propósito: detectar clientes registrados que aún no compraron.
-- =====================================================
SELECT
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.email,
    c.fecha_registro
FROM clientes AS c
LEFT JOIN ventas AS v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;
-- Hallazgo: 0 de los 5 clientes están sin compras. CRM no tiene clientes
-- inactivos para captar en este conjunto, pero puede trabajar en fidelización.

-- =====================================================
-- Consulta 3: Productos sin ventas (LEFT JOIN)
-- Propósito: identificar artículos del catálogo sin movimiento.
-- =====================================================
SELECT
    p.id_producto,
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    p.precio
FROM productos AS p
INNER JOIN categorias AS cat ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas AS v ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;
-- Hallazgo: 0 de los 6 productos están sin ventas. Producto puede enfocar
-- su análisis en los artículos con menor facturación, no en faltantes de venta.

-- =====================================================
-- Consulta 4: Consolidado por origen (UNION ALL)
-- Propósito: comparar la facturación de dos períodos no superpuestos.
-- La columna canal es una etiqueta literal; no representa un canal real.
-- =====================================================
SELECT
    canal,
    SUM(total) AS total_canal
FROM (
    SELECT fecha_venta, cantidad * precio_unitario AS total,
           'Marzo 01-10' AS canal
    FROM ventas
    WHERE fecha_venta >= '2024-03-01' AND fecha_venta < '2024-03-11'

    UNION ALL

    SELECT fecha_venta, cantidad * precio_unitario AS total,
           'Marzo 11-31' AS canal
    FROM ventas
    WHERE fecha_venta >= '2024-03-11' AND fecha_venta < '2024-04-01'
) AS consolidado
GROUP BY canal
ORDER BY total_canal DESC;
-- Hallazgo: el período del 1 al 10 de marzo facturó 3.620,00 y el del
-- 11 al 31 facturó 2.824,00. El consolidado suma 6.444,00 sin duplicados.
