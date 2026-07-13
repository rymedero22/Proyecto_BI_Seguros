-- =====================================================================
-- UTILIDADES DE DEFENSA - PROYECTO BI SEGUROS ALTA VISTA
-- Base de datos: seguros_bi
-- Esquema transaccional: seguro_g29969634
-- Esquema dimensional:  seguro_dw_g29969634
--
-- IMPORTANTE:
-- No ejecutes todo el archivo completo de una sola vez.
-- Selecciona y ejecuta únicamente el bloque que necesites.
-- =====================================================================


-- =====================================================================
-- BLOQUE 1. VACIAR TODAS LAS TABLAS SIN BORRAR ESQUEMAS NI ESTRUCTURAS
-- =====================================================================
-- Conserva:
--   - Esquemas
--   - Tablas
--   - Claves primarias y foráneas
--   - Restricciones
--   - Definiciones IDENTITY
--
-- Elimina:
--   - Todas las filas de ambos esquemas
--   - Reinicia los contadores IDENTITY
--
-- Después de ejecutar este bloque:
--   1. Ejecuta el script normal de INSERT de datos de prueba.
--   2. Ejecuta CARGA_DATA_WAREHOUSE.kjb.
-- =====================================================================

BEGIN;

TRUNCATE TABLE
    -- Hechos
    seguro_dw_g29969634.fact_registro_contrato,
    seguro_dw_g29969634.fact_evaluacion_servicio,
    seguro_dw_g29969634.fact_registro_siniestro,
    seguro_dw_g29969634.fact_metas,

    -- Dimensiones
    seguro_dw_g29969634.dim_tiempo,
    seguro_dw_g29969634.dim_cliente,
    seguro_dw_g29969634.dim_producto,
    seguro_dw_g29969634.dim_contrato,
    seguro_dw_g29969634.dim_sucursal,
    seguro_dw_g29969634.dim_estado_contrato,
    seguro_dw_g29969634.dim_evaluacion_servicio,
    seguro_dw_g29969634.dim_siniestro,

    -- Modelo transaccional
    seguro_g29969634.registro_siniestro,
    seguro_g29969634.siniestro,
    seguro_g29969634.recomienda,
    seguro_g29969634.evaluacion_servicio,
    seguro_g29969634.registro_contrato,
    seguro_g29969634.contrato,
    seguro_g29969634.meta_comercial,
    seguro_g29969634.cliente,
    seguro_g29969634.producto,
    seguro_g29969634.tipo_producto,
    seguro_g29969634.sucursal,
    seguro_g29969634.ciudad,
    seguro_g29969634.pais
RESTART IDENTITY CASCADE;

COMMIT;



-- =====================================================================
-- BLOQUE 3. VALIDAR LA CARGA BASE DEL ESQUEMA TRANSACCIONAL
-- =====================================================================
-- Ejecutar después del script normal de INSERT de datos de prueba.
-- Todas las filas deben mostrar resultado = OK.
-- =====================================================================

SELECT
    tabla,
    cantidad_actual,
    cantidad_esperada,
    CASE
        WHEN cantidad_actual = cantidad_esperada THEN 'OK'
        ELSE 'REVISAR'
    END AS resultado
