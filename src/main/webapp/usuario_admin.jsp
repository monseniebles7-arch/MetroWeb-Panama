<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>

<%
    // ==========================================================================
    // PARTE 1: VERIFICACIÓN DEL ID Y CONFIGURACIÓN INICIAL
    // ==========================================================================
    String idParam = request.getParameter("id");
    
    // Si no viene un ID válido, devolvemos al admin a la tabla de gestión
    if (idParam == null || idParam.trim().isEmpty()) {
        response.sendRedirect("gestion_usuarios.jsp");
        return;
    }

    String mensajeAlerta = null;
    boolean esExito = false;

    // Variables para almacenar la información actual del usuario de la BD
    String nombre = "";
    String apellido = "";
    String correo = "";

    // ==========================================================================
    // PARTE 2: PROCESAMIENTO DE LA EDICIÓN (CUANDO SE HACE CLIC EN GUARDAR)
    // ==========================================================================
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        request.setCharacterEncoding("UTF-8");
        String txtNombre = request.getParameter("nombre");
        String txtApellido = request.getParameter("apellido");
        String txtCorreo = request.getParameter("correo");
        String txtContrasena = request.getParameter("contrasena");

        Connection cn = null;
        PreparedStatement psUpdate = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/metrowebpanama2", "root", "");

            // Evaluamos si el administrador ingresó o no una nueva contraseña
            if (txtContrasena != null && !txtContrasena.trim().isEmpty()) {
                // Si escribió algo, validamos la longitud, la hasheamos y actualizamos todo
                if (txtContrasena.length() < 8) {
                    mensajeAlerta = "❌ La nueva contraseña debe tener al menos 8 caracteres.";
                } else {
                    String contrasenaHasheada = BCrypt.hashpw(txtContrasena, BCrypt.gensalt(12));
                    String sqlUpdate = "UPDATE Usuario SET nombre = ?, apellido = ?, correo = ?, hash_contrasena = ? WHERE id_usuario = ?";
                    psUpdate = cn.prepareStatement(sqlUpdate);
                    psUpdate.setString(1, txtNombre.trim());
                    psUpdate.setString(2, txtApellido.trim());
                    psUpdate.setString(3, txtCorreo.trim());
                    psUpdate.setString(4, contrasenaHasheada);
                    psUpdate.setInt(5, Integer.parseInt(idParam));
                    psUpdate.executeUpdate();
                    esExito = true;
                }
            } else {
                // Si se dejó vacía, actualizamos únicamente los datos básicos sin tocar el hash anterior
                String sqlUpdate = "UPDATE Usuario SET nombre = ?, apellido = ?, correo = ? WHERE id_usuario = ?";
                psUpdate = cn.prepareStatement(sqlUpdate);
                psUpdate.setString(1, txtNombre.trim());
                psUpdate.setString(2, txtApellido.trim());
                psUpdate.setString(3, txtCorreo.trim());
                psUpdate.setInt(4, Integer.parseInt(idParam));
                psUpdate.executeUpdate();
                esExito = true;
            }
        } catch (Exception e) {
            mensajeAlerta = "⚠️ Error al actualizar el registro: " + e.getMessage();
        } finally {
            if (psUpdate != null) try { psUpdate.close(); } catch(Exception e){}
            if (cn != null) try { cn.close(); } catch(Exception e){}
        }

        // Redirección exitosa hacia la tabla de control
        if (esExito) {
            response.sendRedirect("gestion_usuarios.jsp");
            return;
        }
    }

    // ==========================================================================
    // PARTE 3: PRECARGA DE DATOS EXISTENTES EN PANTALLA (MÉTODO GET)
    // ==========================================================================
    Connection cnSelect = null;
    PreparedStatement psSelect = null;
    ResultSet rsSelect = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        cnSelect = DriverManager.getConnection("jdbc:mysql://localhost:3306/metrowebpanama2", "root", "");

        String sqlSelect = "SELECT nombre, apellido, correo FROM Usuario WHERE id_usuario = ?";
        psSelect = cnSelect.prepareStatement(sqlSelect);
        psSelect.setInt(1, Integer.parseInt(idParam));
        rsSelect = psSelect.executeQuery();

        if (rsSelect.next()) {
            nombre = rsSelect.getString("nombre");
            apellido = rsSelect.getString("apellido");
            correo = rsSelect.getString("correo");
        } else {
            // Si el ID ingresado manualmente en la URL no existe
            response.sendRedirect("gestion_usuarios.jsp");
            return;
        }
    } catch (Exception e) {
        mensajeAlerta = "⚠️ Error al cargar los datos del usuario: " + e.getMessage();
    } finally {
        if (rsSelect != null) try { rsSelect.close(); } catch(Exception e){}
        if (psSelect != null) try { psSelect.close(); } catch(Exception e){}
        if (cnSelect != null) try { cnSelect.close(); } catch(Exception e){}
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>MetroWeb Panamá — Editar Usuario</title>
  <link rel="stylesheet" href="CSS/style.css"/>
  
  <!-- Manteniendo tu cabecera administrativa superior -->
  <jsp:include page="componentes/header_admin.jsp" />
</head>
<body>

<main>
  <section class="registro-body">
    <div class="registro-card">
      <!-- Botón para regresar directamente a la gestión de usuarios -->
      <a href="gestion_usuarios.jsp" class="btn-volver">← Volver a Gestión</a>

      <h1>Editar Cuenta<br>de Usuario</h1>
      <p class="subtitulo">Modifica la información correspondiente en la base de datos.</p>

      <% if (mensajeAlerta != null) { %>
          <div class="alerta alerta-error">
            <%= mensajeAlerta %>
          </div>
      <% } %>

      <!-- Enviamos los cambios adjuntando el ID actual en el action -->
      <form action="usuario_admin.jsp?id=<%= idParam %>" method="POST">
        
        <div class="campo-fila">
          <div class="campo">
            <label for="nombre">Nombre</label>
            <!-- El atributo 'value' pinta la información recuperada de la BD -->
            <input type="text" id="nombre" name="nombre" value="<%= nombre %>" placeholder="Juan" required/>
          </div>
          <div class="campo">
            <label for="apellido">Apellido</label>
            <input type="text" id="apellido" name="apellido" value="<%= apellido %>" placeholder="Pérez" required/>
          </div>
        </div>

        <div class="campo">
          <label for="correo">Correo electrónico</label>
          <input type="email" id="correo" name="correo" value="<%= correo %>" placeholder="usuario@correo.com" required/>
        </div>

        <!-- Se ajustó la contraseña para que sea opcional al editar -->
        <div class="campo">
          <label for="contrasena">Nueva contraseña (Opcional)</label>
          <input type="password" id="contrasena" name="contrasena" placeholder="Dejar en blanco para conservar la actual"/>
        </div>

        <button type="submit" class="btn btn-primario btn-full">
          Confirmar Edición
        </button>
      </form>

    </div>
  </section>
</main>

<footer>
    <jsp:include page="componentes/footer_admin.jsp" />
</footer>

</body>
</html>