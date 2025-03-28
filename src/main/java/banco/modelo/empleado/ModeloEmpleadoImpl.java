package banco.modelo.empleado;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import banco.modelo.ModeloImpl;
import banco.modelo.empleado.beans.ClienteBean;
import banco.modelo.empleado.beans.ClienteMorosoBean;
import banco.modelo.empleado.beans.DAOCliente;
import banco.modelo.empleado.beans.DAOClienteImpl;
import banco.modelo.empleado.beans.DAOClienteMoroso;
import banco.modelo.empleado.beans.DAOClienteMorosoImpl;
import banco.modelo.empleado.beans.DAOEmpleado;
import banco.modelo.empleado.beans.DAOEmpleadoImpl;
import banco.modelo.empleado.beans.DAOPago;
import banco.modelo.empleado.beans.DAOPagoImpl;
import banco.modelo.empleado.beans.DAOPrestamo;
import banco.modelo.empleado.beans.DAOPrestamoImpl;
import banco.modelo.empleado.beans.EmpleadoBean;
import banco.modelo.empleado.beans.PagoBean;
import banco.modelo.empleado.beans.PrestamoBean;

public class ModeloEmpleadoImpl extends ModeloImpl implements ModeloEmpleado {

	private static Logger logger = LoggerFactory.getLogger(ModeloEmpleadoImpl.class);	

	// Indica el usuario actualmente logueado. Null corresponde que todavia no se ha autenticado
	private Integer legajo = null;
	
	public ModeloEmpleadoImpl() {
		logger.debug("Se crea el modelo Empleado.");
	}
	

	@Override
	public boolean autenticarUsuarioAplicacion(String legajo, String password) throws Exception {
		logger.info("Se intenta autenticar el legajo {} con password {}", legajo, password);
		/** 
		 * TODO ✓ Código que autentica que exista un legajo de empleado y que el password corresponda a ese legajo
		 *      (el password guardado en la BD está en MD5) 
		 *      En caso exitoso deberá registrar el legajo en la propiedad legajo y retornar true.
		 *      Si la autenticación no es exitosa porque el legajo no es válido o el password es incorrecto
		 *      deberá retornar falso y si hubo algún otro error deberá producir una excepción.
		 */
		Integer legajoInt = null;		
		try {
			legajoInt = Integer.valueOf(legajo.trim());
			String sql = "SELECT * FROM empleado WHERE legajo = ? AND password = MD5(?)";
			PreparedStatement stmt = this.conexion.prepareStatement(sql);
			stmt.setInt(1, legajoInt);
			stmt.setString(2,password);
			ResultSet rs = stmt.executeQuery();
			if (rs.next()) {
				this.legajo = legajoInt;
				return true;
			}
        }
        catch (Exception ex) {
        	throw new Exception("Se esperaba que el legajo sea un valor entero.");
        }
		return false;
		/*
		 * Datos estáticos de prueba. Quitar y reemplazar por código que recupera los datos reales.  
		 */
		// Se registra el usuario logueado.
		//this.legajo = 1;
		//return true;
		// Fin datos estáticos de prueba.
	}
	
	@Override
	public EmpleadoBean obtenerEmpleadoLogueado() throws Exception {
		logger.info("Solicita al DAO un empleado con legajo {}", this.legajo);
		if (this.legajo == null) {
			logger.info("No hay un empleado logueado.");
			throw new Exception("No hay un empleado logueado. La sesión terminó.");
		}
		
		DAOEmpleado dao = new DAOEmpleadoImpl(this.conexion);
		return dao.recuperarEmpleado(this.legajo);
	}	
	
