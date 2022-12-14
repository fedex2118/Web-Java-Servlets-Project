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
 * Servlet implementation class SvuotaCarrelloServlet
 */
@WebServlet("/SvuotaCarrelloServlet")
public class SvuotaCarrelloServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SvuotaCarrelloServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		
		User user = (User)session.getAttribute("user");
		Carrello carrello = (Carrello)session.getAttribute("carrello");
		
		String svuotaCarrello = request.getParameter("svuotaCarrello");
		String codiceProdString = request.getParameter("codiceProd");
		
		if(user == null) // non siamo autenticati! Allora se siamo arrivati in qualche modo qui torniamo all'index!
			response.sendRedirect("/ProjectApp/indexJsp");
		
		if(carrello.len() == 1) // il carrello ha un solo prodotto, lo rimuoviamo!
			carrello.removeFirst();
		
		if(carrello.len() > 1 && svuotaCarrello != null) // abbiamo premuto svuota carrello: rimuoviamo tutti i prodotti...
			carrello.removeAll();
		else if(carrello.len() > 1 && svuotaCarrello == null) { // ...non abbiamo premuto svuota carrello.
			if(codiceProdString != null) { // rimuoviamo il singolo prodotto quindi!
				int codice = Integer.parseInt(codiceProdString);
				
				for (int i = 0; i < carrello.len(); i++) {
					Prodotto prodotto = carrello.getProdotto(i);
					
					if (prodotto.getCodice() == codice) {
						carrello.remove(i);
						break; // inutile andare avanti.
					}
				}
			}
		}
		
		response.sendRedirect("/ProjectApp/jsp/resumeCarrello.jsp");
	}
}
