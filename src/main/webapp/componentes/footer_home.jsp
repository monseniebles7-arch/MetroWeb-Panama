<%-- Configuración de la directiva de página para definir el tipo de contenido y la codificación UTF-8 --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- Inicio del pie de página global de la pantalla de bienvenida -->
<footer>
  <div class="footer-inner">
    
    <!-- Contenedor principal en cuadrícula (Grid) para organizar las columnas -->
    <div class="footer-grid">
      
      <!-- Columna 1: Información de la marca, descripción institucional y badges -->
      <div>
        <div class="footer-marca">🚇 Metro<span>Web</span> Panamá</div>
        <p class="footer-desc">
          Plataforma digital para gestionar tus viajes en el sistema de transporte público de Panamá.
        </p>
        <div class="footer-lineas">
          <span class="footer-badge footer-badge-l1">Línea 1</span>
          <span class="footer-badge footer-badge-l2">Línea 2</span>
        </div>
      </div>

      <!-- Columna 2: Enlaces de navegación pública general -->
      <div class="footer-col">
        <h4>Navegación</h4>
        <ul>
          <li><a href="home.jsp">Inicio</a></li>
          <li><a href="nosotros_home.jsp">Sobre Nosotros</a></li>
        </ul>
      </div>

      <!-- Columna 3: Enlaces de gestión de cuenta de usuario antes de iniciar sesión -->
      <div class="footer-col">
        <h4>Cuenta</h4>
        <ul>
          <li><a href="home.jsp">Iniciar Sesión</a></li>
          <li><a href="registro.jsp">Registrarse</a></li>
          <li><a href="recuperar.jsp">Recuperar Contraseña</a></li>
        </ul>
      </div>
    </div>

    <!-- Sección inferior para créditos de propiedad intelectual y origen -->
    <div class="footer-bottom">
      <p class="footer-copy">
        © 2026 <span>MetroWeb Panamá</span>. Todos los derechos reservados.
      </p>
      <p class="footer-copy">Hecho en 🇵🇦 Panamá</p>
    </div>
  </div>
</footer>

<!-- Cierre de las etiquetas globales del documento HTML (Abiertas originalmente en home.jsp) -->
</body>
</html>