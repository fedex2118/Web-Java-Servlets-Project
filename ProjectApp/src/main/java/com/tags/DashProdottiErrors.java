package com.tags;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.TagSupport;

public class DashProdottiErrors extends TagSupport
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public int doStartTag() throws JspException {
		String error = (String)pageContext.getSession().
				getAttribute("errorProdotti");

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
