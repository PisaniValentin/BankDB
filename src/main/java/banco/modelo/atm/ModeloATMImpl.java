package banco.modelo.atm;

import java.io.FileInputStream;
import java.security.MessageDigest;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Properties;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import banco.modelo.ModeloImpl;
import banco.modelo.empleado.beans.PrestamoBeanImpl;
import banco.utils.Conexion;
import banco.utils.Fechas;


public class ModeloATMImpl extends ModeloImpl implements ModeloATM {

	private static Logger logger = LoggerFactory.getLogger(ModeloATMImpl.class);	

	private String tarjeta = null;   // mantiene la tarjeta del cliente actual
	private Integer codigoATM = null;

	/*
	 * La información del cajero ATM se recupera del archivo que se encuentra definido en ModeloATM.CONFIG
	 */
	public ModeloATMImpl() {
		logger.debug("Se crea el modelo ATM.");

		logger.debug("Recuperación de la información sobre el cajero");

		Properties prop = new Properties();
		try (FileInputStream file = new FileInputStream(ModeloATM.CONFIG))
		{
			logger.debug("Se intenta leer el archivo de propiedades {}",ModeloATM.CONFIG);
			prop.load(file);

			codigoATM = Integer.valueOf(prop.getProperty("atm.codigo.cajero"));

			logger.debug("Código cajero ATM: {}", codigoATM);
		}
		catch(Exception ex)
		{
			logger.error("Se produjo un error al recuperar el archivo de propiedades {}.",ModeloATM.CONFIG); 
		}
		return;
	}

