package com.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class ServletProduttoreAggiunto
 */
@WebServlet("/ServletProduttoreAggiunto")
public class ServletProduttoreAggiunto extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
    private String dbURL = "jdbc:mysql://localhost:3306/mydb";
    private String dbUser = "root";
    private String dbPass = "";
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ServletProduttoreAggiunto() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection conn = null; // connection to the database
		HttpSession session = request.getSession();
		String idUtente = request.getParameter("idUtente");
		String messaggio = "";
		session.setAttribute("vettoreUtenti", null); // lo risettiamo a null
		
		try {
    		// connects to the database
    		Class.forName("com.mysql.jdbc.Driver");
    		conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

    		// constructs SQL statement
    		Statement stmt = conn.createStatement();  
            int i = stmt.executeUpdate("update Utente set permesso = 'venditore' where idUtente = "+ idUtente);
            
            if(i>0)
            	messaggio = idUtente + " messo come produttore!";
            else
            	messaggio = "Errore con l'aggiornamento dei dati";
            
            
    	} catch (SQLException | ClassNotFoundException ex) {
    		ex.printStackTrace();
    	} finally {
    		session.setAttribute("messaggio", messaggio);
    		if (conn != null) {
    			// closes the database connection
    			try {
    				conn.close();
    			} catch (SQLException ex) {
    				ex.printStackTrace();
    			}
    		}
    		
    		response.sendRedirect(request.getContextPath() + "/jsp/messagioRiscontroAdmin.jsp");
    	}
		
	}

}