FROM (
    SELECT 1 AS orden, 'PAIS' AS tabla,
           COUNT(*)::BIGINT AS cantidad_actual, 2::BIGINT AS cantidad_esperada
    FROM seguro_g29969634.pais

    UNION ALL
    SELECT 2, 'CIUDAD', COUNT(*), 6
    FROM seguro_g29969634.ciudad

    UNION ALL
    SELECT 3, 'SUCURSAL', COUNT(*), 6
    FROM seguro_g29969634.sucursal

    UNION ALL
    SELECT 4, 'TIPO_PRODUCTO', COUNT(*), 5
    FROM seguro_g29969634.tipo_producto

    UNION ALL
    SELECT 5, 'PRODUCTO', COUNT(*), 12
    FROM seguro_g29969634.producto

    UNION ALL
    SELECT 6, 'CLIENTE', COUNT(*), 40
    FROM seguro_g29969634.cliente

    UNION ALL
    SELECT 7, 'CONTRATO', COUNT(*), 72
    FROM seguro_g29969634.contrato

    UNION ALL
    SELECT 8, 'REGISTRO_CONTRATO', COUNT(*), 72
    FROM seguro_g29969634.registro_contrato

    UNION ALL
    SELECT 9, 'EVALUACION_SERVICIO', COUNT(*), 5
    FROM seguro_g29969634.evaluacion_servicio

    UNION ALL
    SELECT 10, 'RECOMIENDA', COUNT(*), 54
    FROM seguro_g29969634.recomienda

    UNION ALL
    SELECT 11, 'SINIESTRO', COUNT(*), 24
    FROM seguro_g29969634.siniestro

    UNION ALL
    SELECT 12, 'REGISTRO_SINIESTRO', COUNT(*), 24
    FROM seguro_g29969634.registro_siniestro

    UNION ALL
    SELECT 13, 'META_COMERCIAL', COUNT(*), 36
    FROM seguro_g29969634.meta_comercial
) validacion
ORDER BY orden;


-- =====================================================================
-- BLOQUE 4. VALIDAR LA CARGA BASE DEL DATA WAREHOUSE
-- =====================================================================
-- Ejecutar después de CARGA_DATA_WAREHOUSE.kjb.
-- Todas las filas deben mostrar resultado = OK.
-- =====================================================================

SELECT
    tabla,
    cantidad_actual,
    cantidad_esperada,
    CASE
        WHEN cantidad_actual = cantidad_esperada THEN 'OK'
        ELSE 'REVISAR'
    END AS resultado
FROM (
    SELECT 1 AS orden, 'DIM_TIEMPO' AS tabla,
           COUNT(*)::BIGINT AS cantidad_actual, 2557::BIGINT AS cantidad_esperada
    FROM seguro_dw_g29969634.dim_tiempo

    UNION ALL
    SELECT 2, 'DIM_CLIENTE', COUNT(*), 40
    FROM seguro_dw_g29969634.dim_cliente

    UNION ALL
    SELECT 3, 'DIM_PRODUCTO', COUNT(*), 12
    FROM seguro_dw_g29969634.dim_producto

    UNION ALL
    SELECT 4, 'DIM_CONTRATO', COUNT(*), 72
    FROM seguro_dw_g29969634.dim_contrato

    UNION ALL
    SELECT 5, 'DIM_SUCURSAL', COUNT(*), 6
    FROM seguro_dw_g29969634.dim_sucursal

    UNION ALL
    SELECT 6, 'DIM_ESTADO_CONTRATO', COUNT(*), 3
    FROM seguro_dw_g29969634.dim_estado_contrato

    UNION ALL
    SELECT 7, 'DIM_EVALUACION_SERVICIO', COUNT(*), 5
    FROM seguro_dw_g29969634.dim_evaluacion_servicio

    UNION ALL
    SELECT 8, 'DIM_SINIESTRO', COUNT(*), 24
    FROM seguro_dw_g29969634.dim_siniestro

    UNION ALL
    SELECT 9, 'FACT_REGISTRO_CONTRATO', COUNT(*), 72
    FROM seguro_dw_g29969634.fact_registro_contrato

    UNION ALL
    SELECT 10, 'FACT_EVALUACION_SERVICIO', COUNT(*), 54
    FROM seguro_dw_g29969634.fact_evaluacion_servicio

    UNION ALL
    SELECT 11, 'FACT_REGISTRO_SINIESTRO', COUNT(*), 24
    FROM seguro_dw_g29969634.fact_registro_siniestro

    UNION ALL
    SELECT 12, 'FACT_METAS', COUNT(*), 36
    FROM seguro_dw_g29969634.fact_metas
) validacion
ORDER BY orden;


