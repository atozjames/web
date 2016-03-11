<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="com.mycheckup.*"%>
<%@ page import="controller.*"%>

<%

String id = (String)session.getAttribute("id");

if(id==null||id.equals("")){                  
response.sendRedirect("index.html");    
}

//request.getHeaderNames();
String remoteIP=request.getRemoteAddr(); 
//out.print(remoteIP);

//String remoteIP="192.168.0.35";
if(!Ipcheck.ipCheck(remoteIP)){
response.sendRedirect("../error.html");
}

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<html ng-app="countryApp">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>영업정보 </title>
  
   <!-- JQuery -->
<script type="text/javascript"
	src="../bower_components/jquery/dist/jquery.min.js"></script>
  
 <!-- Latest compiled and minified CSS -->
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"
	integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7"
	crossorigin="anonymous">

<!-- Optional theme -->
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css"
	integrity="sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r"
	crossorigin="anonymous">

<!-- Latest compiled and minified JavaScript -->
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"
	integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS"
	crossorigin="anonymous"></script>
	
   
    <!-- Optional theme -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap-theme.min.css">
    <link href="http://netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css" rel="stylesheet">
    
 <link
	href="http://netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css"
	rel="stylesheet">

<script src="../bower_components/angular/angular.min.js"></script>
<script src="../bower_components/angular/angular-animate.js"></script>
<script src="../bower_components/angular-bootstrap/ui-bootstrap.js"></script>
<script src="../bower_components/angular-bootstrap/ui-bootstrap-tpls.js"></script>
<link href="../bower_components/angular-bootstrap/ui-bootstrap-csp.css"
	rel="stylesheet">
  
	
	<!-- paggenation  -->
   <script src="../js/dirPagination.js"></script>
   <script src="../js/log.js"></script>
	
    
  </head>
<body ng-controller="CountryCtrl">
  
  <div class="container">
    <p><h1>영업 일지 </h1> </p>
        <div class="well well-lg">
        <button class="btn btn-primary" type="button">검  색</button> <input ng-model="query" type="text"/>
        <div class="btn-group" role="group" style="float:right" >
          <button class="btn btn-info" type="button" ng-click="logOpen(query)">일지작성</button>
          <a href=sales.jsp><button class="btn btn-warning" type="button" >병원정보</button></a>
        </div>

        </div>

        <div class="table-responsive">
          <table class="table table-bordered">
            <tr>
              <th width="20%" ng-click="sort('C_NAME')" style="text-align:center;">병원명
              <span class="glyphicon sort-icon" ng-show="sortField=='C_NAME'" ng-class="{'glyphicon-chevron-up':reverse,'glyphicon-chevron-down':!reverse}"></span>
             </th>
              <th withd="60%" style="text-align:center;">내용</th>
              <th withd="20%" ng-click="sort('REG_DATE')" style="text-align:center;">등록일
              <span class="glyphicon sort-icon" ng-show="sortField=='REG_DATE'" ng-class="{'glyphicon-chevron-up':reverse,'glyphicon-chevron-down':!reverse}"></span></th>
            </tr>
            <tr dir-paginate="log in logs | filter:query |orderBy:sortField:reverse|itemsPerPage:10">
              <td>{{log.C_NAME}}</a></td>
              <td>{{log.LOG}}</td>
              <td style="text-align:center;">{{log.REG_DATE}} </td>
              <td ng-show="false">
              </td>
            </tr>
          </table>
		    </div>
        <div class="panel" style="text-align:center;">
		       <dir-pagination-controls
            max-size="10"
            direction-links="true"
            boundary-links="true" >
           </dir-pagination-controls>
		   </div>
  </div>
          
           
            <script type="text/ng-template" id="modalLogInfo.html">
             
             <div class="modal-header">
              <h4 class="modal-title">{{memo.C_NAME}}</h4>
             </div>
             
             <div class="modal-body">
                <div class="well">
                  <form class="" role="form">
                    <div class="form-group">
                      <label for="log">업무로그</label>
                      <textarea class="form-control" rows="3" name="CLOG"  ng-model="memo.LOG"></textarea>
                    </div>
                  </form>
                </div>
             </div>
             
              <div class="modal-footer">
              <button type="submit" class="btn btn-default" ng-click="logSave(memo)">저장</button>
              <button class="btn btn-warning" type="button" ng-click="cancel()">닫기</button>
              </div> 
            </script>

  
  </body>
</html>