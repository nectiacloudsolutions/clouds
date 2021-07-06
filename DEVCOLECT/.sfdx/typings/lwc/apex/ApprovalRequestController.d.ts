declare module "@salesforce/apex/ApprovalRequestController.getInitialData" {
  export default function getInitialData(param: {oppId: any}): Promise<any>;
}
declare module "@salesforce/apex/ApprovalRequestController.getApprovalVisibilityProfiles" {
  export default function getApprovalVisibilityProfiles(): Promise<any>;
}
declare module "@salesforce/apex/ApprovalRequestController.getVisibilityApproval" {
  export default function getVisibilityApproval(param: {oppId: any}): Promise<any>;
}
declare module "@salesforce/apex/ApprovalRequestController.saveApproval" {
  export default function saveApproval(param: {oppId: any}): Promise<any>;
}
declare module "@salesforce/apex/ApprovalRequestController.rejectProposalRisk" {
  export default function rejectProposalRisk(param: {oppId: any, reason: any, obs: any}): Promise<any>;
}
declare module "@salesforce/apex/ApprovalRequestController.rejectProposalConfirmBoss" {
  export default function rejectProposalConfirmBoss(param: {oppId: any}): Promise<any>;
}
declare module "@salesforce/apex/ApprovalRequestController.rejectProposalNotification" {
  export default function rejectProposalNotification(param: {oppId: any, profile: any, obs: any, action: any}): Promise<any>;
}
declare module "@salesforce/apex/ApprovalRequestController.stageApprovalManager" {
  export default function stageApprovalManager(param: {oppId: any}): Promise<any>;
}
declare module "@salesforce/apex/ApprovalRequestController.stageRejectManager" {
  export default function stageRejectManager(param: {oppId: any, motivo: any}): Promise<any>;
}
declare module "@salesforce/apex/ApprovalRequestController.sendToApproveManager" {
  export default function sendToApproveManager(param: {oppId: any}): Promise<any>;
}
