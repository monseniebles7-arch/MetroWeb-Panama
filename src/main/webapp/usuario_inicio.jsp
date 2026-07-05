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

    <%-- jsp:include: Carga e inserta dinámicamente el componente común header.jsp (menú superior) --%>
    <jsp:include page="componentes/header.jsp" />

    <%-- Etiqueta <main>: Delimita el área de contenido principal de la página, aplicando márgenes estándar --%>
    <main class="contenedor seccion">
        
        <%-- Bloque superior del Dashboard: Contenedor que maneja la estructura flexbox para dar el saludo de bienvenida --%>
        <div class="dashboard-bienvenida">
            <div>
                <%-- Etiqueta decorativa pequeña para indicar la sección actual --%>
                <p class="txt-gris-propio">Panel de Control</p>
                <%-- <%= nombreUsuario %>: Inyecta dinámicamente el nombre guardado en la sesión del servidor --%>
                <h2>¡Hola, <%= nombreUsuario %>!</h2>
            </div>
        </div>

        <h3>Mis Tarjetas Asociadas</h3>

        <%-- Grid Contenedor: Aplica una grilla de CSS que ordena automáticamente las tarjetas en columnas (se adapta a PCs y celulares) --%>
        <div class="tarjetas-contenedor-grid">
            
            <%-- PRIMERA TARJETA (Simulada como activa o principal) --%>
            <div class="tarjeta-transporte">
                <%-- Cabecera interna de la tarjeta de transporte físico --%>
                <div class="tarjeta-header">
                    <div>
                        <%-- Marca decorativa del sistema de transporte --%>
                        <span class="tarjeta-marca">MetroWeb</span>
                        <%-- Espacio asignado para mostrar el identificador o número serial de la tarjeta --%>
                        <div class="tarjeta-numero">Nº 91040997</div>
                    </div>
                    <%-- Etiqueta (Badge) azul para resaltar que esta es la tarjeta primordial del usuario --%>
                    <span class="badge badge-azul">Principal</span>
                </div>
                <%-- Cuerpo central de la tarjeta destinado exclusivamente a mostrar las finanzas --%>
                <div class="tarjeta-body-saldo">
                    <div class="tarjeta-saldo-label">Saldo Disponible</div>
                    <%-- Monto monetario formateado que posee actualmente el plástico --%>
                    <div class="tarjeta-saldo-monto">$3.50</div>
                </div>
                <%-- Enlace que funciona como botón de acción para enviar al usuario directo al formulario de recarga monetaria --%>
                <a href="Recarga_tarjetas.jsp" class="btn-recarga-tarjeta">
                    Recargar esta tarjeta
                </a>
            </div>

            <%-- SEGUNDA TARJETA (Simulada como secundaria o de respaldo) --%>
            <div class="tarjeta-transporte">
                <div class="tarjeta-header">
                    <div>
                        <span class="tarjeta-marca">MetroWeb</span>
                        <div class="tarjeta-numero">Nº 45871293</div>
                    </div>
                    <%-- Etiqueta informativa indicando que es una tarjeta complementaria --%>
                    <span class="badge badge-azul">Secundaria</span>
                </div>
                <div class="tarjeta-body-saldo">
                    <div class="tarjeta-saldo-label">Saldo Disponible</div>
                    <div class="tarjeta-saldo-monto">$1.25</div>
                </div>
                <a href="Recarga_tarjetas.jsp" class="btn-recarga-tarjeta">
                    Recargar esta tarjeta
                </a>
            </div>

            <%-- BOTÓN O TARJETA DE ACCESO DIRECTO: Estilizado con bordes discontinuos (dashed) para invitar a agregar más elementos --%>
            <a href="agregar-tarjeta.jsp" class="tarjeta-agregar-nueva">
                <%-- Signo matemático de suma estilizado en tamaño grande --%>
                <span class="tarjeta-agregar-icono">+</span>
                Agregar nueva tarjeta
            </a>

        </div>

    </main>

    <%-- jsp:include: Carga modular e integra la estructura del pie de página común (footer.jsp) --%>
    <jsp:include page="componentes/footer.jsp" />

</body>
</html>