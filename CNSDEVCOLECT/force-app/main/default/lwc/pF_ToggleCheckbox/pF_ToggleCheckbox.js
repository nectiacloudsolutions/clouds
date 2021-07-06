import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord, getFieldValue, updateRecord } from 'lightning/uiRecordApi';

export default class PF_ToggleCheckbox extends LightningElement {
    @api fieldLabel;
    @api checkOnLabel;
    @api checkOffLabel;
    @api fieldApiName;
    @api recordId;

    showConfirmDialog = false;
    checkboxVal;
    arrField = [];

    @wire(getRecord, { recordId: '$recordId', fields: '$fieldApiName' })
    wireRec({ error, data }) {
        if (error) {
            console.log('error:' + error);
            this.showErrorMessage('Error al Obtener el valor del campo ' + this.fieldApiName );   
        } else if (data) {
            this.checkboxVal = getFieldValue(data, this.fieldApiName);
        }  else{
            this.showErrorMessage('Error al obtener el valor del campo ' + this.fieldApiName);
        }
    }

    handleChange(event) {
        this.checkboxVal = event.target.checked;
        this.showConfirmDialog = true;
    }

    handleConfirmDialogYes() {
        this.arrField = this.fieldApiName.split('.');

        const fields = {};
        fields['Id'] = this.recordId;
        fields[this.arrField[1]] = this.checkboxVal;

        updateRecord({ fields })
        .then(() => {
            this.showSuccessMessage('El Registro se ha Actualizado correctamente.');
        })
        .catch(error => {
            this.checkboxVal = !this.checkboxVal;
            this.showErrorMessage('Error al actualizar: ' + error.body.message);
        });
        this.showConfirmDialog = false;
    }
    handleConfirmDialogNo() {
        this.checkboxVal = !this.checkboxVal;
        this.showConfirmDialog = false;
    }
    showErrorMessage(errorMessage){
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error!!!',
                message: errorMessage,
                variant: 'error',
                duration:'1500'
            })
        );
    }
    showSuccessMessage(successMessage){
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Actualización correcta!',
                message: successMessage,
                variant: 'success',
                duration:'1500'
            })
        );
    }
}