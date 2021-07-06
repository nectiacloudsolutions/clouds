declare module "@salesforce/apex/FileUploadCaseController.invokeUploadAlfrescoNew" {
  export default function invokeUploadAlfrescoNew(param: {idRecord: any, fileId: any, IdDocs: any}): Promise<any>;
}
declare module "@salesforce/apex/FileUploadCaseController.updateDocsNew" {
  export default function updateDocsNew(param: {IdDocs: any, IdAlfresco: any, EstadoDoc: any}): Promise<any>;
}
declare module "@salesforce/apex/FileUploadCaseController.viewDocNew" {
  export default function viewDocNew(param: {idDoc: any}): Promise<any>;
}
declare module "@salesforce/apex/FileUploadCaseController.saveChunk" {
  export default function saveChunk(param: {parentId: any, fileName: any, base64Data: any, contentType: any, fileId: any}): Promise<any>;
}
