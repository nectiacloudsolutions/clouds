/*********************************************************************************************************
@Author       cagonzle@everis.com
@name         cnf_pf_tri_platform_event
@CreateDate   26/08/2020
@Description  Test class para CaseTriggerPFHelper - Casos de Salida
**********************************************************************************************************/
trigger cnf_pf_tri_platform_event on PF_Envio_Masterbase__e (after insert) {
    for(PF_Envio_Masterbase__e evento : (List<PF_Envio_Masterbase__e>)Trigger.new){
        Datetime dt = evento.PF_FechaHora_Envio__c;
        PF_EnvioMail_MB_sch em = new PF_EnvioMail_MB_sch(evento.PF_BodyJson__c);
        String sch =  '0 '+ dt.minute() + ' ' + dt.hour() + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
        String jobID = System.schedule('Envio Mail MB '+evento.ReplayId , sch, em);       
    }
}