	@Override
	public ArrayList<String> obtenerTiposDocumento() throws Exception {
		logger.info("recupera los tipos de documentos.");
		/** 
		 * TODO ✓ Debe retornar una lista de strings con los tipos de documentos. 
		 *      Deberia propagar una excepción si hay algún error en la consulta.
		 */
		ArrayList<String> tipos = new ArrayList<String>();
		try {
			String sql = "select tipo_doc from empleado";
			ResultSet rs = consulta(sql);
			while (rs.next()) {
				String tipo_doc = rs.getString("tipo_doc");
				if(!tipos.contains(tipo_doc)) {
					tipos.add(tipo_doc);
				}
			}
			rs.close();
		}catch(Exception e) {
			throw new Exception(e.getMessage());
		}
		/*
		 * Datos estáticos de prueba. Quitar y reemplazar por código que recupera los datos reales.  
		 */
		//ArrayList<String> tipos = new ArrayList<String>();
		//tipos.add("DNI");
		return tipos;
		// Fin datos estáticos de prueba.
	}	

	@Override
	public double obtenerTasa(double monto, int cantidadMeses) throws Exception {

		logger.info("Busca la tasa correspondiente a el monto {} con una cantidad de meses {}", monto, cantidadMeses);

		/** 
		 * TODO ✓ Debe buscar la tasa correspondiente según el monto y la cantidadMeses. 
		 *      Deberia propagar una excepción si hay algún error de conexión o 
		 *      no encuentra el monto dentro del [monto_inf,monto_sup] y la cantidadMeses.
		 */
		try {
			String sql = "SELECT * FROM tasa_prestamo WHERE monto_inf < ? AND monto_sup > ? and periodo = ? ";
			PreparedStatement stmt = this.conexion.prepareStatement(sql);
			stmt.setDouble(1, monto);
			stmt.setDouble(2,monto);
			stmt.setInt(3,cantidadMeses);
			ResultSet rs = stmt.executeQuery();
			if (rs.next()) {
				return rs.getDouble("tasa");
			}else {
				throw new Exception("El Monto o la cantidad de Meses no es válido.");
			}
		}catch(SQLException e) {
			throw new SQLException(e.getMessage());
		}
		/*
		 * Datos estáticos de prueba. Quitar y reemplazar por código que recupera los datos reales.  
		 */
		//double tasa = 23.00;
   		//return tasa;
     	// Fin datos estáticos de prueba.
	}

	@Override
	public double obtenerInteres(double monto, double tasa, int cantidadMeses) {
		return (monto * tasa * cantidadMeses) / 1200;
	}


	@Override
	public double obtenerValorCuota(double monto, double interes, int cantidadMeses) {
		return (monto + interes) / cantidadMeses;
	}
		

	@Override
	public ClienteBean recuperarCliente(String tipoDoc, int nroDoc) throws Exception {
		DAOCliente dao = new DAOClienteImpl(this.conexion);
		return dao.recuperarCliente(tipoDoc, nroDoc);
	}


	@Override
	public ArrayList<Integer> obtenerCantidadMeses(double monto) throws Exception {
		logger.info("recupera los períodos (cantidad de meses) según el monto {} para el prestamo.", monto);

		/** 
		 * TODO ✓ Debe buscar los períodos disponibles según el monto. 
		 *      Deberia propagar una excepción si hay algún error de conexión o 
		 *      no encuentra el monto dentro del [monto_inf,monto_sup].
		 */
		
		/*
		 * Datos estáticos de prueba. Quitar y reemplazar por código que recupera los datos reales.  
		 */		
		ArrayList<Integer> cantMeses = new ArrayList<Integer>();
		try {
			String sql = "SELECT periodo FROM tasa_prestamo WHERE monto_inf < ? AND monto_sup > ?";
			PreparedStatement stmt = this.conexion.prepareStatement(sql);
			stmt.setDouble(1, monto);
			stmt.setDouble(2, monto);
			ResultSet rs = stmt.executeQuery();
			while (rs.next()) {
				int cant = rs.getInt("periodo");
				if(!cantMeses.contains(cant)) {
					cantMeses.add(cant);
				}
			}
		}catch(SQLException e) {
			throw new SQLException(e.getMessage());
		}
		//cantMeses.add(9);
		//cantMeses.add(18);
		//cantMeses.add(27);
//		cantMeses.add(54);
//		cantMeses.add(108);
		if(cantMeses.size() == 0) {
			throw new Exception("El monto no pertenece al rango valido de la tasa de prestamo.");
		}
		return cantMeses;
		// Fin datos estáticos de prueba.
	}

