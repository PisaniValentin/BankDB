package banco.modelo.empleado.beans;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Date;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import banco.utils.Fechas;

public class DAOPrestamoImpl implements DAOPrestamo {

	private static Logger logger = LoggerFactory.getLogger(DAOPrestamoImpl.class);
	
	private Connection conexion;
	
	public DAOPrestamoImpl(Connection c) {
		this.conexion = c;
	}
	
	
	@Override
	public void crearPrestamo(PrestamoBean prestamo) throws Exception {

		logger.info("Creación o actualizacion del prestamo.");
		logger.debug("meses : {}", prestamo.getCantidadMeses());
		logger.debug("monto : {}", prestamo.getMonto());
		logger.debug("tasa : {}", prestamo.getTasaInteres());
		logger.debug("interes : {}", prestamo.getInteres());
		logger.debug("cuota : {}", prestamo.getValorCuota());
		logger.debug("legajo : {}", prestamo.getLegajo());
		logger.debug("cliente : {}", prestamo.getNroCliente());
		
		/**   
		 * TODO ✓ Crear un Prestamo segun el PrestamoBean prestamo. 
		 *    
		 * 
		 * @throws Exception deberá propagar la excepción si ocurre alguna. Puede capturarla para loguear los errores, ej.
		 *				logger.error("SQLException: " + ex.getMessage());
		 * 				logger.error("SQLState: " + ex.getSQLState());
		 *				logger.error("VendorError: " + ex.getErrorCode());
		 *		   pero luego deberá propagarla para que se encargue el controlador. 
		 */
		try {
			String sql = "INSERT INTO prestamo (cant_meses, fecha, tasa_interes, interes, monto, valor_cuota, legajo, nro_cliente) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
			PreparedStatement stmt = this.conexion.prepareStatement(sql);
			stmt.setInt(1, prestamo.getCantidadMeses());
			Date fechaActual = new Date();
			stmt.setDate(2, Fechas.convertirDateADateSQL(fechaActual));
			stmt.setDouble(3, prestamo.getTasaInteres());
			stmt.setDouble(4, prestamo.getInteres());
			stmt.setDouble(5, prestamo.getMonto());
			Double valorCuota = (prestamo.getMonto() + prestamo.getInteres()) / prestamo.getCantidadMeses();
			stmt.setDouble(6, valorCuota);
			stmt.setInt(7, prestamo.getLegajo());
			stmt.setInt(8, prestamo.getNroCliente());
			
			stmt.execute();
			stmt.close();
		}catch(java.sql.SQLException ex){
			logger.error("SQLException: " + ex.getMessage());
			logger.error("SQLState: " + ex.getSQLState());
			logger.error("VendorError: " + ex.getErrorCode());
			throw new SQLException(ex.getMessage());
		}

	}

	@Override
	public PrestamoBean recuperarPrestamo(int nroPrestamo) throws Exception {
		logger.info("Recupera el prestamo nro {}.", nroPrestamo);
		PrestamoBean prestamo = null;
		try {
			String sql = "select * from prestamo where nro_prestamo = ?";
			PreparedStatement stmt = this.conexion.prepareStatement(sql);
			stmt.setInt(1, nroPrestamo);
			ResultSet rs = stmt.executeQuery();
			if(rs.next()) {
				prestamo = new PrestamoBeanImpl();
				prestamo.setNroPrestamo(rs.getInt("nro_prestamo"));
				prestamo.setFecha(rs.getDate("fecha"));
				prestamo.setCantidadMeses(rs.getInt("cant_meses"));
				prestamo.setMonto(rs.getDouble("monto"));
				prestamo.setTasaInteres(rs.getDouble("tasa_interes"));
				prestamo.setInteres(rs.getDouble("interes"));
				prestamo.setValorCuota(rs.getDouble("valor_cuota"));
				prestamo.setLegajo(rs.getInt("legajo"));
				prestamo.setNroCliente(rs.getInt("nro_cliente"));
				rs.close();
				stmt.close();
				return prestamo;
			}
		}catch(java.sql.SQLException e) {
			throw new Exception("Error al obtener el prestamo. Intente más tarde.");		
		}	
		return prestamo;
		/**
		 * TODO ✓ Obtiene el prestamo según el id nroPrestamo
		 * 
		 * @param nroPrestamo
		 * @return Un prestamo que corresponde a ese id o null
		 * @throws Exception si hubo algun problema de conexión
		 */

		/*
		 * Datos estáticos de prueba. Quitar y reemplazar por código que recupera los datos reales.  
		 * Retorna un PretamoBean con información del prestamo nro 4
		 */
		/*
		PrestamoBean prestamo = null;
			
		prestamo = new PrestamoBeanImpl();
		prestamo.setNroPrestamo(4);
		prestamo.setFecha(Fechas.convertirStringADate("2021-04-05"));
		prestamo.setCantidadMeses(6);
		prestamo.setMonto(20000);
		prestamo.setTasaInteres(24);
		prestamo.setInteres(2400);
		prestamo.setValorCuota(3733.33);
		prestamo.setLegajo(2);
		prestamo.setNroCliente(2);
		return prestamo;
		 */
		// Fin datos estáticos de prueba.
	}

}
