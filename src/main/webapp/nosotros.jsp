<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Sobre nosotros - MetroWeb Panamá</title>
    <link rel="stylesheet" href="CSS/style.css">
</head>
<body>

    <!-- Este componente debe tener los enlaces actualizados a home.html y nosotros.jsp -->
    <jsp:include page="componentes/header.jsp" />

    <main class="contenedor seccion">
        
        <div class="card card-accent">
            <div class="card-body">
                <h3>Nuestra Misión</h3>
                <p class="mt-4">
                    Facilitar la movilidad de los ciudadanos panameños integrando soluciones tecnológicas 
                    para el acceso rápido, consultas de saldo en tiempo real y optimización del uso del Metro y Metrobús.
                </p>
            </div>
        </div>

        <div class="seccion-titulo text-center" style="margin-top: 60px;">
            <h2>Nuestro equipo</h2>
        </div>

        <div class="grid-cards">
            <div class="card">
                <img src="PNGS/instagram.png" alt="Integrante 1" style="width: 100%; aspect-ratio: 1/1; object-fit: cover; background-color: var(--gris-borde);">
                <div class="card-body">
                    <p class="mb-2"><span class="fw-600">Nombre:</span> Gabriel Cedeño</p>
                    <p class="mb-2 text-sm"><span class="fw-600">Cédula:</span> 8-985-584</p>
                    <p class="mb-2 text-sm"><span class="fw-600">Edad:</span> 23 años</p>
                    <p class="mb-0 text-sm"><span class="fw-600">Descripción:</span> Desarrollador de software enfocado en la arquitectura del sistema.</p>
                </div>
            </div>

            <div class="card">
                <img src="PNGS/Roberto.jpeg" alt="Integrante 2" style="width: 100%; aspect-ratio: 1/1; object-fit: cover; background-color: var(--gris-borde);">
                <div class="card-body">
                    <p class="mb-2"><span class="fw-600">Nombre:</span> Roberto De Gracia</p>
                    <p class="mb-2 text-sm"><span class="fw-600">Cédula:</span> 8-1028-2132</p>
                    <p class="mb-2 text-sm"><span class="fw-600">Edad:</span> 20 años</p>
                    <p class="mb-0 text-sm"><span class="fw-600">Descripción:</span> Encargado de diseño y experiencia de usuario: "Me gusta tocar el piano, leer, jugar fútbol y se programar en Java y C"</p>
                </div>
            </div>

            <div class="card">
                <img src="PNGS/monse.jpeg" alt="Integrante 3" style="width: 100%; aspect-ratio: 1/1; object-fit: cover; background-color: var(--gris-borde);">
                <div class="card-body">
                    <p class="mb-2"><span class="fw-600">Nombre:</span> Monserrate Niebles</p>
                    <p class="mb-2 text-sm"><span class="fw-600">Cédula:</span> 3-750-104</p>
                    <p class="mb-2 text-sm"><span class="fw-600">Edad:</span> 23 años</p>
                    <p class="mb-0 text-sm"><span class="fw-600">Descripción:</span> Soporte técnico y gestión de base de datos.</p>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="componentes/footer.jsp" />

</body>
</html>