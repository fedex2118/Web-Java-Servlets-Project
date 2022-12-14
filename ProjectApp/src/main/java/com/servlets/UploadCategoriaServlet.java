package com.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
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
 * Servlet implementation class UploadCategoriaServlet
 */
@WebServlet("/UploadCategoriaServlet")
public class UploadCategoriaServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UploadCategoriaServlet() {
        super();
        // TODO Auto-generated constructor stub
    }
    
	// database connection settings
    private String dbURL = "jdbc:mysql://localhost:3306/mydb";
    private String dbUser = "root";
    private String dbPass = "";
    
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.sendRedirect(response.encodeURL("/ProjectApp/indexJsp"));
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException { 
	HttpSession session = request.getSession(false);
		
	// gets values of text fields
    String nome = request.getParameter("nome");
    String success = "File uploaded and saved into database";
    
    if (nome.equals("")) { // no campi vuoti!
        session.setAttribute("dashCategoriaErrorMessage", "Non lasciare campi vuoti!");
		String dashCategoriaPage = (String)session.getAttribute("dashCategoria-page");
		getServletContext().getRequestDispatcher(response.encodeURL(dashCategoriaPage)).forward(request, response);
    }
    else {
    	
    	Connection conn = null; // connection to the database
    	String message = null;  // message will be sent back to client
    	Statement statement = null;
    	PreparedStatement prStatement = null;
    	ResultSet resultSet = null;

    	try {
    		// connects to the database
    		Class.forName("com.mysql.jdbc.Driver");
    		conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
    		
    		statement = conn.createStatement();
    		
			String query_idCategoria = "SELECT max(idCategoria) from categoria";
			resultSet = statement.executeQuery(query_idCategoria);
			
			resultSet.next();
			int idCategoria = resultSet.getInt(1) + 1;

    		// constructs SQL statement
    		String sql = "INSERT INTO Categoria (idCategoria, nome) values (?, ?)";
    		prStatement = conn.prepareStatement(sql);
    		prStatement.setInt(1, idCategoria);
    		prStatement.setString(2, nome);

    		// sends the statement to the database server
    		int row = prStatement.executeUpdate();
    		if (row > 0) {
    			message = success;
    		}
    	} catch (SQLException | ClassNotFoundException ex) {
    		message = "ERROR: " + ex.getMessage();
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
    	if(message != null) {
			if(message.equals(success)) {
				request.setAttribute("requestSuccesfull", message);
				session.removeAttribute("dashCategoriaErrorMessage"); // rimuovo l'errore
				String protectedPage = (String)session.getAttribute("protected-page");
				// forwards to the message page
				getServletContext().getRequestDispatcher(protectedPage).forward(request, response);
			}
			else  { // ...il messaggio ha dato errore!
				session.setAttribute("dashCategoriaErrorMessage", message);
				String dashProdottiPage = (String)session.getAttribute("dashCategoria-page");
				getServletContext().getRequestDispatcher(response.encodeURL(dashProdottiPage)).forward(request, response);
			}
		}
    }
}
}
