 var actionTest = angular.module('actionTest', []);
  
      actionTest.controller('actionTestCtrl',function ($scope, $http){

    	  $scope.requestView=true;
    	  $scope.formData={};
          $scope.processForm=function(){
          console.log($.param($scope.formData));
          
        	  $http({
        		  method  : 'POST',
        		  url     : 'https://mcbiz.mycheckup.co.kr/smartchk/select_report_result_recent.jsp',
        		  data    : $.param($scope.formData), 
        		  headers : { 'Content-Type': 'application/x-www-form-urlencoded' }  
        		 })
        		  .success(function(data) {
        			 $scope.requestView=false;
        			  console.log(data);

        		    if (!data.success) {
        		      // if not successful, bind errors to error variables
        		      $scope.errorName = data.errors.name;
        		      $scope.errorSuperhero = data.errors.superheroAlias;
        		    } else {
        		      // if successful, bind success message to message
        		      $scope.message = data.message;
        		    }
        		  });
        		};

          
        	

      });
