/*********************************************************************************************************
@Author       eayalcor@everis.com
@name         CreateLeadAnalytics
@CreateDate   08/10/2019
@Description  Utility class for Service REST Custom
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
08/10/2019                    eayalcor@everis.com           Initial Version
**********************************************************************************************************/
global without sharing class UtilitiesSalesREST {


    global class Response{
        public List<Data> response{get;set;}
    }

    global class Data{
        public boolean success  {get;set;}
        public String statusCode {get;set;}
        public String message {get;set;}
        public String jsonMap {get;set;}
    }
}