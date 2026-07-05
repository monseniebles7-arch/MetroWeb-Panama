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
    int idUsuario = 0;

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
        String txtUsuario = request.getParameter("id_usuario");

        PreparedStatement psAccion = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/metrowebpanama2", "root", "");

            if (modoEdicion) {
                // Modo Administración: Modificar registro existente
                String sqlUpdate = "UPDATE tarjetas SET numero_tarjeta = ?, alias_tarjeta = ?, saldo = ?, id_estado = ?, id_tipo_tarjeta = ?, id_usuario = ? WHERE id_tarjeta = ?";
                psAccion = cn.prepareStatement(sqlUpdate);
                psAccion.setString(1, txtNumero.trim());
                psAccion.setString(2, txtAlias.trim());
                psAccion.setDouble(3, Double.parseDouble(txtSaldo));
                psAccion.setInt(4, Integer.parseInt(txtEstado));
                psAccion.setInt(5, Integer.parseInt(txtTipo));
                psAccion.setInt(6, Integer.parseInt(txtUsuario));
                psAccion.setInt(7, Integer.parseInt(idParam));
                psAccion.executeUpdate();
                esExito = true;
            } else {
                // Modo Administración: Registrar nueva tarjeta en la BD
                String sqlInsert = "INSERT INTO tarjetas (numero_tarjeta, alias_tarjeta, saldo, id_estado, id_tipo_tarjeta, id_usuario) VALUES (?, ?, ?, ?, ?, ?)";
                psAccion = cn.prepareStatement(sqlInsert);
                psAccion.setString(1, txtNumero.trim());
                psAccion.setString(2, txtAlias.trim());
                psAccion.setDouble(3, Double.parseDouble(txtSaldo));
                psAccion.setInt(4, Integer.parseInt(txtEstado));
                psAccion.setInt(5, Integer.parseInt(txtTipo));
                psAccion.setInt(6, Integer.parseInt(txtUsuario));
                psAccion.executeUpdate();
                esExito = true;
            }
            
        } catch (Exception e) {
            e.printStackTrace(); 
            mensajeAlerta = "⚠️ Error en la Base de Datos: " + e.getMessage();
        } finally {
            if (psAccion != null) try { psAccion.close(); } catch(Exception e){}
        }

        if (esExito) {
            response.sendRedirect("gestion_tarjetas.jsp");
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

            String sqlSelect = "SELECT numero_tarjeta, alias_tarjeta, saldo, id_estado, id_tipo_tarjeta, id_usuario FROM tarjetas WHERE id_tarjeta = ?";
            psSelect = cn.prepareStatement(sqlSelect);
            psSelect.setInt(1, Integer.parseInt(idParam));
            rsSelect = psSelect.executeQuery();

            if (rsSelect.next()) {
                numeroTarjeta = rsSelect.getString("numero_tarjeta");
                aliasTarjeta = rsSelect.getString("alias_tarjeta");
                saldo = rsSelect.getDouble("saldo");
                idEstado = rsSelect.getInt("id_estado");
                idTipoTarjeta = rsSelect.getInt("id_tipo_tarjeta");
                idUsuario = rsSelect.getInt("id_usuario");
            } else {
                response.sendRedirect("gestion_tarjetas.jsp");
                return;
            }
        } catch (Exception e) {
            mensajeAlerta = "⚠️ Error al recuperar los datos de la tarjeta: " + e.getMessage();
        } finally {
            if (rsSelect != null) try { rsSelect.close(); } catch(Exception e){}
            if (psSelect != null) try { psSelect.close(); } catch(Exception e){}
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

                <!-- El formulario se envía a sí mismo preservando el parámetro ID si está en modo edición -->
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

                    <!-- Campo 3: Ajuste de saldo (Exclusivo de gestión administrativa) -->
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

                    <!-- Campo 4: Estado de Tarjeta (Tabla estadotarjeta) -->
                    <div class="campo" style="margin-top: 20px;">
                        <label for="id_estado">Estado Operativo</label>
                        <select id="id_estado" name="id_estado" style="width: 100%; padding: 10px; border: 1px solid var(--gris-borde); border-radius: 4px; background: white; font-family: inherit;">
                            <option value="1" <%= (idEstado == 1) ? "selected" : "" %>>Activa</option>
                            <option value="2" <%= (idEstado == 2) ? "selected" : "" %>>Bloqueada</option>
                            <option value="3" <%= (idEstado == 3) ? "selected" : "" %>>Vencida</option>
                        </select>
                    </div>

                    <!-- Campo 5: Tipo de Tarjeta (Tabla tipotarjeta) -->
                    <div class="campo" style="margin-top: 20px;">
                        <label for="tipoTarjeta">Tipo de Tarjeta</label>
                        <select id="tipoTarjeta" name="tipoTarjeta" style="width: 100%; padding: 10px; border: 1px solid var(--gris-borde); border-radius: 4px; background: white; font-family: inherit;">
                            <option value="1" <%= (idTipoTarjeta == 1) ? "selected" : "" %>>General</option>
                            <option value="2" <%= (idTipoTarjeta == 2) ? "selected" : "" %>>Estudiante</option>
                            <option value="3" <%= (idTipoTarjeta == 3) ? "selected" : "" %>>Jubilado</option>
                        </select>
                    </div>

                    <!-- Campo 6: Propietario de la tarjeta (Dropdown dinámico de la BD) -->
                    <div class="campo" style="margin-top: 20px;">
                        <label for="id_usuario">Asignar Propietario</label>
                        <select id="id_usuario" name="id_usuario" required style="width: 100%; padding: 10px; border: 1px solid var(--gris-borde); border-radius: 4px; background: white; font-family: inherit;">
                            <option value="">-- Seleccione un usuario --</option>
                            <%
                                Statement stUsers = null;
                                ResultSet rsUsers = null;
                                try {
                                    if (cn == null || cn.isClosed()) {
                                        Class.forName("com.mysql.cj.jdbc.Driver");
                                        cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/metrowebpanama2", "root", "");
                                    }
                                    stUsers = cn.createStatement();
                                    rsUsers = stUsers.executeQuery("SELECT id_usuario, nombre, apellido FROM Usuario ORDER BY nombre ASC");
                                    while (rsUsers.next()) {
                                        int uId = rsUsers.getInt("id_usuario");
                                        String uNombre = rsUsers.getString("nombre") + " " + rsUsers.getString("apellido");
                                        String uSelected = (uId == idUsuario) ? "selected" : "";
                            %>
                                        <option value="<%= uId %>" <%= uSelected %>><%= uNombre %></option>
                            <%
                                    }
                                } catch(Exception e) {
                                    e.printStackTrace();
                                } finally {
                                    if (rsUsers != null) try { rsUsers.close(); } catch(Exception e){}
                                    if (stUsers != null) try { stUsers.close(); } catch(Exception e){}
                                    if (cn != null) try { cn.close(); } catch(Exception e){}
                                }
                            %>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-primario btn-full" style="margin-top: 30px;">
                         <%= modoEdicion ? "Confirmar Cambios" : "Guardar Tarjeta" %>
                    </button>
                    
                    <a href="gestion_tarjetas.jsp" style="display: block; text-align: center; margin-top: 15px; color: var(--azul-primario); text-decoration: none; font-size: 0.9rem;">
                        Cancelar y regresar
                    </a>
                </form>
            </div>
        </div>
    </main>

    <jsp:include page="componentes/footer.jsp" />

</body>
</html>