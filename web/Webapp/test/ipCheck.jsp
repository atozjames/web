<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="UTF-8"%>
    
<%@ page import="com.mycheckup.*"%>

<%
//request.getHeaderNames();

String remoteIP=request.getRemoteAddr(); 

out.print(remoteIP);

//String tmsg="12.24.56.23";
String msg="13245623";

String delimiter="\\.";
Mcfunction mcFunction = new Mcfunction();

String rmsg=mcFunction.splitStr(remoteIP,delimiter);
if(!msg.equals(rmsg)){
	
//response.sendRedirect("../error.html");
out.print(remoteIP);

}

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<h1>당신은 정당한 사용자 입니다.</h1>
</body>
</html>