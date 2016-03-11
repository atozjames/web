/*
 * 
 *
 */


package com.mycheckup;

import java.security.MessageDigest;

/**
 * @author atozjames
 *
 */
public class Mcfunction {
			
			/**
			 *
			 */
	
			public String splitStr(String mag,String delimiter){
	
			String splitMsg="";
			
			String[] temp;
			
			temp = mag.split(delimiter);
			 /* print substrings */
			  
			 for(int i =0; i < temp.length ; i++)
			    //System.out.println(temp[i]);
				 splitMsg=splitMsg+temp[i];
			
			return splitMsg;
		
				
		}
		
		/**
		 * ���ڿ��� SHA-256 ������� ��ȣȭ
		 * @param txt ��ȣȭ �Ϸ��ϴ� ���ڿ�
		 * @return String
		 * @throws Exception
		 */
		public String getEncSHA256(String txt) throws Exception{
		    StringBuffer sbuf = new StringBuffer();
		     
		    MessageDigest mDigest = MessageDigest.getInstance("SHA-256");
		    mDigest.update(txt.getBytes());
		     
		    byte[] msgStr = mDigest.digest() ;
		     
		    for(int i=0; i < msgStr.length; i++){
		        byte tmpStrByte = msgStr[i];
		        String tmpEncTxt = Integer.toString((tmpStrByte & 0xff) + 0x100, 16).substring(1);
		         
		        sbuf.append(tmpEncTxt) ;
		    }
		     
		    return sbuf.toString();
		}
		
		
		
}
