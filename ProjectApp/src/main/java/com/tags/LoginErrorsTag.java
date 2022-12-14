package com.tags;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.TagSupport;

@SuppressWarnings("serial")
public class LoginErrorsTag extends TagSupport
{
	public int doStartTag() throws JspException {
		String error = (String)pageContext.getSession().
				getAttribute("login-error");

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
