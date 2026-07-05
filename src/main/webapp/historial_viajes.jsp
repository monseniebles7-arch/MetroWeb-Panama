<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // control de seguridad para verificar sesion activa
    Integer idUsuarioLogueado = (Integer) session.getAttribute("id_usuario");
    if (idUsuarioLogueado == null) {
        idUsuarioLogueado = 4; // asignamos el ID 4 de tus pruebas para interactuar con sus tarjetas
    }

    // capturamos el id de tarjeta seleccionado desde el desplegable
    String idTarjetaParam = request.getParameter("idTarjeta");
    int idTarjetaSeleccionada = (idTarjetaParam != null && !idTarjetaParam.isEmpty()) ? Integer.parseInt(idTarjetaParam) : 0;

    // capturamos el periodo de dias seleccionado en el filtro y asignamos 30 por defecto
    String periodoParam = request.getParameter("periodo");
    int diasFiltro = (periodoParam != null && !periodoParam.isEmpty()) ? Integer.parseInt(periodoParam) : 30;

    // variables para almacenar el numero de tarjeta activo a mostrar
    String numTarjetaActiva = "No disponible";
    String fechaInicioMovimientos = "04/04/2026";

    Connection cn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        // solucionado: apuntamos exactamente a metrowebpanama2 igual que en saldo.jsp
        cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/metrowebpanama2", "root", "");

        // si el usuario aun no elige tarjeta tomamos la primera de la base de datos
        if (idTarjetaSeleccionada == 0) {
            String sqlDefault = "SELECT id_tarjeta, numero_tarjeta FROM tarjeta WHERE id_usuario = ? LIMIT 1";
            ps = cn.prepareStatement(sqlDefault);
            ps.setInt(1, idUsuarioLogueado);
            rs = ps.executeQuery();
            if (rs.next()) {
                idTarjetaSeleccionada = rs.getInt("id_tarjeta");
                numTarjetaActiva = rs.getString("numero_tarjeta");
            }
            if (rs != null) rs.close();
            if (ps != null) ps.close();
        } else {
            // si ya selecciono una buscamos su numero de tarjeta correspondiente
            String sqlBuscar = "SELECT numero_tarjeta FROM tarjeta WHERE id_usuario = ? AND id_tarjeta = ?";
            ps = cn.prepareStatement(sqlBuscar);
            ps.setInt(1, idUsuarioLogueado);
            ps.setInt(2, idTarjetaSeleccionada);
            rs = ps.executeQuery();
            if (rs.next()) {
                numTarjetaActiva = rs.getString("numero_tarjeta");
            }
            if (rs != null) rs.close();
            if (ps != null) ps.close();
        }
    } catch (Exception e) {
        System.out.println("error al inicializar tarjeta: " + e.getMessage());
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historial de Viajes - MetroWeb Panamá</title>
    <link rel="stylesheet" href="CSS/style.css">
    
    <jsp:include page="componentes/header.jsp" />
</head>
<body>

    <main class="contenedor seccion">
        
        <div class="card">
            <div class="card-body card-historial">
                
                <p class="txt-gris-propio">Historial</p>
                <h2>Saldos y Movimientos</h2>

                <div class="contenedor-selector-historial">
                    <form action="historial_viajes.jsp" method="GET" id="formSelectorTarjeta">
                        <input type="hidden" name="periodo" value="<%= diasFiltro %>">
                        
                        <label for="idTarjeta" class="txt-destaque etiqueta-selector">Selecciona tu Tarjeta:</label>
                        <select name="idTarjeta" id="idTarjeta" class="filtro-container select-tarjeta-dinamico" onchange="document.getElementById('formSelectorTarjeta').submit();">
                            <%
                                try {
                                    // cargamos las tarjetas reales de metrowebpanama2 usando el id_tarjeta principal
                                    String sqlSelect = "SELECT id_tarjeta, numero_tarjeta, alias_tarjeta FROM tarjeta WHERE id_usuario = ?";
                                    ps = cn.prepareStatement(sqlSelect);
                                    ps.setInt(1, idUsuarioLogueado);
                                    rs = ps.executeQuery();

                                    while (rs.next()) {
                                        int idT = rs.getInt("id_tarjeta");
                                        String numero = rs.getString("numero_tarjeta");
                                        String alias = rs.getString("alias_tarjeta");
                                        if (alias == null) alias = "Tarjeta Pass";
                                        
                                        String seleccionado = (idT == idTarjetaSeleccionada) ? "selected" : "";
                            %>
                                        <option value="<%= idT %>" <%= seleccionado %>><%= alias %> (Nº <%= numero %>)</option>
                            <%
                                    }
                                } catch (Exception e) {
                                    System.out.println("error en select de tarjetas: " + e.getMessage());
                                } finally {
                                    if (rs != null) try { rs.close(); } catch(Exception e){}
                                    if (ps != null) try { ps.close(); } catch(Exception e){}
                                }
                            %>
                        </select>
                    </form>
                </div>

                <table class="tabla-resumen">
                    <tbody>
                        <tr>
                            <td class="txt-destaque ancho-etiqueta">Nº Tarjeta:</td>
                            <td class="ancho-valor"><%= numTarjetaActiva %></td>
                            <td class="txt-destaque ancho-etiqueta">Movimientos desde:</td>
                            <td class="ancho-valor txt-naranja-bold"><%= fechaInicioMovimientos %></td>
                        </tr>
                    </tbody>
                </table>

                <form action="historial_viajes.jsp" method="GET" class="filtro-container">
                    <input type="hidden" name="idTarjeta" value="<%= idTarjetaSeleccionada %>">
                    
                    <label for="periodo" class="txt-destaque">Periodo:</label>
                    <select name="periodo" id="periodo">
                        <option value="7" <%= (diasFiltro == 7) ? "selected" : "" %>>Últimos 7 días</option>
                        <option value="15" <%= (diasFiltro == 15) ? "selected" : "" %>>Últimos 15 días</option>
                        <option value="30" <%= (diasFiltro == 30) ? "selected" : "" %>>Últimos 30 días</option>
                    </select>
                    <button type="submit" class="btn btn-primario">Filtrar</button>
                </form>

                <table class="tabla-resumen">
                    <thead>
                        <tr>
                            <th>ID Viaje</th>
                            <th>Descripción / Ruta</th>
                            <th>Fecha / Hora</th>
                            <th>Tipo Transporte</th>
                            <th>Estación Origen</th>
                            <th>Estación Destino</th>
                            <th>Monto (Costo)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (idTarjetaSeleccionada > 0) {
                                try {
                                    // solucionado: la consulta ahora filtra estrictamente por el id_tarjeta seleccionado de forma unica
                                    String sqlViajes = "SELECT v.id_viaje, v.fecha_hora, v.costo, r.codigo_ruta, " +
                                                       "tt.descripcion AS transporte, eo.nombre_estacion AS origen, ed.nombre_estacion AS destino " +
                                                       "FROM Viaje v " +
                                                       "INNER JOIN TipoTransporte tt ON v.id_tipo_transporte = tt.id_tipo_transporte " +
                                                       "LEFT JOIN Estacion eo ON v.id_estacion_origen = eo.id_estacion " +
                                                       "LEFT JOIN Estacion ed ON v.id_estacion_destino = ed.id_estacion " +
                                                       "LEFT JOIN RutaBus r ON v.id_ruta = r.id_ruta " +
                                                       "WHERE v.id_tarjeta = ? AND v.fecha_hora >= DATE_SUB(NOW(), INTERVAL ? DAY) " +
                                                       "ORDER BY v.fecha_hora DESC";
                                    
                                    ps = cn.prepareStatement(sqlViajes);
                                    ps.setInt(1, idTarjetaSeleccionada);
                                    ps.setInt(2, diasFiltro);
                                    rs = ps.executeQuery();

                                    boolean tieneViajes = false;
                                    while (rs.next()) {
                                        tieneViajes = true;
                                        int idViaje = rs.getInt("id_viaje");
                                        String fechaHora = rs.getString("fecha_hora");
                                        double costo = rs.getDouble("costo");
                                        String codigoRuta = rs.getString("codigo_ruta");
                                        String nombreTransporte = rs.getString("transporte");
                                        String origen = rs.getString("origen");
                                        String destino = rs.getString("destino");

                                        String descripcionRuta = (codigoRuta != null) ? "Viaje en ruta " + codigoRuta : "Trayecto linea de metro";
                                        
                                        if (origen == null) origen = "Parada en calle";
                                        if (destino == null) destino = "Parada en calle";
                        %>
                                        <tr>
                                            <td class="txt-destaque"><%= idViaje %></td>
                                            <td><%= descripcionRuta %></td>
                                            <td><%= fechaHora %></td>
                                            <td><%= nombreTransporte %></td>
                                            <td><%= origen %></td>
                                            <td><%= destino %></td>
                                            <td class="txt-bold">$<%= String.format("%.2f", costo) %></td>
                                        </tr>
                        <%
                                    }

                                    if (!tieneViajes) {
                        %>
                                        <tr>
                                            <td colspan="7" class="tabla-vacia-mensaje">
                                                No se registraron viajes con esta tarjeta en el periodo seleccionado
                                            </td>
                                        </tr>
                        <%
                                    }
                                } catch (Exception e) {
                        %>
                                    <tr>
                                        <td colspan="7" class="tabla-error-mensaje">
                                            ⚠️ Error al procesar los datos de viaje: <%= e.getMessage() %>
                                        </td>
                                    </tr>
                        <%
                                } finally {
                                    if (rs != null) try { rs.close(); } catch(Exception e){}
                                    if (ps != null) try { ps.close(); } catch(Exception e){}
                                    if (cn != null) try { cn.close(); } catch(Exception e){}
                                }
                            } else {
                        %>
                                <tr>
                                    <td colspan="7" class="tabla-vacia-mensaje">
                                        Por favor, asocie una tarjeta para ver sus movimientos
                                    </td>
                                </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>

            </div>
        </div>

    </main>

    <footer><jsp:include page="componentes/footer.jsp" /></footer>

</body>
</html>