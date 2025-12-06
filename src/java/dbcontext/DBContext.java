/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dbcontext;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.List;

/**
 *
 * @author acer
 */
public class DBContext {
    protected Connection connect;

    public DBContext() {
        try {
            String url = "jdbc:sqlserver://" + serverName + ":" + portNumber
                    + ";databaseName=" + dbName;
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connect = DriverManager.getConnection(url, userID, userPassword);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    private final String serverName = "localhost";
    private final String dbName = "PRJ_ClotherOnline2";
    private final String portNumber = "1433";
    private final String userID = "sa";
    private final String userPassword = "123";

    public static void main(String[] args) throws Exception {
        DBContext dbContext = new DBContext();

        try {
            Connection connection = dbContext.connect;
            if (connection != null) {
                System.out.println("Connected to database successfully.");
                // Do other operations if needed
                connection.close(); // Close the connection when done
            } else {
                System.out.println("Failed to connect to database.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
