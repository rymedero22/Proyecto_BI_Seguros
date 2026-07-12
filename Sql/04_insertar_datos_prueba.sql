-- ============================================================
-- PROYECTO BI - SEGUROS ALTA VISTA
-- 04. INSERCIÓN DE DATOS DE PRUEBA CORREGIDOS
-- Esquema fuente: seguro_g29969634
--
-- El archivo contiene INSERT INTO ... VALUES explícitos.
-- No utiliza WITH, arreglos, generate_series ni generación
-- dinámica dentro de PostgreSQL.
--
-- Cantidades:
--   1 país
--   8 ciudades
--   8 sucursales
--   5 tipos de producto
--   15 productos
--   50 clientes
--   90 contratos y 90 registros de contrato
--   5 tipos de evaluación y 68 evaluaciones
--   30 siniestros y 30 registros de siniestro
--   45 metas comerciales
--
-- Coherencia aplicada:
--   * El sexo corresponde con el nombre del cliente.
--   * Cada descripción de contrato corresponde con su producto.
--   * Cada siniestro corresponde con el producto del contrato.
--   * Hay 2 contratos por producto en cada año 2024-2026.
--   * Las metas se relacionan con el volumen e ingreso real.
--   * Las variaciones controladas solo afectan formato de textos.
-- ============================================================

BEGIN;

-- Vaciar primero el Data Warehouse
TRUNCATE TABLE
    seguro_dw_g29969634.fact_registro_contrato,
    seguro_dw_g29969634.fact_registro_siniestro,
    seguro_dw_g29969634.fact_evaluacion_servicio,
    seguro_dw_g29969634.fact_metas,
    seguro_dw_g29969634.dim_cliente,
    seguro_dw_g29969634.dim_contrato,
    seguro_dw_g29969634.dim_estado_contrato,
    seguro_dw_g29969634.dim_evaluacion_servicio,
    seguro_dw_g29969634.dim_producto,
    seguro_dw_g29969634.dim_siniestro,
    seguro_dw_g29969634.dim_sucursal,
    seguro_dw_g29969634.dim_tiempo
RESTART IDENTITY CASCADE;

-- Vaciar después el modelo transaccional
TRUNCATE TABLE
    seguro_g29969634.registro_siniestro,
    seguro_g29969634.recomienda,
    seguro_g29969634.registro_contrato,
    seguro_g29969634.meta_comercial,
    seguro_g29969634.siniestro,
    seguro_g29969634.evaluacion_servicio,
    seguro_g29969634.contrato,
    seguro_g29969634.cliente,
    seguro_g29969634.producto,
    seguro_g29969634.tipo_producto,
    seguro_g29969634.sucursal,
    seguro_g29969634.ciudad,
    seguro_g29969634.pais
RESTART IDENTITY CASCADE;


-- 1. PAÍS
INSERT INTO seguro_g29969634.pais (cod_pais, nb_pais)
VALUES
    ('VE', 'Venezuela');


-- 2. CIUDADES
INSERT INTO seguro_g29969634.ciudad (cod_ciudad, nb_ciudad, cod_pais)
VALUES
    ('CCS', 'Caracas', 'VE'),
    ('MAR', '  maracaibo ', 'VE'),
    ('VAL', 'VALENCIA', 'VE'),
    ('BQT', 'Barquisimeto', 'VE'),
    ('PZO', 'puerto ordaz', 'VE'),
    ('MRY', 'Maracay', 'VE'),
    ('MER', '  Mérida', 'VE'),
    ('SCT', 'San Cristóbal ', 'VE');


-- 3. SUCURSALES
INSERT INTO seguro_g29969634.sucursal (cod_sucursal, nb_sucursal, cod_ciudad)
VALUES
    ('SUC001', 'Sucursal Caracas Centro', 'CCS'),
    ('SUC002', '  sucursal maracaibo norte ', 'MAR'),
    ('SUC003', 'SUCURSAL VALENCIA', 'VAL'),
    ('SUC004', 'Sucursal Barquisimeto Este', 'BQT'),
    ('SUC005', 'sucursal alta vista', 'PZO'),
    ('SUC006', 'Sucursal Maracay Centro', 'MRY'),
    ('SUC007', '  Sucursal Mérida ', 'MER'),
    ('SUC008', 'Sucursal San Cristóbal', 'SCT');


-- 4. TIPOS DE PRODUCTO
INSERT INTO seguro_g29969634.tipo_producto (cod_tipo_producto, nb_tipo_producto)
VALUES
    ('TP01', 'Personales'),
    ('TP02', '  daños '),
    ('TP03', 'PATRIMONIALES'),
    ('TP04', 'Prestación de Servicios'),
    ('TP05', 'empresariales');


-- 5. PRODUCTOS
INSERT INTO seguro_g29969634.producto (
    cod_producto, nb_producto, descripcion, cod_tipo_producto, calificacion
)
VALUES
    ('PROD001', 'Seguro de Vida', 'Protección económica para familiares y beneficiarios.', 'TP01', 4.40),
    ('PROD002', '  seguro de salud ', 'cobertura médica, hospitalaria y de emergencias ', 'TP01', 4.65),
    ('PROD003', 'SEGURO DE VIAJE', 'Cobertura durante viajes nacionales e internacionales.', 'TP01', 4.10),
    ('PROD004', 'Seguro de Automóvil', 'Protección para vehículos y responsabilidad civil.', 'TP02', 4.55),
    ('PROD005', ' seguro contra incendios', 'COBERTURA ANTE DAÑOS OCASIONADOS POR INCENDIOS.', 'TP02', 3.95),
    ('PROD006', 'Seguro contra Robo ', 'Protección ante robo de bienes asegurados.', 'TP02', 4.05),
    ('PROD007', 'Seguro de Hogar', 'Protección integral para viviendas y bienes personales.', 'TP03', 4.50),
    ('PROD008', 'SEGURO EMPRESARIAL', 'cobertura patrimonial para pequeñas y medianas empresas', 'TP03', 4.20),
    ('PROD009', ' Crédito y Caución ', 'Garantía para obligaciones contractuales y comerciales.', 'TP03', 3.85),
    ('PROD010', 'Asistencia Vial', 'Servicio de grúa y asistencia para vehículos.', 'TP04', 4.70),
    ('PROD011', 'Asistencia Funeraria', 'Servicios de previsión y asistencia funeraria.', 'TP04', 4.35),
    ('PROD012', '  asistencia odontológica ', 'ATENCIÓN ODONTOLÓGICA PREVENTIVA Y DE EMERGENCIA.', 'TP04', 4.00),
    ('PROD013', 'Seguro para Comercios', 'Cobertura integral para establecimientos comerciales.', 'TP05', 4.25),
    ('PROD014', ' SEGURO DE TRANSPORTE DE MERCANCÍA ', 'protección de mercancías durante su traslado', 'TP05', 4.15),
    ('PROD015', 'Responsabilidad Civil Empresarial', 'Cobertura por daños a terceros derivados de la actividad.', 'TP05', 4.30);


-- 6. TIPOS DE EVALUACIÓN
INSERT INTO seguro_g29969634.evaluacion_servicio (
    cod_evaluacion_servicio, nb_descripcion, valor_calificacion
)
VALUES
    ('EV01', 'Malo', 1),
    ('EV02', 'Regular', 2),
    ('EV03', 'Bueno', 3),
    ('EV04', 'Muy Bueno', 4),
    ('EV05', 'Excelente', 5);


