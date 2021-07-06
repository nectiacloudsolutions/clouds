/*********************************************************************************************************
@Author       mbeltrab@everis.com
@name         UtilitiesSalesB2B
@CreateDate   12/08/2020
@Description  UtilitiesSales class for Sales cloud B2B
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
12/08/2020                    mbeltrab@everis.com           Initial Version
**********************************************************************************************************/

public without sharing class UtilitiesSalesB2B {

    /**
	* @description       This method validate the RUT Field (Algoritm mod11)
    * @param1            Set<String> RUT to validated
    * @return            Boolean, True if is valid otherwise false
    */
    public static boolean validarRunRut(String runRut){
        
        Integer[] factores = new Integer[]{7, 6, 5, 4, 3, 2, 7, 6, 5, 4, 3, 2};
        if (runRut.length() > 2){
            Integer indFactor = factores.size() - 1;
            string cadnumero = runRut.substring(0,runRut.length()-2);
            string guion = runRut.substring(runRut.length()-2, runRut.length()-1);           
            string digitoverificador = runRut.substring(runRut.length()-1);           
            string digitoCalculado;
            Integer calculodigito = 0;
            if (guion == '-' && cadnumero.isNumeric()){
                for (Integer i = cadnumero.length() - 1; i >= 0; i--) {                   
                    calculodigito = calculodigito + (factores[indFactor]*Integer.valueof(cadnumero.substring(i,i+1)));
                    indFactor--;
                }
                Integer resultadoModulo = 11 - (math.mod(calculodigito,11));
                if (resultadoModulo == 11){
                    digitoCalculado = '0';
                } else if (resultadoModulo == 10) {
                    digitoCalculado = 'K';
                } else {
                    digitoCalculado = string.valueof(resultadoModulo);
                }
                //System.debug('DigitoCalculado: ' + digitoCalculado);
                if (digitoCalculado != digitoverificador){
                    return false;
                }
            } else {
                System.debug('Primer false');
                return false;
            }
        } else {
            System.debug('Segundo false');
            return false;
        }
        return true;
    }

    /**
      * @description       This method formated User rut whithout dots
      * @param1            String rut
      * @return            String formatRut
      * @throws            NA
    */
    public static String formatRutEjecutivo(String rut){
            rut = rut.contains('.') ? rut.replace('.', '') : rut;
            rut = rut.contains('-') ? rut.replace('-', '') : rut;
            return rut;
    }

    /**
      * @description       This method return List Lead By Id, se llama desde EventTriggerHelperB2B class
      * @param1            Set<String> Id Leads
      * @return            Map<Id,Lead> Map Id,Lead
	*/
    public static Map<Id,Lead> getLeadsAsociadosEventos(Set<String> IdsLeads){
        Map<Id,Lead> maps = new Map<Id,Lead>();
        for(Lead l : [SELECT Id, Status,Email,Informe_Visita_Generado__c FROM lead WHERE Id in :IdsLeads]){
            maps.put(l.Id, l);
        }
        return maps;
    }

    /**
      * @description       This method return String with the RecordtypeId asociated to Event BBEE
      * @param1            NA 
      * @return            String Id RecordtypeId
    */
    public static String getIdRecordTypeEventEmpresa(){
        RecordType RT = [SELECT Id FROM RecordType WHERE Name =: EventTriggerHelperB2B.RECORDTYPE_EVENT_EMPRESA AND SobjectType =:EventTriggerHelperB2B.EVENT LIMIT 1];
        String RTid = RT.id;
        return RTid;
    }
    
    
    public static String formatRut(String rut, String typeFormat){
        Integer cont = 0;
        String format;

        try{
            rut = rut.contains('.') ? rut.replace('.', '') : rut;
            rut = rut.contains('-') ? rut.replace('-', '') : rut;
            format = '-' + rut.substring(rut.length() - 1);
            for (Integer i = rut.length() - 2; i >= 0; i--) {
                format = rut.substring(i, i + 1) + format;
                cont++;
                if (cont == 3 && i != 0 && typeFormat.equals('WITHDOT')) {
                    format = '.' + format;
                    cont = 0;
                }
            }
        }catch(Exception e){
            format = null;
        }
    
        return format;
    }

    
}