<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // 1. Control de seguridad: Redirigir al login si no hay sesión activa
    if (session.getAttribute("id_usuario") == null) {
        response.sendRedirect("home.jsp");
        return;
    }

    int idUsuarioLogueado = Integer.parseInt(session.getAttribute("id_usuario").toString());
    String numTarjetaParam = request.getParameter("num_tarjeta");

    // Si entran a la página sin un número de tarjeta en la URL, los devolvemos
    if (numTarjetaParam == null || numTarjetaParam.trim().isEmpty()) {
        response.sendRedirect("usuario_inicio.jsp");
        return;
    }

    String numTarjeta = numTarjetaParam.trim();
    String aliasTarjeta = "";
    String tipoTarjetaDescripcion = "";
    String mensajeAlerta = null;
    boolean esExito = false;

    Connection cn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    // 2. Procesar el POST: Modificar o Eliminar la tarjeta
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/MetroWebPanama2", "root", "");

            if ("guardar".equals(accion)) {
                String nuevoAlias = request.getParameter("aliasTarjeta");
                if (nuevoAlias != null && !nuevoAlias.trim().isEmpty()) {
                    String sqlUpdate = "UPDATE Tarjeta SET alias_tarjeta = ? WHERE numero_tarjeta = ? AND id_usuario = ?";
                    ps = cn.prepareStatement(sqlUpdate);
                    ps.setString(1, nuevoAlias.trim());
                    ps.setString(2, numTarjeta);
                    ps.setInt(3, idUsuarioLogueado);
                    ps.executeUpdate();
                    esExito = true;
                }
            } else if ("borrar".equals(accion)) {
                String sqlDelete = "DELETE FROM Tarjeta WHERE numero_tarjeta = ? AND id_usuario = ?";
                ps = cn.prepareStatement(sqlDelete);
                ps.setString(1, numTarjeta);
                ps.setInt(2, idUsuarioLogueado);
                ps.executeUpdate();
                esExito = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
            mensajeAlerta = "⚠️ Error al procesar la solicitud: " + e.getMessage();
        } finally {
            if (ps != null) try { ps.close(); } catch(Exception e){}
            if (cn != null) try { cn.close(); } catch(Exception e){}
        }

        if (esExito) {
            response.sendRedirect("usuario_inicio.jsp");
            return;
        }
    }

    // 3. Cargar los datos actuales de la tarjeta para mostrarlos en los inputs
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/MetroWebPanama2", "root", "");

        String sqlSelect = "SELECT t.alias_tarjeta, tt.descripcion FROM Tarjeta t " +
                           "INNER JOIN TipoTarjeta tt ON t.id_tipo_tarjeta = tt.id_tipo_tarjeta " +
                           "WHERE t.numero_tarjeta = ? AND t.id_usuario = ?";
        ps = cn.prepareStatement(sqlSelect);
        ps.setString(1, numTarjeta);
        ps.setInt(2, idUsuarioLogueado);
        rs = ps.executeQuery();

        if (rs.next()) {
            aliasTarjeta = rs.getString("alias_tarjeta");
            tipoTarjetaDescripcion = rs.getString("descripcion");
        } else {
            response.sendRedirect("usuario_inicio.jsp");
            return;
        }
    } catch (Exception e) {
        mensajeAlerta = "⚠️ Error al cargar los datos de la tarjeta: " + e.getMessage();
    } finally {
        if (rs != null) try { rs.close(); } catch(Exception e){}
        if (ps != null) try { ps.close(); } catch(Exception e){}
        if (cn != null) try { cn.close(); } catch(Exception e){}
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Gestionar Tarjeta — MetroWeb Panamá</title>
    <link rel="stylesheet" href="CSS/style.css"/>
</head>
<body>

    <jsp:include page="componentes/header.jsp" />

    <main class="seccion-gestion-azul">
        <div class="contenedor-formulario-compacto">
            <div class="caja-formulario-blanca">
                
                <h3>Gestionar Tarjeta</h3>
                <p class="subtitulo-gestion">Modifica o remueve la tarjeta seleccionada</p>

                <% if (mensajeAlerta != null) { %>
                    <div class="alerta-error-gestion">
                        <%= mensajeAlerta %>
                    </div>
                <% } %>

                <form action="editar_datos_tarjeta.jsp?num_tarjeta=<%= numTarjeta %>" method="POST">
                    
                    <div class="campo-gestion">
                        <label for="numTarjeta">Número de Tarjeta</label>
                        <input 
                            type="text" 
                            id="numTarjeta" 
                            value="<%= numTarjeta %>" 
                            disabled 
                            class="input-solo-lectura"
                        />
                    </div>

                    <div class="campo-gestion espacio-campos">
                        <label for="tipoTarjeta">Tipo de Usuario</label>
                        <input 
                            type="text" 
                            id="tipoTarjeta" 
                            value="<%= tipoTarjetaDescripcion %>" 
                            disabled 
                            class="input-solo-lectura texto-negrita"
                        />
                    </div>

                    <div class="campo-gestion espacio-campos">
                        <label for="aliasTarjeta">Nombre personalizado (Alias)</label>
                        <input 
                            type="text" 
                            id="aliasTarjeta" 
                            name="aliasTarjeta" 
                            value="<%= aliasTarjeta %>" 
                            required
                        />
                    </div>

                    <input type="hidden" name="accion" id="accionFormulario" value="guardar" />
                    
                    <button type="submit" class="btn btn-primario btn-full boton-guardar" onclick="document.getElementById('accionFormulario').value='guardar';">
                        Guardar Cambios
                    </button>
                    
                    <button type="submit" class="btn btn-full boton-borrar-rojo" onclick="if(confirm('¿Seguro que deseas eliminar definitivamente esta tarjeta?')){ document.getElementById('accionFormulario').value='borrar'; } else { return false; }">
                        Borrar Tarjeta
                    </button>
                    
                    <a href="usuario_inicio.jsp" class="link-volver-atras">
                        Volver al panel de control
                    </a>
                </form>
            </div>
        </div>
    </main>

    <jsp:include page="componentes/footer.jsp" />

</body>
</html>