-- 7. CLIENTES
-- CLI0001 a CLI0023 contienen variaciones controladas de formato.
INSERT INTO seguro_g29969634.cliente (
    cod_cliente, nb_cliente, ci_rif, telefono,
    direccion, sexo, email, cod_sucursal
)
VALUES
    ('CLI0001', '  maría fernanda gonzález ', 'V10013791', '04141000731', 'Av. Francisco de Miranda, Caracas, Apto. 1', 'F', ' MARIA.GONZALEZ@CORREO.COM ', 'SUC001'),
    ('CLI0002', '  carlos eduardo ramírez ', 'V10027582', '04141001462', 'Av. 5 de Julio, Maracaibo, Casa 2', 'M', 'Carlos.Ramirez@Correo.Com', 'SUC002'),
    ('CLI0003', '  andrea carolina méndez ', 'V10041373', '04141002193', '  urb. la viña, valencia, casa 3 ', 'F', ' ANDREA.MENDEZ@CORREO.COM ', 'SUC003'),
    ('CLI0004', '  josé antonio rodríguez ', 'V10055164', '04141002924', 'Av. Lara, Barquisimeto, Local 4', 'M', 'Jose.Rodriguez@Correo.Com', 'SUC004'),
    ('CLI0005', 'VALENTINA ISABEL PÉREZ', 'V10068955', '04141003655', 'Av. Las Américas, Puerto Ordaz, Apto. 5', 'F', ' VALENTINA.PEREZ@CORREO.COM ', 'SUC005'),
    ('CLI0006', 'LUIS ALBERTO HERNÁNDEZ', 'V10082746', '04141004386', ' AV. BOLÍVAR, MARACAY, CASA 6 ', 'M', 'Luis.Hernandez@Correo.Com', 'SUC006'),
    ('CLI0007', 'GABRIELA ALEJANDRA TORRES', 'V10096537', '04141005117', 'Av. Las Américas, Mérida, Apto. 7', 'F', ' GABRIELA.TORRES@CORREO.COM ', 'SUC007'),
    ('CLI0008', 'MIGUEL ÁNGEL CASTILLO', 'V10110328', '04141005848', 'Av. Carabobo, San Cristóbal, Casa 8', 'M', 'Miguel.Castillo@Correo.Com', 'SUC008'),
    ('CLI0009', 'Sofía Victoria Morales', 'V-10.124.119', '04141006579', '  av. francisco de miranda, caracas, apto. 9 ', 'F', ' SOFIA.MORALES@CORREO.COM ', 'SUC001'),
    ('CLI0010', 'Daniel Alejandro Rojas', 'V-10.137.910', '04141007310', 'Av. 5 de Julio, Maracaibo, Casa 10', 'M', 'Daniel.Rojas@Correo.Com', 'SUC002'),
    ('CLI0011', 'Camila Andrea Silva', 'V-10.151.701', '04141008041', 'Urb. La Viña, Valencia, Casa 11', 'F', ' CAMILA.SILVA@CORREO.COM ', 'SUC003'),
    ('CLI0012', 'Francisco Javier Vargas', 'V 10165492', '04141008772', ' AV. LARA, BARQUISIMETO, LOCAL 12 ', 'M', 'Francisco.Vargas@Correo.Com', 'SUC004'),
    ('CLI0013', 'Isabella Cristina Romero', 'V 10179283', '04141009503', 'Av. Las Américas, Puerto Ordaz, Apto. 13', 'F', ' ISABELLA.ROMERO@CORREO.COM ', 'SUC005'),
    ('CLI0014', 'Alejandro José Navarro', 'v-10193074', '04141010234', 'Av. Bolívar, Maracay, Casa 14', 'M', 'Alejandro.Navarro@Correo.Com', 'SUC006'),
    ('CLI0015', 'Natalia Beatriz Herrera', 'v-10206865', '04141010965', '  av. las américas, mérida, apto. 15 ', 'F', ' NATALIA.HERRERA@CORREO.COM ', 'SUC007'),
    ('CLI0016', 'Ricardo Andrés Suárez', 'V10220656', '0414-1011696', 'Av. Carabobo, San Cristóbal, Casa 16', 'M', 'Ricardo.Suarez@Correo.Com', 'SUC008'),
    ('CLI0017', 'Paola Andreína Campos', 'V10234447', '0414-1012427', 'Av. Francisco de Miranda, Caracas, Apto. 17', 'F', ' PAOLA.CAMPOS@CORREO.COM ', 'SUC001'),
    ('CLI0018', 'Manuel Enrique Ortega', 'V10248238', '(0414) 1013158', ' AV. 5 DE JULIO, MARACAIBO, CASA 18 ', 'M', 'Manuel.Ortega@Correo.Com', 'SUC002'),
    ('CLI0019', 'Mariana Alejandra Acosta', 'V10262029', '(0414) 1013889', 'Urb. La Viña, Valencia, Casa 19', 'F', ' MARIANA.ACOSTA@CORREO.COM ', 'SUC003'),
    ('CLI0020', 'Jorge Luis Salazar', 'V10275820', '0414 101 46 20', 'Av. Lara, Barquisimeto, Local 20', 'M', 'Jorge.Salazar@Correo.Com', 'SUC004'),
    ('CLI0021', 'Laura Carolina Zambrano', 'V10289611', '0414 101 53 51', '  av. las américas, puerto ordaz, apto. 21 ', 'F', ' LAURA.ZAMBRANO@CORREO.COM ', 'SUC005'),
    ('CLI0022', 'Jesús Alberto Figueroa', 'V10303402', '+58 414-1016082', 'Av. Bolívar, Maracay, Casa 22', 'M', 'Jesus.Figueroa@Correo.Com', 'SUC006'),
    ('CLI0023', 'Daniela Sofía Delgado', 'V10317193', '+58 414-1016813', 'Av. Las Américas, Mérida, Apto. 23', 'F', ' DANIELA.DELGADO@CORREO.COM ', 'SUC007'),
    ('CLI0024', 'Pedro Antonio Márquez', 'V10330984', '04141017544', 'Av. Carabobo, San Cristóbal, Casa 24', 'M', 'pedro.marquez@correo.com', 'SUC008'),
    ('CLI0025', 'Ana Victoria Molina', 'V10344775', '04141018275', 'Av. Francisco de Miranda, Caracas, Apto. 25', 'F', 'ana.molina@correo.com', 'SUC001'),
    ('CLI0026', 'Roberto Carlos Medina', 'V10358566', '04141019006', 'Av. 5 de Julio, Maracaibo, Casa 26', 'M', 'roberto.medina@correo.com', 'SUC002'),
    ('CLI0027', 'Patricia Elena Cabrera', 'V10372357', '04141019737', 'Urb. La Viña, Valencia, Casa 27', 'F', 'patricia.cabrera@correo.com', 'SUC003'),
    ('CLI0028', 'Héctor José Fuentes', 'V10386148', '04141020468', 'Av. Lara, Barquisimeto, Local 28', 'M', 'hector.fuentes@correo.com', 'SUC004'),
    ('CLI0029', 'Verónica Alejandra León', 'V10399939', '04141021199', 'Av. Las Américas, Puerto Ordaz, Apto. 29', 'F', 'veronica.leon@correo.com', 'SUC005'),
    ('CLI0030', 'Fernando Miguel Paredes', 'V10413730', '04141021930', 'Av. Bolívar, Maracay, Casa 30', 'M', 'fernando.paredes@correo.com', 'SUC006'),
    ('CLI0031', 'Claudia Marcela Núñez', 'V10427521', '04141022661', 'Av. Las Américas, Mérida, Apto. 31', 'F', 'claudia.nunez@correo.com', 'SUC007'),
    ('CLI0032', 'Rafael Eduardo Blanco', 'V10441312', '04141023392', 'Av. Carabobo, San Cristóbal, Casa 32', 'M', 'rafael.blanco@correo.com', 'SUC008'),
    ('CLI0033', 'Adriana Paola Cedeño', 'V10455103', '04141024123', 'Av. Francisco de Miranda, Caracas, Apto. 33', 'F', 'adriana.cedeno@correo.com', 'SUC001'),
    ('CLI0034', 'Óscar Javier Villalobos', 'V10468894', '04141024854', 'Av. 5 de Julio, Maracaibo, Casa 34', 'M', 'oscar.villalobos@correo.com', 'SUC002'),
    ('CLI0035', 'Carolina Isabel Quintero', 'V10482685', '04141025585', 'Urb. La Viña, Valencia, Casa 35', 'F', 'carolina.quintero@correo.com', 'SUC003'),
    ('CLI0036', 'Víctor Manuel Espinoza', 'V10496476', '04141026316', 'Av. Lara, Barquisimeto, Local 36', 'M', 'victor.espinoza@correo.com', 'SUC004'),
    ('CLI0037', 'Mónica Gabriela Arias', 'V10510267', '04141027047', 'Av. Las Américas, Puerto Ordaz, Apto. 37', 'F', 'monica.arias@correo.com', 'SUC005'),
    ('CLI0038', 'Alberto José Contreras', 'V10524058', '04141027778', 'Av. Bolívar, Maracay, Casa 38', 'M', 'alberto.contreras@correo.com', 'SUC006'),
    ('CLI0039', 'Elena María Velásquez', 'V10537849', '04141028509', 'Av. Las Américas, Mérida, Apto. 39', 'F', 'elena.velasquez@correo.com', 'SUC007'),
    ('CLI0040', 'Samuel David Carrasco', 'V10551640', '04141029240', 'Av. Carabobo, San Cristóbal, Casa 40', 'M', 'samuel.carrasco@correo.com', 'SUC008'),
    ('CLI0041', 'Lorena Patricia Mendoza', 'V10565431', '04141029971', 'Av. Francisco de Miranda, Caracas, Apto. 41', 'F', 'lorena.mendoza@correo.com', 'SUC001'),
    ('CLI0042', 'Diego Alejandro Gil', 'V10579222', '04141030702', 'Av. 5 de Julio, Maracaibo, Casa 42', 'M', 'diego.gil@correo.com', 'SUC002'),
    ('CLI0043', 'Beatriz Elena Montoya', 'V10593013', '04141031433', 'Urb. La Viña, Valencia, Casa 43', 'F', 'beatriz.montoya@correo.com', 'SUC003'),
    ('CLI0044', 'Tomás Enrique Serrano', 'V10606804', '04141032164', 'Av. Lara, Barquisimeto, Local 44', 'M', 'tomas.serrano@correo.com', 'SUC004'),
    ('CLI0045', 'Karla Vanessa Pinto', 'V10620595', '04141032895', 'Av. Las Américas, Puerto Ordaz, Apto. 45', 'F', 'karla.pinto@correo.com', 'SUC005'),
    ('CLI0046', 'Emilio José Urdaneta', 'V10634386', '04141033626', 'Av. Bolívar, Maracay, Casa 46', 'M', 'emilio.urdaneta@correo.com', 'SUC006'),
    ('CLI0047', 'Roxana Isabel Peña', 'V10648177', '04141034357', 'Av. Las Américas, Mérida, Apto. 47', 'F', 'roxana.pena@correo.com', 'SUC007'),
    ('CLI0048', 'Marco Antonio Brito', 'V10661968', '04141035088', 'Av. Carabobo, San Cristóbal, Casa 48', 'M', 'marco.brito@correo.com', 'SUC008'),
    ('CLI0049', 'Teresa Cristina Valera', 'V10675759', '04141035819', 'Av. Francisco de Miranda, Caracas, Apto. 49', 'F', 'teresa.valera@correo.com', 'SUC001'),
    ('CLI0050', 'Nicolás Eduardo Parra', 'V10689550', '04141036550', 'Av. 5 de Julio, Maracaibo, Casa 50', 'M', 'nicolas.parra@correo.com', 'SUC002');


