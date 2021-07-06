public  class CONS_FormularioActDatosController {

    Public String NombreEjecutivo{get;set;}
    Public String RutEjecutivo{get;set;}
    public String SucursalEjecutivo{get;set;}
    Public Case casoAct{get;set;}
    public PageReference pagina;
    Public Id tmpId {get;set;}


    //public CONS_FormularioActDatosController(ApexPages.StandardController stdController) {
    public CONS_FormularioActDatosController() {

        tmpId = Apexpages.currentPage().getParameters().get('Id');
        system.debug('caso->'+tmpId);

		casoAct = [Select Id, CaseNumber, Account.Name, Account.RUT__c, Nombre_calle__c,Numero_Nectia__c,Nombre_Villa__c,Numero_piso__c,Numero_de_departamento__c,C_digo_regi_n__c,toLabel(Comuna__c),Correo_electr_nico__c,Tel_fono_de_contacto__c,Otro_telefono__c,Telefono_movil__c from Case where Id =: tmpId];
		system.debug('resultado query->'+casoAct);

		NombreEjecutivo = UserInfo.getName();
		RutEjecutivo = [Select Id, RUT__c From User Where Id =: UserInfo.getUserId()].RUT__c;
		SucursalEjecutivo = [Select Id, toLabel(Sucursal__c)  From User Where Id =: UserInfo.getUserId()].Sucursal__c;
		System.debug('datos ejecutivo->'+NombreEjecutivo + ' ' + RutEjecutivo + ' ' + SucursalEjecutivo);
    }


   /* public PageReference creaPdf(){

		//PageReference paginaPdf;
		//PageReference paginaPdf = Apexpages.currentPage();
		PageReference paginaPdf = Page.CONS_FormularioActDatos;
		paginaPdf.getParameters().put('Id',tmpId);

		Attachment adjunto = new Attachment();

		Blob cuerpoPdf;

		try{

			cuerpoPdf = paginaPdf.getContent();
			System.debug('cuerpo pdf->'+cuerpoPdf);

		}catch(VisualforceException e){

			System.debug('error->'+e);
			String error = String.valueOf(e);
			cuerpoPdf = Blob.valueOf(error);

		}

		adjunto.Body = cuerpoPdf;
		adjunto.Name = casoAct.CaseNumber+' - Formulario.pdf';
		adjunto.IsPrivate = false;
		adjunto.ParentId = tmpId;

		system.debug('adjunto->'+adjunto);

		insert adjunto;

		User us = [SELECT Id,FederationIdentifier,ProfileId FROM User WHERE Id =: UserInfo.getUserId()];
		system.debug('usuario->'+us.FederationIdentifier);
		system.debug('perfil usuario->'+us.ProfileId);

		Profile perfil = [SELECT Id,Name FROM Profile WHERE Id =: us.ProfileId];
		system.debug('nombre perfil->'+perfil.Name);

/*		if( perfil.Name=='Ejecutivos de Atención al Cliente Seguros Presencial' || perfil.Name=='Jefe de Atención al Cliente Seguros Presencial' || perfil.Name=='Administrador del sistema'){

			PageReference pageRef = new PageReference('/apex/CONS_pruebahuellero?id='+casoAct.Id+'&tipo=ModificaDatos&obj=c');
			return pageRef;  

		}else if( perfil.Name=='Ejecutivos de Atención al Cliente Seguros Remoto' || perfil.Name=='Jefe de Atención al Cliente Seguros Remoto'  || perfil.Name=='Usuario Seguros Estándar' || perfil.Name=='Ejecutivos de Atención al Cliente Seguros MAC' || perfil.Name=='Jefe de Atención al Cliente Seguros MAC' ){

			String url = '/apex/CONS_ProcesaCambioDatos?Id='+casoAct.Id;
			PageReference pr = new PageReference(url);
			pr.setRedirect(true);
			return pr;
		}


		String url = '/'+casoAct.Id;
		PageReference pr = new PageReference(url);
		pr.setRedirect(true);
		return pr;*/

		/*return null;
	}*/

}