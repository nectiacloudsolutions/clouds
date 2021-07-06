@isTest
public class CONS_EnvioReclamos_JSON_Test {
	static testMethod void TesJson() {
		CONS_EnvioReclamos_JSON estructuraJson = new CONS_EnvioReclamos_JSON();
        string arregloJson = 
            '{"nCelular": 1234567,"nNumMandato": "4324","nNumpoliza": "43242","nNumsolicitud" : "22","nResolucionCaso": "123","nTelefonoEjec": "444","nNegocio": "1","sBanco": "1","sDoc_Adjunto": "test","sEmail": "test","sFechaCierre": "test","sFechaEfectivaEndoso": "test","sFechaRecepcion": "test","sLinNegocio": "test","sMailEjecutivo" : "test","sMotivoRechazo":"test","sNombcaso":"test","sNombreCliente":"test","sNomEjecutivo":"test","sPlantilla":"test","sRutCliente":"test","sNombreLiquidador":"test","sNombreTaller":"test","sNominstitucion":"test"}';
        
        estructuraJson = CONS_EnvioReclamos_JSON.parse(arregloJson);
        
    }
}