DELETE FROM ciudad;
DELETE FROM sucursal;
DELETE FROM empleado;
DELETE FROM cliente;
DELETE FROM plazo_fijo;
DELETE FROM tasa_plazo_fijo;
DELETE FROM plazo_cliente;
DELETE FROM prestamo;
DELETE FROM pago;
DELETE FROM tasa_prestamo;
DELETE FROM caja_ahorro;
DELETE FROM cliente_ca;
DELETE FROM tarjeta;
DELETE FROM caja;
DELETE FROM ventanilla;
DELETE FROM atm;
DELETE FROM transaccion;
DELETE FROM debito;
DELETE FROM transaccion_por_caja;
DELETE FROM deposito;
DELETE FROM extraccion;
DELETE FROM transferencia;

#----------------------------------------------------------------------------------------------------------------------------
# CIUDADES
INSERT INTO ciudad (nombre, cod_postal) VALUES ('Bahia Blanca', '8000');
INSERT INTO ciudad (nombre, cod_postal) VALUES ('Neuquen', '8300');
INSERT INTO ciudad (nombre, cod_postal) VALUES ('Capital', '1000');

#----------------------------------------------------------------------------------------------------------------------------
# SUCURSALES
INSERT INTO sucursal (nro_suc, nombre, direccion, telefono, horario, cod_postal) VALUES
(111, 'Primera', 'Charlone 456', '2914838385', '8 a 14', '8000'),
(222, 'Olimpo', 'Brown 405', '2914578346', '8 a 14', '8000'),
(333, 'Neuquino', 'Independencia 50', '2994235478', '8 a 20', '8300'),
(444, 'Belgranito', 'Cabildo 2201', '1153684930', '8 a 20', '1000'),
(555, 'La Boca', 'Brandsen 805', '1155245637', '8 a 20', '1000');

#----------------------------------------------------------------------------------------------------------------------------
# EMPLEADOS
INSERT INTO empleado (legajo, apellido, nombre, tipo_doc, nro_doc, direccion, password, telefono, cargo, nro_suc) VALUES
(1001, 'Perez', 'Alfredo', 'Dni', 12456765, 'Brandsen 115', md5('1234'), '291456456', 'Encargado', 111),
(1002, 'Fernandez', 'Enzo', 'Dni', 43567234, 'Brown 84', md5('1234'), '291345678', 'Gerente', 111),
(1003, 'Alvarez', 'Julian', 'Dni', 44543789, 'Sarmiento 456', md5('1234'), '291234795', 'Secretario', 111),
(1004, 'Romero', 'Cristian', 'Dni', 22567456, 'Cabildo 1345', md5('5678'), '115723494', 'Encargado', 444),
(1005, 'Martinez', 'Emiliano', 'Dni', 33367890, 'Nicaragua 234', md5('5678'), '115572958', 'Gerente', 444),
(1006, 'Messi', 'Leonel', 'Dni', 34565423, 'Roca 45', md5('5678'), '114832949', 'Secretario', 444),
(1007, 'Gonzalez', 'Nicolas', 'Dni', 42345789, 'Chiclana 1234', md5('8901'), '291462844', 'Encargado', 222),
(1008, 'Otamendi', 'Nicolas', 'Dni', 46745762, 'Alem 345', md5('8901'), '291885235', 'Gerente', 222),
(1009, 'Tagliafico', 'Nicolas', 'Dni', 21456432, 'Alem 1456', md5('8901'), '291563456', 'Secretario', 222),
(1010, 'Acunia', 'Marcos', 'Dni', 25345321, 'Italia 2445', md5('2345'), '113486432', 'Encargado', 555),
(1011, 'Alvarez', 'Martin', 'Dni', 40378421, 'Francia 234', md5('2345'), '115935305', 'Gerente', 555),
(1012, 'Martinez', 'Lautaro', 'Dni', 34567438, 'Sarmiento 563', md5('2345'), '116932346', 'Secretario', 555),
(1013, 'Pezzella', 'German', 'Dni', 43496394, 'Caronti 3589', md5('7890'), '299406924', 'Encargado', 333),
(1014, 'Scaloni', 'Leonel', 'Dni', 42348567, 'Estomba 2389', md5('7890'), '299572940', 'Gerente', 333),
(1015, 'Mbappe', 'Fernando', 'Dni', 40432573, 'Cuyo 289', md5('7890'), '299238034', 'Secretario', 333);

