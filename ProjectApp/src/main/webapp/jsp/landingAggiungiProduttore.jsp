<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Vector" %>
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
	<%
		Vector<String[]> vettoreUtenti =(Vector<String[]>) session.getAttribute("vettoreUtenti");
		String nomeUtente = "";
		String codiceUtente = "";
		
	%>
	<div class="container-fluid" style="padding-top: 80px">
		<div class="col-6 offset-3 pt-4">
			
			<p class="display-6 text-center" style="padding-bottom: 20px;">Aggiungi Venditore</p>
			
			<form action="/ProjectApp/produttoreAggiunto" method="post">
				<div class="row">
					<div class="col-8">
						<label class="form-label" for="idUtente">Username e codice:</label>
						<select class="form-select" name="idUtente" id="idUtente">
							<%
								for(String[] utente : vettoreUtenti){
									codiceUtente = utente[0];
									nomeUtente = utente[1];
							%>
									<option value="<%= codiceUtente %>"> 
										<%=nomeUtente %> , <%=codiceUtente %>
									</option>	
							<%
								}
							%>
						</select>
					</div>
						
				</div>
				
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