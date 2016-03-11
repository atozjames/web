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

smtp =conn.createStatement();

String sql="select  ROWNUM NUM,CID ,C_NAME ,C_LOCAL ,GRADE ,PEOPLE1,PEOPLE2 ,PEOPLE3 ,PEOPLE4 ,EMPOLYEE ,TO_CHAR(AGRR_DATE,'YYYY-MM-DD') AS AGRR_DATE,AGR_COST ,CHECKUP_AMT,SA_WON,CONDITION  from customer order by NUM";

ResultSet rs =smtp.executeQuery(sql);

jsonArray = ResultSetConverter.convert(rs);

out.println(jsonArray);
out.flush();




%>