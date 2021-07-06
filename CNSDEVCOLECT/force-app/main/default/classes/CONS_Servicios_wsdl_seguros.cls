global class CONS_Servicios_wsdl_seguros {

	global class Validacliente{

		webservice String rut;
		webservice String idcrossnet;

	}
    
	global class Respuestaurl{
		webservice String url;
		webservice String mensaje;
		webservice String nombre;
		webservice String rut;
		webservice Integer codigo;
		webservice String idcrossnet;
	}


	webservice static Respuestaurl consultaclienteURL(Validacliente datos){
		Respuestaurl r=new  Respuestaurl();
		system.debug('datos rut->'+datos.rut);

		if (datos.rut != ''){
			list<Account>  existe =[SELECT Id , Name, RecordTypeId, Type, Phone, RUT__c, RUT_Nectia__pc FROM Account where RUT__c=:datos.rut limit 1 ];
			system.debug('cuentas->'+existe);
			
			if(existe.size()>0){
				r.url = Url.getOrgDomainUrl().toExternalForm() + '/' + existe[0].id;
				r.mensaje='cliente encontrado';
				r.nombre=existe[0].Name;
				r.rut=existe[0].RUT__c ;
				r.codigo=0; 
				r.idcrossnet=datos.idcrossnet;
				// r.uuid=datos.uuid;  
			}else{
				r.url= Url.getOrgDomainUrl().toExternalForm() + '/lightning/page/home';
				r.mensaje='cliente no existe en salesforce';
				r.codigo=1;
			}
		}else{
			r.url= Url.getOrgDomainUrl().toExternalForm() + '/lightning/page/home';
			r.mensaje='consulta con rut en blanco';
			r.codigo=1;
		}

		return r; 
	}
/*
     global class datocsliente{
   
        webservice String rut;
        webservice String numerocaso;
      
       
   }
    
     global class Respuestaobtenerinformacion{
       
        webservice String id;
        webservice String numero_de_caso;
		webservice String caso_principal;
		webservice String descripcion;
        webservice String origen_del_caso;
        webservice String propietario_del_caso;
        webservice String estado;
        webservice String sub_estado;
		webservice String nombre_asignacion;
        webservice String tipo;
		webservice String subtipo;
        webservice Datetime  asignacion_hora_inicio;
		webservice Datetime  asignacion_hora_finalizacion;
        webservice String url;
     
 }
      global class Respuestainformacion{
       
        webservice String error;
        webservice list<Respuestaobtenerinformacion> listado;
		
     
 }
    
         webservice static Respuestainformacion obtenerinformacion(datocsliente datos){
            Respuestainformacion  r=new Respuestainformacion(); 
          
               RestRequest req = RestContext.request;
        
        String rut = datos.rut;
        String numero = datos.numerocaso;
        string extencion='where' ;
        if(rut!='' && rut!=null){
            extencion+= ' Rut_del_Cliente__c=\''+rut+'\'';
        }
        if(numero!='' && numero!=null ){
            if(!extencion.equals('where')){
               extencion+=' and '; 
            }
            extencion+= ' CaseNumber=\''+numero+'\'';
        }
        
        system.debug('rut'+rut);
        system.debug('numero'+numero);
        system.debug('extencion'+extencion);
        
          string inst = [SELECT Id, InstanceName, IsSandbox FROM Organization limit 1].InstanceName;
              List <Respuestaobtenerinformacion> listacasos = new List <Respuestaobtenerinformacion>();
        try{
            string query='SELECT CaseNumber,Rut_del_Cliente__c, Semaforo__c, Valores_Nectia__c, Subtipo__c, Tipo_de_cierre_Nectia__c,'+
                'SLA_Nectia__c, Sub_estado_Nectia__c, Producto_del_Cliente_Nectia__c, Anio__c, Status, RecordTypeId, Id,'+
                'SlaStartDate,SlaExitDate,Entitlement.name,Owner.name,Origin,Parentid,parent.CaseNumber,Description,Type,Ownerid,Entitlementid '+
                ' FROM Case '+extencion;
            system.debug('query'+query);
            list<case> cas =Database.query(query);
            system.debug('cas'+cas);
            system.debug('cantidad'+cas.size());
            //estcas.cliente_rut=cas.get(0).Rut_del_Cliente__c;
            if(cas.size()==0){
                 r.error='cliente no tiene casos';
            }
            
            for(integer i=0;i < cas.size();i++){
                Respuestaobtenerinformacion  lcas=new Respuestaobtenerinformacion();
               
                lcas.id=cas.get(i).Id;
                lcas.numero_de_caso=cas.get(i).CaseNumber;
                lcas.caso_principal=cas.get(i).Parentid==null?null:cas.get(i).Parent.CaseNumber;
                lcas.descripcion=cas.get(i).Description;
                lcas.origen_del_caso=cas.get(i).Origin;
                lcas.propietario_del_caso=cas.get(i).Ownerid==null?null:cas.get(i).Owner.name;
                lcas.estado=cas.get(i).Status;
                lcas.sub_estado=cas.get(i).Sub_estado_Nectia__c==null?null:cas.get(i).Sub_estado_Nectia__c;
                lcas.nombre_asignacion=cas.get(i).Entitlementid==null?null:cas.get(i).Entitlement.name;
                lcas.tipo=cas.get(i).Type;
                lcas.subtipo=cas.get(i).Subtipo__c;
                lcas.asignacion_hora_inicio=cas.get(i).SlaStartDate;
                lcas.asignacion_hora_finalizacion=cas.get(i).SlaExitDate;  
                lcas.url= 'https://'+inst+'.lightning.force.com/lightning/r/Case/'+cas.get(i).id;
                system.debug('lcas='+lcas);
              //  system.debug('estcas.casos=='+estcas.casos);
                listacasos.add(lcas);
              //  system.debug('estcas.casos=='+estcas.casos);
            }
            
            r.listado=listacasos;
       //     estcas.casos=listacasos;
        }catch(Exception e){
            system.debug('e'+e);
        }
        return r;
        
       }
    */
}