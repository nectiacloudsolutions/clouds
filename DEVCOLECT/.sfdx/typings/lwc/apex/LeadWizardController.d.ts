declare module "@salesforce/apex/LeadWizardController.validatedRUT" {
  export default function validatedRUT(param: {RUT: any}): Promise<any>;
}
declare module "@salesforce/apex/LeadWizardController.consultAnalyticsForLead" {
  export default function consultAnalyticsForLead(param: {RUT: any}): Promise<any>;
}
declare module "@salesforce/apex/LeadWizardController.changeLeadOwner" {
  export default function changeLeadOwner(param: {leadID: any, newOwnerId: any}): Promise<any>;
}
declare module "@salesforce/apex/LeadWizardController.createLead" {
  export default function createLead(param: {fName: any, lName: any, phone: any, email: any, RUT: any}): Promise<any>;
}
declare module "@salesforce/apex/LeadWizardController.notifyExecutive" {
  export default function notifyExecutive(param: {leadId: any}): Promise<any>;
}
