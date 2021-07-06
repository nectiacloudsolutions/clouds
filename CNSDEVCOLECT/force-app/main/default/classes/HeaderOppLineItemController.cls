public class HeaderOppLineItemController {
	@AuraEnabled
    public static List<String> getForm(Id recordId, String objectName, String fieldSetName) {
        List<String> strng = new List<String>();
        strng.addAll(getFields(recordId, objectName, fieldSetName));
        return strng;
    }
    
    private static List<String> getFields(Id recordId, String objectName, String fieldSetName) {
        Schema.SObjectType objectType = null;
        if (recordId != null) {
            objectType = recordId.getSobjectType();
        }
        else if (String.isNotBlank(objectName)) {
            objectType = Schema.getGlobalDescribe().get(objectName);
        }
        Schema.DescribeSObjectResult objectDescribe = objectType.getDescribe();
        Map<String, Schema.FieldSet> fieldSetMap = objectDescribe.fieldSets.getMap();
        Schema.FieldSet fieldSet = fieldSetMap.get(fieldSetName);
        List<Schema.FieldSetMember> fieldSetMembers = fieldSet.getFields();
        List<String> strng = new List<String>();
        for (Schema.FieldSetMember fsm : fieldSetMembers) {
            strng.add(fsm.getFieldPath());
        }
        return strng;
    }
}