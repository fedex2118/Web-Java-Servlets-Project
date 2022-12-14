package com.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashSet;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.beans.Carrello;
import com.beans.LoginDB;
import com.beans.User;

/**
 * Servlet implementation class ServletRegistrazione
 */
@WebServlet("/ServletRegistrazione")
public class ServletRegistrazione extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private LoginDB loginDB;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ServletRegistrazione() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    @Override
	public void init(ServletConfig config) throws ServletException {
		super.init(config);
		loginDB = new LoginDB();
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		String connectionURL = "jdbc:mysql://localhost:3306/mydb";
		Connection connection = null;
		Statement statement = null;
		PreparedStatement pr = null;
		ResultSet resultSet = null;
		
		
		String nome = request.getParameter("nome");
		String cognome = request.getParameter("cognome");
		String userName = request.getParameter("userName");
		String pwd = request.getParameter("pwd");
		
		if (!nome.equals("") && !cognome.equals("") && !userName.equals("") && !pwd.equals("")) { // se sono rimaste in bianco...
			try {
				Class.forName("com.mysql.jdbc.Driver"); // riporta exception se non trova il driver nel classpath!
				// connect to database
				connection = DriverManager.getConnection(connectionURL, "root", "");
				// create Statement to query database
				statement = connection.createStatement();

				// query database
				String query_username = "SELECT username from utente";
				resultSet = statement.executeQuery(query_username);
				
				HashSet<String> usernameHashSet = new HashSet<>();
				while (resultSet.next()) {
					usernameHashSet.add((String)resultSet.getObject(1));
				}
				
				if (usernameHashSet.contains(userName)) {
					String signInPage = (String)session.getAttribute("signIn-page");
					session.setAttribute("signIn-error", "Nome utente già in uso!");
					getServletContext().getRequestDispatcher(response.encodeURL(signInPage)).forward(request, response);
				}
				else { // aggiorniamo il database
					// prendiamo l'id più grande e sommiamo +1
					String query_idUtente = "SELECT max(idUtente) from utente";
					resultSet = statement.executeQuery(query_idUtente);

					resultSet.next();
					int idUtente = resultSet.getInt(1) + 1;
					
					String query_addUser = "insert into utente(idUtente, nome, cognome, permesso, username, password) values(?,?,?,?,?,?)";
					String utente = "utente";
					pr = connection.prepareStatement(query_addUser);
					pr.setInt(1, idUtente);
					pr.setString(2, nome);
					pr.setString(3, cognome);
					pr.setString(4, utente);
					pr.setString(5, userName);
					pr.setString(6, pwd);
					
					int row = pr.executeUpdate();
					
					if (row > 0) {
						pr.close();

						statement = connection.createStatement();

						// prendiamo l'id dell'utente

						User user = new User(userName, pwd);
						Carrello carrello = new Carrello();

						String protectedPage = (String)session.getAttribute("protected-page");
						session.removeAttribute("signIn-page");
						session.removeAttribute("protected-page");
						session.removeAttribute("signIn-error");
						session.setAttribute("permesso", utente); // default value di permesso per utenti base
						//inserisce il bean utente nella sessione
						session.setAttribute("user", user);
						session.setAttribute("carrello", carrello);
						session.setAttribute("id-user", idUtente);
						response.sendRedirect(response.encodeURL(protectedPage));
					}
				}

			} catch (SQLException e) { // detect problems interacting with the database
				e.printStackTrace();
				System.err.println("SQL problem:" + e.getMessage());
				System.err.println("SQL state" + e.getSQLState());
				System.err.println("Error:" + e.getErrorCode());
				System.exit(1); // usciamo con exit status 1 indicando che c'è stato un errore!

			} catch (ClassNotFoundException e) { // detect problems loading database driver
				e.printStackTrace();
				System.err.println("Non trovo il driver " + e.getMessage());
			}
			finally {
				if (connection != null)
					try { connection.close();
					} 
					catch (SQLException e) {
						e.printStackTrace();
						System.err.println(e.getMessage());
					}
			}
		}
		else { // campi vuoti
			String signInPage = (String)session.getAttribute("signIn-page");
			session.setAttribute("signIn-error", "Non lasciare campi vuoti!");
			getServletContext().getRequestDispatcher(response.encodeURL(signInPage)).forward(request, response);
		}
	}

}
