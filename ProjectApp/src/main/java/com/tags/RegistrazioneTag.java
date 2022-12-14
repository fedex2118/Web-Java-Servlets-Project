package com.tags;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.TagSupport;

@SuppressWarnings("serial")
public class RegistrazioneTag extends TagSupport
{
	private String signInPage;
	
	// Setters
	public void setSignInPage(String signInPage) {
		this.signInPage = signInPage;
	}
	
	@Override
	public int doEndTag() throws JspException {
		HttpSession session = pageContext.getSession();
		HttpServletRequest req = (HttpServletRequest)pageContext.getRequest();
		String header = req.getHeader("referer");
		String protectedPage = header;
		if (session.getAttribute("user")==null) {
			session.setAttribute("signIn-page", signInPage);
			if(!protectedPage.endsWith("loginJsp") && !protectedPage.endsWith("signInJsp")) {
				session.setAttribute("protected-page", protectedPage);
			}
			return SKIP_PAGE;
		}
		return EVAL_PAGE; //eseguito se l’attributo user viene trovato nella sessione
	}
	
	@Override
	public void release() {
		signInPage = null;
	}
}
