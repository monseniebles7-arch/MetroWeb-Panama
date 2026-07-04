import java.sql.Connection;
import java.sql.DriverManager;

/**
 * Clase utilitaria para obtener una conexión a la base de datos MetroWeb.
 * Se reutiliza en todos los servlets que necesiten acceder a la BD,
 * en lugar de repetir el código de conexión en cada archivo.
 */
public class Conexion {

<<<<<<< HEAD
    private static final String URL = "jdbc:mysql://localhost:3306/Metrowebpanama2";
=======
    private static final String URL = "jdbc:mysql://localhost:3306/metroweb";
>>>>>>> 620432fbf01abe7ffd0cdcf3f2172ea29323019a
    private static final String USUARIO = "root";
    private static final String PASSWORD = "";

    public static Connection obtenerConexion() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USUARIO, PASSWORD);
    }
}