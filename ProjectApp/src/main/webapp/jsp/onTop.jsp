<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
	</head>
<body>
	<%@page import="com.beans.*" %>
	<%@page session="true" %>
	<%
	// Prendiamo tutti i messaggi di errori se esistono e...
	String loginError = (String)session.getAttribute("login-error");
	String signInError = (String)session.getAttribute("signIn-error");
	String dashCategoriaError = (String)session.getAttribute("dashCategoria-errorMessage");
	String dashProdottiError = (String)session.getAttribute("dashProdotti-errorMessage");
	
	if(loginError != null) { // ...rimuoviamo gli errori se siamo arrivati dalla pagina login!
		session.removeAttribute("login-error");
	}
	if(signInError != null) { // ...rimuoviamo gli errori se siamo arrivati dalla pagina registrazione!
		session.removeAttribute("signIn-error");
	}
	%>
<nav class="navbar navbar-expand-lg navbar-light bg-white fixed-top">
<div class="container">
	  <a class="navbar-brand" href="/ProjectApp/indexJsp"><h2 style="color:#d80027"><b>Heartbeat</b></h2></a>
	  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
	    <span class="navbar-toggler-icon"></span>
	  </button>
	  <div class="collapse navbar-collapse" id="navbarSupportedContent">
	    <ul class="navbar-nav ms-auto">
	  	<%
		User user = (User)session.getAttribute("user");
		String uri = request.getRequestURI();
		
		if(uri.endsWith("indexJsp")) {
			
		%>
		<li class="nav-item">
          <div class="dropdown nav-link active">
          <a class="dropdown-toggle text-decoration-none text-black" id="dropdownMenuButton1" data-bs-toggle="dropdown" aria-expanded="false">
            <i class="fa-solid fa-list fa-lg"></i> Categorie di Prodotti
          </a>
          <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton1">

          <%
            String url2 = "jdbc:mysql://localhost:3306/mydb";
            String username2 = "root";
            String password2 = "culo2118";
            String sql2 = "select * from Categoria;";
            Class.forName("com.mysql.jdbc.Driver");
            Connection con2 = DriverManager.getConnection(url2, username2, password2);
            try {
                Class.forName("com.mysql.jdbc.Driver");
                Statement st2 = con2.createStatement();
                ResultSet rs2 = st2.executeQuery(sql2);

                while(rs2.next()) {
            %> 

            <% String path2 = "/ProjectApp/indexJsp?categoria=" + rs2.getString(1); %>
            <li><a class="dropdown-item" href=<%=path2%>><%= rs2.getString(2) %></a></li>

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
                if(con2 != null) {
                    try {con2.close();
                    } catch(SQLException e) {
                        e.printStackTrace();
                        System.err.println(e.getMessage());
                    }

                }
            }

        %>

          </ul>
        </div>
        </li>
		
		<%
		}
		if (user == null) {
	%>
	      <li class="nav-item">
	            <a class="nav-link active" href="/ProjectApp/loginJsp"><i class="fa-solid fa-user-check fa-lg" style="color: #3c3c3c"></i>
	                Login</a>
	          </li>
	      <li class="nav-item">
	            <a class="nav-link active" href="/ProjectApp/signInJsp"><i class="fa-solid fa-user-plus fa-lg" style="color: #3c3c3c"></i>  Registrazione</a>
	          </li>
	    </ul>
	  </div>
	  <% } else { %>
	      <li class="nav-item">
	            <a class="nav-link active" href="/ProjectApp/profiloJsp"><i class="fa-solid fa-user-check fa-lg" style="color: #3c3c3c"></i>
	                <%=user.getUserName()%></a>
	          </li>
	          <li class="nav-item">
	          <% Carrello carrello = (Carrello)session.getAttribute("carrello"); %>
	            <a class="nav-link active position-relative" href="/ProjectApp/carrello"><i class="fa-solid fa-cart-shopping fa-lg" style="color: #3c3c3c"></i>
	                <span class="top-50 start-100 translate-middle badge rounded-pill bg-danger"><%=carrello.len() %></span></a>
			</li>
	      
	    
	  <% String permesso = (String)session.getAttribute("permesso");
	  if(permesso.equals("venditore")) { %>
	  
	  <li class="nav-item">
	            <form action="<%= response.encodeURL("/ProjectApp/jsp/dashProdotti.jsp") %>" method="post"><button type="submit" class="btn shadow-none"><i class="fa-solid  fa-circle-plus fa-lg" style="color: #3c3c3c"></i>  Aggiungi Prodotto</button></form>
	  </li>
	  <li class="nav-item">
	            <form action="<%= response.encodeURL("/ProjectApp/jsp/modificaProdottiHome.jsp") %>" method="post"><button type="submit" class="btn shadow-none"><i class="fa-solid  fa-code fa-lg" style="color: #3c3c3c"></i>  Modifica Prodotto</button></form>
	  </li>
	  
	  
	  <% }
	  else if(permesso.equals("admin")) {
		  %>
		  <li class="nav-item">
	            <form action="<%= response.encodeURL("/ProjectApp/jsp/homeAdmin.jsp") %>" method="post"><button type="submit" class="btn shadow-none"><i class="fa-solid fa-gauge-high fa-lg" style="color: #3c3c3c"></i>  Admin Page</button></form>
	      </li>
	  <% }%>
	  	<li class="nav-item">
	            <form action="<%= response.encodeURL("/ProjectApp/logout") %>" method="post"><button type="submit" class="btn shadow-none"><i class="fa-solid fa-user-plus fa-lg" style="color: #3c3c3c"></i>  Logout</button></form>
	          </li>
	 	 </ul>
	  	</div>
	  <%
	  
	  
	  } %>
	  	
  </div>
</nav>

</body>
</html>