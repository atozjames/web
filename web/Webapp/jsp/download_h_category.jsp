<%@ page language="java" contentType="text/html; charset=euc-kr"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.sql.*,javax.sql.*,java.io.*,java.util.*,java.text.*,java.lang.*,javax.naming.*"%>
<%@ page import="org.json.simple.*"%>
<%@ include file="logger.jsp"%>

<%!// parameter
	final static String PARAM_IN_BIRTH_DATE = "birth_date";
	final static String PARAM_IN_TEL_NUMBER = "phone_number";
	final static String PARAM_IN_REG_NUMBER = "identifier";

	final static String PARAM_OUT_RESULT = "result";
	final static String PARAM_OUT_RESULT_REASON = "result_reason";

	final static String PARAM_OUT_REPORT = "report";
	final static String PARAM_OUT_REPORT_IDENTIFIER = "report_identifier";
	final static String PARAM_OUT_CATEGORY_LARGE = "report_category_large";
	final static String PARAM_OUT_CATEGORY_MEDIUM = "report_category_medium";
	final static String PARAM_OUT_CATEGORY_SMALL = "report_category_small";
	final static String PARAM_OUT_MEASURE = "report_measure";
	final static String PARAM_OUT_MEASURE_OLD = "report_measure_old";
	final static String PARAM_OUT_QUANTITY = "report_quantity";
	final static String PARAM_OUT_REFERENCE_MIN = "report_reference_min";
	final static String PARAM_OUT_REFERENCE_MAX = "report_reference_max";
	final static String PARAM_OUT_REFERENCE = "report_reference";
	final static String PARAM_OUT_IMAGE_URL = "report_image_url";
	final static String PARAM_OUT_RESULT_DECISION = "report_result_decision";
	final static String PARAM_OUT_LEVEL_CD = "report_level_cd";

	final static int RESULT_LOGIC_ERROR = -1;
	final static int RESULT_PARAM_ERROR = -1;
	final static int RESULT_NOT_EXIST = 0;
	final static int RESULT_SUCCESS = 1;

	// length of params
	final static int LENGTH_BIRTH_DATE = 8;
	final static int LENGTH_TEL_NUMBER = 10;
	final static int LENGTH_REG_NUMBER = 8;%>

