@isTest
private class CONS_Comunicaciones_test {
	
	@isTest static void test_method_one() {
		
		Id rtcp = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
		Id rtcas = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Casos Seguros').getRecordTypeId();

		Account cuenta = new Account();
		cuenta.FirstName = 'cuenta';
		cuenta.LastName = 'cuenta';
		cuenta.RUT__c = '14381623-0';
		cuenta.RecordTypeId = rtcp;
		insert cuenta;

		Producto_de_Seguros__c PdS = new Producto_de_Seguros__c();
		PdS.Name = 'prod seguro';
		PdS.Codigo_de_Producto_nectia__c = '1000';
		PdS.Familia__c = 'Seguro Vida Accidentes Personales';
		insert PdS;

		Producto_del_Cliente__c PdC = new Producto_del_Cliente__c();
		PdC.Name = 'prod cliente';
		PdC.Producto_de_Seguros_Nectia__c = PdS.Id;
		PdC.Cliente_Nectia__c = cuenta.Id;
		PdC.Id__c = '1234514381623-0';
		PdC.Poliza_Nectia__c = '12345';
		PdC.Esquema_Nectia__c = 'INSUDB';
		PdC.Tipo_Registro_Nectia__c = '2';
		PdC.Ramo_Nectia__c = '1';
		PdC.Codigo_Plan_Nectia__c = '650';
		PdC.Numero_Certificado_Nectia__c = '0';
		insert PdC;

		Case caso = new Case();
		caso.Type	= 'Reclamo';
		caso.Subtipo__c = 'Asociadas a Producción S. Vida';
		caso.Clasificaci_n_del_Reclamo__c = 'Costos de Cobertura';
		caso.Status = 'Nuevo';
		caso.RecordTypeId = rtcas;
		caso.Producto_del_Cliente_Nectia__c = PdC.Id;
		caso.AccountId = cuenta.Id;
		insert caso;
        
        
	}

