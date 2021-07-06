/**
 * @description       : 
 * @author            : mbeltran@everis.com
 * @group             : 
 * @last modified on  : 01-19-2021
 * @last modified by  : mbeltran@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   01-04-2021   mbeltran@everis.com   Initial Version
**/
public class  MB_EmailsSummary_JSON {
    public Data Data {get;set;}
    public String Service {get;set;}
    public Status Status {get;set;} 
    public String TransactionId {get;set;} 
    public String Version {get;set;} 

    public class Data {
        public List<Mails> Mails {get;set;} 
        public PageDetail PageDetail {get;set;}
    }

    public class Mails {
        public String FromMail {get;set;}
        public String Id {get;set;}
        public Datetime ReceptionDate {get;set;}
        public Integer RuleId {get;set;}
        public Datetime SendDate {get;set;}
        public String Status {get;set;}
        public String To {get;set;}
        public String Subject {get;set;}
        public String UrlEmlProced {get;set;}
    }

    public class PageDetail {
        public Integer CurrentPage {get;set;}
        public Integer TotalPages {get;set;}
        public Integer TotalRecords {get;set;}
    }

    public class Status {
        public String Code {get;set;}
        public String Value {get;set;}
    }
}