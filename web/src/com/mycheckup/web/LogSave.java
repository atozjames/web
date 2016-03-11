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


@WebServlet("/LogSave")
public class LogSave extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private ConnectionPool connectionPool = null;
	private Connection conn = null;
	private Statement smtp = null;
	private PreparedStatement psmt = null;
	private ResultSet rs = null;
	
    public LogSave() {
        super();
        connectionPool = ConnectionPool.getConnectionPool();
    }


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		request.setCharacterEncoding("UTF-8");
		
		int cid = Integer.parseInt(request.getParameter("CID"));
		String log =request.getParameter("LOG");
		
		int num=0;
		
		try{
			conn = connectionPool.getConnection();
			
			String sql1="select max(mid) from custom_log";
			
			smtp =conn.createStatement();
			
			rs = smtp.executeQuery(sql1);
			
			while(rs.next()){
				num=rs.getInt(1);
				num=num+1;
			}

			rs.close();
		    smtp.close();
			
			String sql2="insert into custom_log(mid,cid,log)VALUES(?,?,?)";
			
			psmt=conn.prepareStatement(sql2);
			
			psmt.setInt(1, num);
			psmt.setInt(2, cid);
			psmt.setString(3, log);
			
			psmt.executeUpdate();
			
			psmt.close();
			
		}catch(SQLException e){
			
			e.printStackTrace();
			
		}finally {
			
		connectionPool.releaseConnection(conn);
		}
	
	
	
	}

}
