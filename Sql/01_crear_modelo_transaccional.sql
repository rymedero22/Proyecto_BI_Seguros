-- ============================================================
-- PROYECTO BI - SEGUROS ALTA VISTA
-- 02. CREACIÓN DEL MODELO TRANSACCIONAL
-- Esquema: seguro_g29969634
-- ============================================================
-- 1. CREACIÓN DE ESQUEMA
-- =====================================================

CREATE SCHEMA IF NOT EXISTS seguro_g29969634;

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