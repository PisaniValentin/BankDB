CREATE DATABASE banco;
use banco;
DROP user IF EXISTS ''@localhost; 

CREATE TABLE ciudad(
    nombre VARCHAR(20) NOT NULL, 
    cod_postal int UNSIGNED NOT NULL CHECK(cod_postal BETWEEN 0 AND 9999), 

    CONSTRAINT pk_ciudad
    PRIMARY KEY(cod_postal)
) ENGINE=InnoDB;

CREATE TABLE sucursal(
    nro_suc int UNSIGNED NOT NULL AUTO_INCREMENT, 
    nombre VARCHAR(20) NOT NULL, 
    direccion VARCHAR(20) NOT NULL, 
    telefono VARCHAR(20) NOT NULL, 
    horario VARCHAR(50) NOT NULL,
    cod_postal int UNSIGNED NOT NULL,

    CONSTRAINT pk_sucursal
    PRIMARY KEY(nro_suc),

    CONSTRAINT fk_sucursal_cod_postal
    FOREIGN KEY(cod_postal) REFERENCES ciudad(cod_postal)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE empleado(
    legajo int UNSIGNED AUTO_INCREMENT NOT NULL,
    apellido VARCHAR(20) NOT NULL, 
    nombre VARCHAR(20) NOT NULL, 
    tipo_doc VARCHAR(20) NOT NULL, 
    nro_doc int UNSIGNED NOT NULL CHECK (nro_doc BETWEEN 0 AND 99999999),
    direccion VARCHAR(20) NOT NULL,
    password VARCHAR(32) NOT NULL, 
    telefono VARCHAR(20) NOT NULL,
    cargo VARCHAR(20) NOT NULL,
    nro_suc int UNSIGNED NOT NULL,

    CONSTRAINT pk_empleado
    PRIMARY KEY (legajo),

    CONSTRAINT fk_empleado_nro_suc
    FOREIGN KEY(nro_suc) REFERENCES sucursal(nro_suc)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE cliente(
    nro_cliente int UNSIGNED NOT NULL AUTO_INCREMENT, 
    telefono VARCHAR(20) NOT NULL, 
    fecha_nac DATE NOT NULL, 
    nombre VARCHAR(20) NOT NULL, 
    apellido VARCHAR(20) NOT NULL, 
    tipo_doc VARCHAR(20) NOT NULL, 
    nro_doc int UNSIGNED NOT NULL CHECK(nro_doc BETWEEN 0 AND 99999999), 
    direccion VARCHAR(20) NOT NULL, 

    CONSTRAINT pk_cliente
    PRIMARY KEY(nro_cliente)
) ENGINE=InnoDB;

CREATE TABLE plazo_fijo(
    nro_plazo int UNSIGNED NOT NULL AUTO_INCREMENT,
    capital DECIMAL(16,2) UNSIGNED NOT NULL, 
    tasa_interes DECIMAL(4,2) UNSIGNED NOT NULL,
    interes DECIMAL(16,2) UNSIGNED NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    nro_suc int UNSIGNED NOT NULL,

    CONSTRAINT pk_plazo_fijo
    PRIMARY KEY(nro_plazo),

    CONSTRAINT fk_plazo_fijo_nro_suc
    FOREIGN KEY(nro_suc) REFERENCES sucursal(nro_suc)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE tasa_plazo_fijo(
    periodo int UNSIGNED NOT NULL CHECK(periodo BETWEEN 0 AND 999),
    monto_inf DECIMAL(16,2) UNSIGNED NOT NULL,
    monto_sup DECIMAL(16,2) UNSIGNED NOT NULL,
    tasa DECIMAL(4,2) UNSIGNED NOT NULL,

    CONSTRAINT pk_plazo_fijo
    PRIMARY KEY(periodo,monto_inf,monto_sup)
) ENGINE=InnoDB;

CREATE TABLE plazo_cliente(
    nro_plazo int UNSIGNED NOT NULL,
    nro_cliente int UNSIGNED NOT NULL, 

    CONSTRAINT pk_plazo_cliente
    PRIMARY KEY(nro_plazo,nro_cliente),

    CONSTRAINT fk_plazo_cliente_nro_plazo
    FOREIGN KEY(nro_plazo) REFERENCES plazo_fijo(nro_plazo)
    ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT fk_plazo_cliente_nro_cliente
    FOREIGN KEY(nro_cliente) REFERENCES cliente(nro_cliente)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE prestamo(
    nro_prestamo int UNSIGNED NOT NULL AUTO_INCREMENT,
    cant_meses int UNSIGNED NOT NULL CHECK(cant_meses BETWEEN 0 AND 99), 
    fecha DATE NOT NULL, 
    tasa_interes DECIMAL(4,2) UNSIGNED NOT NULL CHECK( tasa_interes > 0),
    interes DECIMAL(9,2) UNSIGNED NOT NULL CHECK( interes >= 0),
    monto DECIMAL(10,2) UNSIGNED NOT NULL CHECK( monto > 0), 
    valor_cuota DECIMAL(9,2) UNSIGNED NOT NULL CHECK( valor_cuota >= 0),
    legajo int UNSIGNED NOT NULL,
    nro_cliente int UNSIGNED NOT NULL,

    CONSTRAINT pk_prestamo
    PRIMARY KEY(nro_prestamo),

    CONSTRAINT fk_prestamo_legajo
    FOREIGN KEY(legajo) REFERENCES empleado(legajo)
    ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT fk_prestamo_nro_cliente
    FOREIGN KEY(nro_cliente) REFERENCES cliente(nro_cliente)
    ON DELETE RESTRICT ON UPDATE CASCADE

) ENGINE=InnoDB;

CREATE TABLE pago(
    nro_prestamo int UNSIGNED NOT NULL,
    nro_pago int UNSIGNED CHECK (nro_pago BETWEEN 0 AND 99),
    fecha_venc DATE NOT NULL,
    fecha_pago DATE,

    CONSTRAINT pk_pago
    PRIMARY KEY(nro_prestamo,nro_pago),

    CONSTRAINT fk_nro_prestamo
    FOREIGN KEY(nro_prestamo) REFERENCES prestamo(nro_prestamo)
    ON DELETE RESTRICT ON UPDATE CASCADE

) ENGINE=InnoDB;

CREATE TABLE tasa_prestamo(
    periodo int UNSIGNED NOT NULL CHECK(periodo BETWEEN 0 AND 999),
    tasa DECIMAL(4,2) UNSIGNED NOT NULL CHECK( tasa > 0),
    monto_inf DECIMAL(10,2) UNSIGNED,
    monto_sup DECIMAL(10,2) UNSIGNED,

    CONSTRAINT pk_tasa_prestamo
    PRIMARY KEY(periodo,monto_inf,monto_sup)
) ENGINE=InnoDB;

CREATE TABLE caja_ahorro(
    nro_ca int UNSIGNED NOT NULL AUTO_INCREMENT,
    cbu BIGINT UNSIGNED NOT NULL CHECK (cbu BETWEEN 0 AND 999999999999999999),
    saldo DECIMAL(16,2) UNSIGNED NOT NULL CHECK ( saldo >= 0),

    CONSTRAINT pk_caja_ahorro
    PRIMARY KEY(nro_ca)
) ENGINE=InnoDB;

CREATE TABLE cliente_ca(
    nro_cliente int UNSIGNED NOT NULL,
    nro_ca int UNSIGNED NOT NULL,

    CONSTRAINT pk_cliente_ca
    PRIMARY KEY(nro_cliente,nro_ca),

    CONSTRAINT fk_cliente_ca_nro_cliente
    FOREIGN KEY(nro_cliente) REFERENCES cliente(nro_cliente)
    ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT fk_cliente_ca_nro_ca
    FOREIGN KEY(nro_ca) REFERENCES caja_ahorro(nro_ca)
    ON DELETE RESTRICT ON UPDATE CASCADE

) ENGINE=InnoDB;

CREATE TABLE tarjeta(
    nro_tarjeta BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, 
    fecha_venc DATE NOT NULL,
    PIN VARCHAR(32) NOT NULL, 
    CVT VARCHAR(32) NOT NULL, 
    nro_cliente int UNSIGNED NOT NULL,
    nro_ca int UNSIGNED NOT NULL,

    CONSTRAINT pk_tarjeta
    PRIMARY KEY(nro_tarjeta),

    CONSTRAINT fk_tarjeta_nro_cliente_nro_ca
    FOREIGN KEY(nro_cliente,nro_ca) REFERENCES cliente_ca(nro_cliente,nro_ca)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE caja(
    cod_caja int UNSIGNED NOT NULL AUTO_INCREMENT,

    CONSTRAINT pk_caja
    PRIMARY KEY(cod_caja)
) ENGINE=InnoDB;

CREATE TABLE ventanilla(
    cod_caja int UNSIGNED NOT NULL,
    nro_suc int UNSIGNED AUTO_INCREMENT NOT NULL,  
    CONSTRAINT pk_ventanilla
    PRIMARY KEY(cod_caja),

    CONSTRAINT fk_ventanilla_cod_caja
    FOREIGN KEY(cod_caja) REFERENCES caja(cod_caja)
    ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT fk_ventanilla_nro_suc
    FOREIGN KEY(nro_suc) REFERENCES sucursal(nro_suc)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE atm(
    cod_caja int UNSIGNED NOT NULL,
    cod_postal int UNSIGNED NOT NULL,
    direccion VARCHAR(20) NOT NULL,

    CONSTRAINT pk_atm
    PRIMARY KEY(cod_caja),

    CONSTRAINT fk_atm_cod_caja
    FOREIGN KEY(cod_caja) REFERENCES caja(cod_caja)
    ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT fk_atm_cod_postal
    FOREIGN KEY(cod_postal) REFERENCES ciudad(cod_postal)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE transaccion(
    nro_trans int UNSIGNED NOT NULL AUTO_INCREMENT,
    monto DECIMAL(16,2) UNSIGNED NOT NULL CHECK (monto >= 0),
    fecha DATE NOT NULL,
    hora TIME NOT NULL,

    CONSTRAINT pk_transaccion
    PRIMARY KEY(nro_trans)
) ENGINE=InnoDB;

CREATE TABLE debito(
    nro_trans int UNSIGNED NOT NULL,
    descripcion TEXT,
    nro_cliente int UNSIGNED NOT NULL,
    nro_ca int UNSIGNED NOT NULL,

    CONSTRAINT pk_debito
    PRIMARY KEY(nro_trans),

    CONSTRAINT fk_debito_nro_trans
    FOREIGN KEY(nro_trans) REFERENCES transaccion(nro_trans)
    ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT fk_debito_nro_cliente_nro_ca
    FOREIGN KEY(nro_cliente,nro_ca) REFERENCES cliente_ca(nro_cliente,nro_ca)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;


CREATE TABLE transaccion_por_caja(
    nro_trans int UNSIGNED NOT NULL,
    cod_caja int UNSIGNED NOT NULL,

    CONSTRAINT pk_transaccion_por_caja
    PRIMARY KEY(nro_trans),

    CONSTRAINT fk_transaccion_por_caja_nro_trans
    FOREIGN KEY(nro_trans) REFERENCES transaccion(nro_trans)
    ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT fk_transaccion_por_caja_cod_caja
    FOREIGN KEY(cod_caja) REFERENCES caja(cod_caja)
    ON DELETE RESTRICT ON UPDATE CASCADE


) ENGINE=InnoDB;

CREATE TABLE deposito(
    nro_trans int UNSIGNED NOT NULL,
    nro_ca int UNSIGNED NOT NULL,

    CONSTRAINT pk_deposito
    PRIMARY KEY(nro_trans),

    CONSTRAINT fk_deposito_nro_trans
    FOREIGN KEY(nro_trans) REFERENCES transaccion_por_caja(nro_trans)
    ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT fk_deposito_nro_ca
    FOREIGN KEY(nro_ca) REFERENCES caja_ahorro(nro_ca)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE extraccion(
    nro_trans int UNSIGNED NOT NULL,
    nro_cliente int UNSIGNED NOT NULL, 
    nro_ca int UNSIGNED NOT NULL,

    CONSTRAINT pk_extraccion
    PRIMARY KEY(nro_trans),

    CONSTRAINT fk_extraccion_nro_trans
    FOREIGN KEY(nro_trans) REFERENCES transaccion_por_caja(nro_trans)
    ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT fk_extraccion_nro_ca_nro_cliente
    FOREIGN KEY(nro_cliente,nro_ca) REFERENCES cliente_ca(nro_cliente,nro_ca)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE transferencia(
    nro_trans int UNSIGNED NOT NULL,
    nro_cliente int UNSIGNED NOT NULL, 
    origen int UNSIGNED NOT NULL,
    destino int UNSIGNED NOT NULL,

    CONSTRAINT pk_transferencia
    PRIMARY KEY(nro_trans),

    CONSTRAINT fk_transferencia_nro_trans
    FOREIGN KEY(nro_trans) REFERENCES transaccion_por_caja(nro_trans)
    ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT fk_transferencia_nro_cliente_origen
    FOREIGN KEY(nro_cliente,origen) REFERENCES cliente_ca(nro_cliente,nro_ca)
    ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT fk_transferencia_destino
    FOREIGN KEY(destino) REFERENCES caja_ahorro(nro_ca)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE VIEW trans_cajas_ahorro AS
SELECT 
caja_ahorro.nro_ca,
caja_ahorro.saldo,
transaccion.nro_trans,
transaccion.fecha,
transaccion.hora,
case 
when transaccion.nro_trans in (select nro_trans from deposito) then 'Deposito'
end as Tipo,
transaccion.monto,
transaccion_por_caja.cod_caja,
NULL AS nro_cliente,
NULL as tipo_doc,
NULL as nro_doc,
NULL as nombre,
NULL as apellido,
NULL AS destino
FROM transaccion
NATURAL JOIN transaccion_por_caja
NATURAL JOIN deposito
NATURAL JOIN caja_ahorro
UNION ALL
SELECT 
caja_ahorro.nro_ca,
caja_ahorro.saldo,
transaccion.nro_trans,
transaccion.fecha,
transaccion.hora,
case 
when transaccion.nro_trans in (select nro_trans from extraccion) then 'Extraccion' 
end as Tipo,
transaccion.monto,
transaccion_por_caja.cod_caja,
cliente.nro_cliente,
cliente.tipo_doc,
cliente.nro_doc,
cliente.nombre,
cliente.apellido,
NULL AS destino
FROM transaccion
NATURAL JOIN transaccion_por_caja
NATURAL JOIN extraccion
NATURAL JOIN caja_ahorro
NATURAL JOIN cliente_ca
NATURAL JOIN cliente
UNION ALL
SELECT 
caja_ahorro.nro_ca,
caja_ahorro.saldo,
transaccion.nro_trans,
transaccion.fecha,
transaccion.hora,
case 
when transaccion.nro_trans in (select nro_trans from transferencia) then 'Transferencia'
end as Tipo,
transaccion.monto,
transaccion_por_caja.cod_caja,
cliente.nro_cliente,
cliente.tipo_doc,
cliente.nro_doc,
cliente.nombre,
cliente.apellido,
transferencia.destino
FROM transaccion
NATURAL JOIN transaccion_por_caja
NATURAL JOIN transferencia
JOIN caja_ahorro ON caja_ahorro.nro_ca = transferencia.origen
NATURAL JOIN cliente_ca
NATURAL JOIN cliente
UNION ALL
SELECT 
caja_ahorro.nro_ca,
caja_ahorro.saldo,
transaccion.nro_trans,
transaccion.fecha,
transaccion.hora,
case
when transaccion.nro_trans in (select nro_trans from debito) then 'Debito'
end as Tipo,
transaccion.monto,
NULL AS cod_caja,
cliente.nro_cliente,
cliente.tipo_doc,
cliente.nro_doc,
cliente.nombre,
cliente.apellido,
NULL AS destino
FROM transaccion
NATURAL JOIN debito
NATURAL JOIN caja_ahorro
NATURAL JOIN cliente_ca
NATURAL JOIN cliente
ORDER BY nro_trans;

delimiter !
CREATE PROCEDURE extraer(IN monto DECIMAL(16,2), IN numero_tarjeta BIGINT, IN codigoATM int)
BEGIN
    DECLARE saldo_actual_caja DECIMAL(16,2);
    DECLARE caja_ahorro int;
    DECLARE titular BIGINT;

    DECLARE codigo_SQL CHAR(5) DEFAULT '00000';
    DECLARE codigo_MYSQL INT DEFAULT 0;
    DECLARE mensaje_error TEXT;  
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
        BEGIN
            GET DIAGNOSTICS CONDITION 1  codigo_MYSQL= MYSQL_ERRNO,  
            codigo_SQL= RETURNED_SQLSTATE, 
            mensaje_error= MESSAGE_TEXT;
            SELECT 'SQLEXCEPTION, transacción abortada' AS resultado, 
            codigo_MySQL, codigo_SQL,  mensaje_error;
            ROLLBACK;
        END;

    START TRANSACTION;

        SELECT nro_ca, nro_cliente INTO caja_ahorro, titular 
        FROM tarjeta 
        WHERE nro_tarjeta = numero_tarjeta;

        SELECT saldo INTO saldo_actual_caja 
        FROM caja_ahorro 
        WHERE nro_ca = caja_ahorro 
        FOR UPDATE;

        IF saldo_actual_caja >= monto  THEN
            UPDATE caja_ahorro 
            SET saldo = saldo - monto 
            WHERE nro_ca = caja_ahorro;

            INSERT INTO transaccion(monto,fecha,hora) 
            VALUES (monto,CURDATE(),CURTIME());

            SET @nro_trans = LAST_INSERT_ID();

            INSERT INTO transaccion_por_caja(nro_trans,cod_caja) 
            VALUES (@nro_trans, codigoATM);

            INSERT INTO extraccion(nro_trans,nro_cliente,nro_ca) 
            VALUES (@nro_trans, titular, caja_ahorro);

            SELECT 'Extraccion Exitosa' AS resultado;
        ELSE
            SELECT 'Saldo insuficiente para realizar la extraccion.' AS resultado;
        END IF;
    COMMIT;
END; !

CREATE PROCEDURE transferir(IN monto DECIMAL(16,2), IN tarjeta BIGINT, IN destino_ca int, IN codigoATM int)
BEGIN
    DECLARE saldo_actual_caja DECIMAL(16,2);
    DECLARE titular BIGINT;
    DECLARE origen_ca int;

    DECLARE codigo_SQL CHAR(5) DEFAULT '00000';
    DECLARE codigo_MYSQL INT DEFAULT 0;
    DECLARE mensaje_error TEXT;  
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
        BEGIN
            GET DIAGNOSTICS CONDITION 1  codigo_MYSQL= MYSQL_ERRNO,  
            codigo_SQL= RETURNED_SQLSTATE, 
            mensaje_error= MESSAGE_TEXT;
            SELECT 'SQLEXCEPTION, transacción abortada' AS resultado, 
            codigo_MySQL, codigo_SQL,  mensaje_error;
            ROLLBACK;
        END;

    START TRANSACTION;
        IF EXISTS (SELECT * FROM caja_ahorro WHERE nro_ca = destino_ca) THEN
            SELECT nro_ca, nro_cliente INTO origen_ca, titular 
            FROM tarjeta 
            WHERE nro_tarjeta = tarjeta;

            SELECT saldo INTO saldo_actual_caja 
            FROM caja_ahorro 
            WHERE nro_ca = origen_ca 
            FOR UPDATE;

            IF saldo_actual_caja >= monto  THEN
                UPDATE caja_ahorro 
                SET saldo = saldo - monto 
                WHERE nro_ca = origen_ca;

                UPDATE caja_ahorro 
                SET saldo = saldo + monto 
                WHERE nro_ca = destino_ca;

                INSERT INTO transaccion(monto,fecha,hora) 
                VALUES (monto,CURDATE(),CURTIME());

                SET @nro_trans = LAST_INSERT_ID();

                INSERT INTO transaccion_por_caja(nro_trans,cod_caja) 
                VALUES (@nro_trans, codigoATM);

                INSERT INTO transferencia(nro_trans,nro_cliente,origen,destino) 
                VALUES (@nro_trans,titular,origen_ca,destino_ca);

                INSERT INTO transaccion(monto,fecha,hora) 
                VALUES (monto,CURDATE(),CURTIME());

                SET @nro_trans = LAST_INSERT_ID();

                INSERT INTO transaccion_por_caja(nro_trans,cod_caja) 
                VALUES (@nro_trans, codigoATM);

                INSERT INTO deposito(nro_trans,nro_ca) 
                VALUES (@nro_trans,destino_ca);

                SELECT 'Transferencia Exitosa' AS resultado;
            ELSE
                SELECT 'Saldo insuficiente para realizar la transferencia.' AS resultado;
            END IF;
        ELSE
            SELECT 'La caja de ahorro destino no existe' AS resultado;
        END IF;
    COMMIT;
END; !

CREATE TRIGGER prestamo_insert
AFTER INSERT ON prestamo
FOR EACH ROW
BEGIN
    DECLARE i int DEFAULT 1;
    WHILE i <= NEW.cant_meses DO
        IF NOT EXISTS (SELECT * FROM pago WHERE nro_prestamo = NEW.nro_prestamo and nro_pago = i) THEN
            INSERT INTO pago(nro_prestamo,nro_pago,fecha_venc,fecha_pago) VALUES (NEW.nro_prestamo, i, DATE_ADD(NEW.fecha, INTERVAL i MONTH),NULL);
        END IF;
        SET i = i + 1;
    END WHILE;
END; !

delimiter ;

CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin';
GRANT ALL PRIVILEGES ON banco.* TO 'admin'@'localhost' WITH GRANT OPTION;

CREATE USER 'empleado'@'%' IDENTIFIED BY 'empleado';
GRANT SELECT, INSERT ON banco.prestamo TO 'empleado'@'%';
GRANT SELECT, INSERT ON banco.plazo_fijo TO 'empleado'@'%';
GRANT SELECT, INSERT ON banco.plazo_cliente TO 'empleado'@'%';
GRANT SELECT, INSERT ON banco.caja_ahorro TO 'empleado'@'%';
GRANT SELECT, INSERT ON banco.tarjeta TO 'empleado'@'%';
GRANT SELECT ON banco.empleado TO 'empleado'@'%';
GRANT SELECT ON banco.sucursal TO 'empleado'@'%';
GRANT SELECT ON banco.tasa_plazo_fijo TO 'empleado'@'%';
GRANT SELECT ON banco.tasa_prestamo TO 'empleado'@'%';

GRANT SELECT, INSERT, UPDATE ON banco.cliente_ca TO 'empleado'@'%';
GRANT SELECT, INSERT, UPDATE ON banco.cliente TO 'empleado'@'%';
GRANT SELECT, INSERT, UPDATE ON banco.pago TO 'empleado'@'%';

CREATE USER 'atm'@'%' IDENTIFIED BY 'atm';
GRANT SELECT, UPDATE ON banco.tarjeta TO 'atm'@'%';
GRANT SELECT ON banco.trans_cajas_ahorro TO 'atm'@'%';
GRANT EXECUTE ON PROCEDURE banco.extraer TO 'atm'@'%';
GRANT EXECUTE ON PROCEDURE banco.transferir TO 'atm'@'%';

FLUSH PRIVILEGES;