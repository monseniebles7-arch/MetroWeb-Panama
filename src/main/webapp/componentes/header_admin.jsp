<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<header>
  <div class="banner">
    <div class="banner-inner">
      <div class="banner-logo">
        <a href="<c:url value='/admin_inicio.jsp'/>">
          <img src="PNGS/logometro.png" alt="MetroWeb Panamá"/>
        </a>
      </div>
    </div>
  </div>

  <nav class="nav-principal">
    <div class="nav-inner">
      <div class="nav-espacio"></div>
      
      <!-- Enlaces del Admin idénticos en estilo al home -->
      <ul class="nav-links">
        <li><a href="<c:url value='/admin_inicio.jsp'/>">🏠 Inicio</a></li>
        <li><a href="<c:url value='/gestion_usuarios.jsp'/>">👥 Usuarios</a></li>
        <li><a href="<c:url value='/admin_tarjetas.jsp'/>">💳 Tarjetas</a></li>
        <li><a href="<c:url value='/admin_reportes.jsp'/>">📊 Reportes</a></li>
        <li><a href="<c:url value='/nosotros.jsp'/>">ℹ️ Sobre nosotros</a></li>
        <li><a href="<c:url value='/CerrarSesionServlet'/>">🚪 Cerrar sesión</a></li>
      </ul>

      <div class="nav-iconos">
        <a href="https://www.google.com" target="_blank" class="icono-busqueda" title="Buscar en Google">🔍 Buscar</a>
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