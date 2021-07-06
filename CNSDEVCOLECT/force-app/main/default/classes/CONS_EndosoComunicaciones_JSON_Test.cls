@isTest
public class CONS_EndosoComunicaciones_JSON_Test {
	static testMethod void TesJson() {
		CONS_EndosoComunicaciones_JSON estructuraJson = new CONS_EndosoComunicaciones_JSON();
        string arregloJson = 
            '{"nCelular": 1234567,"nNumMandato": "4324","nNumpoliza": "43242","nResolucionCaso": "123","nTelefonoEjec": "444","sBanco": "1","sDoc_Adjunto": "test","sEmail": "test","sFechaCierre": "test","sFechaEfectivaEndoso": "test","sFechaRecepcion": "test","sLinNegocio": "test","nNegocio": "test","sMailEjecutivo" : "test","sMotivoRechazo":"test","sNomEjecutivo":"test","sNombcaso":"test","sNombreCliente":"test","sPlantilla":"test"}';
        
        estructuraJson = CONS_EndosoComunicaciones_JSON.parse(arregloJson);
        
    }
}