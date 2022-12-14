<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>File Upload to Database Demo</title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://kit.fontawesome.com/723459cc3a.js"></script>
	</head>
<%@ taglib uri="/WEB-INF/tld/security.tld" prefix="security" %>
<body>
<%@ include file="/jsp/onTop.jsp" %>
<%
Object idObject = session.getAttribute("id-user");
String permesso = (String)session.getAttribute("permesso");
if(idObject!=null && !(permesso.equals("utente") || permesso.equals("venditore"))) {

%>
	<div class="container-fluid " style="padding-top: 80px">
		<div class="col-6 offset-3 pt-4">
			<p class="display-6 text-center" style="padding-bottom: 20px;">Aggiungi Categoria</p>
	        <form method="post" action="/ProjectApp/uploadCategoria">
	        	
	            <div class="form-group col-6">
		            <label class="form-label" for="nome">Nome:</label>
					<input type="text" class="form-control" name="nome" id="nome">
	            </div>
	            <font size=4 color="red"><security:dashCategoriaErrors/></font>
	            <security:enforceDashCategoria dashCategoriaPage="/DashCategoriaJsp"></security:enforceDashCategoria>
			
				<div class="row pt-4">
					<div class="col-3">
						<button class="btn btn-secondary btn-sm w-100" type="submit" >Invia</button>
					</div>
					<div class="col-3 offset-6"> 
						<a class="btn btn-danger btn-sm w-100" href="/ProjectApp/jsp/homeAdmin.jsp">Indietro</a> 
					</div>
				</div>
			
			</form>
		</div>
	</div>
		
	<%
	} else {
		response.sendRedirect(response.encodeURL("/ProjectApp/indexJsp"));
	}
	%>
	
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/js/bootstrap.bundle.min.js" integrity="sha384-pprn3073KE6tl6bjs2QrFaJGz5/SUsLqktiwsUTF55Jfv3qYSDhgCecCxMW52nD2" crossorigin="anonymous"></script>
</body>
</html>