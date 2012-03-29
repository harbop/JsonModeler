JsonModeller is a simple category that will allow you to automatically populate Data Model Objects (DMO) from JSON.  The current version will work correctly with CoreData objects as well.

To define a DMO, you simply create a subclass of NSObject and define the properties.  The properties are then used to try to pull data from a parsed JSON dictionary (or array) by name and type.  The category defines a few methods to override the default naming: inputKeyForPropertyNamed and outputKeyForPropertyNamed.

When the deserializer encounters and array, it will need to know they type of the objects in the array.  This is accomplished by overriding 

	-(Class) classForObjectsIn:(NSString *)collectionName

To create a Data Model Object (DMO) and initialize it from JSON, just call

	Customer *customer = [[Customer alloc] init];
	[customer fromJSON:jsonString];

To create JSON from a DMO:

	NSString *newJson = [customer toJSON];

Defining a DMO is the same as defining any standard object.  At the moment, it works with NSStrings, NSNumbers, NSArrays, NSMutableArrays, other DMOs and all native types (int, unsigned int, long, boolean, double, etc., etc.)   The category (NSObject+JSON) uses the property definitions to determine how to pull code from the parsed JSON dictionaries and arrays.  It also provides a couple of callback so that you map input and output JSON key names differently than the property names.  Just override these two methods on your DMO if  you want to do that:

	- (NSString *)inputKeyForPropertyNamed:(NSString *)name {
    		return name;
	}

	- (NSString *)outputKeyForPropertyNamed:(NSString *)name {
		return name;
	}

Lastly, because NSArrays are untyped (no generics), the category consults the DMO to determine how to create objects in arrays.  Basically, you just return the type of the objects in the array:

	-(Class) typeOfArrayNamed:(NSString *)arrayName {
    		Class c = nil;
    
    		if ([arrayName isEqualToString: @"accounts"]) {
        		c = [Account class];
    		}
    		else if ([arrayName isEqualToString: @"messages"]) {
        		c = [NSString class];
    		}
    		
    		return c;
	}

That's pretty much it.  Beyond that, DMOs are just defined as normal:

	@interface Customer : NSObject

	@property (strong, nonatomic) NSString *customProperty;
	@property (strong, nonatomic) NSString *accountHolder;
	@property (strong, nonatomic) NSArray *accounts;
	@property (strong, nonatomic) NSArray *messages;
	@property (strong, nonatomic) NSString *lastUpdated;

	@end


	@interface Account : NSObject
	
	@property(nonatomic, strong) NSString *name;
	@property(nonatomic, assign) int index;
	@property(nonatomic, assign) double balance;
	@property(nonatomic, assign, getter=isActive) bool active;
	@property(nonatomic, strong) Transaction *lastTransaction;
	
	@end
	
	@interface Transaction : NSObject
	
	@property(nonatomic, strong) NSString *amount;
	@property(nonatomic, strong) NSString *date;
	@property(nonatomic, strong) NSString *checkImage;
	
	@end


