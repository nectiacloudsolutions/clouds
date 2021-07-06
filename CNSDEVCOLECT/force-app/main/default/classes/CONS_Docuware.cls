public class CONS_Docuware {
    public integer contador{get;set;} 
    public list<listado>  lista {get;set;}
    public string  documento{get;set;} 
    public string  msg{get;set;} 
    public  case cas{get;set;}
    public User u {get; set;}
    public user tmpUser{get;set;}
    public String accessToken {get; set;}
    public CONS_Docuware(ApexPages.StandardController  controller) {
        contador = 0;
        lista=new list<listado>();
        
        case rt = (case) controller.getRecord(); 
        system.debug('rt'+rt);
       
         //   string r='500g000000QzDDcAAN';  
            cas = [SELECT Id, Rut_del_Cliente__c,CaseNumber FROM case where  id=:rt.id];
            tmpUser = [select id,AccessToken_Nectia__c from user where  id=: userinfo.getUserId()]; 
        
    }    
    
    public PageReference lista_documentos(){
        Cons_callOutService call=new Cons_callOutService();
        CONS_estructuratoken est=new  CONS_estructuratoken();
        string resp='';

        tmpUser = [select id,AccessToken_Nectia__c from user where  id=: userinfo.getUserId()]; 

        if(!test.isRunningTest()){

			string access_token=est.token();
			system.debug('token->'+access_token);
			system.debug('rut cliente->'+cas.Rut_del_Cliente__c);
			system.debug('número caso->'+cas.CaseNumber);
			system.debug('user->'+tmpUser);
			
			resp=call.callOutlistardocumentos(access_token,cas.Rut_del_Cliente__c,cas.CaseNumber,tmpUser);
			system.debug('res'+resp); 
			
        }else{
			resp='{"archivadores":{"archivador":[{"mensaje":"Consulta sin resultados","nombre":"Carpeta Digital Cliente"}]},"codigo":"0000","codigoServicio":"0","mensajeServicio":"OK"}';
        }

        if(!resp.contains('ERROR -')){
            
            try{  CONS_docuwareobtener_JSON doclista = (CONS_docuwareobtener_JSON)JSON.deserialize(resp,CONS_docuwareobtener_JSON.class); 
        system.debug('doclista'+doclista);

        system.debug('xml'+doclista.archivadores.archivador[0].resultado);
        Dom.Document doc = new Dom.Document();
        string xml=doclista.archivadores.archivador[0].resultado;
                if(xml!=null){
                    parse(xml);  
                }else{
                     ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,'No existen documentos asociados al cliente'); 
                    ApexPages.addMessage(myMsg);  
                }
                    
              
               }catch(Exception e){
                     
           // docuware22(resp);
               }
          
        }else{
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR:'+resp); 
             ApexPages.addMessage(myMsg);  
        }
        return null;
        
    }
    
    
  
    
    
    
    
    public String parse(String toParse) {
        DOM.Document doc = new DOM.Document();
        
        try {
            doc.load(toParse);    
            DOM.XMLNode root = doc.getRootElement();
            return walkThrough(root);
            
        } catch (System.XMLException e) {  // invalid XML
            return e.getMessage();
        }
    }
    
    public String walkThrough(DOM.XMLNode node) {
        String result = '\n';
        integer j=0;
        if (node.getNodeType() == DOM.XMLNodeType.COMMENT) {
            
            return 'Comment (' +  node.getText() + ')';
        }
        if (node.getNodeType() == DOM.XMLNodeType.TEXT) {
            
            return 'Text (' + node.getText() + ')';
        }
        if (node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
            result += 'Element: ' + node.getName();
            
            if (node.getText().trim() != '') {
                result += ', text=' + node.getText().trim();
                
            }
            if(node.getName()=='Store_x0020_Date'){
                system.debug('================Store_x0020_Date');
                string fecha= node.getText().trim();
                guardar(null,null,null,documento,fecha,null,null);
            }
            if(node.getName()=='FileDownloadLink'){
                system.debug('================FileDownloadLink');
                string FileDownloadLink= node.getText().trim();
                guardar(null,null,null,documento,null,FileDownloadLink,null);
            }
             if(node.getName()=='Comentarios_x0020_Suscripcion'){
                system.debug('================Comentarios_x0020_Suscripcion');
                string OBS1= node.getText().trim();
                guardar(null,null,null,documento,null,null,OBS1);
            }
            if (node.getAttributeCount() > 0) { 
                for (Integer i = 0; i< node.getAttributeCount(); i++ ) {
                    result += ', attribute #' + i + ':' + node.getAttributeKeyAt(i) + '=' + node.getAttributeValue(node.getAttributeKeyAt(i), node.getAttributeKeyNsAt(i));
                    if(node.getAttributeKeyAt(i)=='id'){
                        documento=node.getAttributeValue(node.getAttributeKeyAt(i), node.getAttributeKeyNsAt(i));
                    }
                }  
            }
            
            for (Dom.XMLNode child: node.getChildElements()) {
                if(child.getName()=='DWDOCID'){
                    contador++;
                    system.debug('================1');
                    guardar(child.getName(),0,child.getText().trim(),documento,null,null,null);
                }
                result += walkThrough(child);
            }
            // system.debug('result'+result);
            return result;
        }
        system.debug('result'+result);
        return '';  //should never reach here 
    }
    
    
    public class listado {
        public  String nombre {get;set;}
        public  integer numero {get;set;}
        public  String texto {get;set;}
        public  String documento {get;set;}
        public String fecha {get;set;}
        public String url {get;set;}
        public String obs1 {get;set;}
        
    }    
    public String guardar(string nombre,integer numero ,string texto,string documento,string fecha,string url,string obs1) {
        //  system.debug('lista.get(r).fecha');
        if(lista.size()>0){
            integer contador=0;
            for(integer r=0;r<lista.size();r++){
                // system.debug('lista.get(r).fecha'+lista.get(r).fecha);
                if(lista.get(r).documento==documento && lista.get(r).fecha==null){
                    lista.get(r).fecha=fecha;
                    contador++;
                    
                }
                if(lista.get(r).documento==documento && lista.get(r).url==null){
                    lista.get(r).url=url;
                    contador++;
                    
                }  if(lista.get(r).documento==documento && lista.get(r).obs1==null){
                    lista.get(r).obs1=obs1;
                    contador++;
                    
                }
                
            }
            
            if(contador==0){
                listado  l=new listado();
                l.nombre=nombre;
                l.numero=numero;
                l.texto=texto;
                l.documento=documento;
                lista.add(l);   
            }
            
        }else{
            listado  l=new listado();
            l.nombre=nombre;
            l.numero=numero;
            l.texto=texto;
            l.documento=documento;
            lista.add(l);  
        }
        system.debug('lista'+lista);
        return null;
    }

	public void updateUser(){
		system.debug(tmpUser.AccessToken_Nectia__c);
		update tmpUser;
	}

	public PageReference orquestaMetodos(){
		lista_documentos();
		updateUser();
		return null;
	}


   /* public  PageReference  docuware22(string resp){
         system.debug('entro aca'); 
       CONS_docuwareobtener22_JSON doclista22 = (CONS_docuwareobtener22_JSON)JSON.deserialize(resp,CONS_docuwareobtener22_JSON.class);
        for(integer i=0;i<(doclista22.archivadores.archivador.size());i++){
             system.debug('doclista22.archivadores=='+doclista22.archivadores.archivador.get(i).Resultado.diffgram.DocumentElement.Documentos); 
                listado  l=new listado();
                l.nombre=doclista22.archivadores.archivador.get(i).Resultado.diffgram.DocumentElement.Documentos.Clasificacion_x0020_documento;
              //  l.numero=integer.valueOf(doclista22.archivadores.archivador.get(i).Resultado.diffgram.DocumentElement.Documentos.Numeracion);
                l.texto=doclista22.archivadores.archivador.get(i).Resultado.diffgram.DocumentElement.Documentos.DWDOCID;
                l.documento=doclista22.archivadores.archivador.get(i).Resultado.diffgram.DocumentElement.Documentos.id;
                l.url=doclista22.archivadores.archivador.get(i).Resultado.diffgram.DocumentElement.Documentos.FileDownloadLink;
                l.fecha=doclista22.archivadores.archivador.get(i).Resultado.diffgram.DocumentElement.Documentos.Store_x0020_Date;
                lista.add(l); 
        }
        return null;
    }    */
}