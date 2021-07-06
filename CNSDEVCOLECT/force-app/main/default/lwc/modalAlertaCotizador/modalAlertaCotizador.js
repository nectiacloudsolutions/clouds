import { LightningElement, api, wire } from 'lwc';

import getCantidadPropuestasPendientes from '@salesforce/apex/AlertasController.getCantidadPropuestasPendientes';
import getCantidadMandatosPendientes from '@salesforce/apex/AlertasController.getCantidadMandatosPendientes';


import USER_ID from '@salesforce/user/Id';

export default class ModalAlertaCotizador extends LightningElement {
    showModal=false;
    loading=true;
    showPpTable=false;
    showMpTable=false;

    iconpp = ''; 
    iconmp = ''; 
    vpp = '';
    vmp = '';

    activeSection = '';
    activeSections = [''];
    
    countPpendiente=0;
    countMpendiente=0;

    privateCallCount;
    @api
    get callCounts() {
        return this.privateCallCount;
    }
    set callCounts(value) {
        this.privateCallCount = value;
    }

    @api show(){
        this.showModal = true;
    }

    @api hide(){
        this.showModal = true;
    }

    connectedCallback() {
        //if(this.privateCallCount){
            this.getCountPropuestasPendientes(USER_ID);
            this.getCountMandatosPendientes(USER_ID);
        //}
    }
 
    getCountPropuestasPendientes(userId) {
        getCantidadPropuestasPendientes({
            idUsuario: userId 
        })
        .then((result) => {
            this.countPpendiente = result.cantidad;
            console.log(result);
            this.activeSections['perfil'] = result.perfil;
            if(this.countPpendiente == 0){
                this.iconpp = 'utility:success';
                this.vpp = 'success';
                this.activeSections['dpp'] = 'No hay alertas disponibles';
            }else if(this.countPpendiente > 0){
                this.iconpp = 'utility:warning';
                this.vpp = 'warning';
                this.showPpTable=true;
            }else{
                this.iconpp = 'utility:error';
                this.vpp = 'error';
                this.activeSections['dpp'] = 'Ha ocurrido un error al obtener información, vuelva a refrescar.';
            }
        })
        .catch((error) => {
            this.iconpp = 'utility:error';
            this.vpp = 'error';
            this.activeSections['dpp'] = 'Ha ocurrido un error al obtener información, vuelva a refrescar.';
        })
        .finally(() => {
            this.loading = false;
        })
    }

    getCountMandatosPendientes(userId) {
        this.loading = true;
        getCantidadMandatosPendientes({
            idUsuario: userId  
        })
        .then((result) => {
            this.countMpendiente = result.cantidad;
            this.activeSections['perfil'] = result.perfil;
            if(this.countMpendiente == 0){
                this.iconmp = 'utility:success';
                this.vmp = 'success';
                this.activeSections['dmp'] = 'No hay alertas disponibles';
            }else if(this.countMpendiente > 0){
                this.iconmp = 'utility:warning';
                this.vmp = 'warning';
                this.showMpTable=true;
            }else{
                this.iconmp = 'utility:error';
                this.vmp = 'error';
                this.activeSections['dmp'] = 'Ha ocurrido un error al obtener información, vuelva a refrescar.';
            }
        })
        .catch((error) => {
            this.iconmp = 'utility:error';
            this.vmp = 'error';
            this.activeSections['dmp'] = 'Ha ocurrido un error al obtener información, vuelva a refrescar.';
        })
        .finally(() => {
            this.loading = false;
        })
    }

    handleSectionToggle(event) {
        const openSections = event.detail.openSections;
        this.activeSections['countpp'] = 0;
        this.activeSections['countmp'] = 0;

        if (openSections.length === 0) {
            this.activeSections['countpp'] = 0;
            this.activeSections['countmp'] = 0;
        } else {
            console.log("openSections:", openSections);
            openSections.forEach(element => {
                if(element == 'ppendientes') {
                    if(this.showPpTable){
                        this.template.querySelector('c-detalle-propuestas-pendientes').getPropuestasPendientes(USER_ID, this.activeSections['perfil']);
                    }
                }
                    
                if(element == 'mpendientes'){
                    if(this.showMpTable){
                        this.template.querySelector('c-detalle-mandatos-pendientes').getMandatosPendientes(USER_ID, this.activeSections['perfil']);
                    }
                }
            });
        }
    }

    closeModalAction(){
        this.showModal=false;
    }
}