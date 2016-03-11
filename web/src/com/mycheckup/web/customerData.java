package com.mycheckup.web;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;

import com.mycheckup.ConnectionPool;
import com.mycheckup.ResultSetConverter;

/**
 * Servlet implementation class customerLogData
 */
@WebServlet("/customerData")
public class customerData extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public customerData() {
		super();
		// TODO Auto-generated constructor stub
	}

	Statement smtp = null;
	ConnectionPool connectionPool = ConnectionPool.getConnectionPool();
	Connection conn = null;
	JSONArray jsonArray = new JSONArray();

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub

		// String cid = request.getParameter("CID");

		// int Cid = Integer.parseInt(cid);

		String sql = "select  ROWNUM NUM,CID ,C_NAME ,C_LOCAL ,GRADE ,PEOPLE1,PEOPLE2 ,PEOPLE3 ,PEOPLE4 ,EMPOLYEE ,TO_CHAR(AGRR_DATE,'YYYY-MM-DD') ";
		sql += "AS AGRR_DATE,AGR_COST ,CHECKUP_AMT,SA_WON,CONDITION  from customer order by NUM";

		try {
			conn = connectionPool.getConnection();
			smtp = conn.createStatement();
			ResultSet rs = smtp.executeQuery(sql);
			jsonArray = ResultSetConverter.convert(rs);
			
			rs.close();
			smtp.close();
			
		} catch (SQLException e) {
			e.printStackTrace();
		
		}finally{
			
			connectionPool.releaseConnection(conn);
		}

		response.setContentType("application/x-json; charset=UTF-8");

		PrintWriter out = response.getWriter();
		out.print(jsonArray);
		out.flush();
		
	
		
	 }

	
	

}
