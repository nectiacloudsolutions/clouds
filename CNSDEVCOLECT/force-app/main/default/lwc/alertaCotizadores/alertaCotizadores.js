import { LightningElement } from 'lwc';

export default class AlertaCotizadores extends LightningElement {
    header = "Alertas Operacionales";
    content = "";
    callcountalert = false;

    handleHeaderChange(event){
        this.header = event.targe.value;
    }

    handleContentChange(event){
        this.content = event.target.value;
    }

    handleShowModal(){
        const modal = this.template.querySelector('c-modal-alerta-cotizador');
        this.callcountalert = true;
        modal.show();
    }
    /*
    handleCancelModal(){
        const modal = this.template.querySelector('c-modal-alerta-cotizador');
        modal.hide();
    }

    handleCloselModal(){
        const modal = this.template.querySelector('c-modal-alerta-cotizador');
        modal.hide();
    }*/
}