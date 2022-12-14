package com.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.beans.Carrello;
import com.beans.Prodotto;
import com.beans.User;

/**
 * Servlet implementation class ServletAcquisti
 */
@WebServlet("/ServletAcquisti")
public class ServletAcquisti extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ServletAcquisti() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		
		String idProdottoString = request.getParameter("idProdotto");
		String quantitaString = request.getParameter("quantita");
		
		User user = (User)session.getAttribute("user");
		Carrello carrello = (Carrello)session.getAttribute("carrello");
		
		String message = "";
		String success = "";
		
		int idProdotto = 0;
		int quantita = 0;
		
		int updatedValue = 0;
		int acquistaSubito = 0;
		
		if(user == null) { // non siamo autenticati! Allora facciamo login!
			response.sendRedirect("/ProjectApp/loginJsp");
		}
		else { // user è loggato!
			if(carrello.len() == 0)
				success = "Prodotto acquistato con successo!";
			else
				success = "Prodotti acquistati con successo!";
			if(idProdottoString != null && quantitaString != null) {
				// Caso in cui stiamo arrivando da acquista subito!
				idProdotto = Integer.parseInt(idProdottoString);
				quantita = Integer.parseInt(quantitaString);

				// presi i parametri aggiungiamo quel prodotto al carrello cosi il codice è unico...
				carrello.add(new Prodotto(idProdotto, quantita), true);
				// cosi nel caso di acquista subito andiamo ad acquistare solo l'ultimo valore nel carrello
				acquistaSubito = carrello.len()-1;
			}
			// Caso generale se arriviamo dal carrello o meno:
			String connectionURL = "jdbc:mysql://localhost:3306/mydb";
			Connection connection = null;
			PreparedStatement updateStatement = null;
			PreparedStatement insertStatement = null;
			Statement maxValueStatement = null;
			ResultSet rs = null;

			Date dateTime = new Date(Calendar.getInstance().getTimeInMillis());
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String currentTime = dateFormat.format(dateTime);
			Integer idUtente = (Integer)session.getAttribute("id-user");

			try {
				Class.forName("com.mysql.jdbc.Driver"); // riporta exception se non trova il driver nel classpath!
				// connect to database
				connection = DriverManager.getConnection(connectionURL, "root", "");

				connection.setAutoCommit(false);
				// query database
				String update_query = "UPDATE prodotto set numero_pezzi = ? where idProdotto = ?";
				
				String insert_query = "INSERT into fattura (data, idUtente, idProdotto, quantità) values(?, ?, ?, ?)";
				
				String select_query = "";
				
				int counter = 0;
				
				int rowUpdate = 0;
				int rowInsert = 0;

				for(int i = acquistaSubito; i<carrello.len(); i++) {
					updateStatement = connection.prepareStatement(update_query);
					insertStatement = connection.prepareStatement(insert_query);
					
					Prodotto prodotto = carrello.getProdotto(i);
					idProdotto = prodotto.getCodice();
					quantita = prodotto.getQuantita();
					
					select_query = "SELECT numero_pezzi from prodotto where idProdotto=" + idProdotto;
					maxValueStatement = connection.createStatement();
					rs = maxValueStatement.executeQuery(select_query);
					rs.next();
					
					updatedValue = rs.getInt(1) - quantita;
					
					updateStatement.setInt(1, updatedValue);
					updateStatement.setInt(2, idProdotto);
					
					insertStatement.setObject(1, currentTime); // setObject > setDate
					insertStatement.setInt(2, idUtente);
					insertStatement.setInt(3, idProdotto);
					insertStatement.setInt(4, quantita);
					
					rowUpdate = updateStatement.executeUpdate();
					rowInsert = insertStatement.executeUpdate();
					
					if (rowUpdate > 0 && rowInsert > 0) {
						counter = i;
					}
				}
				
				if(counter == carrello.len()-1) {
					if(acquistaSubito == 0) // caso acquista dal carrello!
						carrello.removeAll();
					else // caso acquista subito!
						carrello.removeLast();
					message = success;
					connection.commit();
				}
				
			} catch (SQLException e) { // detect problems interacting with the database
				e.printStackTrace();
				try {
					connection.rollback();
				} catch (SQLException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				message = e.getMessage();
				System.err.println("SQL problem:" + e.getMessage());
				System.err.println("SQL state" + e.getSQLState());
				System.err.println("Error:" + e.getErrorCode());
				System.exit(1); // usciamo con exit status 1 indicando che c'è stato un errore!

			} catch (ClassNotFoundException e) { // detect problems loading database driver
				e.printStackTrace();
				message = e.getMessage();
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
			if(message.equals(success)) // tutto è andato secondo i piani
				session.setAttribute("avvenutoAcquisto", success);
			else // c'è stato un errore
				session.setAttribute("error-purchase", "C'è stato un errore!");
			response.sendRedirect(response.encodeURL("jsp/avvenutoAcquisto.jsp"));
		}
	}
}

