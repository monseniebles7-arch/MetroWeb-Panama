<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Inicio | MetroWeb Panamá</title>
   <link rel="stylesheet" href="CSS/style.css"/>
</head>
<body>

<!-- Llamada al encabezado de administración horizontal -->
<jsp:include page="componentes/header_admin.jsp" />

<!-- Eliminamos el aside lateral. El contenedor ahora envuelve solo el cuerpo principal -->
<main class="admin-layout-horizontal">
    <section class="admin-body">
        <div class="panel-header">
            <h2>Métricas del Sistema</h2>
            <p class="subtitulo">Resumen operativo de MetroWeb Panamá</p>
        </div>
        
        <div class="grid-cards mb-6">
            <div class="card card-accent card-sm">
                <div class="card-body">
                    <span class="etiqueta">Usuarios Activos</span>
                    <h2 class="mt-4 text-azul fw-700">1,245</h2>
                </div>
            </div>
            <div class="card card-accent card-sm" style="border-left-color: var(--azul)">
                <div class="card-body">
                    <span class="etiqueta" style="color: var(--azul);">Tarjetas Registradas</span>
                    <h2 class="mt-4 text-azul fw-700">3,840</h2>
                </div>
            </div>
        </div>

        <h3 class="mb-4 text-azul">Últimas Transacciones Recientes</h3>
        <div class="tabla-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>ID Transacción</th>
                        <th>Usuario</th>
                        <th>N° Tarjeta</th>
                        <th>Monto</th>
                        <th>Estado</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td class="fw-600">#TX-9021</td>
                        <td>Carlos Mendoza</td>
                        <td>Metro-8832-10</td>
                        <td class="fw-600">$5.00</td>
                        <td><span class="badge badge-verde">Éxito</span></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </section>
</main>

<jsp:include page="componentes/footer.jsp" />

</body>
</html>