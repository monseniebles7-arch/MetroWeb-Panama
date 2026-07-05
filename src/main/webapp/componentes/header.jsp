<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Obtenemos la URI actual (ejemplo: /MetroWeb/usuario_inicio.jsp)
    String uriActual = request.getRequestURI();
    
    // Extraemos solo el nombre del archivo final para evaluar cuál está cargado
    String paginaActual = uriActual.substring(uriActual.lastIndexOf("/") + 1);
%>
<link rel="stylesheet" href="CSS/style.css">

<header>
  <div class="banner">
    <div class="banner-inner">
      <div class="banner-logo">
        <a href="usuario_inicio.jsp">
          <img src="PNGS/logometro.png" alt="MetroWeb Panamá"/>
        </a>
      </div>
    </div>
  </div>

  <nav class="nav-principal">
    <div class="nav-inner">

      <div class="nav-espacio"></div>

      <ul class="nav-links">
        <%-- 1. Inicio --%>
        <li>
          <a href="usuario_inicio.jsp" class="<%= paginaActual.equals("usuario_inicio.jsp") ? "activo" : "" %>">🏠 Inicio</a>
        </li>
        
        <%-- 2. Perfil --%>
        <li>
          <a href="perfil.jsp" class="<%= paginaActual.equals("perfil.jsp") ? "activo" : "" %>">👥 Perfil</a>
        </li>
        
        <%-- 3. Recargar Tarjeta --%>
        <li>
          <a href="Recarga_tarjetas.jsp" class="<%= paginaActual.equals("Recarga_tarjetas.jsp") ? "activo" : "" %>">💳 Recargar Tarjeta</a>
        </li>
        
        <%-- 4. Agregar Tarjeta --%>
        <li>
          <a href="agregar-tarjeta.jsp" class="<%= paginaActual.equals("agregar-tarjeta.jsp") ? "activo" : "" %>">💳 Agregar Tarjeta</a>
        </li>
        
        <%-- 5. Saldo --%>
        <li>
          <a href="saldo.jsp" class="<%= paginaActual.equals("saldo.jsp") ? "activo" : "" %>">💰 Saldo</a>
        </li>
        
        <%-- 6. Historial y Movimientos --%>
        <li>
          <a href="historial_viajes.jsp" class="<%= paginaActual.equals("historial_viajes.jsp") ? "activo" : "" %>">📊 Historial y Movimientos</a>
        </li>
        
        <%-- 7. Sobre nosotros --%>
        <li>
          <a href="nosotros.jsp" class="<%= paginaActual.equals("nosotros.jsp") ? "activo" : "" %>">ℹ️ Sobre nosotros</a>
        </li>
        
        <%-- 8. Cerrar sesión (Sin efecto permanente por diseño) --%>
        <li>
          <a href="cerrar_sesion.jsp">🚪Cerrar sesión</a>
        </li>
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