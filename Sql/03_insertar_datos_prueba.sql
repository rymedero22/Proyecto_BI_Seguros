-- ============================================================
-- PROYECTO BI - SEGUROS ALTA VISTA
-- 04. INSERCIÓN DE DATOS DE PRUEBA
-- Esquema fuente: seguro_g29969634
--
-- CANTIDADES:
--   2 países
--   6 ciudades
--   6 sucursales
--   5 tipos de producto
--   12 productos
--   40 clientes: 30 de Venezuela y 10 de Argentina
--   72 contratos y 72 registros de contrato
--   5 tipos de evaluación y 54 evaluaciones realizadas
--   24 siniestros y 24 registros de siniestro
--   36 metas comerciales
--
-- DISTRIBUCIÓN DE CONTRATOS:
--   2024: 23
--   2025: 19
--   2026: 30
--
-- COHERENCIA APLICADA:
--   * El sexo corresponde con el nombre del cliente.
--   * El teléfono y la sucursal corresponden con el país.
--   * Cada descripción de contrato corresponde con su producto.
--   * Cada evaluación corresponde con un cliente y producto contratados.
--   * Cada siniestro corresponde con el producto del contrato.
--   * Las metas se relacionan con los ingresos y el volumen real.
--   * Las variaciones controladas solo afectan el formato de textos.
-- ============================================================

BEGIN;

-- Vaciar primero el Data Warehouse.
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

-- Vaciar después el modelo transaccional.
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


-- 1. PAÍSES
INSERT INTO seguro_g29969634.pais (
    cod_pais,
    nb_pais
)
VALUES
    ('VE', 'Venezuela'),
    ('AR', ' argentina ');


-- 2. CIUDADES
INSERT INTO seguro_g29969634.ciudad (
    cod_ciudad,
    nb_ciudad,
    cod_pais
)
VALUES
    ('CCS', 'Caracas', 'VE'),
    ('MAR', '  maracaibo ', 'VE'),
    ('VAL', 'VALENCIA', 'VE'),
    ('BQT', 'Barquisimeto ', 'VE'),
    ('BAS', 'Buenos Aires', 'AR'),
    ('COR', '  córdoba ', 'AR');


-- 3. SUCURSALES
INSERT INTO seguro_g29969634.sucursal (
    cod_sucursal,
    nb_sucursal,
    cod_ciudad
)
VALUES
    ('SUC001', 'Sucursal Caracas Centro', 'CCS'),
    ('SUC002', '  sucursal maracaibo norte ', 'MAR'),
    ('SUC003', 'SUCURSAL VALENCIA', 'VAL'),
    ('SUC004', 'Sucursal Barquisimeto Este ', 'BQT'),
    ('SUC005', ' sucursal buenos aires centro ', 'BAS'),
    ('SUC006', 'SUCURSAL CÓRDOBA NORTE', 'COR');


-- 4. TIPOS DE PRODUCTO
INSERT INTO seguro_g29969634.tipo_producto (
    cod_tipo_producto,
    nb_tipo_producto
)
VALUES
    ('TP01', 'Personales'),
    ('TP02', '  daños '),
    ('TP03', 'PATRIMONIALES'),
    ('TP04', 'Prestación de Servicios'),
    ('TP05', ' empresariales ');


