<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Prodotti acquistati </title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://kit.fontawesome.com/723459cc3a.js"></script>
	</head>
<body>
<%@ include file="/jsp/onTop.jsp" %>
	<%    
	Object idObject = session.getAttribute("id-user");
    if(idObject!=null) { %>
	<div class="container" style="padding-top: 80px">
		<p><a href="/ProjectApp/indexJsp" class="text-decoration-none text-black"><i class="fa-solid fa-house"></i> Home</a></p>
    	<p class="display-5 text-center" style="padding-bottom: 10px;">Prodotti Acquistati</p>
    	
    		<div class="row">
			<% String url = "jdbc:mysql://localhost:3306/mydb";
			String username = "root";
			String password = "culo2118";
			String sql = "select prodotto.idProdotto, nome, immagine, data, quantità from Prodotto, Fattura where fattura.idProdotto=prodotto.idProdotto and fattura.idUtente="+session.getAttribute("id-user"); 
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(url, username, password);
			try {
				Class.forName("com.mysql.jdbc.Driver");
				Statement st = con.createStatement();
				ResultSet rs = st.executeQuery(sql);
				if(!rs.isBeforeFirst()) {
					%>
					<p><center><h5>Non hai effettuato alcun acquisto<h5></center></p>
				<%  
				}
				else {
					
					while(rs.next()) {
				    byte barray[] = rs.getBytes(3);
				    String base64Image = Base64.getEncoder().encodeToString(barray);
					 //TODO da vedere cosa fare per la data...
	
				    %>
				    
				    
			      <p><div class="col-lg-6">

			   		<% String path = "prodotto.jsp?idProdotto=" + rs.getString(1); %>
					<a href=<%=path%> class="text-decoration-none text-black">
					<img src="<%="data:image/jpg;base64,"+base64Image%>" class="img-fluid" style="height: 450px; width: 450px; border: 2px solid rgba(0, 0, 0, 0.125); border-radius: 0.25rem;"/>
			      	<!--<img src="<%="data:image/jpg;base64,"+base64Image%>" class="img-fluid" style="height: 240px; margin: 5px 5px 0px 5px;"/>--></a>

			      </div>
			      <div class="col-lg-6">
			        <h5 class="card-title text-center"><%= rs.getString(2) %></h5>
	                <hr>
	                <p class=""><i class="fa-solid fa-money-bill"></i> <b>Data</b>: <%=rs.getDate(4)%></p>
	                <p class=""><i class="fa-solid fa-arrow-up-9-1"></i> <b>Quantità</b>: <%=rs.getInt(5)%></p>
	                <hr>
	                <form method="post">
	                	<center>
	                	<input type="hidden" name="idProdotto" value=<%=rs.getString(1) %>>
			    		<button type="submit" formaction="/ProjectApp/jsp/recensione.jsp" class="btn btn-outline-success"><i class="fa-solid fa-lg fa-pencil"></i> Scrivi o modifica la tua recensione</button> 
			    		</center>
	                </form>
			    </div></p>
			  
					<% //TODO da vedere href del scrivere una recensione e vedere se funziona...
								} %>
					</div>
					</div>
					<%
					}  
			} catch(SQLException e) {
			e.printStackTrace();
			System.out.println("SQL problem:" + e.getMessage());
			System.out.println("SQL state: " + e.getSQLState());
			System.out.println("Error: " + e.getErrorCode());
			System.exit(1);
		
			} catch(ClassNotFoundException e) {
			e.printStackTrace();
			System.err.println("Non trovo il driver: " + e.getMessage());
			}
		
			finally {
			if(con != null) {
				try {con.close();
				} catch(SQLException e) {
					e.printStackTrace();
					System.err.println(e.getMessage());
					}
			
				}
			}
    }
    else {
    	response.sendRedirect(response.encodeURL("/ProjectApp/indexJsp"));
    }
		%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/js/bootstrap.bundle.min.js" integrity="sha384-pprn3073KE6tl6bjs2QrFaJGz5/SUsLqktiwsUTF55Jfv3qYSDhgCecCxMW52nD2" crossorigin="anonymous"></script>	
</body>
</html>