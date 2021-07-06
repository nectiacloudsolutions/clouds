public class CONS_EnvioViaPago_JSON {
    
    
    
    public Integer nBranch;
    public Integer nProduct;
    public Integer nPolicy;
    public String deffecDate;
    public Integer nWayPay;
    public Integer nBillDay;
    public String sBanKauth;
    public Integer nBank;
    public Integer nTypAccPac;
    public String sAccountPac;
    public Integer nCodAgree;
    public String nUserCode;
    public String sClient;
    public String sDigit;
    public String sFirstName;
    public String sLastName;
    public String sLastName2;
    public String dBirthDat;
    public Integer nSexo;
    public Integer sRecType;
    public Integer nProvince;
    public Integer nLocal;
    public Integer nMunicipality;
    public String sStreet;
    public Object sInfor;
    public String sBuild;
    public Integer nFloor;
    public Integer nDepartment;
    public Integer nPolpulation;
    public Integer nZipCode;
    public Integer nCountry;
    public String sEmail;
    public Integer nOrder;
    public Integer nPhoneType;
    public Integer nAreaCode;
    public String sPhone;
    public Integer nPersonTyp;
    public Integer nNationality;
    public String sCaseName;
    public String sClientName;
    public String sTemplate;
    public Integer nBusinessNumber;
    public Integer nCase;
    public Integer sClientCellphone;
    public String dRecceptionDate;
    public integer nTypCreCard;  
    public String sCrediCardVal;  
    public String dCardExpir; 
    public String sClientEmail; 
    public String lineadenegocio;  
    
    
    
    public static CONS_EnvioViaPago_JSON parse(String json) {
        return (CONS_EnvioViaPago_JSON) System.JSON.deserialize(json, CONS_EnvioViaPago_JSON.class);
    }
}