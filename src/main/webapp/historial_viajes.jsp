<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

                <table class="tabla-resumen">
                    <tbody>
                        <tr>
                            <td class="txt-destaque ancho-etiqueta">Nº Tarjeta:</td>
                            <td class="ancho-valor">91040997</td>
                            <td class="txt-destaque ancho-etiqueta">Movimientos desde:</td>
                            <td class="ancho-valor txt-naranja-bold">04/04/2026</td>
                        </tr>
                    </tbody>
                </table>

                <form action="HistorialServlet" method="GET" class="filtro-container">
                    <label for="periodo" class="txt-destaque">Cambiar a:</label>
                    <select name="periodo" id="periodo" class="select-filtro">
                        <option value="mes">Mes Actual</option>
                        <option value="60">60 días</option>
                        <option value="90">90 días</option>
                    </select>
                    <button type="submit" class="btn-naranja">Ver</button>
                </form>

                <h2 class="subtitulo-seccion">Detalle de Transacciones</h2>

                <table class="tabla-resumen">
                    <thead>
                        <tr>
                            <th class="tabla-header-central">Nº Transacción</th>
                            <th class="tabla-header-central">Movimiento</th>
                            <th class="tabla-header-central">Fecha y hora</th>
                            <th class="tabla-header-central">Lugar</th>
                            <th class="tabla-header-central">Monto</th>
                            <th class="tabla-header-central">Saldo Tarjeta</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="txt-destaque">1125</td>
                            <td>19 - Uso</td>
                            <td>02/07/2026 16:36</td>
                            <td>MB0572</td>
                            <td>$0.25</td>
                            <td class="txt-bold">$3.50</td>
                        </tr>
                        <tr>
                            <td class="txt-destaque">1124</td>
                            <td>19 - Uso</td>
                            <td>02/07/2026 12:06</td>
                            <td>MB0522</td>
                            <td>$0.25</td>
                            <td class="txt-bold">$3.75</td>
                        </tr>
                        <tr>
                            <td class="txt-destaque">1123</td>
                            <td>19 - Uso</td>
                            <td>01/07/2026 09:46</td>
                            <td>MB0917</td>
                            <td>$0.25</td>
                            <td class="txt-bold">$4.00</td>
                        </tr>
                        <tr>
                            <td class="txt-destaque">1122</td>
                            <td>20 - Puerta Trasera</td>
                            <td>01/07/2026 07:25</td>
                            <td>MB0016</td>
                            <td>$0.00</td>
                            <td class="txt-bold">$4.25</td>
                        </tr>
                        <tr>
                            <td class="txt-destaque">1118</td>
                            <td>102 - Transacción de Carga</td>
                            <td>28/06/2026 21:24</td>
                            <td>DATA CENTER 1</td>
                            <td class="txt-naranja-bold">$3.00</td>
                            <td class="txt-bold">$5.00</td>
                        </tr>
                    </tbody>
                </table>

            </div>
        </div>

    </main>

    <footer><jsp:include page="componentes/footer.jsp" /></footer>

</body>
</html>