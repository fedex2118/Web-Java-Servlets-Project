<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="com.beans.*" %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Resoconto Carrello</title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://kit.fontawesome.com/723459cc3a.js"></script>
		<style>
      .test {
        padding: 0;
		border: none;
		background: none;
        outline: none;
      }
    </style>
	</head>
<body>
<%@ include file="/jsp/onTop.jsp" %>
<%
Object idObject = session.getAttribute("id-user");
Carrello carrello =(Carrello) session.getAttribute("carrello");
if(idObject!=null && carrello != null) {
%>
	<%
		if(carrello.len()==0){
			//non ci stanno prodotti inseriti
	%>
		<div class="container-fluid" style="padding-top: 80px">
			<div class="col-6 offset-3" >
				<p class="display-6 text-center" style="padding-bottom: 20px;">Non ci sono prodotti nel carrello!</p>
			</div>
		</div>
		
	<% 
		}
		else{
	%>
			<div class="container-fluid" style="padding-top: 80px">
				<div class="col-4 offset-4 pb-4">
					<ol class="list-group">
					
				
	<% 
			for(int i=0;i<carrello.len();i++){
				Prodotto p = carrello.getProdotto(i);
				int codice = p.getCodice();
	%>
				<form action="/ProjectApp/svuotaCarrello" method="post">
						<li class="list-group-item d-flex justify-content-between align-items-start">
						    <div class="ms-2 me-auto " >
						    	<div class="fw-bold">
						    		<%= p.getNomeProdotto() %>
						    		
						    	</div>
						      	X <%= p.getQuantita() %>
						    </div>
						    <button class="test" type="submit">
						    	<input type="hidden" name="codiceProd" value=<%= codice %> />
						    	<i class="badge bg-danger  rounded-pill " style="text-decoration:none; color:#fff">X</i>
						    </button>
						</li>
					</form>
						
				
				
				
	<%
			}
	%>				</ol>
				</div>
				<div class="col-6 offset-4">
					<form method="post">
								<button type="submit" formaction="/ProjectApp/acquisti" class="btn btn-outline-success">
									<i class="fa-solid fa-lg fa-money-bill-wave"></i> Acquista prodotti
								</button>
								
								<button type="submit" formaction="/ProjectApp/svuotaCarrello" class="btn btn-outline-danger">
									<input type="hidden" name="svuotaCarrello" value="svuotaCarrello"/>
									<i class="fa-solid fa-lg fa-trash-alt"></i> Svuota Carrello
								</button>
					</form>
				</div>
			</div>
			
	<% 
		}
	
	} else {
		response.sendRedirect(response.encodeURL("/ProjectApp/indexJsp"));
	}
	%>
</body>
</html>