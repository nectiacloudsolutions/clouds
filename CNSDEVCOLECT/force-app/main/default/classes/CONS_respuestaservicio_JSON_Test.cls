@isTest
public class CONS_respuestaservicio_JSON_Test {
	static testMethod void TestRJson() {
		CONS_respuestaservicio_JSON estructuraJson = new CONS_respuestaservicio_JSON();
        string arregloJson = 
            '{"codigo": "1234567","mensaje": "abc123", "RespuestaBase":{"codigo": "1234567","mensaje": "abc123","nPropuesta": "abc123"}}';       
        estructuraJson = CONS_respuestaservicio_JSON.parse(arregloJson);
        
    }
}