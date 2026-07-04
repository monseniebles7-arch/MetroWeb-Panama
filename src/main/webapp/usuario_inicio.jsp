<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Control de seguridad: Si no hay usuario en sesión, redirige al Home
    if (session.getAttribute("id_usuario") == null) {
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
            
            <div class="tarjeta-transporte">
                <div class="tarjeta-header">
                    <div>
                        <span class="tarjeta-marca">MetroWeb</span>
                        <div class="tarjeta-numero">Nº 91040997</div>
                    </div>
                    <span class="badge badge-azul">Principal</span>
                </div>
                <div class="tarjeta-body-saldo">
                    <div class="tarjeta-saldo-label">Saldo Disponible</div>
                    <div class="tarjeta-saldo-monto">$3.50</div>
                </div>
                <a href="recarga.jsp" class="btn-recarga-tarjeta">
                    Recargar esta tarjeta
                </a>
            </div>

            <div class="tarjeta-transporte">
                <div class="tarjeta-header">
                    <div>
                        <span class="tarjeta-marca">MetroWeb</span>
                        <div class="tarjeta-numero">Nº 45871293</div>
                    </div>
                    <span class="badge badge-azul">Secundaria</span>
                </div>
                <div class="tarjeta-body-saldo">
                    <div class="tarjeta-saldo-label">Saldo Disponible</div>
                    <div class="tarjeta-saldo-monto">$1.25</div>
                </div>
                <a href="recarga.jsp" class="btn-recarga-tarjeta">
                    Recargar esta tarjeta
                </a>
            </div>

            <a href="agregar-tarjeta.jsp" class="tarjeta-agregar-nueva">
                <span class="tarjeta-agregar-icono">+</span>
                Agregar nueva tarjeta
            </a>

        </div>

    </main>

    <jsp:include page="componentes/footer.jsp" />

</body>
</html>