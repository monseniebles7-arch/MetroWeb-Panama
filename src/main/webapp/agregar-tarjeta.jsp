<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Agregar Tarjeta — MetroWeb Panamá</title>
    <link rel="stylesheet" href="CSS/style.css"/>
</head>
<body>

    <jsp:include page="componentes/header.jsp" />

    <main class="contenedor seccion">
        <div style="max-width: 500px; margin: 40px auto;">
            <div class="hero-login" style="float: none; width: 100%; box-sizing: border-box;">
                <h3>Vincular Tarjeta</h3>
                <p class="subtitulo">Registra tu tarjeta del Metro o Metrobús</p>

                <form action="TarjetaServlet" method="POST">
                    
                    <div class="campo">
                        <label for="numTarjeta">Número de Tarjeta</label>
                        <input 
                            type="text" 
                            id="numTarjeta" 
                            name="numTarjeta" 
                            placeholder="Ej. 101001234567" 
                            required 
                            maxlength="20"
                        />
                        <small style="color: var(--gris-texto); font-size: 0.8rem; display: block; margin-top: 5px;">
                            Introduce los dígitos que aparecen al reverso de tu tarjeta.
                        </small>
                    </div>

                    <div class="campo" style="margin-top: 20px;">
                        <label for="aliasTarjeta">Nombre personalizado (Alias)</label>
                        <input 
                            type="text" 
                            id="aliasTarjeta" 
                            name="aliasTarjeta" 
                            placeholder="Ej. Mi Tarjeta Principal, Tarjeta de la U" 
                            required
                        />
                    </div>

                    <div class="campo" style="margin-top: 20px;">
                        <label for="tipoTarjeta">Tipo de Usuario</label>
                        <select id="tipoTarjeta" name="tipoTarjeta" style="width: 100%; padding: 10px; border: 1px solid var(--gris-borde); border-radius: 4px; background: white; font-family: inherit;">
                            <option value="Regular">Regular</option>
                            <option value="Estudiante">Estudiante</option>
                            <option value="Jubilado">Jubilado / Tercera Edad</option>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-primario btn-full" style="margin-top: 30px;">
                          Guardar y Vincular
                    </button>
                    
                    <a href="home.html" style="display: block; text-align: center; margin-top: 15px; color: var(--azul-primario); text-decoration: none; font-size: 0.9rem;">
                        Cancelar y volver al inicio
                    </a>
                </form>
            </div>
        </div>
    </main>

    <jsp:include page="componentes/footer.jsp" />

</body>
</html>