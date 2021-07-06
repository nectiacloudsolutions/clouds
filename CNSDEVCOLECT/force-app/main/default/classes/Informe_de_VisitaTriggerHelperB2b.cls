/*********************************************************************************************************
@Author       mbeltrab@everis.com
@name         Informe_de_VisitaTriggerHelperB2b
@CreateDate   13/08/2020
@Description  Helper of the Informe_de_Visita__c object B2b
***********************************************************************************************************
History of changes:
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments
-----------------------------------------------------------------------------------------------------------
12/08/2020                    mbeltrab@everis.com           Initial Version
**********************************************************************************************************/

public without sharing class Informe_de_VisitaTriggerHelperB2b {

    public static final String INFORMEDEVISITA = 'Informe_de_Visita__c';
    public static final String INFORMEDEVISITA_ESTADOENPROCESO = 'En proceso';
    public static final String INFORMEDEVISITA_ESTADOGENERADO = 'Generado';
    public static final String INFORMEDEVISITA_ERROR1 = 'No puede cambiar el estado a un Informe de visita Generado';


    // onAfterInsert anterior
    public static void insertInformeVisita(List<Informe_de_Visita__c> newInformeVisita) {
        try {
            Lead LeadUpdate = new Lead();
            List<Lead> LeadUpdateLst = new List<Lead>();

            for (Informe_de_Visita__c IV : newInformeVisita) {
                if (IV.Estado__c == INFORMEDEVISITA_ESTADOENPROCESO && !IV.IsInformeVisitaAccount__c) {
                    LeadUpdate = new Lead();
                    LeadUpdate.Id = IV.Id_Prospecto__c;
                    LeadUpdate.Informe_Visita_Generado__c = false;
                    LeadUpdateLst.add(LeadUpdate);
                }
            }

            if (LeadUpdateLst.size() > 0) {
                update LeadUpdateLst;
            }
        } catch (Exception e) {
            Trigger.new[0].addError('Error Catch Update:' + e.getMessage());
        }
    }


    /**
    * @description      Business Logic in Trigger Before Update
    * @author           mbeltrab@everis | 13 / 08 / 2020
    * @param            List<Informe_de_Visita__c> Informe_de_VisitaList, MAP<ID,Informe_de_Visita__c> oldInforme_de_VisitaMap
    * @return           void
    **/
    public static void updateLeadByInformeVisitaGenerado(List<Informe_de_Visita__c> Informe_de_VisitaList, Map<ID, Informe_de_Visita__c> oldInforme_de_VisitaMap) {
        try {
            Set<Id> IdProspectos = new Set<Id>();
            for (Informe_de_Visita__c CargaInforme_de_Visita : Informe_de_VisitaList) {
                IdProspectos.add(CargaInforme_de_Visita.Id_Prospecto__c);
            }
            Lead LeadUpdate = new Lead();
            List<Lead> LeadUpdateLst = new List<Lead>();

            Map<Id, Lead> getLeadsbyId = LeadTriggerHelperB2b.getLeadsbyId(IdProspectos);
            //List<Dato_Complementarios__c> DatosComplementariosByLeadId = DatoComplementarioTriggerHelperB2b.getDatosComplementariosByLeadId(IdProspectos);
            Map<Id, List<Dato_Complementarios__c>> mpIdleadByDC = DatoComplementarioTriggerHelperB2b.getlstDatosComplementByleadMp(IdProspectos);
            List<Linea_Bancaria__c> LineasBancariasByLeadId = LineaBancariaHelperB2b.getLineasBancariasByLeadId(IdProspectos);

            String MensajeError = '';
            for (Informe_de_Visita__c IV : Informe_de_VisitaList) {
                //if (IV.Estado__c == INFORMEDEVISITA_ESTADOGENERADO) { Anterior reemplazado    
                if (oldInforme_de_VisitaMap.get(IV.Id).Estado__c != IV.Estado__c && IV.Estado__c == INFORMEDEVISITA_ESTADOGENERADO) {
                    if (!IV.IsInformeVisitaAccount__c) {
                        List<Dato_Complementarios__c> DatosComplementariosByLeadId = mpIdleadByDC.containsKey(IV.Id_Prospecto__c) 
                                                                                ? mpIdleadByDC.get(IV.Id_Prospecto__c) 
                                                                                : new List<Dato_Complementarios__c>();

                        MensajeError = ValidarCamposenLeadParaInformedeVisita(getLeadsbyId.get(IV.Id_Prospecto__c), DatosComplementariosByLeadId, LineasBancariasByLeadId);

                        if (MensajeError != '')
                            IV.addError(MensajeError);
                        else {
                            LeadUpdate = new Lead();
                            LeadUpdate.Id = IV.Id_Prospecto__c;
                            LeadUpdate.Informe_Visita_Generado__c = true;
                            LeadUpdateLst.add(LeadUpdate);
                        }
                    }
                }
            }

            if (LeadUpdateLst.size() > 0) {
                update LeadUpdateLst;
            }

        } catch (Exception e) {
            Trigger.new[0].addError('Error Catch Update:' + e.getMessage());
        }
    }

    /**
      * @description       This method return String with the error message
      * @param1            Lead object
      * @return            String with message if field is not complete
    */
    public static String ValidarCamposenLeadParaInformedeVisita(Lead ilead, List<Dato_Complementarios__c> DatosComplementarios, List<Linea_Bancaria__c> LineasBancarias){
        String mensaje = '';
        Integer IntLineasBancarias = 0;
        Integer IntSocios = 0;
        Integer IntContactos = 0;
        Integer IntProveedores = 0;
        Integer IntClientes = 0;
        
        for (Linea_Bancaria__c LB: LineasBancarias){
            if(LB.Id_Prospecto__c == ilead.Id){
                IntLineasBancarias++;
            }
        }

        for (Dato_Complementarios__c DC: DatosComplementarios){
            if(DC.Id_Prospecto__c == ilead.Id){
                if(DC.Tipo__C == DatoComplementarioTriggerHelperB2b.DATOCOMPLEMENTARIO_TIPOCONTACTO && DC.Contacto_Principal__c){
                    IntContactos++;
                }ELSE IF(DC.Tipo__C == DatoComplementarioTriggerHelperB2b.DATOCOMPLEMENTARIO_TIPOSOCIO){
                    IntSocios++;   
                }ELSE IF(DC.Tipo__C == DatoComplementarioTriggerHelperB2b.DATOCOMPLEMENTARIO_TIPOCLIENTEPROSPECTO){
                    IntClientes++;   
                }ELSE IF(DC.Tipo__C == DatoComplementarioTriggerHelperB2b.DATOCOMPLEMENTARIO_TIPOPROVEEDOR){
                    IntProveedores++;   
                }
            }
        }
        
        If(ilead.Company == '' || ilead.Company == null){
            mensaje += '-Ingrese Razón social ';
        }
        If(ilead.LeadSource == '' || ilead.LeadSource == null){
            mensaje += '-Ingrese Origen del prospecto ';
        }
        If(ilead.RUTEmpresa__c == '' || ilead.RUTEmpresa__c == null){
            mensaje += '-Ingrese Rut del Prospecto ';
        }
        If(ilead.region_sales__c == '' || ilead.region_sales__c == null){
            mensaje += '-Ingrese Región del prospecto ';
        }
        If(ilead.Direccion_Oficina__c == '' || ilead.Direccion_Oficina__c == null){
            mensaje += '-Ingrese Dirección del prospecto ';
        }
        If(ilead.comuna_sales__c == '' || ilead.comuna_sales__c == null){
            mensaje += '-Ingrese Comuna del prospecto ';
        }
        If(ilead.NumberOfEmployees == 0 || ilead.NumberOfEmployees == null){
            mensaje += '-Ingrese N° de empleados del prospecto ';
        }
        If(ilead.SBIF_Comercial__c == 0 || ilead.SBIF_Comercial__c == null){
            mensaje += '-Ingrese SBIF Comercial ';
        }
        If(ilead.SBIF_Contingente__c == null){
            mensaje += '-Ingrese SBIF Contigente ';
        }
        If(ilead.SBIF_Leasing__c == null){
            mensaje += '-Ingrese SBIF Leasing ';
        }
        If(ilead.Deuda_Achef__c == null){
            mensaje += '-Ingrese Deuda Achef ';
        }
        
        If(ilead.Venta_Anual__c == null){
            mensaje += '-Ingrese Venta Anual ';
        }
        If(ilead.Deuda_Financiera__c == null){
            mensaje += '-Ingrese Deuda Financiera ';
        }
        If(ilead.Utilidad__c == null){
            mensaje += '-Ingrese Utilidad ';
        }
        If(ilead.Patrimonio__c == null){
            mensaje += '-Ingrese Patrimonio ';
        }
        If(ilead.Moneda__c == null && ilead.Moneda__c == '' ){
            mensaje += '-Ingrese Moneda ';
        }
        If(ilead.Nivel_de_Importaciones__c == null){
            mensaje += '-Ingrese Nivel de Importaciones ';
        }
        If(ilead.Actividad_Economica__c == null || ilead.Actividad_Economica__c == ''){
            mensaje += '-Ingrese Actividad Económica ';
        }
        If(ilead.Giro_de_la_empresa__c == null || ilead.Giro_de_la_empresa__c ==''){
            mensaje += '-Ingrese Giro de la Empresa ';
        }
        If(ilead.Cuenta_Corriente__c == false && ilead.Creditos_comerciales__c ==false && ilead.Factoring__c == false && ilead.Leasing__c == false && ilead.Comex__c == false && ilead.Boletas_Garantia__c == false && ilead.Cash_Management__c == false && ilead.Financiamiento_Inmobiliario__c == false && ilead.Mesa_de_Dinero__c == false){
            mensaje += '-Ingrese al menos un producto en los que opera el prospecto ';
        }

        if(IntLineasBancarias == 0){
            mensaje += '-Ingrese al menos una línea Bancaria del prospecto ';
        }
        if(IntSocios == 0){
            Mensaje += '-Ingrese al menos un Socio del prospecto Activo ';
        }
        if(IntContactos == 0){
            mensaje += '-Ingrese al menos un Contacto del prospecto Principal Activo ';
        }
        if(IntProveedores == 0){
            mensaje += '-Ingrese al menos un Proveedor del prospecto Activo ';
        }
        if(IntClientes  == 0){
            mensaje += '-Ingrese al menos un Cliente del prospecto Activo ';
        }
        
        return mensaje;
    }

    /*
    * @Author          :   Georvys Gonzalez <ggonzroj@everis.com>
    * @Description     :   validar campos para Informes de Visita en estado Generado de las Accounts
    */
    public static void validateAccountsFieldsToInformesGenerados(List<Informe_de_Visita__c> newList, Map<ID, Informe_de_Visita__c> oldMap){
        Set<Id> setAccountId = new Set<Id>();
        List<Informe_de_Visita__c> newListInformes = new List<Informe_de_Visita__c>();

        for (Informe_de_Visita__c iInfo : newList) {
            if (oldMap != null) {
                Informe_de_Visita__c informeOld = oldMap.get(iInfo.Id);
                if (iInfo.Estado__c != informeOld.Estado__c 
                    && iInfo.Estado__c == INFORMEDEVISITA_ESTADOGENERADO ) {

                    if (iInfo.IsInformeVisitaAccount__c) {
                        if (String.isNotBlank(iInfo.Account__c)) {
                            setAccountId.add(iInfo.Account__c);
                            newListInformes.add(iInfo);
                        }
                    }
                }
            }
        }

        if (!setAccountId.isEmpty()) {
            Map<Id, Account> mapAccounts = new Map<Id, Account>(
            [
                SELECT Id, Name, RUT__c, Rut_Ejecutivo_Banco__c,
                    Calle_Nectia__c, NumberOfEmployees, 
                    SBIF_Comercial__c, SBIF_Contingente__c, 
                    SBIF_Leasing__c, Venta_Anual__c,
                    Ebitda__c, Utilidad__c, Patrimonio__c, 
                    Moneda__c, Cuenta_Corriente__c, 
                    Creditos_Comerciales__c, Leasing__c, 
                    Comex__c, Boletas_Garantia__c,
                    Cash_Management__c, Mesa_de_Dinero__c,
                    Financiamiento_Inmobiliario__c, 
                    (SELECT Id, FirstName, 
                        Contacto_Principal__c, 
                        LastName, AccountId 
                    FROM Contacts 
                    WHERE Contacto_Principal__c = true)
                FROM Account 
                WHERE Id IN: setAccountId
            ]);

            Id iRecordTypeIdSocio = DatoComplementarioTriggerHelperB2b.getRecordTypeId(DatoComplementarioTriggerHelperB2b.DC_RTYPE_SOCIO_DEVELOPERNAME);
            Id iRecordTypeIdCliente = DatoComplementarioTriggerHelperB2b.getRecordTypeId(DatoComplementarioTriggerHelperB2b.DC_RTYPE_CLIENTE_DEVELOPERNAME);
            Id iRecordTypeIdProveedor = DatoComplementarioTriggerHelperB2b.getRecordTypeId(DatoComplementarioTriggerHelperB2b.DC_RTYPE_PROVEEDORES_DEVELOPERNAME);

            Map<Id, List<Dato_Complementarios__c>> mpAccDCSocio     = DatoComplementarioTriggerHelperB2b.getDatosComplementByAccountAndRT(mapAccounts.keySet(),iRecordTypeIdSocio);
            Map<Id, List<Dato_Complementarios__c>> mpAccDCCliente   = DatoComplementarioTriggerHelperB2b.getDatosComplementByAccountAndRT(mapAccounts.keySet(),iRecordTypeIdCliente);
            Map<Id, List<Dato_Complementarios__c>> mpAccDCProveedor = DatoComplementarioTriggerHelperB2b.getDatosComplementByAccountAndRT(mapAccounts.keySet(),iRecordTypeIdProveedor);
            Map<Id, List<Linea_Bancaria__c>> mpAcclineaBancarias    = LineaBancariaHelperB2b.getlineasBancariaByAccount(mapAccounts.keySet());

            String mensaje = '';
            for (Informe_de_Visita__c iInfo : newListInformes) {
                if (String.isNotBlank(iInfo.Account__c) && mapAccounts.containsKey(iInfo.Account__c)) {
                    Account iAccount = mapAccounts.get(iInfo.Account__c);
                    if (iAccount.Contacts == null) {
                        mensaje += '-Ingrese al menos un Contacto Principal Activo a la cuenta ';
                    }
                    if (iInfo.FechaProgramadaVisita__c == null) {
                        mensaje += '-Ingrese fecha Programada de la Visita ';
                    }
                    mensaje += validarfieldsToInformeVisita(iAccount, mpAccDCSocio, mpAccDCCliente, mpAccDCProveedor, mpAcclineaBancarias);
                    if (mensaje != '') {
                        iInfo.addError(mensaje);
                    }
                }
            }
        }

    }

    /*
    * @Author          :   Georvys Gonzalez <ggonzroj@everis.com>
    * @Description     :   validar campos para Informes de Visita en estado Generado
    */
    public static String validarfieldsToInformeVisita(Account iAccount, 
                        Map<Id, List<Dato_Complementarios__c>> mpAccDCSocio,    
                        Map<Id, List<Dato_Complementarios__c>> mpAccDCCliente,
                        Map<Id, List<Dato_Complementarios__c>> mpAccDCProveedor,
                        Map<Id, List<Linea_Bancaria__c>> mpAcclineaBancarias){
        String mensaje = '';

        if(iAccount.RUT__c == '' || iAccount.RUT__c == null){
            mensaje += '-Ingrese RUT de la Cuenta ';
        } 
        // if(iAccount.Rut_Ejecutivo_Banco__c == '' || iAccount.Rut_Ejecutivo_Banco__c == null){
        //     mensaje += '-Ingrese Rut ejecutivo de la Cuenta ';
        // }                                            
        if(iAccount.Calle_Nectia__c == '' || iAccount.Calle_Nectia__c == null){
            mensaje += '-Ingrese Dirección Empresa de la Cuenta ';
        }  
        if(iAccount.NumberOfEmployees == 0 || iAccount.NumberOfEmployees == null){
            mensaje += '-Ingrese Número Empleado de la Cuenta ';
        }  
        if(iAccount.Venta_Anual__c == 0 || iAccount.Venta_Anual__c == null){
            mensaje += '-Ingrese Venta Anual de la Cuenta ';
        } 
        if(iAccount.Ebitda__c == 0 || iAccount.Ebitda__c == null){
            mensaje += '-Ingrese Ebitda de la Cuenta ';
        } 
        if(iAccount.Utilidad__c == 0 || iAccount.Utilidad__c == null){
            mensaje += '-Ingrese Utilidad de la Cuenta ';
        } 
        if(iAccount.Patrimonio__c == 0 || iAccount.Patrimonio__c == null){
            mensaje += '-Ingrese Patrimonio de la Cuenta ';
        }
        if(iAccount.Moneda__c == '' || iAccount.Moneda__c == null){
            mensaje += '-Ingrese Moneda de la Cuenta ';
        }

        if(iAccount.Cuenta_Corriente__c == false 
        && iAccount.Creditos_Comerciales__c == false
        && iAccount.Leasing__c == false
        && iAccount.Comex__c == false
        && iAccount.Boletas_Garantia__c == false
        && iAccount.Cash_Management__c == false
        && iAccount.Financiamiento_Inmobiliario__c == false ){
            mensaje += '-Ingrese al menos un Producto en el que opera la Cuenta ';
        }

        // ------------------- Dato_Complementarios Socios --------------------------
        if (mpAccDCSocio != null && !mpAccDCSocio.containsKey(iAccount.Id)) {
            mensaje += '-Ingrese al menos un Socio Activo del dato complementario ';
        } else {
            List<Dato_Complementarios__c> lstSocios = mpAccDCSocio.get(iAccount.Id);
            for (Dato_Complementarios__c socio : lstSocios) {
                if(socio.Tipo__c == '' || socio.Tipo__c == null){
                    mensaje += '-Ingrese Tipo Integrante del dato complementario ';
                }
                if(socio.Participacion__c == 0 || socio.Participacion__c == null){
                    mensaje += '-Ingrese Tipo Integrante del datos complementario ';
                }
                if(socio.Rut__c == '' || socio.Rut__c == null){
                    mensaje += '-Ingrese RUT del dato complementario ';
                }
            }
        }

        // ------------------- Dato_Complementarios de Cliente --------------------------
        if (mpAccDCCliente != null && !mpAccDCCliente.containsKey(iAccount.Id)) {
            mensaje += '-Ingrese al menos un Cliente activo del dato complementario ';
        }

        // ------------------- Dato_Complementarios de proveedor --------------------------
        if (mpAccDCProveedor != null && !mpAccDCProveedor.containsKey(iAccount.Id)) {
            mensaje += '-Ingrese al menos un proveedor activo del dato complementario ';
        }
        
        // ------------------- Linea_Bancaria__c  --------------------------
        if (mpAcclineaBancarias != null && !mpAcclineaBancarias.containsKey(iAccount.Id)) {
            mensaje += '-Ingrese al menos una linea Bancaria activa ';
        } else {
            List<Linea_Bancaria__c> lstlineaBancarias = mpAcclineaBancarias.get(iAccount.Id);
            if (lstlineaBancarias.isEmpty()) {
                mensaje += '-Ingrese al menos una linea Bancaria activa ';
            } else {
                for (Linea_Bancaria__c linea : lstlineaBancarias) {
                    if(linea.Banco__c == '' || linea.Banco__c == null){
                        mensaje += '-Ingrese el Nombre del Banco de línea bancaria ';
                    }
                    if(linea.Monto_Aprobado__c == 0 || linea.Monto_Aprobado__c == null){
                        mensaje += '-Ingrese el Monto Aprobado de línea bancaria ';
                    }
                    if(linea.Monto_Utilizado__c == 0 || linea.Monto_Utilizado__c == null){
                        mensaje += '-Ingrese el Monto Utilizado de línea bancaria ';
                    }
                }
            }
        }

        return mensaje;
    }

    /*
    * @Author          :   Georvys Gonzalez <ggonzroj@everis.com>
    * @Description     :   Helper Map de Leads con lista de Dato_Complementarios__c relacionados
    */
    public static Map<Id, List<Informe_de_Visita__c>> getMapInformeslstBylead (Set<Id> leadIds) {
        Map<Id, List<Informe_de_Visita__c>> mapInformes = new Map<Id, List<Informe_de_Visita__c>>();
        for (Informe_de_Visita__c info : [SELECT Id, Id_Prospecto__c, 
                                                Name, OwnerId
                                            FROM Informe_de_Visita__c 
                                            WHERE Id_Prospecto__c IN: leadIds ]){
            if (!mapInformes.containsKey(info.Id_Prospecto__c)) {
                mapInformes.put(info.Id_Prospecto__c, new List<Informe_de_Visita__c> {info});
            } else {
                mapInformes.get(info.Id_Prospecto__c).add(info);
            }
        }
        return mapInformes;
    }

}