#----------------------------------------------------------------------------------------------------------------------------
# CLIENTE
INSERT INTO cliente (nro_cliente, telefono, fecha_nac, nombre, apellido, tipo_doc, nro_doc, direccion) VALUES
(10001, '291458283', '2001-04-09', 'Alfredo', 'Martinez', 'Dni', 43780233, 'Brown 67'),
(10002, '291684032', '2002-05-06', 'Raul', 'Rodriguez', 'Dni', 44556784, 'Rodriguez 115'),
(10003, '291784960', '1989-02-06', 'Enrique', 'Rodriguez', 'Dni', 30456789, 'Mitre 56'),
(10004, '291432007', '1999-09-24', 'Mario', 'Perez', 'Dni', 40234567, 'Sarmiento 123'),
(10005, '299603004', '2002-09-30', 'Simon', 'Fernandez', 'Dni', 45007890, 'Alem 1234'),
(10006, '299906543', '1980-01-01', 'Alberto', 'Messi', 'Dni', 25678345, 'Chiclana 115'),
(10007, '114650706', '2000-05-20', 'Sergio', 'Di Maria', 'Dni', 42357885, 'Chiclana 1456'),
(10008, '110539045', '2001-06-03', 'Fernando', 'Romero', 'Dni', 43890345, 'Caronti 432'),
(10009, '112005023', '1994-04-08', 'Ismael', 'Martinez', 'Dni', 35063135, 'Casanova 1238'),
(10010, '118906306', '1982-05-23', 'Facundo', 'Gomez', 'Dni', 26783456, 'Ohiggins 4892');

#----------------------------------------------------------------------------------------------------------------------------
# PLAZO_FIJO
INSERT INTO plazo_fijo (nro_plazo, capital, tasa_interes, interes, fecha_inicio, fecha_fin, nro_suc) VALUES
(51111111, 100000.00, 25.50, 102.00, '2024-08-01', '2028-08-01', 111),
(52222222, 300000.00, 45.00, 180.00, '2024-07-01', '2028-07-01', 222),
(54444444, 200000.00, 30.00, 90.00, '2024-02-01', '2027-02-01', 111),
(55555555, 50000.00, 20.00, 40.00, '2023-05-01', '2025-05-01', 333),
(56666666, 400000.00, 60.00, 300.00, '2023-12-01', '2028-12-01', 444),
(57777777, 100000.00, 25.50, 102.00, '2023-06-01', '2025-06-01', 555);

#----------------------------------------------------------------------------------------------------------------------------
# TASA_PLAZO_FIJO
INSERT INTO tasa_plazo_fijo (periodo, monto_inf, monto_sup, tasa) VALUES
(48, 30000.00, 50000.00, 40.50),
(36, 15000.00, 25000.00, 30.50),
(24, 5000.00, 10000.00, 20.50);

#----------------------------------------------------------------------------------------------------------------------------
# PLAZO_CLIENTE
INSERT INTO plazo_cliente (nro_plazo, nro_cliente) VALUES
(51111111, 10002),
(54444444, 10008),
(56666666, 10010),
(57777777, 10007);

#----------------------------------------------------------------------------------------------------------------------------
# PRESTAMO
INSERT INTO prestamo (nro_prestamo, cant_meses, fecha, tasa_interes, interes, monto, valor_cuota, legajo, nro_cliente) VALUES
(11111111, 5, '2024-01-10', 15.00, 1200.00, 50000.00, 1000.00, 1001, 10003),
(11111112, 2, '2024-03-12', 20.00, 800.00, 30000.00, 800.00, 1002, 10002),
(11111113, 3, '2024-07-05', 25.00, 500.00, 10000.00, 833.33, 1003, 10004),
(11111114, 3, '2024-09-10', 10.00, 600.00, 20000.00, 500.00, 1004, 10005);

