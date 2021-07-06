/**
 * @description       : Control class of aura cmp CrearInformesGeneradosAndes
 * @author            : ggonzroj@everis.com
 * @group             : 
 * @last modified on  : 10-26-2020
 * @last modified by  : ggonzroj@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   10-15-2020   ggonzroj@everis.com   Initial Version
**/
public with sharing class CrearInformesGeneradosAndesCtrl {
    
    @AuraEnabled
    public static Map<String,Object> procesaEnvioInformesAndes (Id informeId) {
        String msjAPI = '';
        Map<String,Object> respMap = new Map<String,Object>();
        Informe_de_Visita__c iInforme = new Informe_de_Visita__c();
        CS_IntegracionesAndes__c csIntegraciones = CrearInformesGeneradosAndesHelper.getCSIntegracionesAndes('GenerarInformesAndes');

        try {
            if (csIntegraciones.Active__c) {
                iInforme = [SELECT Id, Id_Prospecto__c, 
                                Account__c, Estado__c, IsSentBtnAndes__c,
                                FechaProgramadaVisita__c, IsInformeVisitaAccount__c
                            FROM Informe_de_Visita__c 
                            WHERE Id =: informeId LIMIT 1];

                if (iInforme.Estado__c != Informe_de_VisitaTriggerHelperB2b.INFORMEDEVISITA_ESTADOGENERADO 
                    && iInforme.IsSentBtnAndes__c == false
                    ) {

                    if (!iInforme.IsInformeVisitaAccount__c) {
                        Map<Id,Lead> mpleads = LeadTriggerHelperB2b.getLeadsbyId(new Set<Id>{iInforme.Id_Prospecto__c});
                        Lead iLead = mpleads.get(iInforme.Id_Prospecto__c);

                        String iJSONBodyToken = CrearInformesGeneradosAndesHelper.JSONBodyToken(iLead.rut_ejecutivo_sales__c);
                        CrearInformesGeneradosAndesHelper.getTokensAndes(iJSONBodyToken);
                        String body = CrearInformesGeneradosAndesHelper.JSONEngine(iInforme, iLead);
                        respMap = CrearInformesGeneradosAndesHelper.generateInformesAndes(body, iLead.rut_ejecutivo_sales__c);
                    } else {
                        Map<Id, Account> mpAccounts =  AccountTriggerHelperB2B.getAccountsAndContacts(new Set<Id>{iInforme.Account__c});
                        Account iAccount = mpAccounts.get(iInforme.Account__c);
                        String iJSONBodyToken = CrearInformesGeneradosAndesHelper.JSONBodyToken(iAccount.Rut_Ejecutivo_Banco__c);
                        CrearInformesGeneradosAndesHelper.getTokensAndes(iJSONBodyToken);
                        String body = CrearInformesGeneradosAndesHelper.JSONEngineFromAccount(iInforme, iAccount);
                        respMap = CrearInformesGeneradosAndesHelper.generateInformesAndes(body, iAccount.Rut_Ejecutivo_Banco__c);
                    }
                } else {
                    msjAPI = 'Este Informe ya ha sido generado en ANDES o no es un Informe de la cuenta.';
                    respMap = CrearInformesGeneradosAndesHelper.respMapErrors('100', msjAPI);
                    return respMap;
                }
            } else { 
                update new Informe_de_Visita__c(
                    Id = informeId,
                    Estado__c = Informe_de_VisitaTriggerHelperB2b.INFORMEDEVISITA_ESTADOGENERADO,
                    IsSentBtnAndes__c = true
                );

                msjAPI = 'Este Informe no pudo enviarse a ANDES. Servicio inactivo en Salesforce';
                respMap = CrearInformesGeneradosAndesHelper.respMapErrors('100', msjAPI);
                return respMap;
            }

        } catch (Exception e) {
            String data = 'STACK TRACE:\n' + e.getStackTraceString() + '\nMESSAGE:\n' + e.getMessage() + '\nLine:\n' + e.getLineNumber();
            msjAPI = data; // e.getMessage();
            respMap = CrearInformesGeneradosAndesHelper.respMapErrors('100', msjAPI);
        }

        try {
            if (CrearInformesGeneradosAndesHelper.responsesAndesWrp != null && csIntegraciones.Active__c) {
                CrearInformesGeneradosAndesHelper.ResponsesAndesWrp iResponsesAndesWrp = CrearInformesGeneradosAndesHelper.responsesAndesWrp;
                CrearInformesGeneradosAndesHelper.dtoResponseCodigosEstadoHttp idtoResponseCodigosEstadoHttp = iResponsesAndesWrp.dtoResponseCodigosEstadoHttp;
                CrearInformesGeneradosAndesHelper.dtoResponseSetResultados idtoResponseSetResultados = iResponsesAndesWrp.dtoResponseSetResultados;
                if (idtoResponseCodigosEstadoHttp.codigo == '200') {
                    if (idtoResponseSetResultados.codigoSalida == 1) {
                        update new Informe_de_Visita__c(
                            Id = informeId,
                            Estado__c = 'Generado',
                            IsSentBtnAndes__c = true,
                            Fecha_de_envio_Andes__c = Date.today()
                            // agregar Id_Informe_de_visita_Andes__c con el valor recibido de ANDES por definir
                        );
                    }
                }
            }
        } catch (Exception e) {
            String data = 'STACK TRACE:\n' + e.getStackTraceString() + '\nMESSAGE:\n' + e.getMessage() + '\nLine:\n' + e.getLineNumber();
            msjAPI = e.getMessage();
            respMap = CrearInformesGeneradosAndesHelper.respMapErrors('100', msjAPI);
        }

        return respMap;
    }

}