import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Servlet que procesa el formulario de inicio de sesión.
 * Verifica el correo y la contraseña contra la base de datos,
 * y según el rol del usuario (Usuario / Administrador) guarda
 * el valor correspondiente en la sesión y redirige a la página
 * de inicio que le corresponde.
 *
 * IMPORTANTE: el formulario de login (en home.jsp) debe enviar
 * los campos con name="correo" y name="contrasena", con method="post"
 * y action="LoginServlet".
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String correo = request.getParameter("correo");
        String contrasena = request.getParameter("contrasena");

        String sql = "SELECT u.id_usuario, u.nombre, u.hash_contrasena, r.nombre_rol " +
                     "FROM Usuario u " +
                     "JOIN Rol r ON u.id_rol = r.id_rol " +
                     "WHERE u.correo = ?";

        try (Connection cn = Conexion.obtenerConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, correo);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    String hashGuardado = rs.getString("hash_contrasena");

                    // Compara la contraseña ingresada contra el hash guardado en la BD
                    if (BCrypt.checkpw(contrasena, hashGuardado)) {

                        HttpSession session = request.getSession();
                        session.setAttribute("idUsuario", rs.getInt("id_usuario"));
                        session.setAttribute("nombreUsuario", rs.getString("nombre"));

                        String nombreRol = rs.getString("nombre_rol");

                        if ("Administrador".equalsIgnoreCase(nombreRol)) {
                            session.setAttribute("rol", "admin");
                            response.sendRedirect(request.getContextPath() + "/admin_inicio.jsp");
                        } else {
                            session.setAttribute("rol", "usuario");
                            response.sendRedirect(request.getContextPath() + "/usuario_inicio.jsp");
                        }

                    } else {
                        mostrarError(request, response, "Correo o contraseña incorrectos");
                    }

                } else {
                    mostrarError(request, response, "Correo o contraseña incorrectos");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            mostrarError(request, response, "Ocurrió un error al iniciar sesión. Intenta de nuevo.");
        }
    }

    private void mostrarError(HttpServletRequest request, HttpServletResponse response, String mensaje)
            throws ServletException, IOException {
        request.setAttribute("error", mensaje);
        request.getRequestDispatcher("home.jsp").forward(request, response);
    }
}