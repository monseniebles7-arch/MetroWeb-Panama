<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    // VARIABLES DE CONTEO
    int totalUsuarios = 0;
    
    // Conteos por Estado (IDs: 1=Activa, 2=Bloqueada, 3=Vencida)
    int tarjetasActivas = 0;
    int tarjetasBloqueadas = 0;
    int tarjetasVencidas = 0;
    
    // Conteos por Tipo (IDs: 1=General, 2=Estudiante, 3=Jubilado)
    int tarjetasRegulares = 0;
    int tarjetasEstudiantes = 0;
    int tarjetasJubilados = 0;

    Connection cn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/metrowebpanama2", "root", "");

        // 1. Conteo de la tabla Usuario
        String sqlUsers = "SELECT COUNT(*) FROM Usuario";
        ps = cn.prepareStatement(sqlUsers);
        rs = ps.executeQuery();
        if(rs.next()) { totalUsuarios = rs.getInt(1); }
        rs.close(); ps.close();

        // 2. Conteo por Estado usando tus IDs numéricos de la tabla 'tarjeta'
        String sqlEstados = "SELECT " +
                            "COUNT(CASE WHEN id_estado = 1 THEN 1 END), " +
                            "COUNT(CASE WHEN id_estado = 2 THEN 1 END), " +
                            "COUNT(CASE WHEN id_estado = 3 THEN 1 END) " +
                            "FROM tarjeta";
        ps = cn.prepareStatement(sqlEstados);
        rs = ps.executeQuery();
        if(rs.next()) {
            tarjetasActivas = rs.getInt(1);
            tarjetasBloqueadas = rs.getInt(2);
            tarjetasVencidas = rs.getInt(3);
        }
        rs.close(); ps.close();

        // 3. Conteo por Tipo usando tus IDs numéricos de la tabla 'tarjeta'
        String sqlTipos = "SELECT " +
                          "COUNT(CASE WHEN id_tipo_tarjeta = 1 THEN 1 END), " +
                          "COUNT(CASE WHEN id_tipo_tarjeta = 2 THEN 1 END), " +
                          "COUNT(CASE WHEN id_tipo_tarjeta = 3 THEN 1 END) " +
                          "FROM tarjeta";
        ps = cn.prepareStatement(sqlTipos);
        rs = ps.executeQuery();
        if(rs.next()) {
            tarjetasRegulares = rs.getInt(1);
            tarjetasEstudiantes = rs.getInt(2);
            tarjetasJubilados = rs.getInt(3);
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch(Exception e){}
        if (ps != null) try { ps.close(); } catch(Exception e){}
        if (cn != null) try { cn.close(); } catch(Exception e){}
    }

    // Calcular escala visual para las gráficas
    int maxEstado = Math.max(tarjetasActivas, Math.max(tarjetasBloqueadas, tarjetasVencidas));
    int maxTipo = Math.max(tarjetasRegulares, Math.max(tarjetasEstudiantes, tarjetasJubilados));
    
    if (maxEstado == 0) maxEstado = 1;
    if (maxTipo == 0) maxTipo = 1;
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Inicio | MetroWeb Panamá</title>
    <link rel="stylesheet" href="CSS/style.css"/>
    <style>
        .contenedor-graficas {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(450px, 1fr));
            gap: 24px;
            margin-top: 24px;
        }
        .grafica-card {
            background: var(--blanco);
            padding: 24px;
            border-radius: var(--radio-xl);
            box-shadow: var(--sombra-sm);
        }
        .grafica-columnas {
            display: flex;
            justify-content: space-around;
            align-items: flex-end;
            height: 200px;
            border-bottom: 2px solid #ccc;
            padding-top: 20px;
            margin-bottom: 10px;
        }
        .columna-wrapper {
            display: flex;
            flex-direction: column;
            align-items: center;
            width: 70px;
        }
        .columna-barra {
            width: 100%;
            border-radius: var(--radio) var(--radio) 0 0;
            transition: height 0.5s ease;
            position: relative;
        }
        .columna-valor {
            font-size: var(--text-sm);
            font-weight: 700;
            margin-bottom: 4px;
        }
        .columna-etiqueta {
            font-size: var(--text-xs);
            font-weight: 600;
            color: var(--text-mutado);
            text-align: center;
            margin-top: 8px;
        }
        /* Paletas visuales */
        .barra-activa { background-color: #28a745; }
        .barra-bloqueada { background-color: #dc3545; }
        .barra-vencida { background-color: #ffc107; }
        
        .barra-general { background-color: var(--azul); }
        .barra-estudiante { background-color: var(--naranja); }
        .barra-jubilado { background-color: #6f42c1; }
    </style>
</head>
<body>

<jsp:include page="componentes/header_admin.jsp" />

<main class="admin-layout-horizontal">
    <section class="admin-body">
        
        <div class="panel-header">
            <h2>Métricas del Sistema</h2>
            <p class="subtitulo">Resumen operativo de MetroWeb Panamá en tiempo real</p>
        </div>
        
        <!-- CARD METRICA TOTAL USUARIOS -->
        <div class="grid-cards mb-6" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 16px;">
            <div class="card card-accent card-sm" style="border-left: 5px solid var(--naranja);">
                <div class="card-body">
                    <span class="etiqueta" style="color: var(--naranja); font-weight: 600;">Usuarios Totales Registrados</span>
                    <h2 class="mt-4 text-azul fw-700" style="font-size: 2.5rem; margin-top: 8px;"><%= totalUsuarios %></h2>
                </div>
            </div>
        </div>

        <!-- SECCIÓN DE GRÁFICAS -->
        <div class="contenedor-graficas">
            
            <!-- Grafica de Estados -->
            <div class="grafica-card">
                <h3 class="text-azul" style="margin-bottom: 16px;">💳 Tarjetas por Estado</h3>
                <div class="grafica-columnas">
                    <div class="columna-wrapper">
                        <span class="columna-valor" style="color: #28a745;"><%= tarjetasActivas %></span>
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

            <!-- Grafica de Tipos -->
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
        
    </section>
</main>

<jsp:include page="componentes/footer.jsp" />

</body>
</html>