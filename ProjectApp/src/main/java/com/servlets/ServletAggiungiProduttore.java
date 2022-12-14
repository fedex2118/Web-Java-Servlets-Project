package com.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class ServletAggiungiProduttore
 */
@WebServlet("/ServletAggiungiProduttore")
public class ServletAggiungiProduttore extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private String url = "jdbc:mysql://localhost:3306/mydb";
	private String username = "root";
	private String password = "";
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ServletAggiungiProduttore() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		
		Vector<String[]> vettoreUtenti = new Vector<>();
		
		//prendo gli utenti che sono utenti normali
		String sql = "select * from Utente where permesso = 'utente' ";
		Connection con = null;
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			con = DriverManager.getConnection(url, username, password);
			Statement st = con.createStatement();
			ResultSet rs = st.executeQuery(sql);
			
			while(rs.next()) {
				String[] elemento = new String [2];
				//aggiunge i codici degli utenti
				elemento[0]=rs.getString(1);
				elemento[1] =rs.getString(2); 
 				
				vettoreUtenti.add(elemento);
			}
			
			session.setAttribute("vettoreUtenti", vettoreUtenti);
			
			
		} catch(SQLException e) {
			e.printStackTrace();
			System.out.println("SQL problem:" + e.getMessage());
			System.out.println("SQL state: " + e.getSQLState());
			System.out.println("Error: " + e.getErrorCode());
			System.exit(1);
		
		} catch(ClassNotFoundException e) {
			e.printStackTrace();
			System.err.println("Non trovo il driver: " + e.getMessage());
		}
		
		finally {
			if(con != null) {
				try {
					con.close();
				} catch(SQLException e) {
					e.printStackTrace();
					System.err.println(e.getMessage());
				}
				
			}
			
			response.sendRedirect(request.getContextPath() + "/jsp/landingAggiungiProduttore.jsp");
		}
		
		
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
