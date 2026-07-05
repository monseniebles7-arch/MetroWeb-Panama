<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    // =========================================================================
    // 1. CONFIGURACIÓN INICIAL Y DETECCIÓN DE MODO (CREAR O EDITAR)
    // =========================================================================
    String idParam = request.getParameter("id");
    boolean modoEdicion = (idParam != null && !idParam.trim().isEmpty());

    String mensajeAlerta = null;
    boolean esExito = false;

    // Variables internas para los campos del formulario
    String numeroTarjeta = "";
    String aliasTarjeta = "";
    double saldo = 0.0;
    int idEstado = 1;
    int idTipoTarjeta = 1;
    String correoUsuario = ""; // Guardaremos el correo en lugar del ID bruto en la vista

    Connection cn = null;

    // =========================================================================
    // 2. PROCESAMIENTO DEL FORMULARIO (MÉTODO POST - INSERT / UPDATE)
    // =========================================================================
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        request.setCharacterEncoding("UTF-8");
        
        String txtNumero = request.getParameter("numTarjeta");
        String txtAlias = request.getParameter("aliasTarjeta");
        String txtSaldo = request.getParameter("saldo");
        String txtEstado = request.getParameter("id_estado");
        String txtTipo = request.getParameter("tipoTarjeta");
        String txtCorreo = request.getParameter("correo_usuario"); // Capturamos el correo introducido

        PreparedStatement psUsuario = null;
        PreparedStatement psAccion = null;
        ResultSet rsUsuario = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/metrowebpanama2", "root", "");

            // PASO A: Buscar el id_usuario correspondiente al correo ingresado
            String sqlBuscarUsuario = "SELECT id_usuario FROM Usuario WHERE correo = ?";
            psUsuario = cn.prepareStatement(sqlBuscarUsuario);
            psUsuario.setString(1, txtCorreo.trim());
            rsUsuario = psUsuario.executeQuery();

            if (rsUsuario.next()) {
                int idUsuarioEncontrado = rsUsuario.getInt("id_usuario");

                if (modoEdicion) {
                    // Modo Administración: Modificar registro existente
                    String sqlUpdate = "UPDATE tarjeta SET numero_tarjeta = ?, alias_tarjeta = ?, saldo = ?, id_estado = ?, id_tipo_tarjeta = ?, id_usuario = ? WHERE id_tarjeta = ?";
                    psAccion = cn.prepareStatement(sqlUpdate);
                    psAccion.setString(1, txtNumero.trim());
                    psAccion.setString(2, txtAlias.trim());
                    psAccion.setDouble(3, Double.parseDouble(txtSaldo));
                    psAccion.setInt(4, Integer.parseInt(txtEstado));
                    psAccion.setInt(5, Integer.parseInt(txtTipo));
                    psAccion.setInt(6, idUsuarioEncontrado);
                    psAccion.setInt(7, Integer.parseInt(idParam));
                    psAccion.executeUpdate();
                    esExito = true;
                } else {
                    // Modo Administración: Registrar nueva tarjeta en la BD
                    String sqlInsert = "INSERT INTO tarjeta (numero_tarjeta, alias_tarjeta, saldo, id_estado, id_tipo_tarjeta, id_usuario) VALUES (?, ?, ?, ?, ?, ?)";
                    psAccion = cn.prepareStatement(sqlInsert);
                    psAccion.setString(1, txtNumero.trim());
                    psAccion.setString(2, txtAlias.trim());
                    psAccion.setDouble(3, Double.parseDouble(txtSaldo));
                    psAccion.setInt(4, Integer.parseInt(txtEstado));
                    psAccion.setInt(5, Integer.parseInt(txtTipo));
                    psAccion.setInt(6, idUsuarioEncontrado);
                    psAccion.executeUpdate();
                    esExito = true;
                }
            } else {
                // El correo no pertenece a ningún usuario en la base de datos
                mensajeAlerta = "❌ El correo electrónico ingresado no se encuentra registrado en el sistema.";
                // Conservamos los datos ingresados para que el admin no los pierda al recargarse la pantalla
                numeroTarjeta = txtNumero;
                aliasTarjeta = txtAlias;
                saldo = Double.parseDouble(txtSaldo);
                idEstado = Integer.parseInt(txtEstado);
                idTipoTarjeta = Integer.parseInt(txtTipo);
                correoUsuario = txtCorreo;
            }
            
        } catch (Exception e) {
            e.printStackTrace(); 
            mensajeAlerta = "⚠️ Error en la Base de Datos: " + e.getMessage();
        } finally {
            if (rsUsuario != null) try { rsUsuario.close(); } catch(Exception e){}
            if (psUsuario != null) try { psUsuario.close(); } catch(Exception e){}
            if (psAccion != null) try { psAccion.close(); } catch(Exception e){}
            if (cn != null) try { cn.close(); } catch(Exception e){}
        }

        if (esExito) {
            response.sendRedirect("tarjetas_admin.jsp");
            return;
        }
    }

    // =========================================================================
    // 3. RECUPERACIÓN DE DATOS PREVIOS (MÉTODO GET - SÓLO EN MODO EDICIÓN)
    // =========================================================================
    if (modoEdicion && mensajeAlerta == null) {
        PreparedStatement psSelect = null;
        ResultSet rsSelect = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/metrowebpanama2", "root", "");

            // Hacemos un INNER JOIN para recuperar directamente el correo del propietario actual
            String sqlSelect = "SELECT t.numero_tarjeta, t.alias_tarjeta, t.saldo, t.id_estado, t.id_tipo_tarjeta, u.correo " +
                               "FROM tarjeta t " +
                               "INNER JOIN Usuario u ON t.id_usuario = u.id_usuario " +
                               "WHERE t.id_tarjeta = ?";
            psSelect = cn.prepareStatement(sqlSelect);
            psSelect.setInt(1, Integer.parseInt(idParam));
            rsSelect = psSelect.executeQuery();

            if (rsSelect.next()) {
                numeroTarjeta = rsSelect.getString("numero_tarjeta");
                aliasTarjeta = rsSelect.getString("alias_tarjeta");
                saldo = rsSelect.getDouble("saldo");
                idEstado = rsSelect.getInt("id_estado");
                idTipoTarjeta = rsSelect.getInt("id_tipo_tarjeta");
                correoUsuario = rsSelect.getString("correo"); // Cargamos el correo en el input
            } else {
                response.sendRedirect("tarjetas_admin.jsp");
                return;
            }
        } catch (Exception e) {
            mensajeAlerta = "⚠️ Error al recuperar los datos de la tarjeta: " + e.getMessage();
        } finally {
            if (rsSelect != null) try { rsSelect.close(); } catch(Exception e){}
            if (psSelect != null) try { psSelect.close(); } catch(Exception e){}
            if (cn != null) try { cn.close(); } catch(Exception e){}
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title><%= modoEdicion ? "Editar Tarjeta" : "Agregar Tarjeta" %> — MetroWeb Panamá</title>
    <link rel="stylesheet" href="CSS/style.css"/>
</head>
<body>

    <!-- Header de Administración -->
    <jsp:include page="componentes/header_admin.jsp" />

    <main class="contenedor seccion">
        <div style="max-width: 500px; margin: 40px auto;">
            <div class="hero-login" style="float: none; width: 100%; box-sizing: border-box;">
                
                <h3><%= modoEdicion ? "Modificar Tarjeta" : "Agregar Tarjeta" %></h3>
                <p class="subtitulo"><%= modoEdicion ? "Modifica los parámetros asignados de la tarjeta" : "Registra y vincula una nueva tarjeta al sistema" %></p>

                <% if (mensajeAlerta != null) { %>
                    <div class="alerta alerta-error" style="background-color: #fce4e4; border: 1px solid #fcc2c2; color: #cc0000; padding: 12px; margin-bottom: 20px; border-radius: 6px; font-weight: 500; text-align: center;">
                        <%= mensajeAlerta %>
                    </div>
                <% } %>

                <form action="agregar-tarjeta.jsp<%= modoEdicion ? "?id=" + idParam : "" %>" method="POST">
                    
                    <!-- Campo 1: Número de tarjeta -->
                    <div class="campo">
                        <label for="numTarjeta">Número de Tarjeta</label>
                        <input 
                            type="text" 
                            id="numTarjeta" 
                            name="numTarjeta" 
                            value="<%= numeroTarjeta %>"
                            placeholder="Ej. 91040997" 
                            required 
                            maxlength="20"
                        />
                        <small style="color: var(--gris-texto); font-size: 0.8rem; display: block; margin-top: 5px;">
                            Introduce los dígitos numéricos del reverso.
                        </small>
                    </div>

                    <!-- Campo 2: Alias de la tarjeta -->
                    <div class="campo" style="margin-top: 20px;">
                        <label for="aliasTarjeta">Nombre personalizado (Alias)</label>
                        <input 
                            type="text" 
                            id="aliasTarjeta" 
                            name="aliasTarjeta" 
                            value="<%= (aliasTarjeta != null) ? aliasTarjeta : "" %>"
                            placeholder="Ej. Mi Tarjeta Principal" 
                        />
                    </div>

                    <!-- Campo 3: Ajuste de saldo -->
                    <div class="campo" style="margin-top: 20px;">
                        <label for="saldo">Saldo Disponible (B/.)</label>
                        <input 
                            type="number" 
                            step="0.01"
                            id="saldo" 
                            name="saldo" 
                            value="<%= saldo %>"
                            placeholder="0.00" 
                            required
                        />
                    </div>

                    <!-- Campo 4: Estado de Tarjeta -->
                    <div class="campo" style="margin-top: 20px;">
                        <label for="id_estado">Estado Operativo</label>
                        <select id="id_estado" name="id_estado" style="width: 100%; padding: 10px; border: 1px solid var(--gris-borde); border-radius: 4px; background: white; font-family: inherit;">
                            <option value="1" <%= (idEstado == 1) ? "selected" : "" %>>Activa</option>
                            <option value="2" <%= (idEstado == 2) ? "selected" : "" %>>Bloqueada</option>
                            <option value="3" <%= (idEstado == 3) ? "selected" : "" %>>Vencida</option>
                        </select>
                    </div>

                    <!-- Campo 5: Tipo de Tarjeta -->
                    <div class="campo" style="margin-top: 20px;">
                        <label for="tipoTarjeta">Tipo de Tarjeta</label>
                        <select id="tipoTarjeta" name="tipoTarjeta" style="width: 100%; padding: 10px; border: 1px solid var(--gris-borde); border-radius: 4px; background: white; font-family: inherit;">
                            <option value="1" <%= (idTipoTarjeta == 1) ? "selected" : "" %>>General</option>
                            <option value="2" <%= (idTipoTarjeta == 2) ? "selected" : "" %>>Estudiante</option>
                            <option value="3" <%= (idTipoTarjeta == 3) ? "selected" : "" %>>Jubilado</option>
                        </select>
                    </div>

                    <!-- NUEVO CAMPO OPTIMIZADO: Correo del usuario dueño de la tarjeta -->
                    <div class="campo" style="margin-top: 20px;">
                        <label for="correo_usuario">Correo Electrónico del Propietario</label>
                        <input 
                            type="email" 
                            id="correo_usuario" 
                            name="correo_usuario" 
                            value="<%= correoUsuario %>"
                            placeholder="Ej. usuario@correo.com" 
                            required
                        />
                        <small style="color: var(--gris-texto); font-size: 0.8rem; display: block; margin-top: 5px;">
                            La tarjeta quedará enlazada automáticamente a la cuenta que posea este correo.
                        </small>
                    </div>

                    <button type="submit" class="btn btn-primario btn-full" style="margin-top: 30px;">
                         <%= modoEdicion ? "Confirmar Cambios" : "Guardar Tarjeta" %>
                    </button>
                    
                    <a href="tarjetas_admin.jsp" style="display: block; text-align: center; margin-top: 15px; color: var(--azul-primario); text-decoration: none; font-size: 0.9rem;">
                        Cancelar y regresar
                    </a>
                </form>
            </div>
        </div>
    </main>

    <jsp:include page="componentes/footer.jsp" />

</body>
</html>