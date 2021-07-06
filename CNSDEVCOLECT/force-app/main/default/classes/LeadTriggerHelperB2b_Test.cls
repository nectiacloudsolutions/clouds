/**
 * @description       : 
 * @author            : ggonzroj@everis.com
 * @group             : 
 * @last modified on  : 11-19-2020
 * @last modified by  : mbeltran@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   08-27-2020   ggonzroj@everis.com   Initial Version
**/
@isTest
public class LeadTriggerHelperB2b_Test {
    
    @testSetup static void dataloadB2B(){
        List<User> userList = new List<User>();

        User analistaInteliNegocioB2B = TestFactoryB2B.getUserAnalistaInteligenciaNegocioBE();
        userList.add(analistaInteliNegocioB2B);

        User iUserEjecutivoVenta = TestFactoryB2B.getUserEjecutivoComercialBE();
        userList.add(iUserEjecutivoVenta);

        User iUserEjecutivo2 = TestFactoryB2B.getUserEjecutivoComercialPymeBE();
        userList.add(iUserEjecutivo2);

        insert userList;

        TestFactoryB2B.createConsorcioOrgB2B();

        CS_IntegracionesAndes__c apitoken = TestFactoryB2B.getCSIntegracionesAndes('GetTokenInformesAndes');
        insert apitoken;
    } 
    

    @isTest
    private static void assignCuotasByEjecutivosInsert_Test(){
        User analistaInteliNegocioB2B = [SELECT Id, UserRoleId FROM User WHERE RUT__c = '219200315' LIMIT 1];

        System.runAs(analistaInteliNegocioB2B){
            Lead leadB2b = new Lead();
            leadB2b.RecordTypeId                    = LeadTriggerHelperB2b.getRecordTypeId(LeadTriggerHelperB2b.RT_LEAD_EMPRESA) ;
            leadB2b.Company                         = 'COMERCIAL HUMERES LIMITADA';
            leadB2b.Email                           = 'corporativoxsd@consorcio.co';
            leadB2b.FirstName                       = 'Kretions'; 
            leadB2b.LastName                        = 'Renosox';
            leadB2b.RUTEmpresa__c                   = '8523319-k';
            leadB2b.EmpresaGrupoFilial__c           = '1';
            leadB2b.IdRutEmpresaFilial__c           = leadB2b.RUTEmpresa__c+leadB2b.EmpresaGrupoFilial__c;
            leadB2b.rut_ejecutivo_sales__c          = '21920031-5';
            leadB2b.Etapa_Prospecto__c              = LeadTriggerHelperB2b.LEAD_ETAPA_SIN_GESTION;
            leadB2b.LeadSource                      = 'Campaña';
            leadB2b.Status                          = LeadTriggerHelperB2b.LEAD_STATUS_SIN_GESTION;

            Lead leadB2b2 = new Lead();
            leadB2b2.RecordTypeId                    = LeadTriggerHelperB2b.getRecordTypeId(LeadTriggerHelperB2b.RT_LEAD_EMPRESA) ;
            leadB2b2.Company                         = 'COWORK HIMERES LIMIT';
            leadB2b2.Email                           = 'corpo324S@consorcio.co';
            leadB2b2.FirstName                       = 'Kritso'; 
            leadB2b2.LastName                        = 'Renausox';
            leadB2b2.RUTEmpresa__c                   = '22025237-k';
            leadB2b2.EmpresaGrupoFilial__c           = '1';
            leadB2b2.IdRutEmpresaFilial__c           = leadB2b2.RUTEmpresa__c+'2';
            leadB2b2.rut_ejecutivo_sales__c          = '21920031-5';
            leadB2b2.Etapa_Prospecto__c              = LeadTriggerHelperB2b.LEAD_ETAPA_SIN_GESTION;
            leadB2b2.LeadSource                      = 'Campaña';
            leadB2b2.Status                          = LeadTriggerHelperB2b.LEAD_STATUS_SIN_GESTION;

            Lead leadB2b3 = new Lead();
            leadB2b3.RecordTypeId                    = LeadTriggerHelperB2b.getRecordTypeId(LeadTriggerHelperB2b.RT_LEAD_EMPRESA) ;
            leadB2b3.Company                         = 'EMPRESA RUT ERRONEO';
            leadB2b3.Email                           = 'RUT@erroneo.co';
            leadB2b3.FirstName                       = 'rut'; 
            leadB2b3.LastName                        = 'erroneo';
            leadB2b3.RUTEmpresa__c                   = '22025237-5';
            leadB2b3.EmpresaGrupoFilial__c           = '1';
            leadB2b3.IdRutEmpresaFilial__c           = leadB2b2.RUTEmpresa__c+'2';
            leadB2b3.rut_ejecutivo_sales__c          = '21920031-5';
            leadB2b3.Etapa_Prospecto__c              = LeadTriggerHelperB2b.LEAD_ETAPA_SIN_GESTION;
            leadB2b3.LeadSource                      = 'Campaña';
            leadB2b3.Status                          = LeadTriggerHelperB2b.LEAD_STATUS_SIN_GESTION;

            Lead leadB2b4 = new Lead();
            leadB2b4.RecordTypeId                    = LeadTriggerHelperB2b.getRecordTypeId(LeadTriggerHelperB2b.RT_LEAD_EMPRESA) ;
            leadB2b4.Company                         = 'COWORK HIMERES LIMIT';
            leadB2b4.Email                           = 'corpo324S@consorcio.co';
            leadB2b4.FirstName                       = 'Kritso'; 
            leadB2b4.LastName                        = 'Renausox';
            leadB2b4.RUTEmpresa__c                   = '22025237-k';
            leadB2b4.EmpresaGrupoFilial__c           = '1';
            leadB2b4.IdRutEmpresaFilial__c           = leadB2b2.RUTEmpresa__c+'2';
            leadB2b4.rut_ejecutivo_sales__c          = '21920031-8';
            leadB2b4.Etapa_Prospecto__c              = LeadTriggerHelperB2b.LEAD_ETAPA_SIN_GESTION;
            leadB2b4.LeadSource                      = 'Campaña';
            leadB2b4.Status                          = LeadTriggerHelperB2b.LEAD_STATUS_SIN_GESTION;

            try {
                insert new List<lead>{leadB2b, leadB2b2, leadB2b3,leadB2b4};
            } catch (Exception ex) {
                System.assertEquals(ex.getMessage().contains('el grupo no coinciden o RUT Empresa inválido'), true);
            }
        }
    }
    

