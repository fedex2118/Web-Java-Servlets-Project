<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Recensione </title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://kit.fontawesome.com/723459cc3a.js"></script>
	</head>
<body>
<%@ include file="/jsp/onTop.jsp" %>
<%
Object idObject = session.getAttribute("id-user");
if(idObject!=null) {

%>
	
	<div class="container" style="padding-top: 80px">
    	<p class="display-5 text-center" style="padding-bottom: 10px;">Scrivi o modifica la tua recensione</p>
    	<p><a href="/ProjectApp/indexJsp" class="text-decoration-none text-black"><i class="fa-solid fa-house"></i> Home</a></p>
    		<div class="row">
			<% String url = "jdbc:mysql://localhost:3306/mydb";
			String username = "root";
			String password = "culo2118"; 
			int idProdotto = Integer.parseInt(request.getParameter("idProdotto"));
			String sql = "select descrizione, valutazione from Recensione where idProdotto="+idProdotto+" and idUtente="+session.getAttribute("id-user"); 
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(url, username, password);
			try {
				Class.forName("com.mysql.jdbc.Driver");
				Statement st = con.createStatement();
				ResultSet rs = st.executeQuery(sql);
				if(!rs.isBeforeFirst()) {
					%>
					<div class="col-lg-6">
						<form method="post">
		                	<input type="hidden" name="idProdotto" value=<%=request.getParameter("idProdotto") %>>
							<input type="text"  name="descrizione" pattern="^[-a-zA-Z,.!?'-()]+(\s+[-a-zA-Z,.!?'-()]+)*$"  maxlength="45" required="required" autofocus required title="Sono ammesse solo lettere e questi caratteri ! , ? '"> Scrivi come ti è sembrato il prodotto
		                	<hr>
		                	<input type="number" name="valutazione" min="0" max="5" required="required" > Valutazione
		                	<hr>
				    		<button type="submit" formaction="/ProjectApp/uploadRecensione" class="btn btn-outline-success"><i class="fa-solid fa-lg fa-money-bill-wave"></i> Invia</button>			    		
		                </form>
	                </div>
				<%  
				}
				else {
					
					if(rs.next()) {
						String descrizione = rs.getString(1);
						int valutazione = rs.getInt(2);
				    
				    %>
				    
			      <div class="col-lg-6">
						<form method="post">
		                	<input type="hidden" name="idProdotto" value=<%=request.getParameter("idProdotto") %>>
		                	<input type="hidden" name="recensione" value="esiste">
		                	<input type="text"  name="descrizione" pattern="^[-a-zA-Z,.!?'-()]+(\s+[-a-zA-Z,.!?'-()]+)*$"  maxlength="45" required="required" value="<%=descrizione %>" autofocus required title="Sono ammesse solo lettere e questi caratteri ! , ? '"> Scrivi come ti è sembrato il prodotto
		                	<hr>
		                	<input type="number" name="valutazione" value=<%=valutazione %> min="0" max="5" required="required">Valutazione
		                	<hr>
				    		<button type="submit" formaction="/ProjectApp/uploadRecensione" class="btn btn-outline-success"><i class="fa-solid fa-lg fa-envelope"></i> Invia</button> 
		                </form>
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