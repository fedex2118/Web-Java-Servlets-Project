package com.tags;

import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.TagSupport;

public class ModificaProdottiMessageTag extends TagSupport {
	private static final long serialVersionUID = 1L;
	
	private String modificaProdottiPage;
	
	// Setters
	public void setModificaProdottiPage(String modificaProdottiPage) {
		this.modificaProdottiPage = modificaProdottiPage;
	}
	
	@Override
	public int doStartTag() throws JspException {
		String error = (String)pageContext.getSession().
				getAttribute("modificaProdotti-errorMessage");

		if (error!=null) {
			try {
				pageContext.getOut().print(error);
			}
			catch (java.io.IOException ex) {
				throw new JspException(ex.getMessage());
			}
		}
		return SKIP_BODY;
	}
	
	@Override
	public int doEndTag() throws JspException {
		HttpSession session = pageContext.getSession();
		String protectedPage = "/jsp/dashProdottiMessaggio.jsp";
		session.setAttribute("modificaProdotti-page", modificaProdottiPage);
		session.setAttribute("protected-page", protectedPage);
		return EVAL_PAGE;
	}
	
	@Override
	public void release() {
		modificaProdottiPage = null;
	}
}
