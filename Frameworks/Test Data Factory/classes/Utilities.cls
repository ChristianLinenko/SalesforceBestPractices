public without sharing class Utilities {

    private static Map<String, RecordType> mapRecordTypesByDeveloperNameCache;
    private static Map<String,Map<String,RecordType>> recordTypesMapByDeveloperNameByObject;
    private static Map<String,Map<String,RecordType>> recordTypesMapByNameByObject;
    private static List<RecordType> allRecordTypes;
    private static Map<String, List<RecordType>> recordTypesListByObject;
    private static Map<String, Map<String, Schema.RecordTypeInfo>> objectRecordTypeInfoMap;

    /**
    * This method returns the record type Id given the object name and record
    * type label.
    *
    * @param objectName         The API Name for the object you're wanting
    *                           to retrieve the record types for
    *
    * @param recordTypeLabel    The record type label you're wanting the Id for
    *
    * @return                   Returns the Record Type Id for the provided
    *                           Object API Name and Record Type Label.
    */
    public static Id getRecordTypeIdByLabel(String objectName, String recordTypeLabel) {

        Map<String, Schema.RecordTypeInfo> recordTypeMap = getObjectRecordTypeInfo(objectName);

        if (recordTypeMap != NULL && recordTypeMap.containsKey(recordTypeLabel)) {
            return recordTypeMap.get(recordTypeLabel).getRecordTypeId();
        }
        else {
            return NULL;
        }
    }

    /**
    * This method returns the record type info for a single object. If the object
    * does not exist, this will return NULL.
    *
    * @param objectName       This is the API Name for the object you're wanting
    *                         to retrieve the record type info for.
    *
    * @return                 Returns a map with the record type info by name, so
    *                         you can retreive the record type Id by passing the
    *                         record type label to the returned map.
    */
    public static Map<String, Schema.RecordTypeInfo> getObjectRecordTypeInfo(String objectName) {

        if (objectRecordTypeInfoMap == NULL) {
            objectRecordTypeInfoMap = new Map<String, Map<String, Schema.RecordTypeInfo>>();
        }

        if (!objectRecordTypeInfoMap.containsKey(objectName) && Schema.getGlobalDescribe().containsKey(objectName)) {
            objectRecordTypeInfoMap.put(objectName, Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosByName());
        }

        if (objectRecordTypeInfoMap.containsKey(objectName)) {
            return objectRecordTypeInfoMap.get(objectName);
        }
        else {
            return NULL;
        }
    }

    public static Map<String,RecordType> getRecordTypesMap(String objectName, Boolean useDeveloperName) {

        String rtypeSObject;

        if(useDeveloperName) {
            return GetRecordTypesMapByDeveloperNameByObject().get(objectName);
        }
        else {
            return GetRecordTypesMapByNameByObject().get(objectName);
        }
    }

    private static Map<String, Map<String, RecordType>> GetRecordTypesMapByNameByObject() {
        LoadAllRecordTypesList();
        if (recordTypesMapByNameByObject == null) {
            recordTypesMapByNameByObject = new Map<String,Map<String,RecordType>>();
            for (RecordType rtype :allRecordTypes) {
                if (recordTypesMapByNameByObject.get(string.ValueOf(rtype.SobjectType)) == null) {
                    //object not in the structure
                    recordTypesMapByNameByObject.put(string.ValueOf(rtype.SobjectType), new Map <String, RecordType>());
                }
                recordTypesMapByNameByObject.get(string.ValueOf(rtype.SobjectType)).put(rtype.Name, rtype);
            }
        }
        return recordTypesMapByNameByObject;
    }

    private static void LoadAllRecordTypesList()
    {
        if(allRecordTypes == null || allRecordTypes.isEmpty()) {
            allRecordTypes = [SELECT Id, DeveloperName, Name ,SobjectType,
                                     IsActive, Description, BusinessProcessId,
                                     NameSpacePrefix
                              FROM RecordType
                              ORDER BY SobjectType, Name];
      }
    }

    private static Map <String, Map <String, RecordType>> GetRecordTypesMapByDeveloperNameByObject() {
        String rtypeSObject;
        LoadAllRecordTypesList();
        if (recordTypesMapByDeveloperNameByObject == null) {
            recordTypesMapByDeveloperNameByObject = new Map <String , Map <String , RecordType >>();
            for (RecordType rtype :allRecordTypes) {
                if(recordTypesMapByDeveloperNameByObject.get(string.ValueOf(rtype.SobjectType)) == null) {//object not in the structure
                    recordTypesMapByDeveloperNameByObject.put(string.ValueOf(rtype.SobjectType), new Map<String, RecordType>());
                }
                recordTypesMapByDeveloperNameByObject.get(string.ValueOf(rtype.SobjectType)).put(rtype.DeveloperName, rtype);
            }
        }
        return recordTypesMapByDeveloperNameByObject;
    }

    /**
    * This method returns a list of the record types for the given object.
    *
    * @param objectName         The API Name of the object you're wanting the
    *                           record types for.
    *
    * @return                   Returns a list of the record types for the object
    */
    public static List<RecordType> getRecordTypesList(String objectName) {
        LoadAllRecordTypesList();

        if (recordTypesListByObject == NULL) {
            recordTypesListByObject = new Map<String, List<RecordType>>();

            for (RecordType rt: allRecordTypes) {
                if (!recordTypesListByObject.containsKey(rt.SobjectType)) recordTypesListByObject.put(rt.SobjectType, new List<RecordType>());

                recordTypesListByObject.get(rt.SobjectType).add(rt);
            }
        }

        if (recordTypesListByObject.containsKey(objectName)) {
            return recordTypesListByObject.get(objectName);
        }
        else {
            return NULL;
        }
    }

    public static Map<Id,RecordType> RecordTypeMapIdToRecordType(String objectName) {

        Map<Id,RecordType> recordTypeByIdMap = new Map<Id,RecordType>();

        for(RecordType rt :GetRecordTypesMapByDeveloperNameByObject().get(objectName).values()) {
          recordTypeByIdMap.put(rt.Id, rt);
        }
        return recordTypeByIdMap;
    }

    /**
    * Returns a map containing all record types in this instance of SFDC, with
    * the key being the record type developer name.
    *
    * @return       Returns the map of all the record types in this instance of
    *               Salesforce, which can be retrieved by the record type
    *               developer name.
    */
    public static Map<String, RecordType> getRecordTypes() {
        LoadAllRecordTypesList();

        if (mapRecordTypesByDeveloperNameCache == NULL) {
            mapRecordTypesByDeveloperNameCache = new Map<String, RecordType>();

            for (RecordType rt: allRecordTypes) {
                mapRecordTypesByDeveloperNameCache.put(rt.DeveloperName, rt);
            }
        }

        return mapRecordTypesByDeveloperNameCache;
    }

    /**
    * Returns the Id for a record type given the Record Type Developer Name.
    *
    * @param developerName    The Record Type Developer Name
    *
    * @return                 Returns the Id for the record type given the
    *                         provided developer name.
    */
    public static Id recordTypeIdByDeveloperName(String developerName) {
        Map<String, RecordType> recordTypeMap = getRecordTypes();

        if (recordTypeMap.containsKey(developerName)) {
            return recordTypeMap.get(developerName).Id;
        }
        else {
            return NULL;
        }
  }

    public static List<Sobject> combineSortLists(List<List<Sobject>> lists, String sortField, String uniqueField) {
        List<Sobject> combineSortList = new List<Sobject>();
        Set<Sobject> uniqueSet = new Set<Sobject>();
        Set<String> uniqueStringSet = new Set<String>();
        // combine lists into one unique set
        for (List<Sobject> li : lists) {
            for (SObject lo:li) {
                String uniqueId = (String)lo.get(uniqueField);
                if (!uniqueStringSet.contains(uniqueId)) {
                    uniqueSet.add(lo);
                    uniqueStringSet.add(uniqueId);
                }
            }
        }
        // Create map of key value pair for sorting using the sort field CONCATENATED with the unique field
        // to ensure that we retrieve the one and only one matching record in our final list
        Map<String, Sobject> sortMap = new Map<String, Sobject>();
        for(Sobject so : uniqueSet) {
            sortMap.put((String)so.get(sortField) + (String)so.get(uniqueField), so);
        }
        // sort list by sortfield
        List<String> sortList = new List<String>(sortMap.keySet());
        sortList.sort();

        for(String s : sortList) {
            Sobject so = (Sobject)sortMap.get(s);
            combineSortList.add(so);
            sortMap.remove(s);
        }

        return combineSortList;
    }

    public static RecordType GetRecordTypeByDeveloperName(String developerName)
    {
        LoadAllRecordTypesList();
        RecordType returnType = new RecordType();

        Map<String,RecordType> rtMap = new Map<String,RecordType>();
        for (RecordType rtype : allRecordTypes) {
        rtMap.put(rtype.DeveloperName,rtype);
        }

        if(rtMap.get(developerName) != null) {
            return rtMap.get(developerName);
        }
        return returnType;
    }

    public static RecordType GetRecordTypeByDeveloperName(String developerName, String objType)
    {
        return getRecordTypesMap(objType,true).get(developerName);

    }

    public static Set<Id> getRecordTypeIdsFromList(Set<String> developerNames, String objType)
    {
      Set<Id> recordTypeIds = new Set<Id>();
      for(String s: getRecordTypesMap(objType,true).keySet())
      {
        if(developerNames.contains(s))
          recordTypeIds.add(getRecordTypesMap(objType,true).get(s).Id);
      }
      return recordTypeIds;
    }

    public static Map<String, RecordType> GetRecordTypesByObjectType(String objType)
    {
        return getRecordTypesMap(objType,false);
    }
}
