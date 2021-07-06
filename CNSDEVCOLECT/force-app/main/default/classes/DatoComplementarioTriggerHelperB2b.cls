/*********************************************************************************************************
@Author       mbeltrab@everis.com
@name         DatoComplementarioTriggerHelperB2b
@CreateDate   12/08/2020
@Description  Helper of the Dato_Complementarios__c object B2b
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
12/08/2020                    mbeltrab@everis.com           Initial Version
**********************************************************************************************************/

public without sharing class DatoComplementarioTriggerHelperB2b {

    public static final String DATOCOMPLEMENTARIO = 'Dato_Complementarios__c';
    public static final String DATOCOMPLEMENTARIO_TIPOCONTACTO = 'Contacto';
    public static final String DATOCOMPLEMENTARIO_TIPOSOCIO = 'Socio';
    public static final String DATOCOMPLEMENTARIO_TIPOCLIENTEPROSPECTO = 'Cliente de prospecto';
    public static final String DATOCOMPLEMENTARIO_TIPOPROVEEDOR = 'Proveedor';
    public static final String DATOCOMPLEMENTARIO_ESTADOACTIVO = 'Activo';
    public static final String DATOCOMPLEMENTARIO_ERROR1 = 'Rut {0} invalido';
    public static final String DC_RTYPE_SOCIO_DEVELOPERNAME = 'Sales_BBEE_Socio';
    public static final String DC_RTYPE_CONTACTO_DEVELOPERNAME = 'Sales_BBEE_Contacto';
    public static final String DC_RTYPE_CLIENTE_DEVELOPERNAME = 'Sales_BBEE_Cliente_Principal';
    public static final String DC_RTYPE_PROVEEDORES_DEVELOPERNAME = 'Sales_BBEE_Proveedores';
    
    
    /*
    * @Author          :   Georvys Gonzalez <ggonzroj@everis.com>
    * @Description     :   Asisign Contacto_Principal true. 
                           Contacto_Principal true al primero de un conjunto de DC false. Si no, el primero a Contacto_Principal y el resto a false.
    */
    public static void assignCtcPrincipalTrue (List<Dato_Complementarios__c> newList ){
        Set<Id> leadIds = new Set<Id>();
        List<Lead> leadToUpdate = new List<Lead>();
        Map<Id, Boolean> mapDCPrincipalTrue = new Map<Id, Boolean>();
        List<Dato_Complementarios__c> lstDCtoUpdate = new List<Dato_Complementarios__c>();
        Id iRecordTypeId = DatoComplementarioTriggerHelperB2b.getRecordTypeId(DC_RTYPE_CONTACTO_DEVELOPERNAME);

        for(Dato_Complementarios__c iDComplements : newList){
            if (iDComplements.RecordTypeId == iRecordTypeId) {
                leadIds.add(iDComplements.Id_Prospecto__c);    
                if (iDComplements.Contacto_Principal__c) {
                    System.debug('----name: ' + iDComplements.Name +' - '+ iDComplements.RecordType.DeveloperName +' - '+ iDComplements.Contacto_Principal__c );
                    mapDCPrincipalTrue.put(iDComplements.Id, iDComplements.Contacto_Principal__c);
                }
            }
        }

        Map<Id, List<Dato_Complementarios__c>> mpIdleadByDC = DatoComplementarioTriggerHelperB2b.getDatosComplementByleadAndRT(leadIds,iRecordTypeId);

        for (Id leadId : mpIdleadByDC.keySet()) {
            if (mpIdleadByDC.containsKey(leadId)) {
                List<Dato_Complementarios__c> lstDC = mpIdleadByDC.get(leadId);
                
                if (mapDCPrincipalTrue.isEmpty()) {
                    Dato_Complementarios__c ctcDC = lstDC.get(0);
                    lstDCtoUpdate.add(
                        new Dato_Complementarios__c(
                            Id = lstDC.get(0).Id,
                            Contacto_Principal__c = true
                        ) 
                    );
                    leadToUpdate.add(
                        new Lead(
                            Id        = ctcDC.Id_Prospecto__c,
                            Phone     = (ctcDC.Telefono__c != null && ctcDC.Telefono__c != '') ? ctcDC.Telefono__c : '',
                            Email     = (ctcDC.Email__c != null && ctcDC.Email__c != '') ? ctcDC.Email__c : '',
                            FirstName = ctcDC.Name,
                            LastName  = ctcDC.Apellido__c 
                        )
                    );
                    break;
                } else {
                    Integer count = 0;
                    Boolean doFalse = false;
                    for (Dato_Complementarios__c iDatos : lstDC) {
                        if (iDatos.Contacto_Principal__c) {
                            Dato_Complementarios__c ctcDC = lstDC.remove(count);
                            leadToUpdate.add(
                                new Lead(
                                    Id        = ctcDC.Id_Prospecto__c,
                                    Phone     = (ctcDC.Telefono__c != null && ctcDC.Telefono__c != '') ? ctcDC.Telefono__c : '',
                                    Email     = (ctcDC.Email__c != null && ctcDC.Email__c != '') ? ctcDC.Email__c : '',
                                    FirstName = ctcDC.Name,
                                    LastName  = ctcDC.Apellido__c 
                                )
                            );
                            doFalse = true;
                            break;
                        }
                        count ++;
                    }

                    if (doFalse) {
                        for (Dato_Complementarios__c iDatos : lstDC) {
                            lstDCtoUpdate.add(
                                new Dato_Complementarios__c(
                                    Id = iDatos.Id,
                                    Contacto_Principal__c = false
                                ) 
                            );
                        }
                    }
                }
            }
        }

        if (!lstDCtoUpdate.isEmpty()) {
            update lstDCtoUpdate;
        }

        if (!leadToUpdate.isEmpty()) {
            update leadToUpdate;
        }
    }

    /*
    * @Author          :   Georvys Gonzalez <ggonzroj@everis.com>
    * @Description     :   Verifica si Rut__c a cambiado en el record de Dato_Complementarios__c y no es null o vacío
    */
    public static boolean isChangedRut ( Dato_Complementarios__c newDC, Dato_Complementarios__c oldDC ){
        return oldDC.Rut__c != newDC.Rut__c;
    }

    /*
    * @Author          :   Georvys Gonzalez <ggonzroj@everis.com>
    * @Description     :   Verifica si Rut__c a cambiado en el record de Dato_Complementarios__c y no es null o vacío
    */
    public static boolean isNotEmptyRUT (Dato_Complementarios__c newDC){
        return newDC.Rut__c != '' 
            && newDC.Rut__c != null;
    }

    /*
    * @Author          :   Georvys Gonzalez <ggonzroj@everis.com>
    * @Description     :   addError en record con Rut__c invalido cambiado.
    */
    public static void addErrorInvalidRUT (List<Dato_Complementarios__c> newList, Map<ID,Dato_Complementarios__c> oldMap){
        for (Dato_Complementarios__c newDC : newList){

            if (oldMap != null) {
                Dato_Complementarios__c oldDC = oldMap.get(newDC.Id);
                if (isChangedRut(newDC,oldDC) && isNotEmptyRUT(newDC)) {
                    if (!UtilitiesSalesB2B.validarRunRut(newDC.Rut__c)){
                        newDC.addError(String.format(DATOCOMPLEMENTARIO_ERROR1, new String[]{newDC.Rut__c}));
                    }
                }
            } else {
                if (isNotEmptyRUT(newDC)) {
                    if (!UtilitiesSalesB2B.validarRunRut(newDC.Rut__c)){
                        newDC.addError(String.format(DATOCOMPLEMENTARIO_ERROR1, new String[]{newDC.Rut__c}));
                    }
                }
            }
        }
    }

    /*
    * @Author          :   Georvys Gonzalez <ggonzroj@everis.com>
    * @Description     :   Verifica si Contacto_Principal__c a cambiado en el record de Dato_Complementarios__c
    */
    public static boolean isChangeContact (Dato_Complementarios__c iDComplements, Dato_Complementarios__c oldDComplement) {
        return oldDComplement.Contacto_Principal__c != iDComplements.Contacto_Principal__c;
    }

    /*
    * @Author          :   Georvys Gonzalez <ggonzroj@everis.com>
    * @Description     :   Helper Map de Leads con lista de Dato_Complementarios__c relacionados dado especifico RecordTypeId.
    */
    public static Map<Id, List<Dato_Complementarios__c>> getDatosComplementByleadAndRT (Set<Id> leadIds, Id iRecordTypeId) {
        Map<Id, List<Dato_Complementarios__c>> iDComplementsMap = new Map<Id, List<Dato_Complementarios__c>>();
        for (Dato_Complementarios__c dComplementItems : [SELECT Id, Id_Prospecto__c, Tipo__c, Telefono__c, OwnerId,
                                                            Email__c, Apellido__c, Name, Rut__c,Participacion__c,
                                                            Contacto_Principal__c, RecordTypeId
                                                        FROM Dato_Complementarios__c 
                                                        WHERE Id_Prospecto__c IN: leadIds
                                                        AND RecordTypeId =: iRecordTypeId]){
            if (!iDComplementsMap.containsKey(dComplementItems.Id_Prospecto__c)) {
                iDComplementsMap.put(dComplementItems.Id_Prospecto__c, new List<Dato_Complementarios__c> {dComplementItems});
            } else {
                iDComplementsMap.get(dComplementItems.Id_Prospecto__c).add(dComplementItems);
            }
        }
        return iDComplementsMap;
    }

    /*
    * @Author          :   Georvys Gonzalez <ggonzroj@everis.com>
    * @Description     :   Helper Map de Account con lista de Dato_Complementarios__c relacionados dado su RecordTypeId.
    */
    public static Map<Id, List<Dato_Complementarios__c>> getDatosComplementByAccountAndRT (Set<Id> accountds, Id iRecordTypeId) {
        Map<Id, List<Dato_Complementarios__c>> iDComplementsMap = new Map<Id, List<Dato_Complementarios__c>>();
        for (Dato_Complementarios__c dComplementItems : [SELECT Id, Id_Prospecto__c, Tipo__c, Telefono__c, OwnerId,
                                                            Email__c, Apellido__c, Name, Rut__c,Participacion__c,
                                                            Contacto_Principal__c, RecordTypeId, Account__c
                                                        FROM Dato_Complementarios__c 
                                                        WHERE Account__c IN: accountds
                                                        AND RecordTypeId =: iRecordTypeId]){
            if (!iDComplementsMap.containsKey(dComplementItems.Account__c)) {
                iDComplementsMap.put(dComplementItems.Account__c, new List<Dato_Complementarios__c> {dComplementItems});
            } else {
                iDComplementsMap.get(dComplementItems.Account__c).add(dComplementItems);
            }
        }
        return iDComplementsMap;
    }

    /*
    * @Author          :   Georvys Gonzalez <ggonzroj@everis.com>
    * @Description     :   Helper Map de Leads con lista de Dato_Complementarios__c relacionados
    */
    public static Map<Id, List<Dato_Complementarios__c>> getlstDatosComplementByleadMp (Set<Id> leadIds) {
        Map<Id, List<Dato_Complementarios__c>> iDComplementsMap = new Map<Id, List<Dato_Complementarios__c>>();
        for (Dato_Complementarios__c dComplementItems : [SELECT Id, Id_Prospecto__c, Tipo__C, OwnerId,
                                                            Contacto_Principal__c, RecordTypeId
                                                        FROM Dato_Complementarios__c 
                                                        WHERE Id_Prospecto__c IN: leadIds ]){
            if (!iDComplementsMap.containsKey(dComplementItems.Id_Prospecto__c)) {
                iDComplementsMap.put(dComplementItems.Id_Prospecto__c, new List<Dato_Complementarios__c> {dComplementItems});
            } else {
                iDComplementsMap.get(dComplementItems.Id_Prospecto__c).add(dComplementItems);
            }
        }
        return iDComplementsMap;
    }

    /*
    * @Author          :   Georvys Gonzalez <ggonzroj@everis.com>
    * @Description     :   Update Dato_Complementarios__c, false en Contacto_Principal__c al record que no cambió a true
    */
    public static void updateLeadByNewCtcPrincipal (List<Dato_Complementarios__c> Dato_ComplementariosList, Map<ID,Dato_Complementarios__c> oldDato_ComplementariosMap){
        Set<Id> leadIds = new Set<Id>();
        Map<Id,Dato_Complementarios__c> mapDCUpdated = new Map<Id,Dato_Complementarios__c>();

        for(Dato_Complementarios__c iDComplements : Dato_ComplementariosList){
            Dato_Complementarios__c oldDComplement = oldDato_ComplementariosMap.get(iDComplements.Id);
            if (isChangeContact(iDComplements,oldDComplement) && iDComplements.Contacto_Principal__c) {
                leadIds.add(iDComplements.Id_Prospecto__c);
                mapDCUpdated.put(iDComplements.Id, iDComplements);
            }
        }

        Id iRecordTypeId = DatoComplementarioTriggerHelperB2b.getRecordTypeId(DC_RTYPE_CONTACTO_DEVELOPERNAME);
        // Map<Id, List<Dato_Complementarios__c>> mpLeadsDCid = getlstDatosComplementByleadMp(leadIds);
        Map<Id, List<Dato_Complementarios__c>> mpLeadsDCid = DatoComplementarioTriggerHelperB2b.getDatosComplementByleadAndRT(leadIds,iRecordTypeId);
        List<Dato_Complementarios__c> lstDCUpdateToFalse = new List<Dato_Complementarios__c>();
        List<Lead> ProspectosUpdateLst = new List<Lead>();

        for (Id Idlead : mpLeadsDCid.keySet()) {
            if (mpLeadsDCid.containsKey(Idlead)) {
                List<Dato_Complementarios__c> lstDatoComp = mpLeadsDCid.get(Idlead);
                for(Dato_Complementarios__c iDComplements : lstDatoComp){
                    if (!mapDCUpdated.containsKey(iDComplements.Id) && iDComplements.Contacto_Principal__c) {
                        lstDCUpdateToFalse.add(
                            new Dato_Complementarios__c(
                                Id = iDComplements.Id,
                                Contacto_Principal__c = false
                            )
                        );
                    } else if (mapDCUpdated.containsKey(iDComplements.Id)) {
                        Dato_Complementarios__c newCtcDComplement = mapDCUpdated.get(iDComplements.Id);
                        ProspectosUpdateLst.add(
                            new Lead(
                                Id        = newCtcDComplement.Id_Prospecto__c,
                                Phone     = (newCtcDComplement.Telefono__c != null && newCtcDComplement.Telefono__c != '') ? newCtcDComplement.Telefono__c : '',
                                Email     = (newCtcDComplement.Email__c != null && newCtcDComplement.Email__c != '') ? newCtcDComplement.Email__c : '',
                                FirstName = newCtcDComplement.Name,
                                LastName  = newCtcDComplement.Apellido__c 
                            )
                        );
                    }
                }    
            }
        }

        if (!lstDCUpdateToFalse.isEmpty()) {
            update lstDCUpdateToFalse;
        }
        if (!ProspectosUpdateLst.isEmpty()) {
            update ProspectosUpdateLst;
        }
    }

    
    // -- 20200817 Georvys Gonzalez <ggonzroj@everis.com>
    public static Boolean shouldUpdateLeadByContactoPrincipal(Dato_Complementarios__c newDC, Dato_Complementarios__c oldDC){
        return newDC.Contacto_Principal__c != oldDC.Contacto_Principal__c 
                && shouldUpdateLeadByContactoPrincipal(newDC);
    }

    // -- 20200817 Georvys Gonzalez <ggonzroj@everis.com>
    public static Boolean shouldUpdateLeadByContactoPrincipal(Dato_Complementarios__c newDC){
        return newDC.Contacto_Principal__c == true;
    }

    // -- 20200817 Georvys Gonzalez <ggonzroj@everis.com>
    public static Boolean hasChangedEmailPhoneName(Dato_Complementarios__c newDC, Dato_Complementarios__c oldDC){
        return  newDC.Email__c != oldDC.Email__c ||
                newDC.Telefono__c != oldDC.Telefono__c ||
                newDC.Apellido__c != oldDC.Apellido__c ||
                newDC.Name != oldDC.Name;
    }

    /*
    * @Author          :   Georvys Gonzalez <ggonzroj@everis.com>
    * @Description     :   Update info de Contacto en el Lead con los datos del nuevo Contacto_Principal__c en Dato_Complementarios__c
    */
    public static void populateCtcPrincipalInfoTolead(List<Dato_Complementarios__c> newList, Map<Id, Dato_Complementarios__c> oldMap){
        Map<Id, Dato_Complementarios__c> mapLeadDC = new Map<Id, Dato_Complementarios__c>();
        for (Dato_Complementarios__c iDatoComplementarios : newList){
            Dato_Complementarios__c oldDatoComplementarios = oldMap.get(iDatoComplementarios.Id);
            if(shouldUpdateLeadByContactoPrincipal(iDatoComplementarios, oldDatoComplementarios)
                || (hasChangedEmailPhoneName(iDatoComplementarios, oldDatoComplementarios) 
                    && shouldUpdateLeadByContactoPrincipal(iDatoComplementarios)) 
            ){
                mapLeadDC.put(
                    iDatoComplementarios.Id_Prospecto__c,
                    iDatoComplementarios
                );
            }
        }

        Map<Id, Lead> mpLeads = new Map<Id, Lead>(
		    [
		        SELECT Id, Name, 
                    Email, Phone,
                    FirstName, LastName
		        FROM Lead
		        WHERE Id IN: mapLeadDC.keySet()
		    ]
		);

        List<Lead> lstLead = new List<Lead>();
        for (Lead iLead : mpLeads.values()){
            if(mapLeadDC.containsKey(iLead.Id)){
                Dato_Complementarios__c iDC = mapLeadDC.get(iLead.Id);
                iLead.Email     =   iDC.Email__c;
                iLead.Phone     =   iDC.Telefono__c;
                iLead.FirstName =   iDC.Name;
                iLead.LastName  =   iDC.Apellido__c;
            }
        }

        update mpLeads.values();
    }
    
    /*
    * @Author          :   Georvys Gonzalez <ggonzroj@everis.com>
    * @Description     :   RECORD_TYPE_MAP_DEVELOPERNAME of Dato_Complementarios__c object
    */
    public static Map<String, RecordType> RECORD_TYPE_MAP_DEVELOPERNAME{
        get{
            if (RECORD_TYPE_MAP_DEVELOPERNAME == null){
                RECORD_TYPE_MAP_DEVELOPERNAME = new Map<String, RecordType>();

                List<RecordType> lstRecordType = [
                    SELECT Id,
                        Name, 
                        DeveloperName 
                    FROM RecordType 
                    WHERE SobjectType =: Dato_Complementarios__c.SObjectType.getDescribe().getName() 
                ];

                for (RecordType iRecordType : lstRecordType){
                    RECORD_TYPE_MAP_DEVELOPERNAME.put(iRecordType.DeveloperName, iRecordType);
                }
            }
            return RECORD_TYPE_MAP_DEVELOPERNAME;
        }
        set;
    }

    /*
    * @Author          :   Georvys Gonzalez <ggonzroj@everis.com>
    * @Description     :   Map of RecordTypeInfo
    */
    public static String getRecordTypeId (String developerName){
        return RECORD_TYPE_MAP_DEVELOPERNAME.get(developerName).Id;
    }

}