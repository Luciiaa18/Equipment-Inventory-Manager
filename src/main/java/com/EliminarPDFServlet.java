package com;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/eliminarPDF")
public class EliminarPDFServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        eliminarPDF(request, response);
    }

    // Soporte temporal para GET para propósitos de depuración
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        eliminarPDF(request, response);
    }

    private void eliminarPDF(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");

        // Verifica si el parámetro "id" no está en los parámetros directos
        if (id == null) {
            // Intenta obtener el parámetro "id" de la URL
            String pathInfo = request.getPathInfo();
            if (pathInfo != null && pathInfo.length() > 1) {
                id = pathInfo.substring(1); // Esto elimina el "/" inicial
            }
        }

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            // Obtener la conexión a la base de datos desde DatabaseConnector
            conn = DatabaseConnector.getConnection();

            // Consulta SQL para actualizar el campo PDF a NULL
            String sql = "UPDATE MAQUINARI SET PDF = NULL WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, id);

            int rows = stmt.executeUpdate();

            if (rows > 0) {
                response.setStatus(HttpServletResponse.SC_OK);
                System.out.println("PDF eliminado correctamente para el ID " + id);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                System.err.println("No se encontró ningún registro con el ID " + id);
            }
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            e.printStackTrace();  // Imprime el stack trace completo en la consola
            System.err.println("Error al eliminar el PDF: " + e.getMessage());
        } finally {
            try {
                if (stmt != null) stmt.close();
            } catch (SQLException e) {
                // Manejo opcional de excepciones al cerrar el statement
                e.printStackTrace();
            }
            try {
                if (conn != null) conn.close();
            } catch (SQLException e) {
                // Manejo opcional de excepciones al cerrar la conexión
                e.printStackTrace();
            }
        }
    }
}

