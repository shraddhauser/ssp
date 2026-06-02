package com.officevpn.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Database connection utility class.
 * Uses H2 Embedded Database — NO MySQL installation required!
 * Data is stored in a local file (./data/officevpn.mv.db)
 * and persists between restarts.
 */
public class DBConnection {

    // H2 Embedded Database — file-based, runs inside the app
    private static final String URL = "jdbc:h2:file:./data/officevpn;MODE=MySQL;DB_CLOSE_DELAY=-1;AUTO_SERVER=TRUE;DATABASE_TO_UPPER=FALSE";
    private static final String USER = "sa";
    private static final String PASSWORD = "";
    private static final String DRIVER = "org.h2.Driver";

    // Load the JDBC driver once when class is loaded
    static {
        try {
            Class.forName(DRIVER);
            System.out.println("[DBConnection] H2 Database driver loaded successfully.");
        } catch (ClassNotFoundException e) {
            System.err.println("[DBConnection] ERROR: H2 Driver not found!");
            e.printStackTrace();
            throw new RuntimeException("Failed to load H2 JDBC driver", e);
        }
    }

    /**
     * Get a new database connection.
     * @return Connection object
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    /**
     * Close a database connection safely.
     * @param conn Connection to close
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