#----------------------------------------------------------------------------------------------------------------------------
# PAGO
-- INSERT INTO pago(nro_prestamo,nro_pago,fecha_venc,fecha_pago)VALUES
-- (11111111,1,'2024-01-01','2024-01-10'),
-- (11111111,2,'2024-02-01','2024-02-10'),
-- (11111111,3,'2024-03-01', NULL),
-- (11111111,4,'2024-04-01', NULL),
-- (11111111,5,'2024-05-01', NULL),
-- (11111112,1,'2024-03-01',NULL),
-- (11111112,2,'2024-04-01',NULL),
-- (11111113,1,'2024-07-01','2024-07-05'),
-- (11111113,2,'2024-08-01',NULL),
-- (11111113,3,'2024-09-01',NULL),
-- (11111114,1,'2024-09-01','2024-09-10'),
-- (11111114,2,'2024-10-01','2024-09-10'),
-- (11111114,3,'2024-11-01',NULL);

UPDATE pago SET fecha_venc = '2024-01-01', fecha_pago = '2024-01-10' WHERE nro_prestamo = 11111111 AND nro_pago = 1;
UPDATE pago SET fecha_venc = '2024-02-01', fecha_pago = '2024-02-10' WHERE nro_prestamo = 11111111 AND nro_pago = 2;
UPDATE pago SET fecha_venc = '2024-03-01', fecha_pago = NULL WHERE nro_prestamo = 11111111 AND nro_pago = 3;
UPDATE pago SET fecha_venc = '2024-04-01', fecha_pago = NULL WHERE nro_prestamo = 11111111 AND nro_pago = 4;
UPDATE pago SET fecha_venc = '2024-05-01', fecha_pago = NULL WHERE nro_prestamo = 11111111 AND nro_pago = 5;

UPDATE pago SET fecha_venc = '2024-03-01', fecha_pago = NULL WHERE nro_prestamo = 11111112 AND nro_pago = 1;
UPDATE pago SET fecha_venc = '2024-04-01', fecha_pago = NULL WHERE nro_prestamo = 11111112 AND nro_pago = 2;

UPDATE pago SET fecha_venc = '2024-07-01', fecha_pago = '2024-07-05' WHERE nro_prestamo = 11111113 AND nro_pago = 1;
UPDATE pago SET fecha_venc = '2024-08-01', fecha_pago = NULL WHERE nro_prestamo = 11111113 AND nro_pago = 2;
UPDATE pago SET fecha_venc = '2024-09-01', fecha_pago = NULL WHERE nro_prestamo = 11111113 AND nro_pago = 3;

UPDATE pago SET fecha_venc = '2024-09-01', fecha_pago = '2024-09-10' WHERE nro_prestamo = 11111114 AND nro_pago = 1;
UPDATE pago SET fecha_venc = '2024-10-01', fecha_pago = '2024-09-10' WHERE nro_prestamo = 11111114 AND nro_pago = 2;
UPDATE pago SET fecha_venc = '2024-11-01', fecha_pago = NULL WHERE nro_prestamo = 11111114 AND nro_pago = 3;




#----------------------------------------------------------------------------------------------------------------------------
# TASA_PRESTAMO
INSERT INTO tasa_prestamo(periodo,tasa,monto_inf,monto_sup) VALUES
(48,40.50,30000.00,50000.00),
(36,30.50,20000.00,25000.00),
(24,20.50,5000.00,15000.00);

#----------------------------------------------------------------------------------------------------------------------------
# CAJA_AHORRO
INSERT INTO caja_ahorro(nro_ca,cbu,saldo)VALUES
(10000001,123456789011111111,00.00),
(10000002,123456789022222222,2000000.00),
(10000003,123456789033333333,10000.00),
(10000004,123456789044444444,4000000.00),
(10000005,123456789055555555,4000000.00),
(10000006,123456789066666666,5000000.00),
(10000007,123456789077777777,6000000.00),
(10000008,123456789088888888,7000000.00),
(10000009,123456789099999999,7000000.00),
(10000010,123456789010101010,00.00);
#----------------------------------------------------------------------------------------------------------------------------
# CLIENTE_CA
INSERT INTO cliente_ca (nro_cliente, nro_ca) VALUES
(10001, 10000001),
(10002, 10000002),
(10003, 10000003),
(10004, 10000004);

