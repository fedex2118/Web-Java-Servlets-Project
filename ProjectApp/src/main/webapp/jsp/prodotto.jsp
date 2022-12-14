<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title><%=request.getParameter("idProdotto")%></title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://kit.fontawesome.com/723459cc3a.js"></script>
	</head>
<body>

<%@ include file="/jsp/onTop.jsp" %>
	    <%  
			String url = "jdbc:mysql://localhost:3306/mydb";
			String username = "root";
			String password = "culo2118";
			String sql = "select * from Prodotto where idProdotto=" + request.getParameter("idProdotto");
			String sqlRecensione = "select descrizione, valutazione, username from Recensione, Utente where recensione.idUtente=utente.idUtente and idProdotto=" + request.getParameter("idProdotto");
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(url, username, password);
			try {
				Class.forName("com.mysql.jdbc.Driver");
				Statement st = con.createStatement();
				Statement stRecensione = con.createStatement();
				ResultSet rs = st.executeQuery(sql);
				ResultSet rsRecensione = stRecensione.executeQuery(sqlRecensione);
				if(rs.next()) {
				byte barray[] = rs.getBytes(4);
			    String base64Image = Base64.getEncoder().encodeToString(barray);
			%> 
			
			
			<div class="container" style="padding-top: 80px">
			<p><a href="/ProjectApp/indexJsp" class="text-decoration-none text-black"><i class="fa-solid fa-house"></i> Home</a> > <%=request.getParameter("idProdotto")%></p>
		    <div class="row">
		      <div class="col-lg-6">
		      <center>
		      	<img src="<%="data:image/jpg;base64,"+base64Image%>" class="img-fluid" style="height: 500px; width: 500px; border: 2px solid rgba(0, 0, 0, 0.125); border-radius: 0.25rem;"/>
		      	</center>
		      </div>
		      <div class="col-lg-6">
		        <p class="card-title text-center display-4"><%= rs.getString(2) %></p> <br>
                <p class="text-center"><%=rs.getString(3)%></p>
                <hr>
                <p class=""><i class="fa-solid fa-money-bill"></i> <b>Prezzo</b>: <%=rs.getString(5)%> euro a pezzo</p>
                <p class=""><i class="fa-solid fa-box"></i> <b>Pezzi disponibili</b>: <%=rs.getString(6)%> pezzi</p>
                <p class=""><i class="fa-solid fa-layer-group"></i> <b>Categoria</b>: <%=rs.getString(7)%></p>
                <form method="post">
	                <p><i class="fa-solid fa-arrow-up-9-1"></i> <b>Quantità</b>:  <input type="number" name="quantita" id="quantita" class="form-control" min="1" max="<%=rs.getString(6)%>" style="display: inline; width: auto;" placeholder="0" required="required"/></p>
	                <hr>
				      <center>
				      	<label><input type="hidden" name="idProdotto" value=<%=request.getParameter("idProdotto") %>></label> 
				      	
				      	<button type="submit" formaction="/ProjectApp/acquisti" class="btn btn-outline-success">
				      		<i class="fa-solid fa-lg fa-money-bill-wave"></i> Acquista subito
				      	</button>
				      	<button type="submit" formaction="/ProjectApp/aggiungiCarrello"  class="btn btn-outline-danger">
				      		<i class="fa-solid fa-lg fa-cart-shopping"></i> Aggiungi al carrello
				      	</button>
				      </center>
				      
				</form>
		    </div>
		  </div>
		  
		  <div style="padding-top: 40px;">
		  <nav>
		  <div class="nav nav-tabs" id="nav-tab" role="tablist">
		    <button class="nav-link active" id="nav-home-tab" data-bs-toggle="tab" data-bs-target="#nav-home" type="button" role="tab" aria-controls="nav-home" aria-selected="true">Recensioni</button>
		  </div>
		</nav>
		<div class="tab-content py-5" id="nav-tabContent">
		  <div class="tab-pane fade show active" id="nav-home" role="tabpanel" aria-labelledby="nav-home-tab" tabindex="0">
		 <%
		 	if(!rsRecensione.isBeforeFirst()) { // per vedere se ci sono recensioni per il prodotto...
		  		String messaggioRecensione = "Non ci sono ancora recensioni per questo prodotto";
		  		%>
		  		<div class="row">
		  			<div class="col-10 offset-1">
		  			<p class="lead">
		  				<%=messaggioRecensione %>
		  			</p>
		  			</div>
		  		</div>
		  	<%   }
		  	else {%>
		  			
					<div class="row" >
		  		<% while (rsRecensione.next()) { 
					String utenteRecensione = rsRecensione.getString(3);
					int valutazioneRecensione = rsRecensione.getInt(2);
					String descrizioneRecensione = rsRecensione.getString(1);
					%>
						
						<div class="col-10 offset-1" style="border-bottom: 1px solid #D3D3D3;">
							<div class="row">
								<div class="col-10">
									<p class="fw-bolder"><%=utenteRecensione %></p> 
								</div>
								<div class="col-2">
									<%
										int countStars = valutazioneRecensione;
										for(int i = 0;i<5;i++){
											if(countStars>0){
												countStars--;
												%>
												<i class="fa fa-star" aria-hidden="true"></i>
												<%
											}
											else{
												%>
												<i class="fa fa-star-o" aria-hidden="true"></i>
												<%
											}
										}
									
									%>
								</div>
								<div class="col-10 offset-1">
									<p class="lead"><%=descrizioneRecensione %></p>
								</div>
							</div>
							
							
							
							
						</div>
					
				<% } %>
					</div>
				</div>
		  </div>
		  <div class="tab-pane fade" id="nav-contact" role="tabpanel" aria-labelledby="nav-contact-tab" tabindex="0">...</div>
		</div>
		</div>
      		<%
      				}
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
			
		%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/js/bootstrap.bundle.min.js" integrity="sha384-pprn3073KE6tl6bjs2QrFaJGz5/SUsLqktiwsUTF55Jfv3qYSDhgCecCxMW52nD2" crossorigin="anonymous"></script>
</body>
</html>