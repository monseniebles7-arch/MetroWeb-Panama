<%-- Configuración de la directiva de página para definir el tipo de contenido y la codificación UTF-8 --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Importación de la librería JSTL Core para el correcto manejo de rutas dinámicas --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // Obtenemos la URI actual para evaluar en qué página interna del panel de administración está el usuario
    String uriFooterAdmin = request.getRequestURI();
    String paginaActualAdmin = uriFooterAdmin.substring(uriFooterAdmin.lastIndexOf("/") + 1);
%>

<!-- Inicio del pie de página global para el Panel de Administración -->
<footer class="footer-principal">
  <div class="footer-inner">
    
    <!-- Contenedor principal en cuadrícula (Grid) para organizar las columnas -->
    <div class="footer-grid">
      
      <!-- Columna 1: Información de la marca, descripción del rol y badges de control administrativo -->
      <div>
        <div class="footer-marca">🚇 Metro<span>Web</span> Panamá</div>
        <p class="footer-desc">
          Módulo de Control de Administración. Plataforma interna para la gestión, supervisión y mantenimiento del sistema de transporte público.
        </p>
        <div class="footer-lineas">
          <span class="footer-badge footer-badge-l1" style="background-color: #7f8c8d;">Panel Admin</span>
          <span class="footer-badge footer-badge-l2">Modo Seguro</span>
        </div>
      </div>

      <!-- Columna 2: Enlaces de Gestión Operativa del Sistema -->
      <div class="footer-col">
        <h4>Gestión</h4>
        <ul>
          <%-- 1. Inicio --%>
          <li>
            <a href="<c:url value='/admin_inicio.jsp'/>" class="<%= paginaActualAdmin.equals("admin_inicio.jsp") ? "activo" : "" %>">🏠 Inicio</a>
          </li>
          <%-- 2. Usuarios (Se activa tanto en la tabla principal como en el formulario de edición usuario_admin.jsp) --%>
          <li>
            <a href="<c:url value='/gestion_usuarios.jsp'/>" class="<%= paginaActualAdmin.equals("gestion_usuarios.jsp") || paginaActualAdmin.equals("usuario_admin.jsp") ? "activo" : "" %>">👥 Usuarios</a>
          </li>
          <%-- 3. Tarjetas --%>
          <li>
            <a href="<c:url value='/admin_tarjetas.jsp'/>" class="<%= paginaActualAdmin.equals("admin_tarjetas.jsp") ? "activo" : "" %>">💳 Tarjetas</a>
          </li>
        </ul>
      </div>

      <!-- Columna 3: Enlaces de Reportes, Soporte Informativo y Cierre de Sesión -->
      <div class="footer-col">
        <h4>Soporte</h4>
        <ul>
          <%-- 4. Reportes --%>
          <li>
            <a href="<c:url value='/admin_reportes.jsp'/>" class="<%= paginaActualAdmin.equals("admin_reportes.jsp") ? "activo" : "" %>">📊 Reportes</a>
          </li>
          <%-- 5. Sobre nosotros --%>
          <li>
            <a href="<c:url value='/nosotros.jsp'/>" class="<%= paginaActualAdmin.equals("nosotros.jsp") ? "activo" : "" %>">ℹ️ Sobre nosotros</a>
          </li>
          <%-- 6. Cerrar sesión por medio del Servlet correspondiente --%>
          <li>
            <a href="<c:url value='/CerrarSesionServlet'/>">🚪 Cerrar sesión</a>
          </li>
        </ul>
      </div>
    </div>

    <!-- Sección inferior para créditos de propiedad intelectual del módulo de control -->
    <div class="footer-bottom">
      <p class="footer-copy">
        © 2026 <span>MetroWeb Panamá</span>. Panel de Control y Administración.
      </p>
      <p class="footer-copy">Hecho en 🇵🇦 Panamá</p>
    </div>
  </div>
</footer>

<!-- Cierre de las etiquetas globales del documento HTML (Abiertas originalmente en la página que consume este footer) -->
</body>
</html>