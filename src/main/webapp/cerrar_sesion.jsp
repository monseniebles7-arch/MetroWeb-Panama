<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Destruye por completo la sesión actual del usuario
    session.invalidate();
    
    // Te redirige al Home (Menú de inicio)
    response.sendRedirect("home.jsp");
%>