package com.mycheckup;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Vector;

class ConnectionInfo{

	public Connection connection=null;
	public long time =0;
	
	public ConnectionInfo(Connection connection,long time){
		this.connection =connection;
		this.time=time;
	}
}

public class ConnectionPool {

	private static int MAX_CONNECTION=5;
	private Vector buffer = new Vector();
	private int wait_count = 0;
	private static ConnectionPool connectionPool =new ConnectionPool();
	
    //static initalized
	static{
		
		try{
			initConnectionPool();
			
		}catch(SQLException e){
			
			System.out.println("---Connection Create Error--");
			e.printStackTrace();
			
		}catch(ClassNotFoundException e2){
			System.out.println("--Driver Class Not Founder Error--");
			e2.printStackTrace();
		}
		
	}
	
	private ConnectionPool(){} //��ü ������ ���ϰ� �ϱ� ����

    
	@SuppressWarnings({ "unchecked", "static-access" })
	public synchronized static void initConnectionPool()throws SQLException,ClassNotFoundException {
		ConnectionPool.getConnectionPool().destoryConnectionPool();
		
		@SuppressWarnings("rawtypes")
		Vector temp = ConnectionPool.getConnectionPool().getConnectionPoolBuffer();
		ConnectionFactory connectionFactory = ConnectionFactory.getDefaultFactory();
		
		for(int i=0; i <MAX_CONNECTION;i++){
		
			Connection connection = connectionFactory.createConnection("oracle");
			temp.addElement(new ConnectionInfo(connection,System.currentTimeMillis()));
			System.out.println("New Connection Created.."+connection);
			
		}
	}

	

	public synchronized static void destoryConnectionPool(){
		
		@SuppressWarnings("rawtypes")
		Vector temp = ConnectionPool.getConnectionPool().getConnectionPoolBuffer();
		int t = temp.size();
		System.out.println("������ ũ���"+t);
		
		for(int i=0;i<t;i++){
			ConnectionInfo connectionInfo = (ConnectionInfo)temp.remove(0);
			if(connectionInfo !=null){
				try{
					connectionInfo.connection.close();
					System.out.println("Connection Closed"+connectionInfo.connection);
					
				}catch(SQLException e){
					e.printStackTrace();
				}
			}
			
		}
				
	}
	
	public static ConnectionPool getConnectionPool() {
		// TODO Auto-generated method stub
		if(connectionPool==null){
			connectionPool= new ConnectionPool();
		}
		
		return connectionPool;
	}
	public Vector getConnectionPoolBuffer() {
		// TODO Auto-generated method stub
		return this.buffer;
	}

	public synchronized Connection getConnection(){
		ConnectionInfo connectionInfo=null;

		if(wait_count> MAX_CONNECTION){
			return null;
		}

		try{
			while(buffer.size()==0){
				wait_count++;
				this.wait();
				wait_count--;
			}

			connectionInfo=(ConnectionInfo)this.buffer.elementAt(0);
			long interval =System.currentTimeMillis()- connectionInfo.time;
			if(interval > 1000*60*30){
				try{
					System.out.println(interval/1000+"�ʸ� ��� Connection Close");
					connectionInfo.connection.close();
				}catch(SQLException e1){
					e1.printStackTrace();
					System.out.println("Connection Closed error");
				}
				ConnectionFactory connectionFactory = ConnectionFactory.getDefaultFactory();
				connectionInfo.connection=connectionFactory.createConnection("oracle");
				System.out.println(new java.util.Date().toString()+"Connection Opened");
			}
		}catch(InterruptedException e2){
			e2.printStackTrace();

		}finally{
			connectionInfo = (ConnectionInfo)this.buffer.remove(0);

		}
		return connectionInfo.connection;
	}
	
	@SuppressWarnings("unchecked")
	public synchronized void releaseConnection(Connection Connection){
		this.buffer.addElement(new ConnectionInfo(Connection,System.currentTimeMillis()));
		this.notifyAll();
	}
	
	
	
	
	
	
}
