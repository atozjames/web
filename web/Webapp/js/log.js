
      var countryApp = angular.module('countryApp', ['ngAnimate','ui.bootstrap','angularUtils.directives.dirPagination']);
  
      countryApp.controller('CountryCtrl',function ($scope, $http, $uibModal,$window){
        
        $http.post('/web/customLogData').success(function(data) {
          $scope.logs = data;
          $scope.sortField="REG_DATE";
          $scope.reverse=true;
          });
          
          $scope.sort = function(keyname){
          $scope.sortField = keyname;   //set the sortKey to the param passed
          $scope.reverse = !$scope.reverse; //if true make it false and vice versa
         }
        
          $scope.logOpen=function(query){
          'console.log(query)';
          
          if(query==undefined){

            //console.log("hi");
            alert("병원이를을 먼저 검색하세요 ");
          
          }else{

           var request=$http({
                    method  : 'POST',
                    url     : '/web/SearchCID',
                    data    :$.param({ C_NAME : query }),  // pass in data as strings
                    headers : { 'Content-Type': 'application/x-www-form-urlencoded' }  
                });
                request.success(function(data) {
                       
                     //   console.log(data);
                       
                        if(data.result=="false"){
                         
                         alert("등록된 병원이 업습니다.\n병원이를을 정확하게 검색하세요 ");
                        
                        }else{
                        
                        rdata=data.result[0];
                        
                        //console.log(rdata);
                        	
                        $scope.open(rdata);  
                        
                        }
                
                });

          }

         } //Eno of Logopen

           $scope.open = function (data,size) {

                     var modalInstance = $uibModal.open({
                       animation: $scope.animationsEnabled,
                       templateUrl: 'modalLogInfo.html',
                       controller: 'ModalInstanceCtrl',
                       size: size,
                       resolve: {
                         items: function () {
                           return data;
                         }
                       }
                     }); //End of ModalInstance

           }; //End of open

        

          }); //End of Controller

         // // Please note that $modalInstance represents a modal window (instance) dependency.
         // // It is not the same as the $uibModal service used above.

         angular.module('countryApp').controller('ModalInstanceCtrl', function ($scope,$http,$window,$uibModalInstance,items) {
           
            $scope.memo=items;

            $scope.logSave = function(data) {
                 //console.log("logsave");
                 //console.log(data);
                  var request=$http({
                           method  : 'POST',
                           url     : '/web/LogSave',
                           data    : $.param(data),  // pass in data as strings
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
         

