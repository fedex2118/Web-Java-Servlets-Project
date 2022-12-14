package com.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

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
 * Servlet implementation class ServletAutenticazione
 */
@WebServlet("/ServletAutenticazione")
public class ServletAutenticazione extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private LoginDB loginDB;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ServletAutenticazione() {
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
		String userName = request.getParameter("userName");
		String pwd = request.getParameter("pwd");
		
		String connectionURL = "jdbc:mysql://localhost:3306/mydb";
		Connection connection = null;
		Statement statement = null;
		ResultSet resultSet = null;
		
		Integer idUtente = null;
		String permesso = null;
		
		if (!userName.equals("") && !pwd.equals("")) { // se i campi non sono vuoti...
			try {
				Class.forName("com.mysql.jdbc.Driver"); // riporta exception se non trova il driver nel classpath!
				// connect to database
				connection = DriverManager.getConnection(connectionURL, "root", "");
				// create Statement to query database
				statement = connection.createStatement();

				// query database
				String query_user = "SELECT idUtente, permesso, username, password from utente";
				resultSet = statement.executeQuery(query_user);
				
				while (resultSet.next()) { // aggiungiamo user al loginDB
					String usernameDB = (String)resultSet.getObject(3);
					String pwdDB = (String)resultSet.getObject(4);
					if(usernameDB.equals(userName) && pwdDB.equals(pwd)) {
						idUtente = (Integer)resultSet.getObject(1);
						permesso = (String)resultSet.getObject(2);
					}
					loginDB.addUser(new User(usernameDB, pwdDB));
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
			User user = loginDB.getUser(userName, pwd);
			Carrello carrello = new Carrello();

			if (user != null) { //authorized
				String protectedPage = (String)session.getAttribute("protected-page");
				session.setAttribute("carrello", carrello);
				session.removeAttribute("login-page");
				session.removeAttribute("protected-page");
				session.removeAttribute("login-error");
				session.setAttribute("permesso", permesso);
				// inseriamo idUtente nella sessione
				session.setAttribute("id-user", idUtente);
				// inserisce il bean utente nella sessione
				session.setAttribute("user", user);
				
				response.sendRedirect(response.encodeURL(protectedPage));
			}
			//l’utente con i dati digitati nel form non è stato trovato nella base dati
			else { // not authorized
				String loginPage = (String)session.getAttribute("login-page");
				session.setAttribute("login-error", "Username o Password non sono corretti!");

				//la richiesta viene rediretta alla pagina di errore se è stata
				//configurata, altrimenti alla pagina di login
				getServletContext().getRequestDispatcher(response.encodeURL(loginPage)).forward(request, response);
			}
		} 
		else { // uno o due campi sono stati lasciati vuoti!
			String loginPage = (String)session.getAttribute("login-page");
			session.setAttribute("login-error", "Non lasciare campi vuoti!");
			getServletContext().getRequestDispatcher(response.encodeURL(loginPage)).forward(request, response);
		}
	}
}
