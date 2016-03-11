<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="com.mycheckup.*"%>
<%@ page import="controller.*"%>

<%

//request.getHeaderNames();
String remoteIP=request.getRemoteAddr(); 
//out.print(remoteIP);

//String remoteIP="192.168.0.35";
if(!Ipcheck.ipCheck(remoteIP)){
response.sendRedirect("../error.html");
}

%>


<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <meta name="description" content="">
    <meta name="author" content="">
   

    <title>My CheckUP service Admin</title>

    <!-- Bootstrap core CSS -->
    <link href="../bower_components/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="../css/signin.css" rel="stylesheet">

    <!--JQuery js -->
    <script src="../bower_components/jquery/dist/jquery.min.js"></script>
     <script src="../js/jquery.ui.shake.js"></script>
    <script src="../js/jquery.dropotron.min.js"></script>
    <script src="../bower_components/bootstrap/dist/js/bootstrap.min.js"></script>
    
        <script>
            $(document).ready(function(){
                $('button').click(function(){
                var email=$("#inputEmail").val();
                var password=$("#inputPassword").val();
                var dataString = 'email='+email+'&password='+password;

                 if($.trim(email).length>0 && $.trim(password).length>0)
                  {
                     $.ajax({
                            type: "POST",
                            url: "/web/LoginCheck",
                            data: dataString,
                            cache: false,
                            //beforeSend: function(){ $("#login").val('Connecting...');},
                            dataType: "json",
                            async: true,
                            success: resultProcess,
                            
                            error: function(request,status,error){
                                    alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
                                         }
                            
                            }); //End of ajax
                             function resultProcess(data){
                                             var result=data['result'];  //data는 json객체
                                              if(result==true)
                                              {   
                                             
                                              $(location).attr('href','sales.jsp');
                                              
                                              console.log(data);
                                              }
                                               else
                                              {
                                         
                                              $('#box').shake();
                                        
                                              $("#error").html("<div class='panel-body'><h4>아이디와 비번이 틀립니다.</h4></div>");
                                          
                                              var allReset=function(){
                                                $("#LoginForm").each(function() {  
                                                  this.reset();  
                                                });

                                                $("#error").hide()
                                                }
                                                setTimeout(allReset, 1000);
                                                }
                                 }  //End of Callback Fuction           
            
                    }
                  return false;
                  }); //End of button
            
                    //섹션 저장   
                             if(localStorage.chkbx && localStorage.chkbx != '') {
                                   $('#remember_me').attr('checked', 'checked');
                                   $('#inputEmail').val(localStorage.usrname);
                                   $('#inputPassword').val(localStorage.pass);
                               }else{
                                   $('#inputEmail').removeAttr('checked');
                                   $('#inputEmail').val('');
                                   $('#inputPassword').val('');
                              }
                  
              
                              $('#remember_me').click(function(){
                                 if ($('#remember_me').is(':checked')) {
                                     // save username and password
                                     console.log("Remember me checked")
                                     localStorage.usrname = $('#inputEmail').val();
                                     localStorage.pass = $('#inputPassword').val();
                                     localStorage.chkbx = $('#remember_me').val();
                                     console.log(localStorage.chkbx);
                                  }else{
                                     localStorage.usrname = '';
                                     localStorage.pass = '';
                                     localStorage.chkbx = '';
                                  }
                               });
                

            });
        
        </script>



    </head>

  <body>
  <div id="main">
    <div id="box" class="container">
    <form id="LoginForm" class="form-signin" method="post" action="">
        <h2 class="form-signin-heading">MyCheckUP Admin</h2>
        <label for="inputEmail" class="sr-only">Email address</label>
        <input type="email" name="email" id="inputEmail" class="form-control" placeholder="Email address" required autofocus>
        <label for="inputPassword" class="sr-only">Password</label>
        <input type="password" name="password" id="inputPassword" class="form-control" placeholder="Password" required>
        <div class="checkbox">
          <label>
            <input type="checkbox" id="remember_me">Remember me
          </label>
        </div>
        <button class="btn btn-lg btn-primary btn-block" type="submit" id="login">Sign in</button>
        <div class="panel panel-default" id="error">
         </div>  
      </form>
     
    </div> <!-- /container -->

    

</div> <!--/main -->



    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <!-- <script src="../../assets/js/ie10-viewport-bug-workaround.js"></script> -->
  </body>
</html>
