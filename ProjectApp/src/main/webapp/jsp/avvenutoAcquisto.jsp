<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Resoconto acquisto</title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://kit.fontawesome.com/723459cc3a.js"></script>
	</head>
<body>
<%@ include file="/jsp/onTop.jsp" %>

<div class="container" style="padding-top: 80px">
	<p><a href="/ProjectApp/indexJsp" class="text-decoration-none text-black"><i class="fa-solid fa-house"></i> Home</a></p>
</div>

<div class="container" style="padding-top: 80px">
	<% 
	String avvenutoAcquisto = (String)session.getAttribute("avvenutoAcquisto");
	String errorPurchase = (String)session.getAttribute("error-purchase");
	if(user != null) {
		if(errorPurchase != null) {
	%>
	<font size="4" color="red"><%= errorPurchase %></font>
	<%} else if(avvenutoAcquisto != null) { %>
	<h3><%= avvenutoAcquisto %></h3>
	<%} } 
	// cleanup
	session.removeAttribute("avvenutoAcquisto");
	session.removeAttribute("error-purchase");
	%>
	</div>
</body>
</html>