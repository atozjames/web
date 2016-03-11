package com.mycheckup.web;

import java.io.IOException;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mycheckup.*;

/**
 * Servlet implementation class myDataSave
 */
@WebServlet("/myDataSave")
public class myDataSave extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private ConnectionPool connectionPool = null;
	private Connection conn = null;
	private Statement smtp = null;
	private PreparedStatement psmt = null;
	private ResultSet rs = null;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public myDataSave() {
		super();
		// TODO Auto-generated constructor stub

		connectionPool = ConnectionPool.getConnectionPool();
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		String c_name = request.getParameter("C_NAME");
		String c_local = request.getParameter("C_LOCAL");
		String grade = request.getParameter("GRADE");
		String people1 = request.getParameter("PEOLPE1");
		String people2 = request.getParameter("PEOPLE2");
		String people3 = request.getParameter("PEOLPE3");
		String people4 = request.getParameter("PEOPLE4");
		String empolyee = request.getParameter("EMPOLYEE");
		String agrr_date = request.getParameter("AGGR_DATE");
		String agr_cost = request.getParameter("AGR_COST");
		String checkup_amt = request.getParameter("CHECKUP_AMT");
		String sa_won = request.getParameter("SA_WON");

		try {
			int maxcid = 0;
			conn = connectionPool.getConnection();

			String sql1 = "select max(cid) from customer";

			smtp = conn.createStatement();

			rs = smtp.executeQuery(sql1);

			while (rs.next()) {

				maxcid = rs.getInt(1);
				maxcid=maxcid+1;
			}

			rs.close();
			smtp.close();

			String sql2 = "insert into customer(cid,c_name,c_local,grade,people1,people2,people3,people4,empolyee,agrr_date,agr_cost,checkup_amt,sa_won)";
			sql2 += "values(?,?,?,?,?,?,?,?,?,to_date(?,'YYYY/MM/DD'),?,?,?)";
      
			
			psmt = conn.prepareStatement(sql2);
			psmt.setInt(1, maxcid);
			psmt.setString(2, c_name);
			psmt.setString(3, c_local);
			psmt.setString(4, grade);
			psmt.setString(5, people1);
			psmt.setString(6, people2);
			psmt.setString(7, people3);
			psmt.setString(8, people4);
			psmt.setString(9, empolyee);
			psmt.setString(10, agrr_date);
			psmt.setString(11, agr_cost);
			psmt.setString(12, checkup_amt);
			psmt.setString(13, sa_won);

			psmt.executeUpdate();

			psmt.close();

		} catch (SQLException e) {

			e.printStackTrace();

		} finally {

			connectionPool.releaseConnection(conn);
		}

	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

}
