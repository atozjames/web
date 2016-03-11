/**
 * 
 */

var myApp = angular.module('myApp',[]);

myApp.controller('CategoryList', function($http,$scope) {
	
	$scope.qForm=true;
	$scope.result=false;
	
	
	 $scope.CategoryRetrive=function(){
	/*
	  console.log("function called");
	  console.log($scope.phone_number);
	  console.log($scope.birth_date);
	 */
	  
	  var data={'phone_number':$scope.phone_number,'birth_date':$scope.birth_date};
      
	  var request=$http({
               method  : 'POST',
               url     : 'download_h_category.jsp',
               data   : $.param(data),  // pass in data as strings
               headers : { 'Content-Type': 'application/x-www-form-urlencoded' }  
           });
           request.success(function(data) {
                   console.log(data);
                   if(data.result!=-1){
                	    $scope.qForm=false;
                		$scope.result=true;
                   }else{
                	   alert("조회 결과가 없습니다.");
                   }
           });
          
         
     }
	
	 
	
	
});

