<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Página Principal - MetroWeb Panamá</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css">
</head>
<body>

    <jsp:include page="componentes/header.jsp" />

    <main>
        <section class="seccion">
            <div class="contenedor">

                <div class="badge badge-azul mb-6">
                    Bienvenido (${sessionScope.nombreUsuario != null ? sessionScope.nombreUsuario : "usuario"})
                </div>

                <div class="grid-cards">

                    <%-- ==========================================================
                         Recorre dinámicamente las tarjetas del usuario.
                         Se asume que el servlet coloca en el request/session
                         una lista "listaTarjetas" con: nombre, imagen,
                         numeroEnmascarado, saldo, id.
                    =========================================================== --%>
                    <c:forEach var="tarjeta" items="${listaTarjetas}">
                        <div class="card card-sm text-center">
                            <div class="card-body">
                                <h5 class="mb-4">${tarjeta.nombre}</h5>
                                <img src="${pageContext.request.contextPath}/PNGS/${tarjeta.imagen}"
                                     alt="Imagen de la tarjeta"
                                     style="width:100%; height:130px; object-fit:cover; border:1px solid var(--gris-borde); border-radius:var(--radio-sm); margin-bottom:var(--sp-4);">
                                <p class="text-sm text-gris mb-4">${tarjeta.numeroEnmascarado}</p>
                                <div class="flex-between">
                                    <span class="text-sm fw-600">saldo: ${tarjeta.saldo}</span>
                                    <a href="${pageContext.request.contextPath}/Recarga_tarjetas.jsp?id=${tarjeta.id}"
                                       class="btn btn-naranja btn-sm">Recarga</a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                    <!-- Tarjeta para añadir una nueva -->
                    <a href="${pageContext.request.contextPath}/registro.html"
                       class="card card-sm text-center"
                       style="display:flex; align-items:center; justify-content:center; min-height:220px; text-decoration:none;">
                        <div class="card-body">
                            <p class="fw-600 text-azul mb-4">Añadir tarjeta</p>
                            <div style="width:34px; height:34px; border:1.5px solid var(--azul); border-radius:var(--radio-sm); margin:0 auto; display:flex; align-items:center; justify-content:center; font-size:18px; color:var(--azul);">+</div>
                        </div>
                    </a>

                </div>

            </div>
        </section>
    </main>

    <jsp:include page="componentes/footer.jsp" />

</body>
</html>
