/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
public class DBContext {

    private Connection conn;
    private final String DB_URL = "jdbc:sqlserver://127.0.0.1:1433;databaseName=SweetimalPetCare;encrypt=false";
    private final String DB_USER = "sa";
    private final String DB_PWD = "123456";

    public DBContext() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            this.conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PWD);
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public Connection getConnection() {
        return conn;
    }

    public ResultSet executeSelectQuery(String qr, Object[] params) throws SQLException {
        PreparedStatement statement = this.getConnection().prepareStatement(qr);
        if (params != null) {
            for (int i = 0; i < params.length; i++) {
                statement.setObject(i + 1, params[i]);
            }
        }
        return statement.executeQuery();
    }

    public int executeQuery(String qr, Object[] params) throws SQLException {
        PreparedStatement statement = this.getConnection().prepareStatement(qr);
        if (params != null) {
            for (int i = 0; i < params.length; i++) {
                if (params[i] == null) {
                    statement.setNull(i + 1, java.sql.Types.INTEGER);
                } else {
                    statement.setObject(i + 1, params[i]);
                }

            }
        }
        return statement.executeUpdate();
    }

    public long executeInsertAndReturnId(String qr, Object[] params) throws SQLException {
        PreparedStatement statement = this.getConnection().prepareStatement(qr, PreparedStatement.RETURN_GENERATED_KEYS);
        if (params != null) {
            for (int i = 0; i < params.length; i++) {
                statement.setObject(i + 1, params[i]);
            }
        }
        statement.executeUpdate();

        ResultSet rs = statement.getGeneratedKeys();
        long id = -1L;
        if (rs.next()) {
            id = rs.getLong(1);
        }
        rs.close();
        statement.close();
        return id;
    }
    
}
