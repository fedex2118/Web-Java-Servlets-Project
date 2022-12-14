<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>ModificaProdottiHome</title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://kit.fontawesome.com/723459cc3a.js"></script>
	</head>
<body id="inizio">
<%@ include file="/jsp/onTop.jsp" %>

  <div class="container" style="padding-top: 80px">
    <p class="display-5 text-center" style="padding-bottom: 10px;">Scegli un prodotto da modificare</p>
    <div class="row">
	    <%
	    Object idObject = session.getAttribute("id-user");
	    if(idObject!=null) {
	    	    int id = (int)idObject;
	    		String url = "jdbc:mysql://localhost:3306/mydb";
	    		String username = "root";
	    		String password = "culo2118";
	    		String sql = "";
	    		String permesso = (String)session.getAttribute("permesso"); // prendo il permesso e...
	    		if(permesso.equals("admin")) // se è admin può modificare tutti i prodotti!
	    			sql = "select * from prodotto";
	    		else
	    			sql = "select * from prodotto, utente where "
	    				+ "prodotto.idCreatore=utente.idUtente and prodotto.idCreatore=" + id;
	    		Class.forName("com.mysql.jdbc.Driver");
	    		Connection con = DriverManager.getConnection(url, username, password);
	    		try {
	    			Class.forName("com.mysql.jdbc.Driver");
	    			Statement st = con.createStatement();
	    			ResultSet rs = st.executeQuery(sql);
	    			int i = 0;
	    			while (rs.next()) {
	    				i++;
	    				byte barray[] = rs.getBytes(4);
	    				String base64Image = Base64.getEncoder().encodeToString(barray);
	    %> 
			
			<div class="col-6 col-md-4 col-lg-3" style="margin-bottom: 20px;">
			   <% String path = "/ProjectApp/jsp/modificaProdotti.jsp?idProdotto=" + rs.getString(1); %>
				<a href=<%=path%> class="text-decoration-none text-black">
          		<div class="card" style="background-color: #fbfbfb;">
          		<img src="<%="data:image/jpg;base64,"+base64Image%>" class="img-fluid" style="height: 240px; margin: 5px 5px 0px 5px;"/>
            		<div class="card-body">
              			<h5 class="card-title text-center"><%= rs.getString(2) %></h5>
            		</div>
          		</div>
          		</a>
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
	    } else {
			response.sendRedirect(response.encodeURL("/ProjectApp/indexJsp"));
	    }
		%>
		
		
    </div>
  </div>	
</body>
</html>