<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // 1. Control de seguridad: Si no hay usuario en sesión, redirige al Login
    if (session.getAttribute("id_usuario") == null) {
        response.sendRedirect("home.jsp");
        return;
    }
    
    int idUsuario = Integer.parseInt(session.getAttribute("id_usuario").toString());
    String nombreUsuario = (String) session.getAttribute("nombre_usuario");

    Connection cn = null;
    PreparedStatement psCount = null;
    ResultSet rsCount = null;
    int cantidadTarjetas = 0;

    // 2. Verificar cuántas tarjetas posee el usuario
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/MetroWebPanama2", "root", "");

        String sqlCount = "SELECT COUNT(*) AS total FROM Tarjeta WHERE id_usuario = ?";
        psCount = cn.prepareStatement(sqlCount);
        psCount.setInt(1, idUsuario);
        rsCount = psCount.executeQuery();

        if (rsCount.next()) {
            cantidadTarjetas = rsCount.getInt("total");
        }
    } catch (Exception e) {
        System.out.println("ERROR EN CONTEO DE TARJETAS: " + e.getMessage());
        cantidadTarjetas = -1; 
    } finally {
        if (rsCount != null) try { rsCount.close(); } catch(Exception e){}
        if (psCount != null) try { psCount.close(); } catch(Exception e){}
        if (cn != null) try { cn.close(); } catch(Exception e){}
    }

    // 3. Redirección automática si no tiene tarjetas
    if (cantidadTarjetas == 0) {
        response.sendRedirect("agregar-tarjeta.jsp");
        return;
    }

    PreparedStatement ps = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Tarjetas - MetroWeb Panamá</title>
    <link rel="stylesheet" href="CSS/style.css">
</head>
<body>

    <jsp:include page="componentes/header.jsp" />

    <main class="contenedor seccion">
        
        <div class="dashboard-bienvenida">
            <div>
                <p class="txt-gris-propio">Panel principal</p>
                <h2>¡Hola, <%= nombreUsuario %>!</h2>
            </div>
        </div>

        <div class="card">
            <div class="card-body card-historial">
                
                <h2 class="subtitulo-seccion">Mis Tarjetas Asociadas</h2>

                <div class="tarjetas-contenedor-grid">
                    
                    <%
                        try {
                            cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/MetroWebPanama2", "root", "");

                            String sql = "SELECT t.numero_tarjeta, t.alias_tarjeta, t.saldo, t.id_tipo_tarjeta, tt.descripcion AS nombre_tipo " +
                                         "FROM Tarjeta t " +
                                         "INNER JOIN TipoTarjeta tt ON t.id_tipo_tarjeta = tt.id_tipo_tarjeta " +
                                         "WHERE t.id_usuario = ?";
                            
                            ps = cn.prepareStatement(sql);
                            ps.setInt(1, idUsuario);
                            rs = ps.executeQuery();

                            while (rs.next()) {
                                String numTarjeta = rs.getString("numero_tarjeta");
                                String aliasTarjeta = rs.getString("alias_tarjeta");
                                double saldo = rs.getDouble("saldo");
                                String tipoDesc = rs.getString("nombre_tipo");
                                int idTipoTarjeta = rs.getInt("id_tipo_tarjeta");

                                // Manejo dinámico de colores sólidos
                                String claseColor = "tarjeta-solida-azul"; 
                                if (idTipoTarjeta == 2) {
                                    claseColor = "tarjeta-solida-naranja"; 
                                } else if (idTipoTarjeta == 3) {
                                    claseColor = "tarjeta-solida-verde"; 
                                }
                    %>
                                <div class="tarjeta-transporte <%= claseColor %>">
                                    <div class="tarjeta-header">
                                        <div>
                                            <div class="tarjeta-alias"><%= aliasTarjeta %></div>
                                            <div class="tarjeta-numero">Nº <%= numTarjeta %></div>
                                        </div>
                                        
                                        <div class="tarjeta-gestion-links">
                                            <a href="editar_datos_tarjeta.jsp?num_tarjeta=<%= numTarjeta %>" class="link-gestion">Editar</a>
                                        </div>
                                    </div>
                                    
                                    <div class="tarjeta-body-saldo">
                                        <div class="tarjeta-saldo-label"><%= tipoDesc %> — Saldo Disponible</div>
                                        <div class="tarjeta-saldo-monto">$<%= String.format("%.2f", saldo) %></div>
                                    </div>
                                    
                                    <a href="Recarga_tarjetas.jsp?num_tarjeta=<%= numTarjeta %>" class="btn-recarga-tarjeta">
                                        Recargar esta tarjeta
                                    </a>
                                </div>
                    <%
                            }
                        } catch (Exception e) {
                    %>
                            <div class="alerta alerta-error">
                                ⚠️ Error al cargar el sistema de tarjetas: <%= e.getMessage() %>
                            </div>
                    <%
                        } finally {
                            if (rs != null) try { rs.close(); } catch(Exception e){}
                            if (ps != null) try { ps.close(); } catch(Exception e){}
                            if (cn != null) try { cn.close(); } catch(Exception e){}
                        }
                    %>

                    <a href="agregar-tarjeta.jsp" class="tarjeta-agregar-nueva">
                        <span class="tarjeta-agregar-icono">+</span>
                        Agregar nueva tarjeta
                    </a>

                </div>

            </div>
        </div>

    </main>

    <jsp:include page="componentes/footer.jsp" />

</body>
</html>