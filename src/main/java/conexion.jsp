import java.sql.Connection;
import java.sql.DriverManager;

/**
 * Clase utilitaria para obtener una conexión a la base de datos MetroWeb.
 * Se reutiliza en todos los servlets que necesiten acceder a la BD,
 * en lugar de repetir el código de conexión en cada archivo.
 */
public class Conexion {

    private static final String URL = "jdbc:mysql://localhost:3306/MetroWebPanama";
    private static final String USUARIO = "root";
    private static final String PASSWORD = "";

    public static Connection obtenerConexion() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USUARIO, PASSWORD);
    }
}