<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    // ==========================================================================
    // LÓGICA DE ELIMINACIÓN DE TARJETA
    // ==========================================================================
    request.setCharacterEncoding("UTF-8");
    String idEliminar = request.getParameter("idEliminar");

    if (idEliminar != null && !idEliminar.trim().isEmpty()) {
        Connection cnDelete = null;
        PreparedStatement psDelete = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            cnDelete = DriverManager.getConnection("jdbc:mysql://localhost:3306/metrowebpanama2", "root", "");
            
            String sqlDelete = "DELETE FROM tarjeta WHERE id_tarjeta = ?";
            psDelete = cnDelete.prepareStatement(sqlDelete);
            psDelete.setInt(1, Integer.parseInt(idEliminar));
            psDelete.executeUpdate();
            
            response.sendRedirect("tarjetas_admin.jsp");
            return;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (psDelete != null) try { psDelete.close(); } catch(Exception e){}
            if (cnDelete != null) try { cnDelete.close(); } catch(Exception e){}
        }
    }

    String txtBuscar = request.getParameter("txtBuscar");
    Connection cn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Gestión de Tarjetas | MetroWeb Panamá</title>
    <link rel="stylesheet" href="CSS/style.css"/>
</head>
<body>

<jsp:include page="componentes/header_admin.jsp" />

