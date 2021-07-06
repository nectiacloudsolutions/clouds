@isTest
public class CONS_NewCaseProductoSegurosControllTest {
    static testMethod void TestControlador_1() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Vida';
        pds.Familia__c = 'APV';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Modificación de Póliza';
        sc.validaSeccion();
        sc.nuevoCaso.Tipo_de_Modificaci_n__c = 'Regimen Tributario';
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        //cas.SlaStartDate=System.now(); 
        sc.saveAndClose();
    }
    static testMethod void TestControlador_2() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Generales';
        pds.Familia__c = 'Seguro Vehículos';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Modificación de Póliza';
        sc.validaSeccion();
        sc.nuevoCaso.Tipo_de_Modificaci_n__c = 'Vía de Pago';
        sc.validaSeccion();
        sc.nuevoCaso.V_a_de_Pago__c = '3';
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        sc.saveAndSee();
        PageReference c = sc.cerrar();
        //cas.SlaStartDate=System.now(); 
        
    }
    static testMethod void TestControlador_3() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Generales';
        pds.Familia__c = 'Seguro Vehículos';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Modificación de Póliza';
        sc.validaSeccion();
        sc.nuevoCaso.Tipo_de_Modificaci_n__c = 'Rehabilitación';
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        sc.presencial = false;
        sc.remoto = true;
        sc.saveAndSee();
        sc.updateUser('asdasd');
    }
    static testMethod void TestControlador_3b() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Generales';
        pds.Familia__c = 'Seguro Vehículos';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Modificación de Póliza';
        sc.validaSeccion();
        sc.nuevoCaso.Tipo_de_Modificaci_n__c = 'Rehabilitación';
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        sc.presencial = true;
        sc.remoto = false;
        sc.saveAndSee();
    }
    static testMethod void TestControlador_4() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Generales';
        pds.Familia__c = 'Seguro Vehículos';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Modificación de Póliza';
        sc.validaSeccion();
        sc.nuevoCaso.Tipo_de_Modificaci_n__c = 'Terminos de Pólizas (Solo Vida Tradicional)';
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        sc.presencial = false;
        sc.remoto = true;
        sc.saveAndSee();
    }
    static testMethod void TestControlador_4b() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Generales';
        pds.Familia__c = 'Seguro Vehículos';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Modificación de Póliza';
        sc.validaSeccion();
        sc.nuevoCaso.Tipo_de_Modificaci_n__c = 'Terminos de Pólizas (Solo Vida Tradicional)';
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        sc.presencial = true;
        sc.remoto = false;
        sc.saveAndSee();
    }
    static testMethod void TestControlador_5() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Generales';
        pds.Familia__c = 'Seguro Vehículos';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Otros Pagos';
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        sc.presencial = false;
        sc.remoto = true;
        sc.saveAndSee();
    }
    static testMethod void TestControlador_5b() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Generales';
        pds.Familia__c = 'Seguro Vehículos';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Otros Pagos';
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        sc.presencial = true;
        sc.remoto = false;
        sc.saveAndSee();
    }
    static testMethod void TestControlador_6() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Generales';
        pds.Familia__c = 'Seguro Vehículos';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='No Pago Pensión';
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        sc.presencial = false;
        sc.remoto = true;
        sc.saveAndSee();
    }
    static testMethod void TestControlador_7() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Generales';
        pds.Familia__c = 'Seguro Vehículos';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        sc.tipoDoc = true;
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Rescate';
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        sc.saveAndSee();
    }
    static testMethod void TestControlador_8() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Generales';
        pds.Familia__c = 'Seguro Vehículos';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Reclamo';
        sc.nuevoCaso.Subtipo__c='Asociadas a Producción S. Vida';
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        sc.saveAndSee();
    }
    static testMethod void TestControlador_9() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Generales';
        pds.Familia__c = 'Seguro Vehículos';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Modificación de Póliza';
        sc.validaSeccion();
        sc.nuevoCaso.Tipo_de_Modificaci_n__c = 'Día de Pago';
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        sc.presencial = false;
        sc.remoto = true;
        sc.saveAndSee();
    }
    static testMethod void TestControlador_10() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Generales';
        pds.Familia__c = 'Seguro Vehículos';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Modificación de Póliza';
        sc.validaSeccion();
        sc.nuevoCaso.Tipo_de_Modificaci_n__c = 'Frecuencia de Pago';
        sc.validaSeccion();
        sc.nuevoCaso.V_a_de_Pago__c = '2';
        sc.FechaInicioSuspension = system.today();
        //sc.selectedBancos = '1';
        sc.NuevaPrimaProyectada = 3123;
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        sc.presencial = false;
        sc.remoto = true;
        sc.saveAndSee();
    }
    static testMethod void TestControlador_11() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Generales';
        pds.Familia__c = 'Seguro Vehículos';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        sc.tmpMdt = new Arbol_Familias_Tipos_Seguros__mdt();
        sc.mdt = new Arbol_Familias_Tipos_Seguros__mdt();
        //sc.arrayCampos = new List<ListasSeleccionSeguros__mdt>();
        sc.selectedBancoLabel = 'BANCO DE CHILE';
        
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Modificación de Póliza';
        sc.validaSeccion();
        sc.nuevoCaso.Tipo_de_Modificaci_n__c = 'Frecuencia de Pago';
        sc.validaSeccion();
        sc.nuevoCaso.V_a_de_Pago__c = '1';
        sc.FechaInicioSuspension = system.today();
        //sc.selectedBancos = '1';
        sc.NuevaPrimaProyectada = 3123;
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        sc.presencial = false;
        sc.remoto = true;
        sc.saveAndSee();
    }
    
    
    static testMethod void TestControlador_12() {
        CONS_RespuestaConsultaViaPago_JSON  cr=new CONS_RespuestaConsultaViaPago_JSON();
        string  str='{    "codigoViaPago": 2,    "diaPago": 20,    "codigoBanco": 2,   "numeroCuenta": "6656777785954444",    "mandatoPoliza": "13263",    "codigoTipoCuenta": 0,    "codigoTipoTarjeta": 3,    "fechaExpiracionTarjeta": "10-10-2023",    "fechaVigenciaTarjeta": "24-01-2019",    "frecuenciaPagos": 5,    "rutPagador": "00000014761486",    "digitoPagador": "1",    "nombrePagador": "iXWkzNRCKrdFtXAMatg",    "apellidoPPagador": "VDEaxEMBFKQciblMOkY",    "apellidoMPagador": "qvOPFDnvslfaiWVnnmk",    "fechaNaciminetoPagador": "17-02-1976",    "sexoPagador": "1",    "codigoEmpleador": 0,    "numeroCalle": 0,    "codigoComuna": 0,    "codigoCiudad": 0,    "codigo": 0}';
        cr=CONS_RespuestaConsultaViaPago_JSON.parse(str);
        
    }
    static testMethod void TestControlador_13() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='APV FONDO EXPERTO';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Vida';
        pds.Familia__c = 'APV';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='APV FONDO EXPERTO';
        pc.Esquema_Nectia__c='INSU';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        sc.tmpMdt = new Arbol_Familias_Tipos_Seguros__mdt();
        sc.mdt = new Arbol_Familias_Tipos_Seguros__mdt();
        //sc.arrayCampos = new List<ListasSeleccionSeguros__mdt>();
        sc.selectedBancoLabel = 'BANCO DE CHILE';
        
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Rescate';
        sc.nuevoCaso.Tipo_Rescate__c='2';
        
        sc.validaSeccion();
        
        sc.MontoPesoCotizacionA=12;
        sc.MontoPesoCotizacionB=12;
        sc.MontoPesoDepositoA=123;
        sc.MontoPesoDepositoB=123;
        sc.MontoPesoDepositoBMayor=123;
        sc.MontoPesoCotizacionBMayor=123;
        sc.MontoPesoCotizacionAUF=1234;
        sc.MontoUFDepositoA=123;
        sc.saveAndSee();
        sc.MontoPesoCotizacionAUF=null;
        sc.MontoUFDepositoA=null;
        sc.MontoPesoCotizacionBUF=1234;
        sc.MontoUFDepositoB=123;
        sc.saveAndSee();
        sc.MontoPesoCotizacionAUF=null;
        sc.MontoUFDepositoA=null;
        sc.MontoPesoCotizacionBUF=null;
        sc.MontoUFDepositoB=null;
        sc.MontoPesoDepositoAUF=1234;
        sc.MontoUFDepositoAPVA=123;
        sc.saveAndSee();
        sc.MontoPesoCotizacionAUF=null;
        sc.MontoUFDepositoA=null;
        sc.MontoPesoCotizacionBUF=null;
        sc.MontoUFDepositoB=null;
        sc.MontoPesoDepositoAUF=null;
        sc.MontoUFDepositoAPVA=null;
        sc.MontoPesoDepositoBUF=1234;
        sc.MontoUFDepositoAPVB=123;
        sc.saveAndSee();
        sc.MontoPesoCotizacionAUF=null;
        sc.MontoUFDepositoA=null;
        sc.MontoPesoCotizacionBUF=null;
        sc.MontoUFDepositoB=null;
        sc.MontoPesoDepositoAUF=null;
        sc.MontoUFDepositoAPVA=null;
        sc.MontoPesoDepositoBUF=null;
        sc.MontoUFDepositoAPVB=null;
        sc.MontoPesoCotizacionBUFMayor=1234;
        sc.MontoUFDepositoBMayor=123;
        sc.saveAndSee();
        sc.MontoPesoCotizacionAUF=null;
        sc.MontoUFDepositoA=null;
        sc.MontoPesoCotizacionBUF=null;
        sc.MontoUFDepositoB=null;
        sc.MontoPesoDepositoAUF=null;
        sc.MontoUFDepositoAPVA=null;
        sc.MontoPesoDepositoBUF=null;
        sc.MontoUFDepositoAPVB=null;
        sc.MontoPesoCotizacionBUFMayor=null;
        sc.MontoUFDepositoBMayor=null;
        sc.MontoPesoDepositoBUFMayor=1234;
        sc.MontoUFDepositoAPVBMayor=123;
        sc.saveAndSee();
        sc.MontoPesoCotizacionAUF=null;
        sc.MontoUFDepositoA=null;
        sc.MontoPesoCotizacionBUF=null;
        sc.MontoUFDepositoB=null;
        sc.MontoPesoDepositoAUF=null;
        sc.MontoUFDepositoAPVA=null;
        sc.MontoPesoDepositoBUF=null;
        sc.MontoUFDepositoAPVB=null;
        sc.MontoPesoCotizacionBUFMayor=null;
        sc.MontoUFDepositoBMayor=null;
        sc.MontoPesoDepositoBUFMayor=null;
        sc.MontoUFDepositoAPVBMayor=null;
        sc.presencial = false;
        sc.remoto = true;
        sc.saveAndSee();
        
        string str='<?xml version="1.0" encoding="UTF-8"?><S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><ns2:getUfResponse xmlns:ns2="http://ws.wsrescatevida.cnsv.cl/"><return><err_code>0</err_code><ufVal><ufVal>27602.45</ufVal></ufVal></return></ns2:getUfResponse></S:Body></S:Envelope>';
        DOM.Document doc = new DOM.Document();
        doc.load(str);  
        DOM.XMLNode node=doc.getRootElement();
        sc.parseXML(node);
    }
    
    
    
    static testMethod void TestControlador_14() {
        CONS_ConsultaRescate_JSON  cc=new CONS_ConsultaRescate_JSON();
        string     str = '{"listaCuentas":[{"nCodigoProducto": 294,"nOrigin": 4,"nPoliza": 11511650,"nRamoProducto": 1,"nRescateEstimado": 4245,"sOrigin": "Cuenta Unificada" }], "nTipoRescate": 1,"nTotalEstimado": 4245,"responseError": {"nCodigo": 0,"sMensaje": "OK TOTAL" }}';
        CONS_ConsultaRescate_JSON.parse(str);
    }
    
    
    static testMethod void TestControlador_15() {
        
        User u2;
        Account  acc;
        Producto_de_Seguros__c pds;
        Producto_del_Cliente__c pc;
        
        User usuarioActual = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        
        //System.runAs(usuarioActual){
        
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Generales';
        pds.Familia__c = 'Seguro Vehículos';
        insert pds;
        
        pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        
        
        
        //}
        Profile p = [SELECT Id FROM Profile WHERE Name='Ejecutivos de Atención al Cliente Seguros Presencial'];
        UserRole f = [SELECT Id FROM UserRole WHERE Name = 'Seguros'];
        
        u2 = new User(Alias = 'newUs', Email='newuser@testorg.com',
                      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                      LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = f.Id,
                      TimeZoneSidKey='America/Los_Angeles', UserName='testdsafas@testorg.com');
        //insert u2;
        system.debug('pcpc==='+pc.id);
        system.debug('pcpc==='+pc);
        //System.runAs(u2) {
        
        System.debug('Current User: ' + UserInfo.getUserName());
        System.debug('Current Profile: ' + UserInfo.getProfileId());
        string respr = [SELECT Name FROM Profile WHERE Id=: UserInfo.getProfileId()limit 1].Name;
        System.debug('respr: ' + respr);
        system.debug('pcpc2==='+pc.id);
        system.debug('pcpc2==='+pc);
        System.currentPageReference().getParameters().put('id',pc.id);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        
        ApexPages.StandardController astc = new ApexPages.StandardController(pc);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        //System.currentPageReference().getParameters().put('id',pc.id);
        //Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        sc.perfilPresencial = false;
        sc.presencial = true;
        sc.remoto = false;
        sc.saveAndSee();
        //}
    }
    
    
    static testMethod void TestControlador_16() {
        
        User u2;
        Account  acc;
        Producto_de_Seguros__c pds;
        Producto_del_Cliente__c pc;
        
        User usuarioActual = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        
        //System.runAs(usuarioActual){
        
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Generales';
        pds.Familia__c = 'Seguro Vehículos';
        insert pds;
        
        pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Ejecutivos de Atención al Cliente Seguros Presencial'];
        u2 = new User(Alias = 'newUs', Email='newuser@testorg.com',
                      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                      LocaleSidKey='en_US', ProfileId = p.Id,
                      TimeZoneSidKey='America/Los_Angeles', UserName='testdsafas@testorg.com');
        //}
        
        //System.runAs(u2) {
        System.debug('Current User: ' + UserInfo.getUserName());
        System.debug('Current Profile: ' + UserInfo.getProfileId());
        
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        sc.tmpMdt = new Arbol_Familias_Tipos_Seguros__mdt();
        sc.mdt = new Arbol_Familias_Tipos_Seguros__mdt();
        //sc.arrayCampos = new List<ListasSeleccionSeguros__mdt>();
        sc.selectedBancoLabel = 'BANCO DE CHILE';
        
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Modificación de Póliza';
        sc.validaSeccion();
        sc.nuevoCaso.Tipo_de_Modificaci_n__c = 'Anulación de Endoso';
        sc.validaSeccion();
        sc.nuevoCaso.V_a_de_Pago__c = '1';
        sc.FechaInicioSuspension = system.today();
        //sc.selectedBancos = '1';
        sc.NuevaPrimaProyectada = 3123;
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        sc.presencial = true;
        sc.remoto = false;
        sc.saveAndSee();
        
        
    }
    
    
    static testMethod void TestControlador_17() {
        
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Generales';
        pds.Familia__c = 'Seguro Vehículos';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        sc.tmpMdt = new Arbol_Familias_Tipos_Seguros__mdt();
        sc.mdt = new Arbol_Familias_Tipos_Seguros__mdt();
        //sc.arrayCampos = new List<ListasSeleccionSeguros__mdt>();
        sc.selectedBancoLabel = 'BANCO DE CHILE';
        
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Modificación de Póliza';
        sc.validaSeccion();
        sc.nuevoCaso.Tipo_de_Modificaci_n__c = 'Suspensión de Pagos';
        sc.validaSeccion();
        sc.nuevoCaso.V_a_de_Pago__c = '1';
        sc.FechaInicioSuspension = system.today();
        //sc.selectedBancos = '1';
        sc.NuevaPrimaProyectada = 3123;
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        sc.presencial = false;
        sc.remoto = true;
        sc.saveAndSee();
        
        
    }
    
    static testMethod void TestControlador_18() {
        
        
        User u2;
        Account  acc;
        Producto_de_Seguros__c pds;
        Producto_del_Cliente__c pc;
        
        User usuarioActual = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        
        //System.runAs(usuarioActual){
        
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Generales';
        pds.Familia__c = 'Seguro Vehículos';
        insert pds;
        
        pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Ejecutivos de Atención al Cliente Seguros Presencial'];
        u2 = new User(Alias = 'newUs', Email='newuser@testorg.com',
                      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                      LocaleSidKey='en_US', ProfileId = p.Id,
                      TimeZoneSidKey='America/Los_Angeles', UserName='testdsafas@testorg.com');
        //}
        
        //System.runAs(u2) {
        System.debug('Current User: ' + UserInfo.getUserName());
        System.debug('Current Profile: ' + UserInfo.getProfileId());
        
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        sc.tmpMdt = new Arbol_Familias_Tipos_Seguros__mdt();
        sc.mdt = new Arbol_Familias_Tipos_Seguros__mdt();
        //sc.arrayCampos = new List<ListasSeleccionSeguros__mdt>();
        sc.selectedBancoLabel = 'BANCO DE CHILE';
        
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Modificación de Póliza';
        sc.validaSeccion();
        sc.nuevoCaso.Tipo_de_Modificaci_n__c = 'Suspensión de Pagos';
        sc.validaSeccion();
        sc.nuevoCaso.V_a_de_Pago__c = '1';
        sc.FechaInicioSuspension = system.today();
        //sc.selectedBancos = '1';
        sc.NuevaPrimaProyectada = 3123;
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        sc.presencial = true;
        sc.remoto = false;
        sc.saveAndSee();
        
        //}
    }
    
    static testMethod void TestControlador_19() {
        
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Generales';
        pds.Familia__c = 'Seguro Vehículos';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        sc.tmpMdt = new Arbol_Familias_Tipos_Seguros__mdt();
        sc.mdt = new Arbol_Familias_Tipos_Seguros__mdt();
        //sc.arrayCampos = new List<ListasSeleccionSeguros__mdt>();
        sc.selectedBancoLabel = 'BANCO DE CHILE';
        
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Modificación de Póliza';
        sc.validaSeccion();
        sc.nuevoCaso.Tipo_de_Modificaci_n__c = 'Prima Proyectada';
        sc.validaSeccion();
        sc.nuevoCaso.V_a_de_Pago__c = '1';
        sc.FechaInicioSuspension = system.today();
        //sc.selectedBancos = '1';
        sc.NuevaPrimaProyectada = 123;
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        sc.presencial = true;
        sc.remoto = false;
        sc.saveAndSee();
        
        
    }
    static testMethod void TestControlador_19b() {
        
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Generales';
        pds.Familia__c = 'Seguro Vehículos';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        sc.tmpMdt = new Arbol_Familias_Tipos_Seguros__mdt();
        sc.mdt = new Arbol_Familias_Tipos_Seguros__mdt();
        //sc.arrayCampos = new List<ListasSeleccionSeguros__mdt>();
        sc.selectedBancoLabel = 'BANCO DE CHILE';
        
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Modificación de Póliza';
        sc.validaSeccion();
        sc.nuevoCaso.Tipo_de_Modificaci_n__c = 'Prima Proyectada';
        sc.validaSeccion();
        sc.nuevoCaso.V_a_de_Pago__c = '1';
        sc.FechaInicioSuspension = system.today();
        //sc.selectedBancos = '1';
        sc.NuevaPrimaProyectada = 123;
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        sc.presencial = false;
        sc.remoto = true;
        sc.saveAndSee();
        
        
    }
    static testMethod void TestControlador_20() {
        
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Generales';
        pds.Familia__c = 'Seguro Vehículos';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        sc.tmpMdt = new Arbol_Familias_Tipos_Seguros__mdt();
        sc.mdt = new Arbol_Familias_Tipos_Seguros__mdt();
        //sc.arrayCampos = new List<ListasSeleccionSeguros__mdt>();
        sc.selectedBancoLabel = 'BANCO DE CHILE';
        
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Modificación de Póliza';
        sc.validaSeccion();
        sc.nuevoCaso.Tipo_de_Modificaci_n__c = 'Prima Proyectada';
        sc.validaSeccion();
        sc.nuevoCaso.V_a_de_Pago__c = '1';
        sc.FechaInicioSuspension = system.today();
        //sc.selectedBancos = '1';
        sc.NuevaPrimaProyectada = 2123;
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        sc.presencial = true;
        sc.remoto = false;
        sc.saveAndSee();
        
        CONS_estructuratoken token = new CONS_estructuratoken();
        token.token_usuario();
    }
    
    
    static testMethod void TestControlador_21() {
        
        User u2;
        Account  acc;
        Producto_de_Seguros__c pds;
        Producto_del_Cliente__c pc;
        
        User usuarioActual = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        
        //System.runAs(usuarioActual){
        
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Generales';
        pds.Familia__c = 'Seguro Vehículos';
        insert pds;
        
        pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Ejecutivos de Atención al Cliente Seguros Presencial'];
        u2 = new User(Alias = 'newUs', Email='newuser@testorg.com',
                      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                      LocaleSidKey='en_US', ProfileId = p.Id,
                      TimeZoneSidKey='America/Los_Angeles', UserName='testdsafas@testorg.com');
        //}
        
        //System.runAs(u2) {
        System.debug('Current User: ' + UserInfo.getUserName());
        System.debug('Current Profile: ' + UserInfo.getProfileId());
        
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        sc.tmpMdt = new Arbol_Familias_Tipos_Seguros__mdt();
        sc.mdt = new Arbol_Familias_Tipos_Seguros__mdt();
        //sc.arrayCampos = new List<ListasSeleccionSeguros__mdt>();
        sc.selectedBancoLabel = 'BANCO DE CHILE';
        
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Modificación de Póliza';
        sc.validaSeccion();
        sc.nuevoCaso.Tipo_de_Modificaci_n__c = 'Prima Proyectada';
        sc.validaSeccion();
        sc.nuevoCaso.V_a_de_Pago__c = '1';
        sc.FechaInicioSuspension = system.today();
        //sc.selectedBancos = '1';
        sc.NuevaPrimaProyectada = 123;
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        sc.presencial = true;
        sc.remoto = false;
        sc.saveAndSee();
        
        //}
    }
    static testMethod void TestControlador_22() {
        
        User u2;
        Account  acc;
        Producto_de_Seguros__c pds;
        Producto_del_Cliente__c pc;
        
        User usuarioActual = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        
        //System.runAs(usuarioActual){
        
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Generales';
        pds.Familia__c = 'Seguro Vehículos';
        insert pds;
        
        pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Ejecutivos de Atención al Cliente Seguros Presencial'];
        u2 = new User(Alias = 'newUs', Email='newuser@testorg.com',
                      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                      LocaleSidKey='en_US', ProfileId = p.Id,
                      TimeZoneSidKey='America/Los_Angeles', UserName='testdsafas@testorg.com');
        //}
        
        //System.runAs(u2) {
        System.debug('Current User: ' + UserInfo.getUserName());
        System.debug('Current Profile: ' + UserInfo.getProfileId());
        
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        sc.tmpMdt = new Arbol_Familias_Tipos_Seguros__mdt();
        sc.mdt = new Arbol_Familias_Tipos_Seguros__mdt();
        //sc.arrayCampos = new List<ListasSeleccionSeguros__mdt>();
        sc.selectedBancoLabel = 'BANCO DE CHILE';
        
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Modificación de Póliza';
        sc.validaSeccion();
        sc.nuevoCaso.Tipo_de_Modificaci_n__c = 'Asignación Apoderado';
        sc.validaSeccion();
        sc.nuevoCaso.V_a_de_Pago__c = '1';
        sc.FechaInicioSuspension = system.today();
        //sc.selectedBancos = '1';
        sc.NuevaPrimaProyectada = 123;
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        sc.presencial = true;
        sc.remoto = false;
        sc.saveAndSee();
        
        //}
    }
    
    
    static testMethod void TestControlador_23() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Generales';
        pds.Familia__c = 'Seguro Vehículos';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Rescate';
        sc.validaSeccion();
        sc.nuevoCaso.Tipo_de_Modificaci_n__c = 'Regimen Tributario';
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        //cas.SlaStartDate=System.now(); 
        sc.saveAndClose();
        
    }
    
    static testMethod void TestControlador_24() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Generales';
        pds.Familia__c = 'Seguro Vehículos';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        sc.TotalUF=20;
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Rescate';
        sc.validaSeccion();
        sc.nuevoCaso.Tipo_de_Modificaci_n__c = 'Regimen Tributario';
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        //cas.SlaStartDate=System.now(); 
        sc.saveAndClose();
        
    }
    
    static testMethod void TestControlador_25() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Generales';
        pds.Familia__c = 'Seguro Vehículos';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        sc.TotalUF=20;
        sc.NoCtaTarjeta=23232323;
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Rescate';
        sc.validaSeccion();
        sc.nuevoCaso.Tipo_de_Modificaci_n__c = 'Regimen Tributario';
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        //cas.SlaStartDate=System.now(); 
        sc.saveAndClose();
        
    }
    
    static testMethod void TestControlador_26() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Generales';
        pds.Familia__c = 'Seguro Vehículos';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        sc.TotalUF=20;
        sc.NoCtaTarjeta=2323232;
        sc.MontoMaximo=20;
        sc.nuevoCaso.Fecha_Real_Solicitud_solicitud_rescates__c=system.today();
        sc.nuevoCaso.Monto_UF__c=21;
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Rescate';
        sc.validaSeccion();
        sc.nuevoCaso.Tipo_de_Modificaci_n__c = 'Regimen Tributario';
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        //cas.SlaStartDate=System.now(); 
        sc.saveAndClose();
        
    }
    
     static testMethod void TestControlador_27() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Generales';
        pds.Familia__c = 'Seguro Vehículos';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        sc.TotalUF=20;
        sc.MontoMaximo=20;
        sc.nuevoCaso.Fecha_Real_Solicitud_solicitud_rescates__c=system.today();
        sc.nuevoCaso.Monto_UF__c=21;
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Rescate';
        sc.validaSeccion();
        sc.nuevoCaso.Tipo_de_Modificaci_n__c = 'Regimen Tributario';
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        //cas.SlaStartDate=System.now(); 
        sc.saveAndClose();
        
    }
    
     static testMethod void TestControlador_28() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Generales';
        pds.Familia__c = 'Seguro Vehículos';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        sc.TotalUF=20;
        
        sc.nuevoCaso.Fecha_Real_Solicitud_solicitud_rescates__c=system.today();
        sc.nuevoCaso.Monto_UF__c=30;
        sc.MontoMaximo=20;
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Rescate';
        sc.validaSeccion();
        sc.nuevoCaso.Tipo_de_Modificaci_n__c = 'Regimen Tributario';
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        //cas.SlaStartDate=System.now(); 
        sc.saveAndClose();
        
    }
    
    
    static testMethod void TestControlador_29() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Vida';
        pds.Familia__c = 'APV';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Rescate';
        sc.nuevoCaso.Fecha_Real_Solicitud_solicitud_rescates__c=system.today();
        sc.NoCtaTarjeta=1234542;
        sc.MontoPesoCotizacionA=2000;
        sc.MontoPesoCotizacionB=2000;
        sc.MontoPesoDepositoA=2000;
        sc.MontoPesoDepositoB=2000;
        sc.MontoPesoCotizacionBMayor=2000;
        sc.validaSeccion();
        sc.nuevoCaso.Tipo_de_Modificaci_n__c = 'Regimen Tributario';
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        //cas.SlaStartDate=System.now(); 
        sc.saveAndClose();
        
    }
    
     static testMethod void TestControlador_29z() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Vida';
        pds.Familia__c = 'APV';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Rescate';
        sc.nuevoCaso.Fecha_Real_Solicitud_solicitud_rescates__c=system.today();
        sc.NoCtaTarjeta=12345672;
        sc.MontoPesoCotizacionA=2000;
        sc.MontoPesoCotizacionB=2000;
        sc.MontoPesoDepositoA=2000;
        sc.MontoPesoDepositoB=2000;
        sc.MontoPesoCotizacionBMayor=2000;
        sc.MontoPesoDepositoBMayor=2000;
        sc.validaSeccion();
        sc.nuevoCaso.Tipo_de_Modificaci_n__c = 'Regimen Tributario';
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        //cas.SlaStartDate=System.now(); 
        sc.saveAndClose();
        
    }
    
    
    static testMethod void TestControlador_29B() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Vida';
        pds.Familia__c = 'APV';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Rescate';
        sc.nuevoCaso.Fecha_Real_Solicitud_solicitud_rescates__c=system.today();
        sc.NoCtaTarjeta=1238765;
        sc.MontoPesoCotizacionB=2000;
        sc.MontoPesoDepositoA=2000;
        sc.MontoPesoDepositoB=2000;
        sc.MontoPesoCotizacionBMayor=2000;
        sc.validaSeccion();
        sc.nuevoCaso.Tipo_de_Modificaci_n__c = 'Regimen Tributario';
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        //cas.SlaStartDate=System.now(); 
        sc.saveAndClose();
        
    }
    
    
    
     static testMethod void TestControlador_29C() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Vida';
        pds.Familia__c = 'APV';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Rescate';
        sc.nuevoCaso.Fecha_Real_Solicitud_solicitud_rescates__c=system.today();
        sc.NoCtaTarjeta=7743282;
        sc.MontoPesoCotizacionA=2000;
        sc.MontoPesoDepositoA=2000;
        sc.MontoPesoDepositoB=2000;
        sc.MontoPesoCotizacionBMayor=2000;
        sc.validaSeccion();
        sc.nuevoCaso.Tipo_de_Modificaci_n__c = 'Regimen Tributario';
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        //cas.SlaStartDate=System.now(); 
        sc.saveAndClose();
        
    }
    
    static testMethod void TestControlador_29x() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Vida';
        pds.Familia__c = 'APV';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Rescate';
        sc.nuevoCaso.Fecha_Real_Solicitud_solicitud_rescates__c=system.today();
        sc.NoCtaTarjeta=8971241;
        sc.MontoPesoCotizacionA=2000;
        sc.MontoPesoCotizacionB=2000;
        sc.MontoPesoDepositoB=2000;
        sc.MontoPesoCotizacionBMayor=2000;
        sc.validaSeccion();
        sc.nuevoCaso.Tipo_de_Modificaci_n__c = 'Regimen Tributario';
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        //cas.SlaStartDate=System.now(); 
        sc.saveAndClose();
        
    }
    
    
    static testMethod void TestControlador_29l() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Vida';
        pds.Familia__c = 'APV';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Rescate';
        sc.nuevoCaso.Fecha_Real_Solicitud_solicitud_rescates__c=system.today();
        sc.NoCtaTarjeta=732197;
        sc.MontoPesoCotizacionA=2000;
        sc.MontoPesoCotizacionB=2000;
        sc.MontoPesoDepositoA=2000;
        sc.MontoPesoCotizacionBMayor=2000;
        sc.validaSeccion();
        sc.nuevoCaso.Tipo_de_Modificaci_n__c = 'Regimen Tributario';
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        //cas.SlaStartDate=System.now(); 
        sc.saveAndClose();
        
    }
    
    static testMethod void TestControlador_29e() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Vida';
        pds.Familia__c = 'APV';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Rescate';
        sc.nuevoCaso.Fecha_Real_Solicitud_solicitud_rescates__c=system.today();
        sc.NoCtaTarjeta=764327;
        sc.MontoPesoCotizacionA=2000;
        sc.MontoPesoCotizacionB=2000;
        sc.MontoPesoDepositoA=2000;
        sc.MontoPesoDepositoB=2000;
        sc.validaSeccion();
        sc.nuevoCaso.Tipo_de_Modificaci_n__c = 'Regimen Tributario';
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        //cas.SlaStartDate=System.now(); 
        sc.saveAndClose();
        
    }
    
    
     static testMethod void TestControlador_29p() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Vida';
        pds.Familia__c = 'APV';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Rescate';
        sc.nuevoCaso.Fecha_Real_Solicitud_solicitud_rescates__c=system.today();
        sc.NoCtaTarjeta=908129;
        sc.MontoPesoCotizacionA=0;
        sc.MontoPesoCotizacionB=0;
        sc.MontoPesoDepositoA=0;
        sc.MontoPesoDepositoB=0;
        sc.validaSeccion();
        sc.nuevoCaso.Tipo_de_Modificaci_n__c = 'Regimen Tributario';
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        //cas.SlaStartDate=System.now(); 
        sc.saveAndClose();
        
    }
    static testMethod void TestControlador_29g() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Vida';
        pds.Familia__c = 'APV';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Rescate';
        sc.nuevoCaso.Fecha_Real_Solicitud_solicitud_rescates__c=system.today();
        sc.MontoPesoCotizacionA=2000;
        sc.MontoPesoCotizacionB=2000;
        sc.MontoPesoDepositoA=2000;
        sc.MontoPesoDepositoB=2000;
        sc.MontoPesoCotizacionBMayor=2000;
        sc.validaSeccion();
        sc.nuevoCaso.Tipo_de_Modificaci_n__c = 'Regimen Tributario';
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        //cas.SlaStartDate=System.now(); 
        sc.saveAndClose();
        
    }
    
    static testMethod void TestControlador_29f() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Vida';
        pds.Familia__c = 'APV';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Rescate';
        sc.NoCtaTarjeta=674129;
        sc.MontoPesoCotizacionA=2000;
        sc.MontoPesoCotizacionB=2000;
        sc.MontoPesoDepositoA=2000;
        sc.MontoPesoDepositoB=2000;
        sc.MontoPesoCotizacionBMayor=2000;
        sc.validaSeccion();
        sc.nuevoCaso.Tipo_de_Modificaci_n__c = 'Regimen Tributario';
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        //cas.SlaStartDate=System.now(); 
        sc.saveAndClose();
        
    }
    static testMethod void TestControlador_30() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Generales';
        pds.Familia__c = 'APV';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        sc.tipoDoc = true;
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Rescate';
        sc.MontoPesoCotizacionB=20000;
        sc.MontoPesoDepositoA=2000;
        sc.MontoPesoDepositoB=2000;
        sc.MontoPesoCotizacionBMayor=2000;
        sc.MontoPesoDepositoBMayor=2000;
        sc.validaSeccion();
        sc.NoCtaTarjeta=321687;
        sc.nuevoCaso.Fecha_Real_Solicitud_solicitud_rescates__c=system.today();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        sc.saveAndSee();
    }
    
     static testMethod void TestControlador_31() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Generales';
        pds.Familia__c = 'Seguro Vehículos';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        sc.NoCtaTarjeta=981308;
        sc.NombreTerceroAfectado='asdasd';
        sc.RutTerceroAfectado='11111111-1';
        sc.NoDeclaracionBeneficiarios=1;
        sc.NuevoPlan='SDA';
        sc.Fumador=TRUE;
        sc.selectedRegimenSII='1';
        sc.selectedFormaEnvio='1';
        sc.NombreApoderado='asd';
        sc.ApellidoPatApoderado='asd';
        sc.ApellidoMatApoderado='asd';
        sc.NoPropuesta=2000;
        sc.NuevaPrima='asd';
        sc.Deducible='asd';
        sc.NuevaCobertura='asd';
        sc.RutServipag='asd';
        sc.NombreServipag='asd';
        sc.ApellidoPatServipag='asd';
        sc.MesInicio='asd';
        sc.MesFin='asd';
        sc.RutNuevoBeneficiario='asd';
        sc.NombreNuevoBeneficiario='asd';
        sc.ApellidoPatNuevoBeneficiario='asd';
        
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Modificación de Póliza';
        sc.validaSeccion();
        sc.nuevoCaso.Tipo_de_Modificaci_n__c = 'Vía de Pago';
        sc.validaSeccion();
        sc.nuevoCaso.V_a_de_Pago__c = '3';
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        sc.saveAndSee();
        PageReference c = sc.cerrar();
        //cas.SlaStartDate=System.now(); 
        
    }
    
    
    static testMethod void TestControlador_34() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Generales';
        pds.Familia__c = 'APV';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        sc.tipoDoc = true;
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Fecha_Real_Solicitud_solicitud_rescates__c=system.today();
        sc.NoCtaTarjeta=213718;
        sc.MontoPesoCotizacionA=29999;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Rescate';
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        sc.saveAndSee();
    }
    
    static testMethod void TestControlador_35() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Generales';
        pds.Familia__c = 'APV';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        sc.tipoDoc = true;
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.NoCtaTarjeta=987321;
        sc.MontoPesoCotizacionA=0;
        sc.MontoPesoCotizacionAUF=50000;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Rescate';
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        sc.saveAndSee();
    }
    
    
     static testMethod void TestControlador_36() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Generales';
        pds.Familia__c = 'APV';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        sc.tipoDoc = true;
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.NoCtaTarjeta=897312;
        sc.MontoPesoCotizacionB=29999;
        sc.MontoPesoCotizacionBUF=50000;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Rescate';
        sc.validaSeccion();
        sc.nuevoCaso.Priority='alta';
        sc.nuevoCaso.Origin='web';
        sc.nuevoCaso.Description='problemas de clave de acceso';
        sc.nuevoCaso.Subject='reclamo';
        sc.saveAndSee();
    }
    
    static testMethod void TestControlador_37() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='APV FONDO EXPERTO';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c = 'Vida';
        pds.Familia__c = 'APV';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='APV FONDO EXPERTO';
        pc.Esquema_Nectia__c='INSUDB';
        pc.Id__c='12345678901';
        pc.Codigo_Plan_Nectia__c='650';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Crear_Caso_Producto_Seguros'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_NewCaseProductoSeguros_Controller sc=new CONS_NewCaseProductoSeguros_Controller(astc);
        sc.seccion = 'test';
        sc.subseccion_1 = 'test';
        sc.subseccion_2 = 'test';
        sc.subseccion_3 = 'test';
        sc.tmpMdt = new Arbol_Familias_Tipos_Seguros__mdt();
        sc.mdt = new Arbol_Familias_Tipos_Seguros__mdt();
        //sc.arrayCampos = new List<ListasSeleccionSeguros__mdt>();
        sc.selectedBancoLabel = 'BANCO DE CHILE';
        
        sc.nuevoCaso.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        sc.nuevoCaso.Accountid=acc.id;
        sc.nuevoCaso.Status='Nuevo';
        sc.nuevoCaso.Type='Solicitud';
        sc.nuevoCaso.Subtipo__c='Rescate';
        sc.nuevoCaso.Tipo_Rescate__c='2';
        
        sc.validaSeccion();
        
        sc.MontoPesoCotizacionA=12;
        sc.MontoPesoCotizacionB=12;
        sc.MontoPesoDepositoA=123;
        sc.MontoPesoDepositoB=123;
        sc.MontoPesoDepositoBMayor=123;
        sc.MontoPesoCotizacionBMayor=123;
        sc.MontoPesoCotizacionAUF=1234;
        sc.MontoUFDepositoA=123;
        sc.saveAndSee();
        sc.MontoPesoCotizacionAUF=null;
        sc.MontoUFDepositoA=null;
        sc.MontoPesoCotizacionBUF=1234;
        sc.MontoUFDepositoB=123;
        sc.saveAndSee();
        sc.MontoPesoCotizacionAUF=null;
        sc.MontoUFDepositoA=null;
        sc.MontoPesoCotizacionBUF=null;
        sc.MontoUFDepositoB=null;
        sc.MontoPesoDepositoAUF=1234;
        sc.MontoUFDepositoAPVA=123;
        sc.saveAndSee();
        sc.MontoPesoCotizacionAUF=null;
        sc.MontoUFDepositoA=null;
        sc.MontoPesoCotizacionBUF=null;
        sc.MontoUFDepositoB=null;
        sc.MontoPesoDepositoAUF=null;
        sc.MontoUFDepositoAPVA=null;
        sc.MontoPesoDepositoBUF=1234;
        sc.MontoUFDepositoAPVB=123;
        sc.saveAndSee();
        sc.MontoPesoCotizacionAUF=null;
        sc.MontoUFDepositoA=null;
        sc.MontoPesoCotizacionBUF=null;
        sc.MontoUFDepositoB=null;
        sc.MontoPesoDepositoAUF=null;
        sc.MontoUFDepositoAPVA=null;
        sc.MontoPesoDepositoBUF=null;
        sc.MontoUFDepositoAPVB=null;
        sc.MontoPesoCotizacionBUFMayor=1234;
        sc.MontoUFDepositoBMayor=123;
        sc.saveAndSee();
        sc.MontoPesoCotizacionAUF=null;
        sc.MontoUFDepositoA=null;
        sc.MontoPesoCotizacionBUF=null;
        sc.MontoUFDepositoB=null;
        sc.MontoPesoDepositoAUF=null;
        sc.MontoUFDepositoAPVA=null;
        sc.MontoPesoDepositoBUF=null;
        sc.MontoUFDepositoAPVB=null;
        sc.MontoPesoCotizacionBUFMayor=null;
        sc.MontoUFDepositoBMayor=null;
        sc.MontoPesoDepositoBUFMayor=1234;
        sc.MontoUFDepositoAPVBMayor=123;
        sc.saveAndSee();
        sc.MontoPesoCotizacionAUF=null;
        sc.MontoUFDepositoA=null;
        sc.MontoPesoCotizacionBUF=null;
        sc.MontoUFDepositoB=null;
        sc.MontoPesoDepositoAUF=null;
        sc.MontoUFDepositoAPVA=null;
        sc.MontoPesoDepositoBUF=null;
        sc.MontoUFDepositoAPVB=null;
        sc.MontoPesoCotizacionBUFMayor=null;
        sc.MontoUFDepositoBMayor=null;
        sc.MontoPesoDepositoBUFMayor=null;
        sc.MontoUFDepositoAPVBMayor=null;
        sc.presencial = false;
        sc.remoto = true;
        sc.saveAndSee();
        
        string str='<?xml version="1.0" encoding="UTF-8"?><S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><ns2:getUfResponse xmlns:ns2="http://ws.wsrescatevida.cnsv.cl/"><return><err_code>0</err_code><ufVal><ufVal>27602.45</ufVal></ufVal></return></ns2:getUfResponse></S:Body></S:Envelope>';
        DOM.Document doc = new DOM.Document();
        doc.load(str);  
        DOM.XMLNode node=doc.getRootElement();
        sc.parseXML(node);
    }
    
}