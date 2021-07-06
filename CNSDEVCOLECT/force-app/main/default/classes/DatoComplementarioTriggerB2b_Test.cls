/**
 * @description       : 
 * @author            : ggonzroj@everis.com
 * @group             : 
 * @last modified on  : 11-02-2020
 * @last modified by  : ggonzroj@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   08-27-2020   ggonzroj@everis.com   Initial Version
**/
@isTest
public without sharing class DatoComplementarioTriggerB2b_Test {
    
    @testSetup static void dataloadB2B(){
        User iUserEjecutivoVenta = TestFactoryB2B.getUserEjecutivoComercialBE();
        insert iUserEjecutivoVenta;

        TestFactoryB2B.createConsorcioOrgB2B();
    } 

    @isTest
	private static void DatoComplementario_test_insert(){
        User iUserEjecutivoVenta = [SELECT Id, RUT__c, UserRoleId FROM User WHERE RUT__c = '246232369' LIMIT 1];

        System.runAs(iUserEjecutivoVenta){
            Lead newLead2 = TestFactoryB2B.newLead(LeadTriggerHelperB2b.RT_LEAD_EMPRESA);
            newLead2.LastName = 'FactoryLead2';
            newLead2.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType =: 'Lead' AND DeveloperName =: 'sales_empresa' LIMIT 1].Id;
            newLead2.Company = 'Company34569';
            newLead2.RUTEmpresa__c = '12315512345';
            newLead2.Actividad_Economica__c = 'H - COMERCIO AL POR MAYOR Y MENOR.';
            newLead2.LeadSource = 'Propio';
            newLead2.Status = LeadTriggerHelperB2b.LEAD_STATUS_EVALUACION;  // 'Visita';
            newLead2.Etapa_Prospecto__c =  LeadTriggerHelperB2b.LEAD_ETAPA_SIN_GESTION; // 'Pendiente Informe Visita';
            newLead2.rut_ejecutivo_sales__c        = '24623236-9';

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

            Dato_Complementarios__c dcCtc = TestFactoryB2B.newDatoComplementario(DatoComplementarioTriggerHelperB2b.DC_RTYPE_CONTACTO_DEVELOPERNAME) ;
            dcCtc.Name = '10777761';
            dcCtc.Rut__c = '10777761-k';
            dcCtc.Contacto_Principal__c = true;
            dcCtc.Id_Prospecto__c = newLead2.Id;
            insert dcCtc;

            Dato_Complementarios__c dcCtc2 = TestFactoryB2B.newDatoComplementario(DatoComplementarioTriggerHelperB2b.DC_RTYPE_CONTACTO_DEVELOPERNAME) ;
            dcCtc2.Name = '19991002';
            dcCtc2.Rut__c = '19991002-7';
            dcCtc2.Contacto_Principal__c = false;
            dcCtc2.Id_Prospecto__c = newLead2.Id;
            insert dcCtc2;

            Dato_Complementarios__c dcSocio = TestFactoryB2B.newDatoComplementario(DatoComplementarioTriggerHelperB2b.DC_RTYPE_SOCIO_DEVELOPERNAME) ;
            dcSocio.Name = '18458318';
            dcSocio.Rut__c = '18458318-6';
            dcSocio.Contacto_Principal__c = false;
            dcSocio.Id_Prospecto__c = newLead2.Id;
            insert dcSocio;

            Dato_Complementarios__c dcClient = TestFactoryB2B.newDatoComplementario(DatoComplementarioTriggerHelperB2b.DC_RTYPE_CLIENTE_DEVELOPERNAME) ;
            dcClient.Name = '19901043';
            dcClient.Rut__c = '19901043-3';
            dcClient.Contacto_Principal__c = false;
            dcClient.Id_Prospecto__c = newLead2.Id;
            insert dcClient;

            Dato_Complementarios__c dcProveedor = TestFactoryB2B.newDatoComplementario(DatoComplementarioTriggerHelperB2b.DC_RTYPE_PROVEEDORES_DEVELOPERNAME) ;
            dcProveedor.Name = '6738205';
            dcProveedor.Rut__c = '6738205-6';
            dcProveedor.Contacto_Principal__c = false;
            dcProveedor.Id_Prospecto__c = newLead2.Id;
            insert dcProveedor;

            update new Dato_Complementarios__c(
                Id = dcCtc.Id,
                Contacto_Principal__c = false
            );

            update new Dato_Complementarios__c(
                Id = dcCtc2.Id,
                Contacto_Principal__c = true,
                Email__c = 'newmailupdated@gmail.com',
                Telefono__c = '51837743'
            );

        }
    }

}