-- =====================================================================
-- BLOQUE 5. VALIDAR QUE NO HAYA CLAVES SUSTITUTAS OBLIGATORIAS NULAS
-- =====================================================================
-- Todas las filas deben mostrar filas_con_error = 0.
-- sk_fecha_respuesta no se valida porque puede ser NULL en siniestros
-- pendientes.
-- =====================================================================

SELECT
    'FACT_REGISTRO_CONTRATO' AS tabla,
    COUNT(*) AS filas_con_error
FROM seguro_dw_g29969634.fact_registro_contrato
WHERE sk_fecha_inicio IS NULL
   OR sk_fecha_fin IS NULL
   OR sk_dim_cliente IS NULL
   OR sk_dim_contrato IS NULL
   OR sk_dim_producto IS NULL
   OR sk_dim_estado IS NULL

UNION ALL

SELECT
    'FACT_EVALUACION_SERVICIO',
    COUNT(*)
FROM seguro_dw_g29969634.fact_evaluacion_servicio
WHERE sk_dim_tiempo IS NULL
   OR sk_dim_cliente IS NULL
   OR sk_dim_producto IS NULL
   OR sk_dim_evaluacion IS NULL

UNION ALL

SELECT
    'FACT_REGISTRO_SINIESTRO',
    COUNT(*)
FROM seguro_dw_g29969634.fact_registro_siniestro
WHERE sk_fecha_siniestro IS NULL
   OR sk_dim_cliente IS NULL
   OR sk_dim_contrato IS NULL
   OR sk_dim_sucursal IS NULL
   OR sk_dim_producto IS NULL
   OR sk_dim_siniestro IS NULL

UNION ALL

SELECT
    'FACT_METAS',
    COUNT(*)
FROM seguro_dw_g29969634.fact_metas
WHERE sk_fecha_inicio_meta IS NULL
   OR sk_fecha_fin_meta IS NULL
   OR sk_dim_producto IS NULL;


-- =====================================================================
-- BLOQUE 6. PRUEBA INCREMENTAL: ESTADO ANTES DEL INSERT
-- =====================================================================
-- Con la carga base debe mostrar:
--   FUENTE_CLIENTE               40
--   FUENTE_CONTRATO              72
--   FUENTE_REGISTRO_CONTRATO     72
--   DW_DIM_CLIENTE               40
--   DW_DIM_CONTRATO              72
--   DW_FACT_REGISTRO_CONTRATO    72
-- =====================================================================

SELECT 'FUENTE_CLIENTE' AS tabla, COUNT(*) AS cantidad
FROM seguro_g29969634.cliente

UNION ALL
SELECT 'FUENTE_CONTRATO', COUNT(*)
FROM seguro_g29969634.contrato

UNION ALL
SELECT 'FUENTE_REGISTRO_CONTRATO', COUNT(*)
FROM seguro_g29969634.registro_contrato

UNION ALL
SELECT 'DW_DIM_CLIENTE', COUNT(*)
FROM seguro_dw_g29969634.dim_cliente

UNION ALL
SELECT 'DW_DIM_CONTRATO', COUNT(*)
FROM seguro_dw_g29969634.dim_contrato

UNION ALL
SELECT 'DW_FACT_REGISTRO_CONTRATO', COUNT(*)
FROM seguro_dw_g29969634.fact_registro_contrato;


-- =====================================================================
-- BLOQUE 7. INSERT DE PRUEBA INCREMENTAL
-- =====================================================================
-- Agrega:
--   - Cliente CLI0041
--   - Contrato CONT0073
--   - Un registro de contrato por 1850.75
--
-- ON CONFLICT evita insertar el mismo dato dos veces accidentalmente.
-- Después de este bloque, todavía NO debe cambiar el Data Warehouse.
-- =====================================================================

BEGIN;

INSERT INTO seguro_g29969634.cliente (
    cod_cliente,
    nb_cliente,
    ci_rif,
    telefono,
    direccion,
    sexo,
    email,
    cod_sucursal
)
SELECT
    'CLI0041',
    'Valentina Isabel Romero',
    'V-29969635',
    '+58 412-555-4141',
    'Caracas, Venezuela',
    'F',
    'valentina.romero@gmail.com',
    s.cod_sucursal