-- 5. PRODUCTOS
INSERT INTO seguro_g29969634.producto (
    cod_producto,
    nb_producto,
    descripcion,
    cod_tipo_producto,
    calificacion
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
    ('PROD009', ' Asistencia Vial ', 'Servicio de grúa y asistencia para vehículos.', 'TP04', 4.70),
    ('PROD010', 'Asistencia Funeraria', 'Servicios de previsión y asistencia funeraria.', 'TP04', 4.35),
    ('PROD011', ' seguro para comercios ', 'Cobertura integral para establecimientos comerciales.', 'TP05', 4.25),
    ('PROD012', 'SEGURO DE TRANSPORTE DE MERCANCÍA', 'protección de mercancías durante su traslado', 'TP05', 4.15);


-- 6. TIPOS DE EVALUACIÓN
INSERT INTO seguro_g29969634.evaluacion_servicio (
    cod_evaluacion_servicio,
    nb_descripcion,
    valor_calificacion
)
VALUES
    ('EV01', 'Malo', 1),
    ('EV02', 'Regular', 2),
    ('EV03', 'Bueno', 3),
    ('EV04', 'Muy Bueno', 4),
    ('EV05', 'Excelente', 5);


-- 7. CLIENTES
-- 30 pertenecen a Venezuela y 10 a Argentina.
-- Los primeros registros contienen variaciones controladas.
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
VALUES
    ('CLI0001', '  maría fernanda gonzález ', 'V-12.017.319', '+58 414-1000731', 'Av. Francisco de Miranda, Caracas, Apto. 1', 'F', ' MARIA.GONZALEZ@GMAIL.COM ', 'SUC001'),
    ('CLI0002', '  carlos eduardo ramírez ', 'V-12.034.638', '+58-424-1001462', 'Av. Libertador, Caracas, Apto. 12', 'M', 'Carlos.Ramirez@Hotmail.Com', 'SUC001'),
    ('CLI0003', '  andrea carolina méndez ', 'V-12.051.957', '+584121002193', '  av. urdaneta, caracas, piso 4 ', 'F', 'andrea.mendez@gmail.com', 'SUC001'),
    ('CLI0004', '  josé antonio rodríguez ', 'V-12.069.276', '+58 416 100 29 24', 'URB. EL PARAÍSO, CARACAS, CASA 8', 'M', ' JOSE.RODRIGUEZ@HOTMAIL.COM ', 'SUC001'),
    ('CLI0005', '  valentina isabel pérez ', 'V-12.086.595', '+58 414-1003655', 'Av. Principal de Los Ruices, Caracas', 'F', 'Valentina.Perez@Gmail.Com', 'SUC001'),
    ('CLI0006', '  luis alberto hernández ', 'V-12.103.914', '+58-424-1004386', '  urb. la florida, caracas, quinta 15 ', 'M', 'luis.hernandez@hotmail.com', 'SUC001'),
    ('CLI0007', 'GABRIELA ALEJANDRA TORRES', 'V-12.121.233', '+584121005117', 'Av. Andrés Bello, Caracas, Apto. 7', 'F', ' GABRIELA.TORRES@GMAIL.COM ', 'SUC001'),
    ('CLI0008', 'MIGUEL ÁNGEL CASTILLO', 'V-12.138.552', '+58 416 100 58 48', 'URB. SANTA MÓNICA, CARACAS, CASA 21', 'M', 'Miguel.Castillo@Hotmail.Com', 'SUC001'),
    ('CLI0009', 'SOFÍA VICTORIA MORALES', 'V 12155871', '+58 414-1006579', '  av. 5 de julio, maracaibo, apto. 3 ', 'F', 'sofia.morales@gmail.com', 'SUC002'),
    ('CLI0010', 'DANIEL ALEJANDRO ROJAS', 'V 12173190', '+58-424-1007310', 'Urb. La Lago, Maracaibo, Casa 14', 'M', ' DANIEL.ROJAS@HOTMAIL.COM ', 'SUC002'),
    ('CLI0011', 'CAMILA ANDREA SILVA', 'V 12190509', '+584121008041', 'Av. Bella Vista, Maracaibo, Apto. 9', 'F', 'Camila.Silva@Gmail.Com', 'SUC002'),
    ('CLI0012', 'FRANCISCO JAVIER VARGAS', 'V 12207828', '+58 416 100 87 72', '  calle 72, maracaibo, casa 5 ', 'M', 'francisco.vargas@hotmail.com', 'SUC002'),
    ('CLI0013', 'Isabella CRISTINA romero', 'v-12225147', '+58 414-1009503', 'Urb. Tierra Negra, Maracaibo, Apto. 11', 'F', ' ISABELLA.ROMERO@GMAIL.COM ', 'SUC002'),
    ('CLI0014', 'Alejandro JOSÉ navarro', 'v-12242466', '+58-424-1010234', 'Av. Delicias, Maracaibo, Casa 18', 'M', 'Alejandro.Navarro@Hotmail.Com', 'SUC002'),
    ('CLI0015', 'Natalia BEATRIZ herrera', 'v-12259785', '+584121010965', '  urb. la viña, valencia, casa 6 ', 'F', 'natalia.herrera@gmail.com', 'SUC003'),
    ('CLI0016', 'Ricardo ANDRÉS suárez', 'V12277104', '+58 416 101 16 96', 'AV. BOLÍVAR NORTE, VALENCIA, APTO. 10', 'M', ' RICARDO.SUAREZ@HOTMAIL.COM ', 'SUC003'),
    ('CLI0017', 'Paola ANDREÍNA campos', 'V12294423', '+58 414-1012427', 'Urb. El Parral, Valencia, Casa 17', 'F', 'Paola.Campos@Gmail.Com', 'SUC003'),
    ('CLI0018', 'Manuel ENRIQUE ortega', 'V12311742', '+58-424-1013158', '  av. cedeño, valencia, apto. 2 ', 'M', 'manuel.ortega@hotmail.com', 'SUC003'),
    ('CLI0019', 'Mariana Alejandra Acosta', 'V12329061', '+584121013889', 'Urb. Prebo, Valencia, Casa 22', 'F', 'mariana.acosta@gmail.com', 'SUC003'),
    ('CLI0020', 'Jorge Luis Salazar', 'V12346380', '+58 416 101 46 20', 'Av. Las Ferias, Valencia, Apto. 13', 'M', 'jorge.salazar@hotmail.com', 'SUC003'),
    ('CLI0021', 'Laura Carolina Zambrano', 'V12363699', '+58 414-1015351', 'Urb. Trigal Norte, Valencia, Casa 4', 'F', 'laura.zambrano@gmail.com', 'SUC003'),
    ('CLI0022', 'Jesús Alberto Figueroa', 'V12381018', '+58-424-1016082', 'Av. Lara, Barquisimeto, Local 7', 'M', 'jesus.figueroa@hotmail.com', 'SUC004'),
    ('CLI0023', 'Daniela Sofía Delgado', 'V12398337', '+584121016813', 'Urb. Nueva Segovia, Barquisimeto, Casa 12', 'F', 'daniela.delgado@gmail.com', 'SUC004'),
    ('CLI0024', 'Pedro Antonio Márquez', 'V12415656', '+58 416 101 75 44', 'Av. Los Leones, Barquisimeto, Apto. 6', 'M', 'pedro.marquez@hotmail.com', 'SUC004'),
    ('CLI0025', 'Ana Victoria Molina', 'V12432975', '+58 414-1018275', 'Urb. Fundalara, Barquisimeto, Casa 9', 'F', 'ana.molina@gmail.com', 'SUC004'),
    ('CLI0026', 'Roberto Carlos Medina', 'V12450294', '+58-424-1019006', 'Av. Venezuela, Barquisimeto, Apto. 15', 'M', 'roberto.medina@hotmail.com', 'SUC004'),
    ('CLI0027', 'Patricia Elena Cabrera', 'V12467613', '+584121019737', 'Urb. Bararida, Barquisimeto, Casa 3', 'F', 'patricia.cabrera@gmail.com', 'SUC004'),
    ('CLI0028', 'Héctor José Fuentes', 'V12484932', '+58 416 102 04 68', 'Av. Pedro León Torres, Barquisimeto', 'M', 'hector.fuentes@hotmail.com', 'SUC004'),
    ('CLI0029', 'Verónica Alejandra León', 'V12502251', '+58 414-1021199', 'Urb. El Obelisco, Barquisimeto, Casa 20', 'F', 'veronica.leon@gmail.com', 'SUC004'),
    ('CLI0030', 'Fernando Miguel Paredes', 'V12519570', '+58-424-1021930', 'Av. Florencio Jiménez, Barquisimeto', 'M', 'fernando.paredes@hotmail.com', 'SUC004'),
    ('CLI0031', 'Lucía Fernández', 'DNI-30.187.431', '+54 9 11 2000-5173', 'Av. Santa Fe 1450, Buenos Aires', 'F', 'lucia.fernandez@gmail.com', 'SUC005'),
    ('CLI0032', 'Martín González', 'DNI-30.374.862', '+54-9-351-3008254', 'Av. Corrientes 2180, Buenos Aires', 'M', 'martin.gonzalez@hotmail.com', 'SUC005'),
    ('CLI0033', 'Sofía Rodríguez', 'DNI-30.562.293', '+5491120015519', 'Calle Thames 980, Buenos Aires', 'F', 'sofia.rodriguez@gmail.com', 'SUC005'),
    ('CLI0034', 'Nicolás López', 'DNI-30.749.724', '+54 9 351 301-6508', 'Av. Rivadavia 3320, Buenos Aires', 'M', 'nicolas.lopez@hotmail.com', 'SUC005'),
    ('CLI0035', 'Valentina Martínez', 'DNI 30937155', '+54-9-11-20025865', 'Calle Honduras 1540, Buenos Aires', 'F', 'valentina.martinez@gmail.com', 'SUC005'),
    ('CLI0036', 'Santiago Pérez', 'DNI 31124586', '+5493513024762', 'Av. Colón 860, Córdoba', 'M', 'santiago.perez@hotmail.com', 'SUC006'),
    ('CLI0037', 'Camila Sánchez', 'DNI 31312017', '+54 9 11 2003-6211', 'Calle Duarte Quirós 1220, Córdoba', 'F', 'camila.sanchez@gmail.com', 'SUC006'),
    ('CLI0038', 'Joaquín Romero', 'DNI31499448', '+54-9-351-3033016', 'Av. General Paz 450, Córdoba', 'M', 'joaquin.romero@hotmail.com', 'SUC006'),
    ('CLI0039', 'Martina Díaz', 'DNI31686879', '+5491120046557', 'Calle Obispo Trejo 735, Córdoba', 'F', 'martina.diaz@gmail.com', 'SUC006'),
    ('CLI0040', 'Mateo Álvarez', 'DNI31874310', '+54 9 351 304-1270', 'Av. Vélez Sarsfield 1190, Córdoba', 'M', 'mateo.alvarez@hotmail.com', 'SUC006');


-- 8. CONTRATOS
-- La descripción identifica el producto asegurado.
INSERT INTO seguro_g29969634.contrato (
    nro_contrato,
    descrip_contrato
)
VALUES
    ('CONT0001', '  contrato de seguro de vida '),
    ('CONT0002', '  contrato de seguro de vida '),
    ('CONT0003', '  contrato de seguro de vida '),
    ('CONT0004', '  contrato de seguro de salud '),
    ('CONT0005', '  contrato de seguro de salud '),
    ('CONT0006', '  contrato de seguro de salud '),
    ('CONT0007', '  contrato de seguro de viaje '),
    ('CONT0008', '  contrato de seguro de viaje '),
    ('CONT0009', '  contrato de seguro de automóvil '),
    ('CONT0010', '  contrato de seguro de automóvil '),
    ('CONT0011', 'CONTRATO DE SEGURO CONTRA INCENDIOS'),
    ('CONT0012', 'CONTRATO DE SEGURO CONTRA INCENDIOS'),
    ('CONT0013', 'CONTRATO DE SEGURO CONTRA ROBO'),
    ('CONT0014', 'CONTRATO DE SEGURO CONTRA ROBO'),
    ('CONT0015', 'CONTRATO DE SEGURO DE HOGAR'),
    ('CONT0016', 'CONTRATO DE SEGURO DE HOGAR'),
    ('CONT0017', 'CONTRATO DE SEGURO EMPRESARIAL'),
    ('CONT0018', 'CONTRATO DE SEGURO EMPRESARIAL'),
    ('CONT0019', 'CONTRATO DE ASISTENCIA VIAL'),
    ('CONT0020', 'CONTRATO DE ASISTENCIA VIAL'),
    ('CONT0021', 'CONTRATO DE ASISTENCIA FUNERARIA'),
    ('CONT0022', 'Contrato DE Seguro para Comercios'),
    ('CONT0023', 'Contrato DE Seguro de Transporte de Mercancía'),
    ('CONT0024', 'Contrato DE Seguro de Vida'),
    ('CONT0025', 'Contrato DE Seguro de Vida'),
    ('CONT0026', 'Contrato DE Seguro de Salud'),
    ('CONT0027', 'Contrato DE Seguro de Salud'),
    ('CONT0028', 'Contrato DE Seguro de Viaje'),
    ('CONT0029', 'Contrato DE Seguro de Viaje'),
    ('CONT0030', 'Contrato DE Seguro de Automóvil'),
    ('CONT0031', 'Contrato DE Seguro de Automóvil'),
    ('CONT0032', 'Contrato DE Seguro contra Incendios'),
    ('CONT0033', 'Contrato de Seguro contra Incendios'),
    ('CONT0034', 'Contrato de Seguro contra Robo'),
    ('CONT0035', 'Contrato de Seguro de Hogar'),
    ('CONT0036', 'Contrato de Seguro de Hogar'),
    ('CONT0037', 'Contrato de Seguro Empresarial'),
    ('CONT0038', 'Contrato de Asistencia Vial'),
    ('CONT0039', 'Contrato de Asistencia Funeraria'),
    ('CONT0040', 'Contrato de Seguro para Comercios'),
    ('CONT0041', 'Contrato de Seguro para Comercios'),
    ('CONT0042', 'Contrato de Seguro de Transporte de Mercancía'),
    ('CONT0043', 'Contrato de Seguro de Vida'),
    ('CONT0044', 'Contrato de Seguro de Vida'),
    ('CONT0045', 'Contrato de Seguro de Vida'),
    ('CONT0046', 'Contrato de Seguro de Vida'),
    ('CONT0047', 'Contrato de Seguro de Salud'),
    ('CONT0048', 'Contrato de Seguro de Salud'),
    ('CONT0049', 'Contrato de Seguro de Salud'),
    ('CONT0050', 'Contrato de Seguro de Viaje'),
    ('CONT0051', 'Contrato de Seguro de Viaje'),
    ('CONT0052', 'Contrato de Seguro de Viaje'),
    ('CONT0053', 'Contrato de Seguro de Viaje'),
    ('CONT0054', 'Contrato de Seguro de Automóvil'),
    ('CONT0055', 'Contrato de Seguro de Automóvil'),
    ('CONT0056', 'Contrato de Seguro de Automóvil'),
    ('CONT0057', 'Contrato de Seguro contra Incendios'),
    ('CONT0058', 'Contrato de Seguro contra Incendios'),
    ('CONT0059', 'Contrato de Seguro contra Incendios'),
    ('CONT0060', 'Contrato de Seguro contra Robo'),
    ('CONT0061', 'Contrato de Seguro contra Robo'),
    ('CONT0062', 'Contrato de Seguro contra Robo'),
    ('CONT0063', 'Contrato de Seguro de Hogar'),
    ('CONT0064', 'Contrato de Seguro de Hogar'),
    ('CONT0065', 'Contrato de Seguro Empresarial'),
    ('CONT0066', 'Contrato de Seguro Empresarial'),
    ('CONT0067', 'Contrato de Asistencia Vial'),
    ('CONT0068', 'Contrato de Asistencia Vial'),
    ('CONT0069', 'Contrato de Asistencia Funeraria'),
    ('CONT0070', 'Contrato de Asistencia Funeraria'),
    ('CONT0071', 'Contrato de Seguro para Comercios'),
    ('CONT0072', 'Contrato de Seguro de Transporte de Mercancía');


-- 9. REGISTROS DE CONTRATO
-- 2024: 23 | 2025: 19 | 2026: 30
-- Venezuela: 54 | Argentina: 18
INSERT INTO seguro_g29969634.registro_contrato (
    nro_contrato,
    cod_producto,
    cod_cliente,
    fecha_inicio,
    fecha_fin,
    monto,
    estado_contrato
)
VALUES
    ('CONT0001', 'PROD001', 'CLI0001', DATE '2024-01-10', DATE '2025-01-09', 1116.50, 'VENCIDO'),
    ('CONT0002', 'PROD001', 'CLI0002', DATE '2024-01-24', DATE '2025-01-23', 1213.00, 'VENCIDO'),
    ('CONT0003', 'PROD001', 'CLI0003', DATE '2024-02-07', DATE '2025-02-06', 1309.50, 'VENCIDO'),
    ('CONT0004', 'PROD002', 'CLI0031', DATE '2024-02-21', DATE '2025-02-20', 958.96, 'VENCIDO'),
    ('CONT0005', 'PROD002', 'CLI0004', DATE '2024-03-06', DATE '2025-03-05', 940.50, 'VENCIDO'),
    ('CONT0006', 'PROD002', 'CLI0005', DATE '2024-03-20', DATE '2025-03-19', 1019.50, 'VENCIDO'),
    ('CONT0007', 'PROD003', 'CLI0006', DATE '2024-04-03', DATE '2025-04-02', 485.00, 'VENCIDO'),
    ('CONT0008', 'PROD003', 'CLI0007', DATE '2024-04-17', DATE '2025-04-16', 532.50, 'VENCIDO'),
    ('CONT0009', 'PROD004', 'CLI0032', DATE '2024-05-01', DATE '2025-04-30', 1150.32, 'SUSPENDIDO'),
    ('CONT0010', 'PROD004', 'CLI0008', DATE '2024-05-15', DATE '2025-05-14', 1138.50, 'VENCIDO'),
    ('CONT0011', 'PROD005', 'CLI0009', DATE '2024-05-29', DATE '2025-05-28', 1300.50, 'VENCIDO'),
    ('CONT0012', 'PROD005', 'CLI0010', DATE '2024-06-12', DATE '2025-06-11', 1411.00, 'VENCIDO'),
    ('CONT0013', 'PROD006', 'CLI0033', DATE '2024-06-26', DATE '2025-06-25', 802.94, 'VENCIDO'),
    ('CONT0014', 'PROD006', 'CLI0011', DATE '2024-07-10', DATE '2025-07-09', 842.00, 'VENCIDO'),
    ('CONT0015', 'PROD007', 'CLI0012', DATE '2024-07-24', DATE '2025-07-23', 920.00, 'VENCIDO'),
    ('CONT0016', 'PROD007', 'CLI0013', DATE '2024-08-07', DATE '2025-08-06', 1002.50, 'VENCIDO'),
    ('CONT0017', 'PROD008', 'CLI0034', DATE '2024-08-21', DATE '2025-08-20', 2129.96, 'VENCIDO'),
    ('CONT0018', 'PROD008', 'CLI0014', DATE '2024-09-04', DATE '2025-09-03', 2215.50, 'SUSPENDIDO'),
    ('CONT0019', 'PROD009', 'CLI0015', DATE '2024-09-18', DATE '2025-09-17', 344.40, 'VENCIDO'),
    ('CONT0020', 'PROD009', 'CLI0016', DATE '2024-10-02', DATE '2025-10-01', 316.80, 'VENCIDO'),
    ('CONT0021', 'PROD010', 'CLI0035', DATE '2024-10-16', DATE '2025-10-15', 510.04, 'VENCIDO'),
    ('CONT0022', 'PROD011', 'CLI0017', DATE '2024-10-30', DATE '2025-10-29', 1543.00, 'VENCIDO'),
    ('CONT0023', 'PROD012', 'CLI0036', DATE '2024-11-13', DATE '2025-11-12', 2046.78, 'VENCIDO'),
    ('CONT0024', 'PROD001', 'CLI0037', DATE '2025-01-15', DATE '2026-01-14', 1290.01, 'VENCIDO'),
    ('CONT0025', 'PROD001', 'CLI0018', DATE '2025-02-01', DATE '2026-01-31', 1283.04, 'VENCIDO'),
    ('CONT0026', 'PROD002', 'CLI0019', DATE '2025-02-18', DATE '2026-02-17', 956.42, 'VENCIDO'),
    ('CONT0027', 'PROD002', 'CLI0020', DATE '2025-03-07', DATE '2026-03-06', 1040.74, 'VENCIDO'),
    ('CONT0028', 'PROD003', 'CLI0021', DATE '2025-03-24', DATE '2026-03-23', 534.30, 'VENCIDO'),
    ('CONT0029', 'PROD003', 'CLI0022', DATE '2025-04-10', DATE '2026-04-09', 584.60, 'VENCIDO'),
    ('CONT0030', 'PROD004', 'CLI0038', DATE '2025-04-27', DATE '2026-04-26', 1188.35, 'VENCIDO'),
    ('CONT0031', 'PROD004', 'CLI0023', DATE '2025-05-14', DATE '2026-05-13', 1242.08, 'VENCIDO'),
    ('CONT0032', 'PROD005', 'CLI0024', DATE '2025-05-31', DATE '2026-05-30', 1416.04, 'VENCIDO'),
    ('CONT0033', 'PROD005', 'CLI0025', DATE '2025-06-17', DATE '2026-06-16', 1534.38, 'SUSPENDIDO'),
    ('CONT0034', 'PROD006', 'CLI0026', DATE '2025-07-04', DATE '2026-07-03', 844.88, 'VENCIDO'),
    ('CONT0035', 'PROD007', 'CLI0039', DATE '2025-07-21', DATE '2026-07-20', 1033.34, 'ACTIVO'),
    ('CONT0036', 'PROD007', 'CLI0027', DATE '2025-08-07', DATE '2026-08-06', 1081.70, 'ACTIVO'),
    ('CONT0037', 'PROD008', 'CLI0028', DATE '2025-08-24', DATE '2026-08-23', 2210.92, 'ACTIVO'),
    ('CONT0038', 'PROD009', 'CLI0029', DATE '2025-09-10', DATE '2026-09-09', 355.45, 'ACTIVO'),
    ('CONT0039', 'PROD010', 'CLI0040', DATE '2025-09-27', DATE '2026-09-26', 587.34, 'ACTIVO'),
    ('CONT0040', 'PROD011', 'CLI0030', DATE '2025-10-14', DATE '2026-10-13', 1639.44, 'ACTIVO'),
    ('CONT0041', 'PROD011', 'CLI0001', DATE '2025-10-31', DATE '2026-10-30', 1776.68, 'ACTIVO'),
    ('CONT0042', 'PROD012', 'CLI0002', DATE '2025-11-17', DATE '2026-11-16', 2111.56, 'ACTIVO'),
    ('CONT0043', 'PROD001', 'CLI0031', DATE '2026-01-05', DATE '2027-01-04', 1369.37, 'ACTIVO'),
    ('CONT0044', 'PROD001', 'CLI0006', DATE '2026-01-11', DATE '2027-01-10', 1428.08, 'ACTIVO'),
    ('CONT0045', 'PROD001', 'CLI0004', DATE '2026-01-17', DATE '2027-01-16', 1475.52, 'ACTIVO'),
    ('CONT0046', 'PROD001', 'CLI0005', DATE '2026-01-23', DATE '2027-01-22', 1585.46, 'ACTIVO'),
    ('CONT0047', 'PROD002', 'CLI0003', DATE '2026-01-29', DATE '2027-01-28', 1038.84, 'ACTIVO'),
    ('CONT0048', 'PROD002', 'CLI0007', DATE '2026-02-04', DATE '2027-02-03', 1128.48, 'ACTIVO'),
    ('CONT0049', 'PROD002', 'CLI0008', DATE '2026-02-10', DATE '2027-02-09', 1218.12, 'ACTIVO'),
    ('CONT0050', 'PROD003', 'CLI0032', DATE '2026-02-16', DATE '2027-02-15', 554.94, 'ACTIVO'),
    ('CONT0051', 'PROD003', 'CLI0009', DATE '2026-02-22', DATE '2027-02-21', 586.70, 'ACTIVO'),
    ('CONT0052', 'PROD003', 'CLI0010', DATE '2026-02-28', DATE '2027-02-27', 639.80, 'SUSPENDIDO'),
    ('CONT0053', 'PROD003', 'CLI0011', DATE '2026-03-06', DATE '2027-03-05', 692.90, 'ACTIVO'),
    ('CONT0054', 'PROD004', 'CLI0033', DATE '2026-03-12', DATE '2027-03-11', 1326.37, 'ACTIVO'),
    ('CONT0055', 'PROD004', 'CLI0012', DATE '2026-03-18', DATE '2027-03-17', 1320.66, 'ACTIVO'),
    ('CONT0056', 'PROD004', 'CLI0013', DATE '2026-03-24', DATE '2027-03-23', 1426.54, 'ACTIVO'),
    ('CONT0057', 'PROD005', 'CLI0014', DATE '2026-03-30', DATE '2027-03-29', 1519.08, 'ACTIVO'),
    ('CONT0058', 'PROD005', 'CLI0015', DATE '2026-04-05', DATE '2027-04-04', 1645.26, 'ACTIVO'),
    ('CONT0059', 'PROD005', 'CLI0016', DATE '2026-04-11', DATE '2027-04-10', 1771.44, 'ACTIVO'),
    ('CONT0060', 'PROD006', 'CLI0034', DATE '2026-04-17', DATE '2027-04-16', 887.91, 'ACTIVO'),
    ('CONT0061', 'PROD006', 'CLI0017', DATE '2026-04-23', DATE '2027-04-22', 931.22, 'ACTIVO'),
    ('CONT0062', 'PROD006', 'CLI0018', DATE '2026-04-29', DATE '2027-04-28', 1008.68, 'ACTIVO'),
    ('CONT0063', 'PROD007', 'CLI0019', DATE '2026-05-05', DATE '2027-05-04', 1104.70, 'ACTIVO'),
    ('CONT0064', 'PROD007', 'CLI0020', DATE '2026-05-11', DATE '2027-05-10', 1198.40, 'ACTIVO'),
    ('CONT0065', 'PROD008', 'CLI0035', DATE '2026-05-17', DATE '2027-05-16', 2441.75, 'SUSPENDIDO'),
    ('CONT0066', 'PROD008', 'CLI0021', DATE '2026-05-23', DATE '2027-05-22', 2538.98, 'ACTIVO'),
    ('CONT0067', 'PROD009', 'CLI0036', DATE '2026-05-29', DATE '2027-05-28', 380.16, 'ACTIVO'),
    ('CONT0068', 'PROD009', 'CLI0022', DATE '2026-06-04', DATE '2027-06-03', 404.99, 'ACTIVO'),
    ('CONT0069', 'PROD010', 'CLI0023', DATE '2026-06-10', DATE '2027-06-09', 604.94, 'ACTIVO'),
    ('CONT0070', 'PROD010', 'CLI0024', DATE '2026-06-16', DATE '2027-06-15', 597.17, 'ACTIVO'),
    ('CONT0071', 'PROD011', 'CLI0037', DATE '2026-06-22', DATE '2027-06-21', 1843.82, 'ACTIVO'),
    ('CONT0072', 'PROD012', 'CLI0038', DATE '2026-06-28', DATE '2027-06-27', 2355.76, 'ACTIVO');


-- 10. EVALUACIONES Y RECOMENDACIONES
-- Se cargan 54 evaluaciones sobre contratos existentes.
INSERT INTO seguro_g29969634.recomienda (
    cod_cliente,
    cod_producto,
    cod_evaluacion_servicio,
    recomienda_amigo,
    fecha_evaluacion
)
VALUES
    ('CLI0001', 'PROD001', 'EV05', 'SI', DATE '2024-02-15'),
    ('CLI0031', 'PROD002', 'EV04', 'SI', DATE '2024-03-29'),
    ('CLI0006', 'PROD003', 'EV03', 'NO', DATE '2024-05-11'),
    ('CLI0032', 'PROD004', 'EV05', 'SI', DATE '2024-06-09'),
    ('CLI0009', 'PROD005', 'EV02', 'NO', DATE '2024-07-08'),
    ('CLI0033', 'PROD006', 'EV04', 'SI', DATE '2024-08-06'),
    ('CLI0012', 'PROD007', 'EV05', 'SI', DATE '2024-09-04'),
    ('CLI0034', 'PROD008', 'EV03', 'SI', DATE '2024-10-03'),
    ('CLI0015', 'PROD009', 'EV01', 'NO', DATE '2024-11-01'),
    ('CLI0035', 'PROD010', 'EV04', 'SI', DATE '2024-11-30'),
    ('CLI0017', 'PROD011', 'EV05', 'SI', DATE '2024-12-15'),
    ('CLI0036', 'PROD012', 'EV03', 'SI', DATE '2024-12-30'),
    ('CLI0002', 'PROD001', 'EV02', 'NO', DATE '2024-03-12'),
    ('CLI0004', 'PROD002', 'EV05', 'SI', DATE '2024-04-24'),
    ('CLI0037', 'PROD001', 'EV04', 'SI', DATE '2025-03-06'),
    ('CLI0019', 'PROD002', 'EV03', 'SI', DATE '2025-04-10'),
    ('CLI0021', 'PROD003', 'EV05', 'SI', DATE '2025-05-15'),
    ('CLI0038', 'PROD004', 'EV04', 'SI', DATE '2025-06-19'),
    ('CLI0024', 'PROD005', 'EV05', 'SI', DATE '2025-07-24'),
    ('CLI0026', 'PROD006', 'EV04', 'SI', DATE '2025-08-28'),
    ('CLI0039', 'PROD007', 'EV03', 'NO', DATE '2025-09-15'),
    ('CLI0028', 'PROD008', 'EV05', 'SI', DATE '2025-10-20'),
    ('CLI0029', 'PROD009', 'EV02', 'NO', DATE '2025-11-07'),
    ('CLI0040', 'PROD010', 'EV04', 'SI', DATE '2025-11-25'),
    ('CLI0030', 'PROD011', 'EV05', 'SI', DATE '2025-11-18'),
    ('CLI0002', 'PROD012', 'EV03', 'SI', DATE '2025-12-23'),
    ('CLI0018', 'PROD001', 'EV01', 'NO', DATE '2025-03-10'),
    ('CLI0020', 'PROD002', 'EV04', 'SI', DATE '2025-04-14'),
    ('CLI0022', 'PROD003', 'EV05', 'SI', DATE '2025-05-19'),
    ('CLI0023', 'PROD004', 'EV03', 'SI', DATE '2025-06-23'),
    ('CLI0031', 'PROD001', 'EV02', 'NO', DATE '2026-02-15'),
    ('CLI0003', 'PROD002', 'EV05', 'SI', DATE '2026-03-12'),
    ('CLI0032', 'PROD003', 'EV04', 'SI', DATE '2026-03-31'),
    ('CLI0033', 'PROD004', 'EV03', 'SI', DATE '2026-04-25'),
    ('CLI0014', 'PROD005', 'EV05', 'SI', DATE '2026-05-14'),
    ('CLI0034', 'PROD006', 'EV04', 'SI', DATE '2026-06-02'),
    ('CLI0019', 'PROD007', 'EV05', 'SI', DATE '2026-06-21'),
    ('CLI0035', 'PROD008', 'EV04', 'SI', DATE '2026-07-04'),
    ('CLI0036', 'PROD009', 'EV03', 'NO', DATE '2026-07-10'),
    ('CLI0023', 'PROD010', 'EV05', 'SI', DATE '2026-07-10'),
    ('CLI0037', 'PROD011', 'EV02', 'NO', DATE '2026-07-10'),
    ('CLI0038', 'PROD012', 'EV04', 'SI', DATE '2026-07-10'),
    ('CLI0006', 'PROD001', 'EV05', 'SI', DATE '2026-03-05'),
    ('CLI0007', 'PROD002', 'EV03', 'SI', DATE '2026-03-30'),
    ('CLI0009', 'PROD003', 'EV01', 'NO', DATE '2026-04-18'),
    ('CLI0012', 'PROD004', 'EV04', 'SI', DATE '2026-05-13'),
    ('CLI0015', 'PROD005', 'EV05', 'SI', DATE '2026-06-01'),
    ('CLI0017', 'PROD006', 'EV03', 'SI', DATE '2026-06-20'),
    ('CLI0020', 'PROD007', 'EV02', 'NO', DATE '2026-07-09'),
    ('CLI0021', 'PROD008', 'EV05', 'SI', DATE '2026-06-27'),
    ('CLI0022', 'PROD009', 'EV04', 'SI', DATE '2026-07-10'),
    ('CLI0024', 'PROD010', 'EV03', 'SI', DATE '2026-07-10'),
    ('CLI0004', 'PROD001', 'EV05', 'SI', DATE '2026-02-24'),
    ('CLI0010', 'PROD003', 'EV04', 'SI', DATE '2026-04-08');


-- 11. SINIESTROS
-- Cada descripción corresponde al producto del contrato.
INSERT INTO seguro_g29969634.siniestro (
    nro_siniestro,
    descripcion_siniestro
)
VALUES
    ('SIN0001', '  fallecimiento del asegurado '),
    ('SIN0002', '  hospitalización de emergencia '),
    ('SIN0003', '  pérdida de equipaje durante viaje '),
    ('SIN0004', '  colisión del vehículo asegurado '),
    ('SIN0005', 'ROBO DE BIENES ASEGURADOS'),
    ('SIN0006', 'DAÑOS EN EQUIPOS DE LA EMPRESA'),
    ('SIN0007', 'FALLECIMIENTO DEL ASEGURADO'),
    ('SIN0008', 'HOSPITALIZACIÓN DE EMERGENCIA'),
    ('SIN0009', 'Colisión del vehículo asegurado'),
    ('SIN0010', 'Daños ocasionados por incendio'),
    ('SIN0011', 'Daños por filtración en vivienda'),
    ('SIN0012', 'Solicitud de servicio funerario'),
    ('SIN0013', 'Fallecimiento del asegurado'),
    ('SIN0014', 'Hospitalización de emergencia'),
    ('SIN0015', 'Pérdida de equipaje durante viaje'),
    ('SIN0016', 'Colisión del vehículo asegurado'),
    ('SIN0017', 'Daños ocasionados por incendio'),
    ('SIN0018', 'Robo de bienes asegurados'),
    ('SIN0019', 'Daños por filtración en vivienda'),
    ('SIN0020', 'Daños en equipos de la empresa'),
    ('SIN0021', 'Avería mecánica en carretera'),
    ('SIN0022', 'Solicitud de servicio funerario'),
    ('SIN0023', 'Daños en establecimiento comercial'),
    ('SIN0024', 'Pérdida parcial de mercancía en tránsito');


-- 12. REGISTROS DE SINIESTRO
-- 2024: 6 | 2025: 6 | 2026: 12
INSERT INTO seguro_g29969634.registro_siniestro (
    nro_siniestro,
    nro_contrato,
    fecha_siniestro,
    fecha_respuesta,
    id_rechazo,
    monto_reconocido,
    monto_solicitado
)
VALUES
    ('SIN0001', 'CONT0001', DATE '2024-03-06', DATE '2024-03-12', 'NO', 1245.35, 1596.60),
    ('SIN0002', 'CONT0004', DATE '2024-04-18', DATE '2024-04-25', 'NO', 1296.90, 1543.93),
    ('SIN0003', 'CONT0007', DATE '2024-05-31', DATE '2024-06-08', 'NO', 781.33, 868.15),
    ('SIN0004', 'CONT0009', DATE '2024-06-29', DATE '2024-07-08', 'NO', 1035.29, 1437.90),
    ('SIN0005', 'CONT0014', DATE '2024-09-08', DATE '2024-09-21', 'SI', 0.00, 1204.06),
    ('SIN0006', 'CONT0018', DATE '2024-11-04', DATE '2024-11-15', 'NO', 2996.24, 3566.95),
    ('SIN0007', 'CONT0024', DATE '2025-03-18', NULL, 'NO', 0.00, 2309.12),
    ('SIN0008', 'CONT0026', DATE '2025-04-22', DATE '2025-05-05', 'NO', 860.77, 1195.52),
    ('SIN0009', 'CONT0031', DATE '2025-07-17', DATE '2025-07-31', 'NO', 1385.41, 1776.17),
    ('SIN0010', 'CONT0032', DATE '2025-08-04', DATE '2025-08-15', 'SI', 0.00, 2279.82),
    ('SIN0011', 'CONT0035', DATE '2025-09-25', DATE '2025-10-01', 'NO', 1664.71, 1849.68),
    ('SIN0012', 'CONT0039', DATE '2025-12-03', DATE '2025-12-10', 'NO', 528.61, 734.18),
    ('SIN0013', 'CONT0044', DATE '2026-03-20', DATE '2026-03-28', 'NO', 1592.88, 2042.15),
    ('SIN0014', 'CONT0047', DATE '2026-04-08', NULL, 'NO', 0.00, 1672.53),
    ('SIN0015', 'CONT0051', DATE '2026-05-03', DATE '2026-05-12', 'SI', 0.00, 1050.19),
    ('SIN0016', 'CONT0055', DATE '2026-05-28', DATE '2026-06-08', 'NO', 1188.60, 1650.83),
    ('SIN0017', 'CONT0057', DATE '2026-06-10', DATE '2026-06-22', 'NO', 1694.38, 2172.28),
    ('SIN0018', 'CONT0061', DATE '2026-07-05', DATE '2026-07-12', 'NO', 1259.38, 1499.26),
    ('SIN0019', 'CONT0063', DATE '2026-07-10', DATE '2026-07-12', 'NO', 1779.67, 1977.41),
    ('SIN0020', 'CONT0066', DATE '2026-07-10', DATE '2026-07-12', 'SI', 0.00, 3173.72),
    ('SIN0021', 'CONT0068', DATE '2026-07-10', NULL, 'NO', 0.00, 579.14),
    ('SIN0022', 'CONT0069', DATE '2026-07-10', DATE '2026-07-12', 'NO', 818.12, 973.95),
    ('SIN0023', 'CONT0071', DATE '2026-07-10', DATE '2026-07-12', 'NO', 2970.40, 3300.44),
    ('SIN0024', 'CONT0072', DATE '2026-07-10', DATE '2026-07-12', 'NO', 2120.18, 2944.70);


-- 13. METAS COMERCIALES
-- Una meta por producto y año: 12 x 3 = 36.
INSERT INTO seguro_g29969634.meta_comercial (
    cod_producto,
    anio,
    fecha_inicio,
    fecha_fin,
    monto_meta_ingreso,
    meta_renovacion,
    meta_asegurados
)
VALUES
    ('PROD001', 2024, DATE '2024-01-01', DATE '2024-12-31', 3275.10, 2, 2),
    ('PROD001', 2025, DATE '2025-01-01', DATE '2025-12-31', 2573.05, 1, 2),
    ('PROD001', 2026, DATE '2026-01-01', DATE '2026-12-31', 6561.44, 2, 5),
    ('PROD002', 2024, DATE '2024-01-01', DATE '2024-12-31', 2918.96, 2, 3),
    ('PROD002', 2025, DATE '2025-01-01', DATE '2025-12-31', 2236.82, 1, 3),
    ('PROD002', 2026, DATE '2026-01-01', DATE '2026-12-31', 3046.90, 2, 2),
    ('PROD003', 2024, DATE '2024-01-01', DATE '2024-12-31', 1139.60, 1, 3),
    ('PROD003', 2025, DATE '2025-01-01', DATE '2025-12-31', 1007.01, 1, 1),
    ('PROD003', 2026, DATE '2026-01-01', DATE '2026-12-31', 2474.34, 2, 4),
    ('PROD004', 2024, DATE '2024-01-01', DATE '2024-12-31', 2059.94, 1, 1),
    ('PROD004', 2025, DATE '2025-01-01', DATE '2025-12-31', 2430.43, 1, 2),
    ('PROD004', 2026, DATE '2026-01-01', DATE '2026-12-31', 4562.40, 2, 4),
    ('PROD005', 2024, DATE '2024-01-01', DATE '2024-12-31', 2711.50, 1, 2),
    ('PROD005', 2025, DATE '2025-01-01', DATE '2025-12-31', 3304.47, 1, 3),
    ('PROD005', 2026, DATE '2026-01-01', DATE '2026-12-31', 4442.20, 2, 2),
    ('PROD006', 2024, DATE '2024-01-01', DATE '2024-12-31', 1842.33, 1, 3),
    ('PROD006', 2025, DATE '2025-01-01', DATE '2025-12-31', 760.39, 1, 1),
    ('PROD006', 2026, DATE '2026-01-01', DATE '2026-12-31', 2827.81, 2, 3),
    ('PROD007', 2024, DATE '2024-01-01', DATE '2024-12-31', 1730.25, 1, 1),
    ('PROD007', 2025, DATE '2025-01-01', DATE '2025-12-31', 2115.04, 1, 2),
    ('PROD007', 2026, DATE '2026-01-01', DATE '2026-12-31', 2579.47, 1, 3),
    ('PROD008', 2024, DATE '2024-01-01', DATE '2024-12-31', 4345.46, 1, 2),
    ('PROD008', 2025, DATE '2025-01-01', DATE '2025-12-31', 2476.23, 1, 2),
    ('PROD008', 2026, DATE '2026-01-01', DATE '2026-12-31', 4482.66, 1, 1),
    ('PROD009', 2024, DATE '2024-01-01', DATE '2024-12-31', 740.54, 1, 3),
    ('PROD009', 2025, DATE '2025-01-01', DATE '2025-12-31', 319.90, 1, 1),
    ('PROD009', 2026, DATE '2026-01-01', DATE '2026-12-31', 785.15, 1, 2),
    ('PROD010', 2024, DATE '2024-01-01', DATE '2024-12-31', 459.04, 1, 1),
    ('PROD010', 2025, DATE '2025-01-01', DATE '2025-12-31', 587.34, 1, 1),
    ('PROD010', 2026, DATE '2026-01-01', DATE '2026-12-31', 1346.36, 1, 3),
    ('PROD011', 2024, DATE '2024-01-01', DATE '2024-12-31', 1543.00, 1, 1),
    ('PROD011', 2025, DATE '2025-01-01', DATE '2025-12-31', 3826.05, 1, 3),
    ('PROD011', 2026, DATE '2026-01-01', DATE '2026-12-31', 1659.44, 1, 1),
    ('PROD012', 2024, DATE '2024-01-01', DATE '2024-12-31', 2292.39, 1, 2),
    ('PROD012', 2025, DATE '2025-01-01', DATE '2025-12-31', 1900.40, 1, 1),
    ('PROD012', 2026, DATE '2026-01-01', DATE '2026-12-31', 2355.76, 1, 1);


COMMIT;
