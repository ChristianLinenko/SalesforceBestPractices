### Installation Instructions
1. Clone the repository onto your machine.
2. Take the contents of the Frameworks/Test Data Factory and deploy them to the Salesforce environment of your choosing.
3. Update TestDataFactoryTest.testObjectCreationByRecordType() to reference a record type in your org.
4. Update TestDataFactoryTest.testObjectCreationWithFieldMap() to reference a custom field in your org.

### Extending the Framework
1. Create new classes called with the _TDG in the name that implement TestDataGenerator (TDG).
2. Only create 1 TDG per object.
3. Add the line to TestDataFactory.getGenerator() to call the new TDG.
