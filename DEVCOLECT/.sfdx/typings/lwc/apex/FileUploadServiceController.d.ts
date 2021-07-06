declare module "@salesforce/apex/FileUploadServiceController.saveChunk" {
  export default function saveChunk(param: {parentId: any, fileName: any, base64Data: any, contentType: any, fileId: any}): Promise<any>;
}
declare module "@salesforce/apex/FileUploadServiceController.validateTypeClient" {
  export default function validateTypeClient(param: {caseId: any}): Promise<any>;
}
declare module "@salesforce/apex/FileUploadServiceController.callDocumentManager" {
  export default function callDocumentManager(param: {caseId: any, fileId: any}): Promise<any>;
}
declare module "@salesforce/apex/FileUploadServiceController.validateManagerId" {
  export default function validateManagerId(): Promise<any>;
}