<%
	//http://localhost:8080/web/download_h_category.jsp?birth_date=19920618&phone_number=01029317559
    
    request.setCharacterEncoding("UTF-8");

    // getting paramters
    
    String strBirthDate = request.getParameter(PARAM_IN_BIRTH_DATE);
    String strTelNumber = request.getParameter(PARAM_IN_TEL_NUMBER);
    
    //out.print("strBirthDate:"+strBirthDate+"<br>");
    //out.print("strTelNumber:"+strTelNumber+"<br>");
    
    
    //String strRegNumber = request.getParameter(PARAM_IN_REG_NUMBER);

    Statement       stmt        = null;
    ResultSet       rs          = null;
    ResultSet       rs_report   = null;
    ResultSet       rs_reccnt   = null;
    Connection      conn    = null;
    String          sql     = "";
    String          Select  = "";
    String          report_date     = "";
    String          hospital_code   = "";
    
    String			strRegNumber 	= "";
 

    String          category_large  = "";
    String          category_medium = "";
    String          category_small  = "";
    String          measure         = "";
    String          measure_old     = "";
    String          quantity        = "";
    String          reference_min   = "";
    String          reference_max   = "";
    String          reference_val   = "";
    String          image_url       = "";
    String          result_decision = "";
    String          level_cd        = "";

    int             result_cnt      = 0;
    int             report_identifier = 0;


    Context     init_ctx    = new InitialContext();
    Context     env_ctx     = (Context)init_ctx.lookup("java:/comp/env");
    DataSource  ds          = (DataSource)env_ctx.lookup("jdbc/VIBA");

    StringBuffer buf_OUTPUT_00    = new StringBuffer("");
    StringBuffer buf_OUTPUT_01    = new StringBuffer("");
    StringBuffer buf_OUTPUT_02    = new StringBuffer("");
    StringBuffer buf_OUTPUT_03    = new StringBuffer("");
    StringBuffer buf_OUTPUT_04    = new StringBuffer("");

    JSONObject jsonObject      = new JSONObject();
    JSONArray  jsonArrayReport = new JSONArray();
    JSONArray  jsonArrayCategory = new JSONArray();


    if (strBirthDate == null)
    {
        jsonObject.put(PARAM_OUT_RESULT, RESULT_PARAM_ERROR);
        jsonObject.put(PARAM_OUT_RESULT_REASON, "입력 파라미터가 맞지 않습니다.");
        logger.info( " download_result ERROR![parameter null] strBirthDate [" + strBirthDate + "]  ");

        out.println(jsonObject);
        out.flush();

        return;
    }


    if (strBirthDate.length() > LENGTH_BIRTH_DATE)
    {
        jsonObject.put(PARAM_OUT_RESULT, RESULT_PARAM_ERROR);
        jsonObject.put(PARAM_OUT_RESULT_REASON, "입력 파라미터 길이가 맞지 않습니다.");
        logger.info( " download_result ERROR![parameter length] strBirthDate [" + strBirthDate + "]  ");

        out.println(jsonObject);
        out.flush();

        return;
    }

    if (strTelNumber == null)
    {
        jsonObject.put(PARAM_OUT_RESULT, RESULT_PARAM_ERROR);
        jsonObject.put(PARAM_OUT_RESULT_REASON, "입력 파라미터가 맞지 않습니다.");
        logger.info( " download_result ERROR![parameter null] strTelNumber [" + strTelNumber + "]  ");

        out.println(jsonObject);
        out.flush();

        return;
    }


    if (strTelNumber.length() < LENGTH_TEL_NUMBER)
    {
        jsonObject.put(PARAM_OUT_RESULT, RESULT_PARAM_ERROR);
        jsonObject.put(PARAM_OUT_RESULT_REASON, "입력 파라미터 길이가 맞지 않습니다.");
        logger.info( " download_result ERROR![parameter length] strTelNumber [" + strTelNumber + "]  ");

        out.println(jsonObject);
        out.flush();

        return;
    }



    try
    {
        try
        {
            conn    = ds.getConnection();
        }
        catch (Exception _exception)
        {
            System.out.println(_exception);
            jsonObject.put(PARAM_OUT_RESULT, RESULT_LOGIC_ERROR);
            jsonObject.put(PARAM_OUT_RESULT_REASON, "데이터베이스 접속에 실패하였습니다.");
            logger.info( " download_result ERROR![db conn err] : 데이터베이스 접속에 실패하였습니다  " );

            out.println(jsonObject);
            out.flush();

            return;
        }

        try  //전화 번호 와 생년월일로 reg_no추출
        {
            stmt  = conn.createStatement(rs.TYPE_SCROLL_INSENSITIVE, rs.CONCUR_READ_ONLY);

            logger.info( " Download  patmst Sel key :  tel_no[" + strTelNumber + "] birth_dt[" + strBirthDate + "] ");


            
            buf_OUTPUT_00.append("SELECT MAX(a.reg_no) as reg_no FROM smtc_patmst a, smtc_orgmst b WHERE a.tel_no =");
            buf_OUTPUT_00.append("'"+strTelNumber+"'");
            buf_OUTPUT_00.append("AND a.birth_dt =");
            buf_OUTPUT_00.append("'"+strBirthDate+"'");
            buf_OUTPUT_00.append("AND a.exam_dt = ( SELECT MAX(exam_dt) FROM smtc_patmst WHERE tel_no = a.tel_no AND birth_dt = a.birth_dt AND act_gb = '1' ) AND a.org_cd = b.org_cd AND a.act_gb = '1' GROUP BY b.pri_url ,b.last_udt_dt, a.chk_kind ");

            Select = buf_OUTPUT_00.toString();
            //out.print("sql:"+Select+"<br>");
            rs  = stmt.executeQuery(Select);

            rs.last();
            
            if (rs.getRow() == 0)
            {
                jsonObject.put(PARAM_OUT_RESULT, RESULT_NOT_EXIST);
                jsonObject.put(PARAM_OUT_RESULT_REASON, "환자등록 정보가 없습니다.");
                
                logger.info( " download_result ERROR![patmst sel NFD] : 검진자 정보가 없습니다  " );

                out.println(jsonObject);
                out.flush();
                return;
            }

            strRegNumber = rs.getString("reg_no");
            //out.print("strRegNumer:"+strRegNumber+"<br>");
           
            out.flush();

            rs.close();
        }
        catch (Exception _exception)
        {
            System.out.println(_exception);
            jsonObject.put(PARAM_OUT_RESULT, RESULT_LOGIC_ERROR);
            jsonObject.put(PARAM_OUT_RESULT_REASON, "검진자 정보 조회 실패." + _exception);

            out.println(jsonObject);
            out.flush();
            return;
        }
        
        try //org_cd,report_date 추출
        {
            stmt  = conn.createStatement(rs.TYPE_SCROLL_INSENSITIVE, rs.CONCUR_READ_ONLY);

            logger.info( " Download  patmst Sel key :  reg_no [" + strRegNumber + "] tel_no[" + strTelNumber + "] birth_dt[" + strBirthDate + "] ");

            buf_OUTPUT_01.append("SELECT    a.org_cd  AS org_cd                     ");
            buf_OUTPUT_01.append("         ,b.exam_dt AS report_date                ");
            buf_OUTPUT_01.append("FROM      smtc_orgmst a, smtc_patmst b            ");
            buf_OUTPUT_01.append("WHERE     a.org_cd    =  b.org_cd                 ");
            buf_OUTPUT_01.append("AND       b.reg_no    = '" + strRegNumber + "'    ");
            if (!strBirthDate.equals("20150101"))
            {
            buf_OUTPUT_01.append("AND       b.tel_no    = '" + strTelNumber + "'    ");
            }
            buf_OUTPUT_01.append("AND       b.birth_dt  = '" + strBirthDate + "'    ");
            buf_OUTPUT_01.append("AND       b.act_gb    = '1'                       ");

            Select = buf_OUTPUT_01.toString();
            
            //out.print("sql2:"+Select+"<br>");

            rs  = stmt.executeQuery(Select);
            rs.last();

            if (rs.getRow() == 0)
            {
                jsonObject.put(PARAM_OUT_RESULT, RESULT_NOT_EXIST);
                jsonObject.put(PARAM_OUT_RESULT_REASON, "sql2 검진자 정보가 없습니다.");
                logger.info( " download_result ERROR![patmst sel NFD] : 검진자 정보가 없습니다  " );

                out.println(jsonObject);
                out.flush();
                return;
            }

            report_date     = rs.getString("report_date");
            hospital_code   = rs.getString("org_cd");


            jsonObject.put("report_date", report_date);


            //out.println(jsonObject);
            out.flush();

            rs.close();
        }
        catch (Exception _exception)
        {
            System.out.println(_exception);
            jsonObject.put(PARAM_OUT_RESULT, RESULT_LOGIC_ERROR);
            jsonObject.put(PARAM_OUT_RESULT_REASON, "검진자 정보 조회 실패." + _exception);

            out.println(jsonObject);
            out.flush();
            return;
        }
        

        try
        {
            stmt  = conn.createStatement(rs_report.TYPE_SCROLL_INSENSITIVE, rs_reccnt.CONCUR_READ_ONLY);

            buf_OUTPUT_02.append("SELECT     count(*)       AS result_count         ");
            buf_OUTPUT_02.append("FROM      smtc_examhst                            ");
            buf_OUTPUT_02.append("WHERE     org_cd      = '" + hospital_code + "'   ");
            buf_OUTPUT_02.append("AND       reg_no      = '" + strRegNumber  + "'   ");
            buf_OUTPUT_02.append("AND       act_gb      = '1'                       ");

            Select = "";
            Select = buf_OUTPUT_02.toString();

            rs_reccnt  = stmt.executeQuery(Select);
            rs_reccnt.last();

            if (rs_reccnt.getRow() == 0)
            {
                jsonObject.put(PARAM_OUT_RESULT, RESULT_NOT_EXIST);
                out.println(jsonObject);
                out.flush();
                return;
            }

            result_cnt = rs_reccnt.getInt("result_count");
            //jsonObject.put("result_count"   , result_cnt);
            logger.info( " result record count : (" + result_cnt + ") " );
        }
        catch (Exception _exception)
        {
            System.out.println(_exception);
            jsonObject.put(PARAM_OUT_RESULT, RESULT_LOGIC_ERROR);
            jsonObject.put(PARAM_OUT_RESULT_REASON, "검사결과 건수  조회 실패." + _exception);

            out.println(jsonObject);
            out.flush();
            return;
        }

        try { //카데로리 추출해서 json 저장
			stmt = conn.createStatement(rs_report.TYPE_SCROLL_INSENSITIVE, rs_report.CONCUR_READ_ONLY);

			logger.info(" Download  examhst Sel key :  org_cd [" + hospital_code + "] reg_no[" + strRegNumber
					+ "] ");

			buf_OUTPUT_04.append("SELECT DISTINCT class_nm1         AS category_large       ");
			buf_OUTPUT_04.append("          ,to_number(trim(level_cd))  AS level_cd     ");
			buf_OUTPUT_04.append("FROM      smtc_examhst                                ");
			buf_OUTPUT_04.append("WHERE     org_cd      = '" + hospital_code + "'       ");
			buf_OUTPUT_04.append("AND       reg_no      = '" + strRegNumber + "'       ");
			buf_OUTPUT_04.append("order by  to_number(trim(level_cd))          ");

			Select = "";
			Select = buf_OUTPUT_04.toString();
			
			//out.print(Select);

			logger.info("sql4:" + Select);

			rs_report = stmt.executeQuery(Select);

			while (rs_report.next()) {

				category_large = rs_report.getString("category_large"); //out.println(category_large);
				level_cd = rs_report.getString("level_cd");

				JSONObject jsonObjectCategory = new JSONObject();

				jsonObjectCategory.put(PARAM_OUT_CATEGORY_LARGE, category_large);
				jsonObjectCategory.put(PARAM_OUT_LEVEL_CD, level_cd);
				jsonArrayCategory.add(jsonObjectCategory);
			}

			jsonObject.put(PARAM_OUT_CATEGORY_LARGE, jsonArrayCategory);

			logger.info(" Categoty download result OK! ");

			 out.flush();

			rs_report.close();
			
		} catch (Exception _exception) {
			System.out.println(_exception);
			jsonObject.put(PARAM_OUT_RESULT, RESULT_LOGIC_ERROR);
			jsonObject.put(PARAM_OUT_RESULT_REASON, "검사결과 카데고리   조회 실패." + _exception);

			out.println(jsonObject);
			out.flush();
			return;
		}
       			
       			
		try { //검사 세부항목 추출
			stmt = conn.createStatement(rs_report.TYPE_SCROLL_INSENSITIVE, rs_report.CONCUR_READ_ONLY);

			logger.info(" Download  examhst Sel key :  org_cd [" + hospital_code + "] reg_no[" + strRegNumber
					+ "] ");

			buf_OUTPUT_03.append("SELECT     class_nm1          AS category_large       ");
			buf_OUTPUT_03.append("          ,class_nm2          AS category_medium      ");
			buf_OUTPUT_03.append("          ,item_nm            AS category_small       ");
			buf_OUTPUT_03.append("          ,item_no            AS report_identifier    ");
			//buf_OUTPUT_03.append("          ,item_val           AS measure              ");
			//buf_OUTPUT_03.append("          ,prev_item_val      AS measure_old          ");
			buf_OUTPUT_03.append("          ,exam_unit          AS quantity             ");
			buf_OUTPUT_03.append("          ,ref_min            AS reference_min        ");
			buf_OUTPUT_03.append("          ,ref_max            AS reference_max        ");
			buf_OUTPUT_03.append("          ,ref_val            AS reference_val        ");
			//buf_OUTPUT_03.append("          ,img_url            AS image_url            ");
			//buf_OUTPUT_03.append("          ,result_decision    AS result_decision      ");
			buf_OUTPUT_03.append("          ,to_number(trim(level_cd))  AS level_cd     ");
			buf_OUTPUT_03.append("FROM      smtc_examhst                                ");
			buf_OUTPUT_03.append("WHERE     org_cd      = '" + hospital_code + "'       ");
			buf_OUTPUT_03.append("AND       reg_no      = '" + strRegNumber + "'       ");
			buf_OUTPUT_03.append("order by  to_number(trim(level_cd)), item_no          ");

			Select = "";
			Select = buf_OUTPUT_03.toString();
			//out.print(Select);

			logger.info("sql3:" + Select);

			rs_report = stmt.executeQuery(Select);

			while (rs_report.next()) {

				report_identifier = rs_report.getInt("report_identifier");
				category_large = rs_report.getString("category_large"); //out.println(category_large);
				category_medium = rs_report.getString("category_medium"); //out.println(category_medium);
				category_small = rs_report.getString("category_small"); //out.println(category_small);
				//  measure           = rs_report.getString("measure");             //out.println(measure);
				//  measure_old       = rs_report.getString("measure_old");         //out.println(measure_old);
				quantity = rs_report.getString("quantity"); //out.println(quantity);
				reference_min = rs_report.getString("reference_min"); //out.println(reference_min);
				reference_max = rs_report.getString("reference_max"); //out.println(reference_max);
				reference_val = rs_report.getString("reference_val"); //out.println(reference_max);
				// image_url         = rs_report.getString("image_url");           //out.println(img_url);
				// result_decision   = rs_report.getString("result_decision");
				level_cd = rs_report.getString("level_cd");

				JSONObject jsonObjectReport = new JSONObject();

				jsonObjectReport.put(PARAM_OUT_REPORT_IDENTIFIER, report_identifier);
				jsonObjectReport.put(PARAM_OUT_CATEGORY_LARGE, category_large);
				jsonObjectReport.put(PARAM_OUT_CATEGORY_MEDIUM, category_medium);
				jsonObjectReport.put(PARAM_OUT_CATEGORY_SMALL, category_small);
				//jsonObjectReport.put(PARAM_OUT_MEASURE              , measure           );
				//jsonObjectReport.put(PARAM_OUT_MEASURE_OLD          , measure_old       );
				jsonObjectReport.put(PARAM_OUT_QUANTITY, quantity);
				jsonObjectReport.put(PARAM_OUT_REFERENCE_MIN, reference_min);
				jsonObjectReport.put(PARAM_OUT_REFERENCE_MAX, reference_max);
				jsonObjectReport.put(PARAM_OUT_REFERENCE, reference_val);
				//jsonObjectReport.put(PARAM_OUT_IMAGE_URL            , image_url         );
				//jsonObjectReport.put(PARAM_OUT_RESULT_DECISION      , result_decision   );
				jsonObjectReport.put(PARAM_OUT_LEVEL_CD, level_cd);

				jsonArrayReport.add(jsonObjectReport);
			}

			jsonObject.put(PARAM_OUT_REPORT, jsonArrayReport);
			jsonObject.put(PARAM_OUT_RESULT, result_cnt);

			logger.info(" download result OK! ");

			out.println(jsonObject);
			out.flush();

			rs_report.close();
		} catch (Exception _exception) {
			System.out.println(_exception);
			jsonObject.put(PARAM_OUT_RESULT, RESULT_LOGIC_ERROR);
			jsonObject.put(PARAM_OUT_RESULT_REASON, "검사결과 목록  조회 실패." + _exception);

			out.println(jsonObject);
			out.flush();
			return;
		}

	} finally {
		try {
			if (conn != null)
				conn.close();
			if (rs != null)
				rs.close();
			if (rs_report != null)
				rs_report.close();
			if (rs_reccnt != null)
				rs_reccnt.close();
			if (stmt != null)
				stmt.close();
			
			
			
		} catch (Exception _exception) {
			System.out.println(_exception);
		}
	}
    
%>