FROM seguro_g29969634.sucursal s
ORDER BY s.cod_sucursal
LIMIT 1
ON CONFLICT (cod_cliente) DO NOTHING;

INSERT INTO seguro_g29969634.contrato (
    nro_contrato,
    descrip_contrato
)
VALUES (
    'CONT0073',
    'Contrato incremental de prueba'
)
ON CONFLICT (nro_contrato) DO NOTHING;

INSERT INTO seguro_g29969634.registro_contrato (
    nro_contrato,
    cod_producto,
    cod_cliente,
    fecha_inicio,
    fecha_fin,
    monto,
    estado_contrato
)
SELECT
    'CONT0073',
    p.cod_producto,
    'CLI0041',
    DATE '2026-08-01',
    DATE '2027-07-31',
    1850.75,
    'ACTIVO'
FROM seguro_g29969634.producto p
ORDER BY p.cod_producto
LIMIT 1
ON CONFLICT (nro_contrato) DO NOTHING;

COMMIT;


-- =====================================================================
-- BLOQUE 8. VERIFICAR EL INSERT EN EL MODELO TRANSACCIONAL
-- =====================================================================

SELECT
    c.cod_cliente,
    c.nb_cliente,
    c.ci_rif,
    c.telefono,
    c.direccion,
    c.sexo,
    c.email,
    c.cod_sucursal
FROM seguro_g29969634.cliente c
WHERE c.cod_cliente = 'CLI0041';

SELECT
    con.nro_contrato,
    con.descrip_contrato,
    rc.id_registro_contrato,
    rc.cod_producto,
    rc.cod_cliente,
    rc.fecha_inicio,
    rc.fecha_fin,
    rc.monto,
    rc.estado_contrato
FROM seguro_g29969634.contrato con
JOIN seguro_g29969634.registro_contrato rc
    ON rc.nro_contrato = con.nro_contrato
WHERE con.nro_contrato = 'CONT0073';


-- =====================================================================
-- BLOQUE 9. VERIFICAR QUE EL DW AÚN NO CAMBIÓ ANTES DEL JOB
-- =====================================================================
-- Después del insert y antes del Job debe mostrar:
--   FUENTE_CLIENTE               41
--   FUENTE_CONTRATO              73
--   FUENTE_REGISTRO_CONTRATO     73
--   DW_DIM_CLIENTE               40
--   DW_DIM_CONTRATO              72
--   DW_FACT_REGISTRO_CONTRATO    72
-- =====================================================================

SELECT 'FUENTE_CLIENTE' AS tabla, COUNT(*) AS cantidad
FROM seguro_g29969634.cliente

UNION ALL
SELECT 'FUENTE_CONTRATO', COUNT(*)
FROM seguro_g29969634.contrato

UNION ALL
SELECT 'FUENTE_REGISTRO_CONTRATO', COUNT(*)
FROM seguro_g29969634.registro_contrato

UNION ALL
SELECT 'DW_DIM_CLIENTE', COUNT(*)
FROM seguro_dw_g29969634.dim_cliente

UNION ALL
SELECT 'DW_DIM_CONTRATO', COUNT(*)
FROM seguro_dw_g29969634.dim_contrato

UNION ALL
SELECT 'DW_FACT_REGISTRO_CONTRATO', COUNT(*)
FROM seguro_dw_g29969634.fact_registro_contrato;


-- =====================================================================
-- ENTRE LOS BLOQUES 9 Y 10:
-- EJECUTAR MANUALMENTE EN PENTAHO:
-- CARGA_DATA_WAREHOUSE.kjb
-- =====================================================================


-- =====================================================================
-- BLOQUE 10. VALIDAR LA PRUEBA INCREMENTAL DESPUÉS DEL JOB
-- =====================================================================
-- Debe mostrar:
--   DIM_CLIENTE               41
--   DIM_CONTRATO              73
--   FACT_REGISTRO_CONTRATO    73
-- =====================================================================

