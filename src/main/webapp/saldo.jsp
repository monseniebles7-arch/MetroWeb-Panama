<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
                
                <p style="color: var(--gris-medio); font-size: 14px; margin-bottom: 5px; font-weight: 500;">Usuario</p>
                <h2 style="color: var(--azul); margin-bottom: 25px;">Estado de tarjeta</h2>

                <table class="tabla-resumen">
                    <tbody>
                        <tr>
                            <td class="txt-destaque" style="width: 20%;">Nombre:</td>
                            <td style="width: 30%;">Juan Pérez</td>
                            <td class="txt-destaque" style="width: 20%;">Num tarjeta:</td>
                            <td style="width: 30%;">1234-4321</td>
                        </tr>
                        <tr>
                            <td class="txt-destaque">Tipo de tarjeta:</td>
                            <td>Estándar</td>
                            <td class="txt-destaque">Saldo actual:</td>
                            <td style="color: var(--naranja); font-weight: bold; font-size: 16px;">$5.50</td>
                        </tr>
                    </tbody>
                </table>

                <div style="display: flex; justify-content: flex-end; margin-top: 5px; margin-bottom: 35px;">
                    <a href="Recarga_tarjetas.jsp" 
                       style="text-decoration: none; 
                              background-color: #e8610a; 
                              color: #ffffff; 
                              padding: 12px 28px; 
                              border-radius: 8px; 
                              font-weight: 600; 
                              font-size: 15px; 
                              display: inline-flex; 
                              align-items: center; 
                              gap: 8px;
                              box-shadow: 0 4px 12px rgba(232, 97, 10, 0.2);
                              transition: background-color 0.2s;">
                        Recargar Tarjeta
                    </a>
                </div>

                <h2 style="color: var(--azul); margin-top: 20px; margin-bottom: 25px;">Resumen del último trimestre</h2>

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
                            <td>$9.50</td>
                            <td>$10.75</td>
                            <td>$4.00</td>
                        </tr>
                        <tr>
                            <td class="txt-destaque">Num de validaciones</td>
                            <td>37</td>
                            <td>42</td>
                            <td>15</td>
                        </tr>
                    </tbody>
                </table>

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
                            <td>$10.00</td>
                            <td>$12.75</td>
                            <td>$0.00</td>
                        </tr>
                        <tr>
                            <td class="txt-destaque">Num de recargas</td>
                            <td>5</td>
                            <td>7</td>
                            <td>0</td>
                        </tr>
                    </tbody>
                </table>

            </div>
        </div>

    </main>

    <jsp:include page="componentes/footer.jsp" />

</body>
</html>