-- 8. CONTRATOS
-- La descripción identifica el tipo real de contrato.
INSERT INTO seguro_g29969634.contrato (
    nro_contrato, descrip_contrato
)
VALUES
    ('CONT0001', '  contrato de seguro de vida '),
    ('CONT0002', '  contrato de seguro de vida '),
    ('CONT0003', '  contrato de seguro de salud '),
    ('CONT0004', '  contrato de seguro de salud '),
    ('CONT0005', '  contrato de seguro de viaje '),
    ('CONT0006', '  contrato de seguro de viaje '),
    ('CONT0007', '  contrato de seguro de automóvil '),
    ('CONT0008', '  contrato de seguro de automóvil '),
    ('CONT0009', '  contrato de seguro contra incendios '),
    ('CONT0010', '  contrato de seguro contra incendios '),
    ('CONT0011', '  contrato de seguro contra robo '),
    ('CONT0012', '  contrato de seguro contra robo '),
    ('CONT0013', '  contrato de seguro de hogar '),
    ('CONT0014', '  contrato de seguro de hogar '),
    ('CONT0015', 'CONTRATO DE SEGURO EMPRESARIAL'),
    ('CONT0016', 'CONTRATO DE SEGURO EMPRESARIAL'),
    ('CONT0017', 'CONTRATO DE CRÉDITO Y CAUCIÓN'),
    ('CONT0018', 'CONTRATO DE CRÉDITO Y CAUCIÓN'),
    ('CONT0019', 'CONTRATO DE ASISTENCIA VIAL'),
    ('CONT0020', 'CONTRATO DE ASISTENCIA VIAL'),
    ('CONT0021', 'CONTRATO DE ASISTENCIA FUNERARIA'),
    ('CONT0022', 'CONTRATO DE ASISTENCIA FUNERARIA'),
    ('CONT0023', 'CONTRATO DE ASISTENCIA ODONTOLÓGICA'),
    ('CONT0024', 'CONTRATO DE ASISTENCIA ODONTOLÓGICA'),
    ('CONT0025', 'CONTRATO DE SEGURO PARA COMERCIOS'),
    ('CONT0026', 'CONTRATO DE SEGURO PARA COMERCIOS'),
    ('CONT0027', 'CONTRATO DE SEGURO DE TRANSPORTE DE MERCANCÍA'),
    ('CONT0028', 'CONTRATO DE SEGURO DE TRANSPORTE DE MERCANCÍA'),
    ('CONT0029', 'Contrato DE Responsabilidad Civil Empresarial'),
    ('CONT0030', 'Contrato DE Responsabilidad Civil Empresarial'),
    ('CONT0031', 'Contrato DE Seguro de Vida'),
    ('CONT0032', 'Contrato DE Seguro de Vida'),
    ('CONT0033', 'Contrato DE Seguro de Salud'),
    ('CONT0034', 'Contrato DE Seguro de Salud'),
    ('CONT0035', 'Contrato DE Seguro de Viaje'),
    ('CONT0036', 'Contrato DE Seguro de Viaje'),
    ('CONT0037', 'Contrato DE Seguro de Automóvil'),
    ('CONT0038', 'Contrato DE Seguro de Automóvil'),
    ('CONT0039', 'Contrato DE Seguro contra Incendios'),
    ('CONT0040', 'Contrato DE Seguro contra Incendios'),
    ('CONT0041', 'Contrato DE Seguro contra Robo'),
    ('CONT0042', 'Contrato de Seguro contra Robo'),
    ('CONT0043', 'Contrato de Seguro de Hogar'),
    ('CONT0044', 'Contrato de Seguro de Hogar'),
    ('CONT0045', 'Contrato de Seguro Empresarial'),
    ('CONT0046', 'Contrato de Seguro Empresarial'),
    ('CONT0047', 'Contrato de Crédito y Caución'),
    ('CONT0048', 'Contrato de Crédito y Caución'),
    ('CONT0049', 'Contrato de Asistencia Vial'),
    ('CONT0050', 'Contrato de Asistencia Vial'),
    ('CONT0051', 'Contrato de Asistencia Funeraria'),
    ('CONT0052', 'Contrato de Asistencia Funeraria'),
    ('CONT0053', 'Contrato de Asistencia Odontológica'),
    ('CONT0054', 'Contrato de Asistencia Odontológica'),
    ('CONT0055', 'Contrato de Seguro para Comercios'),
    ('CONT0056', 'Contrato de Seguro para Comercios'),
    ('CONT0057', 'Contrato de Seguro de Transporte de Mercancía'),
    ('CONT0058', 'Contrato de Seguro de Transporte de Mercancía'),
    ('CONT0059', 'Contrato de Responsabilidad Civil Empresarial'),
    ('CONT0060', 'Contrato de Responsabilidad Civil Empresarial'),
    ('CONT0061', 'Contrato de Seguro de Vida'),
    ('CONT0062', 'Contrato de Seguro de Vida'),
    ('CONT0063', 'Contrato de Seguro de Salud'),
    ('CONT0064', 'Contrato de Seguro de Salud'),
    ('CONT0065', 'Contrato de Seguro de Viaje'),
    ('CONT0066', 'Contrato de Seguro de Viaje'),
    ('CONT0067', 'Contrato de Seguro de Automóvil'),
    ('CONT0068', 'Contrato de Seguro de Automóvil'),
    ('CONT0069', 'Contrato de Seguro contra Incendios'),
    ('CONT0070', 'Contrato de Seguro contra Incendios'),
    ('CONT0071', 'Contrato de Seguro contra Robo'),
    ('CONT0072', 'Contrato de Seguro contra Robo'),
    ('CONT0073', 'Contrato de Seguro de Hogar'),
    ('CONT0074', 'Contrato de Seguro de Hogar'),
    ('CONT0075', 'Contrato de Seguro Empresarial'),
    ('CONT0076', 'Contrato de Seguro Empresarial'),
    ('CONT0077', 'Contrato de Crédito y Caución'),
    ('CONT0078', 'Contrato de Crédito y Caución'),
    ('CONT0079', 'Contrato de Asistencia Vial'),
    ('CONT0080', 'Contrato de Asistencia Vial'),
    ('CONT0081', 'Contrato de Asistencia Funeraria'),
    ('CONT0082', 'Contrato de Asistencia Funeraria'),
    ('CONT0083', 'Contrato de Asistencia Odontológica'),
    ('CONT0084', 'Contrato de Asistencia Odontológica'),
    ('CONT0085', 'Contrato de Seguro para Comercios'),
    ('CONT0086', 'Contrato de Seguro para Comercios'),
    ('CONT0087', 'Contrato de Seguro de Transporte de Mercancía'),
    ('CONT0088', 'Contrato de Seguro de Transporte de Mercancía'),
    ('CONT0089', 'Contrato de Responsabilidad Civil Empresarial'),
    ('CONT0090', 'Contrato de Responsabilidad Civil Empresarial');


