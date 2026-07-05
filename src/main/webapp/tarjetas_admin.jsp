<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    // ==========================================================================
    // PARTE 0: LÓGICA DE ELIMINACIÓN DE TARJETA
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
            
            response.sendRedirect("gestion_tarjetas.jsp");
            return;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (psDelete != null) try { psDelete.close(); } catch(Exception e){}
            if (cnDelete != null) try { cnDelete.close(); } catch(Exception e){}
        }
    }

    // 1. LEER EL FILTRO DE BÚSQUEDA (Por número de tarjeta o nombre de usuario)
    String txtBuscar = request.getParameter("txtBuscar");

    // 2. VARIABLES DE CONEXIÓN
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

<!-- Encabezado de administración unificado -->
<jsp:include page="componentes/header_admin.jsp" />

<main class="admin-layout-horizontal">
    <section class="admin-body">
        
        <!-- ENCABEZADO DEL PANEL -->
        <div class="panel-header">
            <h2>Control de Tarjetas</h2>
            <p class="subtitulo">Visualiza, busca y administra las tarjetas de transporte digital vinculadas en el sistema</p>
        </div>

        <!-- BARRA DE HERRAMIENTAS -->
        <div class="flex-between mb-6" style="display: flex; justify-content: space-between; align-items: center; gap: 16px; flex-wrap: wrap;">
            
            <!-- Buscador Nativo -->
            <form action="gestion_tarjetas.jsp" method="GET" style="display: flex; gap: 8px; flex-grow: 1; max-width: 400px;">
                <input type="text" name="txtBuscar" value="<%= (txtBuscar != null) ? txtBuscar : "" %>" placeholder="🔍 Buscar por número o usuario..." 
                       style="width: 100%; padding: 10px 14px; border: 1px solid #ccc; border-radius: var(--radio); font-family: var(--font-body);">
                <button type="submit" class="btn btn-primario" style="padding: 0 16px;">Buscar</button>
            </form>

            <!-- Botón Agregar Tarjeta -->
            <a href="agregar-tarjeta.jsp" class="btn btn-naranja" style="text-decoration: none; display: inline-block; line-height: 40px; height: 40px; padding: 0 20px;">
                + Agregar Tarjeta
            </a>
        </div>

        <!-- TABLA DE TARJETA -->
        <div class="tabla-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>Número de Tarjeta</th>
                        <th>Propietario</th>
                        <th>Saldo B/.</th>
                        <th class="text-center" style="width: 200px;">Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        boolean tieneRegistros = false;
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/metrowebpanama2", "root", "");

                            String sql;
                            // Hacemos un INNER JOIN con Usuario para mostrar quién es el dueño de la tarjeta
                            if (txtBuscar != null && !txtBuscar.trim().isEmpty()) {
                                sql = "SELECT t.id_tarjeta, t.num_tarjeta, t.saldo, u.nombre, u.apellido " +
                                      "FROM tarjeta t " +
                                      "INNER JOIN Usuario u ON t.id_usuario = u.id_usuario " +
                                      "WHERE t.num_tarjeta LIKE ? OR u.nombre LIKE ? OR u.apellido LIKE ?";
                                ps = cn.prepareStatement(sql);
                                String queryParam = "%" + txtBuscar.trim() + "%";
                                ps.setString(1, queryParam);
                                ps.setString(2, queryParam);
                                ps.setString(3, queryParam);
                            } else {
                                sql = "SELECT t.id_tarjeta, t.num_tarjeta, t.saldo, u.nombre, u.apellido " +
                                      "FROM tarjeta t " +
                                      "INNER JOIN Usuario u ON t.id_usuario = u.id_usuario";
                                ps = cn.prepareStatement(sql);
                            }

                            rs = ps.executeQuery();

                            while (rs.next()) {
                                tieneRegistros = true;
                                int idTarjeta = rs.getInt("id_tarjeta");
                                String numTarjeta = rs.getString("num_tarjeta");
                                double saldo = rs.getDouble("saldo");
                                String propietario = rs.getString("nombre") + " " + rs.getString("apellido");
                    %>
                                <tr>
                                    <td class="fw-600"><%= numTarjeta %></td>
                                    <td><%= propietario %></td>
                                    <td><strong>B/. <%= String.format("%.2f", saldo) %></strong></td>
                                    <td class="text-center">
                                        <div style="display: flex; gap: 12px; justify-content: center; align-items: center;">
                                            <!-- Botón Editar redirige a agregar-tarjeta.jsp pasando el ID -->
                                            <a href="agregar-tarjeta.jsp?id=<%= idTarjeta %>" 
                                               class="btn btn-ghost btn-sm" 
                                               style="text-decoration: none; width: 90px; text-align: center; box-sizing: border-box; display: inline-block;">
                                               Editar
                                            </a>
                                            
                                            <!-- Botón Eliminar ejecuta el Modal -->
                                            <button type="button" 
                                                    onclick="abrirModalEliminar(<%= idTarjeta %>, '<%= numTarjeta %>')"
                                                    class="btn btn-outline btn-sm" 
                                                    style="color: var(--naranja); border-color: var(--naranja); cursor: pointer; width: 90px; text-align: center; box-sizing: border-box; display: inline-block; background: transparent;">
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
                                <td colspan="4" style="color: red; padding: 15px;">⚠️ Error de conexión: <%= e.getMessage() %></td>
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
                                <td colspan="4" class="text-center text-mutado" style="padding: var(--sp-6);">No se encontraron tarjetas registradas en el sistema.</td>
                            </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </section>
</main>

<!-- MODAL EMERGENTE REUTILIZANDO TUS ESTILOS DE CSS -->
<div id="modalEliminar" class="modal-overlay">
    <div class="modal-box">
        <h3>¿Confirmar desvinculación?</h3>
        <p>¿Seguro que deseas eliminar la tarjeta N° <strong id="numeroTarjetaModal" style="color: #1a202c;"></strong>? Esta acción borrará de inmediato sus datos del sistema.</p>
        
        <div class="modal-botones">
            <button type="button" onclick="cerrarModalEliminar()" class="btn btn-ghost" style="width: 110px;">
                Cancelar
            </button>
            <form action="gestion_tarjetas.jsp" method="POST" id="formConfirmarEliminar">
                <input type="hidden" name="idEliminar" id="idEliminarInput">
                <button type="submit" class="btn btn-naranja" style="width: 110px; background-color: var(--naranja);">
                    Confirmar
                </button>
            </form>
        </div>
    </div>
</div>

<jsp:include page="componentes/footer.jsp" />

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
        if (event.target === modal) {
            cerrarModalEliminar();
        }
    }
</script>

</body>
</html>