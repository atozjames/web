package com.mycheckup.web;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mycheckup.ConnectionPool;

/**
 * Servlet implementation class customerDelete
 */
@WebServlet("/customerDelete")
public class customerDelete extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private ConnectionPool connectionPool = null;
	private Connection conn = null;
	private Statement smtp = null;
	private PreparedStatement psmt = null;
	private ResultSet rs = null;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public customerDelete() {
		super();
		// TODO Auto-generated constructor stub
		connectionPool = ConnectionPool.getConnectionPool();
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String cid = request.getParameter("CID");

		int num = Integer.parseInt(cid);

		conn = connectionPool.getConnection();

		String sql = "DELETE FROM customer WHERE cid=?";

		try {

			psmt = conn.prepareStatement(sql);
			psmt.setInt(1, num);

			psmt.executeUpdate();
			psmt.close();

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			connectionPool.releaseConnection(conn);
		}

	}

}
