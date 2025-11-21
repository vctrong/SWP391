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
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
public class DBContext {

    private static final Logger LOGGER = Logger.getLogger(DBContext.class.getName());

    private Connection conn;

    private static final String ENV_JDBC_URL = "JDBC_URL";
    private static final String ENV_DB_HOST = "DB_HOST";
    private static final String ENV_DB_PORT = "DB_PORT";
    private static final String ENV_DB_NAME = "DB_NAME";
    private static final String ENV_DB_USER = "DB_USER";
    private static final String ENV_DB_PASS = "DB_PASS";
    private static final String ENV_DB_TYPE = "DB_TYPE"; // optional: "postgres" or "sqlserver"

    // Constructor: cố gắng tạo 1 connection instance (giữ compat với code cũ)
    public DBContext() {
        try {
            this.conn = createConnection();
        } catch (SQLException ex) {
            // Không ném ra để tránh crash ngay tại khởi tạo; log kỹ để debug.
            LOGGER.log(Level.SEVERE, "Cannot create initial DB connection", ex);
            this.conn = null;
        }
    }

    // Trả về connection hiện tại, nếu closed/null thì tự tạo mới.
    public Connection getConnection() {
        try {
            if (this.conn == null || this.conn.isClosed()) {
                this.conn = createConnection();
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error obtaining DB connection", ex);
            return null;
        }
        return this.conn;
    }

    // Luôn mở connection mới (giữ interface giống openNewConnection cũ)
    public Connection openNewConnection() throws SQLException {
        return createConnection();
    }

    // SELECT trả về ResultSet như cũ — LƯU Ý: caller phải đóng ResultSet (và statement/connection) sau khi dùng.
    public ResultSet executeSelectQuery(String qr, Object[] params) throws SQLException {
        Connection c = getConnection();
        if (c == null) {
            throw new SQLException("No DB connection available");
        }
        PreparedStatement statement = c.prepareStatement(qr);
        if (params != null) {
            for (int i = 0; i < params.length; i++) {
                statement.setObject(i + 1, params[i]);
            }
        }
        return statement.executeQuery();
    }

    // UPDATE/DELETE/INSERT trả về update count
    public int executeQuery(String qr, Object[] params) throws SQLException {
        Connection c = getConnection();
        if (c == null) {
            throw new SQLException("No DB connection available");
        }
        PreparedStatement statement = c.prepareStatement(qr);
        try {
            if (params != null) {
                for (int i = 0; i < params.length; i++) {
                    if (params[i] == null) {
                        statement.setNull(i + 1, java.sql.Types.NULL);
                    } else {
                        statement.setObject(i + 1, params[i]);
                    }
                }
            }
            return statement.executeUpdate();
        } finally {
            try {
                statement.close();
            } catch (Exception ex) {
                LOGGER.log(Level.WARNING, "Failed closing statement", ex);
            }
            // note: do not close shared connection here
        }
    }

    // Insert và trả về generated key (giống cũ)
    public long executeInsertAndReturnId(String qr, Object[] params) throws SQLException {
        Connection c = getConnection();
        if (c == null) {
            throw new SQLException("No DB connection available");
        }
        PreparedStatement statement = c.prepareStatement(qr, PreparedStatement.RETURN_GENERATED_KEYS);
        try {
            if (params != null) {
                for (int i = 0; i < params.length; i++) {
                    statement.setObject(i + 1, params[i]);
                }
            }
            statement.executeUpdate();

            try ( ResultSet rs = statement.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getLong(1);
                } else {
                    return -1L;
                }
            }
        } finally {
            try {
                statement.close();
            } catch (Exception ex) {
                LOGGER.log(Level.WARNING, "Failed closing statement", ex);
            }
        }
    }

    // --- helper: tạo connection dựa trên env vars ---
    private Connection createConnection() throws SQLException {
        String jdbcUrl = System.getenv(ENV_JDBC_URL);

        if (isEmpty(jdbcUrl)) {
            // build from components
            String host = System.getenv(ENV_DB_HOST);
            String port = System.getenv(ENV_DB_PORT);
            String db = System.getenv(ENV_DB_NAME);
            String type = System.getenv(ENV_DB_TYPE); // optional

            if (isEmpty(host) || isEmpty(db)) {
                // fallback: if nothing provided, try the old hard-coded local SQL Server for dev (keep behaviour for local dev)
                // NOTE: you should prefer setting env vars in Render.
                LOGGER.info("No JDBC_URL or DB_HOST/DB_NAME provided; falling back to local SQL Server (127.0.0.1:1433).");
                jdbcUrl = "jdbc:sqlserver://127.0.0.1:1433;databaseName=SweetimalPetCare;encrypt=false";
            } else {
                if (isEmpty(port)) {
                    port = "postgres".equalsIgnoreCase(type) ? "5432" : "1433";
                }
                if ("postgres".equalsIgnoreCase(type) || host.contains("postgres")) {
                    jdbcUrl = String.format("jdbc:postgresql://%s:%s/%s?sslmode=require", host, port, db);
                } else {
                    // default to SQL Server style
                    jdbcUrl = String.format("jdbc:sqlserver://%s:%s;databaseName=%s;encrypt=true;trustServerCertificate=true;", host, port, db);
                }
            }
        }

        String user = System.getenv(ENV_DB_USER);
        String pass = System.getenv(ENV_DB_PASS);

        // Load driver class explicitly for safety
        try {
            if (jdbcUrl.startsWith("jdbc:postgresql:")) {
                Class.forName("org.postgresql.Driver");
            } else if (jdbcUrl.startsWith("jdbc:sqlserver:")) {
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            }
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "JDBC driver class not found for URL: " + jdbcUrl, e);
            throw new SQLException("JDBC driver not found", e);
        }

        LOGGER.info("Attempting DB connection. URL=" + maskPassword(jdbcUrl) + ", user=" + user);
        return DriverManager.getConnection(jdbcUrl, user, pass);
    }

    // --- helper để đóng ResultSet + Statement + Connection một lần (sử dụng khi bạn dùng executeSelectQuery) ---
    public static void closeResultSetAndRelated(ResultSet rs) {
        if (rs == null) {
            return;
        }
        try {
            Statement st = rs.getStatement();
            Connection c = null;
            try {
                c = (st != null) ? st.getConnection() : null;
            } catch (Exception ex) {
                // ignore
            }
            try {
                rs.close();
            } catch (Exception ex) {
                /*ignore*/ }
            try {
                if (st != null) {
                    st.close();
                }
            } catch (Exception ex) {
                /*ignore*/ }
            try {
                if (c != null && !c.isClosed()) {
                    c.close();
                }
            } catch (Exception ex) {
                /*ignore*/ }
        } catch (Exception ex) {
            LOGGER.log(Level.WARNING, "Error closing ResultSet/Statement/Connection", ex);
        }
    }

    // mask password in logs if present in URL (simple)
    private String maskPassword(String url) {
        if (url == null) {
            return null;
        }
        return url.replaceAll("(?i)(password=)[^;]+", "$1*****");
    }

    private static boolean isEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }
}
