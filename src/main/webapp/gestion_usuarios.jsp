<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    // 1. LEER EL FILTRO DE BÚSQUEDA (SI EXISTE)
    request.setCharacterEncoding("UTF-8");
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
            
            <!-- Formulario de Búsqueda Nativo (Filtro que recarga la misma página) -->
            <form action="admin_usuarios.jsp" method="GET" style="display: flex; gap: 8px; flex-grow: 1; max-width: 400px;">
                <input type="text" name="txtBuscar" value="<%= (txtBuscar != null) ? txtBuscar : "" %>" placeholder="🔍 Buscar por nombre o correo..." 
                       style="width: 100%; padding: 10px 14px; border: 1px solid #ccc; border-radius: var(--radio); font-family: var(--font-body);">
                <button type="submit" class="btn btn-primario" style="padding: 0 16px;">Buscar</button>
            </form>

            <!-- Botón Agregar Usuario -->
            <a href="form_usuario.jsp" class="btn btn-naranja" style="text-decoration: none; display: inline-block; line-height: 40px; height: 40px; padding: 0 20px;">
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
                            // Conexión idéntica a tu archivo de registro en XAMPP
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/metrowebpanama2", "root", "");

                            String sql;
                            if (txtBuscar != null && !txtBuscar.trim().isEmpty()) {
                                // SQL con Filtro si el administrador buscó algo
                                sql = "SELECT id_usuario, nombre, apellido, correo FROM Usuario WHERE nombre LIKE ? OR apellido LIKE ? OR correo LIKE ?";
                                ps = cn.prepareStatement(sql);
                                String queryParam = "%" + txtBuscar.trim() + "%";
                                ps.setString(1, queryParam);
                                ps.setString(2, queryParam);
                                ps.setString(3, queryParam);
                            } else {
                                // SQL por defecto
                                sql = "SELECT id_usuario, nombre, apellido, correo FROM Usuario";
                                ps = cn.prepareStatement(sql);
                            }

                            rs = ps.executeQuery();

                            // Bucle directo en el ResultSet para pintar las filas HTML
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
                                        <!-- Enlaces pasando el ID por la URL de forma nativa -->
                                        <a href="form_usuario.jsp?id=<%= idUsuario %>" class="btn btn-ghost btn-sm" style="text-decoration: none; margin-right: 4px;">Editar</a>
                                        <a href="eliminar_usuario.jsp?id=<%= idUsuario %>" class="btn btn-outline btn-sm" style="color: var(--naranja); border-color: var(--naranja); text-decoration: none;">Eliminar</a>
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
                            // Cierre seguro de recursos de la BD
                            if (rs != null) try { rs.close(); } catch(Exception e){}
                            if (ps != null) try { ps.close(); } catch(Exception e){}
                            if (cn != null) try { cn.close(); } catch(Exception e){}
                        }

                        // Si la consulta terminó y no arrojó ninguna fila
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

<!-- Pie de página común -->
<jsp:include page="componentes/footer.jsp" />

</body>
</html>