<%@ page import="org.apache.log4j.Logger" %>
<%
   Logger logger     = null ;
   
   try {
       logger     = Logger.getLogger( "process.work2" );   
   }
   catch ( Exception e ) {
       logger.debug( e.getMessage() ) ;
   }
%>
