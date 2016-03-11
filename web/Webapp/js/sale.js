
      var countryApp = angular.module('countryApp', ['ngAnimate','ui.bootstrap','angularUtils.directives.dirPagination']);
  
      countryApp.controller('CountryCtrl',function ($scope, $http, $uibModal,$window){
        
        $http.post("/web/customerData").success(function(data) {
         
         // console.log(data);
          $scope.customers = data;
          $scope.sortField="GRADE";
          $scope.reverse=false;
          });
          
          $scope.sort = function(keyname){
          $scope.sortField = keyname;   //set the sortKey to the param passed
          $scope.reverse = !$scope.reverse; //if true make it false and vice versa
         
          }
         
         
         
            
         //Modal Open 작업 
           $scope.animationsEnabled = true;

      
          
          $scope.openLog=function(customer,size){
            //console.log(customer);
                    var modalInstance = $uibModal.open({
                       animation: $scope.animationsEnabled,
                       templateUrl: 'modalSaleLog.html',
                       controller: 'modalSaleLogCtrl',
                       size: size,
                       resolve: {
                         items: function () {
                           return customer;
                         }
                       }
                     }); //End of ModalInstance

           }; //End of open
          

           $scope.open = function (customer,size) {

                     var modalInstance = $uibModal.open({
                       animation: $scope.animationsEnabled,
                       templateUrl: 'modalHospitalInfo.html',
                       controller: 'ModalInstanceCtrl',
                       size: size,
                       resolve: {
                         items: function () {
                           return customer;
                         }
                       }
                     }); //End of ModalInstance

           }; //End of open

          }); //End of Controller

         // Please note that $modalInstance represents a modal window (instance) dependency.
         // It is not the same as the $uibModal service used above.

         angular.module('countryApp').controller('ModalInstanceCtrl', function ($scope,$http,$window,$uibModalInstance,items) {

           if(angular.isObject(items)){
            
            var myData= new Object();
             myData.CID = items.CID;
             myData.C_NAME = items.C_NAME;
             myData.C_LOCAL= items.C_LOCAL;
             myData.GRADE = items.GRADE;    
             myData.PEOPLE1 = items.PEOPLE1; 
             myData.PEOPLE2 = items.PEOPLE2;  
             myData.PEOPLE3= items.PEOPLE3;  
             myData.PEOPLE4= items.PEOPLE4; 
             myData.EMPOLYEE= items.EMPOLYEE;
             myData.AGRR_DATE= items.AGRR_DATE;
             myData.AGR_COST= items.AGR_COST;
             myData.CHECKUP_AMT= items.CHECKUP_AMT;
             myData.SA_WON= items.SA_WON;  
             myData.CONDITION= items.CONDITION;  
             myData.Jobtype="Update";
             
             $scope.myData=myData;
         
          }else{

                var myData= new Object();
                     myData.CID = "";
                     myData.C_NAME =items; 
                     myData.C_LOCAL= "";
                     myData.GRADE = "";
                     myData.PEOPLE1 = "";
                     myData.PEOPLE2 = "";
                     myData.PEOPLE3= "";
                     myData.PEOPLE4="";
                     myData.EMPOLYEE=""; 
                     myData.AGRR_DATE=""; 
                     myData.AGR_COST="";
                     myData.CHECKUP_AMT="";
                     myData.SA_WON= "";
                     myData.Jobtype="Save";
                     
                     $scope.myData=myData;
         
          };

           $scope.ok = function (item) {
             $uibModalInstance.close();
             
           };


           $scope.dataSave = function(myData) {
              // console.log("upDate:"+myData);
              console.log("$param:"+$.param(myData));
                if(myData.Jobtype=="Update"){
                 var request=$http({
                          method  : 'POST',
                          url     : '/web/customerUpdate',
                          data    : $.param(myData),  // pass in data as strings
                          headers : { 'Content-Type': 'application/x-www-form-urlencoded' }  // set the headers so angular passing info as form data (not request payload)
                      });
                      request.success(function(data) {
                              console.log(data);
                              $uibModalInstance.close();
                              $scope.Reload();
                              //console.log("reload");
                      });
               
                }else{
                console.log("Data insert")
                var request=$http({
                         method  : 'POST',
                         url     : '/web/myDataSave',
                         data    : $.param(myData),  // pass in data as strings
                         headers : { 'Content-Type': 'application/x-www-form-urlencoded' }  
                     });
                     request.success(function(data) {
                             console.log(data);
                              $uibModalInstance.close();
                              $scope.Reload();
                              //console.log("reload");
                     });
                }
               
              };
              

           $scope.delData = function(myData) {
                        console.log(myData);
                           var request=$http({
                                    method  : 'POST',
                                    url     : '/web/customerDelete',
                                    data    : $.param(myData),  // pass in data as strings
                                    headers : { 'Content-Type': 'application/x-www-form-urlencoded' }  // set the headers so angular passing info as form data (not request payload)
                                });
                                request.success(function(data) {
                                        //console.log(data);
                                      $uibModalInstance.close();
                                       
                                        $scope.Reload();
                                       
                                });
                        };  
           $scope.cancel = function () {
             $uibModalInstance.dismiss('cancel');
           };

                              
            $scope.Reload=function(){
              $window.location.reload();
           };

         }); //End of modal controller
         


        //Second Modal Controller 
        angular.module('countryApp').controller('modalSaleLogCtrl', function ($scope,$http,$window,$uibModalInstance,items) {
          
          $scope.c_name=items.C_NAME;
          //$scope.cid=items.CID;
          $scope.logData = new Object();
          $scope.logData.CID=items.CID;

  

           var request=$http({
                    method  : "POST",
                    url     : "/web/customerLogData",
                    data    : $.param(items),  // pass in data as strings
                    headers : { 'Content-Type': 'application/x-www-form-urlencoded' }  // set the headers so angular passing info as form data (not request payload)
                });
                request.success(function(data) {
                       
                	    console.log(data);
                        $scope.cuslogs = data;
                        //$uibModalInstance.close();
                        //$scope.Reload();
                        //console.log("reload");
                });


              $scope.logSave = function(data) {
                   console.log("logsave");
                   console.log(data);
                    var request=$http({
                             method  : 'POST',
                             url     : '/web/LogSave',
                             data    : $.param(data),  // pass in data as strings
                             headers : { 'Content-Type': 'application/x-www-form-urlencoded' }  // set the headers so angular passing info as form data (not request payload)
                         });
                         request.success(function(data) {
                                 //console.log(data);
                                 $scope.Reload();

                         });
                 };

           $scope.cancel = function () {
             $uibModalInstance.dismiss('cancel');
           };

            $scope.Reload=function(){
              $window.location.reload();
           };

         });
         //End of Second Modal

          
    
    