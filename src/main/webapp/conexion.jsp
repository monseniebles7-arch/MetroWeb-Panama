<%@ page import="java.sql.*" %>

<html>
<body>

<%
try {
    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection cn = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/metroweb",
        "root",
        ""
    );

    out.println("✔ Conexión exitosa a la base de datos Metroweb");

    cn.close();

} catch(Exception e) {
    out.println("❌ Error: " + e.getMessage());
}
%>

</body>
</html>