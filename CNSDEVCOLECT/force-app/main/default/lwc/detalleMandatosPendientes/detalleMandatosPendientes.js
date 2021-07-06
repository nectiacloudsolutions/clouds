import { LightningElement, track, api } from 'lwc';
import getDetalleMandatosPendientes from '@salesforce/apex/AlertasController.getDetalleMandatosPendientes';


const cabeceraMandatosPendientes=[
    {
        label: 'Cliente',
        fieldName: 'SNombreCliente'
    },
    {
        label: 'Rut',
        fieldName: 'SRutCliente',
        sortable: true
    },
    {
        label: 'Producto',
        fieldName: 'SProducto'
    },
    {
        label: 'Póliza / Propuesta',
        fieldName: 'SPolprop'
    },
    {
        label: 'N° Póliza / Propuesta',
        fieldName: 'NPolicy'
    },
    {
        label: 'Via de Pago',
        fieldName: 'SViaPago'
    },
    {
        label: 'Estado',
        fieldName: 'SestadoReal'
    },
    {
        label: 'Ejecutivo',
        fieldName: 'SnombreEjecutivo'
    }
];

export default class DetalleMandatosPendientes extends LightningElement {

    @track columnsMandatosPendientes;

    @track dataMandatosPendientes = [];
    loading=true;

    @track page = 1;
    @track itemsPaginator = [];    
    @track startingRecord = 1;
    @track endingRecord = 0; 
    @track pageSize = 5; 
    @track totalRecountCount = 0;
    @track totalPage = 0;

    @api
    getMandatosPendientes(idUsuario, perfil) {
        
        getDetalleMandatosPendientes({
            idUsuario: idUsuario 
        })
        .then((result) => {
                    
            this.itemsPaginator = result.detalleMandatos;
            this.totalRecountCount = result.detalleMandatos.length;
            this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); 

            this.dataMandatosPendientes = this.itemsPaginator.slice(0,this.pageSize); 
            this.endingRecord = this.pageSize;

        })
        .catch((error) => {
            console.log(error);
        })
        .finally(() => {

            if(perfil == 'Ejecutivo' && cabeceraMandatosPendientes.length == 8){
                cabeceraMandatosPendientes.splice(cabeceraMandatosPendientes.length-1, 1);
            }          
   
            this.columnsMandatosPendientes = cabeceraMandatosPendientes;
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

        this.dataMandatosPendientes = this.itemsPaginator.slice(this.startingRecord, this.endingRecord);

        this.startingRecord = this.startingRecord + 1;
    }

}