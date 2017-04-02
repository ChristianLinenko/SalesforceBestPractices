public with sharing class TriggerFactory {
    /**  
  * Class TriggerFactory  
  * Used to instantiate and execute Trigger Handlers associated with sObjects.  
 */

    //If we want to create/update objects in Test classes, we can use this flag to insert the core records without logic running on them, 
    //then change the flag back
    private static Map <String , Trigger_Overrides__c >triggerOverrides = new Map <String , Trigger_Overrides__c >();
    public static boolean bypassTrigger = false;
    private static String sObjectName;
    public static void createHandler() {
       // Get the sObjectName we are working with
        sObjectName = ObjectName(trigger.new , trigger.old);
        //check to see if trigger(s) have been disabled via the Trigger Overrides custom setting
        TriggerOverridesSelector tos = new TriggerOverridesSelector();
        bypassTrigger = tos.bypassTrigger(sObjectName);
        System.debug('bypassTrigger: ' + bypassTrigger);
        if (!bypassTrigger) {
            //[SC]
            // Get a handler appropriate to the object being processed  
            ITrigger handler = getHandler(Trigger.old, Trigger.new );
            //[SC]
            execute(handler);
            //System.debug('Executing Handler for object: '+ sObjectName);
        }
        else {
            //System.debug('NOT Executing Handler for object: '+ sObjectName);
        }
    }
    //private static method to control the execution of the handler  
    private static void execute(ITrigger handler) {
        if (Trigger.isBefore) {
            // Call the bulk before to handle any caching of data and enable bulkification 
            handler.BulkBefore();
            // Call the beforeDelete method of the handler
            if (Trigger.isDelete) {
                handler.OnBeforeDelete(Trigger.old, Trigger.oldMap);
            }
            // Call the beforeInsert method of the handler
            if (Trigger.isInsert) {
                handler.OnBeforeInsert(Trigger.new );
            }
            //Call the beforeUpdate method of the handler
            if (Trigger.isUpdate) {
                handler.OnBeforeUpdate(Trigger.old, Trigger.new , Trigger.oldMap, Trigger.newMap);
            }
        }
        else if (Trigger.isAfter) {
            // Call the bulk before to handle any caching of data and enable bulkification 
            handler.BulkAfter();
            // Call the afterDelete method of the handler
            if (Trigger.isDelete) {
                handler.OnAfterDelete(Trigger.old, Trigger.oldMap);
            }
            // Call the afterinsert method of the Handler
            if (Trigger.isInsert) {
                handler.OnAfterInsert(Trigger.new );
            }
            // call the afterUpdate method of the handler
            if (Trigger.isUpdate) {
                handler.OnAfterUpdate(Trigger.old, Trigger.new , Trigger.oldMap, Trigger.newMap);
            }
        }
        else if (Trigger.isUnDelete) {
            handler.OnUnDelete(Trigger.new );
        }
        //call the cleaup method
        handler.cleanUp();
    }
    @testVisible // For this to work on any trigger you create your handler class must be the object name
    // underscores removed with _TriggerHandler appended on the end of the name
    // Example:
    // Object Name: Account_Group__c
    // Handler class name: AccountGroup_TriggerHandler
    private static ITrigger getHandler(List<sObject> oldList, List<sObject> newList) {

        ITrigger handler = null;

        /* Truncate the sObject name to 25 characters because the max class length
         is 40 characters, and sObjectName + '_TriggerHandler' length = 40 if 
         the object name length is 25 or longer. */
        if (sObjectName != null && sObjectName.length() > 25) sObjectName = sObjectName.left(25);

        Type t = Type.forName(sObjectName + '_TriggerHandler');
        if (t == null) {
            //create instance of the default class
            t = Type.forName('TriggerFactoryHandlerBase');
        }
        handler = (ITrigger)t.newInstance();
        handler.setParameters(Trigger.isExecuting, Trigger.size);
        //System.debug('TriggerFactory-size: '+ Trigger.size);
        //System.debug('TriggerFactory-isExecuting: '+ Trigger.isExecuting);
        return handler;
    }

    private static String ObjectName(List<sObject> newObjectList, List<sObject> oldObjectList) {
        String objectName = '';
        if (newObjectList != null && newObjectList [0] != null) {
            objectName = newObjectList [0].getSObjectType().getDescribe().getName();
        }
        else {
            objectName = oldObjectList [0].getSObjectType().getDescribe().getName();
        }

        objectName = objectName.replaceAll('__c', '');
        objectName = objectName.replaceAll('_', '');

        return objectName;
    }
}