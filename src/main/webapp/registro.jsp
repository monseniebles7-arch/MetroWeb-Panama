<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>
<%
    String mensajeAlerta = null;
    boolean esExito = false;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        request.setCharacterEncoding("UTF-8");
        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String correo = request.getParameter("correo");
        String contrasena = request.getParameter("contrasena");
        String confirmar = request.getParameter("confirmar");

        if (contrasena != null && contrasena.length() < 8) {
            mensajeAlerta = "❌ La contraseña debe tener al menos 8 caracteres.";
        } else if (contrasena != null && !contrasena.equals(confirmar)) {
            mensajeAlerta = "❌ Las contraseñas ingresadas no coinciden.";
        } else {
            Connection cn = null;
            PreparedStatement psCheck = null;
            PreparedStatement psInsert = null;
            ResultSet rsCheck = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/metrowebpanama2", "root", "");

                String sqlCheck = "SELECT id_usuario FROM Usuario WHERE correo = ?";
                psCheck = cn.prepareStatement(sqlCheck);
                psCheck.setString(1, correo.trim());
                rsCheck = psCheck.executeQuery();

                if (rsCheck.next()) {
                    mensajeAlerta = "❌ Este correo electrónico ya se encuentra registrado.";
                } else {
                    String contrasenaHasheada = BCrypt.hashpw(contrasena, BCrypt.gensalt(12));

                    String sqlInsert = "INSERT INTO Usuario (nombre, apellido, correo, hash_contrasena, id_rol) VALUES (?, ?, ?, ?, 2)";
                    psInsert = cn.prepareStatement(sqlInsert);
                    psInsert.setString(1, nombre.trim());
                    psInsert.setString(2, apellido.trim());
                    psInsert.setString(3, correo.trim());
                    psInsert.setString(4, contrasenaHasheada);
                    psInsert.executeUpdate();

                    esExito = true;
                }
            } catch (Exception e) {
                mensajeAlerta = "⚠️ Error al guardar en el sistema: " + e.getMessage();
            } finally {
                if (rsCheck != null) try { rsCheck.close(); } catch(Exception e){}
                if (psCheck != null) try { psCheck.close(); } catch(Exception e){}
                if (psInsert != null) try { psInsert.close(); } catch(Exception e){}
                if (cn != null) try { cn.close(); } catch(Exception e){}
            }

            if (esExito) {
                response.sendRedirect("home.jsp?registro_exito=1");
                return;
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>MetroWeb Panamá — Registro</title>
  <link rel="stylesheet" href="CSS/style.css"/>
  
  <jsp:include page="componentes/header_home.jsp" />
  
</head>
<body>


<main>
  <section class="registro-body">
    <div class="registro-card">
      <a href="home.jsp" class="btn-volver">← Volver al inicio</a>

      <h1>Empieza a usar<br>MetroWeb Panamá</h1>
      <p class="subtitulo">Tu tarjeta de transporte digital, en un solo lugar.</p>

      <% if (mensajeAlerta != null) { %>
          <div class="alerta alerta-error">
            <%= mensajeAlerta %>
          </div>
      <% } %>

      <form action="registro.jsp" method="POST">
        <div class="campo-fila">
          <div class="campo">
            <label for="nombre">Nombre</label>
            <input type="text" id="nombre" name="nombre" placeholder="Juan" required/>
          </div>
          <div class="campo">
            <label for="apellido">Apellido</label>
            <input type="text" id="apellido" name="apellido" placeholder="Pérez" required/>
          </div>
        </div>

        <div class="campo">
          <label for="correo">Correo electrónico</label>
          <input type="email" id="correo" name="correo" placeholder="usuario@correo.com" required/>
        </div>

        <div class="campo">
          <label for="contrasena">Contraseña</label>
          <input type="password" id="contrasena" name="contrasena" placeholder="Mínimo 8 caracteres" required/>
        </div>

        <div class="campo">
          <label for="confirmar">Confirmar contraseña</label>
          <input type="password" id="confirmar" name="confirmar" placeholder="Repite tu contraseña" required/>
        </div>

        <button type="submit" class="btn btn-primario btn-full">
          Crear cuenta
        </button>
      </form>

      <div class="separador">o</div>
      
      <a href="home.jsp" class="btn-outline">
        Ya tengo una cuenta
      </a>
    </div>
  </section>
</main>

</body>

<footer><jsp:include page="componentes/footer.jsp" /></footer>


</html>