<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Profilo utente </title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://kit.fontawesome.com/723459cc3a.js"></script>
	</head>
<body>
<%@ include file="/jsp/onTop.jsp" %>
<%
Object idObject = session.getAttribute("id-user");
String permesso = (String)session.getAttribute("permesso");
if(idObject!=null) {

%>
	<div class="container" style="padding-top: 80px">
	<p><a href="/ProjectApp/indexJsp" class="text-decoration-none text-black"><i class="fa-solid fa-house"></i> Home</a></p>
    <p class="display-5 text-center" style="padding-bottom: 20px;">Profilo utente</p>

    <div class="row">
	<% String url = "jdbc:mysql://localhost:3306/mydb";
	String username = "root";
	String password = "culo2118"; // 
	String sql = "select nome, cognome, username from Utente where idUtente="+session.getAttribute("id-user");
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection(url, username, password);
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Statement st = con.createStatement();
			ResultSet rs = st.executeQuery(sql);
			if(rs.next()) {
				String nome = rs.getString(1);
				String cognome = rs.getString(2);
				String nomeUtente = rs.getString(3);
			    %> 	
			    <div class="col-lg-6">
		        <h5 class="card-title text-center">Nome: <%= nome %></h5>
		        <hr>	
			    <h5 class="card-title text-center">Cognome: <%= cognome %></h5>
			    <hr>
			    <h5 class="card-title text-center">Nome Utente: <%= nomeUtente %></h5>
			    <hr>
			    <form method="get">
			    	<center>
			    	<button type="submit" formaction="/ProjectApp/jsp/historyAcquisti.jsp" class="btn btn-outline-success"><i class="fa-solid fa-lg fa-bag-shopping"></i> Guarda gli acquisti che hai fatto</button> 
			    	</center>
	            </form>
				</div>
			    
			    
		<%		}
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
			} %> 
			</div>	
		</div>
				<%
	} else {
		response.sendRedirect(response.encodeURL("/ProjectApp/indexJsp"));
	}
	%>			  	  	
</body>
</html>