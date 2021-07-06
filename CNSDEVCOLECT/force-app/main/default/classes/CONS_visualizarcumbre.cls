public class CONS_visualizarcumbre {
    
    public string url{get; set;}
    public string url2{get; set;}
    public boolean error{get; set;}
    public string id{get; set;}
    public final case cc;
    
    public  Cons_visualizarcumbre(ApexPages.StandardController  controller) {
        this.cc = (case) controller.getRecord(); 
        id = ApexPages.currentPage().getParameters().get('id');
        
        system.debug('cc'+cc);
        system.debug('id'+id);
        string userId = UserInfo.GetUserId();
        system.debug('userId'+userId);
        
        system.debug('===cas.id==='+id+'==userId==='+userId);
         
        
        case cas1=[select id, Rut_del_Cliente__c  from case where id=:id];
        user us=[select id, RUT__c   from user where id=:userId];
        if(us.RUT__c==null){
            error=true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No existe Rut  en  el usuario logueado');
            ApexPages.addMessage(myMsg); 
        }else{
            
            string rut_cliente=cas1.Rut_del_Cliente__c.replace('-','');
            rut_cliente=rut_cliente.length()==8?' '+rut_cliente:rut_cliente;
            string rut_usuario=us.RUT__c.replace('-','');
            rut_usuario=rut_usuario.length()==8?' '+rut_usuario:rut_usuario;
            system.debug('===rut_cliente==='+rut_cliente+'==rut_usuario==='+rut_usuario);
            string cod_sistema='269';
         //   string rut_cliente='133150412';
        //    string rut_usuario='160760532';
            system.debug('rut_cliente'+rut_cliente);
            system.debug('rut_usuario'+rut_usuario);
            system.debug('cod_sistema'+cod_sistema);
            //Blob cryptoKey = Crypto.generateAesKey('');
            Blob cryptoKey=blob.valueOf('KaNdRgUkXp2s5v8y');
            Blob cryptovector=blob.valueOf('encryptionBcnsVe');
            String Key_encripted = EncodingUtil.base64Encode(cryptoKey);
            system.debug('Key_encripted'+Key_encripted);
            Blob data = Blob.valueOf('qwsedfrte'+rut_usuario+'asasae'+rut_cliente+'dsaff'+cod_sistema);
            
            //Blob data = Blob.valueOf(rut_usuario+rut_cliente+cod_sistema);
        
            Blob encryptedData = Crypto.encryptWithManagedIV('AES128', cryptoKey, data);
            Blob decryptedData = Crypto.decryptWithManagedIV('AES128', cryptoKey, encryptedData);
           Blob encryptedData2 = Crypto.encrypt('AES128', cryptoKey,  cryptovector, data);
            
             system.debug('decryptedData='+decryptedData);
            String key = EncodingUtil.base64Encode(encryptedData2);
            key =key.replace('+','%2b');
            string url3 ='https://cumbres.bancoconsorcio.cl/CUMBRES/salesforce?key='+key; //url3 ='https://10.250.12.128/CUMBRES/salesforce?key='+key;
            system.debug('key  '+ url3);
          
          url2=url3;
     
        }
        
        
    }
}