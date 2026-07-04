<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css">

<header>
  <div class="banner">
    <div class="banner-inner">
      <div class="banner-logo">
        <a href="${pageContext.request.contextPath}/home.jsp">
          <img src="${pageContext.request.contextPath}/PNGS/logometro.png" alt="MetroWeb Panamá"/>
        </a>
      </div>
    </div>
  </div>

  <nav class="nav-principal">
    <div class="nav-inner">

      <div class="nav-espacio"></div>

      <%-- ==========================================================
           El menú se arma según el rol guardado en sesión:
           - sin sesión (invitado)  -> menú público (home.jsp)
           - rol = "usuario"        -> menú del usuario logueado
           - rol = "admin"          -> menú del administrador
           El servlet de login es responsable de guardar:
           session.setAttribute("rol", "usuario");  // o "admin"
      =========================================================== --%>
      <c:choose>

        <%-- ── MENÚ ADMINISTRADOR ── --%>
        <c:when test="${sessionScope.rol == 'admin'}">
          <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}/admin_inicio.jsp">🏠 Inicio</a></li>
            <li><a href="${pageContext.request.contextPath}/admin_usuarios.jsp">👥 Usuarios</a></li>
            <li><a href="${pageContext.request.contextPath}/admin_tarjetas.jsp">💳 Tarjetas</a></li>
            <li><a href="${pageContext.request.contextPath}/admin_reportes.jsp">📊 Reportes</a></li>
            <li><a href="${pageContext.request.contextPath}/nosotros.jsp">ℹ️ Sobre nosotros</a></li>
            <li><a href="${pageContext.request.contextPath}/CerrarSesionServlet">🚪 Cerrar sesión</a></li>
          </ul>
        </c:when>

        <%-- ── MENÚ USUARIO LOGUEADO ── --%>
        <c:when test="${sessionScope.rol == 'usuario'}">
          <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}/usuario_inicio.jsp">🏠 Inicio</a></li>
            <li><a href="${pageContext.request.contextPath}/Recarga_tarjetas.jsp">💳 Recarga de tarjeta</a></li>
            <li><a href="${pageContext.request.contextPath}/saldo.jsp">💰 Saldo y movimientos</a></li>
            <li><a href="${pageContext.request.contextPath}/perfil.jsp">👤 Perfil</a></li>
            <li><a href="${pageContext.request.contextPath}/nosotros.jsp">ℹ️ Sobre nosotros</a></li>
            <li><a href="${pageContext.request.contextPath}/CerrarSesionServlet">🚪 Cerrar sesión</a></li>
          </ul>
        </c:when>

        <%-- ── MENÚ PÚBLICO (sin sesión iniciada) ── --%>
        <c:otherwise>
          <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}/home.jsp">🏠 Inicio</a></li>
            <li><a href="${pageContext.request.contextPath}/nosotros.jsp">ℹ️ Sobre nosotros</a></li>
          </ul>
        </c:otherwise>

      </c:choose>

      <div class="nav-iconos">
        <a href="https://facebook.com" target="_blank" title="Facebook">
          <img src="${pageContext.request.contextPath}/PNGS/facebook.png" alt="Facebook" style="height:26px; width:26px; object-fit:contain;"/>
        </a>
        <a href="https://twitter.com" target="_blank" title="Twitter / X">
          <img src="${pageContext.request.contextPath}/PNGS/twitter.png" alt="Twitter" style="height:26px; width:26px; object-fit:contain;"/>
        </a>
        <a href="https://instagram.com" target="_blank" title="Instagram">
          <img src="${pageContext.request.contextPath}/PNGS/instagram.png" alt="Instagram" style="height:26px; width:26px; object-fit:contain;"/>
        </a>
      </div>

    </div>
  </nav>
</header>
