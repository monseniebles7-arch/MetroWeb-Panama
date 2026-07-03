<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <!-- Título único para la página Home -->
  <title>MetroWeb Panamá — Inicio</title>
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

    @media (max-width: 600px) {
      .hero-texto h1 { font-size: 28px; }
      .stats-inner   { grid-template-columns: 1fr 1fr; }
      .nav-links a   { padding: 8px 10px; font-size: 13px; }
    }
  </style>
</head>
<body>

<!-- ══════════════════════════════════════
     HEADER — Banner con logo centrado
     ══════════════════════════════════════ -->
<header>

  <!-- Banner: solo logo centrado -->
  <div class="banner">
    <div class="banner-inner">
      <div class="banner-logo">
        <a href="home.html">
          <img src="PNGS/logometro.png" alt="MetroWeb Panamá"/>
        </a>
      </div>
    </div>
  </div>

  <!-- Menú de navegación: links centrados, iconos a la derecha -->
  <nav class="nav-principal">
    <div class="nav-inner">

      <!-- Espacio izquierdo para balancear y centrar los links -->
      <div class="nav-espacio"></div>

      <!-- Links principales centrados -->
      <ul class="nav-links">
        <li><a href="home.html"     class="activo">🏠 Inicio</a></li>
        <li><a href="nosotros.html">ℹ️ Sobre Nosotros</a></li>
      </ul>

      <!-- Búsqueda (Google) y redes sociales a la derecha -->
      <div class="nav-iconos">
        <!-- Icono de búsqueda enlaza a Google.com -->
        <a href="https://www.google.com" target="_blank" class="icono-busqueda"
           title="Buscar en Google">
          🔍 Buscar
        </a>
        <!-- Redes sociales con imágenes propias -->
        <a href="https://facebook.com" target="_blank" title="Facebook">
          <img src="PNGS/facebook.png" alt="Facebook" style="height:26px; width:26px; object-fit:contain;"/>
        </a>
        <a href="https://twitter.com" target="_blank" title="Twitter / X">
          <img src="PNGS/twitter.png" alt="Twitter" style="height:26px; width:26px; object-fit:contain;"/>
        </a>
        <a href="https://instagram.com" target="_blank" title="Instagram">
          <img src="PNGS/instagram.png" alt="Instagram" style="height:26px; width:26px; object-fit:contain;"/>
        </a>
      </div>

    </div>
  </nav>

</header>

<!-- ══════════════════════════════════════
     MAIN — Contenido principal
     ══════════════════════════════════════ -->