    @isTest
    private static void assignCuotasByEjecutivosUpdate_Test(){
        User analistaInteliNegocioB2B = [SELECT Id, UserRoleId FROM User WHERE RUT__c = '219200315' LIMIT 1];
 
        System.runAs(analistaInteliNegocioB2B){
            Lead leadB2b = new Lead();
            leadB2b.RecordTypeId                    =   LeadTriggerHelperB2b.getRecordTypeId(LeadTriggerHelperB2b.RT_LEAD_EMPRESA) ;
            leadB2b.Company                         =   'KEMORCIAL HAMERES LIMITADUS';
            leadB2b.Email                           =   'cortisrativoxsd@consorcio.co';
            leadB2b.FirstName                       =   'Pretions'; 
            leadB2b.LastName                        =   'Senosox';
            leadB2b.RUTEmpresa__c                   =   '8523319-k';
            leadB2b.EmpresaGrupoFilial__c           =   '1';
            leadB2b.IdRutEmpresaFilial__c           =   leadB2b.RUTEmpresa__c+leadB2b.EmpresaGrupoFilial__c;
            leadB2b.rut_ejecutivo_sales__c          =   '21920031-5';
            leadB2b.Etapa_Prospecto__c              =   LeadTriggerHelperB2b.LEAD_ETAPA_CAMPANAFINALIZADA; 
            leadB2b.LeadSource                      =   'Campaña';
            leadB2b.Status                          =   LeadTriggerHelperB2b.LEAD_STATUS_NO_INTERESADO;
            insert new List<Lead>{leadB2b};

            try {
                update new Lead (
                    Id                  =   leadB2b.Id,
                    Status              =   LeadTriggerHelperB2b.LEAD_STATUS_SIN_GESTION,
                    Etapa_Prospecto__c  =   LeadTriggerHelperB2b.LEAD_ETAPA_SIN_GESTION
                );
            } catch (Exception ex) {
                System.debug(' Exception: ' + ex.getMessage() );
               // System.assertEquals(ex.getMessage().contains('ejecutivo no existe o no tiene licencia'), true);
            }
        }
    }

