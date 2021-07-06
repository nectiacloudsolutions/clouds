declare module "@salesforce/apex/OpportunityDocsFormController.saveDoc" {
  export default function saveDoc(param: {oppDocId: any, value: any}): Promise<any>;
}
declare module "@salesforce/apex/OpportunityDocsFormController.getData" {
  export default function getData(param: {oppId: any}): Promise<any>;
}
declare module "@salesforce/apex/OpportunityDocsFormController.saveApproval" {
  export default function saveApproval(param: {userId: any, recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/OpportunityDocsFormController.sendToApproveVisador" {
  export default function sendToApproveVisador(param: {oppId: any}): Promise<any>;
}
declare module "@salesforce/apex/OpportunityDocsFormController.stageRejectManager" {
  export default function stageRejectManager(param: {oppId: any, motivo: any}): Promise<any>;
}
declare module "@salesforce/apex/OpportunityDocsFormController.saveAllDocs" {
  export default function saveAllDocs(param: {docOppList: any}): Promise<any>;
}
declare module "@salesforce/apex/OpportunityDocsFormController.visadoDecision" {
  export default function visadoDecision(param: {oppId: any, decision: any}): Promise<any>;
}
