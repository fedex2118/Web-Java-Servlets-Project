<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>HomePage</title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://kit.fontawesome.com/723459cc3a.js"></script>
	</head>
<body id="inizio">
<%@ include file="/jsp/onTop.jsp" %>

<div class="container" style="padding-top: 80px">
    <div class="row">
      <div class="col-12 col-lg-6">
        <p class="display-4">
          Hai bisogno di un
          <span style="color:#d80027">medicinale</span>? Ordina quello che vuoi e
          salva una <span style="color:#d80027">vita</span>!
        </p>
      </div>
      <div class="col-12 col-lg-6">
        <center>
          <i class="fa-solid fa-syringe fa-10x" style="color:#d80027; padding: 50px"></i>
        </center>
      </div>
    </div>
  </div>
  <div class="container" style="padding-top: 40px">
    <p class="display-5 text-center" style="padding-bottom: 10px;">Prodotti di Tendenza</p>
    <div class="row">
<%
            String url = "jdbc:mysql://localhost:3306/mydb";
            String username = "root";
            String password = "culo2118";
            String categoria = request.getParameter("categoria");
            String sql = "";
            if(categoria != null) {
                sql = "select * from Prodotto where idCategoria="+categoria;
            }
            else {
                sql = "select * from Prodotto";
            }
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection(url, username, password);
            try {
                Class.forName("com.mysql.jdbc.Driver");
                Statement st = con.createStatement();
                ResultSet rs = st.executeQuery(sql);

                while(rs.next()) {
                    byte barray[] = rs.getBytes(4);
                    String base64Image = Base64.getEncoder().encodeToString(barray);
            %> 

			
			<div class="col-6 col-md-4 col-lg-3" style="margin-bottom: 20px;">
			   <% String path = "jsp/prodotto.jsp?idProdotto=" + rs.getString(1); %>
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
			
		%>
		
		
    </div>
  </div>
  
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/js/bootstrap.bundle.min.js" integrity="sha384-pprn3073KE6tl6bjs2QrFaJGz5/SUsLqktiwsUTF55Jfv3qYSDhgCecCxMW52nD2" crossorigin="anonymous"></script>
</body>
</html>