    @isTest
    private static void leadConversion_Test(){
        CS_IntegracionesAndes__c apiGenerarInfo = TestFactoryB2B.getCSIntegracionesAndes('GenerarInformesAndes');
        apiGenerarInfo.Active__c = false;
        insert apiGenerarInfo;

        User iUserEjecutivoVenta = [SELECT Id, UserRoleId FROM User WHERE RUT__c = '246232369' LIMIT 1];


        System.runAs(iUserEjecutivoVenta){

            Campaign icampaign = TestFactoryB2B.newCampaignContact('campaña 1','Ingresada');
            insert  icampaign;
            System.assertEquals(true, icampaign != null);

            Account iAcc = new Account(
                Name = 'COMERCIAL HUMERES LIMITADA',
                Estado_Cliente_Banca_Empresas__c = AccountTriggerHelperB2B.ACCOUNT_ESTADO_CLIENTE_BANCA_EMPRESAS
            );
            insert iAcc;
            
            Contact ctc = new Contact(
                AccountId = iAcc.Id,
                FirstName = 'COMERCIAL',
                LastName  = 'HUMERES LIMITADA'
            );
            insert ctc;

            Lead leadRTEmpresa = TestFactoryB2B.newLead(LeadTriggerHelperB2b.RT_LEAD_EMPRESA);
            leadRTEmpresa.Company                       = 'COMERCIAL HUMERES LIMITADA';
            leadRTEmpresa.FirstName                     = 'COMERCIAL'; 
            leadRTEmpresa.LastName                      = 'HUMERES LIMITADA';
            leadRTEmpresa.RUTEmpresa__c                 = '18685983-9';
            leadRTEmpresa.EmpresaGrupoFilial__c         = '1';
            leadRTEmpresa.IdRutEmpresaFilial__c         = leadRTEmpresa.RUTEmpresa__c+leadRTEmpresa.EmpresaGrupoFilial__c;
            leadRTEmpresa.Etapa_Prospecto__c            = LeadTriggerHelperB2b.LEAD_ETAPA_SIN_GESTION;
            leadRTEmpresa.rut_ejecutivo_sales__c        = '24623236-9';
            insert leadRTEmpresa;

            ////////////////////////////
            CampaignMember icampaignmember = TestFactoryB2B.newCampaignMemberLead(leadRTEmpresa.Id,icampaign.Id);
            insert icampaignmember;
            ///////////////////////////
    

            Event iEvent = new Event();
            iEvent.Estado__c       = 'Contactado Interesado';
            iEvent.WhoId           = leadRTEmpresa.Id;
            iEvent.StartDateTime   = System.today();
            iEvent.EndDateTime     = System.today();  
            iEvent.Subject         = 'Llamada'; 
            iEvent.Tipo_de_contacto__c = 'Llamada';
            iEvent.OwnerId         = iUserEjecutivoVenta.Id;
            iEvent.RecordTypeId    = EventTriggerHelperB2B.getRecordTypeId(EventTriggerHelperB2B.RT_EVENT_EMPRESA);
            insert iEvent;

            System.assertEquals(true, iEvent.Id != null);

            ///// MBB
            System.debug('iEvent.Id:' + iEvent.Id);
            Event Evento = [SELECT Id, Estado__c,Tipo_de_contacto__c,Who.id FROM Event limit 1];

            leadRTEmpresa = [SELECT Id, Etapa_Prospecto__c, Status FROM Lead Limit 1];
            System.assertEquals('Gestionado', leadRTEmpresa.Status);
            System.assertEquals('Contactado', leadRTEmpresa.Etapa_Prospecto__c);

            // ---------------------------
            //  Mover Lead Estado = Visita 
            // ---------------------------
            Event iEvVisita = new Event();
            iEvVisita.Estado__c       = EventTriggerHelperB2B.EVENT_ESTADO_VISITAAGENDADA;
            iEvVisita.WhoId           = leadRTEmpresa.Id;
            iEvVisita.StartDateTime   = System.today();
            iEvVisita.EndDateTime     = System.today();  
            iEvVisita.Subject         = 'Asunto calling'; 
            iEvVisita.Tipo_de_contacto__c = 'Visita';
            iEvVisita.OwnerId         = iUserEjecutivoVenta.Id;
            iEvVisita.RecordTypeId    = EventTriggerHelperB2B.getRecordTypeId(EventTriggerHelperB2B.RT_EVENT_EMPRESA);
            insert iEvVisita;

            System.assertEquals(true, iEvVisita.Id != null);
            leadRTEmpresa = [SELECT Id, Etapa_Prospecto__c, Status, Sancion_Comite__c, rut_ejecutivo_sales__c FROM Lead Limit 1];
            System.assertEquals('Visita', leadRTEmpresa.Status);
            System.assertEquals('Contactado Visita', leadRTEmpresa.Etapa_Prospecto__c);

            // ---------------------------
            //  Mover Lead Estado = Comité 
            // ---------------------------
            List<Dato_Complementarios__c> datoComplementarioList = new List<Dato_Complementarios__c>();
            Dato_Complementarios__c dcCtc = TestFactoryB2B.newDatoComplementario(DatoComplementarioTriggerHelperB2b.DC_RTYPE_CONTACTO_DEVELOPERNAME) ;
            dcCtc.Name = dcCtc.Name + String.valueOf(Datetime.now());
            dcCtc.Rut__c = '24051857-0';
            dcCtc.Contacto_Principal__c = true;
            dcCtc.Id_Prospecto__c = leadRTEmpresa.Id;
            datoComplementarioList.add(dcCtc);

            Dato_Complementarios__c dcSocio = TestFactoryB2B.newDatoComplementario(DatoComplementarioTriggerHelperB2b.DC_RTYPE_SOCIO_DEVELOPERNAME) ;
            dcSocio.Name = dcCtc.Name + String.valueOf(Datetime.now());
            dcSocio.Rut__c = '11860839-9';
            dcSocio.Contacto_Principal__c = false;
            dcSocio.Id_Prospecto__c = leadRTEmpresa.Id;
            datoComplementarioList.add(dcSocio);

            Dato_Complementarios__c dcClient = TestFactoryB2B.newDatoComplementario(DatoComplementarioTriggerHelperB2b.DC_RTYPE_CLIENTE_DEVELOPERNAME) ;
            dcClient.Name = dcClient.Name + String.valueOf(Datetime.now());
            dcClient.Rut__c = '22492803-3';
            dcClient.Contacto_Principal__c = false;
            dcClient.Id_Prospecto__c = leadRTEmpresa.Id;
            datoComplementarioList.add(dcClient);

            Dato_Complementarios__c dcProveedor = TestFactoryB2B.newDatoComplementario(DatoComplementarioTriggerHelperB2b.DC_RTYPE_PROVEEDORES_DEVELOPERNAME) ;
            dcProveedor.Name = dcProveedor.Name + String.valueOf(Datetime.now());
            dcProveedor.Rut__c = '9167025-9';
            dcProveedor.Contacto_Principal__c = false;
            dcProveedor.Id_Prospecto__c = leadRTEmpresa.Id;
            datoComplementarioList.add(dcProveedor);

            insert datoComplementarioList;

            Linea_Bancaria__c lbancarias =  TestFactoryB2B.newLineaBancaria('ProKetsol');
            lbancarias.Id_Prospecto__c = leadRTEmpresa.Id;
            insert lbancarias;

            leadRTEmpresa.Nivel_de_Importaciones__c     = 68999;
            update leadRTEmpresa;

            System.assertEquals('Contactado Visita', leadRTEmpresa.Etapa_Prospecto__c);

            Event visitaExitosa = new Event();
            visitaExitosa.Estado__c       = 'Visita Exitosa';
            visitaExitosa.WhoId           = leadRTEmpresa.Id;
            visitaExitosa.StartDateTime   = System.today();
            visitaExitosa.EndDateTime     = System.today();  
            visitaExitosa.Subject         = 'Asunto calling'; 
            visitaExitosa.Tipo_de_contacto__c = 'Visita';
            visitaExitosa.OwnerId         = iUserEjecutivoVenta.Id;
            visitaExitosa.RecordTypeId    = EventTriggerHelperB2B.getRecordTypeId(EventTriggerHelperB2B.RT_EVENT_EMPRESA);
            insert visitaExitosa;
            
            Informe_de_Visita__c informe2 = TestFactoryB2B.newInformeVisita(Informe_de_VisitaTriggerHelperB2b.INFORMEDEVISITA_ESTADOENPROCESO);
            informe2.Id_Prospecto__c = leadRTEmpresa.Id;
            insert informe2;

            informe2.Estado__c = 'Generado';
            informe2.IsSentBtnAndes__c = true;
            informe2.Fecha_de_envio_Andes__c = Date.today();
            update informe2;

            leadRTEmpresa = [SELECT Id, Status, Informe_Visita_Generado__c, Visita_comercial_exitosa__c, 
                                Etapa_Prospecto__c, Sancion_Comite__c, Fecha_Aprobacion_Comite__c,
                                Fecha_Estimada_Presentacion_Comite__c, Estado_Curse__c, Fecha_Curse__c, 
                                Moneda_Producto__c, Producto__c, Monto__c, rut_ejecutivo_sales__c,
                                IdRutEmpresaFilial__c, RUTEmpresa__c, EmpresaGrupoFilial__c
                            FROM Lead Limit 1];

            System.assertEquals('Comité', leadRTEmpresa.Status);
            System.assertEquals('Informe Visita Completo', leadRTEmpresa.Etapa_Prospecto__c);
            System.assertEquals(true, leadRTEmpresa.Informe_Visita_Generado__c);
            System.assertEquals(true, leadRTEmpresa.Visita_comercial_exitosa__c);

            leadRTEmpresa.Etapa_Prospecto__c            = 'Comité Aprobado';
            leadRTEmpresa.Sancion_Comite__c             = 'Aprobado';
            leadRTEmpresa.Fecha_Aprobacion_Comite__c    = Date.today();
            leadRTEmpresa.Fecha_Estimada_Presentacion_Comite__c = Date.today();
            update leadRTEmpresa;

            leadRTEmpresa = [SELECT Id, Status, Informe_Visita_Generado__c, Visita_comercial_exitosa__c, 
                                Etapa_Prospecto__c, Sancion_Comite__c, Fecha_Aprobacion_Comite__c,
                                Fecha_Estimada_Presentacion_Comite__c, Estado_Curse__c, Fecha_Curse__c, 
                                Moneda_Producto__c, Producto__c, Monto__c, rut_ejecutivo_sales__c,
                                IdRutEmpresaFilial__c, RUTEmpresa__c, EmpresaGrupoFilial__c
                            FROM Lead Limit 1];

            Test.startTest();
            // -------------------------------
            //  Mover Lead Estado = Convertido 
            // -------------------------------
            leadRTEmpresa.Estado_Curse__c       =   'Cursado';
            leadRTEmpresa.Fecha_Curse__c        =   Date.today();
            leadRTEmpresa.Moneda_Producto__c    =   'CLP';
            leadRTEmpresa.Producto__c           =   'Comex';
            leadRTEmpresa.Monto__c              =   18960;
            update leadRTEmpresa;

            leadRTEmpresa = [SELECT Id, Status, Company, Etapa_Prospecto__c, rut_ejecutivo_sales__c FROM Lead Limit 1];
            System.assertEquals('Convertido', leadRTEmpresa.Status);
            System.assertEquals('Cursado', leadRTEmpresa.Etapa_Prospecto__c);

                List<Lead> lstLead = [SELECT Id, Status, FirstName,  
                                        rut_ejecutivo_sales__c, 
                                        ConvertedAccountId,
                                        Informe_Visita_Generado__c,
                                        Visita_comercial_exitosa__c,
                                        Fecha_ultima_gestion__c,
                                        Fecha_Inicio_Sin_Gestion__c,
                                        Fecha_Inicio_Gestion__c,
                                        Fecha_Inicio_Visita__c,
                                        Fecha_Inicio_Comite__c,
                                        Fecha_Inicio_Convertido__c,
                                        Fecha_Inicio_No_Convertido__c,
                                        Sancion_Comite__c,
                                        Fecha_Aprobacion_Comite__c,
                                        Fecha_Estimada_Presentacion_Comite__c,
                                        Estado_Curse__c, LastName, Company
                                    FROM Lead 
                                    WHERE Id=: leadRTEmpresa.Id];

                LeadConvertHelperB2b.assignleads(new List<Id>{lstLead.get(0).Id});
                List<Account> lstAcc = [SELECT Id, Name, Estado_Cliente_Banca_Empresas__c FROM Account Limit 1];

            Test.stopTest();
        }
    }

