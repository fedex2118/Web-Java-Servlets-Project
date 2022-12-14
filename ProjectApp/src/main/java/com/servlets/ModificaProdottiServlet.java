package com.servlets;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

/**
 * Servlet implementation class ModificaProdottiServlet
 */
@WebServlet("/ModificaProdottiServlet")
@MultipartConfig(maxFileSize = 16177215)    // upload file's size up to 16MB
public class ModificaProdottiServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
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
     
    protected void doPost(HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
    	
    	// gets values of text fields
    	String idProdotto = request.getParameter("idProdotto");
        String nome = request.getParameter("nome");
        String prezzoString = request.getParameter("prezzo");
        String descrizione = request.getParameter("descrizione");
        String n_pezziString = request.getParameter("n_pezzi");
        String categoriaString = request.getParameter("categoria");
        
		String success = "Tabella aggiornata";
        
        // caso in cui tutti i campi sono lasciati vuoti!
        if (nome.equals("") || descrizione.equals("")) {
            session.setAttribute("modificaProdotti-errorMessage", "Nome e descrizione non possono essere vuoti!");
			String modificaProdottiPage = (String)session.getAttribute("modificaProdotti-page");
			request.setAttribute("codice", idProdotto);
			getServletContext().getRequestDispatcher(response.encodeURL(modificaProdottiPage)).forward(request, response);
        }
        else {
        	// L'immagine può non essere scelta se non la si vuole cambiare cosi come altri campi pure.

        	InputStream immagine = null; // input stream of the upload file

        	// obtains the upload file part in this multipart request
        	Part filePart = request.getPart("immagine");
        	if (filePart != null) {
        		// prints out some information for debugging
        		if(filePart.getSize()!=0) 
        			// obtains input stream of the upload file
        			immagine = filePart.getInputStream();
        		// Debug
        		System.out.println(filePart.getName());
        		System.out.println(filePart.getSize());
        		System.out.println(filePart.getContentType());

        	}
        	double prezzo = Double.parseDouble(prezzoString);
        	
        	int n_pezzi =  Integer.parseInt(n_pezziString);
        	
        	int categoria =  Integer.parseInt(categoriaString);

        	Connection conn = null; // connection to the database
        	String message = null;  // message will be sent back to client

        	try {
        		// connects to the database
        		Class.forName("com.mysql.jdbc.Driver");
        		conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

        		// constructs SQL statement
        		String sql;
        		PreparedStatement statement=null;
        		if(immagine!=null)
        		{
        			sql = "update Prodotto set nome=?, descrizione=?, immagine=?,prezzo=?,numero_pezzi=?,idCategoria=? where idProdotto="+idProdotto;
        			statement = conn.prepareStatement(sql);
        			statement.setString(1, nome);
        			statement.setString(2, descrizione);
        			statement.setBlob(3, immagine);
        			statement.setDouble(4, prezzo);
        			statement.setInt(5, n_pezzi);
        			statement.setInt(6, categoria);
        		}

        		else
        		{
        			sql = "update Prodotto set nome=?, descrizione=?,prezzo=?,numero_pezzi=?,idCategoria=? where idProdotto="+idProdotto;
        			statement = conn.prepareStatement(sql);
        			statement.setString(1, nome);
        			statement.setString(2, descrizione);
        			statement.setDouble(3, prezzo);
        			statement.setInt(4, n_pezzi);
        			statement.setInt(5, categoria);
        		}


        		// sends the statement to the database server
        		int row = statement.executeUpdate();
        		if (row > 0) {
        			message = success;
        		}
        		else {
        			message = "Errore di aggiornamento,query: "+sql;
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
    				session.removeAttribute("modificaProdotti-errorMessage"); // rimuovo l'errore
    				String protectedPage = (String)session.getAttribute("protected-page");
    				// forwards to the message page
    				getServletContext().getRequestDispatcher(protectedPage).forward(request, response);
    			}
    			else  { // ...il messaggio ha dato errore!
    				session.setAttribute("modificaProdotti-errorMessage", message);
    				String modificaProdottiPage = (String)session.getAttribute("modificaProdotti-page");
    				getServletContext().getRequestDispatcher(response.encodeURL(modificaProdottiPage)).forward(request, response);
    			}
    		}
        }
    }
}
