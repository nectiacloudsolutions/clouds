public class CONS_Via_Pago {
    public String idcas{get;set;}
    public String urlSF{get;set;}
    public String Naut{get;set;}
    public User tmpUser{get;set;}
    public CONS_Via_Pago() {
         urlSF = URL.getSalesforceBaseUrl().toExternalForm()+'/';
        idcas = ApexPages.currentPage().getParameters().get('id');
        Naut = ApexPages.currentPage().getParameters().get('Naut');
        
        // cambioviapago();
    }
    public PageReference cambioviapago(){
        
        case cas=[select id,Rut__c,Accountid,Account.Name,Account.FirstName,Account.lastName,Producto_del_Cliente_Nectia__c,Rut_del_Cliente__c,Seguros_producto__c,Linea_Producto_Seguros__c,
                  V_a_de_Pago__c,D_a_de_Pago__c,Account.PersonBirthdate,Account.Genero_Nectia__pc,Account.PersonEmail,Tipo_de_cuenta__c,CaseNumber,Banco__c,Mensaje_Transaci_n__c,
                  N_Cta_o_Tarjeta__c,CreatedDate,N_mandato__c,CreatedByid,Fecha_de_Vigencia_de_Tarjeta_Nectia__c,Fecha_Vencimiento_Tarjeta__c,Type,Subtipo__c,Genero_Nectia__c,Nombres__c,
                  Apellido_Paterno__c,Apellido_Materno__c,Fecha_de_nacimiento__c,transacion_ejecutada__c,N_de_Endoso__c,
                  Account.PersonMobilePhone,Telefono_movil__c,Status,Codigo_Empleador__c,Codigo_de_Validacion_Autentia_Nectia__c,Tipo_de_Modificaci_n__c from case where id=:idcas];
        
        system.debug('cas='+cas);
        string userid=UserInfo.getUserId();
        system.debug('userid'+userid);
        user  us=[select id,Codigo_Usuario_Nectia__c,FederationIdentifier   from user where id=:userid];
        system.debug('us='+us);

        tmpUser = [select id,AccessToken_Nectia__c from user where  id=: userinfo.getUserId()];
        
        Producto_del_Cliente__c pro=	[select id,Codigo_Plan_Nectia__c,Poliza_Nectia__c,Numero_Certificado_Nectia__c,Esquema_Nectia__c,Ramo_Nectia__c,L_nea__c 
        											from Producto_del_Cliente__c 
        											where id=:cas.Producto_del_Cliente_Nectia__c];

        Arbol_Comunicaciones__mdt  arcom;
            try{

				arcom=	[SELECT Numero_Linea__c, Id, Tipo__c, Subtipo__c, Plantilla__c, Estado_del_caso__c, Subestado_del_caso__c,Linea_de_negocio__c 
							FROM Arbol_Comunicaciones__mdt 
							WHERE Tipo__c=:cas.Type  AND Subtipo__c=:cas.Subtipo__c  AND Estado_del_caso__c=:cas.Status  AND Clasificacion__c=:cas.Tipo_de_Modificaci_n__c AND Linea_de_negocio__c=:pro.L_nea__c];

            system.debug('arcom2'+arcom);
            }catch(Exception e){
                system.debug('entro a la  estructura catch');
               arcom=null;     
            }

        system.debug('pro='+pro);
        CONS_EnvioViaPago_JSON  j=new CONS_EnvioViaPago_JSON();

        if (pro.Ramo_Nectia__c != '' || pro.Ramo_Nectia__c != null){
        	system.debug('pro.Ramo_Nectia__c='+pro.Ramo_Nectia__c);
        	j.nBranch=integer.valueOf(pro.Ramo_Nectia__c);    //  "integer",   "Código del ramo, Cuando tiene los valores 1 o 6 para Vida, Otros valores para Generales"  EntradaViaPagoDescPlanilla.
        }
        
        system.debug('pro.Codigo_Plan_Nectia__c='+pro.Codigo_Plan_Nectia__c);
        j.nProduct=integer.valueOf(pro.Codigo_Plan_Nectia__c); //  "integer",   "Código del producto"                       EntradaViaPagoDescPlanilla.
        system.debug('pro.Poliza_Nectia__c='+pro.Poliza_Nectia__c);
        j.nPolicy=integer.valueOf(pro.Poliza_Nectia__c);    //  "integer",   "Número de la póliza"                                             
        system.debug('cas.CreatedDate='+cas.CreatedDate);
        if(cas.Fecha_de_Vigencia_de_Tarjeta_Nectia__c!=null){
            DateTime d1 = cas.Fecha_de_Vigencia_de_Tarjeta_Nectia__c+1 ;
            String defdate = d1.format('dd-MM-yyyy') ;
            j.deffecDate=defdate;   //  "string",   "Fecha endoso"
        }else{
            DateTime defec = system.now();
            String diaingreso = defec.format('dd-MM-yyyy') ;
            j.deffecDate=diaingreso;
        }
       /* integer numvia=0;
        if(cas.V_a_de_Pago__c=='PAT'){
            numvia=2;
        }else if(cas.V_a_de_Pago__c=='PAC'){
            numvia=1;
        }else if(cas.V_a_de_Pago__c=='Aviso Cobranza'){
            numvia=4;
        }else if(cas.V_a_de_Pago__c=='Descuento por Planilla'){
            numvia=3;
        }
        system.debug('numvia='+numvia);*/
        j.nWayPay=integer.valueOf(cas.V_a_de_Pago__c);    //  "integer",   "Vía de pago"

        system.debug('cas.D_a_de_Pago__c='+cas.D_a_de_Pago__c);
        j.nBillDay=integer.valueOf(cas.D_a_de_Pago__c==null?'0':cas.D_a_de_Pago__c);   //  "integer",   "Día de cobro"

        system.debug('0='+0);
        if(j.nWayPay==1 || j.nWayPay==2){
            j.nCodAgree=0;
        }else{
            j.nCodAgree=integer.valueOf(cas.Codigo_Empleador__c==null?'0':cas.Codigo_Empleador__c==''?'0':cas.Codigo_Empleador__c);
        }
         //  "integer",   "Numero de convenio"
        // system.debug('cas.CaseNumber'+cas.CaseNumber);

        system.debug('cas.CaseNumber='+cas.CaseNumber);
        j.nCase=integer.valueOf(cas.CaseNumber==null?'0':cas.CaseNumber);   //  "integer",   "Numero de caso SF"

        system.debug('us.Codigo_Usuario_Nectia__c='+us.Codigo_Usuario_Nectia__c);
       // j.nUserCode= 60000; //integer.valueOf(us.Codigo_Usuario_Nectia__c==null?'0':us.Codigo_Usuario_Nectia__c);   //  "integer",   "Código de usuario SF"
        j.nUserCode= (us.FederationIdentifier ==null?'0':us.FederationIdentifier ); 
        if(j.nWayPay==1  || j.nWayPay==2){
            
            system.debug('cas.N_mandato__c='+cas.N_mandato__c);
            j.sBanKauth=string.valueOf(cas.N_mandato__c);  //  "string",   "Mandato banco"
            system.debug('cas.Banco__c='+cas.Banco__c);
            j.nBank=  integer.valueOf(cas.Banco__c==null?'0':cas.Banco__c==''?'0':cas.Banco__c);   //  "integer",   "Código Banco"
            
            if (cas.Rut__c != '' && cas.Rut__c !=null){
            	String []rutPagador = cas.Rut__c.split('-');
            	system.debug('rut pagador->'+rutPagador);
            	j.sClient = rutPagador[0];
            	j.sDigit = rutPagador[1];
            }/*else{
            	string []rut= cas.Rut_del_Cliente__c.split('-');
            	system.debug('rut[0]='+rut[0]);
            	j.sClient=rut[0];   //  "string",   "Rut de cliente"
            	system.debug('rut[1]='+rut[1]);
            	j.sDigit=rut[1];   //  "string",   "Código verificador del rut cliente"
            }*/

            if (cas.Nombres__c !=''){
            	j.sFirstName=cas.Nombres__c;
            }else{
            	system.debug('cas.Account.FirstName='+cas.Account.FirstName);
            	j.sFirstName=null;   //  "string",   "Nombre pagador"            	
            }

            if (cas.Apellido_Paterno__c !='' || cas.Apellido_Materno__c != ''){
            	j.sLastName = cas.Apellido_Paterno__c;
            	j.sLastName2 = cas.Apellido_Materno__c;
            }else{
	            system.debug('cas.Account.lastName='+cas.Account.lastName);
    	        j.sLastName=null;   //  "string",   "Primer apellido pagador"
            
        	    j.sLastName2=null;   //  "string",   "Segundo apellido pagador"
        	}

        	if (cas.Fecha_de_nacimiento__c != null){
				DateTime d2 = cas.Fecha_de_nacimiento__c+1;
				String dbd =  d2.format('dd-MM-yyyy') ;
				j.dBirthDat=dbd;
        	}else{
				if(cas.Account.PersonBirthdate!=null){
					DateTime d2 = cas.Account.PersonBirthdate+1;
					String dbd =  d2.format('dd-MM-yyyy') ;
					j.dBirthDat=dbd;  //  "string",   "Fecha nacimiento Pagador"        		
				}else{
					j.dBirthDat='';
				}
        	}
            system.debug('cas.Account.PersonBirthdate='+cas.Account.PersonBirthdate);

            if (cas.Genero_Nectia__c != ''){
            	if(cas.Genero_Nectia__c == 'Masculino'){
            		j.nSexo = 2;
            	}else{
            		j.nSexo = 1;
            	}
            }else{
            	if (cas.Account.Genero_Nectia__pc == 'Masculino'){
            		j.nSexo = 2;
            	}else{
            		j.nSexo = 1;
            	}
            }

            if (cas.Telefono_movil__c != ''){
				j.sClientCellphone=Integer.valueOf(cas.Telefono_movil__c==null?'0':cas.Telefono_movil__c);   //  "integer",   "Número celular Cliente"
			}else{
				j.sClientCellphone = Integer.valueOf(cas.Account.PersonMobilePhone==null?'0':cas.Account.PersonMobilePhone);
			}

            //j.nSexo = null   //  "integer",   "Código sexo pagador"     'femenino'?'1':'Masculino'?´2':'No Informado'?:'3'
            j.sRecType=null;   //  "integer",   "Código tipo dirección pagador"      'Comewrcial'?'1': 'Particular'?'2':'Casilla de Correo'?'3'
            j.nProvince=null;   //  "integer",   "Código región pagador"
           j.nLocal=null;   //  "integer",   "Código ciudad pagador"
            j.nMunicipality=null;   //  "integer",   "Código comuna pagador"
            j.sStreet=null;   //  "string",   "Calle pagador"
            j.sInfor=null;   //  "string",   "Dirección envio pagador"
            j.sBuild=null;   //  "string",   "Número de la calle pagador"
            j.nFloor=null;   //  "integer",   "Numero de piso pagador"
            j.nDepartment=null;   //  "integer",   "código tipo condominio pagador"
            j.nPolpulation=null;   //  "integer",   "Complemento pagador"      'Villa'?'1':'Poblacion'?'2':'Paradero'?'3':'Condominio'?'4':
            j.nZipCode=null;   //  "integer",   "Numero código postal pagador"
            j.nCountry=null;   //  "integer",   "código de Pais pagador"
            system.debug('cas.Account.PersonEmai='+cas.Account.PersonEmail);
            j.sEmail=cas.Account.PersonEmail;   //  "string",   "Correo electrónico pagador"
            j.nOrder=null;   //  "integer",   "Orden TLF pagador"
            j.nPhoneType=null;   //  "integer",   "código tipo TLF pagador"      'Oficina'?'1':'Celular'?'2':'Fax'?'3':'Particular'?'4':'Otros'?'5'
            j.nAreaCode=null;   //  "integer",   "código de área pagador"
            j.sPhone=null;   //  "string",   "Numero TLF pagador"
            j.nPersonTyp=null;   //  "integer",   "código tipo persona pagador"    'Persona Natural'?'1':'Empresa'?'2':'Provisional Persona Natural'?'3':'Provisional para empresas'?'4'
            j.nNationality=null;   //  "integer",   "Código nacionalidad pagador" 
            
            if(j.nWayPay==1  ){
                j.sAccountPac=string.valueOf(cas.N_Cta_o_Tarjeta__c);   //  "string",   "cuenta PAC"
                system.debug('cas.Tipo_de_cuenta__c='+cas.Tipo_de_cuenta__c);
                j.nTypAccPac=integer.valueOf(cas.Tipo_de_cuenta__c=='Cuenta de ahorro'?'1':cas.Tipo_de_cuenta__c=='Cuenta Corriente'?'2':cas.Tipo_de_cuenta__c=='Caja tarjetas de crédito'?'6':
                                             cas.Tipo_de_cuenta__c=='Caja cheques a fecha'?'7': cas.Tipo_de_cuenta__c=='Caja efectivo'?'8': cas.Tipo_de_cuenta__c=='Caja cheques'?'9': 
                                             cas.Tipo_de_cuenta__c=='Cuenta Vista'?'10':  cas.Tipo_de_cuenta__c=='Cuenta Prima'?'11':  cas.Tipo_de_cuenta__c=='Cuenta Mática'?'12':  
                                             cas.Tipo_de_cuenta__c=='Cuenta Fácil'?'13':   cas.Tipo_de_cuenta__c=='Cheque Electrónico'?'14':   cas.Tipo_de_cuenta__c=='Cuenta RUT'?'15':cas.Tipo_de_cuenta__c); 
              }else{
                j.nTypCreCard=integer.valueOf(cas.Tipo_de_cuenta__c=='Visa'?'1':cas.Tipo_de_cuenta__c=='Mastercard'?'2':cas.Tipo_de_cuenta__c=='Magna'?'3':cas.Tipo_de_cuenta__c=='Diners'?'4':
                                              cas.Tipo_de_cuenta__c=='American Express'?'5':cas.Tipo_de_cuenta__c); 
                j.sCrediCardVal=string.valueOf(cas.N_Cta_o_Tarjeta__c);   //  "string",   "Numero de tarjeta de crédito"
                
                if(cas.Fecha_Vencimiento_Tarjeta__c!=null){
                    DateTime d = cas.Fecha_Vencimiento_Tarjeta__c+1 ;
                    String dateStr =  d.format('dd-MM-yyyy') ;
                    j.dCardExpir=dateStr;   //  "string",   "Fecha de expiración de tarjeta de credito " 
                }else{
                    j.dCardExpir=''; 
                }
            }
            
            
        }
        
        system.debug('cas.Account.name='+cas.Account.name);
        j.sClientName=cas.Account.name;   //  "string",   "Nombre Cliente"
        j.sClientEmail=cas.Account.PersonEmail;  //  "string",   "Email cliente"
        DateTime fd = system.now();
        String fdia =  fd.format('dd-MM-yyyy') ;
        j.dRecceptionDate=fdia;   //  "string",   "Fecha de recepcion"
        j.sCaseName=cas.Type +'-'+cas.Subtipo__c;   //  "string",   "nombre caso"
        if(arcom!=null){
        j.sTemplate=arcom.Plantilla__c;   //  "string",   "Plantilla"
        j.nBusinessNumber=integer.valueOf(arcom.Numero_Linea__c ); //  "integer",   "Numero Negocio"
        }else{
        j.sTemplate=''; 
        j.nBusinessNumber=0;
        }
          
        j.lineadenegocio=null;   //  "string"
        
        
        
        tmpUser = [select id,AccessToken_Nectia__c from user where  id=: userinfo.getUserId()];
        
        string envio =JSON.serialize(j);
        system.debug('envio estructura salesforce= '+envio);
               
        Cons_callOutService  call= new Cons_callOutService();
      /*string token=call.callOuttoken();
        system.debug('token'+token);
        CONS_token_JSON tok = (CONS_token_JSON)JSON.deserialize(token,CONS_token_JSON.class);  
        system.debug('token=='+tok.access_token);*/
        CONS_estructuratoken est=new  CONS_estructuratoken();
        string access_token=est.token();
       system.debug('token=='+access_token);
        string str='';
        
        if(pro.Esquema_Nectia__c=='INSUDB'){

            str=call.callOutCambio_via_pago_vida(access_token,envio, tmpUser);
			System.debug('token->'+tmpUser.AccessToken_Nectia__c);
            updateUser(tmpUser.AccessToken_Nectia__c);

        }else if(pro.Esquema_Nectia__c=='CLONINSUDB'){

            str=call.callOutCambio_via_pago_Generales(access_token,envio, tmpUser);
			System.debug('token->'+tmpUser.AccessToken_Nectia__c);
            updateUser(tmpUser.AccessToken_Nectia__c);
            
        }else{
            system.debug('el producto ingresado no corresponde a ninguno de los esquemas  de vida o generales no se puede llamar al servicio ');  
        }

		System.debug('token->'+tmpUser.AccessToken_Nectia__c);
		updateUser(tmpUser.AccessToken_Nectia__c);        

        if(test.isRunningTest()){
            str='{ "codigo": "99", "mensaje": "Ocurrió un error al ejecutar el servicio", "respuestaBase": { "codigo": "1", "mensaje": "Ingrese codigo de usuario valido", "nPropuesta": "0" }}';
        }
        system.debug('respuesta del servicio '+str);
        if(!str.contains('ERROR -')){
            CONS_respuestaservicio_JSON res = (CONS_respuestaservicio_JSON)JSON.deserialize(str,CONS_respuestaservicio_JSON.class);  
            system.debug('mensage del servicio == '+res.mensaje); 
            if(res.codigo=='0'){
                cas.Mensaje_Transaci_n__c=res.mensaje.left(255); 
                if(res.RespuestaBase.nPropuesta!=null &&  res.RespuestaBase.nPropuesta!=''){
                   cas.N_de_Endoso__c=decimal.valueOf(res.RespuestaBase.nPropuesta); 
                    cas.transacion_ejecutada__c=true;
                }
                
                cas.Codigo_de_Validacion_Autentia_Nectia__c=Naut;
            }else{
                if(res.RespuestaBase!=null){
                     cas.Mensaje_Transaci_n__c=res.RespuestaBase.mensaje.left(255); 
                    if(res.RespuestaBase.nPropuesta!=null &&  res.RespuestaBase.nPropuesta!=''){
                   cas.N_de_Endoso__c=decimal.valueOf(res.RespuestaBase.nPropuesta);  
                }
                     if(res.RespuestaBase.codigo=='0'){
                    cas.transacion_ejecutada__c=true;
                     }
                    cas.Codigo_de_Validacion_Autentia_Nectia__c=Naut;
                }else{
                    cas.Mensaje_Transaci_n__c=res.mensaje.left(255); 
                    cas.transacion_ejecutada__c=false;
                    cas.Codigo_de_Validacion_Autentia_Nectia__c=Naut;
                }
                 if(res.respuestaEmailmatico!=null){
                     cas.Mensaje_Transaci_n__c=cas.Mensaje_Transaci_n__c+ '/n '+res.respuestaEmailmatico.mensaje; 
                     cas.Codigo_de_Validacion_Autentia_Nectia__c=Naut;
                }
            }
        }else{
             cas.Mensaje_Transaci_n__c=str;
             cas.transacion_ejecutada__c=false;
            cas.Codigo_de_Validacion_Autentia_Nectia__c=Naut;
        }
          update cas;
        
         PageReference p = new PageReference('/'+idcas);
          p.setRedirect(true);
        return null;
    }
   
     public  PageReference continuar(){
       system.debug('entro a continuar'); 
     PageReference p = new PageReference('/'+idcas);
          p.setRedirect(true);
     return p;
     }

	public void updateUser(String tokenActualizado){
		system.debug('token actualizado->'+tokenActualizado);
		User usuarioParaActualizar = [SELECT Id,AccessToken_Nectia__c FROM User WHERE Id =: UserInfo.getUserId()];

		usuarioParaActualizar.AccessToken_Nectia__c = tokenActualizado;
		update usuarioParaActualizar;
	}

	public PageReference orquestaMetodos(){
		cambioviapago();
		//updateUser();
		return null;
	}
}