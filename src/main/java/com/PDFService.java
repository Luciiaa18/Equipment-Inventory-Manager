package com;

import java.io.InputStream;
import java.sql.Connection;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class PDFService {
    public byte[] getPDFById(int id) throws SQLException {
        byte[] pdfData = null;
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            connection = DatabaseConnector.getConnection();
            String sql = "SELECT PDF FROM MAQUINARI WHERE id = ?";
            stmt = connection.prepareStatement(sql);
            stmt.setInt(1, id);
            rs = stmt.executeQuery();

            if (rs.next()) {
                pdfData = rs.getBytes("PDF");
            }
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        }

        return pdfData;
    }

	public boolean uploadPDF(int id, String fileName, InputStream fileContent) {
		// TODO Auto-generated method stub
		return false;
	}
}
