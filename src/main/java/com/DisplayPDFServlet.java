package com;

import java.io.IOException;
import java.io.OutputStream;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet("/displayPDF")
public class DisplayPDFServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public DisplayPDFServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");

        if (idStr != null) {
            int id = Integer.parseInt(idStr);

            PDFService pdfService = new PDFService();
            byte[] pdfData = null;
            try {
                pdfData = pdfService.getPDFById(id);
            } catch (SQLException e) {
                e.printStackTrace();
            }

            if (pdfData != null) {
                response.setContentType("application/pdf");
                response.setContentLength(pdfData.length);

                OutputStream out = response.getOutputStream();
                out.write(pdfData);
                out.close();
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND); 
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST); 
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}

