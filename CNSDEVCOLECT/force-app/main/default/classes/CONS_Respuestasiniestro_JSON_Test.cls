@isTest
public class CONS_Respuestasiniestro_JSON_Test {
	static testMethod void TesJson() {
		CONS_Respuestasiniestro_JSON estructuraJson = new CONS_Respuestasiniestro_JSON();
        string arregloJson = 
            '{"tipo_perdida": 1234567,"numero_siniestro": "4324","numero_denuncio": "43242","liquidador_asignado" : "22","fecha_ocurrenci_denuncio": "123","fecha_de_denuncio": "444","estado": "1","des_evento_siniestro": "1","declaracion_involucrados": "test","causal": "test"}';
        
        estructuraJson = CONS_Respuestasiniestro_JSON.parse(arregloJson);
        
    }
}