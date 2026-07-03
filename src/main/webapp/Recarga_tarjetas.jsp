<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
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
                    <div class="alerta alerta-error" style="background-color: #f8d7da; color: #721c24; padding: 15px; border-radius: 8px; margin-top: 20px; border: 1px solid #f5c6cb;">
                        ❌ No se pudo procesar la recarga. Inténtalo de nuevo.
                    </div>
        <%
                } else if (error.equals("db")) {
        %>
                    <div class="alerta alerta-error" style="background-color: #f8d7da; color: #721c24; padding: 15px; border-radius: 8px; margin-top: 20px; border: 1px solid #f5c6cb;">
                        ❌ Error de conexión con la base de datos de MetroWeb.
                    </div>
        <%
                }
            }
        %>

        <form action="ProcesarRecargaServlet" method="post" style="margin-top: 40px;">
            
            <h4 style="color: var(--naranja); margin-bottom: 20px; border-bottom: 1px solid var(--gris-borde); padding-bottom: 8px;">
                1. Datos de la Tarjeta
            </h4>
            
            <div class="perfil-grid">
                <div class="grupo grupo-full">
                    <label for="tarjeta" class="fw-600">Selecciona tu tarjeta registrada</label>
                    <select id="tarjeta" name="idTarjeta" required>
                        <option value="" disabled selected>-- Elige una tarjeta --</option>
                        <option value="1">Tarjeta Principal - N° 1029384756</option>
                        <option value="2">Tarjeta Secundaria - N° 5647382910</option>
                    </select>
                </div>

                <div class="grupo grupo-full">
                    <label for="monto" class="fw-600">Monto a recargar (USD)</label>
                    <select id="monto" name="monto" required>
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
                <a href="tarjetas.jsp" class="btn btn-secundario" style="text-decoration: none; text-align: center; line-height: 2.4;">
                    Cancelar
                </a>
                <button class="btn btn-principal" type="submit">
                    Confirmar Recarga
                </button>
            </div>

        </form>
    </main>

    <jsp:include page="componentes/footer.jsp" />

</body>
</html>