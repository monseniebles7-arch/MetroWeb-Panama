<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Página Principal - MetroWeb Panamá</title>
    <link rel="stylesheet" href="CSS/style.css">
    <style>
        /* Estilos específicos para la página principal */
        .contenedor-principal {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px 30px;
        }

        .bienvenida {
            font-size: 22px;
            font-weight: 700;
            color: var(--azul);
            border: 2px solid var(--azul);
            display: inline-block;
            padding: 6px 14px;
            border-radius: 4px;
            margin-bottom: 25px;
        }

        .grid-tarjetas {
            display: flex;
            flex-wrap: wrap;
            gap: 25px;
        }

        .tarjeta-card {
            border: 1px solid var(--gris-borde);
            border-radius: 8px;
            width: 220px;
            padding: 15px;
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .tarjeta-card h3 {
            font-size: 15px;
            font-weight: 600;
            color: var(--azul);
            margin: 0 0 12px 0;
        }

        .tarjeta-imagen {
            width: 100%;
            height: 130px;
            border: 1px solid var(--gris-borde);
            border-radius: 4px;
            margin-bottom: 12px;
            object-fit: cover;
        }

        .tarjeta-numero {
            font-size: 14px;
            color: #333;
            margin-bottom: 10px;
        }

        .tarjeta-info {
            width: 100%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 13px;
        }

        .tarjeta-saldo {
            color: #333;
        }

        .btn-recarga {
            background-color: var(--azul);
            color: var(--blanco);
            border: none;
            border-radius: 4px;
            padding: 6px 12px;
            font-size: 13px;
            cursor: pointer;
            text-decoration: none;
        }

        .btn-recarga:hover {
            opacity: 0.85;
        }

        /* Tarjeta especial para "Añadir tarjeta" */
        .tarjeta-anadir {
            border: 1px solid var(--gris-borde);
            border-radius: 8px;
            width: 220px;
            min-height: 245px;
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
        }

        .tarjeta-anadir-contenido {
            text-align: center;
            color: var(--azul);
        }

        .tarjeta-anadir-icono {
            width: 34px;
            height: 34px;
            border: 1px solid var(--azul);
            border-radius: 4px;
            margin: 10px auto 0 auto;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
        }

        .tarjeta-anadir p {
            font-size: 14px;
            font-weight: 600;
            margin: 0;
        }
    </style>
</head>
<body>

    <jsp:include page="componentes/header.jsp" />

    <main class="contenedor-principal">

        <div class="bienvenida">
            Bienvenido (${sessionScope.nombreUsuario != null ? sessionScope.nombreUsuario : "usuario"})
        </div>

        <div class="grid-tarjetas">

            <%-- ==========================================================
                 Aquí se recorren dinámicamente las tarjetas del usuario.
                 Se asume que en el servlet/controlador se coloca en el
                 request/session un objeto "listaTarjetas" con los datos
                 de cada tarjeta: nombre, numero, saldo, imagen, id.
            =========================================================== --%>
            <c:forEach var="tarjeta" items="${listaTarjetas}">
                <div class="tarjeta-card">
                    <h3>${tarjeta.nombre}</h3>
                    <img src="PNGS/${tarjeta.imagen}" alt="Imagen de la tarjeta" class="tarjeta-imagen">
                    <div class="tarjeta-numero">${tarjeta.numeroEnmascarado}</div>
                    <div class="tarjeta-info">
                        <span class="tarjeta-saldo">saldo: ${tarjeta.saldo}</span>
                        <a href="Recarga_tarjetas.jsp?id=${tarjeta.id}" class="btn-recarga">recarga</a>
                    </div>
                </div>
            </c:forEach>

            <!-- Tarjeta para añadir una nueva tarjeta -->
            <a href="Recarga_tarjetas.jsp" class="tarjeta-anadir">
                <div class="tarjeta-anadir-contenido">
                    <p>Añadir tarjeta</p>
                    <div class="tarjeta-anadir-icono">+</div>
                </div>
        
        </div>

    </main>

    <jsp:include page="componentes/footer.jsp" />

</body>
</html>
