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
int maxCategoria = 0;
if(idObject!=null && !(permesso.equals("utente"))) {
	
	Connection conn = null; // connection to the database
	ResultSet resultSet = null;

	try {
		// connects to the database
		Class.forName("com.mysql.jdbc.Driver");
		
	    String dbURL = "jdbc:mysql://localhost:3306/mydb";
	    String dbUser = "root";
	    String dbPass = "culo2118";
		
		conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

		// constructs SQL statement
		Statement statement = conn.createStatement();
		
		String sql = "SELECT max(idCategoria) from categoria";
		
		resultSet = statement.executeQuery(sql);
		resultSet.next();
		
		maxCategoria = resultSet.getInt(1);

		// sends the statement to the database server
	} catch (SQLException | ClassNotFoundException ex) {
		ex.printStackTrace();
	} finally {
		if (conn != null) {
			// closes the database connection
			try {
				conn.close();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}
	}

%>
		<div class="container-fluid" style="padding-top: 80px">
			<div class="col-6 offset-3 pt-4" style="padding-bottom:100px">
			
				<p class="display-6 text-center" style="padding-bottom: 20px;">Aggiungi Prodotto</p>
				<form method="post" action="/ProjectApp/uploadProdotti" enctype="multipart/form-data">
            	
	            	<div class="form-group py-2">
	            		<label class="form-label" for="nome">Nome:</label>
						<input class="form-control" type="text" name="nome" id="nome">
	            	</div>
		            
					<div class="form-group py-2">
						<label class="form-label" for="descrizione">Descrizione:</label>
						<textarea name="descrizione" class="form-control" id="descrizione" style="height: 100px"></textarea>
						
					</div>
					
					<div class="form-group py-2">
						<label class="form-label" for="immagine">Immagine:</label>
						<input class="form-control" type="file" name="immagine" id="immagine" accept=".jpg,.png">
					</div>
					
					<div class="form-group py-2">
						<label class="form-label" for="prezzo">Prezzo:</label>
						<input class="form-control" type="number" id="prezzo" name="prezzo" min="1">
					</div>
					
					<div class="form-group py-2">
						<label class="form-label" for="n_pezzi">Pezzi:</label>
						<input class="form-control" type="number" name="n_pezzi" id="n_pezzi" min="0">
					</div>
					
					<div class="form-group py-2">
						<label for="categoria">Categoria:</label>
						<input class="form-control" type="number" name="categoria" id="categoria" min="1" max=<%=maxCategoria %>>
					</div>
					<font size=4 color="red"><security:dashProdottiErrors/></font>
					<security:enforceDashProdotti dashProdottiPage="/DashProdottiJsp"></security:enforceDashProdotti>
					
					<div class="row pt-4">
						<div class="col-3">
							<input class="btn btn-secondary btn-sm w-100" type="submit" />
						</div>
						<div class="col-3 offset-6"> 
							<a class="btn btn-danger btn-sm w-100" href="/ProjectApp/indexJsp">Indietro</a> 
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