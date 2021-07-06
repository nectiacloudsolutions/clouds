public without sharing class Constants {
    
    public Constants(){}

    public static final String RUT = 'RUT';
    public static final String ACCOUNT = 'Account';
    public static final String CONTACT = 'Contact';
    public static final String LEAD = 'Lead';
    public static final String EVENT = 'Event';
    public static final String CAMPAIGN = 'Campaign';
    public static final String OPPORTUNITY = 'Opportunity';
    public static final String PRODUCT2 = 'Product2';
    public static final String QUOTE = 'Quote';
    public static final String CASE_OBJECT = 'Case';
    public static final String OPPORTUNITY_STAGE_CONTACTO = 'Contacto';
    public static final String OPPORTUNITY_STAGE_INGRESO_NEGOCIO = 'Ingreso del Negocio';
    public static final String OPPORTUNITY_STAGE_TRASPASO = 'Traspaso';
    public static final String LEAD_OWNER = 'LeadOwner';
    public static final String ACCOUNT_OWNER = 'AccountOwner';
    public static final String PLAN_PLUS = 'Plan Plus';
    public static final String OFERTA = 'Oferta__c';
    public static final String TOAST_WARNING = 'warning';
    public static final String TOAST_ERROR = 'error';
    /*
	Constantes Campañas
*/
	public static final String CAMPAIGN_STATUS_INGRESADA = 'Ingresada';    
    
	public static final String LEAD_STATUS_CONVERTIDO = 'Convertido';
    public static final String LEAD_STATUS_NO_INTERESADO = 'No_Interesado';
    public static final String LEAD_STATUS_GESTIONADO = 'Gestionado';
    public static final String LEAD_STATUS_CREADO = 'No Gestionado';
     
    public static final String TASK_SUBJECT_CALL = 'Call';
    public static final String TASK_SUBJECT_LLAMADA = 'LLamada';
    public static final String TASK_SUBJECT_ENTREVISTA = 'Entrevista';
    public static final String TASK_SUBJECT_ASIGNACION = 'Asignación';
    public static final String TASK_SUBJECT_PRIMERARETENCION = 'Primera Retención';
    public static final String TASK_SUBJECT_SEGUNDARETENCION = 'Segunda Retención';
    
    public static final String TASK_STATUS_COMPLETADA = 'Completada';
    public static final String TASK_STATUS_ABIERTA = 'Abierta';

    public static final String TASK_RESULTADO_AGENDAR = 'Agendar';
    public static final String TASK_RESULTADO_VOLVER_LLAMAR = 'Volver a Llamar';
    public static final String TASK_RESULTADO_NO_CONTESTA = 'No Contesta';
    public static final String TASK_RESULTADO_NO_INTERESA = 'No le interesa';

    public static final String EVENT_SUBJECT_ENTREVISTA = 'Entrevista';
    public static final String EVENT_SUBJECT_AGENDA = 'Agenda';
    
    public static final String EVENT_TYPE_ENTREVISTA = 'Meeting';
    public static final String EVENT_TYPE_LLAMADA = 'Call';

    public static final String EVENT_ESTADO_LLAMADA_CONTACTADO = 'Contactado';
    public static final String EVENT_ESTADO_LLAMADA_NOCONTACTADO = 'No Contactado';

    public static final String EVENT_ESTADO_ENTREVISTA_EXITOSO = 'Exitosa';
    public static final String EVENT_ESTADO_ENTREVISTA_NOEXITOSO = 'No Exitosa';

    //Contactado
    public static final String EVENT_RESULTADO_LLAMADA_LLAMAR = 'Volver a Llamar';
    public static final String EVENT_RESULTADO_LLAMADA_ENTEVISTA = 'Entrevista';
    public static final String EVENT_RESULTADO_LLAMADA_EXITOSA = 'Llamada Exitosa';
    public static final String EVENT_RESULTADO_LLAMADA_NOINTERESA = 'No interesado';  

    //No Contactado  
    public static final String EVENT_RESULTADO_LLAMADA_EQUIVOCADO_N ='Numero equivocado'; 
    public static final String EVENT_RESULTADO_LLAMADA_EQUIVOCADO = 'Numero equivocado';
    public static final String EVENT_RESULTADO_LLAMADA_NOEXISTE = 'Numero no existe';
    public static final String EVENT_RESULTADO_LLAMADA_NOCONTESTALLAMAR = 'No Contesta(Volver a Llamar)';
    public static final String EVENT_RESULTADO_LLAMADA_NOCONTESTAINUBICABLE = 'No Contesta(Inubicable)';

    //No Exitoso   
    public static final String EVENT_RESULTADO_ENTREVISTA_LLAMAR = 'Suspendida(Volver a llamar)';
    public static final String EVENT_RESULTADO_ENTREVISTA_ENTEVISTAR = 'Suspendida(Volver a entrevistar)';
    public static final String EVENT_RESULTADO_ENTREVISTA_NOINTERESA = 'No interesado';
    
    public static final String EVENT_RESULTADO_VOLVER_ENTREVISTAR = 'Volver a Entrevistar';
    public static final String EVENT_RESULTADO_VOLVER_LLAMAR = 'Volver a llamar';
    public static final String EVENT_RESULTADO_SUSPENDIDO = 'Suspendido';
    public static final String EVENT_RESULTADO_REUNION_EXITOSA = 'Reunión Exitosa';
    public static final String EVENT_RESULTADO_NO_LE_INTERESA = 'No le interesa';
    
    public static final String EVENT_MOTIVO_NO_INTERESA = 'Descontento con Consorcio';
    
    /*
	CONSTANTES PICLIST LEAD 
*/
    public static final String ACCOUNT_PICKLISTS_NINGUNO = '--Ninguno--';
    /*
     * CONSTANTES STATUS CAMPAÑA
	*/
    public static final String CAMPAIGN_STATUS_ACTIVADA = 'Activada';
    public static final String CAMPAIGN_STATUS_SUSPENDIDA = 'Suspendida';
    
    /*
     * CONSTANTES RECORD TYPE CAMPAIGN
	*/
    
    public static final String RECORDTYPE_RP_SALES_CAMPAIGN = 'cnf_sal_rp_campania_sales';
	public static final String RECORDTYPE_CAMPAIGN_SALES_PERSONA = 'sales_personas';
    /*
		CONSTANTES RECORD TYPE PERSON ACCOUNT
	*/
    public static final String RECORDTYPE_PERSON_ACCOUNT_SEGUROS = 'Cliente_Persona_Seguros';
    /*
	CONSTANTES RECORD TYPE TASK
	*/
    public static final String RECORDTYPE_TASK_P_RETENCION = 'Tareas_Retencion';
    /*
      CONSTANTES RECORD TYPE LEAD
	*/
    public static final String RECORDTYPE_SALES_LEAD_PERSONAS = 'sales_lead_personas';
    
    /*
     * CONSTANTES RECORD TYPE OPPORTUNITY
	*/
    public static final String RECORDTYPE_SEGURO_VIDA= 'Sales_Opp_Seguro_Vida';
    public static final String RECORDTYPE_BANCA_HIPOTECARIO= 'sales_banca_hipotecario';
    public static final String RECORDTYPE_BANCA_HIPOTECARIO_LECTURA= 'sales_banca_hipotecario_lectura';
    public static final String RECORDTYPE_AUTO= 'Sales_Seguros_Auto';
    public static final String RECORDTYPE_HOGAR= 'Sales_Seguros_Hogar';
    public static final String RECORDTYPE_BANCA_PLAN_PLUS= 'plan_plus_sales';
    public static final String RECORDTYPE_BANCA_PLAN_PLUS_LECTURA= 'plan_plus_lectura_sales';
    public static final String RECORDTYPE_BANCA_CREDITO_CONSUMO='sales_credito_consumo';
    public static final String RECORDTYPE_BANCA_CREDITO_CONSUMO_LECTURA='sales_credito_consumo_lectura';
    public static final String RECORDTYPE_SEGURO_VIDA_COTIZADOR = 'SalesSegurosVidaCotizador';

    /*
     * CONSTANTES RECORD TYPE QUOTE
	*/
    public static final String RECORDTYPE_QUOTE_SEGURO_VIDA = 'cnf_sales_rt_cotizacion';
    public static final String RECORDTYPE_QUOTE_BANCA_HIPOTECARIO = 'Quote_Banca_Hipotecario';
    public static final String RECORDTYPE_QUOTE_AUTO = 'Sales_Seguros_Auto';
    public static final String RECORDTYPE_QUOTE_HOGAR = 'Sales_Seguros_Hogar';
    public static final String RECORDTYPE_QUOTE_CREDITO_CONSUMO = 'quote_banca_consumo';
    public static final String RECORDTYPE_QUOTE_CREDITO_CONSUMO_LECTURA = 'quote_banca_consumo_lectura';
    public static final String RECORDTYPE_QUOTE_AUTO_COTIZADOR = 'Sales_Seguros_Auto_Cotizador';
    public static final String RECORDTYPE_QUOTE_VIDA_COTIZADOR = 'SalesSegurosVidaCotizador';
    public static final String RECORDTYPE_QUOTE_VIDA_COTIZADOR_LECTURA = 'SalesSegurosVidaCotizadorLectura';
    
    /*
     * CONSTANTES STATUS QUOTE
	*/
    public static final String STATUS_QUOTE_CERRADO = 'Cerrado';

    /*
     * CONSTANTES RECORD TYPE EVENT
	*/
    public static final String RECORDTYPE_EVENT_LLAMADA= 'llamada_sales';
    public static final String RECORDTYPE_EVENT_AGENDA= 'cnf_sales_rt_Agenda_Event';
    
    public static final String PRICEBOOK_NAME = 'Standard Price Book';
    public static final String PRICEBOOK_NAME1 = 'Standard Price Book1';
/*
     * CONSTANTES STAGES OPPORTUNITY
	*/
    public static final String OPPORTUNITY_STAGENAME_COTIZACION= 'Cotización';
    public static final String OPPORTUNITY_STAGENAME_EVALUACION= 'Evaluación';
    public static final String OPPORTUNITY_STAGENAME_SIMULACION= 'Simulación';
    public static final String OPPORTUNITY_STAGENAME_FORMALIZACION= 'Formalización';
    public static final String OPPORTUNITY_STAGENAME_RECOPILACION= 'Recopilación';
    public static final String OPPORTUNITY_STAGENAME_CIERRE_PERDIDA='Cierre Perdida';
    public static final String OPPORTUNITY_STAGENAME_CIERRE_GANADA='Cierre Ganada';
    public static final String OPPORTUNITY_STAGENAME_CONTACTO='Contacto';
    public static final String OPPORTUNITY_STAGENAME_CURSE ='Curse';
    public static final String OPPORTUNITY_STAGENAME_INSCRIPCION ='Inscripción';
    
    /*
     * CONSTANTES RECORD TYPE CASE
	*/
    public static final String RECORDTYPE_CASE_CORPORATIVOS = 'casos_corporativos';

 /*
     * CONSTANTES CODIGOS DE RESPUESTA
	*/
    public static final String RESPONSE_200 = '200';
    public static final String RESPONSE_201 = '201';
    public static final String RESPONSE_400 = '400';
    public static final String RESPONSE_401 = '401';
    public static final String RESPONSE_OK = 'OK';
    public static final String RESPONSE_FORBIDDEN = 'Forbidden';
    
    /*
     * CONSTANTES ACTION WIZARD LEAD
	*/
    public static final String CONSULT = 'CONSULT';
    public static final String MODIFIED = 'MODIFIED';
    public static final String INSERTED = 'INSERTED';
    public static final String REASSIGN = 'REASSIGN';
    public static final String CONVERTED = 'CONVERTED';
    public static final String CHANGE_STATUS = 'CHANGE_STATUS';
    public static final String CHANGE_OWNER = 'CHANGE_OWNER';
    public static final String REFER_EXECUTIVE = 'REFER_EXECUTIVE';

    /*
    * CONSTANTES INVOKE CALLOUT
	*/
    public static final String ANALYTICSLEAD = 'ANALYTICS';
    public static final String VTIME = 'VTIME';
    public static final String ALERTAS = 'ALERTAS';
    public static final String CUMBRES = 'CUMBRES';
    public static final String ALFRESCO = 'ALFRESCO';
    public static final String ANALYTICSMARCA = 'ANALYTICSMARCA';
    public static final String DOCUWARE = 'DOCUWARE';
    public static final String COTIZADOR = 'COTIZADOR';

    public static final String ICON_MEETING = 'meeting.ics';

    public static final String WITHDOT = 'WITHDOT';
    public static final String WITHOUTDOT = 'WITHOUTDOT';

    public static final String REQUEST_METHOD_POST = 'POST';
    public static final String REQUEST_METHOD_GET = 'GET';

    public static final String REQUEST_ANALYTICS_ORIGIN = 'formulario-preguntas-detector-necesidades';
    
    public static final String EJECUTIVAVENTAS = 'Ejecutivo de Venta';
    public static final String CAMPAIGN_MEMBER_ERROR1 = 'Rut {0} de cliente no existe';
    public static final String CAMPAIGN_MEMBER_ERROR2 = 'Rut {0} de cliente invalido';    
    public static final String CAMPAIGN_MEMBER_ERROR3 = 'Rut {0} de ejecutivo no existe o no tiene licencia';
    public static final String CAMPAIGN_MEMBER_ERROR4 = 'Rut {0} de ejecutivo invalido';
    public static final String CAMPAIGN_MEMBER_ERROR5 = 'El propietario del miembro de campaña es distinto al propietario del cliente';
    public static final String CAMPAIGN_MEMBER_ERROR6 = 'El propietario del miembro de campaña es distinto al propietario del prospecto';
    public static final String CAMPAIGN_MEMBER_ERROR7 = 'No se puede cargar un cliente a una campaña de prospectos';
    public static final String CAMPAIGN_MEMBER_ERROR8 = 'No se puede cargar un prospecto a una campaña de clientes';

    public static final String CAMPAIGN_TYPE_CLIENTES = 'Clientes';
    public static final String CAMPAIGN_TYPE_CANDIDATOS = 'Candidatos';
    
    public static final String PARTICIPANT_ERROR1 = 'ERROR: Contactar a su administrador';
    
    public static final String EVENT_ERROR1 = 'Debe completar los campos N° de documento y Tipo de documento';
    public static final String EVENT_ERROR2 = 'No es posible Enviar un Cita si el Candidato no tiene Email';
    public static final String EVENT_ERROR3 = 'No es posible Enviar un Cita si el Cliente no tiene Email';
    
    public static final String NUM_OP_COMERCIALIZA = 'Número Oportunidad Comercializador';
    public static final String EXCEPTION_DOCUMENT = 'El tipo de documento ya se encuentra solicitado';
    public static final String MESSAGE_COTIZADOR_PRODUCTO_NO_POSEE = 'El Producto Seleccionado NO tiene Cotizador';
    public static final String MESSAGE_COTIZADOR_ETAPA = 'Sólo se puede acceder al cotizador en etapa Cotización o Ingreso de Negocio';
    public static final String MESSAGE_COTIZADOR_NO_TIENE_PERMISO = 'No puede acceder al flujo cotizador';
    /*
     * CONSTANTES COMPONENTE REFERIR  
     */
    public static final String OPPORTUNITY_ERROR_ETAPA = 'ERROR_ETAPA';
    public static final String OPPORTUNITY_ERROR_USUARIO = 'ERROR_USUARIO';
    public static final String OPPORTUNITY_ERROR_DOCUMENTOS = 'ERROR_DOCUMENTOS';
    public static final String OPPORTUNITY_ERROR_PRODUCTO = 'ERROR: la oportunidad no tiene un producto asociado';
    public static final String OPPORTUNITY_ERROR_USER_NOTFOUND = 'ERROR: No se encontró un usuario para reasignar';
    public static final String OPPORTUNITY_ERROR_EXCEPTION = 'ERROR: Ha ocurrido un error, favor contactar con el Administrador';

    public static final String EMAIL_EJECUTIVO_VF ='cnf_sal_et_adjunto_campania_vf';

    /*
     * CONSTANTES PERFILES
	*/
    public static final String PROFILE_EJECUTIVO_VENTA = 'Ejecutivo de Venta';
    public static final String PROFILE_EJECUTIVO_ESPECIALISTA = 'Ejecutivo Especialista';
    public static final String PROFILE_EJECUTIVO_VISADO = 'Ejecutivo de Visado';
    public static final String PROFILE_EJECUTIVO_DE_RELACIONAMIENTO = 'Ejecutivo de Relacionamiento';
    public static final String PROFILE_EJECUTIVO_DE_RIESGO = 'Ejecutivo de Riesgo';
    public static final String PROFILE_JEFE_PLATAFORMA_HIPOTECARIO = 'Jefe Plataforma Hipotecario';
    public static final String PROFILE_EJECUTIVO_ATENCION_CLIENTE='Ejecutivos de Atención al Cliente Seguros Comercial';
    public static final String PROFILE_JEFE_ATENCION_CLIENTE='Jefe de Atención al Cliente Seguros Comercial';
    public static final String PROFILE_EJECUTIVO_PRESENCIAL = 'Ejecutivos de Atención al Cliente Seguros Presencial';
    public static final String PROFILE_JEFE_CAMPANA = 'Jefe de Campaña';
        
    public static final String CONSORCIO_SEGUROS = 'consorcio_seguros';
    public static final String OPENCONNECT = 'Open ID Connect';

    public static final String OK = 'OK';
    public static final String NOK = 'NOK';
    public static final String NOOK = 'NO OK';
    public static final String INVALID = 'INVALID';
    public static final String COMERCIALIZADOR = 'Comercializador';
    public static final String RV_CONTRATO = 'El campo Tipo de Contrato es obligatorio. Si no puede seguir con el flujo, refiera la oportunidad';

    /*
	* LISTA DE RECORDTYPES BANCA
	*/   
    public static final List<String> RECORDTYPES_BANCA = new List<String>{
        RECORDTYPE_BANCA_HIPOTECARIO,
        RECORDTYPE_BANCA_HIPOTECARIO_LECTURA,
        RECORDTYPE_BANCA_PLAN_PLUS,
        RECORDTYPE_BANCA_PLAN_PLUS_LECTURA,
        RECORDTYPE_BANCA_CREDITO_CONSUMO,
        RECORDTYPE_BANCA_CREDITO_CONSUMO_LECTURA
    };
    
    /*
	* MAPA DE DOCUMENTOS HIPOTECARIO
	*/
    public static final Map<Integer, String> DOC_TYPES = new Map<Integer, String> {
		0 => 'Cédula de Identidad',
        1 => 'Activos Circulantes',
        2 => 'Vehículos',
        3 => 'Propiedades',
        4 => 'Pasivos',
        5 => 'Pie',
        6 => 'Liquidaciones de Sueldo',
        7 => 'AFP',
        8 => 'Honorarios',
        9 => 'Impuestos',
        10 => 'Certificado de Matrimonio'
    };
        
	/*
	* MAPA DE DOCUMENTOS PLAN PLUS
	*/
    public static final Map<Integer, String> DOC_TYPES_PP = new Map<Integer, String>{
        0 => 'Ficha Cliente',
        1 => 'Liquidaciones de Sueldo',
        2 => 'Foto Selfie',
        3 => 'Cédula de Identidad'  
    };
    
    public static final String DOC_TYPE_DEC_ANUAL_IMPUESTOS = 'Declaración Anual de impuestos';
    
    /*
     * CONSTANTES FUNCTIONALITY
*/
    public static final String OPPORTUNITY_DOCS_EJECUTIVO_ESPECIALISTA = 'OPPORTUNITY_DOCS_EJECUTIVO_ESPECIALISTA';
    
    /*
     * CONSTANTES ESTADOS OPORTUNIDAD HIPOTECARIO 
	*/
    public static final String HIPOTECARIO_STATUS_CONTACTO = 'Contacto';    
    public static final String HIPOTECARIO_STATUS_VISADO = 'Revisión';
    public static final String HIPOTECARIO_STATUS_RECOPILACION = 'Recopilación';
    public static final String HIPOTECARIO_STATUS_EVALUACION = 'Evaluación';
    public static final String HIPOTECARIO_STATUS_SIMULACION = 'Simulación';
    public static final String HIPOTECARIO_STATUS_FORMALIZACION = 'Formalización';
    public static final String HIPOTECARIO_STATUS_CIERRE_PERDIDA = 'Cierre Perdida';
    
     /*
     * CONSTANTES API NAMES MOTIVO PÉRDIDA OPORTUNIDAD HIPOTECARIO 
	*/
    public static final String HIPOTECARIO_MOTIVO_PERDIDA_RECHAZADO_RIESGO = 'Rechazado por Riesgo';
    /*
     * CONSTANTES MOTIVO RECHAZO OPORTUNIDAD HIPOTECARIO 
	*/
    public static final String HIPOTECARIO_MOTIVO_RECHAZO_RIESGO_DEUDA_CAST = 'Deuda castigada';
    /*
     * CONSTANTES MOTIVO REINGRESO HIPOTECARIO 
	*/
    public static final String HIPOTECARIO_MOTIVO_REINGRESO_CAMBIO = 'Cambio de condiciones';
    public static final String HIPOTECARIO_MOTIVO_REINGRESO_INCLUSION = 'Inclusión de participantes';
    public static final String HIPOTECARIO_MOTIVO_REINGRESO_EXCLUSION = 'Exclusión de participantes';
    
    /*
     * CONSTANTES ESTADOS OPORTUNIDAD PLAN PLUS
     */ 	
   // public static final String PLAN_PLUS_STATUS_ASIGNACION = 'Asignación';
    public static final String PLAN_PLUS_STATUS_ENTREGA = 'Entrega';
    public static final String PLAN_PLUS_STATUS_ACTIVACION = 'Activación';
    public static final String PLAN_PLUS_STATUS_CIERRE_GANADA = 'Cierre Ganada';
    public static final String PLAN_PLUS_STATUS_CIERRE_PERDIDA = 'Cierre Perdida';
    public static final String PLAN_PLUS_STATUS_RECOPILACION = 'Recopilación';
    
    /*
     * CONSTANTES MOTIVOS DE RECHAZO RIESGO HIPOTECARIO
     */
    public static final String APROBADO_RIESGO_APROBADO = 'Aprobado';
    public static final String APROBADO_RIESGO_RECHAZADO = 'Rechazado';
    public static final String APROBADO_RIESGO_EN_PROCESO = 'En Proceso';
    
    /*
     *  CONSTANTES NOTIFICACIONES RIESGO HIPOTECARIO
     */
    public static final String NOTIFICACION_APROBADO_ESPECIALISTA = 'Aprobado Especialista';
    public static final String NOTIFICACION_RECHAZO_RIESGO = 'Rechazado Riesgo';
    public static final String NOTIFICACION_RECHAZO_ESPECIALISTA = 'Rechazado Especialista';
	
    /*
     *  CONSTANTES ACCESS LEVEL OBJECTO OPPORTUNITY TEAM 
     */
    public static final String OPPORTUNITY_TEAM_ACCESS_READ = 'Read';
    public static final String OPPORTUNITY_TEAM_ACCESS_EDIT = 'Edit';

    public static final String SELECT_ESTADO_SELECCIONAR = 'Seleccionar';
    public static final String SELECT_ESTADO_INGRESADO = 'Ingresado';
    public static final String SELECT_ESTADO_RECHAZADO = 'Rechazado';
    public static final String SELECT_ESTADO_APROBADO = 'Aprobado';
	public static final String SELECT_ESTADO_NO_APLICA = 'No aplica';
    /*
     *  OPPORTUNITY ROLES
     */
    public static final String OPPORTUNITY_MEMBER_JEFE = 'Jefe de Visado';
    public static final String OPPORTUNITY_MEMBER_REVISOR = 'Revisor';
    public static final String OPPORTUNITY_MEMBER_REVISOR_DOCUMENTO = 'Revisor de Documentos';
    public static final String OPPORTUNITY_MEMBER_RIESGO = 'Riesgo';
    public static final String OPPORTUNITY_MEMBER_REVISION = 'Revisión';
    public static final String OPPORTUNITY_MEMBER_APROBADOR = 'Aprobador de Pre-Visado';
    public static final String OPPORTUNITY_MEMBER_APROBADOR_ACTUAL = 'Aprobador de Pre-Visado Actual';

    /*
     *  ESTADOS DE PARTICIPANTES 
     */
    public static final String PARTICIPANT_ESTADO_VIGENTE = 'Vigente';
    public static final String PARTICIPANT_ESTADO_NO_VIGENTE = 'No Vigente';

    /*
     * ROL OPPORTUNITY TEAMS
     */
    public static final String TEAM_ROL_ASIGNADOR_VISADO = 'Asignador de Revisión';
    public static final String TEAM_ROL_ASIGNADOR_RIESGO = 'Asignador Riesgo';
    public static final String TEAM_ROL_JEVE_DE_VISADO = 'Jefe de Revisión';
    public static final String TEAM_ROL_TRASPASO = 'Traspaso';

    /*
    *  CONSTANTES ESTADOS FINALES CAMBIO DE ETAPA SERVICIO OPP BACKEND
    */
    public static final String OPP_PPLUS_GENERACION_ENTREGA = 'GENERACION_ENTREGA';
    public static final String OPP_PPLUS_ESTADO_ACTIVACION = 'ACTIVACION';
    public static final String OPP_PPLUS_ESTADO_CANCELACION = 'CANCELACION';
    
    
    /*
    *  TIPOS DE CONTRATO - OPORTUNIDAD PLAN PLUS
    */
    public static final String OPP_CONTRACT_TYPE_INDEPENDIENTE = 'Independiente';
    public static final String OPP_CONTRACT_TYPE_DEPENDIENTE = 'Dependiente';
    public static final String OPP_CONTRACT_TYPE_PENSIONADO = 'Pensionado';
    public static final String OPP_CONTRACT_TYPE_INDEPEN_BOLETA = 'Independiente Boletas';
    public static final String OPP_CONTRACT_TYPE_INDEPEN_SOCIOEMP = 'Independiente Socio Empresa';
    public static final String OPP_CONTRACT_TYPE_RENTISTA = 'Rentista';
	/*
	 TIPOS DE PICKLIST CDT TIPO CONTRATO
*/    
    public static final String OPP_MDT_PICK_PLAN_PLUS_IND = 'Plan Plus Independiente Boleta';
    public static final String OPP_MDT_PICK_PLAN_PLUS_INDEMP = 'Plan Plus Independiente Socio Empresa';
    public static final String OPP_MDT_PICK_PLAN_PLUS_DEP = 'Plan Plus Dependiente';
    public static final String OPP_MDT_PICK_PLAN_PLUS_PEN = 'Plan Plus Pensionado';
    public static final String OPP_MDT_PICK_PLAN_PLUS_REN = 'Plan Plus Rentista';
    
    /*
		CAMPOS OPORTUNIDAD Y DOCUMENTOS
	*/
    public static final String OPP_FIELDS_DOC_OP = 'documento_oportunidad_sales__c';
    public static final String OPP_FIELDS_DOC_ESTADO = 'estado_documento_sales__c';
    public static final String OPP_FIELDS_DOC_MOTIVO = 'motivo_rechazo_sales__c';
    public static final String OPP_FIELDS_DOC_ORDEN = 'orden_doc_sales__c';
    public static final String OPP_FIELDS_NUM_SOL = 'numero_solicitud_sales__c';
    public static final String OPP_FIELDS_NUM_OPP_PCH = 'numero_oportunidad_pch_sales__c';
    
    /*
    *  TIPOS DE CLIENTE - OPORTUNIDAD CONSUMO Y VALUE DE LABELS mdt
    */
   
    public static final String OPP_CLIENT_TYPE_INDEPENDIENTE = 'Trabajador Independiente';
    public static final String OPP_CLIENT_TYPE_DEPENDIENTE = 'Trabajador Dependiente';
    public static final String OPP_CLIENT_TYPE_SOCIOEMPRESA = 'Cliente Socio Empresa';
    public static final String OPP_CLIENT_TYPE_RENTISTA= 'Cliente Rentista';
    public static final String OPP_MDT_LABEL_CONSUMO = 'Consumo';
    public static final String OPP_MDT_LABEL_CONSUMO_DEPENDIENTE =  'Consumo Dependiente';
    public static final String OPP_MDT_LABEL_CONSUMO_INDEPENDIENTE = 'Consumo Independiente';
    public static final String OPP_MDT_LABEL_CONSUMO_SOCIOEMPRESA = 'Consumo Socio Empresa';
    public static final String OPP_MDT_LABEL_CONSUMO_RENTISTA = 'Consumo Rentista';
    public static final String OPP_MDT_LABEL_CONSUMO_FORMALIZACION = 'Consumo Form';
    
/*
    *  TIPOS DE CLIENTE - OPORTUNIDAD HIPOTECARIO Y VALUE DE LABELS mdt
    */
    public static final String OPP_MDT_LABEL_HIPOTECARIO_FORMALIZACION = 'Hipotecario Form';
    public static final String OPP_STRING_HIPOTECARIO = 'Hipotecario';

	/* TIPOS DE PRODUCTO COTIZADOR
	*/    
    public static final String PRODUCTO_COTIZADOR_APV_FONDO_EXPERTO = 'APV fondo experto';

    /*
    *   TIPOS DE PRODUCTO BANCA
    */
    public static final string PRODUCT_HIPOTECARIO = 'HIPOTECARIO';
    public static final string PRODUCT_PLAN_PLUS = 'PLANPLUS';
    public static final string PRODUCT_CONSUMO = 'CONSUMO';

    /*
    *   CONSTANTES COMPONENTE OFERTA
    */
    public static final String OFERTA_GESTIONADO = 'Gestionado';
    public static final String OFERTA_NOGESTIONADO = 'No Gestionado';
    public static final String OFERTA_INTERESADO = 'Interesado';
    public static final String OFERTA_NOINTERESADO = 'No Interesado';
    public static final String OFERTA_SALES_RECORDTYPE = 'sales_oferta';
    public static final String OFERTA_SALES_RECORDTYPE_LECTURA = 'sales_oferta_lectura';

    /*
    *   EXCEPCIONES TRIGGERS
    */
    public static final String OPPORTUNITYLINEITEM_ERROR01 = 'Debe ingresar un producto relacionado con la Familia de la Oportunidad';
    
    /*
	*	GRUPOS PUBLICOS PROYECTO SALES
	*/
    public static final String GRUPO_SEGUROS = 'Sales_Consorcio_Seguros';
    public static final String GRUPO_BANCO = 'Sales_Consorcio_Banco';
    public static final String GRUPO_CORREDORA = 'Sales_Consorcio_Corredora';
    public static final String GRUPO_SERVICIOS = 'Sales_Consorcio_Servicios';
    
    /*
	* VALORES CAMPO COMPANY EN USER
	*/
    
    public static final String COMPANY_SEGUROS = 'Consorcio Seguros';
    public static final String COMPANY_CORREDORA = 'Consorcio Corredora de Bolsa';
    public static final String COMPANY_BANCO = 'Consorcio Banco';
    public static final String COMPANY_SERVICIOS = 'Consorcio Servicios';
    
    /*
     * DOCUMENTOS CONSUMO - CLIENTE RENTISTA
	*/
    public static final String DOC_CON_RENTIS_CONTRATOARR = 'Contrato de arriendo legalizado';
    
    /*
     * DOCUMENTOS PLAN PLUS - CLIENTE RENTISTA
	*/
    public static final String DOC_PLAN_INDEPENDINTE_BOLETA = 'Boletas de los 6 últimos meses';
    public static final String DOC_PLAN_INDEPENDIENTE_EMPRESA = '3 Últimas liquidaciones de sueldo';
    
    public static final String DOC_PLAN_RENTISTA_ACRE_SIN_DEUDA = 'Acreditación de la propiedad sin deuda';
    public static final String DOC_PLAN_RENTISTA_ACRE_CON_DEUDA = 'Acreditación de propiedad con deuda';
    public static final String DOC_PLAN_RENTISTA_3MESES = '3 últimos meses de pago de arriendo';
    public static final String DOC_PLAN_RENTISTA_CONTRATO_ARR = 'Contrato de arriendo notariado';  
    /*
	 * TOOLTIPS SOLICITADOS
	 */
    public static final String DOC_CON_REN_TOOLTIP_CONTRATOARR = 'Ante Notario';
    public static final String DOC_PLAN_PLUS_TOOTIL_INDEPEN_BOL = 'O Resumen anual de Boletas de Honorarios desde SII';
    public static final String DOC_PLAN_PLUS_TOOLTI_EMPRESA = 'Si cliente además posee liquidaciones de la misma empresa';
    
    public static final String DOC_PLAN_PLUS_TOOLTIP_RENTIS_ACRESIN = 'Escritura o Dominio vigente';
    public static final String DOC_PLAN_PLUS_TOOLTIP_RENTIS_ACRECRON = 'Escritura o dominio vigente, o comprobante de dividendo, o certificado de avalúo fiscal o, pago de contribuciones al día';
    public static final String DOC_PLAN_PLUS_TOOLTIP_RENTIS_3MESES = 'Comprobante de los o Cartolas bancarias';
    public static final String DOC_PLAN_PLUS_TOOLTIP_RENTIS_CONTRA = 'Con vigencia de al menos 6 meses';
    /*
     *   TEMPLATE  PDF
     */
    public static final String TEMPLATE_PDF_LEGAL_AGREE = 'templateLegalAggree';
    public static final String TEMPLATE_PDF_LEGAL_NOTAGREE = 'templateLegalNotAggree';
    public static final String TEMPLATE_PDF_ERROR = 'Ha ocurrido un error, contacte con el administrador.';
    public static final String TEMPLATE_PDF_ERROR_TEMPLATE = 'Error, no se ha encontrado plantilla del documento.';
    public static final String TEMPLATE_PDF_SUCCESS = 'SUCCESS';
    
    /*
     * ERRORES
*/
    public static final String ERRA01 = 'ERRA01';
    public static final String ERRA02 = 'ERRA02';
    public static final String ERRA03 = 'ERRA03';
    public static final String ERRA04 = 'ERRA04';
    /*
     * CONSTANTS STATUS CASE
    */
    public static final String CASE_STATUS_NUEVO = 'Nuevo';
    public static final String CASE_STATUS_CERRADO = 'Cerrado';
    public static final String CASE_SUBESTADONECTIA_CERRADO = 'Cerrado';
    public static final String CASE_SUBESTADONECTIA_RECHAZADO = 'Rechazado';
    public static final String CASE_SUBESTADONECTIA_CANCELADO = 'Cancelado';
    public static final String CASE_SUBESTADONECTIA_SOLUCIONADO = 'Solucionado';
    public static final String CASE_TYPE_SOLICITUD = 'Solicitud';
    public static final String CASE_SUBTIPO_DESUSCRIPCION = 'Desuscripción';
    public static final String CASE_SUBTIPO_AUTORIZA = 'Autorización Compartir Datos';
    public static final String CASE_SUBJECT_DEFAULT = 'Gestión Autoriza Uso de Datos';
    public static final String CASE_SUBJECT_INCORPORACION = 'INCORPORACION';
    public static final String CASE_DESCRIPTION_AUTORIZA = 'Gestión Autoriza Uso de Datos';
    public static final String CASE_DESCRIPTION_TERMINAR_PROCESO = 'Terminar proceso';
    public static final String CASE_CASE_ORIGIN_PRESENCIAL = 'Presencial';
    public static final String CASE_CASE_ORIGIN_EMAIL = 'Email';
    public static final String CASE_COMPARTEDATOS_SI = 'Si';
    public static final String CASE_COMPARTEDATOS_NO = 'No'; 
    public static final String CASE_ERROR_ACNOTFOUND = 'No se ha encontrado la cuenta';
    public static final String CASE_FUNCTIONALITY_NAME = 'CASE_AUTHORIZE_EJECUTIVO_EJECUTIVOS';

    /*
     * CONSTANTS DOCUWARE
	 */
    public static final String CARPETA_DIGITAL_CLIENTE = 'Carpeta Digital Cliente';
    public static final String XML_INDICES = 'xmlIndices';
    public static final String XML_FILTROS = 'xmlFiltros';
    public static final String EXTENSION_PDF = 'pdf';
    public static final String INDICE_CLIENTE = 'CLIENTE';
    public static final String INDICE_DWDOCID = 'DWDOCID';
    public static final String INDICE_PROCESO = 'ID_PROCESO';
    
    /*
     * 	CONSTANTS CASE
     */
    public static final String CASE_STATUS_PROCESO = 'En proceso';
    public static final String CASE_SUBESTADONECTIA_VALIDACION = 'En Validación';
    public static final String CASE_CUSTOM_NOTIFY_ADVERTENCIA = 'ADVERTENCIA';
    public static final String CASE_CUSTOM_NOTIFY_VENCIMIENTO= 'VENCIMIENTO';
    public static final String CASE_ENVIO_NOTIFICACION_PROPIETARIO = 'PROPIETARIO';
    public static final String CASE_ENVIO_NOTIFICACION_GESTOR = 'GESTOR';
    public static final String CASE_ENVIO_NOTIFICACION_CERRADO = 'CERRADO';
    public static final String CASE_ENVIO_NOTIFICACION_PROPIETARIO_ADVERTENCIA = 'ADVERTENCIA PROPIETARIO';
    public static final String CASE_ENVIO_NOTIFICACION_PROPIETARIO_VENCIMIENTO = 'VENCIMIENTO PROPIETARIO';
    public static final String CASE_ENVIO_NOTIFICACION_GESTOR_ADVERTENCIA = 'ADVERTENCIA GESTOR';
    public static final String CASE_ENVIO_NOTIFICACION_GESTOR_VENCIMIENTO = 'VENCIMIENTO GESTOR';
    public static final String CASE_CUSTOM_NOTIFY_VENCIMIENTO_SLA = 'SLAVENCIDO';

    /*
     * 	CONSTANTS RECORDTYPE CASE
     */
    public static final String CASE_RECORDTYPE_CASOS_CORPORATIVOS = 'casos_corporativos';
  
	/*
     * 	CONSTANTS SLA PROCESS CASE CUSTOM SETTING
     */    
    public static final String CASE_SLA_PROCESS_AUTORIZA_USO_DATOS = 'SLAAUTORIZA';
    public static final String CASE_SLA_PROCESS_DESAUTORIZA_USO_DATOS = 'SLADESAUTORIZA';
	
    /*
     * 	CONSTANTS MULTICONSUTA / MULSTISERVICIO
     */  
    public static final String MULTICONSULTA = 'Multiconsulta';
    public static final String MULTISERVICIO = 'Multiservicio';
    //CONSTANTS VTIME
    public static final String TYPECALL_MANUAL = 'Manual';
    public static final String TYPECALL_AUTOMATICO = 'Automático';
    
    /*
	* CONSTANTS SERVICE RRHH
	*/
    public static final String RRHH = 'RRHH';

    public static final String ACTIVAR = 'Activar';
    public static final String DESACTIVAR = 'Desactivar';
    
    public static final String CNS_NOTIFICATION_HOME = 'cnf_sal_cn_alerta_desktop';

}