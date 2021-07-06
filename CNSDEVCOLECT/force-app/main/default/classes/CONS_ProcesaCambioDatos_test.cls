@isTest
private class CONS_ProcesaCambioDatos_test {
	
	static testMethod void Cons_ProcesaCambioDatos_test(){
		Id rtcp = [SELECT id FROM RecordType WHERE Name =: 'Cliente Persona Seguros'].id;
		Id rtcaso = [SELECT Id FROM RecordType WHERE SobjectType='case' AND Name ='Casos Seguros'].Id;
		 
		Account cuenta = new Account();
		cuenta.FirstName = 'Cliente';
		cuenta.LastName = 'Test';
		cuenta.Phone = '+569123123123';
		cuenta.PersonEmail = 'mimail@mimail.cl';
		cuenta.ShippingStreet = 'Calle Falsa 123';
		cuenta.ShippingCity = 'Santiago';
		cuenta.ShippingState = 'Santiago';
		cuenta.ShippingPostalCode = '8320000';
		cuenta.RUT__c = '16213371-3';
		cuenta.RecordTypeId = rtcp;
		insert cuenta;

		Case caso = new Case();
		caso.AccountId = cuenta.Id;
		caso.Nombre_calle__c = 'nueva calle';
		caso.Numero_Nectia__c = '123';
		caso.C_digo_regi_n__c = 'CL-TA';
		caso.Comuna__c = '1101';
		caso.Otro_telefono__c = '1234567';
		caso.Telefono_movil__c = '1234567';
		caso.RecordTypeId = rtcaso;
		insert caso;

		apexPages.Currentpage().getParameters().put('id',caso.Id);

		CONS_ProcesaCambioDatos procesa = new CONS_ProcesaCambioDatos();
		pageReference pagina = page.CONS_ProcesaCambioDatos;
		Test.setCurrentPage(pagina);

		procesa.cambiodatos();
        procesa.continuar();
	}
    	static testMethod void test1(){
            CONS_DatosContacto_JSON fr=new CONS_DatosContacto_JSON();
            //string str='{ "datosContacto": {   "nCase_Id": 206231,   "oCorreo": { "sMailPrincipal": "carolyn.guzman@consorcio.cl"   }, "oDireccion": { "aCodigopostal": "", "nNumero": "123", "nPiso": null, "sCalle": "Calle", "sCasilla": "", "sComuna": "13123", "sDepartamento": null, "sVillapoblacion": null   },   "oFono": { "nNumeroTelefono": "122222222", "sCodarea": "9", "sExtension1": "", "sExtension2": "", "sTipotelefono": "2"   },   "sRut": "13558818-0",   "sUsuario": "wmbarra" }, "datosEmail": {   "nCelular": 122222222,   "nNegocio": 1,   "nNumSolicitud": 206231,   "nTelefono": 65524784,   "sDireccion": "Calle 123 null null null",   "sEmail": "carolyn.guzman@consorcio.cl",   "sEmail2": "",   "sFechaRecepcion": "01-04-2019",   "sLinNegocio": "Vida",   "sNombreCliente": "Carolyn Del Carmen Guzman",   "sPlantilla": "PLA0000038" }}';
            string str='{   "codigo": "99",    "mensaje": "Ocurrió un error al ejecutar el servicio",    "respuestaBase": {        "nCase_Id": "60",        "estado": {            "nCodigo": "0",            "sMensaje": "OK"        }    },    "respuestaEmailmatico": {        "codigo": "1",        "mensaje": "Alerta,  plantilla no valida para envio -Plantilla : string"    }}';
            fr=CONS_DatosContacto_JSON.parse(str);
            
        }
    
}