<main class="admin-layout-horizontal">
    <section class="admin-body">
        
        <div class="panel-header">
            <h2>Control de Tarjetas</h2>
            <p class="subtitulo">Visualiza, busca y administra las tarjetas de transporte digital vinculadas en el sistema</p>
        </div>

        <div class="flex-between mb-6" style="display: flex; justify-content: space-between; align-items: center; gap: 16px; flex-wrap: wrap;">
            <form action="tarjetas_admin.jsp" method="GET" style="display: flex; gap: 8px; flex-grow: 1; max-width: 400px;">
                <input type="text" name="txtBuscar" value="<%= (txtBuscar != null) ? txtBuscar : "" %>" placeholder="🔍 Buscar por número, alias o usuario..." 
                       style="width: 100%; padding: 10px 14px; border: 1px solid #ccc; border-radius: var(--radio); font-family: var(--font-body);">
                <button type="submit" class="btn btn-primario" style="padding: 0 16px;">Buscar</button>
            </form>

            <a href="agregar_tarjeta_admin.jsp" class="btn btn-naranja" style="text-decoration: none; display: inline-block; line-height: 40px; height: 40px; padding: 0 20px;">
                + Agregar Tarjeta
            </a>
        </div>

        <div class="tabla-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>Número de Tarjeta</th>
                        <th>Alias</th>
                        <th>Propietario</th>
                        <th>Tipo</th>
                        <th>Estado</th>
                        <th>Saldo</th>
                        <th class="text-center" style="width: 200px;">Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        boolean tieneRegistros = false;
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/metrowebpanama2", "root", "");

                            // Unimos la tabla tarjeta con Usuario, estadotarjeta y tipotarjeta usando alias para desempatar las columnas 'descripcion'
                            String sql = "SELECT t.id_tarjeta, t.numero_tarjeta, t.alias_tarjeta, t.saldo, " +
                                         "u.nombre, u.apellido, e.descripcion AS estado_desc, tp.descripcion AS tipo_desc " +
                                         "FROM tarjeta t " +
                                         "INNER JOIN Usuario u ON t.id_usuario = u.id_usuario " +
                                         "INNER JOIN estadotarjeta e ON t.id_estado = e.id_estado " +
                                         "INNER JOIN tipotarjeta tp ON t.id_tipo_tarjeta = tp.id_tipo_tarjeta";

                            if (txtBuscar != null && !txtBuscar.trim().isEmpty()) {
                                sql += " WHERE t.numero_tarjeta LIKE ? OR t.alias_tarjeta LIKE ? OR u.nombre LIKE ? OR u.apellido LIKE ?";
                                ps = cn.prepareStatement(sql);
                                String queryParam = "%" + txtBuscar.trim() + "%";
                                ps.setString(1, queryParam);
                                ps.setString(2, queryParam);
                                ps.setString(3, queryParam);
                                ps.setString(4, queryParam);
                            } else {
                                ps = cn.prepareStatement(sql);
                            }

                            rs = ps.executeQuery();

                            while (rs.next()) {
                                tieneRegistros = true;
                                int idTarjeta = rs.getInt("id_tarjeta");
                                String numeroTarjeta = rs.getString("numero_tarjeta");
                                String aliasTarjeta = rs.getString("alias_tarjeta");
                                double saldo = rs.getDouble("saldo");
                                String propietario = rs.getString("nombre") + " " + rs.getString("apellido");
                                String estadoDesc = rs.getString("estado_desc");
                                String tipoDesc = rs.getString("tipo_desc");
                    %>
                                <tr>
                                    <td class="fw-600"><%= numeroTarjeta %></td>
                                    <td class="text-mutado"><%= (aliasTarjeta != null) ? aliasTarjeta : "-" %></td>
                                    <td><%= propietario %></td>
                                    <td><span class="badge-tipo"><%= tipoDesc %></span></td>
                                    <td><strong><%= estadoDesc %></strong></td>
                                    <td><strong>B/. <%= String.format("%.2f", saldo) %></strong></td>
                                    <td class="text-center">
                                        <div style="display: flex; gap: 12px; justify-content: center; align-items: center;">
                                            <a href="agregar_tarjeta_admin.jsp?id=<%= idTarjeta %>" class="btn btn-ghost btn-sm" style="text-decoration: none; width: 90px; text-align: center; box-sizing: border-box; display: inline-block;">
                                               Editar
                                            </a>
                                            <button type="button" onclick="abrirModalEliminar(<%= idTarjeta %>, '<%= numeroTarjeta %>')" class="btn btn-outline btn-sm" style="color: var(--naranja); border-color: var(--naranja); cursor: pointer; width: 90px; text-align: center; box-sizing: border-box; display: inline-block; background: transparent;">
                                               Eliminar
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                    <%
                            }
                        } catch (Exception e) {
                    %>
                            <tr>
                                <td colspan="7" style="color: red; padding: 15px;">⚠️ Error al procesar tablas: <%= e.getMessage() %></td>
                            </tr>
                    <%
                        } finally {
                            if (rs != null) try { rs.close(); } catch(Exception e){}
                            if (ps != null) try { ps.close(); } catch(Exception e){}
                            if (cn != null) try { cn.close(); } catch(Exception e){}
                        }

                        if (!tieneRegistros) {
                    %>
                            <tr>
                                <td colspan="7" class="text-center text-mutado" style="padding: var(--sp-6);">No se encontraron tarjetas registradas.</td>
                            </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </section>
</main>

<div id="modalEliminar" class="modal-overlay">
    <div class="modal-box">
        <h3>¿Confirmar desvinculación?</h3>
        <p>¿Seguro que deseas eliminar la tarjeta N° <strong id="numeroTarjetaModal" style="color: #1a202c;"></strong>?</p>
        <div class="modal-botones">
            <button type="button" onclick="cerrarModalEliminar()" class="btn btn-ghost" style="width: 110px;">Cancelar</button>
            <form action="tarjetas_admin.jsp" method="POST">
                <input type="hidden" name="idEliminar" id="idEliminarInput">
                <button type="submit" class="btn btn-naranja" style="width: 110px; background-color: var(--naranja);">Confirmar</button>
            </form>
        </div>
    </div>
</div>

<jsp:include page="componentes/footer_admin.jsp" />

<script>
    const modal = document.getElementById('modalEliminar');
    const tarjetaTxt = document.getElementById('numeroTarjetaModal');
    const idInput = document.getElementById('idEliminarInput');

    function abrirModalEliminar(id, numero) {
        tarjetaTxt.textContent = numero;
        idInput.value = id;
        modal.classList.add('activo');
    }
    function cerrarModalEliminar() {
        modal.classList.remove('activo');
    }
    window.onclick = function(event) {
        if (event.target === modal) cerrarModalEliminar();
    }
</script>
</body>
</html>