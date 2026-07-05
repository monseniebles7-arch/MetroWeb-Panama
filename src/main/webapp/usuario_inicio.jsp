<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Control de seguridad: Si no hay usuario en sesión, redirige al Home
    Integer idUsuarioLogueado = (Integer) session.getAttribute("id_usuario");
    if (idUsuarioLogueado == null) {
        response.sendRedirect("home.jsp");
        return;
    }
    String nombreUsuario = (String) session.getAttribute("nombre_usuario");
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
                <p class="txt-gris-propio">Panel de Control</p>
                <h2>¡Hola, <%= nombreUsuario %>!</h2>
            </div>
        </div>

        <h3>Mis Tarjetas Asociadas</h3>

        <div class="tarjetas-contenedor-grid">
            
            <%
                Connection cn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/metrowebpanama2", "root", "");
                    
                    // Consultamos las tarjetas asociadas al usuario logueado usando la tabla en minúsculas
                    String sql = "SELECT id_tarjeta, numero_tarjeta, alias_tarjeta, saldo FROM tarjeta WHERE id_usuario = ?";
                    ps = cn.prepareStatement(sql);
                    ps.setInt(1, idUsuarioLogueado);
                    rs = ps.executeQuery();
                    
                    boolean tieneTarjetas = false;
                    int contador = 0;
                    
                    while(rs.next()) {
                        tieneTarjetas = true;
                        contador++;
                        
                        int idTarjeta = rs.getInt("id_tarjeta");
                        String numeroTarjeta = rs.getString("numero_tarjeta");
                        String aliasTarjeta = rs.getString("alias_tarjeta");
                        double saldo = rs.getDouble("saldo");
                        
                        // La primera tarjeta será la "Principal", las siguientes serán "Secundaria"
                        String tipoBadge = (contador == 1) ? "Principal" : "Secundaria";
            %>
                        <%-- TARJETA DINÁMICA --%>
                        <div class="tarjeta-transporte">
                            <div class="tarjeta-header">
                                <div>
                                    <%-- Usamos el alias de la tarjeta (Metro, Metrobús, Trabajo, etc.) --%>
                                    <span class="tarjeta-marca"><%= aliasTarjeta %></span>
                                    <div class="tarjeta-numero">Nº <%= numeroTarjeta %></div>
                                </div>
                                <span class="badge badge-azul"><%= tipoBadge %></span>
                            </div>
                            <div class="tarjeta-body-saldo">
                                <div class="tarjeta-saldo-label">Saldo Disponible</div>
                                <div class="tarjeta-saldo-monto">$<%= String.format("%.2f", saldo) %></div>
                            </div>
                            <a href="Recarga_tarjetas.jsp" class="btn-recarga-tarjeta">
                                Recargar esta tarjeta
                            </a>
                        </div>
            <%
                    }
                    
                    if (!tieneTarjetas) {
            %>
                        <div style="grid-column: span 2; padding: 20px; background: #f9f9f9; border-radius: 8px; border: 1px dashed var(--gris-borde); text-align: center;">
                            <p style="color: #666;">Aún no tienes tarjetas registradas.</p>
                        </div>
            <%
                    }
                    
                } catch(Exception e) {
                    System.out.println("❌ Error al cargar el panel de tarjetas: " + e.getMessage());
                } finally {
                    if (rs != null) try { rs.close(); } catch(Exception e){}
                    if (ps != null) try { ps.close(); } catch(Exception e){}
                    if (cn != null) try { cn.close(); } catch(Exception e){}
                }
            %>

            <%-- BOTÓN O TARJETA DE ACCESO DIRECTO --%>
            <a href="agregar-tarjeta.jsp" class="tarjeta-agregar-nueva">
                <span class="tarjeta-agregar-icono">+</span>
                Agregar nueva tarjeta
            </a>

        </div>

    </main>

    <jsp:include page="componentes/footer.jsp" />

</body>
</html>