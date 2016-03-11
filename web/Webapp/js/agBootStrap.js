var myApp = angular.module("myApp",[]);

myApp.controller("simpleCtrl", function($scope,$http) {

	 
    $http.get("../jsp/customer_data.jsp").success(function(data) {
      //alert("성공");
      
      $scope.customers = data;
      $scope.title="My Angular OK";
      console.log($scope.customers);
      });
     
	
});