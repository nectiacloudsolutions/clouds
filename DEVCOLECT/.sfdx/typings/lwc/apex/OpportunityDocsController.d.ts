declare module "@salesforce/apex/OpportunityDocsController.getValuesDocumentClient" {
  export default function getValuesDocumentClient(): Promise<any>;
}
declare module "@salesforce/apex/OpportunityDocsController.getData" {
  export default function getData(param: {oppId: any}): Promise<any>;
}
declare module "@salesforce/apex/OpportunityDocsController.saveDoc" {
  export default function saveDoc(param: {oppDocId: any, value: any}): Promise<any>;
}
declare module "@salesforce/apex/OpportunityDocsController.saveAllDocs" {
  export default function saveAllDocs(param: {docOppList: any}): Promise<any>;
}
declare module "@salesforce/apex/OpportunityDocsController.sendToValidate" {
  export default function sendToValidate(param: {oppId: any}): Promise<any>;
}
declare module "@salesforce/apex/OpportunityDocsController.visadoDecision" {
  export default function visadoDecision(param: {oppId: any, decision: any}): Promise<any>;
}
declare module "@salesforce/apex/OpportunityDocsController.addNewDocumentType" {
  export default function addNewDocumentType(param: {oppId: any, name: any, detail: any, idParticipant: any}): Promise<any>;
}
declare module "@salesforce/apex/OpportunityDocsController.sendToJefatura" {
  export default function sendToJefatura(param: {oppId: any}): Promise<any>;
}
declare module "@salesforce/apex/OpportunityDocsController.getAccessPerfilEspecialista" {
  export default function getAccessPerfilEspecialista(param: {perfil: any}): Promise<any>;
}
declare module "@salesforce/apex/OpportunityDocsController.stageRejectManager" {
  export default function stageRejectManager(param: {oppId: any, motivo: any}): Promise<any>;
}
declare module "@salesforce/apex/OpportunityDocsController.sendToApproveManager" {
  export default function sendToApproveManager(param: {oppId: any}): Promise<any>;
}
declare module "@salesforce/apex/OpportunityDocsController.rejectProposalConfirmBoss" {
  export default function rejectProposalConfirmBoss(param: {oppId: any}): Promise<any>;
}
declare module "@salesforce/apex/OpportunityDocsController.setAllDocsStateTo" {
  export default function setAllDocsStateTo(param: {id: any, estado: any}): Promise<any>;
}