-- 9. REGISTROS DE CONTRATO
-- 30 contratos por año y 6 contratos por producto.
INSERT INTO seguro_g29969634.registro_contrato (
    nro_contrato, cod_producto, cod_cliente,
    fecha_inicio, fecha_fin, monto, estado_contrato
)
VALUES
    ('CONT0001', 'PROD001', 'CLI0001', DATE '2024-01-10', DATE '2025-01-09', 1104.00, 'VENCIDO'),
    ('CONT0002', 'PROD001', 'CLI0002', DATE '2024-01-19', DATE '2025-01-18', 1344.00, 'VENCIDO'),
    ('CONT0003', 'PROD002', 'CLI0003', DATE '2024-02-01', DATE '2025-01-31', 874.00, 'VENCIDO'),
    ('CONT0004', 'PROD002', 'CLI0004', DATE '2024-02-10', DATE '2025-02-09', 1064.00, 'VENCIDO'),
    ('CONT0005', 'PROD003', 'CLI0005', DATE '2024-02-23', DATE '2025-02-22', 441.60, 'VENCIDO'),
    ('CONT0006', 'PROD003', 'CLI0006', DATE '2024-03-03', DATE '2025-03-02', 537.60, 'VENCIDO'),
    ('CONT0007', 'PROD004', 'CLI0007', DATE '2024-03-16', DATE '2025-03-15', 1058.00, 'SUSPENDIDO'),
    ('CONT0008', 'PROD004', 'CLI0008', DATE '2024-03-25', DATE '2025-03-24', 1288.00, 'VENCIDO'),
    ('CONT0009', 'PROD005', 'CLI0009', DATE '2024-04-07', DATE '2025-04-06', 1380.00, 'VENCIDO'),
    ('CONT0010', 'PROD005', 'CLI0010', DATE '2024-04-16', DATE '2025-04-15', 1680.00, 'VENCIDO'),
    ('CONT0011', 'PROD006', 'CLI0011', DATE '2024-04-29', DATE '2025-04-28', 754.40, 'VENCIDO'),
    ('CONT0012', 'PROD006', 'CLI0012', DATE '2024-05-08', DATE '2025-05-07', 918.40, 'VENCIDO'),
    ('CONT0013', 'PROD007', 'CLI0013', DATE '2024-05-21', DATE '2025-05-20', 920.00, 'VENCIDO'),
    ('CONT0014', 'PROD007', 'CLI0014', DATE '2024-05-30', DATE '2025-05-29', 1120.00, 'SUSPENDIDO'),
    ('CONT0015', 'PROD008', 'CLI0015', DATE '2024-06-12', DATE '2025-06-11', 2024.00, 'VENCIDO'),
    ('CONT0016', 'PROD008', 'CLI0016', DATE '2024-06-21', DATE '2025-06-20', 2464.00, 'VENCIDO'),
    ('CONT0017', 'PROD009', 'CLI0017', DATE '2024-07-04', DATE '2025-07-03', 1656.00, 'VENCIDO'),
    ('CONT0018', 'PROD009', 'CLI0018', DATE '2024-07-13', DATE '2025-07-12', 2016.00, 'VENCIDO'),
    ('CONT0019', 'PROD010', 'CLI0019', DATE '2024-07-26', DATE '2025-07-25', 294.40, 'VENCIDO'),
    ('CONT0020', 'PROD010', 'CLI0020', DATE '2024-08-04', DATE '2025-08-03', 358.40, 'VENCIDO'),
    ('CONT0021', 'PROD011', 'CLI0021', DATE '2024-08-17', DATE '2025-08-16', 478.40, 'SUSPENDIDO'),
    ('CONT0022', 'PROD011', 'CLI0022', DATE '2024-08-26', DATE '2025-08-25', 582.40, 'VENCIDO'),
    ('CONT0023', 'PROD012', 'CLI0023', DATE '2024-09-08', DATE '2025-09-07', 349.60, 'VENCIDO'),
    ('CONT0024', 'PROD012', 'CLI0024', DATE '2024-09-17', DATE '2025-09-16', 425.60, 'VENCIDO'),
    ('CONT0025', 'PROD013', 'CLI0025', DATE '2024-09-30', DATE '2025-09-29', 1518.00, 'VENCIDO'),
    ('CONT0026', 'PROD013', 'CLI0026', DATE '2024-10-09', DATE '2025-10-08', 1848.00, 'VENCIDO'),
    ('CONT0027', 'PROD014', 'CLI0027', DATE '2024-10-22', DATE '2025-10-21', 1932.00, 'VENCIDO'),
    ('CONT0028', 'PROD014', 'CLI0028', DATE '2024-10-31', DATE '2025-10-30', 2352.00, 'SUSPENDIDO'),
    ('CONT0029', 'PROD015', 'CLI0029', DATE '2024-11-13', DATE '2025-11-12', 1748.00, 'VENCIDO'),
    ('CONT0030', 'PROD015', 'CLI0030', DATE '2024-11-22', DATE '2025-11-21', 2128.00, 'VENCIDO'),
    ('CONT0031', 'PROD001', 'CLI0001', DATE '2025-01-10', DATE '2026-01-09', 1192.32, 'VENCIDO'),
    ('CONT0032', 'PROD001', 'CLI0031', DATE '2025-01-19', DATE '2026-01-18', 1451.52, 'VENCIDO'),
    ('CONT0033', 'PROD002', 'CLI0002', DATE '2025-02-01', DATE '2026-01-31', 943.92, 'SUSPENDIDO'),
    ('CONT0034', 'PROD002', 'CLI0032', DATE '2025-02-10', DATE '2026-02-09', 1149.12, 'VENCIDO'),
    ('CONT0035', 'PROD003', 'CLI0003', DATE '2025-02-23', DATE '2026-02-22', 476.93, 'VENCIDO'),
    ('CONT0036', 'PROD003', 'CLI0033', DATE '2025-03-04', DATE '2026-03-03', 580.61, 'VENCIDO'),
    ('CONT0037', 'PROD004', 'CLI0004', DATE '2025-03-17', DATE '2026-03-16', 1142.64, 'VENCIDO'),
    ('CONT0038', 'PROD004', 'CLI0034', DATE '2025-03-26', DATE '2026-03-25', 1391.04, 'VENCIDO'),
    ('CONT0039', 'PROD005', 'CLI0005', DATE '2025-04-08', DATE '2026-04-07', 1490.40, 'VENCIDO'),
    ('CONT0040', 'PROD005', 'CLI0035', DATE '2025-04-17', DATE '2026-04-16', 1814.40, 'VENCIDO'),
    ('CONT0041', 'PROD006', 'CLI0006', DATE '2025-04-30', DATE '2026-04-29', 814.75, 'VENCIDO'),
    ('CONT0042', 'PROD006', 'CLI0036', DATE '2025-05-09', DATE '2026-05-08', 991.87, 'VENCIDO'),
    ('CONT0043', 'PROD007', 'CLI0007', DATE '2025-05-22', DATE '2026-05-21', 993.60, 'VENCIDO'),
    ('CONT0044', 'PROD007', 'CLI0037', DATE '2025-05-31', DATE '2026-05-30', 1209.60, 'SUSPENDIDO'),
    ('CONT0045', 'PROD008', 'CLI0008', DATE '2025-06-13', DATE '2026-06-12', 2185.92, 'VENCIDO'),
    ('CONT0046', 'PROD008', 'CLI0038', DATE '2025-06-22', DATE '2026-06-21', 2661.12, 'VENCIDO'),
    ('CONT0047', 'PROD009', 'CLI0009', DATE '2025-07-05', DATE '2026-07-04', 1788.48, 'VENCIDO'),
    ('CONT0048', 'PROD009', 'CLI0039', DATE '2025-07-14', DATE '2026-07-13', 2177.28, 'ACTIVO'),
    ('CONT0049', 'PROD010', 'CLI0010', DATE '2025-07-27', DATE '2026-07-26', 317.95, 'ACTIVO'),
    ('CONT0050', 'PROD010', 'CLI0040', DATE '2025-08-05', DATE '2026-08-04', 387.07, 'ACTIVO'),
    ('CONT0051', 'PROD011', 'CLI0011', DATE '2025-08-18', DATE '2026-08-17', 516.67, 'ACTIVO'),
    ('CONT0052', 'PROD011', 'CLI0041', DATE '2025-08-27', DATE '2026-08-26', 628.99, 'ACTIVO'),
    ('CONT0053', 'PROD012', 'CLI0012', DATE '2025-09-09', DATE '2026-09-08', 377.57, 'ACTIVO'),
    ('CONT0054', 'PROD012', 'CLI0042', DATE '2025-09-18', DATE '2026-09-17', 459.65, 'ACTIVO'),
    ('CONT0055', 'PROD013', 'CLI0013', DATE '2025-10-01', DATE '2026-09-30', 1639.44, 'SUSPENDIDO'),
    ('CONT0056', 'PROD013', 'CLI0043', DATE '2025-10-10', DATE '2026-10-09', 1995.84, 'ACTIVO'),
    ('CONT0057', 'PROD014', 'CLI0014', DATE '2025-10-23', DATE '2026-10-22', 2086.56, 'ACTIVO'),
    ('CONT0058', 'PROD014', 'CLI0044', DATE '2025-11-01', DATE '2026-10-31', 2540.16, 'ACTIVO'),
    ('CONT0059', 'PROD015', 'CLI0015', DATE '2025-11-14', DATE '2026-11-13', 1887.84, 'ACTIVO'),
    ('CONT0060', 'PROD015', 'CLI0045', DATE '2025-11-23', DATE '2026-11-22', 2298.24, 'ACTIVO'),
    ('CONT0061', 'PROD001', 'CLI0031', DATE '2026-01-08', DATE '2027-01-07', 1280.64, 'ACTIVO'),
    ('CONT0062', 'PROD001', 'CLI0046', DATE '2026-01-13', DATE '2027-01-12', 1559.04, 'ACTIVO'),
    ('CONT0063', 'PROD002', 'CLI0032', DATE '2026-01-19', DATE '2027-01-18', 1013.84, 'ACTIVO'),
    ('CONT0064', 'PROD002', 'CLI0047', DATE '2026-01-24', DATE '2027-01-23', 1234.24, 'ACTIVO'),
    ('CONT0065', 'PROD003', 'CLI0033', DATE '2026-01-30', DATE '2027-01-29', 512.26, 'SUSPENDIDO'),
    ('CONT0066', 'PROD003', 'CLI0048', DATE '2026-02-04', DATE '2027-02-03', 623.62, 'ACTIVO'),
    ('CONT0067', 'PROD004', 'CLI0034', DATE '2026-02-10', DATE '2027-02-09', 1227.28, 'ACTIVO'),
    ('CONT0068', 'PROD004', 'CLI0049', DATE '2026-02-15', DATE '2027-02-14', 1494.08, 'ACTIVO'),
    ('CONT0069', 'PROD005', 'CLI0035', DATE '2026-02-21', DATE '2027-02-20', 1600.80, 'ACTIVO'),
    ('CONT0070', 'PROD005', 'CLI0050', DATE '2026-02-26', DATE '2027-02-25', 1948.80, 'ACTIVO'),
    ('CONT0071', 'PROD006', 'CLI0036', DATE '2026-03-04', DATE '2027-03-03', 875.10, 'ACTIVO'),
    ('CONT0072', 'PROD006', 'CLI0016', DATE '2026-03-09', DATE '2027-03-08', 1065.34, 'ACTIVO'),
    ('CONT0073', 'PROD007', 'CLI0037', DATE '2026-03-15', DATE '2027-03-14', 1067.20, 'ACTIVO'),
    ('CONT0074', 'PROD007', 'CLI0017', DATE '2026-03-20', DATE '2027-03-19', 1299.20, 'ACTIVO'),
    ('CONT0075', 'PROD008', 'CLI0038', DATE '2026-03-26', DATE '2027-03-25', 2347.84, 'ACTIVO'),
    ('CONT0076', 'PROD008', 'CLI0018', DATE '2026-03-31', DATE '2027-03-30', 2858.24, 'ACTIVO'),
    ('CONT0077', 'PROD009', 'CLI0039', DATE '2026-04-06', DATE '2027-04-05', 1920.96, 'ACTIVO'),
    ('CONT0078', 'PROD009', 'CLI0019', DATE '2026-04-11', DATE '2027-04-10', 2338.56, 'SUSPENDIDO'),
    ('CONT0079', 'PROD010', 'CLI0040', DATE '2026-04-17', DATE '2027-04-16', 341.50, 'ACTIVO'),
    ('CONT0080', 'PROD010', 'CLI0020', DATE '2026-04-22', DATE '2027-04-21', 415.74, 'ACTIVO'),
    ('CONT0081', 'PROD011', 'CLI0041', DATE '2026-04-28', DATE '2027-04-27', 554.94, 'ACTIVO'),
    ('CONT0082', 'PROD011', 'CLI0021', DATE '2026-05-03', DATE '2027-05-02', 675.58, 'ACTIVO'),
    ('CONT0083', 'PROD012', 'CLI0042', DATE '2026-05-09', DATE '2027-05-08', 405.54, 'ACTIVO'),
    ('CONT0084', 'PROD012', 'CLI0022', DATE '2026-05-14', DATE '2027-05-13', 493.70, 'ACTIVO'),
    ('CONT0085', 'PROD013', 'CLI0043', DATE '2026-05-20', DATE '2027-05-19', 1760.88, 'ACTIVO'),
    ('CONT0086', 'PROD013', 'CLI0023', DATE '2026-05-25', DATE '2027-05-24', 2143.68, 'ACTIVO'),
    ('CONT0087', 'PROD014', 'CLI0044', DATE '2026-05-31', DATE '2027-05-30', 2241.12, 'ACTIVO'),
    ('CONT0088', 'PROD014', 'CLI0024', DATE '2026-06-05', DATE '2027-06-04', 2728.32, 'ACTIVO'),
    ('CONT0089', 'PROD015', 'CLI0045', DATE '2026-06-11', DATE '2027-06-10', 2027.68, 'ACTIVO'),
    ('CONT0090', 'PROD015', 'CLI0025', DATE '2026-06-16', DATE '2027-06-15', 2468.48, 'ACTIVO');


