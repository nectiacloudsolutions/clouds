global class InfoUserBatch implements Database.Batchable<sObject>, Database.AllowsCallouts  {
    
    private static map <String, Id> MapPerfil = new map <String, Id>(); 
    private static map <String, Id> MapRol = new map <String, Id>(); 
    private static map <String, HomologacionPerfilesRoles__mdt> MapCustom = new map <String, HomologacionPerfilesRoles__mdt>(); 
    
    global Database.QueryLocator start(Database.BatchableContext BC){

        // collect the batches of records or objects to be passed to executString 
        String rut1 = '235364425';
        Date hoy = date.today();

        String query = Test.isRunningTest() ? ' Rut__c = \''+rut1+ '\' LIMIT 200' : ' Rut__c != null AND UserRoleId != null AND desvinculado_sales__c = false AND ProfileId IN (SELECT setupownerid FROM profileInfoUserBatch_org__c) ' ;
		
        return Database.getQueryLocator('SELECT Rut__c,Email,Title,Companyname,Department,ManagerId,Sucursal__c, IsActive,name,'+
                                        'ProfileId,UserRoleId,Phone,Extension,fecha_usuario_con_licencia_desde_sales__c, fecha_usuario_con_licencia_hasta_sales__c,' +
                                        'fecha_usuario_con_vacaciones_desde_sales__c, fecha_usuario_con_vacaciones_hasta_sales__c FROM User WHERE' + query);

    }

    
    global void execute(Database.BatchableContext BC, List<User> lstObj){
        
        Date currentTime = date.today();
        List<String> lstRut = new List<String>();
        Set<string> rutEjc = new Set<string>();
        Map<String, User> mapUser = new Map<String, User> ();
        List<User> lstUpdUsr = new List<User>();
        Map<String, String> mapCompany = utilitiesSales.getCompanyName();
        Map<String, String> mapSucursal = utilitiesSales.getSucursalName();      
        
        for(User usr : lstObj){
            mapUser.put(rutWithDash(usr.Rut__c), usr);
            lstRut.add(rutWithDash(usr.Rut__c));            
        }      
        
        getPerfilRol();
        getCustomMetaData();        
        
        SalesCallout sc = new SalesCallout(Constants.RRHH);
        RequestRRHH Request = new RequestRRHH ();
        Request.ruts = lstRut;
        ResponseRRHH obj = new ResponseRRHH();
        if(Test.isRunningTest()){
            String jsonMock = '{"registros":[{"rut":"23536442-5","email":"eduardo.ojeda@consorcio.cl","cargo":"JEFE DESARROLLO CRM","departamento":"GCIA INTELIGENCIA COM Y CRM","compania":"CGRAL","sucursal":"EDIFICIO EL BOSQUE PISO 1","telefono":"5622222222","anexo":"2242","rut_jefe_directo":"8327094-2","fecha_inicio_licencia":"2020-10-01","fecha_termino_licencia":"2020-10-01","fecha_inicio_vacaciones":"","fecha_termino_vacaciones":""},{"rut":"16104081-9","email":"dummy.ffvv@consorcio.cl","cargo":"EJECUTIVO DE VENTAS","departamento":"AGENCIA ANTOFAGASTA 199","compania":"CVIDA","sucursal":"EDIFICIO EL BOSQUE PISO 1","telefono":"222222221","anexo":"2249","rut_jefe_directo":"8327094-2","fecha_inicio_licencia":"","fecha_termino_licencia":"","fecha_inicio_vacaciones":"","fecha_termino_vacaciones":""}]}';
            obj = (ResponseRRHH)System.JSON.deserialize(jsonMock,ResponseRRHH.class);
        }else{
            obj = sc.getInfoUserRRHH (Request);    
        }        	
        
        for(Registros regUsr :  Obj.Registros){
            rutEjc.add(regusr.rut_jefe_directo.replace('-', ''));            
        }    

        Map<String,Id> mapsManager = new Map<String,Id>();
        mapsManager = getIdsExecutive(rutEjc);
        
        Boolean sandBoxProd = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;  
        
        for(Registros regUsr :  Obj.Registros){ 
        	
            if(mapUser.containskey(regUsr.rut) && regUsr.rut != regUsr.rut_jefe_directo){

                user user = mapUser.get(regUsr.rut);
				
                if(user.Email != null && !sandBoxProd && !regUsr.email.equalsIgnoreCase(user.Email)){
                	user.email = regUsr.email;  
                }
                
                user.Title = regUsr.cargo;
                user.CompanyName = mapCompany.containsKey(regUsr.compania) == false ? Constants.COMPANY_SEGUROS : mapCompany.get(regUsr.compania);
                user.Sucursal__c = mapSucursal.containsKey(regUsr.sucursal) == false ? user.Sucursal__c : mapSucursal.get(regUsr.sucursal);         
                user.Department = regusr.departamento;
	            user.Phone = regusr.telefono;
                user.Extension = regusr.anexo;
                user.fecha_usuario_con_licencia_desde_sales__c = String.isBlank(regusr.fecha_inicio_licencia) ? null :  date.valueOf(regusr.fecha_inicio_licencia);
                user.fecha_usuario_con_licencia_hasta_sales__c = String.isBlank(regusr.fecha_termino_licencia) ? null :  date.valueOf(regusr.fecha_termino_licencia);
                user.fecha_usuario_con_vacaciones_desde_sales__c = String.isBlank(regusr.fecha_inicio_vacaciones) ? null : date.valueOf(regusr.fecha_inicio_vacaciones);
                user.fecha_usuario_con_vacaciones_hasta_sales__c = String.isBlank(regusr.fecha_termino_vacaciones) ? null : date.valueOf(regusr.fecha_termino_vacaciones);
                user.profileid = MapCustom.containsKey(regusr.compania+'-'+regusr.cargo+'-'+regusr.departamento) == false ? user.profileid : MapPerfil.get(MapCustom.get(regusr.compania+'-'+regusr.cargo+'-'+regusr.departamento).PerfilNameSF__c);
                user.UserRoleId = MapCustom.containsKey(regusr.compania+'-'+regusr.cargo+'-'+regusr.departamento) == false ? user.UserRoleId : MapRol.get(MapCustom.get(regusr.compania+'-'+regusr.cargo+'-'+regusr.departamento).FuncionNameSF__c);
                user.FechaActualizacionRRHHSales__c = date.today();
                if(mapsManager.containsKey(regusr.rut_jefe_directo.replace('-', ''))){
                    user.ManagerId = mapsManager.get(regusr.rut_jefe_directo.replace('-', ''));
                }
                
                Boolean vacaciones = evaluaPeriodoFechas(user.fecha_usuario_con_vacaciones_desde_sales__c, user.fecha_usuario_con_vacaciones_hasta_sales__c);
                Boolean licencia = evaluaPeriodoFechas(user.fecha_usuario_con_licencia_desde_sales__c, user.fecha_usuario_con_licencia_hasta_sales__c);
                
                if((user.IsActive) && (vacaciones || licencia)){
                	user.IsActive = false;
                } 
                
                if((!user.IsActive) && (!vacaciones && !licencia)){
                	user.IsActive = true;
                }
                
                mapUser.remove(regUsr.rut);
                lstUpdUsr.add(user);
            } 
                
        }
        
        Database.update(lstUpdUsr, false);
    }   
     
    global void finish(Database.BatchableContext BC){
        
    }
    
    private static void getPerfilRol(){
       
        list<profile> listaPerfil = [SELECT Id,Name FROM Profile];  
        list<UserRole> listaRol = [SELECT Id, Name FROM UserRole];
        
        for(profile perfil: listaPerfil) {
            MapPerfil.put(perfil.Name, perfil.Id);
        }       
         
        for(UserRole rol: listaRol) {
            MapRol.put(rol.Name, rol.Id);
        }   
    }

	
    private static void getCustomMetaData(){
        
        list<HomologacionPerfilesRoles__mdt> listaPerfilRol = [SELECT CargoNameSF__c, CompanyNameSF__c, DepartamentoNameSF__c, FuncionNameSF__c,PerfilNameSF__c FROM HomologacionPerfilesRoles__mdt];
        
        for(HomologacionPerfilesRoles__mdt homolo : listaPerfilRol){
            MapCustom.put(homolo.CompanyNameSF__c+'-'+homolo.CargoNameSF__c+'-'+homolo.DepartamentoNameSF__c, homolo);
        }
    }

    
    private static Map<String,Id> getIdsExecutive(Set<String> rutExecutive){
        Map<String,Id> maps = new Map<String,Id>();

        for(User u : [SELECT Id,Rut__C FROM User WHERE Rut__C IN : rutExecutive AND desvinculado_sales__c = false]){
            maps.put(u.Rut__c, u.Id);
    	}
        
        return maps;
    }
    
    private static String rutWithDash(String rut){
        Integer largo = rut.length();
        String dv = rut.right(1); 
        rut = rut.left(largo - 1);
        
        String finalRut = rut + '-' + dv.toUpperCase(); 
        return finalRut;
    }

    
    //request
    public class RequestRRHH {
        public List<String> ruts;
    }
    //response
    public class ResponseRRHH {
        public Integer codigo;
        public String mensaje;
    	public List<Registros> registros;
    }

	public class Registros {
		public String rut;
		public String email;
		public String cargo;
		public String departamento;
		public String compania;
		public String sucursal;
		public String telefono;
		public String anexo;
		public String rut_jefe_directo;
		public String fecha_inicio_licencia;
		public String fecha_termino_licencia;
		public String fecha_inicio_vacaciones;
		public String fecha_termino_vacaciones;
	}
    
    private Boolean evaluaPeriodoFechas(Date fechaInicio, Date fechaFin) {
        
        Boolean periodo = false;
        
        if(Date.today() >= fechaInicio && Date.today() <= fechaFin){
       		periodo = true;    
        }        
        return periodo;        
    }
    
}