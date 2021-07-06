/**
 * @File Name          : UtilitiesOppREST.cls
 * @Description        : 
 * @Author             : pcelis@everis.com
 * @Group              : 
 * @Last Modified By   : pcelis@everis.com
 * @Last Modified On   : 16-01-2020 17:08:29
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    26-12-2019   pcelis@everis.com     Initial Version
**/
global with sharing class UtilitiesOppREST {


    global class Response{
        public List<Data> resultados{get;set;}
    }

    global class Data{
        public String idOportunidad  {get;set;}
        public String estado {get;set;}
        public String mensaje {get;set;}

    }

    global class ResponseCreate{
        public List<DataCreate> resultados{get;set;}
    }

    global class DataCreate{
        //public String numero_de_documento_sales {get;set;}
        //public String rut_ejecutivo_sales {get;set;}
        public String idOportunidad  {get;set;}
        public String estado {get;set;}
        public String mensaje {get;set;}
        //public Opportunity Opp{get;set;}
        public String AccountId{get;set;}
        public String correoOportunidad{get;set;}
        public String description{get;set;}
        public String ownerId{get;set;}
        public String stageName{get;set;}
        public String telefono_Opp{get;set;}
        public String telefono_Sales{get;set;}
        public String cod_prod{get;set;}
        public String rut_ejecutivo{get;set;}
        public String rut_cuenta{get;set;}
        public String origenOportunidad {get;set;}
        public String tipoOportunidad {get;set;}
    }
}