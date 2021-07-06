public class CONS_Opp_visualizarcumbre {
    
    public string url{get; set;}
    public string url2{get; set;}
    public boolean error{get; set;}
    public string id{get; set;}
    public final Opportunity opp;
    
    public Cons_Opp_visualizarcumbre(ApexPages.StandardController controller) {
        this.opp = (Opportunity)controller.getRecord(); 
        id = ApexPages.currentPage().getParameters().get('id');
        string userId = UserInfo.GetUserId();
        Opportunity opp1 = [SELECT id, PF_Rut__c FROM Opportunity WHERE id =: id];
        User us = [SELECT id, RUT__c FROM User WHERE id =: userId];

        if(us.RUT__c == null){
            error = true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No existe Rut en el usuario logueado');
            ApexPages.addMessage(myMsg); 
        }else{
            string rut_cliente = opp1.PF_Rut__c.replace('-','');
            rut_cliente = rut_cliente.length()==8?' '+rut_cliente:rut_cliente;
            string rut_usuario = us.RUT__c.replace('-','');
            rut_usuario = rut_usuario.length()==8?' '+rut_usuario:rut_usuario;
            string cod_sistema = '269';
            Blob cryptoKey = blob.valueOf('KaNdRgUkXp2s5v8y');
            Blob cryptovector = blob.valueOf('encryptionBcnsVe');
            String Key_encripted = EncodingUtil.base64Encode(cryptoKey);
            Blob data = Blob.valueOf('qwsedfrte'+rut_usuario+'asasae'+rut_cliente+'dsaff'+cod_sistema);
            Blob encryptedData = Crypto.encryptWithManagedIV('AES128', cryptoKey, data);
            Blob decryptedData = Crypto.decryptWithManagedIV('AES128', cryptoKey, encryptedData);
            Blob encryptedData2 = Crypto.encrypt('AES128', cryptoKey,  cryptovector, data);
            String key = EncodingUtil.base64Encode(encryptedData2);
            key = key.replace('+','%2b');
            string url3 = 'https://cumbres.bancoconsorcio.cl/CUMBRES/salesforce?key='+key; //url3 ='https://10.250.12.128/CUMBRES/salesforce?key='+key;
            system.debug('key  '+ url3);
            url2 = url3;
        }   
    }
}