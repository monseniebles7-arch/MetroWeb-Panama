<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Perfil - MetroWeb Panamá</title>
    <link rel="stylesheet" href="CSS/style.css">
</head>
<body>

    <jsp:include page="componentes/header.jsp" />

    <main class="contenedor seccion">
        
        <div class="perfil-container">
            <div class="perfil-card">

                <div class="perfil-top" style="display: flex; align-items: center; gap: 20px; margin-bottom: 35px;">
                    <div class="perfil-avatar">
                        <img src="PNGS/avatar.png" alt="Usuario" style="height: 80px; width: 80px; border-radius: 50%; object-fit: cover;">
                    </div>
                    <div class="perfil-info">
                        <h2 style="color: var(--azul); margin: 0;">Juan Pérez</h2>
                        <p style="color: var(--gris-medio); margin: 5px 0 0 0; font-size: 14px;">Administrador de la cuenta MetroWeb Panamá</p>
                    </div>
                </div>

                <h3 class="perfil-titulo" style="color: var(--naranja); margin-bottom: 25px; border-bottom: 1px solid var(--gris-borde); padding-bottom: 8px;">
                    Información Personal
                </h3>

                <form action="ActualizarPerfilServlet" method="post">
                    <div class="perfil-grid">

                        <div class="grupo">
                            <label for="nombre" class="fw-600">Nombre</label>
                            <input type="text" id="nombre" name="nombre" value="Juan">
                        </div>

                        <div class="grupo">
                            <label for="apellido" class="fw-600">Apellido</label>
                            <input type="text" id="apellido" name="apellido" value="Pérez">
                        </div>

                        <div class="grupo grupo-full">
                            <label for="correo" class="fw-600">Correo electrónico</label>
                            <input type="email" id="correo" name="correo" value="juan@email.com">
                        </div>

                        <div class="grupo">
                            <label for="telefono" class="fw-600">Teléfono</label>
                            <input type="text" id="telefono" name="telefono" value="6000-0000">
                        </div>

                        <div class="grupo">
                            <label for="cedula" class="fw-600">Cédula</label>
                            <input type="text" id="cedula" name="cedula" value="8-888-888">
                        </div>

                        <div class="grupo">
                            <label for="fechaNacimiento" class="fw-600">Fecha de nacimiento</label>
                            <input type="date" id="fechaNacimiento" name="fechaNacimiento" value="2002-06-18">
                        </div>

                        <div class="grupo">
                            <label for="sexo" class="fw-600">Sexo</label>
                            <select id="select-sexo" name="sexo">
                                <option selected>Masculino</option>
                                <option>Femenino</option>
                            </select>
                        </div>

                        <div class="grupo grupo-full">
                            <label for="direccion" class="fw-600">Dirección</label>
                            <input type="text" id="direccion" name="direccion" value="Ciudad de Panamá">
                        </div>

                        <div class="grupo">
                            <label for="password" class="fw-600">Nueva contraseña</label>
                            <input type="password" id="password" name="password">
                        </div>

                        <div class="grupo">
                            <label for="confirmar" class="fw-600">Confirmar contraseña</label>
                            <input type="password" id="confirmar" name="confirmar">
                        </div>
                    </div>

                    <div class="perfil-botones" style="margin-top: 35px; display: flex; justify-content: center; gap: 15px;">
                        <button class="btn btn-secundario" type="reset">
                            Cancelar
                        </button>
                        <button class="btn btn-principal" type="submit">
                            Guardar Cambios
                        </button>
                    </div>
                </form>

                <hr style="margin: 50px 0; border: none; border-top: 1px solid var(--gris-borde);">

                <h3 class="perfil-titulo" style="color: var(--naranja); margin-bottom: 25px; border-bottom: 1px solid var(--gris-borde); padding-bottom: 8px;">
                    Información de la Cuenta
                </h3>

                <div class="perfil-grid">
                    <div class="grupo">
                        <label class="fw-600">Fecha de registro</label>
                        <input type="text" value="15/01/2026" readonly style="background-color: var(--gris-fondo);">
                    </div>

                    <div class="grupo">
                        <label class="fw-600">Estado</label>
                        <input type="text" value="Cuenta Activa" readonly style="background-color: var(--gris-fondo);">
                    </div>

                    <div class="grupo">
                        <label class="fw-600">Tarjetas registradas</label>
                        <input type="text" value="2 tarjetas" readonly style="background-color: var(--gris-fondo);">
                    </div>

                    <div class="grupo">
                        <label class="fw-600">Último acceso</label>
                        <input type="text" value="29/06/2026 - 5:15 PM" readonly style="background-color: var(--gris-fondo);">
                    </div>
                </div> 

                <!-- Botón de acceso directo modificado con fondo naranja y letras blancas -->
                <div style="display: flex; justify-content: center; margin-top: 40px;">
                    <a href="Recarga_tarjetas.jsp" 
                       style="text-decoration: none; 
                              background-color: #e8610a; 
                              color: #ffffff; 
                              padding: 12px 32px; 
                              border-radius: 8px; 
                              font-weight: 600; 
                              font-size: 15px; 
                              display: inline-flex; 
                              align-items: center; 
                              gap: 8px;
                              box-shadow: 0 4px 12px rgba(232, 97, 10, 0.2);
                              transition: background-color 0.2s;">
                          Ir a Recargar Tarjeta
                    </a>
                </div>

            </div>
        </div>
        
    </main>

    <jsp:include page="componentes/footer.jsp" />

</body>
</html>