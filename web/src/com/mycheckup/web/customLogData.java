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
 * Servlet implementation class customLogData
 */
@WebServlet("/customLogData")
public class customLogData extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private static ConnectionPool connectionPool = null;
	private static Connection conn = null;

	Statement smtp = null;
	JSONArray jsonArray = new JSONArray();

	public customLogData() {
		super();
		connectionPool = ConnectionPool.getConnectionPool();
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String sql = "select rownum num,A.C_NAME,B.CID,b.mid,b.log,to_char(B.REG_DATE,'YYYY/MM/DD') as REG_DATE from customer a, custom_log b where a.cid=b.cid";

		try {
			conn = connectionPool.getConnection();
			smtp = conn.createStatement();
			ResultSet rs = smtp.executeQuery(sql);
			jsonArray = ResultSetConverter.convert(rs);

			rs.close();
			smtp.close();

		} catch (SQLException e) {
			e.printStackTrace();

		} finally {

			connectionPool.releaseConnection(conn);
		}

		response.setContentType("application/x-json; charset=UTF-8");

		PrintWriter out = response.getWriter();
		out.print(jsonArray);
		out.flush();
	}

}
