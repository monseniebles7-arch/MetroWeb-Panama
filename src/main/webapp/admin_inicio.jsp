<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    /* ==========================================================================
       PARTE 1: CAPTURA DE FECHA Y HORA DEL SISTEMA (PARA EL REPORTE PDF)
       ========================================================================== */
    Date fechaActual = new Date();
    SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat formatoHora = new SimpleDateFormat("hh:mm:ss a");
    String fechaStr = formatoFecha.format(fechaActual);
    String horaStr = formatoHora.format(fechaActual);

    /* ==========================================================================
       PARTE 2: DECLARACIÓN DE VARIABLES PARA CONTADORES DE LA BASE DE DATOS
       ========================================================================== */
    int totalUsuarios = 0;
    
    // Contadores para Gráfica de Estados (Asociados a tus IDs de la base de datos)
    int tarjetasActivas = 0;     // ID = 1
    int tarjetasBloqueadas = 0;  // ID = 2
    int tarjetasVencidas = 0;    // ID = 3
    
    // Contadores para Gráfica de Tipos (Asociados a tus IDs de la base de datos)
    int tarjetasRegulares = 0;   // ID = 1
    int tarjetasEstudiantes = 0; // ID = 2
    int tarjetasJubilados = 0;   // ID = 3

    /* ==========================================================================
       PARTE 3: CONEXIÓN A MYSQL (XAMPP) Y EJECUCIÓN DE CONSULTAS SQL
       ========================================================================== */
    Connection cn = null; 
    PreparedStatement ps = null; 
    ResultSet rs = null;

    try {
        // Inicializa el Driver del conector de MySQL
        Class.forName("com.mysql.cj.jdbc.Driver");
        cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/metrowebpanama2", "root", "");

        // CONSUlTA A: Contar la cantidad total de usuarios registrados
        String sqlUsers = "SELECT COUNT(*) FROM Usuario";
        ps = cn.prepareStatement(sqlUsers); 
        rs = ps.executeQuery();
        if(rs.next()) { totalUsuarios = rs.getInt(1); }
        rs.close(); ps.close();

        // CONSULTA B: Contar tarjetas agrupadas por su ID de Estado (Filtro rápido con CASE WHEN)
        String sqlEstados = "SELECT COUNT(CASE WHEN id_estado = 1 THEN 1 END), " +
                            "COUNT(CASE WHEN id_estado = 2 THEN 1 END), " +
                            "COUNT(CASE WHEN id_estado = 3 THEN 1 END) FROM tarjeta";
        ps = cn.prepareStatement(sqlEstados); 
        rs = ps.executeQuery();
        if(rs.next()) {
            tarjetasActivas = rs.getInt(1);
            tarjetasBloqueadas = rs.getInt(2);
            tarjetasVencidas = rs.getInt(3);
        }
        rs.close(); ps.close();

        // CONSULTA C: Contar tarjetas agrupadas por su ID de Tipo de Tarjeta
        String sqlTipos = "SELECT COUNT(CASE WHEN id_tipo_tarjeta = 1 THEN 1 END), " +
                          "COUNT(CASE WHEN id_tipo_tarjeta = 2 THEN 1 END), " +
                          "COUNT(CASE WHEN id_tipo_tarjeta = 3 THEN 1 END) FROM tarjeta";
        ps = cn.prepareStatement(sqlTipos); 
        rs = ps.executeQuery();
        if(rs.next()) {
            tarjetasRegulares = rs.getInt(1);
            tarjetasEstudiantes = rs.getInt(2);
            tarjetasJubilados = rs.getInt(3);
        }
    } catch (Exception e) {
        e.printStackTrace(); // Muestra errores en la consola de Tomcat si algo falla
    } finally {
        // Cierre preventivo de conexiones para evitar saturar XAMPP
        if (rs != null) try { rs.close(); } catch(Exception e){}
        if (ps != null) try { ps.close(); } catch(Exception e){}
        if (cn != null) try { cn.close(); } catch(Exception e){}
    }

    /* ==========================================================================
       PARTE 4: CÁLCULO MATEMÁTICO DE ESCALAS PARA LAS COLUMNAS CSS
       ========================================================================== */
    // Buscamos el valor más alto de cada gráfica para que sea el 100% de la altura
    int maxEstado = Math.max(tarjetasActivas, Math.max(tarjetasBloqueadas, tarjetasVencidas));
    int maxTipo = Math.max(tarjetasRegulares, Math.max(tarjetasEstudiantes, tarjetasJubilados));
    
    // Si la base de datos está vacía, evitamos dividir entre cero asignando un 1 por defecto
    if (maxEstado == 0) maxEstado = 1;
    if (maxTipo == 0) maxTipo = 1;
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Panel de Control | MetroWeb Panamá</title>
   <link rel="stylesheet" href="CSS/style.css"/>
    
    
