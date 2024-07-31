package com;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/uploadPDF")
@MultipartConfig
public class UploadPDFServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public UploadPDFServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        Part filePart = request.getPart("file");

        if (idStr != null && filePart != null) {
            int id = Integer.parseInt(idStr);

            try (InputStream fileContent = filePart.getInputStream()) {
                savePDFToDatabase(id, fileContent);

                response.setContentType("application/json");
                response.getWriter().write("{\"success\": true}");
            } catch (SQLException e) {
                e.printStackTrace();
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
            }
        } else {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Missing parameters\"}");
        }
    }

    private void savePDFToDatabase(int id, InputStream pdfContent) throws SQLException {
        String sql = "UPDATE MAQUINARI SET pdf = ? WHERE id = ?";
        try (Connection conn = DatabaseConnector.getConnection(); 
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setBinaryStream(1, pdfContent);
            stmt.setInt(2, id);
            stmt.executeUpdate();
        }
    }
}
