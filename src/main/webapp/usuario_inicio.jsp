<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // =========================================================================
    // CONTROL DE SEGURIDAD Y CONFIGURACIÓN DE SESIÓN
    // =========================================================================
    // Recuperamos el identificador numérico único del usuario desde la sesión activa del servidor
    Integer idUsuarioLogueado = (Integer) session.getAttribute("id_usuario");
    
    // Filtro de autenticación: Si no existe un registro activo en la sesión, se bloquea el acceso
    if (idUsuarioLogueado == null) {
        response.sendRedirect("home.jsp"); // Redirección inmediata a la página de bienvenida / login
        return; // Interrumpe de manera definitiva el procesamiento del hilo actual
    }
    
    // Obtenemos el nombre del cliente almacenado en memoria para personalizar la interfaz
    String nombreUsuario = (String) session.getAttribute("nombre_usuario");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Tarjetas - MetroWeb Panamá</title>
    <link rel="stylesheet" href="CSS/style.css">
</head>
<body>

    <%-- jsp:include: Carga e inserta de forma modular el componente dinámico común header.jsp (menú de navegación) --%>
    <jsp:include page="componentes/header.jsp" />

    <%-- Etiqueta <main>: Delimita el área de contenido primordial de la página, aplicando márgenes y estilos del layout base --%>
    <main class="contenedor seccion">
        
        <%-- Bloque de bienvenida: Contenedor flexible encargado de renderizar la cabecera del panel de usuario --%>
        <div class="dashboard-bienvenida">
            <div>
                <%-- Etiqueta decorativa superior sutil para dar contexto de ubicación --%>
                <p class="txt-gris-propio">Panel de Control</p>
                <%-- Expresión JSP: Inyecta el nombre completo del usuario directamente en la etiqueta de saludo --%>
                <h2>¡Hola, <%= nombreUsuario %>!</h2>
            </div>
        </div>

        <h3>Mis Tarjetas Asociadas</h3>

        <%-- Grid Contenedor: Estructura bidimensional en CSS que organiza dinámicamente las tarjetas de transporte --%>
        <div class="tarjetas-contenedor-grid">
            
            <%
                // Declaración preventiva de los objetos de la API JDBC fuera del bloque try para asegurar su alcance en el bloque finally
                Connection cn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                
                try {
                    // Inicialización del driver de comunicación nativo para bases de datos relacionales MySQL
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    
                    // Establecimiento del canal de conexión hacia la instancia del servidor local y esquema metrowebpanama2
                    cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/metrowebpanama2", "root", "");
                    
                    // Definición de la consulta preparada: Busca parámetros específicos filtrando de manera segura por el ID del usuario
                    String sql = "SELECT id_tarjeta, numero_tarjeta, alias_tarjeta, saldo FROM tarjeta WHERE id_usuario = ?";
                    ps = cn.prepareStatement(sql);
                    ps.setInt(1, idUsuarioLogueado); // Sustitución segura del comodín para prevenir vulnerabilidades de SQL Injection
                    rs = ps.executeQuery(); // Ejecución y captura de las filas resultantes en la matriz del ResultSet
                    
                    // Variables de control interno para el estado del flujo de datos
                    boolean tieneTarjetas = false;
                    int contador = 0;
                    
                    // Ciclo iterativo while: Recorre secuencialmente cada una de las tarjetas devueltas por la base de datos
                    while(rs.next()) {
                        tieneTarjetas = true; // Se levanta la bandera indicando que el usuario posee al menos un plástico vinculado
                        contador++; // Incremento para la identificación posicional de los elementos gráficos
                        
                        // Extracción de las columnas de la fila actual de la base de datos
                        int idTarjeta = rs.getInt("id_tarjeta");
                        String numeroTarjeta = rs.getString("numero_tarjeta");
                        String aliasTarjeta = rs.getString("alias_tarjeta");
                        double saldo = rs.getDouble("saldo");
                        
                        // Lógica ternaria de negocio: Asigna la etiqueta 'Principal' únicamente al primer plástico y 'Secundaria' a los demás
                        String tipoBadge = (contador == 1) ? "Principal" : "Secundaria";
            %>
                        <%-- TARJETA DINÁMICA: Estructura HTML que se renderizará de forma iterativa por cada registro del ResultSet --%>
                        <div class="tarjeta-transporte">
                            <%-- Cabecera interna: Contiene la información de identificación visual del plástico --%>
                            <div class="tarjeta-header">
                                <div>
                                    <%-- Inyección del alias personalizado de la tarjeta (Ej: 'Mi Metro', 'Tarjeta de Trabajo') --%>
                                    <span class="tarjeta-marca"><%= aliasTarjeta %></span>
                                    <%-- Renderizado dinámico del identificador serial único impreso --%>
                                    <div class="tarjeta-numero">Nº <%= numeroTarjeta %></div>
                                </div>
                                <%-- Distintivo de prioridad dinámico basado en la lógica evaluada arriba --%>
                                <span class="badge badge-azul"><%= tipoBadge %></span>
                            </div>
                            
                            <%-- Cuerpo central: Sección orientada exclusivamente a exponer el estado financiero del plástico --%>
                            <div class="tarjeta-body-saldo">
                                <div class="tarjeta-saldo-label">Saldo Disponible</div>
                                <%-- Formateo monetario riguroso en punto flotante fijando el despliegue a exactamente 2 decimales --%>
                                <div class="tarjeta-saldo-monto">$<%= String.format("%.2f", saldo) %></div>
                            </div>
                            
                            <%-- Vínculo operativo: Envía al cliente al formulario transaccional de depósitos monetarios --%>
                            <a href="Recarga_tarjetas.jsp" class="btn-recarga-tarjeta">
                                Recargar esta tarjeta
                            </a>
                        </div>
            <%
                    } // Fin del ciclo iterativo while
                    
                    // Control de excepciones visuales: Evalúa si el ResultSet finalizó vacío para desplegar un mensaje de estado
                    if (!tieneTarjetas) {
            %>
                        <%-- Bloque informativo alternativo que ocupa todo el espacio del Grid si el cliente no posee registros --%>
                        <div style="grid-column: span 2; padding: 20px; background: #f9f9f9; border-radius: 8px; border: 1px dashed var(--gris-borde); text-align: center;">
                            <p style="color: #666;">Aún no tienes tarjetas registradas.</p>
                        </div>
            <%
                    }
                    
                } catch(Exception e) {
                    // Impresión técnica detallada en la consola del servidor de aplicaciones en caso de fallos en el bloque JDBC
                    System.out.println("❌ Error al cargar el panel de tarjetas: " + e.getMessage());
                } finally {
                    // Bloque de cierre preventivo: Libera los recursos del servidor de bases de datos para evitar fugas de memoria (Memory Leaks)
                    if (rs != null) try { rs.close(); } catch(Exception e){}
                    if (ps != null) try { ps.close(); } catch(Exception e){}
                    if (cn != null) try { cn.close(); } catch(Exception e){}
                }
            %>

            <%-- BOTÓN DE ACCESO DIRECTO: Estilizado con bordes descontinuados que invita al usuario a registrar nuevos plásticos --%>
            <a href="agregar-tarjeta.jsp" class="tarjeta-agregar-nueva">
                <span class="tarjeta-agregar-icono">+</span>
                Agregar nueva tarjeta
            </a>

        </div>

    </main>

    <%-- jsp:include: Carga modular e integra la estructura del pie de página común (footer.jsp) --%>
    <jsp:include page="componentes/footer.jsp" />

</body>
</html>