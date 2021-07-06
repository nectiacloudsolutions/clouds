({
  InitData: function(cmp, event) {
    var action = cmp.get("c.getData");
    action.setParams({ recordId: cmp.get("v.recordId") });

    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var result = response.getReturnValue();
        cmp.set("v.files", result);
      } else if (state === "ERROR") {
        var errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {
            console.log("Error message: " + errors[0].message);
          }
        } else {
          console.log("Unknown error");
        }
      }
    });
    $A.enqueueAction(action);
  },
  callviewFileDocuware: function(cmp, event, idRepo) {
    var action = cmp.get("c.viewDocDocuware");
    cmp.set("v.pdfContainer", "");
    action.setParams({
      idRepo: idRepo
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      console.log(response.getReturnValue());
      if (state === "SUCCESS") {
        var rootObj = JSON.parse(JSON.stringify(response.getReturnValue()));
        if (rootObj.codigoServicio === "0") {
          	var pdfData = rootObj.documents.documentResult[0].contenido;
            this.renderPdfViewer(cmp, event,pdfData);
        } else {
          var toastEvent = $A.get("e.force:showToast");
          toastEvent.setParams({
            title: "Ha ocurrido un error",
            message:
              "Error del Servicio :" +rootObj.mensaje,
            type: "Error"
          });
          toastEvent.fire();
        }
          cmp.set("v.showSpinner", false);
      } else {
        console.log("Unknown error");
      }
    });
    $A.enqueueAction(action);
  },
  callviewFileAlfresco: function(cmp, event, idRepo) {
    var action = cmp.get("c.viewDocAlfresco");
    cmp.set("v.pdfContainer", "");
    action.setParams({
      idRepo: idRepo
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      console.log(response.getReturnValue());
      if (state === "SUCCESS") {
        var rootObj = JSON.parse(JSON.stringify(response.getReturnValue()));
        //console.log('OBJETO-->' +rootObj.mensaje);
        if (rootObj.dtoResponseSetParametros.codigoError == "0") {
			var pdfData = rootObj.salidaDocAlfresco.bytes;
			this.renderPdfViewer(cmp, event,pdfData);
        } else if (rootObj.dtoResponseSetParametros.codigoError == "999") {
          var toastEvent = $A.get("e.force:showToast");
          toastEvent.setParams({
            title: "Precaución!",
            message: rootObj.dtoResponseSetParametros.msjError,
            type: "Warning"
          });
          toastEvent.fire();
        } else {
          var toastEvent = $A.get("e.force:showToast");
          toastEvent.setParams({
            title: "Ha ocurrido un error",
            message:
              "Error del Servicio :" +
              rootObj.dtoResponseSetParametros.msjError,
            type: "Error"
          });
          toastEvent.fire();
        }
        cmp.set("v.showSpinner", false);
      } else {
        console.log("Unknown error");
      }
    });
    $A.enqueueAction(action);
  },
    renderPdfViewer: function(cmp, event,pdfData) {
              $A.createComponent(
            "c:pdfViewer",
            {
              pdfData: pdfData
            },
            function(pdfViewer, status, errorMessage) {
              if (status === "SUCCESS") {
                var pdfContainer = cmp.get("v.pdfContainer");
                pdfContainer.push(pdfViewer);
                cmp.set("v.pdfContainer", pdfContainer);
                cmp.set("v.isOpenPdf", true);
              } else if (status === "INCOMPLETE") {
                console.log("No response from server or client is offline.");
              } else if (status === "ERROR") {
                console.log("Error: " + errorMessage);
              }
            }
          );
         }
});