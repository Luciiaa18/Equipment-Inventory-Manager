<%@ page import="java.sql.*, com.DatabaseConnector" %>

<%
// Obtenir l'ID de la nova fila enviat des de la sol·licitud AJAX
int newId = Integer.parseInt(request.getParameter("id"));

// Establir la connexió a la base de dades
Connection connection = null;
PreparedStatement preparedStatement = null;

try {
    connection = DatabaseConnector.getConnection();
    // Inserir la nova fila a la taula corresponent amb valor "6" a la columna Marca
    String query = "INSERT INTO MAQUINARI (id, Marca) VALUES (?, ?)"; 
    preparedStatement = connection.prepareStatement(query);
    preparedStatement.setInt(1, newId);
    preparedStatement.setInt(2, 6); // Valor fixat a "6" per la columna Marca
    preparedStatement.executeUpdate();

    // Enviar una resposta al client
    response.setContentType("text/plain");
    response.setCharacterEncoding("UTF-8");
    response.getWriter().write("Nova fila inserida correctament amb ID: " + newId + " i Marca: 6");
} catch (SQLException e) {
    
    // Gestionar qualsevol error durant la inserció a la base de dades
    response.setStatus(500); // Error intern del servidor
    response.setContentType("text/plain");
    response.setCharacterEncoding("UTF-8");
    response.getWriter().write("Error en inserir la nova fila a la base de dades: " + e.getMessage());
} finally {
    
    // Tancar la connexió i el PreparedStatement
    if (preparedStatement != null) {
        try {
            preparedStatement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    if (connection != null) {
        try {
            connection.close();
        } catch (SQLException e) {
            e.printStackTrace(); 
         
        }
    }
}
%>
