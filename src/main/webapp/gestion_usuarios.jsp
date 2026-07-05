<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    // ==========================================================================
    // PARTE 0: LÓGICA DE ELIMINACIÓN DIRECTA EN LA MISMA PÁGINA
    // ==========================================================================
    request.setCharacterEncoding("UTF-8");
    String idEliminar = request.getParameter("idEliminar");

    if (idEliminar != null && !idEliminar.trim().isEmpty()) {
        Connection cnDelete = null;
        PreparedStatement psDelete = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            cnDelete = DriverManager.getConnection("jdbc:mysql://localhost:3306/metrowebpanama2", "root", "");
            
            String sqlDelete = "DELETE FROM Usuario WHERE id_usuario = ?";
            psDelete = cnDelete.prepareStatement(sqlDelete);
            psDelete.setInt(1, Integer.parseInt(idEliminar));
            psDelete.executeUpdate();
            
            // Redireccionamos a sí misma sin parámetros para limpiar la URL y actualizar la tabla
            response.sendRedirect("gestion_usuarios.jsp");
            return;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (psDelete != null) try { psDelete.close(); } catch(Exception e){}
            if (cnDelete != null) try { cnDelete.close(); } catch(Exception e){}
        }
    }

    // 1. LEER EL FILTRO DE BÚSQUEDA (SI EXISTE)
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
    <title>Admin - Gestión de Usuarios | MetroWeb Panamá</title>
    <link rel="stylesheet" href="CSS/style.css"/>
     
    <!-- ESTILOS ADICIONALES PARA LA VENTANA EMERGENTE (MODAL) -->
    <style>
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 9999;
            opacity: 0;
            pointer-events: none;
            transition: opacity 0.3s ease;
        }
        .modal-overlay.activo {
            opacity: 1;
            pointer-events: auto;
        }
        .modal-box {
            background: #ffffff;
            padding: 28px;
            border-radius: var(--radio-xl, 12px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
            max-width: 400px;
            width: 90%;
            text-align: center;
            transform: scale(0.8);
            transition: transform 0.3s ease;
        }
        .modal-overlay.activo .modal-box {
            transform: scale(1);
        }
        .modal-box h3 {
            color: #1a202c;
            margin-bottom: 12px;
            font-size: 1.3rem;
        }
        .modal-box p {
            color: #718096;
            font-size: var(--text-sm, 14px);
            margin-bottom: 24px;
        }
        .modal-botones {
            display: flex;
            gap: 12px;
            justify-content: center;
        }
    </style>
</head>
<body>

<!-- Encabezado de administración unificado -->
<jsp:include page="componentes/header_admin.jsp" />

<main class="admin-layout-horizontal">
    <section class="admin-body">
        
        <!-- ENCABEZADO DEL PANEL -->
        <div class="panel-header">
            <h2>Control de Usuarios</h2>
            <p class="subtitulo">Visualiza, busca y administra las cuentas directamente desde la base de datos</p>
        </div>

        <!-- BARRA DE HERRAMIENTAS: BUSCADOR Y BOTÓN AGREGAR -->
        <div class="flex-between mb-6" style="display: flex; justify-content: space-between; align-items: center; gap: 16px; flex-wrap: wrap;">
            
            <!-- Formulario de Búsqueda Nativo -->
            <form action="gestion_usuarios.jsp" method="GET" style="display: flex; gap: 8px; flex-grow: 1; max-width: 400px;">
                <input type="text" name="txtBuscar" value="<%= (txtBuscar != null) ? txtBuscar : "" %>" placeholder="🔍 Buscar por nombre o correo..." 
                       style="width: 100%; padding: 10px 14px; border: 1px solid #ccc; border-radius: var(--radio); font-family: var(--font-body);">
                <button type="submit" class="btn btn-primario" style="padding: 0 16px;">Buscar</button>
            </form>

            <!-- Botón Agregar Usuario -->
            <a href="registro.jsp" class="btn btn-naranja" style="text-decoration: none; display: inline-block; line-height: 40px; height: 40px; padding: 0 20px;">
                + Agregar Usuario
            </a>
        </div>

        <!-- TABLA DE USUARIOS PROVENIENTES DE XAMPP (MySQL) -->
        <div class="tabla-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>Nombre y Apellido</th>
                        <th>Correo Electrónico</th>
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
                            if (txtBuscar != null && !txtBuscar.trim().isEmpty()) {
                                sql = "SELECT id_usuario, nombre, apellido, correo FROM Usuario WHERE nombre LIKE ? OR apellido LIKE ? OR correo LIKE ?";
                                ps = cn.prepareStatement(sql);
                                String queryParam = "%" + txtBuscar.trim() + "%";
                                ps.setString(1, queryParam);
                                ps.setString(2, queryParam);
                                ps.setString(3, queryParam);
                            } else {
                                sql = "SELECT id_usuario, nombre, apellido, correo FROM Usuario";
                                ps = cn.prepareStatement(sql);
                            }

                            rs = ps.executeQuery();

                            while (rs.next()) {
                                tieneRegistros = true;
                                int idUsuario = rs.getInt("id_usuario");
                                String nombreCompleto = rs.getString("nombre") + " " + rs.getString("apellido");
                                String correo = rs.getString("correo");
                    %>
                                <tr>
                                    <td class="fw-600"><%= nombreCompleto %></td>
                                    <td><%= correo %></td>
                                    <td class="text-center">
                                        <div style="display: flex; gap: 12px; justify-content: center; align-items: center;">
                                            <!-- Botón Editar -->
                                            <a href="form_usuario.jsp?id=<%= idUsuario %>" 
                                               class="btn btn-ghost btn-sm" 
                                               style="text-decoration: none; width: 90px; text-align: center; box-sizing: border-box; display: inline-block;">
                                               Editar
                                            </a>
                                            
                                            <!-- Botón Eliminar modificado para abrir el Modal mediante JavaScript -->
                                            <button type="button" 
                                                    onclick="abrirModalEliminar(<%= idUsuario %>, '<%= nombreCompleto %>')"
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
                                <td colspan="3" style="color: red; padding: 15px;">⚠️ Error de conexión: <%= e.getMessage() %></td>
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
                                <td colspan="3" class="text-center text-mutado" style="padding: var(--sp-6);">No se encontraron usuarios registrados en el sistema.</td>
                            </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </section>
</main>

<!-- ==========================================================================
     VENTANA EMERGENTE (MODAL CONTENEDOR)
     ========================================================================== -->
<div id="modalEliminar" class="modal-overlay">
    <div class="modal-box">
        <h3>¿Confirmar eliminación?</h3>
        <p>¿Seguro que deseas eliminar al usuario <strong id="nombreUsuarioModal" style="color: #1a202c;"></strong>? Esta acción no se puede deshacer.</p>
        
        <div class="modal-botones">
            <!-- Cancelar cierra la ventana simplemente -->
            <button type="button" onclick="cerrarModalEliminar()" class="btn btn-ghost" style="width: 110px;">
                Cancelar
            </button>
            <!-- Confirmar envía el formulario interno para procesar el DELETE con Java -->
            <form action="gestion_usuarios.jsp" method="POST" id="formConfirmarEliminar">
                <input type="hidden" name="idEliminar" id="idEliminarInput">
                <button type="submit" class="btn btn-naranja" style="width: 110px; background-color: var(--naranja);">
                    Confirmar
                </button>
            </form>
        </div>
    </div>
</div>

<!-- Pie de página común -->
<jsp:include page="componentes/footer.jsp" />

<!-- ==========================================================================
     SCRIPTS JAVASCRIPT PARA CONTROLAR EL MODAL
     ========================================================================== -->
<script>
    const modal = document.getElementById('modalEliminar');
    const nombreTxt = document.getElementById('nombreUsuarioModal');
    const idInput = document.getElementById('idEliminarInput');

    function abrirModalEliminar(id, nombre) {
        nombreTxt.textContent = nombre; // Coloca el nombre del usuario dinámicamente en el texto
        idInput.value = id;             // Asigna el ID al campo oculto del formulario
        modal.classList.add('activo');  // Muestra el modal con la transición CSS
    }

    function cerrarModalEliminar() {
        modal.classList.remove('activo'); // Oculta el modal
    }

    // Permite cerrar el modal si el usuario hace clic afuera de la caja blanca
    window.onclick = function(event) {
        if (event.target === modal) {
            cerrarModalEliminar();
        }
    }
</script>

</body>
</html>