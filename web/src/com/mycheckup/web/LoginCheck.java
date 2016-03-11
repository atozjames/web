package com.mycheckup.web;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;

import controller.Users;

/**
 * Servlet implementation class LoginCheck
 */
@WebServlet(description = "아이디 비번 검사 후 세션에 저장", urlPatterns = { "/LoginCheck" })

public class LoginCheck extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		JSONObject obj = new JSONObject();

		String id = request.getParameter("email");
		String passwd = request.getParameter("password");
		String type = request.getParameter("type");

		 System.out.println("id:"+id+"/passwd:"+passwd+"/type:"+type);

		HttpSession session = request.getSession();

		if (type.equals("db")) {

			// userDBCheck구현

			obj = Users.userDbCheck(id, passwd);

			if ((boolean) obj.get("result")) {

				session.setAttribute("id", "id");
			}
			

		} else {

			if (Users.userCheck(id, passwd)) {
				obj.put("result", true);
				obj.put("email", id);
				
				session.setAttribute("id", "id");
			} else {
				obj.put("result", false);
				obj.put("email", "");
			}

		}

		response.setContentType("application/x-json; charset=UTF-8");
		PrintWriter out = response.getWriter();
		out.println(obj);
		out.flush();

	}

}
