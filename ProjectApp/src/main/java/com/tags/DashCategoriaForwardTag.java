package com.tags;

import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.TagSupport;

public class DashCategoriaForwardTag extends TagSupport {
/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
private String dashCategoriaPage;
	
	// Setters
	public void setDashCategoriaPage(String dashCategoriaPage) {
		this.dashCategoriaPage = dashCategoriaPage;
	}
	
	@Override
	public int doEndTag() throws JspException {
		HttpSession session = pageContext.getSession();
		String protectedPage = "/jsp/dashProdottiMessaggio.jsp";
		session.setAttribute("dashCategoria-page", dashCategoriaPage);
		session.setAttribute("protected-page", protectedPage);
		return EVAL_PAGE;
	}
	
	@Override
	public void release() {
		dashCategoriaPage = null;
	}
}
