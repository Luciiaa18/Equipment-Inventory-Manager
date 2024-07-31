package com;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class DatabaseConnector {
    public static Connection getConnection() throws SQLException {
        Connection connection = null;

        try {
            String url = "jdbc:mysql://localhost:3306/INVENTARI";
            String usuario = "user";
            String contraseña = "root";

            Class.forName("com.mysql.cj.jdbc.Driver");

            connection = DriverManager.getConnection(url, usuario, contraseña);

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        return connection;
    }

    // OBTENER MARCAS DISPONIBLES CON ID Y NOMBRE (DE LA BBDD)
    public static ArrayList<Marca> getMarcasDisponibles() throws SQLException {
        ArrayList<Marca> marcas = new ArrayList<>();
        Connection connection = null;
        Statement statement = null;
        ResultSet resultSet = null;

        try {
            connection = getConnection();
            statement = connection.createStatement();
            String query = "SELECT id_marca, nom_marca FROM MARCA";
            resultSet = statement.executeQuery(query);

            while (resultSet.next()) {
                Marca marca = new Marca(0, query);
                marca.setId(resultSet.getInt("id_marca"));
                marca.setNombre(resultSet.getString("nom_marca"));
                marcas.add(marca);
            }
        } finally {
            if (resultSet != null) resultSet.close();
            if (statement != null) statement.close();
            if (connection != null) connection.close();
        }

        return marcas;
    }

    // OBTENER EL ID DE UNA MARCA SI LE PASAMOS SU NOMBRE
    public static int getMarcaIdPorNombre(String nombreMarca) throws SQLException {
        int idMarca = -1; // si no se encuentra la marca

        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            connection = getConnection();
            String query = "SELECT id_marca FROM MARCA WHERE nom_marca = ?";
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, nombreMarca);
            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                idMarca = resultSet.getInt("id_marca");
            }
        } finally {
            if (resultSet != null) resultSet.close();
            if (preparedStatement != null) preparedStatement.close();
            if (connection != null) connection.close();
        }

        return idMarca;
    }
}

