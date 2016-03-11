/**
 * 
 */
package com.mycheckup;

import java.sql.*;

/**
 * @author wBom
 *
 */
public class ConnectionFactory {
	
	
	private static ConnectionFactory connectionFactory = new ConnectionFactory();
	
	private ConnectionFactory(){}; //인스턴스 생성을 막기 위한 조치
	
	public static ConnectionFactory getDefaultFactory(){
		
		if(connectionFactory ==null){
			
			connectionFactory= new ConnectionFactory();
		}
		
		return connectionFactory;
	}
	
	public Connection createConnection(String dbType) {
		Connection connection = null;
		if (dbType.equals("mysql")){

			try {

				Class.forName("com.mysql.jdbc.Driver");

			} catch (ClassNotFoundException cnfe) {

				System.out.println(cnfe);

			}

			String url = "jdbc:mysql://www.youscan.co.kr:3306/konavi";
			String user = "konavi";
			String password = "konavi";

			try {
				connection = DriverManager.getConnection(url, user, password);

			} catch (SQLException sqle) {

				System.out.println(sqle);
			}
			
		}else if(dbType.equals("oracle")){
			
			try {

				Class.forName("core.log.jdbc.driver.OracleDriver"); // real시 변경:oracle.jdbc.driver.OracleDriver

			} catch (ClassNotFoundException cnfe) {

				System.out.println(cnfe);

			}

			String url = "jdbc:oracle:thin:@mcbiz.mycheckup.co.kr:1521:orcl";
			String user="cybercvs";
			String password="info9077";

			try {
				connection = DriverManager.getConnection(url, user, password);

			} catch (SQLException sqle) {

				System.out.println(sqle);
			}
		}else {
			System.out.println("DB type을 입력하세요");
		}

		return connection;
	}

	
}
