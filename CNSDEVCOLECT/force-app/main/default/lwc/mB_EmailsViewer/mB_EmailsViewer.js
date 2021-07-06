import { LightningElement, api, wire } from 'lwc';
import getEmailsList from '@salesforce/apex/MB_EmailsViewer.getEmailsList';

const COLUMNS = [{
    label: 'Nombre Comunicación',
    fieldName: 'nombreComunicacion',
    type: 'text',
    sortable: false,
    initialWidth: 270,
    hideDefaultActions: true,
    cellAttributes: { iconName: 'utility:email' }
},
{
    label: 'Fecha Envío',
    fieldName: 'fechaEnvio',
    type: 'date-local',
    sortable: false,
    initialWidth: 120,
    hideDefaultActions: true,
    class: 'slds-icon-text-error',
    cellAttributes: { iconName: 'utility:date_input' },
    typeAttributes: {
        day: "numeric",
        month: "numeric",
        year: "numeric"
    }

},
{
    label: 'Enviado',
    sortable: false,
    hideDefaultActions: true,
    cellAttributes: { iconName: { fieldName: 'enviado' } }
},
{
    label: 'Recibido',
    sortable: false,
    hideDefaultActions: true,
    cellAttributes: { iconName: { fieldName: 'recibido' } }
},
{
    label: 'Leído',
    sortable: false,
    hideDefaultActions: true,
    cellAttributes: { iconName: { fieldName: 'leido'} }
},
{
    label: 'Contenido Mail',
    sortable: false,
    fieldName: 'url',
    type: 'url',
    hideDefaultActions: true,
    typeAttributes: { label: 'Descargar', value: {fieldName:'url'}  },
    cellAttributes: { iconName: 'utility:download' }
}
];
export default class MB_EmailsViewer extends LightningElement {
    columns = COLUMNS;
    error;
    isLoading = false;
    emailsRecords;
    parameterObject;

    @api fieldApiName;
    @api subjectTextFilter
    @api objectApiName;
    @api recordId;


    connectedCallback() {
        this.parameterObject = {
            objectApiName: this.objectApiName,
            fieldApiName:  this.fieldApiName,
            recordId: this.recordId,
            subjectTextFilter: this.subjectTextFilter
        };
    }


    @wire(getEmailsList, { parameterLWC:'$parameterObject' })
    dataHandler({ error, data }) {
        this.isLoading = true;
        if (data) {
            this.error = undefined;
            this.template.querySelector('lightning-card').title = 'Emails enviados (' + data.length + ')';
            this.isLoading = false;

            this.emailsRecords = data.map(item =>{
                console.log(item);    
                let iconNameEnviado = item.enviado > 0 ? "utility:success":"utility:routing_offline"
                let iconNameRecibido = item.recibido > 0 ? "utility:success":"utility:routing_offline"
                let iconNameLeido = item.leido > 0 ? "utility:success":"utility:routing_offline"

                return {...item,"enviado": iconNameEnviado, "recibido": iconNameRecibido, "leido": iconNameLeido };
            });

        } else if (error) {
            this.error = error;
            this.emailsRecords = undefined;
            this.isLoading = false;
            console.error(error);        
        }

    }   
}