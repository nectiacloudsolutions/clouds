import { LightningElement, track, api } from 'lwc';
import getDetallePropuestasPendientes from '@salesforce/apex/AlertasController.getDetallePropuestasPendientes';


const cabeceraPropuestasPendientes=[
    {
        label: 'Propuesta',
        fieldName: 'propuesta'
    },
    {
        label: 'Cliente',
        fieldName: 'Cliente'
    },
    {
        label: 'Producto',
        fieldName: 'nombreProducto'
    },
    {
        label: 'Estado Propuesta',
        fieldName: 'estado'
    },
    {
        label: 'Fecha',
        fieldName: 'fechaEstado'
    },
    {
        label: 'Causal',
        fieldName: 'causal'
    },
    {
        label: 'Ejecutivo',
        fieldName: 'nombreAgente'
    }
];

export default class DetallePropuestasPendientes extends LightningElement {

    @track columnsPropuestasPendientes;

    @track dataPropuestasPendientes = [];
    loading=true;

    @track page = 1;
    @track itemsPaginator = [];    
    @track startingRecord = 1;
    @track endingRecord = 0; 
    @track pageSize = 5; 
    @track totalRecountCount = 0;
    @track totalPage = 0;

    @api
    getPropuestasPendientes(idUsuario, perfil) {
        
        getDetallePropuestasPendientes({
            idUsuario: idUsuario 
        })
        .then((result) => {

            this.itemsPaginator = result.detallePropuestasPendiente;
            this.totalRecountCount = result.detallePropuestasPendiente.length;
            this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); 

            this.dataPropuestasPendientes = this.itemsPaginator.slice(0,this.pageSize); 
            this.endingRecord = this.pageSize;

        })
        .catch((error) => {
            console.log(error);
        })
        .finally(() => {

            if(perfil == 'Ejecutivo' && cabeceraPropuestasPendientes.length == 7){
                cabeceraPropuestasPendientes.splice(cabeceraPropuestasPendientes.length-1, 1);
            }

            this.columnsPropuestasPendientes = cabeceraPropuestasPendientes;
            this.loading = false;
        })        
    }

    previousHandler() {
        if (this.page > 1) {
            this.page = this.page - 1;
            this.displayRecordPerPage(this.page);
        }
    }

    nextHandler() {
        if((this.page<this.totalPage) && this.page !== this.totalPage){
            this.page = this.page + 1;
            this.displayRecordPerPage(this.page);            
        }             
    }

    displayRecordPerPage(page){

        this.startingRecord = ((page -1) * this.pageSize) ;
        this.endingRecord = (this.pageSize * page);

        this.endingRecord = (this.endingRecord > this.totalRecountCount) 
                            ? this.totalRecountCount : this.endingRecord; 

        this.dataPropuestasPendientes = this.itemsPaginator.slice(this.startingRecord, this.endingRecord);

        this.startingRecord = this.startingRecord + 1;
    }

}