-- 10. EVALUACIONES Y RECOMENDACIONES
INSERT INTO seguro_g29969634.recomienda (
    cod_cliente, cod_producto, cod_evaluacion_servicio,
    recomienda_amigo, fecha_evaluacion
)
VALUES
    ('CLI0001', 'PROD001', 'EV05', 'SI', DATE '2024-03-11'),
    ('CLI0002', 'PROD001', 'EV04', 'SI', DATE '2024-03-21'),
    ('CLI0003', 'PROD002', 'EV03', 'NO', DATE '2024-04-04'),
    ('CLI0004', 'PROD002', 'EV05', 'SI', DATE '2024-04-14'),
    ('CLI0005', 'PROD003', 'EV02', 'NO', DATE '2024-04-28'),
    ('CLI0006', 'PROD003', 'EV04', 'SI', DATE '2024-05-08'),
    ('CLI0007', 'PROD004', 'EV05', 'SI', DATE '2024-05-22'),
    ('CLI0008', 'PROD004', 'EV03', 'SI', DATE '2024-06-01'),
    ('CLI0009', 'PROD005', 'EV01', 'NO', DATE '2024-06-15'),
    ('CLI0010', 'PROD005', 'EV04', 'SI', DATE '2024-06-25'),
    ('CLI0011', 'PROD006', 'EV05', 'SI', DATE '2024-07-09'),
    ('CLI0012', 'PROD006', 'EV03', 'SI', DATE '2024-07-19'),
    ('CLI0013', 'PROD007', 'EV02', 'NO', DATE '2024-08-02'),
    ('CLI0014', 'PROD007', 'EV05', 'SI', DATE '2024-08-12'),
    ('CLI0015', 'PROD008', 'EV04', 'SI', DATE '2024-08-26'),
    ('CLI0016', 'PROD008', 'EV03', 'SI', DATE '2024-09-05'),
    ('CLI0017', 'PROD009', 'EV05', 'SI', DATE '2024-09-19'),
    ('CLI0018', 'PROD009', 'EV05', 'SI', DATE '2024-09-29'),
    ('CLI0019', 'PROD010', 'EV04', 'SI', DATE '2024-10-13'),
    ('CLI0020', 'PROD010', 'EV03', 'SI', DATE '2024-10-23'),
    ('CLI0021', 'PROD011', 'EV05', 'SI', DATE '2024-11-06'),
    ('CLI0022', 'PROD011', 'EV02', 'NO', DATE '2024-11-16'),
    ('CLI0023', 'PROD012', 'EV04', 'SI', DATE '2024-11-30'),
    ('CLI0024', 'PROD012', 'EV05', 'SI', DATE '2024-12-10'),
    ('CLI0025', 'PROD013', 'EV03', 'NO', DATE '2024-11-29'),
    ('CLI0026', 'PROD013', 'EV01', 'NO', DATE '2024-12-09'),
    ('CLI0027', 'PROD014', 'EV04', 'SI', DATE '2024-12-23'),
    ('CLI0028', 'PROD014', 'EV05', 'SI', DATE '2025-01-02'),
    ('CLI0029', 'PROD015', 'EV03', 'NO', DATE '2025-01-16'),
    ('CLI0030', 'PROD015', 'EV02', 'NO', DATE '2025-01-26'),
    ('CLI0001', 'PROD001', 'EV05', 'SI', DATE '2025-03-17'),
    ('CLI0031', 'PROD001', 'EV04', 'SI', DATE '2025-03-27'),
    ('CLI0002', 'PROD002', 'EV03', 'NO', DATE '2025-04-10'),
    ('CLI0032', 'PROD002', 'EV05', 'SI', DATE '2025-04-20'),
    ('CLI0003', 'PROD003', 'EV05', 'SI', DATE '2025-05-04'),
    ('CLI0033', 'PROD003', 'EV04', 'SI', DATE '2025-05-14'),
    ('CLI0004', 'PROD004', 'EV03', 'NO', DATE '2025-05-28'),
    ('CLI0034', 'PROD004', 'EV05', 'SI', DATE '2025-06-07'),
    ('CLI0005', 'PROD005', 'EV02', 'NO', DATE '2025-06-21'),
    ('CLI0035', 'PROD005', 'EV04', 'SI', DATE '2025-07-01'),
    ('CLI0006', 'PROD006', 'EV05', 'SI', DATE '2025-07-15'),
    ('CLI0036', 'PROD006', 'EV03', 'SI', DATE '2025-07-25'),
    ('CLI0007', 'PROD007', 'EV01', 'NO', DATE '2025-08-08'),
    ('CLI0037', 'PROD007', 'EV04', 'SI', DATE '2025-08-18'),
    ('CLI0008', 'PROD008', 'EV05', 'SI', DATE '2025-09-01'),
    ('CLI0038', 'PROD008', 'EV03', 'SI', DATE '2025-09-11'),
    ('CLI0009', 'PROD009', 'EV02', 'NO', DATE '2025-09-25'),
    ('CLI0039', 'PROD009', 'EV05', 'SI', DATE '2025-10-05'),
    ('CLI0010', 'PROD010', 'EV04', 'SI', DATE '2025-10-19'),
    ('CLI0040', 'PROD010', 'EV03', 'SI', DATE '2025-10-04'),
    ('CLI0011', 'PROD011', 'EV05', 'SI', DATE '2025-10-18'),
    ('CLI0041', 'PROD011', 'EV05', 'SI', DATE '2025-10-28'),
    ('CLI0012', 'PROD012', 'EV04', 'SI', DATE '2025-11-11'),
    ('CLI0042', 'PROD012', 'EV03', 'SI', DATE '2025-11-21'),
    ('CLI0013', 'PROD013', 'EV05', 'SI', DATE '2025-12-05'),
    ('CLI0043', 'PROD013', 'EV02', 'NO', DATE '2025-12-15'),
    ('CLI0014', 'PROD014', 'EV04', 'SI', DATE '2025-12-29'),
    ('CLI0044', 'PROD014', 'EV05', 'SI', DATE '2026-01-08'),
    ('CLI0015', 'PROD015', 'EV03', 'NO', DATE '2026-01-22'),
    ('CLI0045', 'PROD015', 'EV01', 'NO', DATE '2026-02-01'),
    ('CLI0031', 'PROD001', 'EV04', 'SI', DATE '2026-03-20'),
    ('CLI0046', 'PROD001', 'EV05', 'SI', DATE '2026-03-26'),
    ('CLI0032', 'PROD002', 'EV03', 'NO', DATE '2026-04-02'),
    ('CLI0047', 'PROD002', 'EV02', 'NO', DATE '2026-04-08'),
    ('CLI0033', 'PROD003', 'EV05', 'SI', DATE '2026-04-15'),
    ('CLI0048', 'PROD003', 'EV04', 'SI', DATE '2026-04-21'),
    ('CLI0034', 'PROD004', 'EV03', 'NO', DATE '2026-04-28'),
    ('CLI0049', 'PROD004', 'EV05', 'SI', DATE '2026-05-04');


