public class CONS_OrquestaPDF {
	
	public string tmpId{get;set;}
	
	public PageReference  generador(){
		tmpId = Apexpages.currentPage().getParameters().get('Id');

		Case casoActualizacion = [SELECT Id,CaseNumber FROM Case WHERE Id=: tmpId];
		
		PageReference pdf = new PageReference('/apex/CONS_FormularioActDatos?Id='+tmpId);

		Attachment att = new Attachment();
		if(!Test.isRunningTest()){
			att.body = pdf.getContent();
		}else{
			att.body = Blob.valueOf('test');
		}
		att.ParentId=tmpId;
		att.Name = casoActualizacion.CaseNumber+' - Formulario.pdf';

		insert att;


		User us = [SELECT Id,FederationIdentifier,ProfileId FROM User WHERE Id =: UserInfo.getUserId()];
		system.debug('usuario->'+us.FederationIdentifier);
		system.debug('perfil usuario->'+us.ProfileId);

		Profile perfil = [SELECT Id,Name FROM Profile WHERE Id =: us.ProfileId];
		system.debug('nombre perfil->'+perfil.Name);
        
        PerfilesSeguridad__mdt PerfilesMeta = [SELECT id,Actualiza_Datos__c,Crea_Clave__c,
                                           Id_Perfil__c,Nombre_Perfil__c,
                                           Pide_huella__c FROM PerfilesSeguridad__mdt 
                                              WHERE Id_Perfil__c =: perfil.id];
        

	//	if( perfil.Name=='Ejecutivos de Atención al Cliente Seguros Presencial' || perfil.Name=='Jefe de Atención al Cliente Seguros Presencial' || perfil.Name=='Administrador del sistema'){
        if(PerfilesMeta.Pide_huella__c == true){
			PageReference pageRef = new PageReference('/apex/CONS_pruebahuellero?id='+tmpId+'&tipo=ModificaDatos&obj=c');
			return pageRef;  

        }else   if(PerfilesMeta.Pide_huella__c == false){
            //if( perfil.Name=='Ejecutivos de Atención al Cliente Seguros Remoto' || perfil.Name=='Jefe de Atención al Cliente Seguros Remoto'  || perfil.Name=='Usuario Seguros Estándar' || perfil.Name=='Ejecutivos de Atención al Cliente Seguros MAC' || perfil.Name=='Jefe de Atención al Cliente Seguros MAC' )
			String url = '/apex/CONS_ProcesaCambioDatos?Id='+tmpId;
			PageReference pr = new PageReference(url);
			pr.setRedirect(true);
			return pr;
		}

		return null;

/*		String url = '/apex/CONS_ProcesaCambioDatos?Id='+tmpId;
		System.debug('url->'+url);
		PageReference pr = new PageReference(url);
		pr.setRedirect(true);

		return pr;*/
	}

	public  PageReference volver(){
		system.debug('entro a volver'); 
		PageReference p = new PageReference('/'+tmpId);
		p.setRedirect(true);
		return p;
	}

}