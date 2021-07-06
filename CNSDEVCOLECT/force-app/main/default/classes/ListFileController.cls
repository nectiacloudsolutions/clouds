public class ListFileController {

    @AuraEnabled
    public static List<ObjDocs> getData(id recordId){
        List<ObjDocs> lstDocs = new List<ObjDocs>();
        List<Case> lstCase = [SELECT Id,id_alfresco_caso_sales__c,id_docuware_sales__c, Fecha_Documento__c FROM Case WHERE Id=:recordId];
        DateTime strConvertedDate;
        if (lstCase[0].id_alfresco_caso_sales__c!= null && lstCase[0].id_alfresco_caso_sales__c!='') {
            ObjDocs docs = new ObjDocs();
            docs.idRepo=lstCase[0].id_alfresco_caso_sales__c;
            docs.origen='Banco';//alfresco 
            strConvertedDate=lstCase[0].Fecha_Documento__c;
            docs.fecha=strConvertedDate.format('dd-MM-yyyy HH:mm');
            lstDocs.add(docs);
        }
        if(lstCase[0].id_docuware_sales__c!= null && lstCase[0].id_docuware_sales__c!='') {
            ObjDocs docs = new ObjDocs();
            docs.idRepo=lstCase[0].id_docuware_sales__c;
            docs.origen='Seguros';//Docuware
            strConvertedDate=lstCase[0].Fecha_Documento__c;
            docs.fecha=strConvertedDate.format('dd-MM-yyyy HH:mm');
            lstDocs.add(docs);
        }
        System.debug('DOCUMENTOSSSS=>'+lstDocs);
        return lstDocs;
    }
    @AuraEnabled
    public static ResponseDTOAlfresco viewDocAlfresco(String idRepo){

        RequestDTOAlfresco request = new RequestDTOAlfresco();
        ResponseDTOAlfresco response = new ResponseDTOAlfresco();


        RequestDTOAlfresco.ConsultaDoc consultar = new RequestDTOAlfresco.ConsultaDoc();
        RequestDTOAlfresco.dtoRequestSetParametros dtoRequestSetParametros = new RequestDTOAlfresco.dtoRequestSetParametros();

            consultar.idAlfresco = idRepo;
            consultar.rutCliente = '';
            dtoRequestSetParametros.ConsultaDoc = consultar;
            request.dtoRequestSetParametros = dtoRequestSetParametros;
            SalesCallout sc = new SalesCallout(CONSTANTS.ALFRESCO);
            response = sc.viewFileAlfresco(request);
        System.debug('RESPONSE LISTFILE==>'+response);

        return response;
    }
    @AuraEnabled
    public static DTODocuware.ResponseGetDocuware viewDocDocuware(String idRepo){
        
        List<DocuwareMetadata__c> lsMetadata = [SELECT Index_Label__c,Index_value__c FROM DocuwareMetadata__c                                                
                                                WHERE Type_Index_List__c = : Constants.XML_FILTROS];        
        Map<String,String> mapMetadata = new Map<String,String>();
        
        for(DocuwareMetadata__c metaData : lsMetadata){           
            if(metaData.Index_Label__c.equalsIgnoreCase(Constants.INDICE_DWDOCID)){                
                metaData.Index_value__c =idRepo ;// Aqui se envia el rut de la cuenta.                
            }
            mapMetadata.put(metaData.Index_Label__c,metaData.Index_value__c);            
        }
         
        DTODocuware.RequestGetDocuware request = new DTODocuware.RequestGetDocuware();        
        request.archivador = Constants.CARPETA_DIGITAL_CLIENTE;        
        request.xmlFiltros = UtilitiesSales.generateMetadataDocuware(mapMetadata);        
  
        System.debug('Request: '+request);

        
        SalesCallout sc = new Salescallout(Constants.DOCUWARE);    
        DTODocuware.ResponseGetDocuware response = sc.getFileDocuware(request);
   
        //lstCase[0].id_docuware_sales__c = String.valueOf(response.dwDocId);
        //update lstCase;
        
        System.debug('response DOCUWARE: '+response);
        return response;
        
        
    }

    public class ObjDocs {
        @AuraEnabled public String idRepo { get;set; }
        @AuraEnabled public string origen { get;set; }
        @AuraEnabled public string fecha { get;set; }
     }
}