/**
 * @description       : 
 * @author            : eayalcor@everis.com
 * @group             : 
 * @last modified on  : 11-04-2020
 * @last modified by  : eayalcor@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   11-04-2020   eayalcor@everis.com   Initial Version
**/
import { LightningElement, track,wire } from 'lwc';
import getSectionInfo from '@salesforce/apex/SectionInfoController.getSectionInfo';
import hasAccess from '@salesforce/apex/SectionInfoController.hasAccess';

export default class SectionInfo extends LightningElement {

    @track sections;
    @track error;
    @track isVisible;
    @track access;

    @wire(getSectionInfo)
    wiredInfo({ error, data }) {
        if (data) {
            this.isVisible = data.length > 0 ? true : false;
            this.sections = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.sections = undefined;
        }
    }

    @wire(hasAccess) 
    isObjectCreate({ error, data }) {
        if (data != null && data != undefined) { 
           this.access = data;
        } else if (error) {
            this.access = false;
        }
    }
    
    
}