<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // =========================================================================
    // 1. PROCESAR LA RECARGA (CUANDO EL USUARIO PRESIONA CONFIRMAR RECARGA)
    // =========================================================================
    String idTarjetaPost = request.getParameter("idTarjeta");
    String montoPost = request.getParameter("monto");

    if (idTarjetaPost != null && montoPost != null) {
        Integer idUsuarioLogueado = (Integer) session.getAttribute("id_usuario");
        if (idUsuarioLogueado == null) {
            idUsuarioLogueado = 2; // ID de respaldo para tus pruebas locales
        }

        Connection cnProc = null;
        PreparedStatement psUpdate = null;
        PreparedStatement psInsert = null;

        try {
            int idTarjeta = Integer.parseInt(idTarjetaPost);
            double montoRecarga = Double.parseDouble(montoPost);

            Class.forName("com.mysql.cj.jdbc.Driver");
            cnProc = DriverManager.getConnection("jdbc:mysql://localhost:3306/metrowebpanama2", "root", "");
            
            // Transacción segura para ejecutar ambas operaciones juntas
            cnProc.setAutoCommit(false);

            // ACCIÓN 1: CORREGIDO 'tarjeta' en minúscula según tu phpMyAdmin
            String sqlUpdate = "UPDATE tarjeta SET saldo = saldo + ? WHERE id_tarjeta = ?";
            psUpdate = cnProc.prepareStatement(sqlUpdate);
            psUpdate.setDouble(1, montoRecarga);
            psUpdate.setInt(2, idTarjeta);
            psUpdate.executeUpdate();

            // ACCIÓN 2: CORREGIDO 'recarga' en minúscula y el nombre del campo 'id_tarjeta'
            String sqlInsert = "INSERT INTO recarga (monto, fecha_hora, id_metodo, id_usuario, id_tarjeta) VALUES (?, NOW(), 1, ?, ?)";
            psInsert = cnProc.prepareStatement(sqlInsert);
            psInsert.setDouble(1, montoRecarga);
            psInsert.setInt(2, idUsuarioLogueado);
            psInsert.setInt(3, idTarjeta);
            psInsert.executeUpdate();

            cnProc.commit();

            // Redirección directa al menú principal tras el éxito
            response.sendRedirect("usuario_inicio.jsp");
            return;

        } catch (Exception e) {
            if (cnProc != null) { try { cnProc.rollback(); } catch (Exception ex) {} }
            System.out.println("❌ Error procesando recarga: " + e.getMessage());
            response.sendRedirect("Recarga_tarjetas.jsp?error=db");
            return;
        } finally {
            if (psUpdate != null) try { psUpdate.close(); } catch(Exception e){}
            if (psInsert != null) try { psInsert.close(); } catch(Exception e){}
            if (cnProc != null) try { cnProc.close(); } catch(Exception e){}
        }
    }

    // =========================================================================
    // 2. CONFIGURACIÓN INICIAL PARA CARGAR LAS TARJETAS EN EL DROPDOWN
    // =========================================================================
    Integer idUsuarioLogueado = (Integer) session.getAttribute("id_usuario");
    if (idUsuarioLogueado == null) {
        idUsuarioLogueado = 2;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recargar Tarjeta - MetroWeb Panamá</title>
    <link rel="stylesheet" href="CSS/style.css">
</head>
<body>

    <jsp:include page="componentes/header.jsp" />

    <main class="contenedor seccion">
        
        <div class="card card-accent">
            <div class="card-body">
                <h3>Recargar Tarjeta Metro / Metrobús</h3>
                <p class="mt-2 text-sm">
                    Selecciona tu tarjeta, introduce el monto y los datos de tu método de pago para procesar tu recarga al instante.
                </p>
            </div>
        </div>

        <%
            String error = request.getParameter("error");
            if (error != null) {
                if (error.equals("1")) {
        %>
                    <div class="alerta alerta-error" style="background-color: #f8d7da; color: #721c24; padding: 15px; border-radius: 8px; margin-top: 200px; border: 1px solid #f5c6cb;">
                        ❌ No se pudo procesar la recarga. Inténtalo de nuevo.
                    </div>
        <%
                } else if (error.equals("db")) {
        %>
                    <div class="alerta alerta-error" style="background-color: #f8d7da; color: #721c24; padding: 15px; border-radius: 8px; margin-top: 20px; border: 1px solid #f5c6cb;">
                        ❌ Error de conexión o inconsistencia en la base de datos de MetroWeb.
                    </div>
        <%
                }
            }
        %>

        <form action="Recarga_tarjetas.jsp" method="post" style="margin-top: 40px;">
            
            <h4 style="color: var(--naranja); margin-bottom: 20px; border-bottom: 1px solid var(--gris-borde); padding-bottom: 8px;">
                1. Datos de la Tarjeta
            </h4>
            
            <div class="perfil-grid">
                <div class="grupo grupo-full">
                    <label for="tarjeta" class="fw-600">Selecciona tu tarjeta registrada</label>
                    <select id="tarjeta" name="idTarjeta" required style="width: 100%; padding: 10px; border: 1px solid var(--gris-borde); border-radius: 4px; background: white;">
                        <option value="" disabled selected>-- Elige una tarjeta --</option>
                        
                        <%
                            Connection cn = null;
                            PreparedStatement psTarjetas = null;
                            ResultSet rsTarjetas = null;
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/metrowebpanama2", "root", "");
                                
                                // CORREGIDO: 'tarjeta' en minúscula para acoplarse a tu entorno
                                String sqlTarjetas = "SELECT id_tarjeta, numero_tarjeta, alias_tarjeta FROM tarjeta WHERE id_usuario = ?";
                                psTarjetas = cn.prepareStatement(sqlTarjetas);
                                psTarjetas.setInt(1, idUsuarioLogueado);
                                rsTarjetas = psTarjetas.executeQuery();
                                
                                while(rsTarjetas.next()) {
                                    int idTarj = rsTarjetas.getInt("id_tarjeta");
                                    String numTarj = rsTarjetas.getString("numero_tarjeta");
                                    String aliasTarj = rsTarjetas.getString("alias_tarjeta");
                        %>
                                    <option value="<%= idTarj %>"><%= aliasTarj %> - N° <%= numTarj %></option>
                        <%
                                }
                            } catch (Exception e) {
                                System.out.println("❌ Error cargando las tarjetas en el select: " + e.getMessage());
                            } finally {
                                if (rsTarjetas != null) try { rsTarjetas.close(); } catch(Exception e){}
                                if (psTarjetas != null) try { psTarjetas.close(); } catch(Exception e){}
                                if (cn != null) try { cn.close(); } catch(Exception e){}
                            }
                        %>
                    </select>
                </div>

                <div class="grupo grupo-full">
                    <label for="monto" class="fw-600">Monto a recargar (USD)</label>
                    <select id="monto" name="monto" required style="width: 100%; padding: 10px; border: 1px solid var(--gris-borde); border-radius: 4px; background: white;">
                        <option value="2.00">$2.00</option>
                        <option value="5.00" selected>$5.00 (Recomendado)</option>
                        <option value="10.00">$10.00</option>
                        <option value="20.00">$20.00</option>
                    </select>
                </div>
            </div>

            <h4 style="color: var(--naranja); margin-top: 40px; margin-bottom: 20px; border-bottom: 1px solid var(--gris-borde); padding-bottom: 8px;">
                2. Información de Pago
            </h4>

            <div class="perfil-grid">
                <div class="grupo grupo-full">
                    <label for="titular" class="fw-600">Nombre del Titular (Como aparece en la tarjeta)</label>
                    <input type="text" id="titular" name="titular" placeholder="Juan Pérez" required>
                </div>

                <div class="grupo grupo-full">
                    <label for="numeroTarjeta" class="fw-600">Número de Tarjeta de Pago</label>
                    <input type="text" id="numeroTarjeta" name="numeroTarjeta" placeholder="4000 1234 5678 9010" maxlength="19" required>
                </div>

                <div class="grupo">
                    <label for="expiracion" class="fw-600">Fecha de Expiración</label>
                    <input type="text" id="expiracion" name="expiracion" placeholder="MM/AA" maxlength="5" required>
                </div>

                <div class="grupo">
                    <label for="cvv" class="fw-600">Código de Seguridad (CVV)</label>
                    <input type="password" id="cvv" name="cvv" placeholder="123" maxlength="3" required>
                </div>
            </div>

            <div class="perfil-botones" style="margin-top: 40px; display: flex; justify-content: center; gap: 15px;">
                <a href="usuario_inicio.jsp" class="btn btn-secundario" style="text-decoration: none; text-align: center; line-height: 2.4;">
                    Cancelar
                </a>
                
                <button class="btn" type="submit" style="background-color: #e8610a; color: #ffffff; padding: 12px 32px; border-radius: 8px; font-weight: 600; font-size: 15px; border: none; cursor: pointer; box-shadow: 0 4px 12px rgba(232, 97, 10, 0.3); transition: background-color 0.2s;">
                    Confirmar Recarga
                </button>
            </div>

        </form>
    </main>

    <jsp:include page="componentes/footer.jsp" />

</body>
</html>