#----------------------------------------------------------------------------------------------------------------------------
# TARJETA
INSERT INTO tarjeta(nro_tarjeta,fecha_venc,PIN,CVT,nro_cliente,nro_ca) VALUES
(123456789011,'2025-01-01',md5('yess'),md5('0980'),10001,10000001),
(123456789012,'2025-06-01',md5('nopo'),md5('0990'),10002,10000002),
(123456789013,'2025-07-01',md5('sopa'),md5('2340'),10003,10000003),
(123456789014,'2025-08-01',md5('sapo'),md5('5960'),10004,10000004);

#----------------------------------------------------------------------------------------------------------------------------
# CAJA
INSERT INTO caja(cod_caja)VALUES
(10),
(11),
(12),
(13),
(14);

#----------------------------------------------------------------------------------------------------------------------------
# VENTANILLA
INSERT INTO ventanilla(cod_caja,nro_suc)VALUES
(10,111),
(11,222),
(12,333),
(13,444),
(14,555);

#----------------------------------------------------------------------------------------------------------------------------
# ATM
INSERT INTO atm(cod_caja,cod_postal,direccion)VALUES
(10,8000,'Charlone 456'),
(11,8300,'Independencia 50'),
(12,1000,'Brandsen 805');

#----------------------------------------------------------------------------------------------------------------------------
# TRANSACCION
INSERT INTO transaccion(nro_trans,monto,fecha,hora)VALUES
(1045,100.00,'2024-05-01','12:00:00'),
(1046,300.00,'2024-06-03','13:00:00'),
(1047,600.00,'2024-02-08','16:00:00'),
(1048,700.00,'2024-09-21','09:00:00'),
(1049,600.00,'2024-02-08','16:00:00'),
(1050,600.00,'2024-02-08','15:00:00'),
(1051,600.00,'2024-02-08','14:00:00'),
(1052,600.00,'2024-02-08','13:00:00'),
(1053,600.00,'2024-02-08','12:00:00'),
(1054,600.00,'2024-02-08','11:00:00'),
(1055,600.00,'2024-02-08','10:00:00'),
(1056,600.00,'2024-02-05','09:00:00'),
(1057,600.00,'2024-02-08','08:00:00'),
(1058,600.00,'2022-02-08','07:00:00'),
(1059,600.00,'2024-02-08','06:00:00');


#----------------------------------------------------------------------------------------------------------------------------
# DEBITO
INSERT INTO debito(nro_trans,descripcion,nro_cliente,nro_ca)VALUES
(1045,'varios',10001, 10000001),
(1046,'prestamos',10002,10000002),
(1047,'construccion',10003,10000003),
(1048,'varios',10004,10000004);

#----------------------------------------------------------------------------------------------------------------------------
# TRANSACCION_POR_CAJA
INSERT INTO transaccion_por_caja (nro_trans, cod_caja) VALUES
(1049, 10),
(1050, 10),
(1051, 11),
(1052, 12),
(1053, 12),
(1054, 11),
(1055, 12),
(1056, 10),
(1057, 10),
(1058, 10),
(1059, 10);

#----------------------------------------------------------------------------------------------------------------------------
# DEPOSITO
INSERT INTO deposito(nro_trans,nro_ca) VALUES
(1053, 10000001),
(1054, 10000002),
(1055, 10000003),
(1056, 10000004);

#----------------------------------------------------------------------------------------------------------------------------
# EXTRACCION
INSERT INTO extraccion(nro_trans,nro_cliente, nro_ca)VALUES
(1049,10001,10000001),
(1050,10002,10000002),
(1051,10003,10000003),
(1052,10004,10000004);

#----------------------------------------------------------------------------------------------------------------------------
# TRANSFERENCIA
INSERT INTO transferencia(nro_trans, nro_cliente, origen, destino)VALUES
(1057,10001,10000001,10000004),
(1058,10002,10000002,10000008),
(1059,10003,10000003,10000006);
