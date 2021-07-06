/**
 * @description       : 
 * @author            : ggonzroj@everis.com
 * @group             : 
 * @last modified on  : 10-20-2020
 * @last modified by  : ggonzroj@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   10-20-2020   ggonzroj@everis.com   Initial Version
**/
@isTest
public class CrearInformesGeneradosAndes_Test {
    
    @isTest
    private static void generarInformesEnAndes_Test(){

        User iUserEjecutivoVenta = TestFactoryB2B.getUserEjecutivoComercialBE();
        insert iUserEjecutivoVenta;

        Consorcio_Org_B2B__c iCOB2B = TestFactoryB2B.getCSConsorcioOrgB2B();
        iCOB2B.SetupOwnerId = iUserEjecutivoVenta.ProfileId;
        insert iCOB2B;

        System.runAs(iUserEjecutivoVenta){

        }
    }
}