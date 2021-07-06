public class Cons_F4_actualizarDatos {
    public Account data { get; set; }
    public Case c { get; set; }
    public User us {get;set;}
    public boolean PerfilPresencial {get;set;}

    public Cons_F4_actualizarDatos(ApexPages.StandardController controller){

        Account idCuenta;
        idCuenta = (Account)controller.getRecord();

        data = [SELECT Id,Calle_Nectia__c,Numero_Nectia__c,Villa_Nectia__c,Numero_de_piso_Nectia__c,Numero_departamento_Nectia__c,Region_Nectia__c,Comuna_Nectia__c,Phone,PersonOtherPhone,PersonMobilePhone ,PersonEmail FROM Account WHERE Id=: idCuenta.Id];

        c = new Case();
        c.Nombre_calle__c = data.Calle_Nectia__c;
        c.Numero_Nectia__c = data.Numero_Nectia__c;
        c.Nombre_Villa__c = data.Villa_Nectia__c;
        c.Numero_piso__c = data.Numero_de_piso_Nectia__c;
        c.Numero_de_departamento__c = data.Numero_departamento_Nectia__c;
        c.C_digo_regi_n__c = data.Region_Nectia__c;
        c.Comuna__c = data.Comuna_Nectia__c;

        c.Correo_electr_nico__c = data.PersonEmail;

        //c.Tel_fono_de_contacto__c = data.Phone;
        c.Otro_telefono__c = data.PersonOtherPhone;
        c.Telefono_movil__c = data.PersonMobilePhone;

        //boolean PerfilPresencial;
        us = [SELECT Id,ProfileId FROM User WHERE Id =: UserInfo.getUserId()];

        Profile perfil = [SELECT Id,Name FROM Profile WHERE Id =: us.ProfileId];
        
        PerfilesSeguridad__mdt PerfilesMeta = [SELECT id,Actualiza_Datos__c,Crea_Clave__c,
                                           Id_Perfil__c,Nombre_Perfil__c,
                                           Pide_huella__c FROM PerfilesSeguridad__mdt 
                                              WHERE Id_Perfil__c =: perfil.id];
        
        system.debug('perfiles'+PerfilesMeta);
            
        system.debug('perfil->'+perfil);
        system.debug('perfil n->'+perfil.Name);

       /* if (perfil.Name=='Ejecutivos de Atención al Cliente Seguros Remoto' || perfil.Name=='Jefe de Atención al Cliente Seguros Remoto' ||  perfil.Name=='Administrador del sistema' || perfil.Name=='Usuario Seguros Estándar' || perfil.Name=='Ejecutivos de Atención al Cliente Seguros MAC' || perfil.Name=='Jefe de Atención al Cliente Seguros MAC' ){
            PerfilPresencial = true;
        }else{
            PerfilPresencial = false;
        }
*/
        
        system.debug('este es el perfil'+ PerfilesMeta.Nombre_Perfil__c);
        system.debug('este es la respuesta de la huella'+perfilesMeta.Pide_huella__c);
        if(PerfilesMeta.Pide_huella__c == false && PerfilesMeta.Actualiza_Datos__c == true){
            PerfilPresencial = True;
        }else{
          PerfilPresencial = false;  
        }
        
        system.debug('perfil presencial->'+PerfilPresencial);
    }

    public PageReference enviarDatos(){

        us = [SELECT Id,FederationIdentifier,ProfileId FROM User WHERE Id =: UserInfo.getUserId()];
        system.debug('usuario->'+us.FederationIdentifier);

/*        AssignmentRule AR = new AssignmentRule();
        AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
        system.debug('regla asignación->'+AR);
        
        //Creating the DMLOptions for "Assign using active assignment rules" checkbox
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.assignmentRuleId = AR.id;
        
        //Setting the DMLOption on Case instance
        c.setOptions(dmlOpts);*/


        Id rt = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Casos Seguros').getRecordTypeId();
        System.debug('tipo de registro->'+rt);
        //Id rt = [SELECT Id FROM RecordType WHERE Name = 'Seguros - Solicitud'].Id;
        Account datos_cliente = [SELECT Name,RUT__c,Id,Calle_Nectia__c,
                                 Numero_Nectia__c,Villa_Nectia__c,Numero_de_piso_Nectia__c,
                                 Numero_departamento_Nectia__c,Region_Nectia__c,
                                 Comuna_Nectia__c,Phone,PersonOtherPhone,
                                 PersonAssistantPhone,PersonEmail,
                                 PersonMobilePhone 
                                 FROM Account 
                                 WHERE 
                                 Id =: data.Id];
        
        system.debug('cliente->'+datos_cliente);
        system.debug('rut cliente->'+datos_cliente.RUT__c);
        string nombre_comuna;
        Schema.DescribeFieldResult fieldResult = case.Comuna__c.getDescribe();
        List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry v : values) {
            if(v.getValue()==c.Comuna__c){
                nombre_comuna=v.getLabel();
                System.debug('Picklist Value Label:' + v.getLabel());
                System.debug('Picklist API Name:' + v.getValue());
            }
        
        
        }
        c.AccountId = data.Id;
        c.Subject = 'Solicitud de actualización de datos';
        c.Description = 'El cliente rut ';
        c.Description += datos_cliente.RUT__c;
        c.Description += ' ha solicitado cambiar los siguientes datos: ';

        c.Description += '\n\n';

        c.Description += 'Dirección: ' + (c.Nombre_calle__c!=null?c.Nombre_calle__c:'') + ' ' + (c.Numero_Nectia__c!=null?c.Numero_Nectia__c:'') + ' ' + (c.Nombre_Villa__c!=null?c.Nombre_Villa__c:'') + ' ' + (c.Numero_piso__c!=null?c.Numero_piso__c:'') + ' ' + (c.Numero_de_departamento__c!=null?c.Numero_de_departamento__c:'') + ' ' +  + ' ' + (nombre_comuna!=null?nombre_comuna:'');

        c.Description += '\n\n';

        c.Description += c.Correo_electr_nico__c;

        c.Description += '\n\n';

        c.Description += c.Otro_telefono__c + ' ' + c.Telefono_movil__c;

        System.debug('descripción->'+c.Description);

        if (c.Nombre_calle__c != data.Calle_Nectia__c || c.Numero_Nectia__c != data.Numero_Nectia__c || c.Nombre_Villa__c != data.Villa_Nectia__c || c.Numero_piso__c != data.Numero_de_piso_Nectia__c || c.Numero_de_departamento__c != data.Numero_departamento_Nectia__c || c.C_digo_regi_n__c != data.Region_Nectia__c || c.Comuna__c != data.Comuna_Nectia__c){
            c.Cambio_de_Direcci_n__c = TRUE;
        }

        if (c.Correo_electr_nico__c != data.PersonEmail){
            c.Cambio_de_Email__c = TRUE;
        }

        //if (c.Telefono_movil__c != data.PersonMobilePhone || c.Tel_fono_de_contacto__c != data.Phone || c.Otro_telefono__c != data.PersonOtherPhone){
        if (c.Telefono_movil__c != data.PersonMobilePhone || c.Otro_telefono__c != data.PersonOtherPhone){
            c.Cambio_de_Tel_fono__c = TRUE;
        }

        String direccion = c.Nombre_calle__c + ' ' + c.Numero_Nectia__c + ' ' + c.Nombre_Villa__c + ' ' + c.Numero_piso__c + ' ' + c.Numero_de_departamento__c;

        c.RecordTypeId = rt;
        c.Subtipo__c = 'Actualización de datos';
        c.Type = 'Solicitud';
        if (PerfilPresencial){
            c.Status = 'Nuevo';
        }else{
            c.Status = 'Cerrado';
        }

        Profile perfil = [SELECT Id,Name FROM Profile WHERE Id =: us.ProfileId];
        system.debug('nombre perfil->'+perfil.Name);
        PerfilesSeguridad__mdt PerfilesMeta = [SELECT id,Actualiza_Datos__c,Crea_Clave__c,
                                           Id_Perfil__c,Nombre_Perfil__c,
                                           Pide_huella__c FROM PerfilesSeguridad__mdt 
                                              WHERE Id_Perfil__c =: perfil.id];
       /*
        if( perfil.Name=='Ejecutivos de Atención al Cliente Seguros Presencial' || perfil.Name=='Jefe de Atención al Cliente Seguros Presencial' || perfil.Name=='Administrador del sistema'){
            // Presencial
            c.Origin = 'Presencial';
        }else if( perfil.Name=='Ejecutivos de Atención al Cliente Seguros Remoto' || perfil.Name=='Jefe de Atención al Cliente Seguros Remoto'  || perfil.Name=='Usuario Seguros Estándar' || perfil.Name=='Ejecutivos de Atención al Cliente Seguros MAC' || perfil.Name=='Jefe de Atención al Cliente Seguros MAC' ){
            //remoto
            c.Origin = 'Teléfono';
        }*/
        
        if(PerfilesMeta.Pide_huella__c == true){
            c.Origin = 'Presencial';
        }else{
            c.Origin = 'Teléfono';
        }        
        

        system.debug('verificación->'+c.Codigo_de_Validacion_Autentia_Nectia__c);

        system.debug('caso->'+c);
        insert c;

        system.debug('id caso->'+c.Id);

	//	if( perfil.Name=='Ejecutivos de Atención al Cliente Seguros Presencial' || perfil.Name=='Jefe de Atención al Cliente Seguros Presencial' || perfil.Name=='Administrador del sistema' || perfil.Name=='Ejecutivos de Atención al Cliente Seguros Remoto' || perfil.Name=='Jefe de Atención al Cliente Seguros Remoto'  || perfil.Name=='Usuario Seguros Estándar' || perfil.Name=='Ejecutivos de Atención al Cliente Seguros MAC' || perfil.Name=='Jefe de Atención al Cliente Seguros MAC' ){
	//PageReference pdf = new PageReference('/apex/CONS_FormularioActDatos?Id='+c.Id);
        if(PerfilesMeta.Actualiza_Datos__c == true){
			String url = '/apex/CONS_OrquestaPDF?Id='+c.Id;
			System.debug('url->'+url);
			PageReference pr = new PageReference(url);
			pr.setRedirect(true);
			return pr;

		}else{

			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'su perfil no corresponde con los  perfiles registrados para esta operacion');
			ApexPages.addMessage(myMsg); 
		}

		return null;
    }

    public PageReference cancelar(){

    String url = '/';
    PageReference pr = new PageReference(url);
    pr.setRedirect(true);
    return pr;
    }

}