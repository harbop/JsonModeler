JsonModeller is a simple category that will allow you to automatically populate Data Model Objects (DMO) from JSON.  You can create and initialize 
an object using code as simple as Customer *customer = [[Customer alloc] initWithJSON:json]

To serialize back to JSON, you simply use NSString *newJson = [customer toJSON];

To define a DMO, you simply create a subclass of NSObject and define the properties.  The properties are then used to try to pull data from a parsed JSON dictionary (or array) by name and type.  The category defines a few methods to override the default naming: inputKeyForPropertyNamed and outputKeyForPropertyNamed.

When the deserializer encounters and array, it will need to know they type of the objects in the array.  This is accomplished by overriding (Class) typeOfArrayNamed:(NSString *)arrayName on your DMO.

More to come soon.

