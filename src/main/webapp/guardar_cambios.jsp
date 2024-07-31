<%@ page import="com.DatabaseConnector" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%


// Per saber quina casella hem seleccionat
String id = request.getParameter("id");
String columnName = request.getParameter("columnName");
String newValue = request.getParameter("newValue");


// Verifiquem si hi ha paràmetres null
if (id != null && columnName != null && newValue != null) {
Connection connection = null;
PreparedStatement preparedStatement = null;


try {
	
  // Connexió base de dades
  connection = DatabaseConnector.getConnection();
  


// Actualització de la casella 
String query = "UPDATE MAQUINARI SET `" + columnName + "` = ? WHERE id = ?";
preparedStatement = connection.prepareStatement(query);
        
               
        
// Valors NULL
if (newValue.equals("-")) {preparedStatement.setNull(1, java.sql.Types.NULL);} 
else {preparedStatement.setString(1, newValue);}
preparedStatement.setString(2, id);



// Update
int rowsAffected = preparedStatement.executeUpdate();



// Respostes
if (rowsAffected > 0) {
    out.println("Els canvis s'han desat correctament.");
} else {
    out.println("No s'han realitzat canvis.");
}
} catch (SQLException e) {
    out.println("Error en executar la consulta SQL: " + e.getMessage());
    e.printStackTrace();
} finally {
    try {
        if (preparedStatement != null) preparedStatement.close();
        if (connection != null) connection.close();
    } catch (SQLException e) {
        out.println("Error en tancar la connexió: " + e.getMessage());
        e.printStackTrace();
    }
}
} else {
    out.println("Algun dels paràmetres és nul.");
}
%>