</head>
<body>

<!-- Inclusión del Menú Superior de Administración -->
<jsp:include page="componentes/header_admin.jsp" />

<main class="admin-layout-horizontal">
    <section class="admin-body">
        
        <!-- ==========================================================================
             ESTRUCTURA HTML A: CABECERA CON DATOS TEMPORALES Y BOTÓN PDF
             ========================================================================== -->
        <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px; margin-bottom: var(--sp-6);">
            <div>
                <h2>Métricas del Sistema</h2>
                <p class="subtitulo">Resumen operativo de MetroWeb Panamá en tiempo real</p>
                <!-- Despliegue de Fecha y Hora calculadas dinámicamente en Java -->
                <p style="font-size: var(--text-xs); color: var(--text-mutado); margin-top: 4px;">Generado el: <strong><%= fechaStr %></strong> a las <strong><%= horaStr %></strong></p>
            </div>
            <!-- Botón nativo que acciona el módulo de guardado PDF/Impresora -->
            <button onclick="window.print();" class="btn btn-naranja btn-no-print" style="display: flex; align-items: center; gap: 8px; font-weight: 600;">
                📄 Generar Reporte PDF
            </button>
        </div>
        
        <!-- ==========================================================================
             ESTRUCTURA HTML B: INDICADOR TOTAL DE USUARIOS REGISTRADOS
             ========================================================================== -->
        <div class="grid-cards mb-6" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 16px;">
            <div class="card card-accent card-sm" style="border-left: 5px solid var(--naranja);">
                <div class="card-body">
                    <span class="etiqueta" style="color: var(--naranja); font-weight: 600;">Usuarios Totales Registrados</span>
                    <h2 class="mt-4 text-azul fw-700" style="font-size: 2.5rem; margin-top: 8px;"><%= totalUsuarios %></h2>
                </div>
            </div>
        </div>

        <!-- ==========================================================================
             ESTRUCTURA HTML C: SECCIÓN GRÁFICA DE COLUMNAS (TARJETAS)
             ========================================================================== -->
        <div class="contenedor-graficas">
            
            <!-- Gráfica 1: Distribución por Estados (Activa, Bloqueada, Vencida) -->
            <div class="grafica-card">
                <h3 class="text-azul" style="margin-bottom: 16px;">💳 Tarjetas por Estado</h3>
                <div class="grafica-columnas">
                    <div class="columna-wrapper">
                        <span class="columna-valor" style="color: #28a745;"><%= tarjetasActivas %></span>
                        <!-- El alto (height) se calcula de forma proporcional en base al máximo obtenido -->
                        <div class="columna-barra barra-activa" style="height: <%= (tarjetasActivas * 100) / maxEstado %>%;"></div>
                        <span class="columna-etiqueta">Activas</span>
                    </div>
                    <div class="columna-wrapper">
                        <span class="columna-valor" style="color: #dc3545;"><%= tarjetasBloqueadas %></span>
                        <div class="columna-barra barra-bloqueada" style="height: <%= (tarjetasBloqueadas * 100) / maxEstado %>%;"></div>
                        <span class="columna-etiqueta">Bloqueadas</span>
                    </div>
                    <div class="columna-wrapper">
                        <span class="columna-valor" style="color: #ffc107;"><%= tarjetasVencidas %></span>
                        <div class="columna-barra barra-vencida" style="height: <%= (tarjetasVencidas * 100) / maxEstado %>%;"></div>
                        <span class="columna-etiqueta">Vencidas</span>
                    </div>
                </div>
            </div>

            <!-- Gráfica 2: Distribución por Tipo de Tarjeta (General, Estudiante, Jubilado) -->
            <div class="grafica-card">
                <h3 class="text-azul" style="margin-bottom: 16px;">📊 Tarjetas por Tipo</h3>
                <div class="grafica-columnas">
                    <div class="columna-wrapper">
                        <span class="columna-valor" style="color: var(--azul);"><%= tarjetasRegulares %></span>
                        <div class="columna-barra barra-general" style="height: <%= (tarjetasRegulares * 100) / maxTipo %>%;"></div>
                        <span class="columna-etiqueta">General</span>
                    </div>
                    <div class="columna-wrapper">
                        <span class="columna-valor" style="color: var(--naranja);"><%= tarjetasEstudiantes %></span>
                        <div class="columna-barra barra-estudiante" style="height: <%= (tarjetasEstudiantes * 100) / maxTipo %>%;"></div>
                        <span class="columna-etiqueta">Estudiante</span>
                    </div>
                    <div class="columna-wrapper">
                        <span class="columna-valor" style="color: #6f42c1;"><%= tarjetasJubilados %></span>
                        <div class="columna-barra barra-jubilado" style="height: <%= (tarjetasJubilados * 100) / maxTipo %>%;"></div>
                        <span class="columna-etiqueta">Jubilado</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==========================================================================
             ESTRUCTURA HTML D: COMPONENTE DE SIMULACIÓN DE PASAJEROS POR ESTACIÓN
             ========================================================================== -->
        <div class="grafica-card" style="margin-top: 24px;">
            <div style="margin-bottom: 16px;">
                <h3 class="text-azul">🚉 Monitor de Tránsito en Estaciones</h3>
                <p class="subtitulo" style="font-size: var(--text-xs); margin-top: 2px;">Simulación en tiempo real basada en flujos estimados de hora pico</p>
            </div>
            
            <div style="border: 1px solid #e2e8f0; border-radius: var(--radio); overflow: hidden;">
                <!-- Estación Albrook (Línea 1 - Roja) -->
                <div class="estacion-row">
                    <div class="estacion-info">
                        <div class="linea-indicador l1" title="Línea 1"></div>
                        <div>
                            <span class="fw-600" style="display:block;">Albrook</span>
                            <small style="color:var(--text-mutado);">Terminal Central</small>
                        </div>
                    </div>
                    <div style="display: flex; align-items: center; gap: 24px;">
                        <span class="fw-700 text-azul">1,420 pers / hora</span>
                        <span class="badge-trafico trafico-alto">CRÍTICO</span>
                    </div>
                </div>

                <!-- Estación 5 de Mayo (Línea 1 - Roja) -->
                <div class="estacion-row">
                    <div class="estacion-info">
                        <div class="linea-indicador l1" title="Línea 1"></div>
                        <div>
                            <span class="fw-600" style="display:block;">5 de Mayo</span>
                            <small style="color:var(--text-mutado);">Zona Comercial</small>
                        </div>
                    </div>
                    <div style="display: flex; align-items: center; gap: 24px;">
                        <span class="fw-700 text-azul">850 pers / hora</span>
                        <span class="badge-trafico trafico-medio">MODERADO</span>
                    </div>
                </div>

                <!-- Estación Iglesia del Carmen (Línea 1 - Roja) -->
                <div class="estacion-row">
                    <div class="estacion-info">
                        <div class="linea-indicador l1" title="Línea 1"></div>
                        <div>
                            <span class="fw-600" style="display:block;">Iglesia del Carmen</span>
                            <small style="color:var(--text-mutado);">Área Bancaria</small>
                        </div>
                    </div>
                    <div style="display: flex; align-items: center; gap: 24px;">
                        <span class="fw-700 text-azul">1,100 pers / hora</span>
                        <span class="badge-trafico trafico-alto">ALTO</span>
                    </div>
                </div>

                <!-- Estación San Miguelito (Línea 2 - Azul, Punto de Interconexión) -->
                <div class="estacion-row">
                    <div class="estacion-info">
                        <div class="linea-indicador l2" title="Línea 2"></div>
                        <div>
                            <span class="fw-600" style="display:block;">San Miguelito</span>
                            <small style="color:var(--text-mutado);">Interconexión L1/L2</small>
                        </div>
                    </div>
                    <div style="display: flex; align-items: center; gap: 24px;">
                        <span class="fw-700 text-azul">1,890 pers / hora</span>
                        <span class="badge-trafico trafico-alto">CRÍTICO</span>
                    </div>
                </div>

                <!-- Estación Nuevo Tocumen (Línea 2 - Azul) -->
                <div class="estacion-row">
                    <div class="estacion-info">
                        <div class="linea-indicador l2" title="Línea 2"></div>
                        <div>
                            <span class="fw-600" style="display:block;">Nuevo Tocumen</span>
                            <small style="color:var(--text-mutado);">Residencial Este</small>
                        </div>
                    </div>
                    <div style="display: flex; align-items: center; gap: 24px;">
                        <span class="fw-700 text-azul">310 pers / hora</span>
                        <span class="badge-trafico trafico-bajo">FLUIDO</span>
                    </div>
                </div>
            </div>
        </div>
        
    </section>
</main>

<!-- Inclusión del Pie de Página Común -->
<jsp:include page="componentes/footer.jsp" />

</body>
</html>