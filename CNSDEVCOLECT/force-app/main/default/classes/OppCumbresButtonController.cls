/**
 * @File Name          : OppCumbresButtonController.cls
 * @Description        : 
 * @Author             : rjimenle@everis.com
 * @Group              : 
 * @Last Modified By   : eayalcor@everis.com
 * @Last Modified On   : 6/23/2020, 3:41:34 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    17-06-2020   rjimenle@everis.com         Initial Version
**/
public class OppCumbresButtonController { 

    /**
    * @description 
    * @author eayalcor@everis.com | 6/23/2020 
    * @param Id id 
    * @return OppCumbresButtonController.ResponseDto 
    **/
    @AuraEnabled
    public static ResponseDto getCumbresInfo(Id id){
        System.debug('getCumbresInfo '+ id);
        RequestDto dtoRequest = new RequestDto();
        ResponseDto dtoResponse = new ResponseDto();
        if(Consorcio_Org__c.getInstance(UserInfo.getProfileId()).Envio_Solicitud_Backend__C){

            List<Opportunity> lstOpp = [SELECT Id,Numero_de_documento_sales__c, Numero_Op_Comercializadora_sales__c,RecordType.DeveloperName
                                    FROM Opportunity
                                    WHERE Id =: id LIMIT 1];
    
            if(lstOpp != null && !lstOpp.IsEmpty()){
                dtoRequestSetParametros request = new dtoRequestSetParametros();
                request.numeroSolicitud = lstOpp[0].Numero_Op_Comercializadora_sales__c;
                request.numeroOportunidad = lstOpp[0].Id;
                request.rutCliente = lstOpp[0].Numero_de_documento_sales__c.remove('-');
                request.fechaSolicitud = date.today().format();
                request.identificadorEjecutivo = [SELECT Rut__c FROM User WHERE Id=: UserInfo.getUserId() LIMIT 1].Rut__c;
                List<Product2> lstPro2 = [SELECT Codigo_Macroproducto_Operacional_sales__c FROM product2 WHERE tipo_producto_sales__c =: lstOpp[0].RecordType.DeveloperName LIMIT 1];
                if(lstPro2 == null || lstPro2.isEmpty()){
                    request.producto = lstPro2[0].Codigo_Macroproducto_Operacional_sales__c;
                    dtoResponseSetParametros response = new dtoResponseSetParametros();
                    response.codigoError = '-1';
                    response.msjError = 'No ha completado el código de Macroproducto operacional';
                    dtoResponse.dtoResponseSetParametros = response;
                    throw new AuraHandledException('Debe completar código de Macroproducto operacional en el producto');
                }else{
                    request.producto = lstPro2[0].Codigo_Macroproducto_Operacional_sales__c;
                }
                dtoRequest.dtoRequestSetParametros = request;
                if(request.numeroSolicitud == null){
                    dtoResponseSetParametros response = new dtoResponseSetParametros();
                    response.codigoError = '-1';
                    response.msjError = 'No ha completado el Número de Solicitud';
                    dtoResponse.dtoResponseSetParametros = response;
                    throw new AuraHandledException('Debe completar Número de Solicitud');
                }else{
                    SalesCallout callOut = new SalesCallout(Constants.CUMBRES);
                    dtoResponse = callOut.setCumbres(dtoRequest);
                }
            }else{ 
                dtoResponseSetParametros response = new dtoResponseSetParametros();
                response.codigoError = '-1'; 
                response.msjError = 'Ha ocurrido un error';
                dtoResponse.dtoResponseSetParametros = response;
            }
        }else{
            dtoResponseSetParametros response = new dtoResponseSetParametros();
            response.codigoError = '-1'; 
            response.msjError = 'Su perfil no posee permisos para ejecutar la acción';
            dtoResponse.dtoResponseSetParametros = response;
        }

        System.debug('Objeto: '+ dtoResponse);

        return dtoResponse; 
    }

    /**
    * @description 
    * @author eayalcor@everis.com | 6/23/2020 
    * @param Id id 
    * @return Boolean 
    **/
    @AuraEnabled 
    public static Boolean getOppStage(Id id){
        List<Opportunity> opp = [SELECT Id,StageName FROM Opportunity WHERE Id =: id LIMIT 1];
        if (opp[0].StageName.equals(Constants.PLAN_PLUS_STATUS_RECOPILACION)) {
            return true;
        }
        return false;
    }

    public class RequestDto{
        public dtoRequestSetParametros dtoRequestSetParametros;
    }

    public class dtoRequestSetParametros {
        @AuraEnabled public String numeroSolicitud;
        @AuraEnabled public String numeroOportunidad;
        @AuraEnabled public String producto;
        @AuraEnabled public String fechaSolicitud;
        @AuraEnabled public String rutCliente;
        @AuraEnabled public String identificadorEjecutivo;
        
    }

    public class ResponseDto{
        @AuraEnabled public dtoResponseCodigosEstadoHttp dtoResponseCodigosEstadoHttp;
        @AuraEnabled public dtoResponseSetParametros dtoResponseSetParametros;
    }

    public class dtoResponseCodigosEstadoHttp{
        @AuraEnabled public String codigo;
        @AuraEnabled public String mensaje;
        @AuraEnabled public String descripcion;
    }

    public class dtoResponseSetParametros{
        @AuraEnabled public String codigoError;
        @AuraEnabled public String msjError;
    }

}