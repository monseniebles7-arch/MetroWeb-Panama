<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // =========================================================================
    // 1. CONFIGURACIÓN DE SESIÓN Y VARIABLES DE CONTROL (CÓDIGO SERVIDOR - JAVA)
    // =========================================================================
    Integer idUsuarioLogueado = (Integer) session.getAttribute("id_usuario");
    if (idUsuarioLogueado == null) {
        idUsuarioLogueado = 2; // ID de respaldo temporal para pruebas en entorno local
    }

    String mensajeAlerta = null;
    boolean esExito = false;

    // =========================================================================
    // 2. BLOQUE POST: CAPTURA Y PROCESAMIENTO DE LOS DATOS
    // =========================================================================
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        request.setCharacterEncoding("UTF-8");
        
        String txtNumero = request.getParameter("numTarjeta");
        String txtAlias = request.getParameter("aliasTarjeta");
        int idTipoTarjeta = Integer.parseInt(request.getParameter("tipoTarjeta")); 

        Connection cn = null;
        PreparedStatement psInsert = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/metrowebpanama2", "root", "");

            String sqlInsert = "INSERT INTO Tarjeta (numero_tarjeta, alias_tarjeta, saldo, id_estado, id_tipo_tarjeta, id_usuario) VALUES (?, ?, 0.00, 1, ?, ?)";
            psInsert = cn.prepareStatement(sqlInsert);
            psInsert.setString(1, txtNumero.trim());
            psInsert.setString(2, txtAlias.trim());
            psInsert.setInt(3, idTipoTarjeta);
            psInsert.setInt(4, idUsuarioLogueado);
            
            psInsert.executeUpdate();
            esExito = true;
            
        } catch (Exception e) {
            e.printStackTrace(); 
            mensajeAlerta = "⚠️ Error en la Base de Datos: " + e.getMessage();
        } finally {
            if (psInsert != null) try { psInsert.close(); } catch(Exception e){}
            if (cn != null) try { cn.close(); } catch(Exception e){}
        }

        if (esExito) {
            response.sendRedirect("usuario_inicio.jsp");
            return;
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Agregar Tarjeta — MetroWeb Panamá</title>
    <link rel="stylesheet" href="CSS/style.css"/>
</head>
<body>

    <%-- jsp:include: Renderiza dinámicamente el archivo header.jsp de la carpeta componentes. 
         Sirve para no tener que copiar y pegar el mismo menú de navegación en todas las páginas --%>
    <jsp:include page="componentes/header.jsp" />

    <%-- Etiqueta <main>: Indica al navegador y a los buscadores el contenido central y principal de este archivo.
         La clase 'contenedor' limita los márgenes laterales y 'seccion' le da un espaciado vertical --%>
    <main class="contenedor seccion">
        
        <%-- Div estructural para centrar el formulario. El 'max-width: 500px' hace que no se estire feo en pantallas grandes
             y el 'margin: 40px auto' lo separa del menú y lo centra perfectamente de manera horizontal --%>
        <div style="max-width: 500px; margin: 40px auto;">
            
            <%-- Caja contenedora blanca (o con estilos de tarjeta). El width: 100% asegura que use todo el espacio 
                 del div padre anterior, y 'box-sizing: border-box' evita que los paddings ensanchen la caja --%>
            <div class="hero-login" style="float: none; width: 100%; box-sizing: border-box;">
                
                <%-- Títulos principales de la tarjeta de vinculación --%>
                <h3>Vincular Tarjeta</h3>
                <p class="subtitulo">Registra tu tarjeta del Metro o Metrobús</p>

                <%-- Bloque condicional de Java en JSP. Si la variable 'mensajeAlerta' tiene texto (porque falló el INSERT),
                     el servidor incluirá el siguiente bloque DIV de HTML en la respuesta enviada al usuario --%>
                <% if (mensajeAlerta != null) { %>
                    <%-- Div de error estilizado con fondo rojo suave (#fce4e4), texto rojo oscuro (#cc0000) y bordes redondeados --%>
                    <div class="alerta alerta-error" style="background-color: #fce4e4; border: 1px solid #fcc2c2; color: #cc0000; padding: 12px; margin-bottom: 20px; border-radius: 6px; font-weight: 500; text-align: center;">
                        <%-- <%= %>: Inserta el mensaje de error de la excepción de base de datos directamente como texto legible --%>
                        <%= mensajeAlerta %>
                    </div>
                <% } %>

                <%-- Formulario HTML: Al presionar el botón "Guardar", empaqueta los inputs y recarga la página usando POST.
                     Apunta a 'agregar-tarjeta.jsp' para que el script de Java de arriba procese los datos --%>
                <form action="agregar-tarjeta.jsp" method="POST">
                    
                    <%-- Bloque del primer campo: Número de tarjeta --%>
                    <div class="campo">
                        <%-- <label>: El texto guía del input. El atributo 'for' se enlaza con el 'id' del input para mejorar la accesibilidad --%>
                        <label for="numTarjeta">Número de Tarjeta</label>
                        
                        <%-- <input>: Caja de texto. 
                             - name="numTarjeta": Es la clave obligatoria para que Java lo lea con request.getParameter("numTarjeta").
                             - required: Impide que el usuario envíe el formulario si la caja está vacía.
                             - maxlength="20": Restringe en el navegador que metan más de 20 caracteres --%>
                        <input 
                            type="text" 
                            id="numTarjeta" 
                            name="numTarjeta" 
                            placeholder="Ej. 91040997" 
                            required 
                            maxlength="20"
                        />
                        <%-- <small>: Texto explicativo secundario en letras pequeñas (0.8rem) y color gris para guiar al usuario --%>
                        <small style="color: var(--gris-texto); font-size: 0.8rem; display: block; margin-top: 5px;">
                            Introduce los dígitos que aparecen al reverso de tu tarjeta.
                        </small>
                    </div>

                    <%-- Bloque del segundo campo: Alias o nombre personalizado --%>
                    <div class="campo" style="margin-top: 20px;">
                        <label for="aliasTarjeta">Nombre personalizado (Alias)</label>
                        <input 
                            type="text" 
                            id="aliasTarjeta" 
                            name="aliasTarjeta" 
                            placeholder="Ej. Mi Tarjeta Principal" 
                            required
                        />
                    </div>

                    <%-- Bloque del tercer campo: Selector (Dropdown) de tipo de usuario --%>
                    <div class="campo" style="margin-top: 20px;">
                        <label for="tipoTarjeta">Tipo de Usuario</label>
                        
                        <%-- <select>: Lista desplegable. Los estilos en línea aseguran que ocupe todo el ancho (100%),
                             tenga un padding cómodo para tocar en móviles y un fondo blanco limpio --%>
                        <select id="tipoTarjeta" name="tipoTarjeta" style="width: 100%; padding: 10px; border: 1px solid var(--gris-borde); border-radius: 4px; background: white; font-family: inherit;">
                            <%-- <option>: Cada alternativa de la lista. 
                                 El atributo 'value' contiene los números (1, 2, 3) que representan los IDs de tu tabla 'id_tipo_tarjeta' --%>
                            <option value="1">Regular</option>
                            <option value="2">Estudiante</option>
                            <option value="3">Jubilado / Tercera Edad</option>
                        </select>
                    </div>

                    <%-- <button type="submit">: Botón de confirmación. Al hacerle clic, valida el formulario 
                         y dispara el envío de datos de los inputs hacia el backend. Usa la clase 'btn-full' para expandirse --%>
                    <button type="submit" class="btn btn-primario btn-full" style="margin-top: 30px;">
                          Guardar y Vincular
                    </button>
                    
                    <%-- <a>: Enlace normal. Si el usuario se arrepiente, este botón no envía ningún dato a la base de datos,
                         sino que redirige el navegador de vuelta a la página del perfil de usuario --%>
                    <a href="perfil.jsp" style="display: block; text-align: center; margin-top: 15px; color: var(--azul-primario); text-decoration: none; font-size: 0.9rem;">
                        Cancelar y volver al perfil
                    </a>
                </form>
            </div>
        </div>
    </main>

    <%-- jsp:include: Trae el pie de página común e institucional (footer.jsp) y lo acopla al final de la estructura HTML --%>
    <jsp:include page="componentes/footer.jsp" />

</body>
</html>