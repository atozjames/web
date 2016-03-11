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

<html ng-app="countryApp">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>영업현황</title>
  
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





<link
	href="http://netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css"
	rel="stylesheet">

<script src="../bower_components/angular/angular.js"></script>
<script src="../bower_components/angular/angular-animate.js"></script>
<script src="../bower_components/angular-bootstrap/ui-bootstrap.js"></script>
<script src="../bower_components/angular-bootstrap/ui-bootstrap-tpls.js"></script>
<link href="../bower_components/angular-bootstrap/ui-bootstrap-csp.css"
	rel="stylesheet">


<!-- paggenation  -->
   <script src="../bower_components/angularUtils-pagination/dirPagination.js"></script>

<script src="../js/sale.js"></script>
    
  </head>
  <body ng-controller="CountryCtrl">
  
   <div class="container">
    <p><h1>영업현황 </h1> </p>
        <div class="well well-lg">
        <button class="btn btn-primary" type="search">검  색</button> <input ng-model="query" type="text"/>
       
        <div class="btn-group" role="group" style="float:right" >
          <button class="btn btn-info" type="button" ng-click="open(query)">병원추가</button>
          <a href=salelog.jsp><button class="btn btn-warning" type="button" >영업일지</button></a>
        </div>

        </div>
        <div class="table-responsive">
          <table class="table table-bordered">
            <tr>
              <th ng-click="sort('NUM')" style="text-align:center;">번호
              <span class="glyphicon sort-icon" ng-show="sortField=='NUM'" ng-class="{'glyphicon-chevron-up':reverse,'glyphicon-chevron-down':!reverse}"></span></th>
              <th ng-click="sort('C_NAME')" style="text-align:center;">병원명
              <span class="glyphicon sort-icon" ng-show="sortField=='C_NAME'" ng-class="{'glyphicon-chevron-up':reverse,'glyphicon-chevron-down':!reverse}"></span>
             </th>
              <th ng-click="sort('C_LOCAL')" style="text-align:center;">지역
              <span class="glyphicon sort-icon" ng-show="sortField=='C_LOCAL'" ng-class="{'glyphicon-chevron-up':reverse,'glyphicon-chevron-down':!reverse}"></span></th>
              
              <th ng-click="sort('GRADE')" style="text-align:center;">가능성
              <span class="glyphicon sort-icon" ng-show="sortField=='GRADE'" ng-class="{'glyphicon-chevron-up':reverse,'glyphicon-chevron-down':!reverse}"></span></th>
              
              <th style="text-align:center;"> 상세보기</th>
              
              <th style="text-align:center;">영업로그</th>
            </tr>
            <tr dir-paginate="customer in customers | filter:query |orderBy:sortField:reverse|itemsPerPage:10">
              <td style="text-align:center;">{{customer.NUM}}</a></td>
              <td style="text-align:center;">{{customer.C_NAME}}</td>
              <td style="text-align:center;">{{customer.C_LOCAL}} </td>
              <td style="text-align:center;">{{customer.GRADE}}    </td>
              <td style="text-align:center;"><button type="button" class="btn btn-default" ng-click="open(customer)">클릭</button></td>
              <td style="text-align:center;"><button type="button" class="btn btn-default" ng-click="openLog(customer)">클릭</button></td>
            </tr>
          </table>
		  <div class="panel" style="text-align:center;">
		   <dir-pagination-controls
            max-size="10"
            direction-links="true"
            boundary-links="true" >
           </dir-pagination-controls>
		  </div>
        </div>
          
            <script type="text/ng-template" id="modalHospitalInfo.html">
             <div class="modal-header">
              <h4 class="modal-title">{{myData.C_NAME}} 상세 정보 </h3>
             </div>
             <div class="modal-body">
                <div class="table-responsive">
                <table class="table">
                <tr>
                <td>순번</td> <td>병원명</td> <td>지역</td><td>가능성</td>
                </tr>
                <tr>
                <td><input type="text" class="form-control" name='cid' ng-model='myData.CID' disabled/></td>
                <td><input type="text" class="form-control" name='c_name' ng-model='myData.C_NAME' /></td>
                <td><input type="text" class="form-control" name='c_local' ng-model='myData.C_LOCAL' /></td>
                <td><input type="text" class="form-control" name='grade' ng-model='myData.GRADE' /></td>
                </tr>
                <tr>
                <td>센터장</td> <td>팀장</td> <td>담당</td><td>수간호사</td>
                </tr>
                <tr>
                <td><input type="text" class="form-control" name='people1' ng-model='myData.PEOPLE1' /></td>
                <td><input type="text" class="form-control"  name='people2' ng-model='myData.PEOPLE2' /></td>
                <td><input type="text" class="form-control"  name='people3' ng-model='myData.PEOPLE3'/></td>
                <td><input type="text" class="form-control"  name='people4' ng-model='myData.PEOPLE4' /></td>
                </tr>
                <tr>
                <td>계약일</td> <td>계약금액</td> <td>월검진수</td><td>영업담당</td>
                </tr>
                <tr>
                <td><input type="text" class="form-control"  name='agrr_date' ng-model='myData.AGRR_DATE' /></td>
                <td><input type="text" class="form-control"  name='agr_cost' ng-model='myData.AGR_COST' /></td>
                <td><input type="text" class="form-control"  name='checkup_amt' ng-model='myData.CHECKUP_AMT'/></td>
                <td><input type="text" class="form-control"   name='sa_won' ng-model='myData.SA_WON'  /></td>
                </tr>
                <!--
                <tr>
                <td>계약조건</td><td rowspan="3" width="100%"><input type="text" class="form-control"  name='condition' ng-model='myData.CONDITION' /></td>
                
                </tr>
                -->
                </table>
               </div>

               <div class="modal-footer">
                  <div style="text-align: center;">
                    <button type="submit" class="btn btn-default" ng-click="dataSave(myData)">{{myData.Jobtype}}</button>
                    <button type="submit" class="btn btn-default" ng-click="delData(myData)">삭제</button>
                    <button class="btn btn-warning" type="button" ng-click="cancel()">닫기</button>
                  </div>
                </div>
              </script>

              <script type="text/ng-template" id="modalSaleLog.html">
                 <div class="modal-header">
                               <h4 class="modal-title">{{c_name}}  영업 로그</h4>
                 </div>
                
                <div class="modal-body">
                  <div class="table-responsive">
                    <table class="table">
                     <tr> <th>순번</th><th>업무기록</th><th>기록일</th></tr>
                      <tr ng-repeat="cuslog in cuslogs">
                       <td width="10%">{{cuslog.NUM}} </td>
                       <td width="70%">{{cuslog.LOG}}</td>
                       <td width="20%">{{cuslog.REG_DATE}} </td>
                       
                     </tr>
                   </table>
                 </div>

                <div class="well">
                  <form class="" role="form">
                    <div class="form-group">
                      <label for="log">업무로그</label>
                      <textarea class="form-control" rows="3" name="CLOG"  ng-model="logData.LOG"></textarea>
                    
                    </div>
                  </form>
                </div>
              
              <div class="modal-footer">
               <button type="submit" class="btn btn-default" ng-click="logSave(logData)">저장</button>
              <button class="btn btn-warning" type="button" ng-click="cancel()">닫기</button>
              </div> 
              </script>
  
    </div>
  
  </body>
</html>