	public boolean autenticarUsuarioAplicacion(String tarjeta, String pin) throws Exception {
		logger.info("Se intenta autenticar la tarjeta {} con pin {}", tarjeta, pin);
		PreparedStatement ps;
		try {
			// Convertir el PIN ingresado por el usuario a MD5
			String sql = "SELECT * FROM tarjeta WHERE nro_tarjeta = ? AND PIN = MD5(?)";
			ps = this.conexion.prepareStatement(sql);
			ps.setLong(1, Long.parseLong(tarjeta));
			ps.setString(2,pin);
			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				this.tarjeta=tarjeta;
				return true;
			}
		} catch (SQLException e) {
			logger.error("Error al obtener el pin de la tarjeta: {}", e.getMessage());
			throw new Exception("Error al obtener el pin de la tarjeta. Intente más tarde.");
		}
		Conexion.closePreparedStatement(ps);
		return false;
	}

	@Override
	public Double obtenerSaldo() throws Exception{
		logger.info("Se intenta obtener el saldo de cliente {}", 3);
		java.sql.Statement stmt = this.conexion.createStatement();
		java.sql.ResultSet rs=null;
		if (this.tarjeta == null ) {
			throw new Exception("El cliente no ingresó la tarjeta");
		}
		try {
			String sql = "SELECT saldo " +
					"FROM trans_cajas_ahorro tc " +
					"JOIN tarjeta t ON tc.nro_ca = t.nro_ca " +
					"WHERE t.nro_tarjeta =  " + this.tarjeta;
			rs = this.consulta(sql);
			if (rs.next()) {
				// Recupera el saldo
				Double saldo = rs.getDouble("saldo");
				logger.info("Saldo recuperado: {}", saldo);
				return saldo;
			} else {throw new Exception("No se encontró una cuenta asociada a la tarjeta.");}
		}catch (SQLException e) {
			logger.error("Error al obtener el saldo: {}", e.getMessage());
			throw new Exception("Error al obtener el saldo del cliente. Intente más tarde.");
		}finally {
			// Cierre de recursos en orden inverso
			Conexion.closeResultset(rs);
			Conexion.closeStatement(stmt);
		}
	}	

	@Override
	public ArrayList<TransaccionCajaAhorroBean> cargarUltimosMovimientos() throws Exception {
		return this.cargarUltimosMovimientos(ModeloATM.ULTIMOS_MOVIMIENTOS_CANTIDAD);
	}	

	@Override
	public ArrayList<TransaccionCajaAhorroBean> cargarUltimosMovimientos(int cantidad) throws Exception {
		logger.info("Busca las ultimas {} transacciones en la BD de la tarjeta {}", cantidad, this.tarjeta);
		PreparedStatement ps=null;
		ResultSet rs=null;
		if (this.tarjeta == null) {
			throw new Exception("No se ha ingresado ninguna tarjeta.");
		}
		ArrayList<TransaccionCajaAhorroBean> lista = new ArrayList<TransaccionCajaAhorroBean>();
		try {	
			// Consulta para obtener las transacciones desde la vista trans_cajas_ahorro
			String query = "SELECT tc.nro_trans, tc.fecha, tc.hora, tc.monto, tc.Tipo, tc.cod_caja, tc.destino " +
					"FROM trans_cajas_ahorro tc " +
					"JOIN tarjeta t ON tc.nro_ca = t.nro_ca " +
					"WHERE t.nro_tarjeta = ? " +
					"ORDER BY tc.fecha DESC, tc.hora DESC " +
					"LIMIT ?";

			ps = conexion.prepareStatement(query);
			ps.setLong(1, Long.parseLong(this.tarjeta));  // Parámetro de la tarjeta
			ps.setInt(2, cantidad);  // Parámetro de la cantidad de transacciones
			rs = ps.executeQuery();

			while (rs.next()) {
				TransaccionCajaAhorroBean trans = new TransaccionCajaAhorroBeanImpl();
				//Le doy un formato especifico para unir los string fecha y hora en uno solo
				Date fecha = rs.getDate("fecha");
				Time hora = rs.getTime("hora");
				//Converti la fecha y la hora usando la clase Fechas
				String fechaS = Fechas.convertirDateAStringDB(fecha);
				String horaS = (hora != null) ? Fechas.convertirDateAHoraString(hora) : "00:00:00"; //Si no hay hora, usamos 00:00:00
				//Uni fecha y hora usando Fechas
				Date fh = Fechas.convertirStringADate(fechaS, horaS);

				trans.setTransaccionFechaHora(fh);
				String type= rs.getString("tipo");
				trans.setTransaccionTipo(type);
				double valor = rs.getDouble("monto");
				if ("Extraccion".equals(type) || "Transferencia".equals(type) || "Debito".equals(type)) {
					valor = -valor;
				}
				trans.setTransaccionMonto(valor);
				trans.setTransaccionCodigoCaja(rs.getInt("cod_caja"));
				if (rs.getObject("destino") != null) {
					trans.setCajaAhorroDestinoNumero(rs.getInt("destino"));//puede ser nulo
				}
				lista.add(trans);
			}
			Conexion.closeResultset(rs);
			Conexion.closePreparedStatement(ps);
			return lista;
		} catch (SQLException ex) {
			logger.error("SQLException: " + ex.getMessage());
			logger.error("SQLState: " + ex.getSQLState());
			logger.error("VendorError: " + ex.getErrorCode());
			throw new Exception("Error en la conexión con la BD.");
		}
	}


	@Override
	public ArrayList<TransaccionCajaAhorroBean> cargarMovimientosPorPeriodo(Date desde, Date hasta)
			throws Exception {
		PreparedStatement ps=null;
		ResultSet rs=null;
		if (desde == null) {
			throw new Exception("El inicio del período no puede estar vacío");
		}
		if (hasta == null) {
			throw new Exception("El fin del período no puede estar vacío");
		}
		if (desde.after(hasta)) {
			throw new Exception("El inicio del período no puede ser posterior al fin del período");
		}	

		Date fechaActual = new Date();
		if (desde.after(fechaActual)) {
			throw new Exception("El inicio del período no puede ser posterior a la fecha actual");
		}
		if (hasta.after(fechaActual)) {
			throw new Exception("El fin del período no puede ser posterior a la fecha actual");
		}

		ArrayList<TransaccionCajaAhorroBean> lista = new ArrayList<TransaccionCajaAhorroBean>();
		try {
			// Convertimos las fechas a string
			String fechaDesde = Fechas.convertirDateAStringDB(desde);
			String fechaHasta = Fechas.convertirDateAStringDB(hasta);
			String query = "SELECT tc.nro_trans, tc.fecha, tc.hora, tc.monto, tc.Tipo, tc.cod_caja, tc.destino " +
					"FROM trans_cajas_ahorro tc " +
					"JOIN tarjeta t ON tc.nro_ca = t.nro_ca " +
					"WHERE t.nro_tarjeta = ? " +
					"AND fecha BETWEEN ? AND ? " +
					"ORDER BY fecha DESC, hora DESC ";
			ps = conexion.prepareStatement(query);
			ps.setLong(1, Long.parseLong(this.tarjeta));  // Parámetro de la tarjeta
			ps.setString(2, fechaDesde);
			ps.setString(3, fechaHasta);
			rs = ps.executeQuery();
			while (rs.next()) {
				TransaccionCajaAhorroBean trans = new TransaccionCajaAhorroBeanImpl();
				//Le doy un formato especifico para unir los string fecha y hora en uno solo
				Date fecha = rs.getDate("fecha");
				Time hora = rs.getTime("hora");
				//Converti la fecha y la hora usando la clase Fechas
				String fechaS = Fechas.convertirDateAStringDB(fecha);
				String horaS = (hora != null) ? Fechas.convertirDateAHoraString(hora) : "00:00:00"; //Si no hay hora, usamos 00:00:00
				//Uni fecha y hora usando Fechas
				Date fh = Fechas.convertirStringADate(fechaS, horaS);

				trans.setTransaccionFechaHora(fh);
				String type= rs.getString("tipo");
				double valor = rs.getDouble("monto");
				if ("Extraccion".equals(type) || "Transferencia".equals(type) || "Debito".equals(type)) {
					valor = -valor;
				}
				trans.setTransaccionTipo(type);
				trans.setTransaccionMonto(valor);
				trans.setTransaccionCodigoCaja(rs.getInt("cod_caja"));
				if (rs.getObject("destino") != null) {
					trans.setCajaAhorroDestinoNumero(rs.getInt("destino"));//puede ser nulo
				}
				lista.add(trans);
			}
			Conexion.closeResultset(rs);
			Conexion.closePreparedStatement(ps);
			return lista;	        
		} catch (SQLException ex) {
			logger.error("SQLException: " + ex.getMessage());
			logger.error("SQLState: " + ex.getSQLState());
			logger.error("VendorError: " + ex.getErrorCode());
			throw new Exception("Error en la conexión con la BD.");
		}
	}

	@Override
	public Double extraer(Double monto) throws Exception {
		logger.info("Realiza la extraccion de ${} sobre la cuenta", monto);
		
		if (this.codigoATM == null) {
			throw new Exception("Hubo un error al recuperar la información sobre el ATM.");
		}
		if (this.tarjeta == null) {
			throw new Exception("Hubo un error al recuperar la información sobre la tarjeta del cliente.");
		}
		/**
		 * TODO Deberá extraer de la cuenta del cliente el monto especificado (ya validado) y 
		 * 		obtener el saldo de la cuenta como resultado.
		 * 		Debe capturar la excepción SQLException y propagar una Exception más amigable. 		 * 		
		 */		

		//String resultado = ModeloATM.EXTRACCION_EXITOSA;
		try {
			String sql = "{CALL extraer(?,?,?)}";
			CallableStatement stmt = this.conexion.prepareCall(sql);
			stmt.setDouble(1, monto);
			stmt.setLong(2, Long.parseLong(this.tarjeta));
			stmt.setInt(3, this.codigoATM);
			ResultSet rs = stmt.executeQuery();
			if(rs.next()) {
				String resultado = rs.getString("resultado");
				rs.close();
				stmt.close();
				if (!resultado.equals(ModeloATM.EXTRACCION_EXITOSA)) {
					throw new Exception(resultado);
				}
			}
		}catch(java.sql.SQLException e) {
			throw new SQLException("Hubo un error al realizar la extraccion.");
		}


//		if (!resultado.equals(ModeloATM.EXTRACCION_EXITOSA)) {
//			throw new Exception(resultado);
//		}
		return this.obtenerSaldo();

	}


		@Override
		public int parseCuenta(String p_cuenta) throws Exception {
			logger.info("Intenta realizar el parsing de un codigo de cuenta {}", p_cuenta);
			PreparedStatement ps;
			ResultSet rs;
			if (p_cuenta == null) {
				throw new Exception("El código de la cuenta no puede ser vacío");
			}
			int numeroCuenta;
			try {
				numeroCuenta = Integer.parseInt(p_cuenta);
				if (numeroCuenta < 0) {
					throw new Exception("El código de la cuenta no puede ser negativo");
				}
			} catch (NumberFormatException e) {
				throw new Exception("El código de la cuenta no es un número válido", e);
			}

			// Verificar si la cuenta existe en la base de datos
			try {
				String query = "SELECT nro_ca FROM trans_cajas_ahorro WHERE nro_ca = ?";
				ps= conexion.prepareStatement(query);
				ps.setInt(1, numeroCuenta);
				rs= ps.executeQuery();

				// Verificar si la cuenta existe
				if (rs.next()) {
					logger.info("Encontró la cuenta en la BD.");
					return numeroCuenta;
				}else {
					throw new Exception("El código de la cuenta no existe en la base de datos");
				}
			} catch (SQLException ex) {
				logger.error("SQLException: " + ex.getMessage());
				logger.error("SQLState: " + ex.getSQLState());
				logger.error("VendorError: " + ex.getErrorCode());
				throw new Exception("Error al verificar la cuenta en la base de datos.", ex);
			}
//			return numeroCuenta;  // Retorna el código de cuenta en formato int
		}


		@Override
		public Double transferir(Double monto, int cajaDestino) throws Exception {
			logger.info("Realiza la transferencia de ${} sobre a la cuenta {}", monto, cajaDestino);

			if (this.codigoATM == null) {
				throw new Exception("Hubo un error al recuperar la información sobre el ATM.");
			}
			if (this.tarjeta == null) {
				throw new Exception("Hubo un error al recuperar la información sobre la tarjeta del cliente.");
			}

			/**
			 * TODO Deberá extraer de la cuenta del cliente el monto especificado (ya fue validado) y
			 * 		de obtener el saldo de la cuenta como resultado.
			 * 		Debe capturar la excepción SQLException y propagar una Exception más amigable. 
			 */		

			try {
				String sql = "{CALL transferir(?,?,?,?)}";
				CallableStatement stmt = this.conexion.prepareCall(sql);
				stmt.setDouble(1, monto);
				stmt.setLong(2, Long.parseLong(this.tarjeta));
				stmt.setInt(3, cajaDestino);
				stmt.setInt(4, this.codigoATM);
				ResultSet rs = stmt.executeQuery();
				if(rs.next()) {
					String resultado = rs.getString("resultado");
					rs.close();
					stmt.close();
					if (!resultado.equals(ModeloATM.TRANSFERENCIA_EXITOSA)) {
						throw new Exception(resultado);
					}
				}
			}catch(java.sql.SQLException e) {
				throw new SQLException("Hubo un error al realizar la transferencia.");
			}

			//			String resultado = ModeloATM.TRANSFERENCIA_EXITOSA;

			//			if (!resultado.equals(ModeloATM.TRANSFERENCIA_EXITOSA)) {
			//				throw new Exception(resultado);
			//			}
			return this.obtenerSaldo();
		}


		@Override
		public Double parseMonto(String p_monto) throws Exception {

			logger.info("Intenta realizar el parsing del monto {}", p_monto);

			if (p_monto == null) {
				throw new Exception("El monto no puede estar vacío");
			}

			try 
			{
				double monto = Double.parseDouble(p_monto);
				DecimalFormat df = new DecimalFormat("#.00");

				monto = Double.parseDouble(corregirComa(df.format(monto)));

				if(monto < 0)
				{
					throw new Exception("El monto no debe ser negativo.");
				}

				return monto;
			}		
			catch (NumberFormatException e)
			{
				throw new Exception("El monto no tiene un formato válido.");
			}	
		}

		private String corregirComa(String n)
		{
			String toReturn = "";

			for(int i = 0;i<n.length();i++)
			{
				if(n.charAt(i)==',')
				{
					toReturn = toReturn + ".";
				}
				else
				{
					toReturn = toReturn+n.charAt(i);
				}
			}

			return toReturn;
		}	




	}
