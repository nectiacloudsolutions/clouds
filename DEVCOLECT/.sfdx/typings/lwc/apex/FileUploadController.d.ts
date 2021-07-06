declare module "@salesforce/apex/FileUploadController.invokeUploadAlfresco" {
  export default function invokeUploadAlfresco(param: {IdOpp: any, fileId: any, IdDocs: any}): Promise<any>;
}
declare module "@salesforce/apex/FileUploadController.saveChunk" {
  export default function saveChunk(param: {parentId: any, fileName: any, base64Data: any, contentType: any, fileId: any}): Promise<any>;
}
declare module "@salesforce/apex/FileUploadController.updateDocs" {
  export default function updateDocs(param: {IdDocs: any, IdAlfresco: any, EstadoDoc: any}): Promise<any>;
}
declare module "@salesforce/apex/FileUploadController.viewDoc" {
  export default function viewDoc(param: {idDoc: any}): Promise<any>;
}
