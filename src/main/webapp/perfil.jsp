<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>
<%
    // =========================================================================
    // 1. CONFIGURACIÓN DE SESIÓN Y VARIABLES DE CONTROL
    // =========================================================================
    Integer idUsuarioLogueado = (Integer) session.getAttribute("id_usuario");
    if (idUsuarioLogueado == null) {
        idUsuarioLogueado = 1; 
    }

    String mensajeAlerta = null;
    boolean esExito = false;

    String nombre = "", apellido = "", correo = "";

    // =========================================================================
    // 2. BLOQUE POST: PROCESAR LA ACTUALIZACIÓN DEL PERFIL
    // =========================================================================
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        request.setCharacterEncoding("UTF-8");
        
        String inputNombre = request.getParameter("nombre");
        String inputApellido = request.getParameter("apellido");
        String inputPassword = request.getParameter("password");
        String inputConfirmar = request.getParameter("confirmar");

        if (inputPassword != null && !inputPassword.isEmpty() && inputPassword.length() < 8) {
            mensajeAlerta = "❌ La nueva contraseña debe tener al menos 8 caracteres.";
        } else if (inputPassword != null && !inputPassword.isEmpty() && !inputPassword.equals(inputConfirmar)) {
            mensajeAlerta = "❌ Las contraseñas ingresadas no coinciden.";
        } else {
            Connection cn = null;
            PreparedStatement psUpdate = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/metrowebpanama2", "root", "");

                if (inputPassword != null && !inputPassword.isEmpty()) {
                    String contrasenaHasheada = BCrypt.hashpw(inputPassword, BCrypt.gensalt(12));
                    String sqlUpdate = "UPDATE Usuario SET nombre=?, apellido=?, hash_contrasena=? WHERE id_usuario=?";
                    psUpdate = cn.prepareStatement(sqlUpdate);
                    psUpdate.setString(1, inputNombre.trim());
                    psUpdate.setString(2, inputApellido.trim());
                    psUpdate.setString(3, contrasenaHasheada);
                    psUpdate.setInt(4, idUsuarioLogueado);
                } else {
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

    <%-- jsp:include: Carga de forma modular la barra de navegación superior (header.jsp) --%>
    <jsp:include page="componentes/header.jsp" />

    <%-- Etiqueta <main>: Delimita el contenido central de la gestión del perfil para buscadores y accesibilidad --%>
    <main class="contenedor seccion">
        
        <%-- Div contenedor principal del perfil: Aplica una estructura flexible para acomodar y centrar las tarjetas --%>
        <div class="perfil-container">
            
            <%-- Tarjeta blanca contenedora que agrupa la información del usuario y los controles de edición --%>
            <div class="perfil-card">

                <%-- Bloque superior (cabecera interna) de la tarjeta de perfil --%>
                <div class="perfil-top">
                    <%-- Contenedor de los textos principales con el nombre dinámico del usuario logueado --%>
                    <div class="perfil-info">
                        <%-- Expresión JSP que inyecta los valores actuales traídos desde MySQL en el bloque GET --%>
                        <h2><%= nombre %> <%= apellido %></h2>
                        <p>Administrador de la cuenta MetroWeb Panamá</p>
                    </div>
                </div>

                <%-- Bloque de alertas: Se procesa en el servidor y decide si inyecta o no este DIV en el HTML resultante --%>
                <% if (mensajeAlerta != null) { %>
                    <%-- Utiliza un operador ternario para alternar la clase CSS entre éxito o error según el resultado del POST --%>
                    <div class="alerta <%= esExito ? "alerta-exito" : "alerta-error" %>">
                        <%= mensajeAlerta %>
                    </div>
                <% } %>

                <h3 class="perfil-titulo">
                    Información Personal
                </h3>

                <%-- Formulario de actualización: Redirige con método POST a este mismo archivo para ejecutar el bloque superior de Java --%>
                <form action="perfil.jsp" method="post">
                    
                    <%-- Div con distribución de rejilla (Grid) para acomodar los inputs en múltiples columnas --%>
                    <div class="perfil-grid">

                        <%-- Bloque de captura del Nombre --%>
                        <div class="grupo">
                            <label for="nombre" class="fw-600">Nombre</label>
                            <%-- Inyecta el valor actual 'nombre' recuperado por el SELECT para que el input no aparezca vacío --%>
                            <input type="text" id="nombre" name="nombre" value="<%= nombre %>" required>
                        </div>

                        <%-- Bloque de captura del Apellido --%>
                        <div class="grupo">
                            <label for="apellido" class="fw-600">Apellido</label>
                            <input type="text" id="apellido" name="apellido" value="<%= apellido %>" required>
                        </div>

                        <%-- Bloque del Correo electrónico (Ocupa el ancho completo de la grilla por su clase 'grupo-full') --%>
                        <div class="grupo grupo-full">
                            <label for="correo" class="fw-600">Correo electrónico</label>
                            <%-- readonly: Atributo HTML que impide que el usuario edite el correo desde la interfaz web
                                 class="bg-gris-fondo": Aplica un tono gris indicando visualmente que es un campo bloqueado --%>
                            <input type="email" id="correo" name="correo" value="<%= correo %>" readonly class="bg-gris-fondo">
                        </div>

                        <%-- Bloque para ingresar una nueva Contraseña (Opcional) --%>
                        <div class="grupo">
                            <label for="password" class="fw-600">Nueva contraseña</label>
                            <input type="password" id="password" name="password" placeholder="Mínimo 8 caracteres">
                        </div>

                        <%-- Bloque para repetir la Contraseña nueva (Validada luego por Java en el POST) --%>
                        <div class="grupo">
                            <label for="confirmar" class="fw-600">Confirmar contraseña</label>
                            <input type="password" id="confirmar" name="confirmar" placeholder="Repite tu contraseña">
                        </div>
                    </div>

                    <%-- Contenedor alineado para los botones de acción del formulario --%>
                    <div class="perfil-botones">
                        <%-- Botón Cancelar (type="reset"): Restaura los valores de los inputs a su estado original --%>
                        <button class="btn btn-secundario" type="reset">
                            Cancelar
                        </button>
                        <%-- Botón Guardar (type="submit"): Dispara la acción POST del formulario hacia el servidor --%>
                        <button class="btn btn-principal" type="submit">
                            Guardar Cambios
                        </button>
                    </div>
                </form>

                <%-- Contenedor inferior flexbox para los accesos directos y enlaces de navegación secundaria del usuario --%>
                <div style="display: flex; justify-content: center; gap: 15px; margin-top: 40px;">
                    
                    <%-- Enlace redireccionado exactamente hacia la vista de agregar-tarjeta.jsp --%>
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

                    <%-- Enlace redireccionado exactamente hacia la vista de recarga de tarjetas --%>
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

    <%-- jsp:include: Carga modular del pie de página (footer.jsp) al cierre de la estructura HTML --%>
    <jsp:include page="componentes/footer.jsp" />

</body>
</html>