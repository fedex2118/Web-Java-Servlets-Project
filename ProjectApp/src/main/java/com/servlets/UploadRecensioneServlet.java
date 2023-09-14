package com.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class UploadRecensioneServlet
 */
@WebServlet("/UploadRecensioneServlet")
public class UploadRecensioneServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    

    // database connection settings
    private String dbURL = "jdbc:mysql://localhost:3306/mydb";
    private String dbUser = "root";
    private String dbPass = "culo2118";

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		 HttpSession session = request.getSession(false);
	    	
		 String descrizione = request.getParameter("descrizione");
		 int valutazione = Integer.parseInt(request.getParameter("valutazione"));
		 String recensione = request.getParameter("recensione");
		 int idProdotto = Integer.parseInt(request.getParameter("idProdotto"));
		 
		    	
		 Connection conn = null; // connection to the database

		 try {
			 // connects to the database
			 Class.forName("com.mysql.jdbc.Driver");
			 conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

			 // constructs SQL statement
			 String sqlInserisci = "INSERT INTO recensione (descrizione, valutazione, idUtente, idProdotto) values (?,?,?,?)";
			 String sqlAggiorna = "UPDATE recensione SET descrizione=?, valutazione=? where idUtente="+session.getAttribute("id-user")+" and idProdotto="+idProdotto;
			 PreparedStatement stInsert = conn.prepareStatement(sqlInserisci);
			 PreparedStatement stUpdate = conn.prepareStatement(sqlAggiorna);

			 if(recensione==null) {
				 stInsert.setString(1,descrizione);
				 stInsert.setInt(2,valutazione);
				 stInsert.setInt(3,(int)session.getAttribute("id-user"));
				 stInsert.setInt(4,idProdotto);
				 stInsert.executeUpdate();
			 }
			 else {
				 stUpdate.setString(1,descrizione); 
				 stUpdate.setInt(2,valutazione);
				 stUpdate.executeUpdate();

			 }

			 // sends the statement to the database server
			 //			 int row = statement.executeUpdate(); // TODO da vedere se implementarlo
			 //			 if (row > 0) {
			 //				 message = success;
			 //			 }
		 } catch (SQLException | ClassNotFoundException ex) {
//			 message = "ERROR: " + ex.getMessage();
			 ex.printStackTrace();
		 } finally {
			 if (conn != null) {
				 // closes the database connection
				 try {
					 conn.close();
				 } catch (SQLException ex) {
					 ex.printStackTrace();
				 }
			 }
		 }
		 response.sendRedirect(response.encodeURL("indexJsp"));
	}

}
