<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Obtenemos el archivo cargado para aplicar el sombreado/estilo dinámico de forma sutil
    String uriFooter = request.getRequestURI();
    String paginaActualFooter = uriFooter.substring(uriFooter.lastIndexOf("/") + 1);
%>
<footer>
  <div class="footer-inner">
    <div class="footer-grid">
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

      <%-- Primera columna de enlaces --%>
      <div class="footer-col">
        <h4>Navegación</h4>
        <ul>
          <li><a href="usuario_inicio.jsp" class="<%= paginaActualFooter.equals("usuario_inicio.jsp") ? "activo" : "" %>">Inicio</a></li>
          <li><a href="perfil.jsp" class="<%= paginaActualFooter.equals("perfil.jsp") ? "activo" : "" %>">Perfil</a></li>
          <li><a href="nosotros.jsp" class="<%= paginaActualFooter.equals("nosotros.jsp") ? "activo" : "" %>">Sobre Nosotros</a></li>
          <li><a href="cerrar_sesion.jsp">Cerrar Sesión</a></li>
        </ul>
      </div>

      <%-- Segunda columna de enlaces (Reemplaza a la de Cuenta pública) --%>
      <div class="footer-col">
        <h4>Servicios</h4>
        <ul>
          <li><a href="Recarga_tarjetas.jsp" class="<%= paginaActualFooter.equals("Recarga_tarjetas.jsp") ? "activo" : "" %>">Recargar Tarjeta</a></li>
          <li><a href="agregar-tarjeta.jsp" class="<%= paginaActualFooter.equals("agregar-tarjeta.jsp") ? "activo" : "" %>">Agregar Tarjeta</a></li>
          <li><a href="saldo.jsp" class="<%= paginaActualFooter.equals("saldo.jsp") ? "activo" : "" %>">Saldo</a></li>
          <li><a href="historial_viajes.jsp" class="<%= paginaActualFooter.equals("historial_viajes.jsp") ? "activo" : "" %>">Historial y Movimientos</a></li>
        </ul>
      </div>
    </div>

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