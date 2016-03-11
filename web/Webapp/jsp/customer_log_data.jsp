<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.*,com.mycheckup.*,java.io.*"%>
<%@ page import="org.json.simple.*"%>


<%

ConnectionPool connectionPool=null;
Connection conn = null;
Statement smtp = null;

connectionPool =ConnectionPool.getConnectionPool();
conn = connectionPool.getConnection();

JSONArray  jsonArray = new JSONArray();

String cid =request.getParameter("CID");

int Cid =Integer.parseInt(cid);

smtp =conn.createStatement();

String sql="select * from (select ROWNUM NUM, A.MID, A.CID,B.C_NAME,A.LOG,TO_CHAR(A.REG_DATE,'YYYY-MM-DD') AS REG_DATE from custom_log A,customer B where A.cid=b.cid) where cid="+cid;

//out.print(sql);

ResultSet rs =smtp.executeQuery(sql);

jsonArray = ResultSetConverter.convert(rs);

out.println(jsonArray);
out.flush();




%>