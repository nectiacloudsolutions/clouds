/**
 * @description       : 
 * @author            : ggonzroj@everis.com
 * @group             : 
 * @last modified on  : 11-02-2020
 * @last modified by  : ggonzroj@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   08-24-2020   ggonzroj@everis.com   Initial Version
**/
@isTest
public class TestFactoryB2B {
    public TestFactoryB2B() {}

    public static User getUserAdmin() {
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];        

        User iUserAdmin = new User();
        iUserAdmin.Email = 'prueba1unique@consorcio.cl.dev';
        iUserAdmin.firstName = 'EjecutivoADM';
        iUserAdmin.LastName = 'prueba1';
        iUserAdmin.Username = 'prueba1unique@consorcio.cl.de';
        iUserAdmin.CompanyName = 'Consorcio Seguros';
        iUserAdmin.Department = 'Adm. Funcional CRM';
        iUserAdmin.Title = 'title';
        iUserAdmin.Alias = 'alias';
        iUserAdmin.CommunityNickname =  'ejecutivo2@consorcio.cl.devsales';
        iUserAdmin.CompanyName = 'Consorcio Banco';
        iUserAdmin.LocaleSidKey = 'es_CL';
        iUserAdmin.EmailEncodingKey = 'ISO-8859-1';            
        iUserAdmin.LanguageLocaleKey = 'en_US';
        iUserAdmin.TimeZoneSidKey = 'America/Santiago';
        iUserAdmin.isActive = true;
        iUserAdmin.ProfileId = profileId.Id;
        return iUserAdmin;      
    }

    public static User getUserAnalistaInteligenciaNegocioBE (){
        Profile AnalistaInteligenciaNegProfileId = [SELECT Id FROM Profile WHERE Name = 'Analista Inteligencia de Negocios' LIMIT 1]; 

        User iUAnalistaIntNeg = new User();
        iUAnalistaIntNeg.firstName = 'Analista';
        iUAnalistaIntNeg.LastName = 'InteligenciaNegociosBE';
        iUAnalistaIntNeg.RUT__c = '219200315';
        iUAnalistaIntNeg.Email = 'analista@consorcio.cl';
        iUAnalistaIntNeg.CompanyName = 'Consorcio Empresas';
        iUAnalistaIntNeg.Department = 'Adm. Funcional CRM';
        iUAnalistaIntNeg.Alias =  'AnNeg';                    
        iUAnalistaIntNeg.UserName =  'analista@consorcio.cl.devsales1';            
        iUAnalistaIntNeg.CommunityNickname =  'analista@consorcio.cl.devsales1';
        iUAnalistaIntNeg.LocaleSidKey = 'es_CL';
        iUAnalistaIntNeg.CompanyName = 'Consorcio Banco';
        iUAnalistaIntNeg.EmailEncodingKey = 'ISO-8859-1';            
        iUAnalistaIntNeg.LanguageLocaleKey = 'en_US';
        iUAnalistaIntNeg.TimeZoneSidKey = 'America/Santiago';
        iUAnalistaIntNeg.isActive = true;
        iUAnalistaIntNeg.ProfileID = AnalistaInteligenciaNegProfileId.Id;
        return iUAnalistaIntNeg;
    }

    public static User getUserEjecutivoComercialBE (){
        Profile EjeComercialProfileId = [SELECT Id FROM Profile WHERE Name = 'Ejecutivo Comercial Banca Empresas' LIMIT 1]; 

        User iUEjecutVenta = new User();
        iUEjecutVenta.firstName = 'Ejecutivo';
        iUEjecutVenta.LastName = 'ComercialBE';
        iUEjecutVenta.RUT__c = '246232369'; // 19812
        iUEjecutVenta.Email = 'ejecutivo@consorcio.cl';
        iUEjecutVenta.CompanyName = 'Consorcio Seguros';
        iUEjecutVenta.Department = 'Adm. Funcional CRM';
        iUEjecutVenta.Alias =  'testb2b';                    
        iUEjecutVenta.UserName =  'ejecutivotestb2b@consorcio.cl.devsales';
        iUEjecutVenta.CommunityNickname =  'ejecutivotestb2b@consorcio.cl.devsales';
        iUEjecutVenta.LocaleSidKey = 'es_CL';
        iUEjecutVenta.EmailEncodingKey = 'ISO-8859-1';            
        iUEjecutVenta.LanguageLocaleKey = 'en_US';
        iUEjecutVenta.CompanyName = 'Consorcio Banco';
        iUEjecutVenta.TimeZoneSidKey = 'America/Santiago';
        iUEjecutVenta.isActive = true;
        iUEjecutVenta.ProfileID = EjeComercialProfileId.Id;
        return iUEjecutVenta;
    }

    public static User getUserEjecutivoComercialPymeBE (){
        Profile EjeComercialProfileId = [SELECT Id FROM Profile WHERE Name = 'Ejecutivo Comercial Banca Empresas' LIMIT 1]; 

        User iUEjecutVenta = new User();
        iUEjecutVenta.firstName = 'Ejecutivo';
        iUEjecutVenta.LastName = 'ComercialBE';
        iUEjecutVenta.RUT__c = '189769288'; // 19812
        iUEjecutVenta.Email = 'ejecutivopyme@consorcio.cl';
        iUEjecutVenta.CompanyName = 'Consorcio Seguros';
        iUEjecutVenta.Department = 'Adm. Funcional CRM';
        iUEjecutVenta.Alias =  'test';                    
        iUEjecutVenta.UserName =  'ejecutivopymetest@consorcio.cl.devsales';            
        iUEjecutVenta.CommunityNickname =  'ejecutivopymetest@consorcio.cl.devsales';
        iUEjecutVenta.LocaleSidKey = 'es_CL';
        iUEjecutVenta.EmailEncodingKey = 'ISO-8859-1';            
        iUEjecutVenta.LanguageLocaleKey = 'en_US';
        iUEjecutVenta.CompanyName = 'Consorcio Banco';
        iUEjecutVenta.TimeZoneSidKey = 'America/Santiago';
        iUEjecutVenta.isActive = true;
        iUEjecutVenta.ProfileID = EjeComercialProfileId.Id;
        return iUEjecutVenta;
    }


    public static Lead newLead (String iRTDeveloperName){
        Lead ilead = new Lead();
        ilead.Company                       = 'COMERCIAL HUMERES LIMITADA';
        ilead.FirstName                     = 'Lorena'; 
        ilead.LastName                      = 'Reinoso';
        ilead.Phone                         = '35325435';
        ilead.Email                         = 'corporativoxsd@consorcio.co';
        ilead.RUTEmpresa__c                 = '14432525-7';
        ilead.Actividad_Economica__c        = 'D - INDUSTRIAS MANUFACTURERAS NO METALICAS';
        ilead.LeadSource                    = 'Gestión Comercial';
        ilead.Status                        = LeadTriggerHelperB2b.LEAD_STATUS_SIN_GESTION;
        ilead.RecordTypeId                  = LeadTriggerHelperB2b.getRecordTypeId(iRTDeveloperName) ;
        ilead.Giro_de_la_empresa__c         = 'Giro CompanyB2B';
        // Información adicional
        ilead.Direccion_Oficina__c          = 'ALAMEDA 678';
        ilead.region_sales__c               = 'CL-RM';
        ilead.provincia_sales__c            = '131';
        ilead.comuna_sales__c               = '13101';
        ilead.NumberOfEmployees             = 200;
        // Deuda SBIF
        ilead.SBIF_Comercial__c             = 18560;
        ilead.SBIF_Contingente__c           = 19560;
        ilead.SBIF_Leasing__c               = 21560;
        ilead.Deuda_Achef__c                = 18660;
        // Info financiera
        ilead.Venta_Anual__c                = 18760;
        ilead.Deuda_Financiera__c           = 18860;
        ilead.Ebitda__c                     = 18960;
        ilead.Utilidad__c                   = 18570;
        ilead.Patrimonio__c                 = 18580;
        // Productos en los que opera
        ilead.Creditos_comerciales__c       = false;
        ilead.Cuenta_Corriente__c 			= false;
        ilead.Factoring__c 					= false;
        ilead.Leasing__c 					= false;
        ilead.Mesa_de_Dinero__c 			= false;
        ilead.Comex__c 						= false;
        ilead.Boletas_Garantia__c 			= false;
        ilead.Cash_Management__c            = true;
        ilead.Financiamiento_Inmobiliario__c = false;
        ilead.Fecha_Inicio_Sin_Gestion__c   = Date.today();
        ilead.Fecha_ultima_gestion__c       = Date.today();
        ilead.Fecha_Inicio_Gestion__c       = Date.today();
        ilead.Fecha_Inicio_Convertido__c    = Date.today();
        ilead.Fecha_Inicio_Visita__c        = Date.today();
        ilead.Fecha_Inicio_Comite__c        = Date.today();
        return ilead;
    }
    
    public static Linea_Bancaria__c newLineaBancaria (String iProducto){
        Linea_Bancaria__c lbancarias = new Linea_Bancaria__c();
        lbancarias.Name = iProducto;
        lbancarias.Monto_Aprobado__c = 20.500;
        lbancarias.Monto_Utilizado__c = 18.500;
        return lbancarias;
    }

    public static Informe_de_Visita__c newInformeVisita (String estado){
        Informe_de_Visita__c informe = new Informe_de_Visita__c();
        informe.Id_Informe_de_visita_Andes__c = String.valueOf(Datetime.now());
        informe.Estado__c = estado;
        return informe;
    }

    public static Dato_Complementarios__c newDatoComplementario (String iRTDeveloperName){
        Dato_Complementarios__c dato = new Dato_Complementarios__c();
        dato.Name                   = 'Gurav';	
        dato.Apellido__c            = 'Gezon';	
        dato.Contacto_Principal__c  = false;	
        dato.Email__c               = 'gsanched3@everis.com';	
        dato.Estado__c              = 'Activo';	
        dato.Rut__c                 = '12345672-6';	
        dato.Telefono__c            = '+56953630124';	
        dato.Participacion__c       = 1;
        dato.Estado__c              = 'Activo';
        dato.RecordTypeId           = DatoComplementarioTriggerHelperB2b.getRecordTypeId(iRTDeveloperName);
        return dato;
    }

    public static Account newAccount (String rutAccount,String name, String IdRecordtype){
        Account iaccount = new Account();
        iaccount.RUT__c  = rutAccount;	
        iaccount.Name = name;
        //iaccount.FirstName = 'Account';	
        //iaccount.LastName  = lastName;
        //iaccount.PersonOtherPhone = '56701719';
        //iaccount.Tipo_de_documento_de_identidad__c = 'RUT';
        iaccount.Phone = '123456789';
        iaccount.Calle_Nectia__c = 'Calle';
        iaccount.Numero_Nectia__c = 'Numero';
        iaccount.Region_Nectia__c = 'CL-AR';
        iaccount.Comuna_Nectia__c = '9101';
        iaccount.RecordTypeId  = IdRecordtype;
        return iaccount;
    }
    public static Contact newContact (String lastName,Boolean ContactoPrincipal, Id IdAccount){
        Contact icontact = new Contact();
        icontact.FirstName = 'Contact';	
        icontact.LastName  = lastName;
        icontact.Contacto_Principal__c = ContactoPrincipal;
        icontact.AccountId = IdAccount;	
        return icontact;
    }
    public static Campaign newCampaignContact(String name,string status){
        Campaign icampaign = new Campaign();
        icampaign.name = name;
        icampaign.Status = status;
        icampaign.StartDate = Date.today().addDays(1);
        icampaign.EndDate = Date.today().addDays(10);
        icampaign.Comex_sales__c = true;
        icampaign.Type = 'Contact';
        icampaign.RecordTypeId = CampaignTriggerHelperB2B.getRecordTypeId(CampaignTriggerHelperB2B.RECORDTYPE_CAMPAIGN_EMPRESA); // '0122i00000065UUAAY';
        icampaign.CampaignMemberRecordTypeId = CampaignMemberTriggerHelperB2B.getRecordTypeId(CampaignMemberTriggerHelperB2B.RECORDTYPE_CAMPAIGNMEMBER_EMPRESA);  // '0122i00000065UVAAY'; 
        return icampaign;
    }
    public static CampaignMember newCampaignMember(String RUTSales,string RUTEjecutivo, Id IdCampaign){
        CampaignMember icampaignmember = new CampaignMember();
        icampaignmember.RUT_sales__c = RUTSales;
        icampaignmember.RUT_Ejecutivo_sales__c = RUTEjecutivo;
        icampaignmember.CampaignId = IdCampaign;
        return icampaignmember;
    }
    public static CampaignMember newCampaignMemberLead(id IdLead, Id IdCampaign){
        CampaignMember icampaignmember = new CampaignMember();
        icampaignmember.LeadId = IdLead;
        icampaignmember.CampaignId = IdCampaign;
        return icampaignmember;
    }

    public static Consorcio_Org_B2B__c getCSConsorcioOrgB2B (){
        Consorcio_Org_B2B__c iCOB2B = new Consorcio_Org_B2B__c();
        iCOB2B.Carga_Masiva_de_Prospectos__c = false;
        iCOB2B.Cuota_Maxima_de_Leads__c = 10;
        iCOB2B.Sales_Project_B2B__c = true;
        return iCOB2B;
    }
    public static Consorcio_Org_B2B__c getCSConsorcioOrgB2BAnalista (){
        Consorcio_Org_B2B__c iCOB2B = new Consorcio_Org_B2B__c();
        iCOB2B.Carga_Masiva_de_Prospectos__c = true;
        iCOB2B.Cuota_Maxima_de_Leads__c = 10;
        iCOB2B.Sales_Project_B2B__c = true;
        return iCOB2B;
    }

    public static CS_IntegracionesAndes__c getCSIntegracionesAndes (String nameCSetting){
        CS_IntegracionesAndes__c sett = new CS_IntegracionesAndes__c();
        if(nameCSetting.equalsIgnoreCase('GenerarInformesAndes')){
            sett.Name               = 'GenerarInformesAndes';
            sett.URLApi__c          = 'http://10.250.12.175:8080';
            sett.ContentType__c     = 'application/json';
            sett.EndPoint__c        = '/BCNSWSR_ANDES_InformeVisitaSalesForce/PlataformaComercial/API/V1/InformeVistaSalesForce/AgregarInformeVisita';
            sett.Method__c          = 'POST';
            sett.NameCredential__c  = '';
            sett.AccessControlAllowOrigin__c = '*';
            sett.Active__c          = false;
            sett.Cache_Control__c   = 'no-cache';
            sett.ClientId__c        = '22348803k';
            sett.CodigoAplicacion__c = '116';
            sett.CodigoCanal__c     = '2';
            sett.EmpresaAplicacion__c = 'Interno';
            sett.IpCliente__c       = '127.0.0.1';
            sett.Modalidad__c       = 'consultar';
            sett.Parameters__c      = '';
            sett.Timeout__c         = '120000';
        } else if(nameCSetting.equalsIgnoreCase('GetTokenInformesAndes')){
            sett.Name               = 'GetTokenInformesAndes';
            sett.URLApi__c          = 'http://10.250.12.175:8080';
            sett.ContentType__c     = 'application/json';
            sett.EndPoint__c        = '/BCNSWSR_TOKENGEN/Token/Generar';
            sett.Method__c          = 'POST';
            sett.NameCredential__c  = '';
            sett.AccessControlAllowOrigin__c = '*';
            sett.Active__c          = true;
            sett.Cache_Control__c   = 'no-cache';
            sett.ClientId__c        = '';
            sett.CodigoAplicacion__c = '116';
            sett.CodigoCanal__c     = '2';
            sett.EmpresaAplicacion__c = 'Interno';
            sett.IpCliente__c       = '127.0.0.1';
            sett.Modalidad__c       = 'generar';
            sett.Parameters__c      = '';
            sett.Timeout__c         = '120000';
        } 
        return sett;
    }

    public static void createConsorcioOrgB2B(){
        Map<String,Id> profileNameId = new Map<String,Id>();
        for(profile p : [SELECT Id, name FROM Profile]){
            profileNameId.put(p.name, p.id);
        }

        List<Consorcio_Org_B2B__c> ConsOrgListB2B = new List<Consorcio_Org_B2B__c>();
        
        Consorcio_Org_B2B__c ConsOrgAdminB2B = new Consorcio_Org_B2B__c();
        ConsOrgAdminB2B.SetupOwnerId = profileNameId.get('System Administrator');
        ConsOrgAdminB2B.Carga_Masiva_de_Prospectos__c = true;
        ConsOrgAdminB2B.Cuota_Maxima_de_Leads__c = 10;
        ConsOrgAdminB2B.Sales_Project_B2B__c = true;
        ConsOrgListB2B.add(ConsOrgAdminB2B);

        Consorcio_Org_B2B__c ConsOrgAnalistaInteligenciaB2B = new Consorcio_Org_B2B__c();
        ConsOrgAnalistaInteligenciaB2B.SetupOwnerId = profileNameId.get('Analista Inteligencia de Negocios');
        ConsOrgAnalistaInteligenciaB2B.Carga_Masiva_de_Prospectos__c = true;
        ConsOrgAnalistaInteligenciaB2B.Cuota_Maxima_de_Leads__c = 10;
        ConsOrgAnalistaInteligenciaB2B.Sales_Project_B2B__c = true;
        ConsOrgListB2B.add(ConsOrgAnalistaInteligenciaB2B);

        Consorcio_Org_B2B__c ConsOrgEjecutivoComercialB2B = new Consorcio_Org_B2B__c();
        ConsOrgEjecutivoComercialB2B.SetupOwnerId = profileNameId.get('Ejecutivo Comercial Banca Empresas');
        ConsOrgEjecutivoComercialB2B.Carga_Masiva_de_Prospectos__c = false;
        ConsOrgEjecutivoComercialB2B.Cuota_Maxima_de_Leads__c = 10;
        ConsOrgEjecutivoComercialB2B.Sales_Project_B2B__c = true;
        ConsOrgListB2B.add(ConsOrgEjecutivoComercialB2B);

        Consorcio_Org_B2B__c ConsOrgJefePlataformaB2B = new Consorcio_Org_B2B__c();
        ConsOrgJefePlataformaB2B.SetupOwnerId = profileNameId.get('Jefe de plataforma Banca Empresas');
        ConsOrgJefePlataformaB2B.Carga_Masiva_de_Prospectos__c = false;
        ConsOrgJefePlataformaB2B.Cuota_Maxima_de_Leads__c = 10;
        ConsOrgJefePlataformaB2B.Sales_Project_B2B__c = true;
        ConsOrgListB2B.add(ConsOrgJefePlataformaB2B);

        insert ConsOrgListB2B;
    }

}