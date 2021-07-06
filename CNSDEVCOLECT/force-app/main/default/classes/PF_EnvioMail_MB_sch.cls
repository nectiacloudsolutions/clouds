/*********************************************************************************************************
@Author       cagonzle@everis.com
@name         PF_EnvioMail_MB_sch
@CreateDate   27/08/2019
@Description  W-000916 - (Portabilidad Financiera) - Integración con Masterbase - Envio de mails
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
27/08/2020                    cagonzle@everis.com                 Initial Version
**********************************************************************************************************/
global with sharing class PF_EnvioMail_MB_sch implements Schedulable {

	private Datetime dt;
	private String bodyJson;

	/**
	 * PF_EnvioMail_MB_sch Constructor de scheduler para programar envio de email
	 * @param  bodyJson bodyJson Body del mensaje 
	 */
	global PF_EnvioMail_MB_sch(String bodyJson){
		this.bodyJson = bodyJson;
	}
	
	/**
	 * execute envio del email
	 * @param  ctx ctx contexto de la clase scheduler
	 */
    global void execute(SchedulableContext ctx) {
		PF_EnvioMail_MB.envioCorreo_A_MasterBase(bodyJson);
    }
}