declare module "@salesforce/apex/addParticipantController.isAllowed" {
  export default function isAllowed(param: {oppId: any}): Promise<any>;
}
declare module "@salesforce/apex/addParticipantController.LeadAssign" {
  export default function LeadAssign(param: {rut: any, OpportunityId: any}): Promise<any>;
}
declare module "@salesforce/apex/addParticipantController.registerParticipant" {
  export default function registerParticipant(param: {id: any, isAccount: any, isLead: any, rut: any, tipoDocument: any, firstName: any, lastName: any, secondLastName: any, accountBirthDate: any, remunerationAccount: any, mobileAccount: any, OpportunityId: any}): Promise<any>;
}
