<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // =========================================================================
    // 1. CONTROL DE SESIÓN Y CAPTURA DE PARÁMETROS
    // =========================================================================
    Integer idUsuarioLogueado = (Integer) session.getAttribute("id_usuario");
    if (idUsuarioLogueado == null) {
        idUsuarioLogueado = 4; // Ajustado al ID 4 (Luis) para coincidir con tus datos de prueba
    }

    // Capturamos la tarjeta seleccionada desde el menú desplegable
    String idTarjetaParam = request.getParameter("idTarjeta");
    int idTarjetaSeleccionada = (idTarjetaParam != null && !idTarjetaParam.isEmpty()) ? Integer.parseInt(idTarjetaParam) : 0;

    // Variables dinámicas para el estado de la tarjeta activa
    String nombreCompleto = "Usuario";
    String numTarjeta = "No registrada";
    String tipoTarjeta = "Regular";
    double saldoActual = 0.00;

    // Variables para el resumen dinámico de RECARGAS por mes
    double recargasMayo = 0.0, recargasJunio = 0.0, recargasJulio = 0.0;
    int cantMayo = 0, cantJunio = 0, cantJulio = 0;

    // Variables para el resumen dinámico de HISTORIAL DE USO (Buses y Metro)
    double usoMayo = 0.0, usoJunio = 0.0, usoJulio = 0.0;
    int valMayo = 0, valJunio = 0, valJulio = 0;

    Connection cn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/metrowebpanama2", "root", "");

        // =========================================================================
        // 2. OBTENER INFORMACIÓN DEL USUARIO (Independiente de la tarjeta)
        // =========================================================================
        String sqlUsuario = "SELECT nombre, apellido FROM Usuario WHERE id_usuario = ?";
        ps = cn.prepareStatement(sqlUsuario);
        ps.setInt(1, idUsuarioLogueado);
        rs = ps.executeQuery();
        if (rs.next()) {
            nombreCompleto = rs.getString("nombre") + " " + rs.getString("apellido");
        }
        rs.close();
        ps.close();

        // =========================================================================
        // 3. SELECCIÓN DE LA TARJETA POR DEFECTO (Si no se ha elegido ninguna aún)
        // =========================================================================
        if (idTarjetaSeleccionada == 0) {
            String sqlPrimera = "SELECT id_tarjeta FROM Tarjeta WHERE id_usuario = ? LIMIT 1";
            ps = cn.prepareStatement(sqlPrimera);
            ps.setInt(1, idUsuarioLogueado);
            rs = ps.executeQuery();
            if (rs.next()) {
                idTarjetaSeleccionada = rs.getInt("id_tarjeta");
            }
            rs.close();
            ps.close();
        }

        // =========================================================================
        // 4. CARGA DE DATOS Y ESTADÍSTICAS DE LA TARJETA SELECCIONADA
        // =========================================================================
        if (idTarjetaSeleccionada > 0) {
            
            // Datos generales de la tarjeta activa (Apuntando a la tabla correcta 'Tarjeta')
            String sqlTarjeta = "SELECT numero_tarjeta, saldo, alias_tarjeta FROM Tarjeta WHERE id_tarjeta = ? AND id_usuario = ?";
            ps = cn.prepareStatement(sqlTarjeta);
            ps.setInt(1, idTarjetaSeleccionada);
            ps.setInt(2, idUsuarioLogueado);
            rs = ps.executeQuery();
            if (rs.next()) {
                numTarjeta = rs.getString("numero_tarjeta");
                saldoActual = rs.getDouble("saldo");
                tipoTarjeta = rs.getString("alias_tarjeta") != null ? rs.getString("alias_tarjeta") : "MetroWeb Pass";
            }
            rs.close();
            ps.close();

            // Resumen de RECARGAS - Cuenta de forma automatizada tanto inserts como recargas de la página
            String sqlResumenRecargas = 
                "SELECT MONTH(fecha_hora) as mes, SUM(monto) as total_monto, COUNT(id_recarga) as total_cant " +
                "FROM Recarga " +
                "WHERE id_tarjeta = ? AND YEAR(fecha_hora) = 2026 AND MONTH(fecha_hora) IN (5, 6, 7) " +
                "GROUP BY MONTH(fecha_hora)";
            ps = cn.prepareStatement(sqlResumenRecargas);
            ps.setInt(1, idTarjetaSeleccionada);
            rs = ps.executeQuery();
            while (rs.next()) {
                int mes = rs.getInt("mes");
                if (mes == 5) { recargasMayo = rs.getDouble("total_monto"); cantMayo = rs.getInt("total_cant"); }
                else if (mes == 6) { recargasJunio = rs.getDouble("total_monto"); cantJunio = rs.getInt("total_cant"); }
                else if (mes == 7) { recargasJulio = rs.getDouble("total_monto"); cantJulio = rs.getInt("total_cant"); }
            }
            rs.close();
            ps.close();

            // Resumen de USO - Corregido apuntando a 'HistorialSaldo' y usando la columna exacta 'monto_usado'
            String sqlResumenUso = 
                "SELECT MONTH(fecha_hora) as mes, SUM(monto_usado) as total_uso, COUNT(id_historial) as total_val " +
                "FROM HistorialSaldo " +
                "WHERE id_tarjeta = ? AND YEAR(fecha_hora) = 2026 AND MONTH(fecha_hora) IN (5, 6, 7) " +
                "GROUP BY MONTH(fecha_hora)";
            ps = cn.prepareStatement(sqlResumenUso);
            ps.setInt(1, idTarjetaSeleccionada);
            rs = ps.executeQuery();
            while (rs.next()) {
                int mes = rs.getInt("mes");
                if (mes == 5) { usoMayo = rs.getDouble("total_uso"); valMayo = rs.getInt("total_val"); }
                else if (mes == 6) { usoJunio = rs.getDouble("total_uso"); valJunio = rs.getInt("total_val"); }
                else if (mes == 7) { usoJulio = rs.getDouble("total_uso"); valJulio = rs.getInt("total_val"); }
            }
        }

    } catch (Exception e) {
        System.out.println("❌ Error en saldo.jsp: " + e.getMessage());
    } finally {
        if (rs != null) try { rs.close(); } catch(Exception e){}
        if (ps != null) try { ps.close(); } catch(Exception e){}
        if (cn != null) try { cn.close(); } catch(Exception e){}
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Saldo y Movimientos - MetroWeb Panamá</title>
    <link rel="stylesheet" href="CSS/style.css">
</head>
<body>

    <jsp:include page="componentes/header.jsp" />

    <main class="contenedor seccion">
        
        <div class="card">
            <div class="card-body" style="padding: 40px;">
                
                <div style="margin-bottom: 25px; background: #fdf6f0; padding: 15px; border-radius: 8px; border: 1px solid var(--gris-borde);">
                    <form method="GET" action="saldo.jsp" id="formSeleccionarTarjeta">
                        <label for="idTarjeta" style="font-weight: 600; color: var(--azul); margin-right: 10px;">Visualizar Tarjeta:</label>
                        <select name="idTarjeta" id="idTarjeta" onchange="this.form.submit();" style="padding: 8px 12px; border-radius: 6px; border: 1px solid var(--gris-borde); background: white; font-weight: 500; cursor: pointer;">
                            <%
                                Connection cnSelect = null;
                                PreparedStatement psSelect = null;
                                ResultSet rsSelect = null;
                                try {
                                    cnSelect = DriverManager.getConnection("jdbc:mysql://localhost:3306/metrowebpanama2", "root", "");
                                    String sqlSelect = "SELECT id_tarjeta, numero_tarjeta, alias_tarjeta FROM Tarjeta WHERE id_usuario = ?";
                                    psSelect = cnSelect.prepareStatement(sqlSelect);
                                    psSelect.setInt(1, idUsuarioLogueado);
                                    rsSelect = psSelect.executeQuery();
                                    
                                    while(rsSelect.next()) {
                                        int idT = rsSelect.getInt("id_tarjeta");
                                        String numT = rsSelect.getString("numero_tarjeta");
                                        String aliasT = rsSelect.getString("alias_tarjeta");
                                        String seleccionado = (idT == idTarjetaSeleccionada) ? "selected" : "";
                            %>
                                        <option value="<%= idT %>" <%= seleccionado %>><%= aliasT %> - Nº <%= numT %></option>
                            <%
                                    }
                                } catch(Exception ex) {
                                    System.out.println("❌ Error en el dropdown de tarjetas: " + ex.getMessage());
                                } finally {
                                    if (rsSelect != null) try { rsSelect.close(); } catch(Exception e){}
                                    if (psSelect != null) try { psSelect.close(); } catch(Exception e){}
                                    if (cnSelect != null) try { cnSelect.close(); } catch(Exception e){}
                                }
                            %>
                        </select>
                    </form>
                </div>

                <p style="color: var(--gris-medio); font-size: 14px; margin-bottom: 5px; font-weight: 500;">Usuario</p>
                <h2 style="color: var(--azul); margin-bottom: 25px;">Estado de tarjeta</h2>

                <table class="tabla-resumen">
                    <tbody>
                        <tr>
                            <td class="txt-destaque" style="width: 20%;">Nombre:</td>
                            <td style="width: 30%;"><%= nombreCompleto %></td>
                            <td class="txt-destaque" style="width: 20%;">Num tarjeta:</td>
                            <td style="width: 30%;"><%= numTarjeta %></td>
                        </tr>
                        <tr>
                            <td class="txt-destaque">Tipo de tarjeta:</td>
                            <td><%= tipoTarjeta %></td>
                            <td class="txt-destaque">Saldo actual:</td>
                            <td style="color: var(--naranja); font-weight: bold; font-size: 16px;">$<%= String.format("%.2f", saldoActual) %></td>
                        </tr>
                    </tbody>
                </table>

                <div style="display: flex; justify-content: flex-end; margin-top: 5px; margin-bottom: 35px;">
                    <a href="Recarga_tarjetas.jsp" style="text-decoration: none; background-color: #e8610a; color: #ffffff; padding: 12px 28px; border-radius: 8px; font-weight: 600; font-size: 15px; display: inline-flex; align-items: center; gap: 8px; box-shadow: 0 4px 12px rgba(232, 97, 10, 0.2);">
                        Recargar Tarjeta
                    </a>
                </div>

                <h2 style="color: var(--azul); margin-top: 20px; margin-bottom: 25px;">Resumen del último trimestre</h2>

                <%-- TABLA 1: USO DE BUSES Y METRO --%>
                <table class="tabla-resumen">
                    <thead>
                        <tr>
                            <th colspan="4" class="tabla-header-central">USO DE BUSES Y METRO</th>
                        </tr>
                        <tr>
                            <th>Mes</th>
                            <th>Mayo</th>
                            <th>Junio</th>
                            <th>Julio</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="txt-destaque">Monto utilizado</td>
                            <td>$<%= String.format("%.2f", usoMayo) %></td>
                            <td>$<%= String.format("%.2f", usoJunio) %></td>
                            <td>$<%= String.format("%.2f", usoJulio) %></td>
                        </tr>
                        <tr>
                            <td class="txt-destaque">Num de validaciones</td>
                            <td><%= valMayo %></td>
                            <td><%= valJunio %></td>
                            <td><%= valJulio %></td>
                        </tr>
                    </tbody>
                </table>

                <%-- TABLA 2: RECARGAS AUTOMATIZADAS --%>
                <table class="tabla-resumen">
                    <thead>
                        <tr>
                            <th colspan="4" class="tabla-header-central" style="background-color: #2c3e50 !important;">RECARGAS</th>
                        </tr>
                        <tr>
                            <th>Mes</th>
                            <th>Mayo</th>
                            <th>Junio</th>
                            <th>Julio</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="txt-destaque">Monto cargado</td>
                            <td>$<%= String.format("%.2f", recargasMayo) %></td>
                            <td>$<%= String.format("%.2f", recargasJunio) %></td>
                            <td>$<%= String.format("%.2f", recargasJulio) %></td>
                        </tr>
                        <tr>
                            <td class="txt-destaque">Num de recargas</td>
                            <td><%= cantMayo %></td>
                            <td><%= cantJunio %></td>
                            <td><%= cantJulio %></td>
                        </tr>
                    </tbody>
                </table>

            </div>
        </div>

    </main>

    <jsp:include page="componentes/footer.jsp" />

</body>
</html>