<main>

  <!-- Hero: texto de presentación + formulario de login -->
  <section class="hero">
    <div class="hero-inner">

      <!-- Lado izquierdo: texto y botón -->
      <div class="hero-texto">
        <h1>Tu transporte público,<br><span>más inteligente</span></h1>
        <p>
          Gestiona tus viajes en el Metro de Panamá y los buses del sistema
          Metrobús desde una sola plataforma. Recarga tu tarjeta, consulta
          tu historial y más.
        </p>
        <div class="hero-btns">
          <a href="registro.html" class="btn btn-naranja btn-lg">Crear cuenta gratis</a>
        </div>
      </div>

      <!-- Lado derecho: formulario de login -->
      <div class="hero-login">
        <h3>Inicia sesión</h3>
        <p class="subtitulo">Accede a tu cuenta MetroWeb</p>

        <!-- Mensaje de error del Servlet -->
        <div class="alerta alerta-error mb-4" id="msgError" style="display:none"></div>

        <!-- Formulario — fuente Georgia diferente al body Inter -->
        <form action="LoginServlet" method="POST" onsubmit="return validar()">
          <div class="campo">
            <label for="correo">Correo electrónico</label>
            <input type="email" id="correo" name="correo"
                   placeholder="usuario@correo.com" required/>
          </div>
          <div class="campo">
            <label for="contrasena">Contraseña</label>
            <input type="password" id="contrasena" name="contrasena"
                   placeholder="••••••••" required/>
          </div>
          <a href="recuperar.html" class="footer-olvide">¿Olvidaste tu contraseña?</a>
          <button type="submit" class="btn btn-primario btn-full">
            Iniciar Sesión
          </button>
        </form>

        <div class="login-pie">
          ¿No tienes cuenta? <a href="registro.html">Regístrate gratis</a>
        </div>
      </div>

    </div>
  </section>

  <!-- Estadísticas del sistema -->
  <section class="seccion-stats">
    <div class="stats-inner">
      <div class="stat-item">
        <h2>30</h2>
        <p>Estaciones de Metro</p>
      </div>
      <div class="stat-item">
        <h2>150+</h2>
        <p>Rutas de Bus</p>
      </div>
      <div class="stat-item">
        <h2>2</h2>
        <p>Líneas del Metro</p>
      </div>
      <div class="stat-item">
        <h2>24/7</h2>
        <p>Disponibilidad</p>
      </div>
    </div>
  </section>

  <!-- Noticias: 2 artículos + 1 video -->
  <section class="seccion-noticias">
    <div class="noticias-inner">

      <div class="noticias-titulo">
        <span class="etiqueta">Actualidad</span>
        <h2>Noticias del Metro de Panamá</h2>
      </div>

      <div class="noticias-grid">

        <!-- Columna izquierda: 2 artículos -->
        <div class="articulos-col">

          <!-- Artículo 1 -->
          <article class="noticia-card">
            <div class="noticia-body">
              <div class="noticia-meta">
                <span class="badge badge-azul">Artículo</span>
                <span class="noticia-fecha">📅 10 de junio, 2026</span>
              </div>
              <!-- Título usa fuente Sora (display), diferente al cuerpo Inter -->
              <h3>MiBus reporta un incremento de más de 7.2 millones de pasajeros movilizados en los primeros cinco meses de 2026</h3>
              <p>
                MiBus, empresa encargada de la operación del transporte público de pasajeros en la Ciudad de Panamá y San Miguelito, informa que, durante los primeros cinco meses de 2026 (enero a mayo), el sistema ha movilizado un total de 61,874,885 pasajeros. Esta cifra representa un aumento significativo en comparación con el mismo periodo del año 2025, cuando se registraron 54,578,710 usuarios. Esto se traduce en un balance positivo de +7,296,175 pasajeros adicionales que han utilizado la red de MiBus este año frente al año pasado.
              </p>
              <!-- Enlace a la fuente original -->
              <a href="https://www.mibus.com.pa/noticia/mibus-reporta-un-incremento-de-mas-de-7-2-millones-de-pasajeros-movilizados-en-los-primeros-cinco-meses-de-2026/" target="_blank" class="noticia-link">
                Leer noticia completa →
              </a>
            </div>
          </article>

          <!-- Artículo 2 -->
          <article class="noticia-card">
            <div class="noticia-body">
              <div class="noticia-meta">
                <span class="badge badge-azul">Artículo</span>
                <span class="noticia-fecha">📅 28 de mayo, 2026</span>
              </div>
              <h3>Teleférico de Panamá y San Miguelito queda sin propuestas en licitación, informó el Metro de Panamá</h3>
              <p>
                El Metro de Panamá, S.A. informa que no se recibieron propuestas para la licitación del proyecto del Teleférico en Panamá y San Miguelito, por parte de los dos consorcios precalificados. La entidad detalló que en los últimos meses mantuvo mesas de trabajo interinstitucionales, atendió consultas y aplicó varias adendas al pliego de cargos con el fin de flexibilizar las condiciones. Sin embargo, a pesar de que ambos consorcios cuentan con una experiencia técnica comprobada, no fue posible lograr la bancarización del proyecto bajo el modelo de concesión administrativa planteado.
              </p>
              <!-- Enlace a la fuente original -->
              <a href="https://www.telemetro.com/nacionales/teleferico-panama-y-san-miguelito-queda-propuestas-licitacion-informo-el-metro-panama-n6080574" target="_blank" class="noticia-link">
                Leer noticia completa →
              </a>
            </div>
          </article>

        </div>

        <!-- Columna derecha: 1 video de YouTube -->
        <div class="video-col">
          <div class="video-card">
            <div class="video-thumb">
              <iframe
                src="https://www.youtube.com/watch?v=IuyetberOiQ"
                title="Metro de Panamá — Video oficial"
                allow="accelerometer; autoplay; clipboard-write;
                       encrypted-media; gyroscope; picture-in-picture"
                allowfullscreen>
              </iframe>
            </div>
            <div class="video-body">
              <div class="noticia-meta">
                <span class="badge badge-naranja">Video</span>
                <span class="noticia-fecha">📅 29 de octubre, 2025</span>
              </div>
              <h3>Línea 3 del Metro</h3>
              <p>
                La Línea 3 del Metro de Panamá pasó de ser un desafío a convertirse en una conquista compartida. Cada paso, cada avance, es el reflejo de lo que somos capaces de lograr cuando trabajamos juntos. ¡Panamá avanza con orgullo y visión de futuro!
              </p>
              <!-- Enlace a la fuente original -->
              <a href="https://www.youtube.com/watch?v=IuyetberOiQ"
                 target="_blank" class="noticia-link">
                Ver en YouTube →
              </a>
            </div>
          </div>
        </div>

      </div>
    </div>
  </section>

</main>

<!-- ══════════════════════════════════════
     FOOTER — menú reducido y copyright
     ══════════════════════════════════════ -->
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

<!-- ══════════════════════════════════════
     JAVASCRIPT — validación del login
     ══════════════════════════════════════ -->
<script>
  const err    = document.getElementById('msgError');
  const params = new URLSearchParams(window.location.search);

  /* Mostrar error si el Servlet redirige con ?error=1 */
  if (params.get('error') === '1') {
    err.style.display = 'flex';
    err.textContent   = '❌ Correo o contraseña incorrectos.';
  }

  /* Validar campos antes de enviar */
  function validar() {
    const correo = document.getElementById('correo').value.trim();
    const pass   = document.getElementById('contrasena').value;

    if (!correo || !pass) {
      err.style.display = 'flex';
      err.textContent   = '❌ Por favor completa todos los campos.';
      return false;
    }
    err.style.display = 'none';
    return true;
  }
</script>

</body>
</html>