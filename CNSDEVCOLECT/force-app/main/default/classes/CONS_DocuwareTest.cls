@isTest
public class CONS_DocuwareTest {
    
 static testMethod void test1() {
     
 String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        pc.Esquema_Nectia__c='SISRVOWCNL';
        insert pc;
        Case cas=new Case();
        cas.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        cas.Accountid=acc.id;
        cas.Status='Nuevo';
        cas.Type='consulta';
        cas.Subtipo__c='Siniestros';
        cas.Clasificaci_n_de_Consulta__c = 'Estado';
        cas.Priority='alta';
        cas.Origin='web';
        cas.Description='problemas de clave de acceso';
        cas.Subject='reclamo';
        cas.SlaStartDate=System.now(); 
        insert cas;
     string xml='<?xml version=\"1.0\" encoding=\"UTF-16\"?>\n<Resultado xmlns=\"http://tempuri.org/\"><xs:schema id=\"NewDataSet\" xmlns=\"\" xmlns:msdata=\"urn:schemas-microsoft-com:xml-msdata\" xmlns:xs=\"http://www.w3.org/2001/XMLSchema\"><xs:element msdata:IsDataSet=\"true\" msdata:MainDataTable=\"Documentos\" msdata:UseCurrentLocale=\"true\" name=\"NewDataSet\"><xs:complexType><xs:choice maxOccurs=\"unbounded\" minOccurs=\"0\"><xs:element name=\"Documentos\"><xs:complexType><xs:sequence><xs:element minOccurs=\"0\" name=\"DWDOCID\" type=\"xs:string\"/><xs:element minOccurs=\"0\" name=\"FileDownloadLink\" type=\"xs:string\"/><xs:element minOccurs=\"0\" name=\"Numeracion\" type=\"xs:string\"/><xs:element minOccurs=\"0\" name=\"Cliente\" type=\"xs:string\"/><xs:element minOccurs=\"0\" name=\"Linea_x0020_de_x0020_negocio\" type=\"xs:string\"/><xs:element minOccurs=\"0\" name=\"Tipo_x0020_Documento\" type=\"xs:string\"/><xs:element minOccurs=\"0\" name=\"Clasificacion_x0020_documento\" type=\"xs:string\"/><xs:element minOccurs=\"0\" name=\"Proceso_x0020_de_x0020_negocio\" type=\"xs:string\"/><xs:element minOccurs=\"0\" name=\"OBS1\" type=\"xs:string\"/><xs:element minOccurs=\"0\" name=\"OBS2\" type=\"xs:string\"/><xs:element minOccurs=\"0\" name=\"OBS3\" type=\"xs:string\"/><xs:element minOccurs=\"0\" name=\"OBS4\" type=\"xs:string\"/><xs:element minOccurs=\"0\" name=\"Fecha\" type=\"xs:string\"/><xs:element minOccurs=\"0\" name=\"ACTUALIZADO\" type=\"xs:string\"/><xs:element minOccurs=\"0\" name=\"Revisado\" type=\"xs:string\"/><xs:element minOccurs=\"0\" name=\"ID_x0020_Negocio\" type=\"xs:string\"/><xs:element minOccurs=\"0\" name=\"ID_x0020_Proceso\" type=\"xs:string\"/><xs:element minOccurs=\"0\" name=\"Comentarios_x0020_Suscripcion\" type=\"xs:string\"/><xs:element minOccurs=\"0\" name=\"FECHAACTUALIZA\" type=\"xs:string\"/><xs:element minOccurs=\"0\" name=\"Store_x0020_Date\" type=\"xs:string\"/><xs:element minOccurs=\"0\" name=\"Numero_x0020_Caja\" type=\"xs:string\"/></xs:sequence></xs:complexType></xs:element></xs:choice></xs:complexType></xs:element></xs:schema><diffgr:diffgram xmlns:diffgr=\"urn:schemas-microsoft-com:xml-diffgram-v1\" xmlns:msdata=\"urn:schemas-microsoft-com:xml-msdata\"><DocumentElement xmlns=\"\"><Documentos diffgr:hasChanges=\"inserted\" diffgr:id=\"Documentos1\" msdata:rowOrder=\"0\"><DWDOCID>184945</DWDOCID><FileDownloadLink>http://tconvm148/DocuWare/Platform/FileCabinets/01f0fde3-0605-4433-9243-cb6c55e01df1/Documents/184945/FileDownload</FileDownloadLink><Numeracion>0</Numeracion><Cliente>15992082-8</Cliente><Linea_x0020_de_x0020_negocio>VI</Linea_x0020_de_x0020_negocio><Tipo_x0020_Documento>CART</Tipo_x0020_Documento><Clasificacion_x0020_documento>CARTAS</Clasificacion_x0020_documento><Proceso_x0020_de_x0020_negocio>DCTOS</Proceso_x0020_de_x0020_negocio><OBS1>carnet de identidad FRT.pdf</OBS1><OBS2/><OBS3/><OBS4/><ACTUALIZADO>1</ACTUALIZADO><Store_x0020_Date>22-04-2019 15:58:44</Store_x0020_Date></Documentos><Documentos diffgr:hasChanges=\"inserted\" diffgr:id=\"Documentos2\" msdata:rowOrder=\"1\"><DWDOCID>184943</DWDOCID><FileDownloadLink>http://tconvm148/DocuWare/Platform/FileCabinets/01f0fde3-0605-4433-9243-cb6c55e01df1/Documents/184943/FileDownload</FileDownloadLink><Numeracion>0</Numeracion><Cliente>15992082-8</Cliente><Linea_x0020_de_x0020_negocio>VI</Linea_x0020_de_x0020_negocio><Tipo_x0020_Documento>DCTO</Tipo_x0020_Documento><Clasificacion_x0020_documento>OTROS</Clasificacion_x0020_documento><Proceso_x0020_de_x0020_negocio>DCTOS</Proceso_x0020_de_x0020_negocio><OBS1>cedula.pdf</OBS1></Documentos><Documentos diffgr:hasChanges=\"inserted\" diffgr:id=\"Documentos3\" msdata:rowOrder=\"2\"><DWDOCID>184942</DWDOCID><FileDownloadLink>http://tconvm148/DocuWare/Platform/FileCabinets/01f0fde3-0605-4433-9243-cb6c55e01df1/Documents/184942/FileDownload</FileDownloadLink><Numeracion>0</Numeracion><Cliente>15992082-8</Cliente><Linea_x0020_de_x0020_negocio>VI</Linea_x0020_de_x0020_negocio><Tipo_x0020_Documento>CERIOT</Tipo_x0020_Documento><Clasificacion_x0020_documento>CERTIFICADO</Clasificacion_x0020_documento><Proceso_x0020_de_x0020_negocio>DCTOS</Proceso_x0020_de_x0020_negocio><OBS1>cedula.pdf</OBS1><OBS2/><OBS3/><OBS4/><ACTUALIZADO>1</ACTUALIZADO><Store_x0020_Date>22-04-2019 15:49:14</Store_x0020_Date></Documentos></DocumentElement></diffgr:diffgram></Resultado>';
     string json='{"archivadores":{"archivador":[{"mensaje":"Consulta sin resultados","nombre":"Carpeta Digital Cliente"}]},"codigo":"0000","codigoServicio":"0","mensajeServicio":"OK"}';
     ApexPages.StandardController  apsc=new ApexPages.StandardController(cas);
     CONS_Docuware  dc=new CONS_Docuware(apsc);
     dc.lista_documentos();
     dc.parse(xml);
     CONS_docuwareobtener_JSON  d=new CONS_docuwareobtener_JSON();
     CONS_docuwareobtener_JSON.parse(json);
    
 }
}