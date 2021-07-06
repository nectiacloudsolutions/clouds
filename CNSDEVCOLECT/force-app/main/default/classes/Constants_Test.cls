/*********************************************************************************************************
@Author       fmaturan@everis.com
@name         Constants_Test
@CreateDate   07/10/2019
@Description  Test of the class TestFactorySales.
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date          		Developer                     Comments   
-----------------------------------------------------------------------------------------------------------
07/10/2019		fmaturan@everis.com               initial version
06/07/2020		fvasquen@everis.com				  Tests for constants of company and public groups
**********************************************************************************************************/
@isTest
public class Constants_Test {
    /**
      * @description       Intansiates the class Constants.  
      * @param            
      * @return            void
      * @throws            NA
    */
	@isTest static void ConstantsTest() {
        Constants cons = new Constants();
        system.assertEquals('RUT', Constants.RUT);
        system.assertEquals('Account', Constants.ACCOUNT);
        system.assertEquals('Lead', Constants.LEAD);
        system.assertEquals('No_Interesado', Constants.LEAD_STATUS_NO_INTERESADO);
        system.assertEquals('Gestionado', Constants.LEAD_STATUS_GESTIONADO);
        system.assertEquals('Call', Constants.TASK_SUBJECT_CALL);
        system.assertEquals('LLamada', Constants.TASK_SUBJECT_LLAMADA);
        system.assertEquals('Entrevista', Constants.TASK_SUBJECT_ENTREVISTA);
        system.assertEquals('Asignación', Constants.TASK_SUBJECT_ASIGNACION);
        system.assertEquals('Completada', Constants.TASK_STATUS_COMPLETADA);
        system.assertEquals('Abierta', Constants.TASK_STATUS_ABIERTA);
        system.assertEquals('Agendar', Constants.TASK_RESULTADO_AGENDAR);
        system.assertEquals('Volver a Llamar', Constants.TASK_RESULTADO_VOLVER_LLAMAR);
        system.assertEquals('No Contesta', Constants.TASK_RESULTADO_NO_CONTESTA);
        system.assertEquals('No le interesa', Constants.TASK_RESULTADO_NO_INTERESA);
        system.assertEquals('Volver a Entrevistar', Constants.EVENT_RESULTADO_VOLVER_ENTREVISTAR);
        system.assertEquals('Volver a llamar', Constants.EVENT_RESULTADO_VOLVER_LLAMAR);
        system.assertEquals('Suspendido', Constants.EVENT_RESULTADO_SUSPENDIDO);
        system.assertEquals('Reunión Exitosa', Constants.EVENT_RESULTADO_REUNION_EXITOSA);
        system.assertEquals('No le interesa', Constants.EVENT_RESULTADO_NO_LE_INTERESA);
        system.assertEquals('200', Constants.RESPONSE_200);
        system.assertEquals('400', Constants.RESPONSE_400);
        system.assertEquals('Sales_Consorcio_Seguros', Constants.GRUPO_SEGUROS);
        system.assertEquals('Sales_Consorcio_Banco', Constants.GRUPO_BANCO);
        system.assertEquals('Sales_Consorcio_Corredora', Constants.GRUPO_CORREDORA);
        system.assertEquals('Sales_Consorcio_Servicios', Constants.GRUPO_SERVICIOS);
        system.assertEquals('Consorcio Seguros', Constants.COMPANY_SEGUROS);
        system.assertEquals('Consorcio Corredora de Bolsa', Constants.COMPANY_CORREDORA);
        system.assertEquals('Consorcio Banco', Constants.COMPANY_BANCO);
        system.assertEquals('Consorcio Servicios', Constants.COMPANY_SERVICIOS);
    }
}