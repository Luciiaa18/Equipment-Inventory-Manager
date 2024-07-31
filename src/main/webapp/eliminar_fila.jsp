<%@ page import="java.sql.*, com.DatabaseConnector" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String id = request.getParameter("id");
    Connection connection = null;
    PreparedStatement statement = null;

    try {
        connection = DatabaseConnector.getConnection();
        String query = "DELETE FROM MAQUINARI WHERE id = ?";
        statement = connection.prepareStatement(query);
        statement.setString(1, id);
        int rowsDeleted = statement.executeUpdate();

        if (rowsDeleted > 0) {
            out.println("La fila amb ID " + id + " s'ha eliminat correctament.");
        } else {
            out.println("No s'ha pogut eliminar la fila amb ID " + id + ".");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        try {
            if (statement != null) statement.close();
            if (connection != null) connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
