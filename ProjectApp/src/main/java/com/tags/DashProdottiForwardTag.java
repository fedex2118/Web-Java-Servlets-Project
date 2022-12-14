package com.tags;

import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.TagSupport;

public class DashProdottiForwardTag extends TagSupport {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private String dashProdottiPage;
	
	// Setters
	public void setDashProdottiPage(String dashProdottiPage) {
		this.dashProdottiPage = dashProdottiPage;
	}
	
	@Override
	public int doEndTag() throws JspException {
		HttpSession session = pageContext.getSession();
		String protectedPage = "/jsp/dashProdottiMessaggio.jsp";
		session.setAttribute("dashProdotti-page", dashProdottiPage);
		session.setAttribute("protected-page", protectedPage);
		return EVAL_PAGE;
	}
	
	@Override
	public void release() {
		dashProdottiPage = null;
	}
}
