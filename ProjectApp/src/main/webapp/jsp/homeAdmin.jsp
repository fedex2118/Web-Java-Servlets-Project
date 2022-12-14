<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.beans.User" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://kit.fontawesome.com/723459cc3a.js"></script>
</head>
<body>
	<%@ include file="/jsp/onTop.jsp" %>
<%
Object idObject = session.getAttribute("id-user");
String permesso = (String)session.getAttribute("permesso");
if(idObject!=null && !(permesso.equals("utente") || permesso.equals("venditore"))) {

%>
	
	
	
	<div class="container-fluid" style="padding-top: 80px">
		<div class="col-8 offset-2 pt-4">
		 	<p class="display-5 text-center" style="padding-bottom: 10px;">Admin Page</p>
			
			<div class="col-12 text-center">
				<a class="btn btn-secondary" href="/ProjectApp/aggiungiProduttore">
					Aggiungi Produttore
				</a>
				
				<a class="btn btn-secondary" href="/ProjectApp/jsp/dashCategoria.jsp">
				
					Aggiungi Categoria
				</a>
				
				<a class="btn btn-secondary" href="/ProjectApp/jsp/dashProdotti.jsp">
					Aggiungi Prodotto
				</a>
				
				<a class="btn btn-secondary" href="/ProjectApp/jsp/modificaProdottiHome.jsp">
					Modifica Prodotto
					
				</a>
			</div>
			
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