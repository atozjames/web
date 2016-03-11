package controller;

import com.mycheckup.Mcfunction;

public class Ipcheck {

	private static String AuthIP = "1101123895";
	//private static String AuthIP = "192168035";
	
	private static String remoteIP = null;

	public static boolean ipCheck(String rIP) {

		String delimiter = "\\.";
		Mcfunction mcFunction = new Mcfunction();

		remoteIP = mcFunction.splitStr(rIP, delimiter);

		if (AuthIP.equals(remoteIP)) {

			
			return true;
			
		} else {
			
			return false;
		}
	}
}