-- 11. SINIESTROS
-- Cada descripción corresponde al producto amparado.
INSERT INTO seguro_g29969634.siniestro (
    nro_siniestro, descripcion_siniestro
)
VALUES
    ('SIN0001', '  fallecimiento del asegurado '),
    ('SIN0002', '  hospitalización de emergencia '),
    ('SIN0003', '  pérdida de equipaje durante viaje '),
    ('SIN0004', '  colisión del vehículo asegurado '),
    ('SIN0005', '  incendio en inmueble asegurado '),
    ('SIN0006', 'ROBO DE BIENES ASEGURADOS'),
    ('SIN0007', 'DAÑOS POR FILTRACIÓN EN VIVIENDA'),
    ('SIN0008', 'DAÑOS EN EQUIPOS DE LA EMPRESA'),
    ('SIN0009', 'INCUMPLIMIENTO DE OBLIGACIÓN GARANTIZADA'),
    ('SIN0010', 'AVERÍA MECÁNICA EN CARRETERA'),
    ('SIN0011', 'Solicitud DE servicio funerario'),
    ('SIN0012', 'Emergencia odontológica'),
    ('SIN0013', 'Daños en establecimiento comercial'),
    ('SIN0014', 'Pérdida parcial DE mercancía en tránsito'),
    ('SIN0015', 'Daños a terceros por actividad empresarial'),
    ('SIN0016', 'Fallecimiento del asegurado'),
    ('SIN0017', 'Hospitalización de emergencia'),
    ('SIN0018', 'Pérdida de equipaje durante viaje'),
    ('SIN0019', 'Colisión del vehículo asegurado'),
    ('SIN0020', 'Incendio en inmueble asegurado'),
    ('SIN0021', 'Robo de bienes asegurados'),
    ('SIN0022', 'Daños por filtración en vivienda'),
    ('SIN0023', 'Daños en equipos de la empresa'),
    ('SIN0024', 'Incumplimiento de obligación garantizada'),
    ('SIN0025', 'Avería mecánica en carretera'),
    ('SIN0026', 'Solicitud de servicio funerario'),
    ('SIN0027', 'Emergencia odontológica'),
    ('SIN0028', 'Daños en establecimiento comercial'),
    ('SIN0029', 'Pérdida parcial de mercancía en tránsito'),
    ('SIN0030', 'Daños a terceros por actividad empresarial');


