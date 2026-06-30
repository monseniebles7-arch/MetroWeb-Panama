<%@ page contentType="text/html; charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>MetroWeb Panamá — Mi Perfil</title>

    <!-- Hoja de estilos general del sitio -->
    <link rel="stylesheet" href="CSS/style.css"/>
  <style>
    /* ── Estilos específicos de la Home ── */

    /* Banner superior — fondo blanco con línea naranja abajo */
    .banner {
      background: #ffffff;
      padding: 10px 0;
      border-bottom: 3px solid var(--naranja);
    }

    .banner-inner {
      display: flex;
      align-items: center;
      justify-content: center;
      width: min(1120px, 92vw);
      margin: 0 auto;
    }

    /* Logo centrado en el banner */
    .banner-logo img {
      height: 100px;
      display: block;
      margin: 0 auto;
    }

    /* Menú de navegación principal */
    .nav-principal {
      background: var(--blanco);
      border-bottom: 1px solid var(--gris-borde);
      position: sticky;
      top: 0;
      z-index: 100;
      box-shadow: var(--sombra-sm);
    }

    /* Nav dividido en 3 partes: espacio | links centrados | iconos */
    .nav-inner {
      display: flex;
      align-items: center;
      justify-content: space-between;
      width: min(1120px, 92vw);
      margin: 0 auto;
      height: 52px;
    }

    /* Espacio izquierdo igual al ancho de los iconos para centrar links */
    .nav-espacio {
      flex: 1;
    }

    /* Links de navegación centrados */
    .nav-links {
      display: flex;
      list-style: none;
      gap: 4px;
      flex: 0;
      white-space: nowrap;
    }

    .nav-links a {
      display: block;
      padding: 8px 16px;
      font-size: 14px;
      font-weight: 500;
      color: var(--gris-oscuro);
      text-decoration: none;
      border-radius: var(--radio-sm);
      transition: background 0.15s, color 0.15s;
    }

    .nav-links a:hover  { background: var(--gris-fondo); color: var(--azul); }
    .nav-links a.activo { background: var(--azul-claro); color: var(--azul); font-weight: 600; }

    /* Iconos a la derecha del menú */
    .nav-iconos {
      flex: 1;
      display: flex;
      align-items: center;
      justify-content: flex-end;
      gap: 14px;
    }

    .nav-iconos a {
      color: var(--gris-oscuro);
      text-decoration: none;
      transition: opacity 0.2s;
    }

    .nav-iconos a:hover { opacity: 0.7; }

    /* Botón de búsqueda */
    

    /* Hero section */
    .hero {
      background: linear-gradient(135deg, var(--azul) 0%, #0f2549 100%);
      padding: 80px 0;
      position: relative;
      overflow: hidden;
    }

   /* Círculo decorativo del hero */
    .hero::after {
      content: '';
      position: absolute;
      width: 500px; height: 500px;
      border-radius: 50%;
      background: rgba(232,97,10,0.08);
      right: -150px; top: -150px;
    }

    .hero-inner {
      width: min(1120px, 92vw);
      margin: 0 auto;
      display: grid;
      grid-template-columns: 1fr 1fr;
      align-items: center;
      gap: 48px;
    }

    /* Título del hero en blanco con palabra naranja */
    .hero-texto h1 {
      font-size: 40px;
      color: var(--blanco);
      margin-bottom: 16px;
      line-height: 1.2;
    }

    .hero-texto h1 span { color: var(--naranja); }

    .hero-texto p {
      color: rgba(255,255,255,0.70);
      font-size: 17px;
      margin-bottom: 32px;
      line-height: 1.7;
    }

    .hero-btns {
      display: flex;
      gap: 12px;
      flex-wrap: wrap;
    }

    /* Caja blanca del formulario de login */
    .hero-login {
      background: var(--blanco);
      border-radius: 20px;
      padding: 36px;
      box-shadow: 0 20px 60px rgba(0,0,0,0.25);
      position: relative;
      z-index: 1;
    }

    .hero-login h3 {
      font-size: 20px;
      margin-bottom: 4px;
    }

    .hero-login .subtitulo {
      font-size: 13px;
      color: var(--gris-medio);
      margin-bottom: 24px;
    }

    /* Formulario con fuente Georgia — diferente al body (Inter) */
    .hero-login form  { font-family: 'Georgia', serif; color: var(--azul); }
    .hero-login label { font-family: 'Georgia', serif; color: var(--azul); font-size: 13px; font-weight: bold; }
    .hero-login input { font-family: 'Georgia', serif; color: var(--azul); }

    /* Link olvidé contraseña */
    .footer-olvide {
      font-size: 13px;
      color: var(--naranja);
      text-align: right;
      display: block;
      margin-top: -8px;
      margin-bottom: 16px;
    }

    .login-pie {
      text-align: center;
      margin-top: 12px;
      font-size: 13px;
      color: var(--gris-medio);
    }

    .login-pie a { color: var(--naranja); font-weight: 500; }

    /* Sección estadísticas */
    .seccion-stats {
      background: var(--azul);
      padding: 48px 0;
    }

    .stats-inner {
      width: min(1120px, 92vw);
      margin: 0 auto;
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 32px;
      text-align: center;
    }

    .stat-item h2 {
      font-size: 36px;
      color: var(--naranja);
      margin-bottom: 6px;
    }

    .stat-item p {
      color: rgba(255,255,255,0.70);
      font-size: 14px;
      margin: 0;
    }

    /* Sección de noticias */
    .seccion-noticias {
      padding: 64px 0;
      background: var(--gris-fondo);
    }

    .noticias-inner {
      width: min(1120px, 92vw);
      margin: 0 auto;
    }

    .noticias-titulo { margin-bottom: 40px; }
    .noticias-titulo .etiqueta { margin-bottom: 8px; display: block; }

    /* Grid: 2 artículos a la izquierda, 1 video a la derecha */
    .noticias-grid {
      display: grid;
      grid-template-columns: 2fr 1fr;
      gap: 24px;
    }

    .articulos-col {
      display: flex;
      flex-direction: column;
      gap: 24px;
    }

    /* Tarjeta de noticia */
    .noticia-card {
      background: var(--blanco);
      border-radius: 16px;
      overflow: hidden;
      box-shadow: var(--sombra);
      transition: transform 0.2s, box-shadow 0.2s;
    }

    .noticia-card:hover {
      transform: translateY(-3px);
      box-shadow: var(--sombra-lg);
    }

    .noticia-body { padding: 24px; }

    .noticia-meta {
      display: flex;
      align-items: center;
      gap: 10px;
      margin-bottom: 12px;
    }

    .noticia-fecha { font-size: 12px; color: var(--gris-medio); }

    .noticia-body h3 { font-size: 18px; margin-bottom: 10px; line-height: 1.4; }

    .noticia-body p {
      font-size: 14px;
      color: var(--gris-medio);
      line-height: 1.6;
      margin-bottom: 16px;
    }

    .noticia-link {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      font-size: 13px;
      font-weight: 600;
      color: var(--naranja);
      text-decoration: none;
    }

    .noticia-link:hover { text-decoration: underline; }

    /* Tarjeta de video */
    .video-card {
      background: var(--blanco);
      border-radius: 16px;
      overflow: hidden;
      box-shadow: var(--sombra);
      height: 100%;
    }

    .video-thumb {
      position: relative;
      background: #000;
      aspect-ratio: 16/9;
      overflow: hidden;
    }

    .video-thumb iframe {
      width: 100%;
      height: 100%;
      border: none;
    }

    .video-body { padding: 20px; }
    .video-body h3 { font-size: 16px; margin-bottom: 8px; }
    .video-body p  { font-size: 13px; color: var(--gris-medio); margin-bottom: 12px; }

    /* Responsive */
    @media (max-width: 900px) {
      .hero-inner    { grid-template-columns: 1fr; }
      .noticias-grid { grid-template-columns: 1fr; }
      .stats-inner   { grid-template-columns: repeat(2, 1fr); }
    }
    .video-body { padding: 20px; }
	.video-body h3 { font-size: 16px; margin-bottom: 8px; }
	.video-body p  { font-size: 13px; color: var(--gris-medio); margin-bottom: 12px; }

/* =======================
   ESTILOS DE PERFIL
======================= */

	.perfil-container{
    	width: min(900px, 90vw);
    	margin: 0 auto;
	}

	.perfil-card{
   		 background: var(--blanco);
   		 border-radius: 20px;
   		 padding: 40px;
   		 box-shadow: var(--sombra);
	}

	.perfil-grid{
    	display: grid;
    	grid-template-columns: 320px 320px;
    	justify-content: center;
    	column-gap: 60px;
    	row-gap: 25px;
	}

	.grupo{
    	display: flex;
    	flex-direction: column;
	}

	{
   		 grid-column: 1 / -1;
	}

	.grupo label{
    	margin-bottom: 8px;
    	font-weight: 600;
    	color: var(--azul);
	}

	.grupo input,
	.grupo select{
    	width: 320px;
    	padding: 10px 14px;
    	border: 1px solid var(--gris-borde);
    	border-radius: 8px;
    	font-size: 15px;
    	box-sizing: border-box;
	}

	.grupo-full{
    	grid-column: 1 / 3;
	}

	.grupo-full input{
   		 width: 700px;
   		 max-width: 100%;
	}

/* Responsive */
	@media (max-width: 900px) {

    @media (max-width: 600px) {
      .hero-texto h1 { font-size: 28px; }
      .stats-inner   { grid-template-columns: 1fr 1fr; }
      .nav-links a   { padding: 8px 10px; font-size: 13px; }
    }
   
  </style>

</head>

<body>

<!--======================================================
                    ENCABEZADO
     Es exactamente igual al de la página principal.
=======================================================-->

<header>

    <!-- Banner superior -->

    <div class="banner">

        <div class="banner-inner">

            <a class="banner-logo" href="home.jsp">

                <img src="PNGS/logo.png"
                     alt="MetroWeb Panamá">

            </a>

        </div>

    </div>

    <!--==================================================
                MENÚ PRINCIPAL
    ===================================================-->

    <nav class="nav-principal">

        <div class="nav-inner">

            <div class="nav-espacio"></div>

            <ul class="nav-links">

                <li><a href="home.jsp">Inicio</a></li>

                <li><a href="nosotros.jsp">Sobre Nosotros</a></li>

                <li><a href="perfil.jsp" class="activo">Mi Perfil</a></li>

                <li><a href="tarjetas.jsp">Mis Tarjetas</a></li>

                <li><a href="recarga.jsp">Recargar Tarjeta</a></li>

            </ul>

            <!-- Redes sociales -->

            <div class="nav-iconos">

                <a href="https://www.google.com"
                   target="_blank"
                   class="icono-busqueda">

                    🔍 Buscar

                </a>

                <a href="https://facebook.com"
                   target="_blank">

                    <img src="PNGS/facebook.png"
                    alt="Facebook"
                    style="height:26px;width:26px;object-fit:contain;">

                </a>

                <a href="https://twitter.com"
                   target="_blank">

                    <img src="PNGS/twitter.png"
                    alt="Twitter"
                    style="height:26px;width:26px;object-fit:contain;">

                </a>

                <a href="https://instagram.com"
                   target="_blank">

                    <img src="PNGS/instagram.png"
                    alt="Instagram"
                    style="height:26px;width:26px;object-fit:contain;">

                </a>

            </div>

        </div>

    </nav>

</header>

<!--======================================================
                CONTENIDO PRINCIPAL
=======================================================-->

<section class="hero">

<div class="perfil-container">

<div class="perfil-card">

<!-- Información superior del usuario -->

<div class="perfil-top">

    <div class="perfil-avatar">

        <img src="PNGS/avatar.png"
             alt="Usuario">

    </div>

    <div class="perfil-info">

        <h1>Juan Pérez</h1>

        <p>Administrador de la cuenta MetroWeb Panamá</p>

    </div>

</div>

<h2 class="perfil-titulo">

    Información Personal

</h2>
<!--======================================================
    FORMULARIO DEL PERFIL
    Permite visualizar y editar la información personal
    del usuario registrado.
=======================================================-->

<form action="ActualizarPerfilServlet" method="post">

    <div class="perfil-grid">

        <!-- Nombre -->

        <div class="grupo">

            <label for="nombre">

                Nombre

            </label>

            <input
                type="text"
                id="nombre"
                name="nombre"
                value="Juan">

        </div>

        <!-- Apellido -->

        <div class="grupo">

            <label for="apellido">

                Apellido

            </label>

            <input
                type="text"
                id="apellido"
                name="apellido"
                value="Pérez">

        </div>

        <!-- Correo -->

        <div class="grupo grupo-full">

            <label for="correo">

                Correo electrónico

            </label>

            <input
                type="email"
                id="correo"
                name="correo"
                value="juan@email.com">

        </div>

        <!-- Teléfono -->

        <div class="grupo">

            <label for="telefono">

                Teléfono

            </label>

            <input
                type="text"
                id="telefono"
                name="telefono"
                value="6000-0000">

        </div>

        <!-- Cédula -->

        <div class="grupo">

            <label for="cedula">

                Cédula

            </label>

            <input
                type="text"
                id="cedula"
                name="cedula"
                value="8-888-888">

        </div>

        <!-- Fecha de nacimiento -->

        <div class="grupo">

            <label for="fechaNacimiento">

                Fecha de nacimiento

            </label>

            <input
                type="date"
                id="fechaNacimiento"
                name="fechaNacimiento"
                value="2002-06-18">

        </div>

        <!-- Sexo -->

        <div class="grupo">

            <label for="sexo">

                Sexo

            </label>

            <select
                id="sexo"
                name="sexo">

                <option>Masculino</option>

                <option>Femenino</option>

            </select>

        </div>

        <!-- Dirección -->

        <div class="grupo grupo-full">

            <label for="direccion">

                Dirección

            </label>

            <input
                type="text"
                id="direccion"
                name="direccion"
                value="Ciudad de Panamá">

        </div>

        <!-- Contraseña -->

        <div class="grupo">

            <label for="password">

                Nueva contraseña

            </label>

            <input
                type="password"
                id="password"
                name="password">

        </div>

        <!-- Confirmación -->

        <div class="grupo">

            <label for="confirmar">

                Confirmar contraseña

            </label>

            <input
                type="password"
                id="confirmar"
                name="confirmar">

        </div>

    </div>

    <!--==================================================
        BOTONES DEL FORMULARIO
    ===================================================-->

    <div class="perfil-botones">

        <button
            class="btn btn-secundario"
            type="reset">

            Cancelar

        </button>

        <button
            class="btn btn-principal"
            type="submit">

            Guardar Cambios

        </button>

    </div>

</form>

<!--======================================================
    INFORMACIÓN ADICIONAL
    Datos de solo lectura referentes a la cuenta.
=======================================================-->

<hr style="margin:55px 0; border:none; border-top:1px solid #e4e4e4;">

<h2 class="perfil-titulo">

    Información de la Cuenta

</h2>

<div class="perfil-grid">

    <!-- Fecha de creación -->

    <div class="grupo">

        <label>

            Fecha de registro

        </label>

        <input
            type="text"
            value="15/01/2026"
            readonly>

    </div>

    <!-- Estado -->

    <div class="grupo">

        <label>

            Estado

        </label>

        <input
            type="text"
            value="Cuenta Activa"
            readonly>

    </div>

    <!-- Tarjetas -->

    <div class="grupo">

        <label>

            Tarjetas registradas

        </label>

        <input
            type="text"
            value="2 tarjetas"
            readonly>

    </div>

    <!-- Último acceso -->

    <div class="grupo">

        <label>

            Último acceso

        </label>

        <input
            type="text"
            value="29/06/2026 - 5:15 PM"
            readonly>

    </div>

</div>

</div>
</div>


</section>

<!-- ======================================================
     PIE DE PÁGINA
====================================================== -->

<footer>
  <div class="footer-inner">
    <div class="footer-grid">

      <!-- Columna marca -->
      <div>
        <div class="footer-marca">🚇 Metro<span>Web</span> Panamá</div>
        <p class="footer-desc">
          Plataforma digital para gestionar tus viajes en el sistema
          de transporte público de Panamá.
        </p>
        <div class="footer-lineas">
          <span class="footer-badge footer-badge-l1">Línea 1</span>
          <span class="footer-badge footer-badge-l2">Línea 2</span>
        </div>
      </div>

      <!-- Versión reducida del menú en el footer -->
      <div class="footer-col">
        <h4>Navegación</h4>
        <ul>
          <li><a href="home.html">Inicio</a></li>
          <li><a href="nosotros.html">Sobre Nosotros</a></li>
        </ul>
      </div>

      <!-- Columna cuenta -->
      <div class="footer-col">
        <h4>Cuenta</h4>
        <ul>
          <li><a href="home.html">Iniciar Sesión</a></li>
          <li><a href="registro.html">Registrarse</a></li>
          <li><a href="recuperar.html">Recuperar Contraseña</a></li>
        </ul>
      </div>

    </div>

    <!-- Barra inferior con copyright -->
    <div class="footer-bottom">
      <p class="footer-copy">
        © 2026 <span>MetroWeb Panamá</span>. Todos los derechos reservados.
      </p>
      <p class="footer-copy">Hecho en 🇵🇦 Panamá</p>
    </div>
  </div>
</footer>

</body>

</html>