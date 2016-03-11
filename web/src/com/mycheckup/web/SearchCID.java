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
import org.json.simple.JSONObject;

import com.mycheckup.ConnectionPool;
import com.mycheckup.ResultSetConverter;

/**
 * Servlet implementation class SearchCID
 */
@WebServlet("/SearchCID")
public class SearchCID extends HttpServlet {
	private static final long serialVersionUID = 1L;

	ConnectionPool connectionPool = null;
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;
	JSONArray jsonArray = new JSONArray();
	JSONObject obj = new JSONObject();


	public SearchCID() {
		super();

		connectionPool = ConnectionPool.getConnectionPool();
		conn = connectionPool.getConnection();
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		
		String c_name = request.getParameter("C_NAME");


		try {
			stmt = conn.createStatement();

			String sql = "select * from customer where c_name='" + c_name+"'";

	        rs=stmt.executeQuery(sql);
			jsonArray = ResultSetConverter.convert(rs);
			
			obj.put("result", jsonArray);

			rs.close();
			stmt.close();
		}
		catch (SQLException e) {
			
			e.printStackTrace();
			obj.put("result", "false");
			
			
		} finally {

			connectionPool.releaseConnection(conn);
		}

		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		out.println(obj);
		out.flush();

	}

}