SELECT 'DIM_CLIENTE' AS tabla, COUNT(*) AS cantidad
FROM seguro_dw_g29969634.dim_cliente

UNION ALL
SELECT 'DIM_CONTRATO', COUNT(*)
FROM seguro_dw_g29969634.dim_contrato

UNION ALL
SELECT 'FACT_REGISTRO_CONTRATO', COUNT(*)
FROM seguro_dw_g29969634.fact_registro_contrato;


-- =====================================================================
-- BLOQUE 11. VER EL REGISTRO INCREMENTAL COMPLETO EN EL DW
-- =====================================================================

SELECT
    cli.cod_cliente,
    cli.nb_cliente,
    cli.ci_rif,
    cli.telefono,
    con.nro_contrato,
    con.descrip_contrato,
    prod.cod_producto,
    prod.nb_producto,
    ti.fecha_completa AS fecha_inicio,
    tf.fecha_completa AS fecha_fin,
    est.descrip_estado,
    f.monto,
    f.cantidad
FROM seguro_dw_g29969634.fact_registro_contrato f
JOIN seguro_dw_g29969634.dim_cliente cli
    ON cli.sk_dim_cliente = f.sk_dim_cliente
JOIN seguro_dw_g29969634.dim_contrato con
    ON con.sk_dim_contrato = f.sk_dim_contrato
JOIN seguro_dw_g29969634.dim_producto prod
    ON prod.sk_dim_producto = f.sk_dim_producto
JOIN seguro_dw_g29969634.dim_tiempo ti
    ON ti.sk_dim_tiempo = f.sk_fecha_inicio
JOIN seguro_dw_g29969634.dim_tiempo tf
    ON tf.sk_dim_tiempo = f.sk_fecha_fin
JOIN seguro_dw_g29969634.dim_estado_contrato est
    ON est.sk_dim_estado = f.sk_dim_estado
WHERE cli.cod_cliente = 'CLI0041'
  AND con.nro_contrato = 'CONT0073';


-- =====================================================================
-- BLOQUE 12. VALIDAR QUE LA SEGUNDA EJECUCIÓN DEL JOB NO DUPLICÓ
-- =====================================================================
-- Ejecuta nuevamente CARGA_DATA_WAREHOUSE.kjb y luego este bloque.
-- Debe mostrar:
--   clientes             41
--   contratos            73
--   registros_contrato   73
--   repeticiones_cliente  1
--   repeticiones_contrato 1
--   repeticiones_hecho    1
-- =====================================================================

SELECT
    (SELECT COUNT(*)
     FROM seguro_dw_g29969634.dim_cliente) AS clientes,

    (SELECT COUNT(*)
     FROM seguro_dw_g29969634.dim_contrato) AS contratos,

    (SELECT COUNT(*)
     FROM seguro_dw_g29969634.fact_registro_contrato) AS registros_contrato,

    (SELECT COUNT(*)
     FROM seguro_dw_g29969634.dim_cliente
     WHERE cod_cliente = 'CLI0041') AS repeticiones_cliente,

    (SELECT COUNT(*)
     FROM seguro_dw_g29969634.dim_contrato
     WHERE nro_contrato = 'CONT0073') AS repeticiones_contrato,

    (
        SELECT COUNT(*)
        FROM seguro_dw_g29969634.fact_registro_contrato f
        JOIN seguro_dw_g29969634.dim_contrato c
            ON c.sk_dim_contrato = f.sk_dim_contrato
        WHERE c.nro_contrato = 'CONT0073'
    ) AS repeticiones_hecho;


-- =====================================================================
-- BLOQUE 13. RESTABLECER LA CARGA BASE DESPUÉS DE LA PRUEBA
-- =====================================================================
-- Para volver a los datos originales:
--   1. Ejecuta BLOQUE 1 para vaciar todas las tablas.
--   2. Ejecuta el script normal de INSERT de datos de prueba.
--   3. Ejecuta CARGA_DATA_WAREHOUSE.kjb.
--   4. Ejecuta BLOQUES 3, 4 y 5 para validar.
-- =====================================================================