<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.mycheckup.*"%>
<%@ page import="controller.*"%>

<%

//request.getHeaderNames();
String remoteIP=request.getRemoteAddr(); 
//out.print(remoteIP);

//String remoteIP="192.168.0.35";
if(!Ipcheck.ipCheck(remoteIP)){
response.sendRedirect("error.html");
}

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>