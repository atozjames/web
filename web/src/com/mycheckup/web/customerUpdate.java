package com.mycheckup.web;

import java.io.*;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.mycheckup.ConnectionPool;



@WebServlet("/customerUpdate")
public class customerUpdate extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	private static ConnectionPool connectionPool=null;
	private static Connection conn = null;
	PreparedStatement psmt=null;

	 static Logger logger2 = Logger.getLogger("process.work2");
	

    public customerUpdate() {
        super();
      
        connectionPool =ConnectionPool.getConnectionPool();
        
    }

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		 request.setCharacterEncoding("UTF-8");
    
		 String cid = request.getParameter("CID");
		 String c_name 	=request.getParameter("C_NAME");
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
	   
	     System.out.println("CNAME:"+c_name);
	     
	     String sql="UPDATE customer SET C_NAME=? ,C_LOCAL=? ,GRADE=? ,PEOPLE1=? ,PEOPLE2 =?,PEOPLE3 =? ,PEOPLE4=?, EMPOLYEE =?, AGRR_DATE =?, AGR_COST =?,";
	     		 sql+="CHECKUP_AMT=?,SA_WON=? WHERE CID=?";
	            
	     
	 	try {
			conn = connectionPool.getConnection();
			psmt=conn.prepareStatement(sql);
			
		
			psmt.setString(1, c_name);
			psmt.setString(2, c_local);
			psmt.setString(3, grade);
			psmt.setString(4, people1);
			psmt.setString(5, people2);
			psmt.setString(6, people3);
			psmt.setString(7, people4);
			psmt.setString(8, empolyee);
			psmt.setString(9, agrr_date);
			psmt.setString(10, agr_cost);
			psmt.setString(11, checkup_amt);
			psmt.setString(12, sa_won);
			psmt.setString(13, cid);
			
			psmt.executeUpdate();
			
			psmt.close();
			
		} catch (SQLException e) {
			
			e.printStackTrace();
		
		}finally{
			
			connectionPool.releaseConnection(conn);
		}

	
	 	response.setContentType("text/htnl; charset=UTF-8"); 
		
		PrintWriter out = response.getWriter();
		out.print("sucess");
		out.flush();
	
	}

}
