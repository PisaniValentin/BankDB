package banco.modelo.empleado.beans;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DAOEmpleadoImpl implements DAOEmpleado {

	private static Logger logger = LoggerFactory.getLogger(DAOEmpleadoImpl.class);
	
	private Connection conexion;
	
	public DAOEmpleadoImpl(Connection c) {
		this.conexion = c;
	}


	@Override
	public EmpleadoBean recuperarEmpleado(int legajo) throws Exception {
		logger.info("recupera el empleado que corresponde al legajo {}.", legajo);
		
		/**
		 * TODO ✓ Debe recuperar los datos del empleado que corresponda al legajo pasado como parámetro.
		 *      Si no existe deberá retornar null y 
		 *      De ocurre algun error deberá generar una excepción.		 * 
		 */		
		
		/*
		 * Datos estáticos de prueba. Quitar y reemplazar por código que recupera los datos reales.  
		 */
		
		EmpleadoBean empleado = null;
		
		try {
			String sql = "SELECT * FROM empleado WHERE legajo = ?";
			PreparedStatement stmt = this.conexion.prepareStatement(sql);
			stmt.setInt(1, legajo);
			ResultSet rs = stmt.executeQuery();
			if (rs.next()) {
				empleado = new EmpleadoBeanImpl();
				empleado.setLegajo(rs.getInt("legajo"));
				empleado.setApellido(rs.getString("apellido"));
				empleado.setNombre(rs.getString("nombre"));
				empleado.setTipoDocumento(rs.getString("tipo_doc"));
				empleado.setNroDocumento(rs.getInt("nro_doc"));
				empleado.setDireccion(rs.getString("direccion"));
				empleado.setTelefono(rs.getString("telefono"));
				empleado.setCargo(rs.getString("cargo"));
				empleado.setPassword(rs.getString("password")); // select md5(9);
				empleado.setNroSucursal(rs.getInt("nro_suc"));
			}
			rs.close();
			stmt.close();
		}catch(SQLException e) {
			throw new SQLException(e.getMessage());
		}
		
//		empleado = new EmpleadoBeanImpl();
//		empleado.setLegajo(9);
//		empleado.setApellido("ApEmp9");
//		empleado.setNombre("NomEmp9");
//		empleado.setTipoDocumento("DNI");
//		empleado.setNroDocumento(9);
//		empleado.setDireccion("DirEmp9");
//		empleado.setTelefono("999-9999");
//		empleado.setCargo("Empleado de Prestamos");
//		empleado.setPassword("45c48cce2e2d7fbdea1afc51c7c6ad26"); // select md5(9);
//		empleado.setNroSucursal(7);
		
		return empleado;
		// Fin datos estáticos de prueba.
	}

}
