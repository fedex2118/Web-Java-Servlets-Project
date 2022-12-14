<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h2><%= session.getAttribute("messaggio") %></h2>
	<br>
	<a href="homeAdmin.jsp">
		<button>
			torna alla home
		</button>
	</a>
</body>
</html>