<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://kit.fontawesome.com/723459cc3a.js"></script>
	</head>
<body>
<%@ taglib uri="/WEB-INF/tld/security.tld" prefix="security" %>
<%@ include file="/jsp/onTop.jsp" %>
	<%
    Object idObject = session.getAttribute("id-user");
    if(idObject!=null) {
		String dbURL = "jdbc:mysql://localhost:3306/mydb";
	    String dbUser = "root";
	    String dbPass = "culo2118";
	    String idProdottoString = request.getParameter("idProdotto");
	    String idProdottoRequest = (String)request.getAttribute("idProdotto");
	    int maxCategoria = 0;
	    
	    int idProdotto = 0;
	    
	    if(idProdottoString != null) {
	    	if(!idProdottoString.equals(""))
	    		idProdotto = Integer.parseInt(idProdottoString);
	    } else {
	    	if(idProdottoRequest != null)
	    		idProdotto = Integer.parseInt(idProdottoRequest);
	    }
	    
	    if(idProdotto != 0) {
	    Connection conn = null; // connection to the database
        Statement statement = null;
        ResultSet resultSet = null;
        
    	ResultSet resultSet2 = null;
        try {
            // connects to the database
        	Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
            
            statement = conn.createStatement();
            
            String sql = "SELECT * FROM prodotto where idProdotto = " + idProdotto;
            resultSet = statement.executeQuery(sql);
            
            // constructs SQL statement
    		statement = conn.createStatement();
    		
    		String sql2 = "SELECT max(idCategoria) from categoria";
            
    		resultSet2 = statement.executeQuery(sql2);
    		resultSet2.next();
    		
    		maxCategoria = resultSet2.getInt(1);
            while (resultSet.next()) {%>
            	<div class="container-fluid" style="padding-top: 80px">
	            	<div class="col-6 offset-3 pt-4" style="padding-bottom:100px">
				
						<p class="display-6 text-center" style="padding-bottom: 20px;">Modifica Prodotto</p>
						<form method="post" action="/ProjectApp/modificaProdotti" enctype="multipart/form-data">
		            	
			            	<div class="form-group py-2">
			            		<label class="form-label" for="nome">Nome:</label>
								<input class="form-control" type="text" name="nome" id="nome" value="<%=resultSet.getString("nome")%>">
			            	</div>
				            
							<div class="form-group py-2">
								<label class="form-label" for="descrizione">Descrizione:</label>
								<textarea name="descrizione" class="form-control" id="descrizione" style="height: 100px"><%=resultSet.getString("descrizione")%></textarea>
								
							</div>
							
							<div class="form-group py-2">
								<label class="form-label" for="immagine">Immagine:</label>
								<input class="form-control" type="file" name="immagine" id="immagine" accept=".jpg,.png">
							</div>
							
							<div class="form-group py-2">
								<label class="form-label" for="prezzo">Prezzo:</label>
								<input class="form-control" type="number" id="prezzo" name="prezzo" min="1" value=<%=resultSet.getDouble("prezzo")%>>
							</div>
							
							<div class="form-group py-2">
								<label class="form-label" for="n_pezzi">Pezzi:</label>
								<input class="form-control" type="number" name="n_pezzi" id="n_pezzi" min="0" value=<%=resultSet.getInt("numero_pezzi")%>>
							</div>
							
							<div class="form-group py-2">
								<label for="categoria">Categoria:</label>
								<input class="form-control" type="number" name="categoria" id="categoria" min="1" value=<%=resultSet.getInt("idCategoria")%> max=<%=maxCategoria %>>
							</div>
							
							<input type="hidden" name="idProdotto" value="<%=resultSet.getInt("idProdotto")%>" />
							
							<font size="4" color="red"><security:enforceModificaProdotti modificaProdottiPage="/modificaProdottiJsp"/></font>
							
							
							
							
							
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
      		<%}   
        } catch (Exception ex) {
            %><h4>ERROR: <%= ex.getMessage() %></h4>
            <p><a href="modificaProdottiHome.jsp">Indietro</a></p>
        <%} 
        }
        } else {
        	response.sendRedirect(response.encodeURL("/ProjectApp/indexJsp"));
        
        }
        %>
</body>
</html>