	@Override	
	public Integer prestamoVigente(int nroCliente) throws Exception 
	{
		logger.info("Verifica si el cliente {} tiene algun prestamo que tienen cuotas por pagar.", nroCliente);

		/** 
		 * TODO ✓ Busca algún prestamo del cliente que tenga cuotas sin pagar (vigente) retornando el nro_prestamo
		 *      si no existe prestamo del cliente o todos están pagos retorna null.
		 *      Si hay una excepción la propaga con un mensaje apropiado.
		 */
		try {
			String sql = "SELECT DISTINCT nro_prestamo FROM prestamo NATURAL JOIN pago WHERE nro_cliente = ? AND fecha_pago is null";
			PreparedStatement stmt = this.conexion.prepareStatement(sql);
			stmt.setInt(1, nroCliente);
			ResultSet rs = stmt.executeQuery();
			if (rs.next()) {
				return rs.getInt("nro_prestamo");
			}else {
				return null;
			}
		}catch(SQLException e) {
			throw new SQLException(e.getMessage());
		}
		/*
		 * Datos estáticos de prueba. Quitar y reemplazar por código que recupera los datos reales.  
		 */
		//return 1;
		// Fin datos estáticos de prueba.
	}


	@Override
	public void crearPrestamo(PrestamoBean prestamo) throws Exception {
		logger.info("Crea un nuevo prestamo.");
		
		if (this.legajo == null) {
			throw new Exception("No hay un empleado registrado en el sistema que se haga responsable por este prestamo.");
		}
		else 
		{
			logger.info("Actualiza el prestamo con el legajo {}",this.legajo);
			prestamo.setLegajo(this.legajo);
			
			DAOPrestamo dao = new DAOPrestamoImpl(this.conexion);		
			dao.crearPrestamo(prestamo);
		}
	}
	
	@Override
	public PrestamoBean recuperarPrestamo(int nroPrestamo) throws Exception {
		logger.info("Busca el prestamo número {}", nroPrestamo);
		
		DAOPrestamo dao = new DAOPrestamoImpl(this.conexion);		
		return dao.recuperarPrestamo(nroPrestamo);
	}
	
	@Override
	public ArrayList<PagoBean> recuperarPagos(Integer prestamo) throws Exception {
		logger.info("Solicita la busqueda de pagos al modelo sobre el prestamo {}.", prestamo);
		
		DAOPago dao = new DAOPagoImpl(this.conexion);		
		return dao.recuperarPagos(prestamo);
	}
	

	@Override
	public void pagarCuotas(String p_tipo, int p_dni, int nroPrestamo, List<Integer> cuotasAPagar) throws Exception {
		
		// Valida que sea un cliente que exista sino genera una excepción
		ClienteBean c = this.recuperarCliente(p_tipo.trim(), p_dni);

		// Valida el prestamo
		if (nroPrestamo != this.prestamoVigente(c.getNroCliente())) {
			throw new Exception ("El nro del prestamo no coincide con un prestamo vigente del cliente");
		}

		if (cuotasAPagar.size() == 0) {
			throw new Exception ("Debe seleccionar al menos una cuota a pagar.");
		}
		
		DAOPago dao = new DAOPagoImpl(this.conexion);
		dao.registrarPagos(nroPrestamo, cuotasAPagar);		
	}


	@Override
	public ArrayList<ClienteMorosoBean> recuperarClientesMorosos() throws Exception {
		logger.info("Modelo solicita al DAO que busque los clientes morosos");
		DAOClienteMoroso dao = new DAOClienteMorosoImpl(this.conexion);
		return dao.recuperarClientesMorosos();	
	}
	

	
}
