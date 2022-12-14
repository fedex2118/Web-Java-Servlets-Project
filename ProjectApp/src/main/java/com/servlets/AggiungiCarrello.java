package com.servlets;

import java.io.IOException;
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
 * Servlet implementation class AggiungiCarrello
 */
@WebServlet("/AggiungiCarrello")
public class AggiungiCarrello extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AggiungiCarrello() {
        super();
        // TODO Auto-generated constructor stub
    }


	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		User user = (User)session.getAttribute("user");
		
		if(user == null) { // non siamo autenticati! Allora facciamo login!
			response.sendRedirect("/ProjectApp/loginJsp");
		}
		else {
			int codiceProdotto =Integer.parseInt(request.getParameter("idProdotto")) ;
			int quantita = Integer.parseInt(request.getParameter("quantita")) ;
			Prodotto prodotto = new Prodotto(codiceProdotto, quantita);
			Carrello carrello =(Carrello) session.getAttribute("carrello");
			carrello.add(prodotto, false);
			session.setAttribute("carrello", carrello);

			response.sendRedirect(response.encodeURL("/ProjectApp/indexJsp"));
		}
	}

}
