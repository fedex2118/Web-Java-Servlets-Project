package com.servlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class ServletLogout
 */
@WebServlet("/ServletLogout")
public class ServletLogout extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ServletLogout() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		
		if(session != null)
			session.invalidate(); // cancelliamo tutti gli attributi legati all'utente in sessione
		// controlliamo i cookies e rimuoviamo quello legato alla sessione settandolo a maxAge = 0
		Cookie[] cookiesArray = request.getCookies();
		if(cookiesArray != null && cookiesArray.length != 0)
		{
			for(int i = 0; i < cookiesArray.length; i++)
			{
				Cookie cookie = cookiesArray[i];
				if (cookie.getName().equals("JSESSIONID")) {
					cookie.setMaxAge(0);
				}
			}
		}
		// adesso torniamo alla home.
		String header = request.getHeader("referer");
		String[] arrayString = header.split("/ProjectApp");
		response.sendRedirect(response.encodeURL(header));
	}

}