    @isTest
	private static void reasignOwnerToLeadAndRelated_test(){
        UserRole RolGerente = [SELECT Id FROM UserRole where DeveloperName = 'Gerente_Ventas_Empresas' LIMIT 1]; 
        UserRole RolEjecutivo = [SELECT Id FROM UserRole where DeveloperName = 'Ejecutivo_Comercial_Pyme_MMGGEE' LIMIT 1]; 

        User analistaInteliNegocioB2B = [SELECT Id, UserRoleId FROM User WHERE RUT__c = '219200315' LIMIT 1];
        analistaInteliNegocioB2B.UserRoleId = RolGerente.Id;
        update analistaInteliNegocioB2B;

        User iUserEjecutivoVenta = [SELECT Id, UserRoleId FROM User WHERE RUT__c = '246232369' LIMIT 1];
        iUserEjecutivoVenta.UserRoleId = RolEjecutivo.Id;
        update iUserEjecutivoVenta;

        User iUserEjecutivo2 = [SELECT Id, UserRoleId FROM User WHERE RUT__c = '189769288' LIMIT 1];
        iUserEjecutivo2.UserRoleId = RolEjecutivo.Id;
        update iUserEjecutivo2;

        System.runAs(analistaInteliNegocioB2B){
            Lead newLead2 = TestFactoryB2B.newLead(LeadTriggerHelperB2b.RT_LEAD_EMPRESA);
            newLead2.LastName               = 'FactoryLead2';
            newLead2.RecordTypeId           = [SELECT Id FROM RecordType WHERE sObjectType =: 'Lead' AND DeveloperName =: 'sales_empresa' LIMIT 1].Id;
            newLead2.Company                = 'Company345k69';
            newLead2.RUTEmpresa__c          = '24282282-k';
            newLead2.EmpresaGrupoFilial__c  = '1';
            newLead2.IdRutEmpresaFilial__c  = newLead2.RUTEmpresa__c+newLead2.EmpresaGrupoFilial__c;
            newLead2.Actividad_Economica__c = 'H - COMERCIO AL POR MAYOR Y MENOR.';
            //newLead2.LeadSource             = LeadTriggerHelperB2b.LEAD_SOURCE_PROPIO ;
            newLead2.LeadSource             = LeadTriggerHelperB2b.LEADSOURCE_GESTION_COMERCIAL ;
            newLead2.Status                 = LeadTriggerHelperB2b.LEAD_STATUS_SIN_GESTION;
            //newLead2.Status                 = LeadTriggerHelperB2b.LEAD_STATUS_EVALUACION;
            newLead2.Etapa_Prospecto__c     = LeadTriggerHelperB2b.LEAD_ETAPA_SIN_GESTION;
            newLead2.rut_ejecutivo_sales__c = '24623236-9'; 
            // Información adicional
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

            Dato_Complementarios__c dcSocio = TestFactoryB2B.newDatoComplementario(DatoComplementarioTriggerHelperB2b.DC_RTYPE_SOCIO_DEVELOPERNAME) ;
            dcSocio.Name = '18458318';
            dcSocio.Rut__c = '18458318-6';
            dcSocio.Contacto_Principal__c = false;
            dcSocio.Id_Prospecto__c = newLead2.Id;
            dcSocio.OwnerId = iUserEjecutivoVenta.Id;
            insert dcSocio;
            
            Dato_Complementarios__c dcClient = TestFactoryB2B.newDatoComplementario(DatoComplementarioTriggerHelperB2b.DC_RTYPE_CLIENTE_DEVELOPERNAME) ;
            dcClient.Name = '19901043';
            dcClient.Rut__c = '19901043-3';
            dcClient.Contacto_Principal__c = false;
            dcClient.Id_Prospecto__c = newLead2.Id;
            dcClient.OwnerId = iUserEjecutivoVenta.Id;
            insert dcClient;
            
            Dato_Complementarios__c dcProveedor = TestFactoryB2B.newDatoComplementario(DatoComplementarioTriggerHelperB2b.DC_RTYPE_PROVEEDORES_DEVELOPERNAME) ;
            dcProveedor.Name = '6738205';
            dcProveedor.Rut__c = '6738205-6';
            dcProveedor.Contacto_Principal__c = false;
            dcProveedor.Id_Prospecto__c = newLead2.Id;
            dcProveedor.OwnerId = iUserEjecutivoVenta.Id;
            insert dcProveedor;

            Informe_de_Visita__c informe2 = TestFactoryB2B.newInformeVisita(Informe_de_VisitaTriggerHelperB2b.INFORMEDEVISITA_ESTADOENPROCESO);
            informe2.Id_Prospecto__c = newLead2.Id;
            informe2.OwnerId = iUserEjecutivoVenta.Id;
            insert informe2;

            Linea_Bancaria__c lbancarias =  TestFactoryB2B.newLineaBancaria('ProKetsol43');
            lbancarias.Id_Prospecto__c = newLead2.Id;
            lbancarias.OwnerId = iUserEjecutivoVenta.Id;
            insert lbancarias;

            newLead2.OwnerId = iUserEjecutivo2.Id;
            update newLead2;
        }

    }


