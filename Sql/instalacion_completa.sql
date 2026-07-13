-- =====================================================
-- PROYECTO BI - SEGUROS ALTA VISTA
-- SCRIPT DE INSTALACIÓN COMPLETA
-- =====================================================


-- =====================================================
-- 1. CREACIÓN DE ESQUEMAS
-- =====================================================

CREATE SCHEMA IF NOT EXISTS seguro_g29969634;

CREATE SCHEMA IF NOT EXISTS seguro_dw_g29969634;


-- ============================================================
-- 1. UBICACIÓN
-- ============================================================

CREATE TABLE IF NOT EXISTS seguro_g29969634.pais (
    cod_pais VARCHAR(10) PRIMARY KEY,
    nb_pais VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS seguro_g29969634.ciudad (
    cod_ciudad VARCHAR(10) PRIMARY KEY,
    nb_ciudad VARCHAR(100) NOT NULL,
    cod_pais VARCHAR(10) NOT NULL,

    CONSTRAINT fk_ciudad_pais
        FOREIGN KEY (cod_pais)
        REFERENCES seguro_g29969634.pais(cod_pais)
);

CREATE TABLE IF NOT EXISTS seguro_g29969634.sucursal (
    cod_sucursal VARCHAR(10) PRIMARY KEY,
    nb_sucursal VARCHAR(100) NOT NULL,
    cod_ciudad VARCHAR(10) NOT NULL,

    CONSTRAINT fk_sucursal_ciudad
        FOREIGN KEY (cod_ciudad)
        REFERENCES seguro_g29969634.ciudad(cod_ciudad)
);


-- ============================================================
-- 2. PRODUCTOS
-- ============================================================

CREATE TABLE IF NOT EXISTS seguro_g29969634.tipo_producto (
    cod_tipo_producto VARCHAR(10) PRIMARY KEY,
    nb_tipo_producto VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS seguro_g29969634.producto (
    cod_producto VARCHAR(10) PRIMARY KEY,
    nb_producto VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    cod_tipo_producto VARCHAR(10) NOT NULL,
    calificacion NUMERIC(3,2) NOT NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_producto_tipo
        FOREIGN KEY (cod_tipo_producto)
        REFERENCES seguro_g29969634.tipo_producto(cod_tipo_producto),

    CONSTRAINT chk_producto_calificacion
        CHECK (
            calificacion IS NULL
            OR calificacion BETWEEN 1 AND 5
        )
);

-- ============================================================
-- 3. CLIENTES Y CONTRATOS
-- ============================================================

CREATE TABLE IF NOT EXISTS seguro_g29969634.cliente (
    cod_cliente VARCHAR(10) PRIMARY KEY,
    nb_cliente VARCHAR(150) NOT NULL,
    ci_rif VARCHAR(20) NOT NULL UNIQUE,
    telefono VARCHAR(20) NOT NULL,
    direccion VARCHAR(255),
    sexo CHAR(1) NOT NULL,
    email VARCHAR(150),
    cod_sucursal VARCHAR(10) NOT NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_cliente_sucursal
        FOREIGN KEY (cod_sucursal)
        REFERENCES seguro_g29969634.sucursal(cod_sucursal),

    CONSTRAINT chk_cliente_sexo
        CHECK (sexo IN ('F', 'M'))
);


CREATE TABLE IF NOT EXISTS seguro_g29969634.contrato (
    nro_contrato VARCHAR(20) PRIMARY KEY,
    descrip_contrato VARCHAR(255) NOT NULL
);


CREATE TABLE IF NOT EXISTS seguro_g29969634.registro_contrato (
    id_registro_contrato BIGSERIAL PRIMARY KEY,
    nro_contrato VARCHAR(20) NOT NULL UNIQUE,
    cod_producto VARCHAR(10) NOT NULL,
    cod_cliente VARCHAR(10) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    monto NUMERIC(12,2) NOT NULL,
    estado_contrato VARCHAR(20) NOT NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_registro_contrato_contrato
        FOREIGN KEY (nro_contrato)
        REFERENCES seguro_g29969634.contrato(nro_contrato),

    CONSTRAINT fk_registro_contrato_producto
        FOREIGN KEY (cod_producto)
        REFERENCES seguro_g29969634.producto(cod_producto),

    CONSTRAINT fk_registro_contrato_cliente
        FOREIGN KEY (cod_cliente)
        REFERENCES seguro_g29969634.cliente(cod_cliente),

    CONSTRAINT chk_registro_contrato_fechas
        CHECK (fecha_fin >= fecha_inicio),

    CONSTRAINT chk_registro_contrato_monto
        CHECK (monto >= 0),

    CONSTRAINT chk_registro_contrato_estado
        CHECK (
            estado_contrato IN (
                'ACTIVO',
                'VENCIDO',
                'SUSPENDIDO'
            )
        )
);

-- ============================================================
-- 4. EVALUACIONES
-- ============================================================

CREATE TABLE IF NOT EXISTS seguro_g29969634.evaluacion_servicio (
    cod_evaluacion_servicio VARCHAR(10) PRIMARY KEY,
    nb_descripcion VARCHAR(50) NOT NULL,
    valor_calificacion INTEGER NOT NULL,

    CONSTRAINT chk_evaluacion_valor
        CHECK (valor_calificacion BETWEEN 1 AND 5)
);


CREATE TABLE IF NOT EXISTS seguro_g29969634.recomienda (
    id_recomendacion BIGSERIAL PRIMARY KEY,
    cod_cliente VARCHAR(10) NOT NULL,
    cod_producto VARCHAR(10) NOT NULL,
    cod_evaluacion_servicio VARCHAR(10) NOT NULL,
    recomienda_amigo CHAR(2) NOT NULL,
    fecha_evaluacion DATE NOT NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_recomienda_cliente
        FOREIGN KEY (cod_cliente)
        REFERENCES seguro_g29969634.cliente(cod_cliente),

    CONSTRAINT fk_recomienda_producto
        FOREIGN KEY (cod_producto)
        REFERENCES seguro_g29969634.producto(cod_producto),

    CONSTRAINT fk_recomienda_evaluacion
        FOREIGN KEY (cod_evaluacion_servicio)
        REFERENCES seguro_g29969634.evaluacion_servicio(
            cod_evaluacion_servicio
        ),

    CONSTRAINT chk_recomienda_amigo
        CHECK (recomienda_amigo IN ('SI', 'NO'))
);

-- ============================================================
-- 5. SINIESTROS
-- ============================================================

CREATE TABLE IF NOT EXISTS seguro_g29969634.siniestro (
    nro_siniestro VARCHAR(20) PRIMARY KEY,
    descripcion_siniestro VARCHAR(255) NOT NULL
);


CREATE TABLE IF NOT EXISTS seguro_g29969634.registro_siniestro (
    id_registro_siniestro BIGSERIAL PRIMARY KEY,
    nro_siniestro VARCHAR(20) NOT NULL UNIQUE,
    nro_contrato VARCHAR(20) NOT NULL,
    fecha_siniestro DATE NOT NULL,
    fecha_respuesta DATE,
    id_rechazo CHAR(2) NOT NULL,
    monto_reconocido NUMERIC(12,2) NOT NULL DEFAULT 0,
    monto_solicitado NUMERIC(12,2) NOT NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_registro_siniestro_siniestro
        FOREIGN KEY (nro_siniestro)
        REFERENCES seguro_g29969634.siniestro(nro_siniestro),

    CONSTRAINT fk_registro_siniestro_contrato
        FOREIGN KEY (nro_contrato)
        REFERENCES seguro_g29969634.contrato(nro_contrato),

    CONSTRAINT chk_registro_siniestro_rechazo
        CHECK (id_rechazo IN ('SI', 'NO')),

    CONSTRAINT chk_registro_siniestro_fechas
        CHECK (
            fecha_respuesta IS NULL
            OR fecha_respuesta >= fecha_siniestro
        ),

    CONSTRAINT chk_registro_siniestro_montos
        CHECK (
            monto_solicitado > 0
            AND monto_reconocido >= 0
            AND monto_reconocido <= monto_solicitado
        ),

    CONSTRAINT chk_registro_siniestro_rechazado
        CHECK (
            id_rechazo <> 'SI'
            OR (
                fecha_respuesta IS NOT NULL
                AND monto_reconocido = 0
            )
        )
);


-- ============================================================
-- 6. METAS COMERCIALES
-- ============================================================

CREATE TABLE IF NOT EXISTS seguro_g29969634.meta_comercial (
    id_meta BIGSERIAL PRIMARY KEY,
    cod_producto VARCHAR(10) NOT NULL,
    anio INTEGER NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    monto_meta_ingreso NUMERIC(14,2) NOT NULL,
    meta_renovacion INTEGER NOT NULL,
    meta_asegurados INTEGER NOT NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_meta_producto
        FOREIGN KEY (cod_producto)
        REFERENCES seguro_g29969634.producto(cod_producto),

    CONSTRAINT uq_meta_producto_anio
        UNIQUE (cod_producto, anio),

    CONSTRAINT chk_meta_fechas
        CHECK (fecha_fin >= fecha_inicio),

    CONSTRAINT chk_meta_ingreso
        CHECK (monto_meta_ingreso >= 0),

    CONSTRAINT chk_meta_renovacion
        CHECK (meta_renovacion >= 0),

    CONSTRAINT chk_meta_asegurados
        CHECK (meta_asegurados >= 0)
);


-- ============================================================
-- 1. DIMENSIONES
-- ============================================================


-- ------------------------------------------------------------
-- DIMENSIÓN TIEMPO
-- Una fila representa una fecha del calendario.
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS seguro_dw_g29969634.dim_tiempo (
    sk_dim_tiempo INTEGER GENERATED BY DEFAULT AS IDENTITY
        PRIMARY KEY,

    fecha_completa DATE NOT NULL UNIQUE,
    cod_anio INTEGER NOT NULL,
    cod_mes INTEGER NOT NULL,
    cod_dia INTEGER NOT NULL,
    desc_mes VARCHAR(20) NOT NULL,
    desc_trimestre VARCHAR(10) NOT NULL,
    desc_semestre VARCHAR(10) NOT NULL,

    CONSTRAINT uq_dim_tiempo_componentes
        UNIQUE (cod_anio, cod_mes, cod_dia),

    CONSTRAINT chk_dim_tiempo_mes
        CHECK (cod_mes BETWEEN 1 AND 12),

    CONSTRAINT chk_dim_tiempo_dia
        CHECK (cod_dia BETWEEN 1 AND 31),

    CONSTRAINT chk_dim_tiempo_trimestre
        CHECK (desc_trimestre IN ('Q1', 'Q2', 'Q3', 'Q4')),

    CONSTRAINT chk_dim_tiempo_semestre
        CHECK (desc_semestre IN ('S1', 'S2'))
);


-- ------------------------------------------------------------
-- DIMENSIÓN CLIENTE
-- Contiene los datos descriptivos de cada cliente.
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS seguro_dw_g29969634.dim_cliente (
    sk_dim_cliente INTEGER GENERATED BY DEFAULT AS IDENTITY
        PRIMARY KEY,

    cod_cliente VARCHAR(10) NOT NULL UNIQUE,
    nb_cliente VARCHAR(150) NOT NULL,
    ci_rif VARCHAR(20) NOT NULL UNIQUE,
    telefono VARCHAR(20) NOT NULL,
    direccion VARCHAR(255),
    sexo CHAR(1) NOT NULL,
    email VARCHAR(150),

    CONSTRAINT chk_dim_cliente_sexo
        CHECK (sexo IN ('F', 'M'))
);


-- ------------------------------------------------------------
-- DIMENSIÓN PRODUCTO
-- Incluye también los datos del tipo de producto.
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS seguro_dw_g29969634.dim_producto (
    sk_dim_producto INTEGER GENERATED BY DEFAULT AS IDENTITY
        PRIMARY KEY,

    cod_producto VARCHAR(10) NOT NULL UNIQUE,
    nb_producto VARCHAR(100) NOT NULL,
    descrip_producto VARCHAR(255) NOT NULL,
    cod_tipo_producto VARCHAR(10) NOT NULL,
    nb_tipo_producto VARCHAR(100) NOT NULL,
    calificacion NUMERIC(3,2) NOT NULL,

    CONSTRAINT chk_dim_producto_calificacion
        CHECK (calificacion BETWEEN 1 AND 5)
);



-- ------------------------------------------------------------
-- DIMENSIÓN CONTRATO
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS seguro_dw_g29969634.dim_contrato (
    sk_dim_contrato INTEGER GENERATED BY DEFAULT AS IDENTITY
        PRIMARY KEY,

    nro_contrato VARCHAR(20) NOT NULL UNIQUE,
    descrip_contrato VARCHAR(255) NOT NULL
);


-- ------------------------------------------------------------
-- DIMENSIÓN SUCURSAL
-- Incluye sucursal, ciudad y país en una sola dimensión.
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS seguro_dw_g29969634.dim_sucursal (
    sk_dim_sucursal INTEGER GENERATED BY DEFAULT AS IDENTITY
        PRIMARY KEY,

    cod_sucursal VARCHAR(10) NOT NULL UNIQUE,
    nb_sucursal VARCHAR(100) NOT NULL,

    cod_ciudad VARCHAR(10) NOT NULL,
    nb_ciudad VARCHAR(100) NOT NULL,

    cod_pais VARCHAR(10) NOT NULL,
    nb_pais VARCHAR(100) NOT NULL
);


-- ------------------------------------------------------------
-- DIMENSIÓN ESTADO DEL CONTRATO
-- Ejemplos: activo, vencido y suspendido.
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS seguro_dw_g29969634.dim_estado_contrato (
    sk_dim_estado INTEGER GENERATED BY DEFAULT AS IDENTITY
        PRIMARY KEY,

    cod_estado CHAR(2) NOT NULL UNIQUE,
    descrip_estado VARCHAR(50) NOT NULL
);


-- ------------------------------------------------------------
-- DIMENSIÓN EVALUACIÓN DEL SERVICIO
-- Ejemplos: Malo, Regular, Bueno, Muy Bueno y Excelente.
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS seguro_dw_g29969634.dim_evaluacion_servicio (
    sk_dim_evaluacion INTEGER GENERATED BY DEFAULT AS IDENTITY
        PRIMARY KEY,

    cod_evaluacion VARCHAR(10) NOT NULL UNIQUE,
    nb_descrip VARCHAR(50) NOT NULL,
    valor_calificacion INTEGER NOT NULL,

    CONSTRAINT chk_dim_evaluacion_valor
        CHECK (valor_calificacion BETWEEN 1 AND 5)
);


-- ------------------------------------------------------------
-- DIMENSIÓN SINIESTRO
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS seguro_dw_g29969634.dim_siniestro (
    sk_dim_siniestro INTEGER GENERATED BY DEFAULT AS IDENTITY
        PRIMARY KEY,

    nro_siniestro VARCHAR(20) NOT NULL UNIQUE,
    descrip_siniestro VARCHAR(255) NOT NULL
);


-- ============================================================
-- 2. TABLAS DE HECHOS
-- ============================================================


-- ------------------------------------------------------------
-- HECHO: REGISTRO DE CONTRATOS
--
-- Grano:
-- Un registro por contrato formalizado por un cliente
-- para un producto.
--
-- DIM_TIEMPO actúa como role-playing:
-- - Fecha de inicio
-- - Fecha de fin
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS seguro_dw_g29969634.fact_registro_contrato (
    id_fact_registro_contrato BIGINT
        GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,

    id_registro_contrato_fuente BIGINT NOT NULL UNIQUE,

    sk_fecha_inicio INTEGER NOT NULL,
    sk_fecha_fin INTEGER NOT NULL,
    sk_dim_cliente INTEGER NOT NULL,
    sk_dim_contrato INTEGER NOT NULL,
    sk_dim_producto INTEGER NOT NULL,
    sk_dim_estado INTEGER NOT NULL,

    monto NUMERIC(12,2) NOT NULL,
    cantidad INTEGER NOT NULL DEFAULT 1,

    CONSTRAINT fk_fact_contrato_fecha_inicio
        FOREIGN KEY (sk_fecha_inicio)
        REFERENCES seguro_dw_g29969634.dim_tiempo(sk_dim_tiempo),

    CONSTRAINT fk_fact_contrato_fecha_fin
        FOREIGN KEY (sk_fecha_fin)
        REFERENCES seguro_dw_g29969634.dim_tiempo(sk_dim_tiempo),

    CONSTRAINT fk_fact_contrato_cliente
        FOREIGN KEY (sk_dim_cliente)
        REFERENCES seguro_dw_g29969634.dim_cliente(sk_dim_cliente),

    CONSTRAINT fk_fact_contrato_contrato
        FOREIGN KEY (sk_dim_contrato)
        REFERENCES seguro_dw_g29969634.dim_contrato(sk_dim_contrato),

    CONSTRAINT fk_fact_contrato_producto
        FOREIGN KEY (sk_dim_producto)
        REFERENCES seguro_dw_g29969634.dim_producto(sk_dim_producto),

    CONSTRAINT fk_fact_contrato_estado
        FOREIGN KEY (sk_dim_estado)
        REFERENCES seguro_dw_g29969634.dim_estado_contrato(sk_dim_estado),


    CONSTRAINT chk_fact_contrato_monto
        CHECK (monto >= 0)
);


-- ------------------------------------------------------------
-- HECHO: REGISTRO DE SINIESTROS
--
-- Grano:
-- Un registro por siniestro reportado.
--
-- DIM_TIEMPO actúa como role-playing:
-- - Fecha del siniestro
-- - Fecha de respuesta
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS seguro_dw_g29969634.fact_registro_siniestro (
    id_fact_registro_siniestro BIGINT
        GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,

    id_registro_siniestro_fuente BIGINT NOT NULL UNIQUE,

    sk_fecha_siniestro INTEGER NOT NULL,
    sk_fecha_respuesta INTEGER,

    sk_dim_cliente INTEGER NOT NULL,
    sk_dim_contrato INTEGER NOT NULL,
    sk_dim_sucursal INTEGER NOT NULL,
    sk_dim_producto INTEGER NOT NULL,
    sk_dim_siniestro INTEGER NOT NULL,

    cantidad INTEGER NOT NULL DEFAULT 1,
    monto_reconocido NUMERIC(12,2) NOT NULL DEFAULT 0,
    monto_solicitado NUMERIC(12,2) NOT NULL,
    id_rechazo CHAR(2) NOT NULL,

    CONSTRAINT fk_fact_siniestro_fecha
        FOREIGN KEY (sk_fecha_siniestro)
        REFERENCES seguro_dw_g29969634.dim_tiempo(sk_dim_tiempo),

    CONSTRAINT fk_fact_siniestro_respuesta
        FOREIGN KEY (sk_fecha_respuesta)
        REFERENCES seguro_dw_g29969634.dim_tiempo(sk_dim_tiempo),

    CONSTRAINT fk_fact_siniestro_cliente
        FOREIGN KEY (sk_dim_cliente)
        REFERENCES seguro_dw_g29969634.dim_cliente(sk_dim_cliente),

    CONSTRAINT fk_fact_siniestro_contrato
        FOREIGN KEY (sk_dim_contrato)
        REFERENCES seguro_dw_g29969634.dim_contrato(sk_dim_contrato),

    CONSTRAINT fk_fact_siniestro_sucursal
        FOREIGN KEY (sk_dim_sucursal)
        REFERENCES seguro_dw_g29969634.dim_sucursal(sk_dim_sucursal),

    CONSTRAINT fk_fact_siniestro_producto
        FOREIGN KEY (sk_dim_producto)
        REFERENCES seguro_dw_g29969634.dim_producto(sk_dim_producto),

    CONSTRAINT fk_fact_siniestro_tipo
        FOREIGN KEY (sk_dim_siniestro)
        REFERENCES seguro_dw_g29969634.dim_siniestro(sk_dim_siniestro),

    CONSTRAINT chk_fact_siniestro_rechazo
        CHECK (id_rechazo IN ('SI', 'NO')),

    CONSTRAINT chk_fact_siniestro_montos
        CHECK (
            monto_solicitado > 0
            AND monto_reconocido >= 0
            AND monto_reconocido <= monto_solicitado
        ),

    CONSTRAINT chk_fact_siniestro_rechazado
        CHECK (
            id_rechazo <> 'SI'
            OR monto_reconocido = 0
        )
);


-- ------------------------------------------------------------
-- HECHO: EVALUACIÓN DEL SERVICIO
--
-- Grano:
-- Un registro por evaluación realizada por un cliente
-- sobre un producto en una fecha.
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS seguro_dw_g29969634.fact_evaluacion_servicio (
    id_fact_evaluacion BIGINT
        GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,

    id_recomendacion_fuente BIGINT NOT NULL UNIQUE,

    sk_dim_tiempo INTEGER NOT NULL,
    sk_dim_cliente INTEGER NOT NULL,
    sk_dim_producto INTEGER NOT NULL,
    sk_dim_evaluacion INTEGER NOT NULL,

    cantidad INTEGER NOT NULL DEFAULT 1,

    -- 1 significa que sí recomienda el producto.
    -- 0 significa que no lo recomienda.
    recomienda_amigo SMALLINT NOT NULL,

    CONSTRAINT fk_fact_evaluacion_tiempo
        FOREIGN KEY (sk_dim_tiempo)
        REFERENCES seguro_dw_g29969634.dim_tiempo(
            sk_dim_tiempo
        ),

    CONSTRAINT fk_fact_evaluacion_cliente
        FOREIGN KEY (sk_dim_cliente)
        REFERENCES seguro_dw_g29969634.dim_cliente(
            sk_dim_cliente
        ),

    CONSTRAINT fk_fact_evaluacion_producto
        FOREIGN KEY (sk_dim_producto)
        REFERENCES seguro_dw_g29969634.dim_producto(
            sk_dim_producto
        ),

    CONSTRAINT fk_fact_evaluacion_tipo
        FOREIGN KEY (sk_dim_evaluacion)
        REFERENCES seguro_dw_g29969634.dim_evaluacion_servicio(
            sk_dim_evaluacion
        ),

    CONSTRAINT chk_fact_evaluacion_recomienda
        CHECK (recomienda_amigo IN (0, 1))
);


-- ------------------------------------------------------------
-- HECHO: METAS COMERCIALES
--
-- Grano:
-- Un registro por meta anual establecida para un producto.
--
-- DIM_TIEMPO actúa como role-playing:
-- - Fecha de inicio de la meta
-- - Fecha de fin de la meta
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS seguro_dw_g29969634.fact_metas (
    id_fact_meta BIGINT
        GENERATED BY DEFAULT AS IDENTITY
        PRIMARY KEY,

    id_meta_fuente BIGINT NOT NULL UNIQUE,

    sk_fecha_inicio_meta INTEGER NOT NULL,
    sk_fecha_fin_meta INTEGER NOT NULL,
    sk_dim_producto INTEGER NOT NULL,

    monto_meta_ingreso NUMERIC(14,2) NOT NULL,
    meta_renovacion INTEGER NOT NULL,
    meta_asegurados INTEGER NOT NULL,

    CONSTRAINT uq_fact_meta_producto_periodo
        UNIQUE (
            sk_dim_producto,
            sk_fecha_inicio_meta,
            sk_fecha_fin_meta
        ),

    CONSTRAINT fk_fact_meta_fecha_inicio
        FOREIGN KEY (sk_fecha_inicio_meta)
        REFERENCES seguro_dw_g29969634.dim_tiempo(
            sk_dim_tiempo
        ),

    CONSTRAINT fk_fact_meta_fecha_fin
        FOREIGN KEY (sk_fecha_fin_meta)
        REFERENCES seguro_dw_g29969634.dim_tiempo(
            sk_dim_tiempo
        ),

    CONSTRAINT fk_fact_meta_producto
        FOREIGN KEY (sk_dim_producto)
        REFERENCES seguro_dw_g29969634.dim_producto(
            sk_dim_producto
        ),

    CONSTRAINT chk_fact_meta_valores
        CHECK (
            monto_meta_ingreso > 0
            AND meta_renovacion > 0
            AND meta_asegurados > 0
        )
);