	@isTest static void test_method_two() {
		
		Id rtcp = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
		Id rtcas = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Casos Seguros').getRecordTypeId();

		Account cuenta = new Account();
		cuenta.FirstName = 'cuenta';
		cuenta.LastName = 'cuenta';
		cuenta.RUT__c = '14381623-0';
		cuenta.RecordTypeId = rtcp;
		insert cuenta;

		Producto_de_Seguros__c PdS = new Producto_de_Seguros__c();
		PdS.Name = 'prod seguro';
		PdS.Codigo_de_Producto_nectia__c = '1000';
		PdS.Familia__c = 'Seguro Vida Accidentes Personales';
		PdS.L_nea__c = 'Rentas Vitalicias';
		insert PdS;

		Producto_del_Cliente__c PdC = new Producto_del_Cliente__c();
		PdC.Name = 'prod cliente';
		PdC.Producto_de_Seguros_Nectia__c = PdS.Id;
		PdC.Cliente_Nectia__c = cuenta.Id;
		PdC.Id__c = '1234514381623-0';
		PdC.Poliza_Nectia__c = '12345';
		PdC.Esquema_Nectia__c = 'INSUDB';
		PdC.Tipo_Registro_Nectia__c = '2';
		PdC.Ramo_Nectia__c = '1';
		PdC.Codigo_Plan_Nectia__c = '650';
		PdC.Numero_Certificado_Nectia__c = '0';
		insert PdC;

		Case caso = new Case();
		caso.Type	= 'Reclamo';
		caso.Subtipo__c = 'Descuento';
		caso.Clasificaci_n_del_Reclamo__c = 'Descuento Caja Compensación';
		caso.Status = 'Nuevo';
		caso.RecordTypeId = rtcas;
		caso.Producto_del_Cliente_Nectia__c = PdC.Id;
		caso.AccountId = cuenta.Id;
		insert caso;

		caso.Status = 'Cerrado';
		update caso;
	}

@isTest static void test_method_three() {
		
		Id rtcp = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
		Id rtcas = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Casos Seguros').getRecordTypeId();

		Account cuenta = new Account();
		cuenta.FirstName = 'cuenta';
		cuenta.LastName = 'cuenta';
		cuenta.RUT__c = '14381623-0';
		cuenta.RecordTypeId = rtcp;
		insert cuenta;

		Producto_de_Seguros__c PdS = new Producto_de_Seguros__c();
		PdS.Name = 'prod seguro';
		PdS.Codigo_de_Producto_nectia__c = '1000';
		PdS.Familia__c = 'Seguro Vida Accidentes Personales';
		PdS.L_nea__c = 'Rentas Vitalicias';
		insert PdS;

		Producto_del_Cliente__c PdC = new Producto_del_Cliente__c();
		PdC.Name = 'prod cliente';
		PdC.Producto_de_Seguros_Nectia__c = PdS.Id;
		PdC.Cliente_Nectia__c = cuenta.Id;
		PdC.Id__c = '1234514381623-0';
		PdC.Poliza_Nectia__c = '12345';
		PdC.Esquema_Nectia__c = 'INSUDB';
		PdC.Tipo_Registro_Nectia__c = '2';
		PdC.Ramo_Nectia__c = '1';
		PdC.Codigo_Plan_Nectia__c = '650';
		PdC.Numero_Certificado_Nectia__c = '0';
		insert PdC;

		Case caso = new Case();
		caso.Type	= 'Solicitud';
		caso.Subtipo__c = 'Modificación de Póliza';
		caso.Tipo_de_Modificaci_n__c = 'Beneficiarios';
		caso.Status = 'Nuevo';
		caso.RecordTypeId = rtcas;
		caso.Producto_del_Cliente_Nectia__c = PdC.Id;
		caso.AccountId = cuenta.Id;
		insert caso;

		caso.Status = 'Cerrado';
		update caso;
	}

@isTest static void test_method_four() {
		
		Id rtcp = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
		Id rtcas = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Casos Seguros').getRecordTypeId();

		Account cuenta = new Account();
		cuenta.FirstName = 'cuenta';
		cuenta.LastName = 'cuenta';
		cuenta.RUT__c = '14381623-0';
		cuenta.RecordTypeId = rtcp;
		insert cuenta;

		Producto_de_Seguros__c PdS = new Producto_de_Seguros__c();
		PdS.Name = 'prod seguro';
		PdS.Codigo_de_Producto_nectia__c = '1000';
		PdS.Familia__c = 'Seguro Vida Accidentes Personales';
		PdS.L_nea__c = 'Rentas Vitalicias';
		insert PdS;

		Producto_del_Cliente__c PdC = new Producto_del_Cliente__c();
		PdC.Name = 'prod cliente';
		PdC.Producto_de_Seguros_Nectia__c = PdS.Id;
		PdC.Cliente_Nectia__c = cuenta.Id;
		PdC.Id__c = '1234514381623-0';
		PdC.Poliza_Nectia__c = '12345';
		PdC.Esquema_Nectia__c = 'INSUDB';
		PdC.Tipo_Registro_Nectia__c = '2';
		PdC.Ramo_Nectia__c = '1';
		PdC.Codigo_Plan_Nectia__c = '650';
		PdC.Numero_Certificado_Nectia__c = '0';
		insert PdC;

		Case caso = new Case();
		caso.Type	= 'Solicitud';
		caso.Subtipo__c = 'Modificación de Póliza';
		caso.Clasificaci_n_de_Solicitud__c = 'Cambio de Liquidador Asignado';
		caso.Status = 'Nuevo';
		caso.RecordTypeId = rtcas;
		caso.Producto_del_Cliente_Nectia__c = PdC.Id;
		caso.AccountId = cuenta.Id;
		insert caso;

		caso.Status = 'Cerrado';
		update caso;
	}

@isTest static void test_method_five() {
		
		Id rtcp = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
		Id rtcas = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Casos Seguros').getRecordTypeId();

		Account cuenta = new Account();
		cuenta.FirstName = 'cuenta';
		cuenta.LastName = 'cuenta';
		cuenta.RUT__c = '14381623-0';
		cuenta.RecordTypeId = rtcp;
		insert cuenta;

		Producto_de_Seguros__c PdS = new Producto_de_Seguros__c();
		PdS.Name = 'prod seguro';
		PdS.Codigo_de_Producto_nectia__c = '1000';
		PdS.Familia__c = 'Seguro Vida Accidentes Personales';
		PdS.L_nea__c = 'Rentas Vitalicias';
		insert PdS;

		Producto_del_Cliente__c PdC = new Producto_del_Cliente__c();
		PdC.Name = 'prod cliente';
		PdC.Producto_de_Seguros_Nectia__c = PdS.Id;
		PdC.Cliente_Nectia__c = cuenta.Id;
		PdC.Id__c = '1234514381623-0';
		PdC.Poliza_Nectia__c = '12345';
		PdC.Esquema_Nectia__c = 'CLONINSUDB';
		PdC.Tipo_Registro_Nectia__c = '2';
		PdC.Ramo_Nectia__c = '1';
		PdC.Codigo_Plan_Nectia__c = '650';
		PdC.Numero_Certificado_Nectia__c = '0';
		insert PdC;

		Case caso = new Case();
		caso.Type	= 'Solicitud';
		caso.Subtipo__c = 'Modificación de Póliza';
		caso.Clasificaci_n_de_Solicitud__c = 'Cambio de Liquidador Asignado';
		caso.Status = 'Nuevo';
		caso.RecordTypeId = rtcas;
		caso.Producto_del_Cliente_Nectia__c = PdC.Id;
		caso.AccountId = cuenta.Id;
		insert caso;
		PageReference p;
    	CONS_Comunicaciones com = new CONS_Comunicaciones();
    	Test.setCurrentPageReference(new PageReference('Page.CONS_Comunicaciones'));
    system.debug('Caso en test: '+caso);
        System.currentPageReference().getParameters().put('id', caso.Id);
    	p = com.endosocomunicaciones();
		caso.Status = 'Cerrado';
		update caso;
	}

@isTest static void test_method_six() {
		
		Id rtcp = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
		Id rtcas = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Casos Seguros').getRecordTypeId();

		Account cuenta = new Account();
		cuenta.FirstName = 'cuenta';
		cuenta.LastName = 'cuenta';
		cuenta.RUT__c = '14381623-0';
		cuenta.RecordTypeId = rtcp;
		insert cuenta;

		Producto_de_Seguros__c PdS = new Producto_de_Seguros__c();
		PdS.Name = 'prod seguro';
		PdS.Codigo_de_Producto_nectia__c = '1000';
		PdS.Familia__c = 'Seguro Vida Accidentes Personales';
		PdS.L_nea__c = 'Rentas Vitalicias';
		insert PdS;

		Producto_del_Cliente__c PdC = new Producto_del_Cliente__c();
		PdC.Name = 'prod cliente';
		PdC.Producto_de_Seguros_Nectia__c = PdS.Id;
		PdC.Cliente_Nectia__c = cuenta.Id;
		PdC.Id__c = '1234514381623-0';
		PdC.Poliza_Nectia__c = '12345';
		PdC.Esquema_Nectia__c = 'CLONINSUDB';
		PdC.Tipo_Registro_Nectia__c = '2';
		PdC.Ramo_Nectia__c = '1';
		PdC.Codigo_Plan_Nectia__c = '650';
		PdC.Numero_Certificado_Nectia__c = '0';
		insert PdC;

		Case caso = new Case();
		caso.Type	= 'Solicitud';
		caso.Subtipo__c = 'Modificación de Póliza';
		caso.Tipo_de_Modificaci_n__c = 'Frecuencia de Pago';
		caso.Status = 'Nuevo';
		caso.RecordTypeId = rtcas;
		caso.Producto_del_Cliente_Nectia__c = PdC.Id;
		caso.AccountId = cuenta.Id;
		insert caso;
           
		/*PageReference p;
    	CONS_Comunicaciones com = new CONS_Comunicaciones();
    	Test.setCurrentPageReference(new PageReference('Page.CONS_Comunicaciones'));
        System.currentPageReference().getParameters().put('id', caso.Id);
    	p = com.endosocomunicaciones();*/
	}
    @isTest static void test_method_seven() {
		
		Id rtcp = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
		Id rtcas = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Casos Seguros').getRecordTypeId();

		Account cuenta = new Account();
		cuenta.FirstName = 'cuenta';
		cuenta.LastName = 'cuenta';
		cuenta.RUT__c = '14381623-0';
		cuenta.RecordTypeId = rtcp;
		insert cuenta;

		Producto_de_Seguros__c PdS = new Producto_de_Seguros__c();
		PdS.Name = 'prod seguro';
		PdS.Codigo_de_Producto_nectia__c = '600';
		PdS.Familia__c = 'APV';
		PdS.L_nea__c = 'Vida';
		insert PdS;

		Producto_del_Cliente__c PdC = new Producto_del_Cliente__c();
		PdC.Name = 'prod cliente';
		PdC.Producto_de_Seguros_Nectia__c = PdS.Id;
		PdC.Cliente_Nectia__c = cuenta.Id;
		PdC.Id__c = '1234514381623-0';
		PdC.Poliza_Nectia__c = '12345';
		PdC.Esquema_Nectia__c = 'CLONINSUDB';
		PdC.Tipo_Registro_Nectia__c = '2';
		PdC.Ramo_Nectia__c = '1';
		PdC.Codigo_Plan_Nectia__c = '650';
		PdC.Numero_Certificado_Nectia__c = '0';
		insert PdC;

		Case caso = new Case();
		caso.Type	= 'Solicitud';
		caso.Subtipo__c = 'Traspaso APV';
		caso.Status = 'Nuevo';
		caso.RecordTypeId = rtcas;
		caso.Producto_del_Cliente_Nectia__c = PdC.Id;
		caso.AccountId = cuenta.Id;
		insert caso;
           
		caso.Status = 'Cerrado';
         caso.Sub_estado_Nectia__c='Solucionado';
		update caso;  
	}
     @isTest static void test_method_eight() {
		
		Id rtcp = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
		Id rtcas = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Casos Seguros').getRecordTypeId();

		Account cuenta = new Account();
		cuenta.FirstName = 'cuenta';
		cuenta.LastName = 'cuenta';
		cuenta.RUT__c = '14381623-0';
		cuenta.RecordTypeId = rtcp;
		insert cuenta;

		Producto_de_Seguros__c PdS = new Producto_de_Seguros__c();
		PdS.Name = 'prod seguro';
		PdS.Codigo_de_Producto_nectia__c = '1000';
		PdS.Familia__c = 'APV';
		PdS.L_nea__c = 'Vida';
		insert PdS;

		Producto_del_Cliente__c PdC = new Producto_del_Cliente__c();
		PdC.Name = 'prod cliente';
		PdC.Producto_de_Seguros_Nectia__c = PdS.Id;
		PdC.Cliente_Nectia__c = cuenta.Id;
		PdC.Id__c = '1234514381623-0';
		PdC.Poliza_Nectia__c = '12345';
		PdC.Esquema_Nectia__c = 'CLONINSUDB';
		PdC.Tipo_Registro_Nectia__c = '2';
		PdC.Ramo_Nectia__c = '1';
		PdC.Codigo_Plan_Nectia__c = '650';
		PdC.Numero_Certificado_Nectia__c = '0';
		insert PdC;

		Case caso = new Case();
		caso.Type	= 'Solicitud';
		caso.Subtipo__c = 'Rescate';
        caso.Tipo_Rescate__c='2';
		caso.Status = 'Nuevo';
		caso.RecordTypeId = rtcas;
		caso.Producto_del_Cliente_Nectia__c = PdC.Id;
        caso.Forma_de_Pago__c ='Vale Vista';
		caso.AccountId = cuenta.Id;
		insert caso;
         
         
         caso.Status = 'Cerrado';
         caso.Sub_estado_Nectia__c='Solucionado';
		update caso;  
		
	}
         @isTest static void test_method_nine() {
		
		Id rtcp = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
		Id rtcas = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Casos Seguros').getRecordTypeId();

		Account cuenta = new Account();
		cuenta.FirstName = 'cuenta';
		cuenta.LastName = 'cuenta';
		cuenta.RUT__c = '14381623-0';
		cuenta.RecordTypeId = rtcp;
		insert cuenta;

		Producto_de_Seguros__c PdS = new Producto_de_Seguros__c();
		PdS.Name = 'prod seguro';
		PdS.Codigo_de_Producto_nectia__c = '1000';
		PdS.Familia__c = 'APV';
		PdS.L_nea__c = 'Vida';
		insert PdS;

		Producto_del_Cliente__c PdC = new Producto_del_Cliente__c();
		PdC.Name = 'prod cliente';
		PdC.Producto_de_Seguros_Nectia__c = PdS.Id;
		PdC.Cliente_Nectia__c = cuenta.Id;
		PdC.Id__c = '1234514381623-0';
		PdC.Poliza_Nectia__c = '12345';
		PdC.Esquema_Nectia__c = 'CLONINSUDB';
		PdC.Tipo_Registro_Nectia__c = '2';
		PdC.Ramo_Nectia__c = '1';
		PdC.Codigo_Plan_Nectia__c = '650';
		PdC.Numero_Certificado_Nectia__c = '0';
		insert PdC;

		Case caso = new Case();
		caso.Type	= 'Solicitud';
		caso.Subtipo__c = 'Rescate';
        caso.Tipo_Rescate__c='2';
		caso.Status = 'Nuevo';
		caso.RecordTypeId = rtcas;
		caso.Producto_del_Cliente_Nectia__c = PdC.Id;
        caso.Forma_de_Pago__c ='Vale Vista';
		caso.AccountId = cuenta.Id;
		insert caso;
         
         
             CONS_Comunicacionescierre.Reclamos_21dias(caso.id);
		
	}
          @isTest static void test_method_10() {
          CONS_EstructuraRescateCierre_JSON  cr=new CONS_EstructuraRescateCierre_JSON();
        string  str='{    "codigoViaPago": 2,    "diaPago": 20,    "codigoBanco": 2,   "numeroCuenta": "6656777785954444",    "mandatoPoliza": "13263",    "codigoTipoCuenta": 0,    "codigoTipoTarjeta": 3,    "fechaExpiracionTarjeta": "10-10-2023",    "fechaVigenciaTarjeta": "24-01-2019",    "frecuenciaPagos": 5,    "rutPagador": "00000014761486",    "digitoPagador": "1",    "nombrePagador": "iXWkzNRCKrdFtXAMatg",    "apellidoPPagador": "VDEaxEMBFKQciblMOkY",    "apellidoMPagador": "qvOPFDnvslfaiWVnnmk",    "fechaNaciminetoPagador": "17-02-1976",    "sexoPagador": "1",    "codigoEmpleador": 0,    "numeroCalle": 0,    "codigoComuna": 0,    "codigoCiudad": 0,    "codigo": 0}';
        cr=CONS_EstructuraRescateCierre_JSON.parse(str);    
              
          }
        @isTest static void test_method_11() {
          CONS_AlertaPinCierre_JSON  APC=new CONS_AlertaPinCierre_JSON();
        string  str='{    "codigoViaPago": 2,    "diaPago": 20,    "codigoBanco": 2,   "numeroCuenta": "6656777785954444",    "mandatoPoliza": "13263",    "codigoTipoCuenta": 0,    "codigoTipoTarjeta": 3,    "fechaExpiracionTarjeta": "10-10-2023",    "fechaVigenciaTarjeta": "24-01-2019",    "frecuenciaPagos": 5,    "rutPagador": "00000014761486",    "digitoPagador": "1",    "nombrePagador": "iXWkzNRCKrdFtXAMatg",    "apellidoPPagador": "VDEaxEMBFKQciblMOkY",    "apellidoMPagador": "qvOPFDnvslfaiWVnnmk",    "fechaNaciminetoPagador": "17-02-1976",    "sexoPagador": "1",    "codigoEmpleador": 0,    "numeroCalle": 0,    "codigoComuna": 0,    "codigoCiudad": 0,    "codigo": 0}';
        APC=CONS_AlertaPinCierre_JSON.parse(str);    
              
          }
}