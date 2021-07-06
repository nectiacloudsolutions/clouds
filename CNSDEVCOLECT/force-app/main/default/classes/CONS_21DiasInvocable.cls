public class CONS_21DiasInvocable {
    @InvocableMethod(label='21 dias' description='21 dias')
    public static List<ID> sendCases(List<id> casos){
        system.debug('entro al invocable');
        List<ID> idscasos = new List<ID>();
        try{
            Case tmpCaseVal = new Case();
            
            Arbol_Comunicaciones__mdt arcom = [SELECT Numero_Linea__c, Id, Tipo__c, Subtipo__c, Plantilla__c, Estado_del_caso__c, Subestado_del_caso__c,Linea_de_negocio__c 
                            FROM Arbol_Comunicaciones__mdt WHERE Tipo__c='21 dias' 
                            AND Subtipo__c = '21 dias' LIMIT 1];
            CONS_EnvioReclamos_JSON j = new CONS_EnvioReclamos_JSON();
            string idcas=casos[0];
            case cas = [select Status,isClosed, id, Producto_del_Cliente_Nectia__r.Esquema_Nectia__c, Account.Name, CreatedDate, Rut_del_Cliente__c, Nueva_Instituci_n__c, Account.PersonEmail, Banco__c, CaseNumber, Producto_del_Cliente_Nectia__r.Poliza_Nectia__c, Type,Subtipo__c,Tipo_de_Modificaci_n__c, Tel_fono_de_contacto__c, N_mandato__c from case where id=:idcas  limit 1];
            if(!cas.isClosed){
                    j.nCelular = cas.Tel_fono_de_contacto__c == null?'': cas.Tel_fono_de_contacto__c;
                    j.nMandato = cas.N_mandato__c == null?'': cas.N_mandato__c;
                    j.nNumpoliza = cas.Producto_del_Cliente_Nectia__r.Poliza_Nectia__c == null?'': cas.Producto_del_Cliente_Nectia__r.Poliza_Nectia__c;
                    j.nNumsolicitud = cas.CaseNumber;
                    j.sResolucionCaso = '';
                    j.nTelefonoEjec = '';
                    j.sBanco = cas.Banco__c == null?'': cas.Banco__c;
                    j.sDoc_Adjunto = '';
                    j.sEmail = cas.Account.PersonEmail == null?'': cas.Account.PersonEmail;
                    j.sFechaCierre = '';
                    j.sNombreLiquidador = '';
                    j.sNombreTaller = '';    
                    j.sNominstitucion = cas.Nueva_Instituci_n__c == null?'': cas.Nueva_Instituci_n__c;
                 DateTime fechaendoso = null;
                if (fechaendoso != null){
                    String fendoso = fechaendoso.format('dd-MM-yyyy') ;
                    j.sFechaEfectivaEndoso = fendoso;
                }else{
                   j.sFechaEfectivaEndoso = '';
                }
                DateTime d = cas.CreatedDate;
                if (d != null){
                    String dateStr = d.format('dd-MM-yyyy') ;
                    j.sFechaRecepcion = dateStr;
                }else{
                    j.sFechaRecepcion = '';
                }
                j.sMailEjecutivo = '';
                j.sMotivoRechazo = '';
                j.sNombcaso = cas.Type+'-'+cas.Subtipo__c;
                j.sNombreCliente = cas.Account.Name;
                j.sNomEjecutivo = '';
                j.nNegocio = arcom.Numero_Linea__c;
                j.sLinNegocio = arcom.Linea_de_negocio__c;
                j.sPlantilla = arcom.Plantilla__c;
                
                j.sRutCliente = cas.Rut_del_Cliente__c;
                string envio = JSON.serialize(j);
                CONS_Comunicacionescierre call;
                string str = '';
                system.debug(cas.Producto_del_Cliente_Nectia__r.Esquema_Nectia__c);
                if(cas.Producto_del_Cliente_Nectia__r.Esquema_Nectia__c == 'INSUDB'){
                    CONS_Comunicacionescierre.Reclamos_21dias(cas.id);
                    
                }else if(cas.Producto_del_Cliente_Nectia__r.Esquema_Nectia__c == 'CLONINSUDB'){
                    CONS_Comunicacionescierre.Reclamos_21dias(cas.id);
                }else if(cas.Producto_del_Cliente_Nectia__r.Esquema_Nectia__c == 'SISRVOWCNS' || cas.Producto_del_Cliente_Nectia__r.Esquema_Nectia__c == 'SISRVOWPCNS' || cas.Producto_del_Cliente_Nectia__r.Esquema_Nectia__c == 'SISRVOWCNL'){
                    CONS_Comunicacionescierre.Reclamos_21dias(cas.id);
                }
                system.debug('respuesta del servicio '+str);
                Case tmpCaso = new Case();
                tmpCaso.Id = cas.Id;
                tmpCaso.Mensaje_Transaci_n__c = 'Solicitud de 21 dias';
               
                //update tmpCaso; 
            }
            
        }
        catch(Exception e){
            System.debug('Error: '+e);
        }  
        return idscasos;
    }
}