<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>
<%
    String mensajeError = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        request.setCharacterEncoding("UTF-8");
        String correo = request.getParameter("correo");
        String contrasena = request.getParameter("contrasena");

        if (correo != null && contrasena != null) {
            Connection cn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            
            PreparedStatement psCount = null;
            ResultSet rsCount = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/metrowebpanama2", "root", "");

                String sql = "SELECT id_usuario, nombre, hash_contrasena, id_rol FROM Usuario WHERE correo = ?";
                ps = cn.prepareStatement(sql);
                ps.setString(1, correo.trim());
                rs = ps.executeQuery();

                if (rs.next()) {
                    String hashBD = rs.getString("hash_contrasena").trim();
                    String passIngresada = contrasena.trim();

                    if (BCrypt.checkpw(passIngresada, hashBD)) {
                        
                        int idUsuario = rs.getInt("id_usuario");
                        int idRol = rs.getInt("id_rol");

                        session.setAttribute("id_usuario", idUsuario);
                        session.setAttribute("nombre_usuario", rs.getString("nombre"));
                        session.setAttribute("id_rol", idRol);

                        if (idRol == 1) {
                            response.sendRedirect("admin_inicio.jsp");
                            return;
                        } else {
                            String sqlCount = "SELECT COUNT(*) AS total FROM Tarjeta WHERE id_usuario = ?";
                            psCount = cn.prepareStatement(sqlCount);
                            psCount.setInt(1, idUsuario);
                            rsCount = psCount.executeQuery();

                            int cantidadTarjetas = 0;
                            if (rsCount.next()) {
                                cantidadTarjetas = rsCount.getInt("total");
                            }

                            if (cantidadTarjetas == 0) {
                                response.sendRedirect("agregar-tarjeta.jsp");
                                return;
                            } else {
                                response.sendRedirect("usuario_inicio.jsp");
                                return;
                            }
                        }

                    } else {
                        mensajeError = "❌ Correo electrónico o contraseña incorrectos.";
                    }
                } else {
                    mensajeError = "❌ Correo electrónico o contraseña incorrectos.";
                }
            } catch (Exception e) {
                mensajeError = "⚠️ Error de conexión con el sistema: " + e.getMessage();
            } finally {
                if (rsCount != null) try { rsCount.close(); } catch(Exception e){}
                if (psCount != null) try { psCount.close(); } catch(Exception e){}
                if (rs != null) try { rs.close(); } catch(Exception e){}
                if (ps != null) try { ps.close(); } catch(Exception e){}
                if (cn != null) try { cn.close(); } catch(Exception e){}
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>MetroWeb Panamá — Inicio</title>
  <link rel="stylesheet" href="CSS/style.css"/>
  
  <jsp:include page="componentes/header_home.jsp" />
  
</head>
<body>

<main>
  <section class="hero">
    <div class="hero-inner">

      <div class="hero-texto">
        <h1>Tu transporte público,<br><span>más inteligente</span></h1>
        <p>
          Gestiona tus viajes en el Metro de Panamá y los buses del sistema
          Metrobús desde una sola plataforma. Recarga tu tarjeta, consulta
          tu historial y más.
        </p>
        <div class="hero-btns">
          <a href="registro.jsp" class="btn btn-naranja btn-lg">Crear cuenta gratis</a>
        </div>
      </div>

      <div class="hero-login">
        <h3>Inicia sesión</h3>
        <p class="subtitulo">Accede a tu cuenta MetroWeb</p>

        <% if (mensajeError != null) { %>
          <div class="alerta alerta-error">
             <%= mensajeError %>
          </div>
        <% } %>

        <% if ("1".equals(request.getParameter("registro_exito"))) { %>
          <div class="alerta alerta-exito">
            ✅ Cuenta creada exitosamente. ¡Inicia sesión!
          </div>
        <% } %>

        <form action="home.jsp" method="POST">
          <div class="campo">
            <label for="correo">Correo electrónico</label>
            <input type="email" id="correo" name="correo" placeholder="usuario@correo.com" required/>
          </div>
          <div class="campo">
            <label for="contrasena">Contraseña</label>
            <input type="password" id="contrasena" name="contrasena" placeholder="••••••••" required/>
          </div>
          <a href="recuperar.html" class="footer-olvide">¿Olvidaste tu contraseña?</a>
          <button type="submit" class="btn btn-primario btn-full">
            Iniciar Sesión
          </button>
        </form>

        <div class="login-pie">
           ¿No tienes cuenta? <a href="registro.jsp">Regístrate gratis</a>
        </div>
      </div>

    </div>
  </section>

  <section class="seccion-stats">
    <div class="stats-inner">
      <div class="stat-item"><h2>30</h2><p>Estaciones de Metro</p></div>
      <div class="stat-item"><h2>150+</h2><p>Rutas de Bus</p></div>
      <div class="stat-item"><h2>2</h2><p>Líneas del Metro</p></div>
      <div class="stat-item"><h2>24/7</h2><p>Disponibilidad</p></div>
    </div>
  </section>

  <section class="seccion-noticias">
    <div class="noticias-inner">

      <div class="noticias-titulo">
        <span class="etiqueta">Actualidad</span>
        <h2>Noticias del Metro de Panamá</h2>
      </div>

      <div class="noticias-grid">

        <div class="articulos-col">

          <article class="noticia-card">
            <div class="noticia-body">
              <div class="noticia-meta">
                <span class="badge badge-azul">Artículo</span>
                <span class="noticia-fecha">📅 10 de junio, 2026</span>
              </div>
              <h3>MiBus reporta un incremento de más de 7.2 millones de pasajeros movilizados en los primeros cinco meses de 2026</h3>
              <p>
                MiBus, empresa encargada de la operación del transporte público de pasajeros en la Ciudad de Panamá y San Miguelito, informa que, durante los primeros cinco meses de 2026 (enero a mayo), el sistema ha movilizado un total de 61,874,885 pasajeros. Esta cifra representa un aumento significativo en comparación con el mismo periodo del año 2025, cuando se registraron 54,578,710 usuarios. Esto se traduce en un balance positivo de +7,296,175 pasajeros adicionales que han utilizado la red de MiBus este año frente al año pasado.
              </p>
              <a href="https://www.mibus.com.pa/noticia/mibus-reporta-un-incremento-de-mas-de-7-2-millones-de-pasajeros-movilizados-en-los-primeros-cinco-meses-de-2026/" target="_blank" class="noticia-link">
                Leer noticia completa →
              </a>
            </div>
          </article>

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
              <a href="https://www.telemetro.com/nacionales/teleferico-panama-y-san-miguelito-queda-propuestas-licitacion-informo-el-metro-panama-n6080574" target="_blank" class="noticia-link">
                Leer noticia completa →
              </a>
            </div>
          </article>

        </div>

        <div class="video-col">
          <div class="video-card">
            <div class="video-thumb">
              <iframe
                src="https://www.youtube.com/embed/IuyetberOiQ"
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

<jsp:include page="componentes/footer.jsp" />

</body>
</html>