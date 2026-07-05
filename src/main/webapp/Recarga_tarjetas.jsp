<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // =========================================================================
    // 1. CONFIGURACIÓN DE SESIÓN (CÓDIGO SERVIDOR - JAVA)
    // =========================================================================
    
    // Recuperamos el ID del usuario logueado desde la sesión activa
    Integer idUsuarioLogueado = (Integer) session.getAttribute("id_usuario");
    if (idUsuarioLogueado == null) {
        idUsuarioLogueado = 2; // ID de respaldo (coincidente con tus muestras de prueba)
    }

    // Inicializamos las variables de conexión para cargar el dropdown de tarjetas
    Connection cn = null;
    PreparedStatement psTarjetas = null;
    ResultSet rsTarjetas = null;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recargar Tarjeta - MetroWeb Panamá</title>
    <link class="stylesheet" href="CSS/style.css">
</head>
<body>

    <%-- jsp:include: Carga modular del componente header.jsp (Menú superior) --%>
    <jsp:include page="componentes/header.jsp" />

    <%-- Etiqueta <main>: Delimita el contenido central de la interfaz de recargas --%>
    <main class="contenedor seccion">
        
        <%-- Bloque superior informativo (Banner o Card Accent) --%>
        <div class="card card-accent">
            <div class="card-body">
                <h3>Recargar Tarjeta Metro / Metrobús</h3>
                <p class="mt-2 text-sm">
                    Selecciona tu tarjeta, introduce el monto y los datos de tu método de pago para procesar tu recarga al instante.
                </p>
            </div>
        </div>

        <%
            // Captura de parámetros de error que provengan del Servlet encargado de procesar la recarga monetaria
            String error = request.getParameter("error");
            if (error != null) {
                if (error.equals("1")) {
        %>
                    <%-- Despliegue de alerta visual en caso de fallo en la validación bancaria --%>
                    <div class="alerta alerta-error" style="background-color: #f8d7da; color: #721c24; padding: 15px; border-radius: 8px; margin-top: 20px; border: 1px solid #f5c6cb;">
                        ❌ No se pudo procesar la recarga. Inténtalo de nuevo.
                    </div>
        <%
                } else if (error.equals("db")) {
        %>
                    <%-- Despliegue de alerta visual en caso de fallo crítico de comunicación con MySQL --%>
                    <div class="alerta alerta-error" style="background-color: #f8d7da; color: #721c24; padding: 15px; border-radius: 8px; margin-top: 20px; border: 1px solid #f5c6cb;">
                        ❌ Error de conexión con la base de datos de MetroWeb.
                    </div>
        <%
                }
            }
        %>

        <%-- Formulario HTML: Despacha la petición mediante POST hacia el controlador ProcesarRecargaServlet --%>
        <form action="ProcesarRecargaServlet" method="post" style="margin-top: 40px;">
            
            <%-- Sección 1: Datos de la tarjeta de transporte público --%>
            <h4 style="color: var(--naranja); margin-bottom: 20px; border-bottom: 1px solid var(--gris-borde); padding-bottom: 8px;">
                1. Datos de la Tarjeta
            </h4>
            
            <div class="perfil-grid">
                <%-- Dropdown dinámico enlazado con MySQL --%>
                <div class="grupo grupo-full">
                    <label for="tarjeta" class="fw-600">Selecciona tu tarjeta registrada</label>
                    <select id="tarjeta" name="idTarjeta" required style="width: 100%; padding: 10px; border: 1px solid var(--gris-borde); border-radius: 4px; background: white;">
                        <option value="" disabled selected>-- Elige una tarjeta --</option>
                        
                        <%
                            // APERTURA DE CONEXIÓN: Extraemos únicamente las tarjetas pertenecientes al usuario activo
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/metrowebpanama2", "root", "");
                                
                                // SQL dinámico con base en los atributos de tu tabla 'Tarjeta'
                                String sqlTarjetas = "SELECT id_tarjeta, numero_tarjeta, alias_tarjeta FROM Tarjeta WHERE id_usuario = ?";
                                psTarjetas = cn.prepareStatement(sqlTarjetas);
                                psTarjetas.setInt(1, idUsuarioLogueado);
                                rsTarjetas = psTarjetas.executeQuery();
                                
                                // Bucle while para iterar e imprimir cada tarjeta en un <option>
                                while(rsTarjetas.next()) {
                                    int idTarj = rsTarjetas.getInt("id_tarjeta");
                                    String numTarj = rsTarjetas.getString("numero_tarjeta");
                                    String aliasTarj = rsTarjetas.getString("alias_tarjeta");
                        %>
                                    <%-- Mapeamos el 'id_tarjeta' como value principal para que viaje al Servlet --%>
                                    <option value="<%= idTarj %>"><%= aliasTarj %> - N° <%= numTarj %></option>
                        <%
                                }
                            } catch (Exception e) {
                                System.out.println("⚠️ Error al cargar select de tarjetas: " + e.getMessage());
                            } finally {
                                // Cierre parcial de los recursos de lectura del selector
                                if (rsTarjetas != null) try { rsTarjetas.close(); } catch(Exception e){}
                                if (psTarjetas != null) try { psTarjetas.close(); } catch(Exception e){}
                                if (cn != null) try { cn.close(); } catch(Exception e){}
                            }
                        %>
                    </select>
                </div>

                <%-- Selector predefinido del monto monetario a transferir --%>
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

            <%-- Sección 2: Captura del método de pago simulado (Pasarela Bancaria) --%>
            <h4 style="color: var(--naranja); margin-top: 40px; margin-bottom: 20px; border-bottom: 1px solid var(--gris-borde); padding-bottom: 8px;">
                2. Información de Pago
            </h4>

            <div class="perfil-grid">
                <%-- Input del titular de la tarjeta de crédito o débito --%>
                <div class="grupo grupo-full">
                    <label for="titular" class="fw-600">Nombre del Titular (Como aparece en la tarjeta)</label>
                    <input type="text" id="titular" name="titular" placeholder="Juan Pérez" required>
                </div>

                <%-- Input del número de cuenta de la tarjeta bancaria --%>
                <div class="grupo grupo-full">
                    <label for="numeroTarjeta" class="fw-600">Número de Tarjeta de Pago</label>
                    <input type="text" id="numeroTarjeta" name="numeroTarjeta" placeholder="4000 1234 5678 9010" maxlength="19" required>
                </div>

                <%-- Input de la fecha de caducidad --%>
                <div class="grupo">
                    <label for="expiracion" class="fw-600">Fecha de Expiración</label>
                    <input type="text" id="expiracion" name="expiracion" placeholder="MM/AA" maxlength="5" required>
                </div>

                <%-- Input oculto/protegido para el código verificador (CVV) --%>
                <div class="grupo">
                    <label for="cvv" class="fw-600">Código de Seguridad (CVV)</label>
                    <input type="password" id="cvv" name="cvv" placeholder="123" maxlength="3" required>
                </div>
            </div>

            <%-- Bloque inferior de botones de control y envío --%>
            <div class="perfil-botones" style="margin-top: 40px; display: flex; justify-content: center; gap: 15px;">
                <%-- Botón Cancelar redirige limpiamente a la sección del perfil seguro --%>
                <a href="perfil.jsp" class="btn btn-secundario" style="text-decoration: none; text-align: center; line-height: 2.4;">
                    Cancelar
                </a>
                <%-- Botón de confirmación que efectúa la petición POST hacia ProcesarRecargaServlet --%>
                <button class="btn btn-principal" type="submit">
                    Confirmar Recarga
                </button>
            </div>

        </form>
    </main>

    <%-- jsp:include: Carga modular de la estructura del pie de página común (footer.jsp) --%>
    <jsp:include page="componentes/footer.jsp" />

</body>
</html>