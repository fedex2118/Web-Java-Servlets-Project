<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Sign In</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-0evHe/X+R7YkIZDRvuzKMRqM+OrBnVFBL6DOitfPri4tjfHxaWutUpFmBp4vmVor" crossorigin="anonymous">
<script src="https://kit.fontawesome.com/723459cc3a.js"></script>
</head>
<%@ taglib uri="/WEB-INF/tld/security.tld" prefix="security" %>
<body>
	<%	
	String loginError = (String)session.getAttribute("login-error");
	if(loginError != null) { // rimuoviamo gli errori se siamo arrivati dalla pagina di login!
		session.removeAttribute("login-error");
	} %>

<div class="container">
			<div class="row justify-content-center">
				<div class="col-xxl-4 col-xl-5 col-lg-5 col-md-7 col-sm-9">
					<div class="text-center my-5">
					<i style="color:#d80027; --fa-animation-duration: 1s; --fa-beat-scale: 1.1;" class="fa-solid fa-8x fa-heart-pulse  my-3 fa-beat"></i>
						<h2 style="color:#d80027"><b>Heartbeat</b></h2>
					</div>
					<div class="card shadow-lg">
						<div class="card-body p-5">
							<h1 class="fs-4 card-title fw-bold mb-4">Sign In</h1>
							<form action="<%= response.encodeURL("/ProjectApp/registrazione") %>" method="post">
			  					<div class="mb-3">
			    					<label class="form-label"><i class="fa-solid fa-lg fa-user"></i>  Nome</label>
			    					<input type="text" class="form-control" name="nome" maxlength="40" pattern="^[-a-zA-Z-()]*$" autofocus required title="Sono richieste solo lettere!">
			  					</div>
			 					<div class="mb-3">
			    					<label class="form-label"><i class="fa-solid fa-lg fa-user"></i>  Cognome</label>
			    					<input type="text" class="form-control" name="cognome" maxlength="40" pattern="^[-a-zA-Z-()]*$" autofocus required title="Sono richieste solo lettere!">
			  					</div>
			  					<div class="mb-3">
			    					<label class="form-label"><i class="fa-solid fa-lg fa-user-astronaut"></i>  Username</label>
			    					<input type="text" class="form-control" name="userName" maxlength="25" pattern="^[-a-zA-Z-0-9-()]*$" autofocus required title="Solo lettere e numeri sono ammessi!">
			  					</div>
			  					<div class="mb-3">
			    					<label class="form-label"><i class="fa-solid fa-lg fa-key"></i>  Password</label>
			    					<input type="password" class="form-control" name="pwd" maxlength="25" pattern="^\S+$" autofocus required title="Non sono ammessi spazi!">
			  					</div>
			  					<button type="submit" class="btn btn-danger" value="Submit"><i class="fa-solid fa-lg fa-check"></i>   Submit</button>
							</form>
							<hr>
							<center>
								<p><font size=4 color=red><security:signInErrors/></font></p>
								<a href="/ProjectApp/loginJsp"><button class="btn btn-dark"><i class="fa-solid fa-sm fa-user-plus"></i>   Login</button></a>
								<a href="/ProjectApp/indexJsp"><button class="btn btn-dark"><i class="fa-solid fa-sm fa-house"></i>   Home</button></a>
								<security:enforceSignIn signInPage="/signInJsp"/>
							</center> 
						</div>
					</div>
				</div>
			</div>
		</div>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/js/bootstrap.bundle.min.js" integrity="sha384-pprn3073KE6tl6bjs2QrFaJGz5/SUsLqktiwsUTF55Jfv3qYSDhgCecCxMW52nD2" crossorigin="anonymous"></script>
</body>
</html>