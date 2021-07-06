/**
 * @description       : 
 * @author            : mbeltran@everis.com
 * @group             : 
 * @last modified on  : 01-05-2021
 * @last modified by  : mbeltran@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   01-05-2021   mbeltran@everis.com   Initial Version
**/
public with sharing class MB_EmailsStatistics_JSON {
    public Data Data {get;set;}
    public String Service {get;set;}
    public String Version {get;set;} 
    public String TransactionId {get;set;} 
    public Status Status {get;set;} 

    public class Data {
        public List<Mails> Mails {get;set;} 
        public PageDetail PageDetail {get;set;}
    }
    public class Mails {
        public String MailId {get;set;}
        public Integer Retry {get;set;}
        public Integer Sents {get;set;}
        public Integer Opens {get;set;}
        public Integer Clicks {get;set;}
        public Integer Accepteds {get;set;}
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