/*********************************************************************************************************
@Author       cagonzle@everis.com
@name         PF_CrearCaso_WSRest
@CreateDate   24/08/2019
@Description  W-000926 - (Portabilidad Financiera) - Integración con Analytics - Caso Retención 
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
24/08/2020                    cagonzle@everis.com                 Initial Version
**********************************************************************************************************/
public class PF_CasoSalidaNotiAnalytics {

	public static boolean justReturn;
    
    private static Id casoRTSalida = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(Label.PF_Caso_RecordType_Salida).getRecordTypeId();

	/**
	 * sendNotification Enviar la notificacion del caso de salida creado
	 * @param  body body Json con el request para el servicio
	 */
	public static Case sendNotificationWS(String body){ 
		justReturn = true;
		PortabilidadSegmentoReq psReq = (PortabilidadSegmentoReq) System.JSON.deserialize(body, PortabilidadSegmentoReq.class);
 		SalesCallout sc = new SalesCallout('ANALYTICS');
		String endPoint = 'portabilidad/segmento';
		String response = sc.dynamicRequestAnalytics(endPoint, body, 'POST');
		PortabilidadSegmentoRes psRes = (PortabilidadSegmentoRes) System.JSON.deserialize(response, PortabilidadSegmentoRes.class);
		psRes.respuesta.idCaso = psReq.idCaso; //Se supone que el servicio responde el mismo caso
		return updateCase(psReq, psRes, justReturn);
	}
	/**
	 * updateCase Mapeo de los campos de Caso con el Response
	 * @param  caso  caso Caso a actualizar
	 * @param  psRes psRes Response de Analytics
	 * @param  isJustReturn isJustReturn Indicate the DML action. True if it just return a Case object or False to Update the Case record
	 */
	private static Case updateCase(PortabilidadSegmentoReq psReq, PortabilidadSegmentoRes psRes, Boolean isJustReturn){
		Case caso = new Case(Id=psRes.respuesta.idCaso);
		if(psRes != null && psRes.respuesta != null && psRes.mensaje != null && psRes.mensaje == 'OK'){
            if(psReq.rtId.equals(casoRTSalida)){ 
                caso.put( Label.PF_Campo_Caso_Hipotecario_no_CNS, psRes.respuesta.hipotecario );
                caso.put( Label.PF_Campo_Caso_Hipotecario, psRes.respuesta.hipotecarioConCNS ); 
                caso.put( Label.PF_Campo_Caso_Segmentacion_Cliente, psRes.respuesta.segmentacionCliente );
            }
            
            if(!psReq.rtId.equals(casoRTSalida)){ //validacion mapeo caso entrada
                caso.put( Label.PF_Campo_Caso_Hipotecario_no_CNS, psRes.respuesta.hipotecarioConCNS );
                caso.put( Label.PF_Campo_Caso_Segmentacion_Cliente, psRes.respuesta.segmentacionCliente );                
            }

			if(!isJustReturn){ Update caso; }
		}
		return caso;
	}

	/**
	 * Clase bean con la estructura del Request
	 */
	public class PortabilidadSegmentoReq {
		String idCaso {get;set;}
		String rutCliente {get;set;}
		String numCaso {get;set;}
		String tipo {get;set;}
		String subTipo {get;set;}
		String estado {get;set;}
		String subEstado {get;set;}
		String origen {get;set;}
		String rtId  {get;set;}
		
		public PortabilidadSegmentoReq(Case c){
			this.idCaso = c.Id;
			this.rutCliente = c.Rut__c;
			this.numCaso = c.CaseNumber;
			this.tipo = c.Type;
			this.subTipo = c.Subtipo__c;
			this.estado = c.status;
			this.subEstado = c.Sub_estado_Nectia__c;
			this.origen = c.Causa_Origen__c;
			this.rtId = c.RecordTypeId;
		}
	}
	
	/**
	 * Clase bean con la estructura del Response
	 */
	public class PortabilidadSegmentoRes { 
		String codigo {get;set;}
		String mensaje {get;set;}
		Respuesta respuesta {get;set;}
	}
	
	public class Respuesta {
		String idCaso {get;set;}
		String rutCliente {get;set;}
		Boolean hipotecario {get;set;}
		Boolean hipotecarioConCNS {get;set;}
		String segmentacionCliente {get;set;}
	}
}