-- 12. REGISTROS DE SINIESTRO
INSERT INTO seguro_g29969634.registro_siniestro (
    nro_siniestro, nro_contrato, fecha_siniestro,
    fecha_respuesta, id_rechazo,
    monto_reconocido, monto_solicitado
)
VALUES
    ('SIN0001', 'CONT0001', DATE '2024-04-05', DATE '2024-04-14', 'NO', 1317.51, 1689.12),
    ('SIN0002', 'CONT0003', DATE '2024-04-28', DATE '2024-05-08', 'NO', 1255.41, 1494.54),
    ('SIN0003', 'CONT0005', DATE '2024-05-21', DATE '2024-06-01', 'NO', 585.00, 650.00),
    ('SIN0004', 'CONT0007', DATE '2024-06-13', DATE '2024-06-25', 'NO', 1165.49, 1618.74),
    ('SIN0005', 'CONT0009', DATE '2024-07-06', DATE '2024-07-24', 'SI', 0.00, 2359.80),
    ('SIN0006', 'CONT0011', DATE '2024-07-29', DATE '2024-08-12', 'NO', 855.49, 1018.44),
    ('SIN0007', 'CONT0013', DATE '2024-08-21', NULL, 'NO', 0.00, 1407.60),
    ('SIN0008', 'CONT0015', DATE '2024-09-13', DATE '2024-09-29', 'NO', 2491.95, 3461.04),
    ('SIN0009', 'CONT0017', DATE '2024-10-06', DATE '2024-10-23', 'NO', 1743.77, 2235.60),
    ('SIN0010', 'CONT0019', DATE '2024-10-29', DATE '2024-11-16', 'SI', 0.00, 650.00),
    ('SIN0011', 'CONT0021', DATE '2024-11-21', DATE '2024-12-10', 'NO', 736.25, 818.06),
    ('SIN0012', 'CONT0023', DATE '2024-12-14', DATE '2024-12-22', 'NO', 468.00, 650.00),
    ('SIN0013', 'CONT0025', DATE '2025-01-06', DATE '2025-01-15', 'NO', 1811.58, 2322.54),
    ('SIN0014', 'CONT0027', DATE '2025-01-29', NULL, 'NO', 0.00, 3303.72),
    ('SIN0015', 'CONT0029', DATE '2025-02-21', DATE '2025-03-11', 'SI', 0.00, 2359.80),
    ('SIN0016', 'CONT0031', DATE '2025-04-21', DATE '2025-05-03', 'NO', 1313.46, 1824.25),
    ('SIN0017', 'CONT0033', DATE '2025-05-14', DATE '2025-05-27', 'NO', 1259.00, 1614.10),
    ('SIN0018', 'CONT0035', DATE '2025-06-06', DATE '2025-06-20', 'NO', 546.00, 650.00),
    ('SIN0019', 'CONT0037', DATE '2025-06-29', DATE '2025-07-14', 'NO', 1573.42, 1748.24),
    ('SIN0020', 'CONT0039', DATE '2025-07-02', DATE '2025-07-20', 'SI', 0.00, 2548.58),
    ('SIN0021', 'CONT0041', DATE '2025-07-25', NULL, 'NO', 0.00, 1099.91),
    ('SIN0022', 'CONT0043', DATE '2025-08-17', DATE '2025-09-04', 'NO', 1276.98, 1520.21),
    ('SIN0023', 'CONT0045', DATE '2025-09-09', DATE '2025-09-28', 'NO', 3364.13, 3737.92),
    ('SIN0024', 'CONT0047', DATE '2025-10-02', DATE '2025-10-10', 'NO', 1738.40, 2414.45),
    ('SIN0025', 'CONT0049', DATE '2025-10-25', DATE '2025-11-12', 'SI', 0.00, 650.00),
    ('SIN0026', 'CONT0051', DATE '2025-11-17', DATE '2025-11-27', 'NO', 742.15, 883.51),
    ('SIN0027', 'CONT0053', DATE '2025-12-10', DATE '2025-12-21', 'NO', 585.00, 650.00),
    ('SIN0028', 'CONT0055', DATE '2026-01-02', NULL, 'NO', 0.00, 2508.34),
    ('SIN0029', 'CONT0057', DATE '2026-01-25', DATE '2026-02-07', 'NO', 2783.06, 3568.02),
    ('SIN0030', 'CONT0059', DATE '2026-02-17', DATE '2026-03-07', 'SI', 0.00, 2548.58);


