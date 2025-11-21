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
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Proxy;

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

    public Connection openNewConnection() throws SQLException {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            return DriverManager.getConnection(DB_URL, DB_USER, DB_PWD);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
            throw new SQLException("Driver not found", ex);
        }
    }

    public ResultSet executeSelectQuery(String qr, Object[] params) throws SQLException {
        // Legacy: keep for backward compatibility but open a new connection so caller
        // can close the ResultSet without affecting the shared connection.
        Connection conn = openNewConnection();
        PreparedStatement statement = conn.prepareStatement(qr);
        if (params != null) {
            for (int i = 0; i < params.length; i++) {
                statement.setObject(i + 1, params[i]);
            }
        }
        // Note: caller MUST close the ResultSet. We return a dynamic proxy that
        // delegates all calls to the real ResultSet but intercepts close() to also
        // close the PreparedStatement and Connection, preventing leaks.
        final ResultSet realRs = statement.executeQuery();
        InvocationHandler handler = (proxy, method, args) -> {
            if ("close".equals(method.getName())) {
                try { realRs.close(); } finally {
                    try { statement.close(); } catch (Exception e) {}
                    try { conn.close(); } catch (Exception e) {}
                }
                return null;
            }
            return method.invoke(realRs, args);
        };
        return (ResultSet) Proxy.newProxyInstance(
                ResultSet.class.getClassLoader(),
                new Class[]{ResultSet.class},
                handler);
    }

    public int executeQuery(String qr, Object[] params) throws SQLException {
        // Use a dedicated connection and ensure the PreparedStatement is closed automatically.
        try (Connection conn = openNewConnection();
             PreparedStatement statement = conn.prepareStatement(qr)) {
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
    }

    public long executeInsertAndReturnId(String qr, Object[] params) throws SQLException {
        try (Connection conn = openNewConnection();
             PreparedStatement statement = conn.prepareStatement(qr, PreparedStatement.RETURN_GENERATED_KEYS)) {
            if (params != null) {
                for (int i = 0; i < params.length; i++) {
                    statement.setObject(i + 1, params[i]);
                }
            }
            statement.executeUpdate();
            try (ResultSet rs = statement.getGeneratedKeys()) {
                long id = -1L;
                if (rs.next()) {
                    id = rs.getLong(1);
                }
                return id;
            }
        }
    }

    // New helper: run a select query and handle the ResultSet inside the handler,
    // guaranteeing that connection, statement and resultset are closed.
    public interface ResultSetHandler<T> {
        T handle(ResultSet rs) throws SQLException;
    }

    public <T> T query(String sql, Object[] params, ResultSetHandler<T> handler) throws SQLException {
        try (Connection conn = openNewConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (params != null) {
                for (int i = 0; i < params.length; i++) ps.setObject(i + 1, params[i]);
            }
            try (ResultSet rs = ps.executeQuery()) {
                return handler.handle(rs);
            }
        }
    }

    // end of DBContext
}
