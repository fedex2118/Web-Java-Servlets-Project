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
 * Servlet implementation class UploadProdottiServlet
 */
@WebServlet("/UploadProdottiServlet")
@MultipartConfig(maxFileSize = 16177215)    // upload file's size up to 16MB
public class UploadProdottiServlet extends HttpServlet {
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
        String nome = request.getParameter("nome");
        String descrizione = request.getParameter("descrizione");
        String prezzoString = request.getParameter("prezzo");
        String n_pezziString = request.getParameter("n_pezzi");
        String categoriaString = request.getParameter("categoria");
        
        if (nome.equals("") || descrizione.equals("") || prezzoString.equals("") || n_pezziString.equals("") || 
        		categoriaString.equals("")) {
            session.setAttribute("errorProdotti", "Non lasciare campi vuoti!");
			String dashProdottiPage = (String)session.getAttribute("dashProdotti-page");
			getServletContext().getRequestDispatcher(response.encodeURL(dashProdottiPage)).forward(request, response);
        }
        else {
        	InputStream immagine = null; // input stream of the upload file

        	// obtains the upload file part in this multipart request
        	Part filePart = request.getPart("immagine");
        	System.out.println("filePart " + filePart);
        	if (filePart.getSize() == 0) {
                session.setAttribute("errorProdotti", "Devi scegliere un immagine valida per il prodotto!");
    			String dashProdottiPage = (String)session.getAttribute("dashProdotti-page");
    			getServletContext().getRequestDispatcher(response.encodeURL(dashProdottiPage)).forward(request, response);
        	}
        	else {
        		// Debug
        		System.out.println("name " + filePart.getName());
        		System.out.println("size " + filePart.getSize());
        		System.out.println("content " + filePart.getContentType());

        		// obtains input stream of the upload file
        		immagine = filePart.getInputStream();

        		double prezzo = Double.parseDouble(prezzoString);

        		int n_pezzi =  Integer.parseInt(n_pezziString);
        		int categoria =  Integer.parseInt(categoriaString);
        		// prendiamo idCreatore = idUtente
        		int idCreatore =  (Integer)session.getAttribute("id-user");

        		Connection conn = null; // connection to the database
        		String message = null;  // message will be sent back to client
        		String success = "File uploaded and saved into database";

        		try {
        			// connects to the database
        			Class.forName("com.mysql.jdbc.Driver");
        			conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

        			// constructs SQL statement
        			String sql = "INSERT INTO Prodotto (nome, descrizione, immagine, prezzo, numero_pezzi, idCategoria, idCreatore) "
        					+ "values (?, ?, ?, ?, ?, ?, ?)";
        			PreparedStatement statement = conn.prepareStatement(sql);
        			statement.setString(1, nome);
        			statement.setString(2, descrizione);

        			if (immagine != null) {
        				// fetches input stream of the upload file for the blob column
        				statement.setBlob(3, immagine);
        			}
        			statement.setDouble(4, prezzo);
        			statement.setInt(5, n_pezzi);
        			statement.setInt(6, categoria);
        			statement.setInt(7, idCreatore);

        			// sends the statement to the database server
        			int row = statement.executeUpdate();
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
        				session.removeAttribute("errorProdotti"); // rimuovo l'errore
        				String protectedPage = (String)session.getAttribute("protected-page");
        				// forwards to the message page
        				getServletContext().getRequestDispatcher(protectedPage).forward(request, response);
        			}
        			else  { // ...il messaggio ha dato errore!
        				session.setAttribute("errorProdotti", message);
        				String dashProdottiPage = (String)session.getAttribute("dashProdotti-page");
        				getServletContext().getRequestDispatcher(response.encodeURL(dashProdottiPage)).forward(request, response);
        			}
        		}
        	}
        }
    }
}
