package com.tags;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.TagSupport;

public class DashCategoriaErrors extends TagSupport
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public int doStartTag() throws JspException {
		String error = (String)pageContext.getSession().
				getAttribute("dashCategoriaErrorMessage");

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
}