    @isTest
    private static void leadSourcePropio_Test(){
        User iUserEjecutivoVenta = [SELECT Id, UserRoleId FROM User WHERE RUT__c = '246232369' LIMIT 1];

        System.runAs(iUserEjecutivoVenta){
            Account iAcc = new Account(
                Name = 'COMERCIAL HUMERES LIMITADA'
            );
            insert iAcc;
            
            Contact ctc = new Contact(
                AccountId = iAcc.Id,
                FirstName = 'COMERCIAL',
                LastName  = 'HUMERES LIMITADA'
            );
            insert ctc;

            Lead leadRTEmpresa = TestFactoryB2B.newLead(LeadTriggerHelperB2b.RT_LEAD_EMPRESA);
            leadRTEmpresa.Company                       = 'COMERCIAL HUMERES LIMITADA2';
            leadRTEmpresa.FirstName                     = 'COMERCIAL2'; 
            leadRTEmpresa.LastName                      = 'HUMERES LIMITADA2';
            leadRTEmpresa.RUTEmpresa__c                 = '5666663-k';
            leadRTEmpresa.EmpresaGrupoFilial__c         = '1';
            leadRTEmpresa.IdRutEmpresaFilial__c         = leadRTEmpresa.RUTEmpresa__c+leadRTEmpresa.EmpresaGrupoFilial__c;
            leadRTEmpresa.rut_ejecutivo_sales__c        = '24623236-9';
            leadRTEmpresa.Status                        = LeadTriggerHelperB2b.LEAD_STATUS_EVALUACION;
            leadRTEmpresa.Etapa_Prospecto__c            = LeadTriggerHelperB2b.LEAD_ETAPA_SIN_GESTION;
            leadRTEmpresa.LeadSource                    = LeadTriggerHelperB2b.LEAD_SOURCE_PROPIO;
            insert leadRTEmpresa;

            Lead leadRTEmpresa2 = TestFactoryB2B.newLead(LeadTriggerHelperB2b.RT_LEAD_EMPRESA);
            leadRTEmpresa2.Company                       = 'COMERCIAL HUMERES LIMITADA3';
            leadRTEmpresa2.FirstName                     = 'COMERCIAL3'; 
            leadRTEmpresa2.LastName                      = 'HUMERES LIMITADA3';
            leadRTEmpresa2.RUTEmpresa__c                 = '11801864-8';
            leadRTEmpresa2.EmpresaGrupoFilial__c         = '1';
            leadRTEmpresa2.IdRutEmpresaFilial__c         = leadRTEmpresa2.RUTEmpresa__c+leadRTEmpresa2.EmpresaGrupoFilial__c;
            leadRTEmpresa2.rut_ejecutivo_sales__c        = '24623236-9';
            leadRTEmpresa2.Status                        = LeadTriggerHelperB2b.LEAD_STATUS_EVALUACION;
            leadRTEmpresa2.Etapa_Prospecto__c            = LeadTriggerHelperB2b.LEAD_ETAPA_SIN_GESTION;
            leadRTEmpresa2.LeadSource                    = LeadTriggerHelperB2b.LEADSOURCE_GESTION_COMERCIAL;
            insert leadRTEmpresa2;

            leadRTEmpresa2.LeadSource                    = LeadTriggerHelperB2b.LEAD_SOURCE_PROPIO;
            update leadRTEmpresa2;
        }
    }


}