-- 13. METAS COMERCIALES
-- Una meta por producto y año: 15 x 3 = 45.
INSERT INTO seguro_g29969634.meta_comercial (
    cod_producto, anio, fecha_inicio, fecha_fin,
    monto_meta_ingreso, meta_renovacion, meta_asegurados
)
VALUES
    ('PROD001', 2024, DATE '2024-01-01', DATE '2024-12-31', 2203.20, 1, 2),
    ('PROD001', 2025, DATE '2025-01-01', DATE '2025-12-31', 2776.03, 1, 2),
    ('PROD001', 2026, DATE '2026-01-01', DATE '2026-12-31', 3265.63, 1, 3),
    ('PROD002', 2024, DATE '2024-01-01', DATE '2024-12-31', 2034.90, 1, 2),
    ('PROD002', 2025, DATE '2025-01-01', DATE '2025-12-31', 2407.00, 1, 3),
    ('PROD002', 2026, DATE '2026-01-01', DATE '2026-12-31', 2023.27, 2, 2),
    ('PROD003', 2024, DATE '2024-01-01', DATE '2024-12-31', 1126.08, 1, 3),
    ('PROD003', 2025, DATE '2025-01-01', DATE '2025-12-31', 951.79, 2, 2),
    ('PROD003', 2026, DATE '2026-01-01', DATE '2026-12-31', 1192.67, 1, 2),
    ('PROD004', 2024, DATE '2024-01-01', DATE '2024-12-31', 2111.40, 2, 2),
    ('PROD004', 2025, DATE '2025-01-01', DATE '2025-12-31', 2660.36, 1, 2),
    ('PROD004', 2026, DATE '2026-01-01', DATE '2026-12-31', 3129.56, 1, 3),
    ('PROD005', 2024, DATE '2024-01-01', DATE '2024-12-31', 3213.00, 1, 2),
    ('PROD005', 2025, DATE '2025-01-01', DATE '2025-12-31', 3800.52, 1, 3),
    ('PROD005', 2026, DATE '2026-01-01', DATE '2026-12-31', 3194.64, 1, 2),
    ('PROD006', 2024, DATE '2024-01-01', DATE '2024-12-31', 1923.72, 1, 3),
    ('PROD006', 2025, DATE '2025-01-01', DATE '2025-12-31', 1625.96, 1, 2),
    ('PROD006', 2026, DATE '2026-01-01', DATE '2026-12-31', 2037.46, 2, 2),
    ('PROD007', 2024, DATE '2024-01-01', DATE '2024-12-31', 1836.00, 1, 2),
    ('PROD007', 2025, DATE '2025-01-01', DATE '2025-12-31', 2313.36, 2, 2),
    ('PROD007', 2026, DATE '2026-01-01', DATE '2026-12-31', 2721.36, 1, 3),
    ('PROD008', 2024, DATE '2024-01-01', DATE '2024-12-31', 4712.40, 2, 2),
    ('PROD008', 2025, DATE '2025-01-01', DATE '2025-12-31', 5574.10, 1, 3),
    ('PROD008', 2026, DATE '2026-01-01', DATE '2026-12-31', 4685.47, 1, 2),
    ('PROD009', 2024, DATE '2024-01-01', DATE '2024-12-31', 4222.80, 1, 3),
    ('PROD009', 2025, DATE '2025-01-01', DATE '2025-12-31', 3569.18, 1, 2),
    ('PROD009', 2026, DATE '2026-01-01', DATE '2026-12-31', 4472.50, 1, 2),
    ('PROD010', 2024, DATE '2024-01-01', DATE '2024-12-31', 587.52, 1, 2),
    ('PROD010', 2025, DATE '2025-01-01', DATE '2025-12-31', 740.27, 1, 2),
    ('PROD010', 2026, DATE '2026-01-01', DATE '2026-12-31', 870.83, 2, 3),
    ('PROD011', 2024, DATE '2024-01-01', DATE '2024-12-31', 1113.84, 1, 2),
    ('PROD011', 2025, DATE '2025-01-01', DATE '2025-12-31', 1317.51, 2, 3),
    ('PROD011', 2026, DATE '2026-01-01', DATE '2026-12-31', 1107.47, 1, 2),
    ('PROD012', 2024, DATE '2024-01-01', DATE '2024-12-31', 891.48, 2, 3),
    ('PROD012', 2025, DATE '2025-01-01', DATE '2025-12-31', 753.50, 1, 2),
    ('PROD012', 2026, DATE '2026-01-01', DATE '2026-12-31', 944.20, 1, 2),
    ('PROD013', 2024, DATE '2024-01-01', DATE '2024-12-31', 3029.40, 1, 2),
    ('PROD013', 2025, DATE '2025-01-01', DATE '2025-12-31', 3817.04, 1, 2),
    ('PROD013', 2026, DATE '2026-01-01', DATE '2026-12-31', 4490.24, 1, 3),
    ('PROD014', 2024, DATE '2024-01-01', DATE '2024-12-31', 4498.20, 1, 2),
    ('PROD014', 2025, DATE '2025-01-01', DATE '2025-12-31', 5320.73, 1, 3),
    ('PROD014', 2026, DATE '2026-01-01', DATE '2026-12-31', 4472.50, 2, 2),
    ('PROD015', 2024, DATE '2024-01-01', DATE '2024-12-31', 4457.40, 1, 3),
    ('PROD015', 2025, DATE '2025-01-01', DATE '2025-12-31', 3767.47, 2, 2),
    ('PROD015', 2026, DATE '2026-01-01', DATE '2026-12-31', 4720.97, 1, 2);


COMMIT;
