<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>
<%
    // =========================================================================
    // 1. CONFIGURACIÓN DE SESIÓN Y VARIABLES DE CONTROL
    // =========================================================================
    
    // Se obtiene el ID del usuario logueado en la sesión activa
    Integer idUsuarioLogueado = (Integer) session.getAttribute("id_usuario");
    if (idUsuarioLogueado == null) {
        idUsuarioLogueado = 1; // ID de respaldo por si estás probando sin login previo
    }

    String mensajeAlerta = null;
    boolean esExito = false;

    // Variables globales para poblar el formulario (se rellenan en el bloque GET)
    String nombre = "", apellido = "", correo = "";

    // =========================================================================
    // 2. BLOQUE POST: PROCESAR LA ACTUALIZACIÓN DEL PERFIL
    // =========================================================================
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        request.setCharacterEncoding("UTF-8");
        
        // Captura de los datos enviados desde los inputs del formulario
        String inputNombre = request.getParameter("nombre");
        String inputApellido = request.getParameter("apellido");
        String inputPassword = request.getParameter("password");
        String inputConfirmar = request.getParameter("confirmar");

        // Validaciones basadas en tu código de registro de referencia
        if (inputPassword != null && !inputPassword.isEmpty() && inputPassword.length() < 8) {
            mensajeAlerta = "❌ La nueva contraseña debe tener al menos 8 caracteres.";
        } else if (inputPassword != null && !inputPassword.isEmpty() && !inputPassword.equals(inputConfirmar)) {
            mensajeAlerta = "❌ Las contraseñas ingresadas no coinciden.";
        } else {
            Connection cn = null;
            PreparedStatement psUpdate = null;

            try {
                // Conexión exacta a tu base de datos de referencia: metrowebpanama2
                Class.forName("com.mysql.cj.jdbc.Driver");
                cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/metrowebpanama2", "root", "");

                // Si el usuario escribió una nueva contraseña, se hashea y se actualiza todo
                if (inputPassword != null && !inputPassword.isEmpty()) {
                    String contrasenaHasheada = BCrypt.hashpw(inputPassword, BCrypt.gensalt(12));
                    String sqlUpdate = "UPDATE Usuario SET nombre=?, apellido=?, hash_contrasena=? WHERE id_usuario=?";
                    psUpdate = cn.prepareStatement(sqlUpdate);
                    psUpdate.setString(1, inputNombre.trim());
                    psUpdate.setString(2, inputApellido.trim());
                    psUpdate.setString(3, contrasenaHasheada);
                    psUpdate.setInt(4, idUsuarioLogueado);
                } else {
                    // Si dejó los campos de contraseña vacíos, solo se actualizan Nombre y Apellido
                    String sqlUpdate = "UPDATE Usuario SET nombre=?, apellido=? WHERE id_usuario=?";
                    psUpdate = cn.prepareStatement(sqlUpdate);
                    psUpdate.setString(1, inputNombre.trim());
                    psUpdate.setString(2, inputApellido.trim());
                    psUpdate.setInt(3, idUsuarioLogueado);
                }

                psUpdate.executeUpdate();
                mensajeAlerta = "✅ ¡Cambios guardados con éxito!";
                esExito = true;
            } catch (Exception e) {
                mensajeAlerta = "⚠️ Error al guardar en el sistema: " + e.getMessage();
            } finally {
                // Cierre seguro de recursos en el bloque finally
                if (psUpdate != null) try { psUpdate.close(); } catch(Exception e){}
                if (cn != null) try { cn.close(); } catch(Exception e){}
            }
        }
    }

    // =========================================================================
    // 3. BLOQUE GET: CARGAR LOS DATOS ACTUALES DEL USUARIO EN TIEMPO REAL
    // =========================================================================
    Connection cnGet = null;
    PreparedStatement psSelect = null;
    ResultSet rsSelect = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        cnGet = DriverManager.getConnection("jdbc:mysql://localhost:3306/metrowebpanama2", "root", "");

        // Consulta para traer la información basándonos únicamente en los campos de tu registro
        String sqlSelect = "SELECT nombre, apellido, correo FROM Usuario WHERE id_usuario = ?";
        psSelect = cnGet.prepareStatement(sqlSelect);
        psSelect.setInt(1, idUsuarioLogueado);
        rsSelect = psSelect.executeQuery();

        if (rsSelect.next()) {
            nombre = rsSelect.getString("nombre");
            apellido = rsSelect.getString("apellido");
            correo = rsSelect.getString("correo");
        }
    } catch (Exception e) {
        mensajeAlerta = "⚠️ Error al cargar los datos: " + e.getMessage();
    } finally {
        if (rsSelect != null) try { rsSelect.close(); } catch(Exception e){}
        if (psSelect != null) try { psSelect.close(); } catch(Exception e){}
        if (cnGet != null) try { cnGet.close(); } catch(Exception e){}
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Perfil - MetroWeb Panamá</title>
    <link rel="stylesheet" href="CSS/style.css">
</head>
<body>

    <jsp:include page="componentes/header.jsp" />

    <main class="contenedor seccion">
        
        <div class="perfil-container">
            <div class="perfil-card">

                <div class="perfil-top">
                    <div class="perfil-info">
                        <h2><%= nombre %> <%= apellido %></h2>
                        <p>Administrador de la cuenta MetroWeb Panamá</p>
                    </div>
                </div>

                <% if (mensajeAlerta != null) { %>
                    <div class="alerta <%= esExito ? "alerta-exito" : "alerta-error" %>">
                        <%= mensajeAlerta %>
                    </div>
                <% } %>

                <h3 class="perfil-titulo">
                    Información Personal
                </h3>

                <form action="perfil.jsp" method="post">
                    <div class="perfil-grid">

                        <div class="grupo">
                            <label for="nombre" class="fw-600">Nombre</label>
                            <input type="text" id="nombre" name="nombre" value="<%= nombre %>" required>
                        </div>

                        <div class="grupo">
                            <label for="apellido" class="fw-600">Apellido</label>
                            <input type="text" id="apellido" name="apellido" value="<%= apellido %>" required>
                        </div>

                        <div class="grupo grupo-full">
                            <label for="correo" class="fw-600">Correo electrónico</label>
                            <input type="email" id="correo" name="correo" value="<%= correo %>" readonly class="bg-gris-fondo">
                        </div>

                        <div class="grupo">
                            <label for="password" class="fw-600">Nueva contraseña</label>
                            <input type="password" id="password" name="password" placeholder="Mínimo 8 caracteres">
                        </div>

                        <div class="grupo">
                            <label for="confirmar" class="fw-600">Confirmar contraseña</label>
                            <input type="password" id="confirmar" name="confirmar" placeholder="Repite tu contraseña">
                        </div>
                    </div>

                    <div class="perfil-botones">
                        <button class="btn btn-secundario" type="reset">
                            Cancelar
                        </button>
                        <button class="btn btn-principal" type="submit">
                            Guardar Cambios
                        </button>
                    </div>
                </form>

                <div style="display: flex; justify-content: center; gap: 15px; margin-top: 40px;">
                    <a href="agregar-tarjeta.jsp" 
                       style="text-decoration: none; 
                              background-color: var(--azul); 
                              color: #ffffff; 
                              padding: 12px 32px; 
                              border-radius: 8px; 
                              font-weight: 600; 
                              font-size: 15px; 
                              display: inline-flex; 
                              align-items: center; 
                              gap: 8px;
                              box-shadow: 0 4px 12px rgba(15, 37, 73, 0.15);
                              transition: background-color 0.2s;">
                              Agregar Tarjeta
                    </a>

                    <a href="Recarga_tarjetas.jsp" 
                       style="text-decoration: none; 
                              background-color: #e8610a; 
                              color: #ffffff; 
                              padding: 12px 32px; 
                              border-radius: 8px; 
                              font-weight: 600; 
                              font-size: 15px; 
                              display: inline-flex; 
                              align-items: center; 
                              gap: 8px;
                              box-shadow: 0 4px 12px rgba(232, 97, 10, 0.2);
                              transition: background-color 0.2s;">
                          Ir a Recargar Tarjeta
                    </a>
                </div>

            </div>
        </div>
        
    </main>

    <jsp:include page="componentes/footer.jsp" />

</body>
</html>