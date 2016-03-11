package controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.json.simple.JSONObject;

import com.mycheckup.ConnectionPool;

public class Users {

	final static private String ID = "cybercvs";
	final static private String Passwd = "info9077";

	public static boolean userCheck(String id, String passwd) {

		if (ID.equals(id) && Passwd.equals(passwd)) {

			System.out.println("인증성공");
			return true;

		} else {

			System.out.println("인증실패");

			return false;
		}

	}

	public static JSONObject userDbCheck(String id, String Passwd) {

		ConnectionPool connectionPool = ConnectionPool.getConnectionPool();

		Connection conn = connectionPool.getConnection();
		JSONObject obj = new JSONObject();

		String sql = "select org_cd, login_id,h_name from G_HOSPITAL where login_id=? and password=?";

		try {
			PreparedStatement pstm = conn.prepareStatement(sql);

			pstm.setString(1, id);
			pstm.setString(2, Passwd);

			ResultSet rs = pstm.executeQuery();

			while (rs.next()) {
				
				obj.put("result", true);
				obj.put("org_cd", rs.getString("org_cd"));
				obj.put("login_id", rs.getString("login_id"));
				obj.put("h_name", rs.getString("h_name"));
			}

		} catch (SQLException e) {
			
			e.printStackTrace();
			obj.put("result", false);

		} finally {
			connectionPool.releaseConnection(conn);
		}
		return obj;
	}

}
