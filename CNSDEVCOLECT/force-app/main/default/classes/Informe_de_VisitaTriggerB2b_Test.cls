/**
 * @description       : Test class of Informe_de_Visita__c object
 * @author            : ggonzroj@everis.com
 * @group             : 
 * @last modified on  : 11-02-2020
 * @last modified by  : ggonzroj@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   08-24-2020   ggonzroj@everis.com   Initial Version
**/
@isTest
public without sharing class Informe_de_VisitaTriggerB2b_Test {

    @testSetup static void dataloadB2B(){
        User iUserEjecutivoVenta = TestFactoryB2B.getUserEjecutivoComercialBE();
        insert iUserEjecutivoVenta;

        TestFactoryB2B.createConsorcioOrgB2B();

        CS_IntegracionesAndes__c apitoken = TestFactoryB2B.getCSIntegracionesAndes('GetTokenInformesAndes');
        insert apitoken;

        CS_IntegracionesAndes__c apiGenerarInfo = TestFactoryB2B.getCSIntegracionesAndes('GenerarInformesAndes');
        apiGenerarInfo.Active__c = false;
        insert apiGenerarInfo;
    } 

    @isTest
	private static void informeGeneradoFromLeadWithMensajeError (){
        User iUserEjecutivoVenta = [SELECT Id, RUT__c, UserRoleId FROM User WHERE RUT__c = '246232369' LIMIT 1];

        System.runAs(iUserEjecutivoVenta){
            Lead newLead2 = TestFactoryB2B.newLead(LeadTriggerHelperB2b.RT_LEAD_EMPRESA);
            newLead2.LastName = 'FactoryLead2';
            newLead2.Company = 'Company34569';
            newLead2.RUTEmpresa__c = '12315512345';
            newLead2.Actividad_Economica__c = 'H - COMERCIO AL POR MAYOR Y MENOR.';
            newLead2.LeadSource = 'Propio';
            newLead2.Status = LeadTriggerHelperB2b.LEAD_STATUS_EVALUACION;
            newLead2.rut_ejecutivo_sales__c = iUserEjecutivoVenta.RUT__c;
            newLead2.Etapa_Prospecto__c = LeadTriggerHelperB2b.LEAD_ETAPA_SIN_GESTION; 
            // Información adicional
            newLead2.Direccion_Oficina__c = '';
            newLead2.NumberOfEmployees = 0;
            // Deuda SBIF
            newLead2.SBIF_Comercial__c = 0;
            newLead2.SBIF_Contingente__c = null;
            newLead2.SBIF_Leasing__c = null;
            newLead2.Deuda_Achef__c = null;
            // Info financiera
            newLead2.Venta_Anual__c = null;
            newLead2.Deuda_Financiera__c = null;
            newLead2.Ebitda__c = null;
            newLead2.Utilidad__c = null;
            newLead2.Patrimonio__c = null;
            // Productos en los que opera
            newLead2.Creditos_comerciales__c = false;
            newLead2.Cuenta_Corriente__c = false;
            newLead2.Factoring__c = false;
            newLead2.Leasing__c = false;
            newLead2.Mesa_de_Dinero__c = false;
            newLead2.Comex__c = false;
            newLead2.Boletas_Garantia__c = false;
            newLead2.Cash_Management__c = false;
            newLead2.Financiamiento_Inmobiliario__c = false;
            newLead2.Nivel_de_Importaciones__c = null;
            newLead2.Giro_de_la_empresa__c = '';
            insert newLead2;

            Informe_de_Visita__c informe = TestFactoryB2B.newInformeVisita(Informe_de_VisitaTriggerHelperB2b.INFORMEDEVISITA_ESTADOENPROCESO);
            informe.Id_Informe_de_visita_Andes__c = '66734';
            informe.FechaProgramadaVisita__c = DateTime.now();
            informe.Id_Prospecto__c = newLead2.Id;
            insert informe;

            Test.startTest();     
                Informe_de_Visita__c info = [SELECT Id, Id_Prospecto__c, 
                                                Account__c, Estado__c, 
                                                IsSentBtnAndes__c,
                                                FechaProgramadaVisita__c, 
                                                IsInformeVisitaAccount__c 
                                            FROM Informe_de_Visita__c WHERE Id =: informe.Id LIMIT 1];
                Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorOK());
                try {
                    Map<String,Object> mpInformesAndesCmp = CrearInformesGeneradosAndesCtrl.procesaEnvioInformesAndes(informe.Id);
                } catch (Exception ex) {
                    System.assertEquals(ex.getMessage().contains('-Ingrese RUT de la Cuenta') , true);
                }
            Test.stopTest();

            Informe_de_Visita__c informeUpdated = [SELECT Id, Estado__c, IsSentBtnAndes__c FROM Informe_de_Visita__c WHERE Id =: informe.Id LIMIT 1];
            System.assertEquals(false, informeUpdated.IsSentBtnAndes__c);
        }
    }

    @isTest
	private static void informeGeneradoFromLeadOK(){
        User iUserEjecutivoVenta = [SELECT Id, RUT__c, UserRoleId FROM User WHERE RUT__c = '246232369' LIMIT 1];

        CS_IntegracionesAndes__c apiGenerarInfo = TestFactoryB2B.getCSIntegracionesAndes('GenerarInformesAndes');
        apiGenerarInfo.Active__c = true;
        insert apiGenerarInfo;

        System.runAs(iUserEjecutivoVenta){
            Lead newLead2 = TestFactoryB2B.newLead(LeadTriggerHelperB2b.RT_LEAD_EMPRESA);
            newLead2.LastName = 'FactoryLead2';
            newLead2.Company = 'Company34569';
            newLead2.RUTEmpresa__c = '12315512345';
            newLead2.Actividad_Economica__c = 'H - COMERCIO AL POR MAYOR Y MENOR.';
            newLead2.LeadSource = 'Propio';
            newLead2.Status = LeadTriggerHelperB2b.LEAD_STATUS_EVALUACION;
            newLead2.rut_ejecutivo_sales__c = iUserEjecutivoVenta.RUT__c;
            newLead2.Etapa_Prospecto__c = LeadTriggerHelperB2b.LEAD_ETAPA_SIN_GESTION;  // 'Pendiente Informe Visita';

            // Información adicional
            newLead2.Direccion_Oficina__c = 'Diez de Julio';
            newLead2.NumberOfEmployees = 10;

            // Deuda SBIF
            newLead2.SBIF_Comercial__c = 4000000;
            newLead2.SBIF_Contingente__c = 5000000;
            newLead2.SBIF_Leasing__c = 2000000;
            newLead2.Deuda_Achef__c = 1000000;

            // Info financiera
            newLead2.Venta_Anual__c = 15000000;
            newLead2.Deuda_Financiera__c = 5000000;
            newLead2.Ebitda__c = 1000000;
            newLead2.Utilidad__c = 8000000;
            newLead2.Patrimonio__c = 60000000;

            // Productos en los que opera
            newLead2.Creditos_comerciales__c = true;
            newLead2.Cuenta_Corriente__c = false;
            newLead2.Factoring__c = false;
            newLead2.Leasing__c = false;
            newLead2.Mesa_de_Dinero__c = false;
            newLead2.Comex__c = false;
            newLead2.Boletas_Garantia__c = false;
            newLead2.Cash_Management__c = true;
            newLead2.Financiamiento_Inmobiliario__c = false;

            newLead2.Nivel_de_Importaciones__c = 290000000;
            newLead2.Giro_de_la_empresa__c = 'Giro de Empresa A';

            insert newLead2;

            Dato_Complementarios__c dcCtc = new Dato_Complementarios__c();
            dcCtc.RecordTypeId = DatoComplementarioTriggerHelperB2b.getRecordTypeId(DatoComplementarioTriggerHelperB2b.DC_RTYPE_CONTACTO_DEVELOPERNAME);
            dcCtc.Name = 'GONZALO SANCHEZx';
            dcCtc.Rut__c = '13026366-6';
            dcCtc.Contacto_Principal__c = true;
            dcCtc.Id_Prospecto__c = newLead2.Id;
            dcCtc.Apellido__c = 'apee1';
            dcCtc.Participacion__c = 5;
            dcCtc.Estado__c = 'Activo';
            insert dcCtc;

            Dato_Complementarios__c dcSocio = new Dato_Complementarios__c();
            dcSocio.RecordTypeId = DatoComplementarioTriggerHelperB2b.getRecordTypeId(DatoComplementarioTriggerHelperB2b.DC_RTYPE_SOCIO_DEVELOPERNAME);
            dcSocio.Contacto_Principal__c = false;
            dcSocio.Id_Prospecto__c = newLead2.Id;
            dcSocio.Apellido__c = 'apee2';
            dcSocio.Participacion__c = 5;
            dcSocio.Estado__c = 'Activo';
            insert dcSocio;

            Dato_Complementarios__c dcClient = new Dato_Complementarios__c();
            dcClient.RecordTypeId = DatoComplementarioTriggerHelperB2b.getRecordTypeId(DatoComplementarioTriggerHelperB2b.DC_RTYPE_CLIENTE_DEVELOPERNAME);
            dcClient.Contacto_Principal__c = false;
            dcClient.Id_Prospecto__c = newLead2.Id;
            dcClient.Apellido__c = 'apee3';
            dcClient.Estado__c = 'Activo';
            dcClient.Rubro__c = 'Rubro 1';
            insert dcClient;

            Dato_Complementarios__c dcProveedor = new Dato_Complementarios__c();
            dcProveedor.RecordTypeId = DatoComplementarioTriggerHelperB2b.getRecordTypeId(DatoComplementarioTriggerHelperB2b.DC_RTYPE_PROVEEDORES_DEVELOPERNAME);
            dcProveedor.Contacto_Principal__c = false;
            dcProveedor.Id_Prospecto__c = newLead2.Id;
            dcProveedor.Apellido__c = 'apee4';
            dcProveedor.Estado__c = 'Activo';
            dcProveedor.Rubro__c = 'Rubro 2';
            insert dcProveedor;

            Linea_Bancaria__c lbancarias = new Linea_Bancaria__c();
            lbancarias.Id_Prospecto__c = newLead2.Id;
            insert lbancarias;

            Informe_de_Visita__c informe = TestFactoryB2B.newInformeVisita(Informe_de_VisitaTriggerHelperB2b.INFORMEDEVISITA_ESTADOENPROCESO);
            informe.Id_Informe_de_visita_Andes__c = '66734';
            informe.FechaProgramadaVisita__c = DateTime.now();
            informe.Id_Prospecto__c = newLead2.Id;
            insert informe;

            Test.startTest();     
                Informe_de_Visita__c info = [SELECT Id, Id_Prospecto__c, 
                                                Account__c, Estado__c, 
                                                IsSentBtnAndes__c,
                                                FechaProgramadaVisita__c, 
                                                IsInformeVisitaAccount__c 
                                            FROM Informe_de_Visita__c WHERE Id =: informe.Id LIMIT 1];
                Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorOK());
                Map<String,Object> mpInformesAndesCmp = CrearInformesGeneradosAndesCtrl.procesaEnvioInformesAndes(informe.Id);
            Test.stopTest();

            Informe_de_Visita__c informeUpdated = [SELECT Id, Estado__c, IsSentBtnAndes__c FROM Informe_de_Visita__c WHERE Id =: informe.Id LIMIT 1];
            System.assertEquals(true, informeUpdated.IsSentBtnAndes__c);
            System.assertEquals(Informe_de_VisitaTriggerHelperB2b.INFORMEDEVISITA_ESTADOGENERADO, informeUpdated.Estado__c);
        }
    }


    @isTest
	private static void informeGeneradoFromAccountOK(){
        User iUserEjecutivoVenta = [SELECT Id, RUT__c, UserRoleId FROM User WHERE RUT__c = '246232369' LIMIT 1];

        CS_IntegracionesAndes__c apiGenerarInfo = TestFactoryB2B.getCSIntegracionesAndes('GenerarInformesAndes');
        apiGenerarInfo.Active__c = true;
        insert apiGenerarInfo;

        System.runAs(iUserEjecutivoVenta){
            Account newAccount = TestFactoryB2B.newAccount('1-9','Baccount', AccountTriggerHelperB2B.getRecordTypeId(AccountTriggerHelperB2B.RT_ACCOUNT_EMPRESA_BANCO));
            newAccount.Rut_Ejecutivo_Banco__c  = '17961022-1';
            newAccount.NumberOfEmployees       = 2; 
            newAccount.Venta_Anual__c          = 100;
            newAccount.Ebitda__c               = 2;
            newAccount.Utilidad__c             = 3;
            newAccount.Patrimonio__c           = 400;
            newAccount.Moneda__c               = 'CLP';
            newAccount.Cuenta_Corriente__c     = true;
            insert  newAccount;
            
            Contact newContact = TestFactoryB2B.newContact('Apellido 1', true,newAccount.Id);
            insert newContact;

            Contact newContact2 = TestFactoryB2B.newContact('Apellido 2', false,newAccount.Id);
            insert newContact2;

            Dato_Complementarios__c dcSocio = new Dato_Complementarios__c();
            dcSocio.RecordTypeId = DatoComplementarioTriggerHelperB2b.getRecordTypeId(DatoComplementarioTriggerHelperB2b.DC_RTYPE_SOCIO_DEVELOPERNAME);
            dcSocio.Contacto_Principal__c = false;
            dcSocio.Account__c = newAccount.Id;
            dcSocio.Apellido__c = 'apee2';
            dcSocio.Participacion__c = 5;
            dcSocio.Estado__c = 'Activo';
            dcSocio.Rut__c  = '1-9';
            insert dcSocio;

            Dato_Complementarios__c dcClient = new Dato_Complementarios__c();
            dcClient.RecordTypeId = DatoComplementarioTriggerHelperB2b.getRecordTypeId(DatoComplementarioTriggerHelperB2b.DC_RTYPE_CLIENTE_DEVELOPERNAME);
            dcClient.Contacto_Principal__c = false;
            dcClient.Account__c = newAccount.Id;
            dcClient.Apellido__c = 'apee3';
            dcClient.Estado__c = 'Activo';
            dcClient.Rubro__c = 'Rubro 1';
            insert dcClient;

            Dato_Complementarios__c dcProveedor = new Dato_Complementarios__c();
            dcProveedor.RecordTypeId = DatoComplementarioTriggerHelperB2b.getRecordTypeId(DatoComplementarioTriggerHelperB2b.DC_RTYPE_PROVEEDORES_DEVELOPERNAME);
            dcProveedor.Contacto_Principal__c = false;
            dcProveedor.Account__c = newAccount.Id;
            dcProveedor.Apellido__c = 'apee4';
            dcProveedor.Estado__c = 'Activo';
            dcProveedor.Rubro__c = 'Rubro 2';
            insert dcProveedor;

            Linea_Bancaria__c lbancarias = new Linea_Bancaria__c();
            lbancarias.Account__c = newAccount.Id;
            lbancarias.Banco__c = 'Banco Consorcio';
            lbancarias.Monto_Aprobado__c = 2;
            lbancarias.Monto_Utilizado__c = 1;
            insert lbancarias;

            Informe_de_Visita__c informe = TestFactoryB2B.newInformeVisita(Informe_de_VisitaTriggerHelperB2b.INFORMEDEVISITA_ESTADOENPROCESO);
            informe.Id_Informe_de_visita_Andes__c = '66734';
            informe.FechaProgramadaVisita__c = DateTime.now();
            informe.Account__c = newAccount.Id;
            insert informe;

            Test.startTest();     
                Informe_de_Visita__c info = [SELECT Id, Id_Prospecto__c, 
                                                Account__c, Estado__c, 
                                                IsSentBtnAndes__c,
                                                FechaProgramadaVisita__c, 
                                                IsInformeVisitaAccount__c 
                                            FROM Informe_de_Visita__c WHERE Id =: informe.Id LIMIT 1];

                Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorOK());
                Map<String,Object> mpInformesAndesCmp = CrearInformesGeneradosAndesCtrl.procesaEnvioInformesAndes(informe.Id);
            Test.stopTest();
        }
    }


    @isTest
	private static void informeGeneradoFromAccountWithMensajeError (){
        User iUserEjecutivoVenta = [SELECT Id, RUT__c, UserRoleId FROM User WHERE RUT__c = '246232369' LIMIT 1];

        System.runAs(iUserEjecutivoVenta){
            Account newAccount = TestFactoryB2B.newAccount('1-9','Baccount', AccountTriggerHelperB2B.getRecordTypeId(AccountTriggerHelperB2B.RT_ACCOUNT_EMPRESA_BANCO));
            newAccount.RUT__c                     = null;
            newAccount.Calle_Nectia__c            = null;
            insert  newAccount;
            
            Contact newContact = TestFactoryB2B.newContact('Apellido 1', true,newAccount.Id);
            insert newContact;

            Contact newContact2 = TestFactoryB2B.newContact('Apellido 2', false,newAccount.Id);
            insert newContact2;

            Dato_Complementarios__c dcSocio = new Dato_Complementarios__c();
            dcSocio.RecordTypeId = DatoComplementarioTriggerHelperB2b.getRecordTypeId(DatoComplementarioTriggerHelperB2b.DC_RTYPE_SOCIO_DEVELOPERNAME);
            dcSocio.Contacto_Principal__c = false;
            dcSocio.Account__c = newAccount.Id;
            dcSocio.Apellido__c = 'apee2';
            dcSocio.Participacion__c = 0;
            dcSocio.Estado__c = 'Activo';
            dcSocio.Rut__c  = '';
            insert dcSocio;

            Linea_Bancaria__c lbancarias = new Linea_Bancaria__c();
            lbancarias.Account__c = newAccount.Id;
            insert lbancarias;

            Informe_de_Visita__c informe = TestFactoryB2B.newInformeVisita(Informe_de_VisitaTriggerHelperB2b.INFORMEDEVISITA_ESTADOENPROCESO);
            informe.Id_Informe_de_visita_Andes__c = '66734';
            informe.FechaProgramadaVisita__c = DateTime.now();
            informe.Account__c = newAccount.Id;
            insert informe;

            Test.startTest();     
                Informe_de_Visita__c info = [SELECT Id, Id_Prospecto__c, 
                                                Account__c, Estado__c, 
                                                IsSentBtnAndes__c,
                                                FechaProgramadaVisita__c, 
                                                IsInformeVisitaAccount__c 
                                            FROM Informe_de_Visita__c WHERE Id =: informe.Id LIMIT 1];

                Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorOK());
                
                try {
                    Map<String,Object> mpInformesAndesCmp = CrearInformesGeneradosAndesCtrl.procesaEnvioInformesAndes(informe.Id);
                } catch (Exception ex) {
                    System.assertEquals(ex.getMessage().contains('-Ingrese RUT de la Cuenta') , true);
                }
            Test.stopTest();

            Informe_de_Visita__c informeUpdated = [SELECT Id, Estado__c, IsSentBtnAndes__c FROM Informe_de_Visita__c WHERE Id =: informe.Id LIMIT 1];
            System.assertEquals(false, informeUpdated.IsSentBtnAndes__c);
            // System.assertEquals(Informe_de_VisitaTriggerHelperB2b.INFORMEDEVISITA_ESTADOGENERADO, informeUpdated.Estado__c);
        }
    }


    @isTest
	private static void informeGeneradoServiceNotActive(){
        User iUserEjecutivoVenta = [SELECT Id, RUT__c, UserRoleId FROM User WHERE RUT__c = '246232369' LIMIT 1];

        System.runAs(iUserEjecutivoVenta){
            Account newAccount = TestFactoryB2B.newAccount('1-9','Baccount', AccountTriggerHelperB2B.getRecordTypeId(AccountTriggerHelperB2B.RT_ACCOUNT_EMPRESA_BANCO));
            newAccount.Rut_Ejecutivo_Banco__c  = '17961022-1';
            newAccount.NumberOfEmployees       = 2; 
            newAccount.Venta_Anual__c          = 100;
            newAccount.Ebitda__c               = 2;
            newAccount.Utilidad__c             = 3;
            newAccount.Patrimonio__c           = 400;
            newAccount.Moneda__c               = 'CLP';
            newAccount.Cuenta_Corriente__c     = true;
            insert  newAccount;
            
            Contact newContact = TestFactoryB2B.newContact('Apellido 1', true,newAccount.Id);
            insert newContact;

            Contact newContact2 = TestFactoryB2B.newContact('Apellido 2', false,newAccount.Id);
            insert newContact2;

            Dato_Complementarios__c dcSocio = new Dato_Complementarios__c();
            dcSocio.RecordTypeId = DatoComplementarioTriggerHelperB2b.getRecordTypeId(DatoComplementarioTriggerHelperB2b.DC_RTYPE_SOCIO_DEVELOPERNAME);
            dcSocio.Contacto_Principal__c = false;
            dcSocio.Account__c = newAccount.Id;
            dcSocio.Apellido__c = 'apee2';
            dcSocio.Participacion__c = 5;
            dcSocio.Estado__c = 'Activo';
            dcSocio.Rut__c  = '1-9';
            insert dcSocio;

            Dato_Complementarios__c dcClient = new Dato_Complementarios__c();
            dcClient.RecordTypeId = DatoComplementarioTriggerHelperB2b.getRecordTypeId(DatoComplementarioTriggerHelperB2b.DC_RTYPE_CLIENTE_DEVELOPERNAME);
            dcClient.Contacto_Principal__c = false;
            dcClient.Account__c = newAccount.Id;
            dcClient.Apellido__c = 'apee3';
            dcClient.Estado__c = 'Activo';
            dcClient.Rubro__c = 'Rubro 1';
            insert dcClient;

            Dato_Complementarios__c dcProveedor = new Dato_Complementarios__c();
            dcProveedor.RecordTypeId = DatoComplementarioTriggerHelperB2b.getRecordTypeId(DatoComplementarioTriggerHelperB2b.DC_RTYPE_PROVEEDORES_DEVELOPERNAME);
            dcProveedor.Contacto_Principal__c = false;
            dcProveedor.Account__c = newAccount.Id;
            dcProveedor.Apellido__c = 'apee4';
            dcProveedor.Estado__c = 'Activo';
            dcProveedor.Rubro__c = 'Rubro 2';
            insert dcProveedor;

            Linea_Bancaria__c lbancarias = new Linea_Bancaria__c();
            lbancarias.Account__c = newAccount.Id;
            lbancarias.Banco__c = 'Banco Consorcio';
            lbancarias.Monto_Aprobado__c = 2;
            lbancarias.Monto_Utilizado__c = 1;
            insert lbancarias;

            Informe_de_Visita__c informe = TestFactoryB2B.newInformeVisita(Informe_de_VisitaTriggerHelperB2b.INFORMEDEVISITA_ESTADOENPROCESO);
            informe.Id_Informe_de_visita_Andes__c = '66734';
            informe.FechaProgramadaVisita__c = DateTime.now();
            informe.Account__c = newAccount.Id;
            insert informe;

            Test.startTest();     
                Informe_de_Visita__c info = [SELECT Id, Id_Prospecto__c, 
                                                Account__c, Estado__c, 
                                                IsSentBtnAndes__c,
                                                FechaProgramadaVisita__c, 
                                                IsInformeVisitaAccount__c 
                                            FROM Informe_de_Visita__c WHERE Id =: informe.Id LIMIT 1];

                Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorOK());
                Map<String,Object> mpInformesAndesCmp = CrearInformesGeneradosAndesCtrl.procesaEnvioInformesAndes(informe.Id);
            Test.stopTest();

            Informe_de_Visita__c informeUpdated = [SELECT Id, Estado__c, IsSentBtnAndes__c FROM Informe_de_Visita__c WHERE Id =: informe.Id LIMIT 1];
            System.assertEquals(true, informeUpdated.IsSentBtnAndes__c);
        }
    }


    public class MockHttpResponseGeneratorOK implements HttpCalloutMock{
        public HTTPResponse respond(HTTPRequest req) {   
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setHeader('Cache-Control', 'no-cache');
            res.setHeader('codigoAplicacion','116');
            res.setHeader('empresaAplicacion','Interno');
            res.setHeader('ipCliente','127.0.0.1');
            res.setHeader('codigoCanal','2');
            res.setHeader('modalidad','consultar');
            res.setBody('{"dtoResponseCodigosEstadoHttp":{"codigo":"200","mensaje":"OK","descripcion":"OK"},"dtoResponseSetResultados":{"codigoSalida":1,"mensajeSalida":"Se ha agregado de forma exitosa una visita con el siguiente identificador: 18293"}}');
            res.setStatusCode(200);
            return res;
        }
    }

     

}