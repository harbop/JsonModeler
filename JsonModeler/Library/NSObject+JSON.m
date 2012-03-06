//
//  NSObject+JSON.m
//
//
//  Created by Greg Pasquariello on 3/5/12.
//  Copyright (c) 2012 BiggerMind Software. All rights reserved.
//

#import "NSObject+JSON.h"
#import <objc/runtime.h>
#import "NSObject+Properties.h"

@implementation NSMutableArray (JSON)


-(id) initWithJSON:(NSString *)json ofClass:(Class)class {
    self = [self init];
    if (self != nil) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData: [json dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error:nil];
        [self fromArray:array ofClass:class];
    }
    return self;
}

-(id) initWithArray:(NSArray *)source ofClass:class {
    self = [self init];
    if (self != nil) {
        [self fromArray:source ofClass:class];
    }
    return self;
}


-(id) fromArray:(NSArray *)source ofClass:(Class)class {    
    if ([class isSubclassOfClass: [NSString class]]) {
        for (int i=0; i < [source count]; i++) {
            NSString *s = [source objectAtIndex: i];
            [self addObject: s];
        }  
    }
    else {
        for (int i=0; i < [source count]; i++) {
            NSDictionary *values = [source objectAtIndex: i];
            id obj = [[class alloc] initWithDictionary: values];
            [self addObject: obj];
        }
    }
    
    return self;
}

-(NSString *) toJSON {
    NSArray *array = [self toArray];
    NSData *data = [NSJSONSerialization dataWithJSONObject: array options: 0 error:nil];
    return [[NSString alloc] initWithData: data encoding: NSASCIIStringEncoding];
}

- (NSArray *)toArray { 
    NSMutableArray *newArray = [NSMutableArray arrayWithCapacity: [self count]];
    
    for(int i=0; i < [self count]; i++) {
        id object = [self objectAtIndex: i];
        
        if ([object isKindOfClass: [NSArray class]]) {
            NSArray *result = [object toArray];
            [newArray addObject: result];
        }
        else {
            //
            // In this case, we just got an array of strings or an array of numbers, not an array of
            // key/value pairs.
            //
            if ([object isKindOfClass: [NSString class]] || [object isKindOfClass: [NSNumber class]]) {
                [newArray addObject: object];
            }
            else {
                NSObject *result = [object toDictionary];
                [newArray addObject: result];
            }
        }
    }
    
    return newArray;
}


@end


@implementation NSObject (JSON)

-(id) initWithDictionary:(NSDictionary *)dictionary {
    self = [self init];
    if (self != nil) {
        [self fromDictionary: dictionary];
    }
    return self;
}

-(id) initWithJSON:(NSString *)json {
    self = [self init];
    
    if (self != nil) {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData: [json dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error:nil];
        
        [self fromDictionary: dict];
    }
    return self;
}


-(id) fromDictionary:(NSDictionary *)dictionary {    
    NSArray *names = [self propertyNames];
    for (int i=0; i < [names count]; i++) {
        NSString *pname = [names objectAtIndex: i];
        
        const char *ptype = [self typeOfPropertyNamed: pname];
        
        NSString *key = [self inputKeyForPropertyNamed: pname];
        if (key == nil) {
            key = pname;
        }
        
        id value = [dictionary objectForKey: key];
        
        if (value != [NSNull null]) {
            if (!strcmp(ptype, "T@\"NSString\"")) {
                [self setValue: [self valueToString: value] forKey: pname];
            } else if (!strcmp(ptype, "T@\"NSNumber\"")) {
                [self setValue: [self valueToNumber: value] forKey: pname];
            } else if (!strcmp(ptype, "T@\"NSArray\"")) {
                Class arrayClass = [self typeOfArrayNamed: pname];
                NSArray *array = [[NSMutableArray alloc] initWithArray: value ofClass: arrayClass];
                [self setValue: array forKey: pname];
            } else if (!strcmp(ptype, "T@\"NSMutableArray\"")) {
                Class arrayClass = [self typeOfArrayNamed: pname];
                NSArray *array = [[NSMutableArray alloc] initWithArray: value ofClass: arrayClass];
                [self setValue: array forKey: pname];
            } else if (!strcmp(ptype, "Ti")) {
                [self setValue: [self valueToNumber: value] forKey: pname];
            } else if (!strcmp(ptype, "TI")) {
                [self setValue: [self valueToNumber: value] forKey: pname];
            } else if (!strcmp(ptype, "Tl")) {
                [self setValue: [self valueToNumber: value] forKey: pname];        
            } else if (!strcmp(ptype, "TL")) {
                [self setValue: [self valueToNumber: value] forKey: pname];
            } else if (!strcmp(ptype, "Td")) {
                [self setValue: [self valueToNumber: value] forKey: pname];           
            } else if (!strcmp(ptype, "Tf")) {
                [self setValue: [self valueToNumber: value] forKey: pname];
            } else if (!strcmp(ptype, "TB")) {
                [self setValue: [self valueToNumber: value] forKey: pname];
            } else {
                NSString *className = [self classFromPropertyTypeString: [NSString stringWithUTF8String: ptype]];
                Class class = NSClassFromString(className);
                id object = [[[class alloc] init] fromDictionary: value];
                [self setValue:object forKey:pname];
            }
        }
    }
    
    return self;
}

-(NSString *) toJSON {
    NSMutableDictionary *dictionary = [self toDictionary];
    NSData *data = [NSJSONSerialization dataWithJSONObject: dictionary options: 0 error:nil];
    return [[NSString alloc] initWithData: data encoding: NSASCIIStringEncoding];
}

- (NSMutableDictionary *)toDictionary {    
    NSArray *pnames = [self propertyNames];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity: [pnames count]];
    
    for (int i=0; i < [pnames count]; i++) {
        NSString *pname = [pnames objectAtIndex: i];
        
        const char *ptype = [self typeOfPropertyNamed: pname];
        
        NSString *key = [self outputKeyForPropertyNamed: pname];
        if (key == nil) {
            key = pname;
        }
        
        if (!strcmp(ptype, "T@\"NSString\"")) {
            [dict setValue: [self valueForKey: pname] forKey: key];
        } else if (!strcmp(ptype, "T@\"NSNumber\"")) {
            [dict setValue: [self valueForKey: pname] forKey: key];
        } else if (!strcmp(ptype, "T@\"NSArray\"")) {
            NSArray *objectArray = [self valueForKey: pname];
            NSArray *newArray = [objectArray toArray];
            [dict setValue: newArray forKey: key];
        } else if (!strcmp(ptype, "T@\"NSMutableArray\"")) {
            NSArray *objectArray = [self valueForKey: pname];
            NSMutableArray *newArray = [NSMutableArray arrayWithArray: [objectArray toArray]];
            [dict setValue: newArray forKey: key];
        } else if (!strcmp(ptype, "Ti")) {
            [dict setValue: [self valueForKey: pname] forKey: key];  
        } else if (!strcmp(ptype, "TI")) {
            [dict setValue: [self valueForKey: pname] forKey: key];
        } else if (!strcmp(ptype, "Tl")) {
            [dict setValue: [self valueForKey: pname] forKey: key];
        } else if (!strcmp(ptype, "TL")) {
            [dict setValue: [self valueForKey: pname] forKey: key];
        } else if (!strcmp(ptype, "Td")) {
            [dict setValue: [self valueForKey: pname] forKey: key];
        } else if (!strcmp(ptype, "Tf")) {
            [dict setValue: [self valueForKey: pname] forKey: key];
        } else if (!strcmp(ptype, "TB")) {
            [dict setValue: [self valueForKey: pname] forKey: key];
        } else {
            id object = [self valueForKey: pname];
            [dict setValue: [object toDictionary] forKey:pname];
        }
    }
    
    return dict;
}


- (NSString *) classFromPropertyTypeString:(NSString *)typeString {
    NSRange range;
    range.location = 3;
    range.length = [typeString length] - 4;
    
    NSString *className = [typeString substringWithRange: range];
    
    return className;
}

/**
 Accept a value of any valid JSON type and attempt to convert it to a string
 **/
-(NSString *)valueToString:(id)value {
    NSString *result = nil;
    
    if ([value isKindOfClass: [NSString class]]) {
        result = value;
    }
    else if ([value isKindOfClass: [NSNumber class]]) {
        result = [((NSNumber *)value) stringValue];
    }
    
    return result;
}


/**
 Accept a value of valid JSON type and attempt to convert it to a number
 **/
-(NSNumber *)valueToNumber:(id)value {
    NSNumber *result = nil;
    
    if ([value isKindOfClass: [NSNumber class]]) {
        result = value;
    }
    else if ([value isKindOfClass: [NSString class]]) {
        NSString *svalue = (NSString *)value;
        
        if ([[svalue lowercaseString] isEqualToString: @"false"]) {
            result = [NSNumber numberWithBool: NO];
        }
        else if ([[svalue lowercaseString] isEqualToString: @"true"]) {
            result = [NSNumber numberWithBool: YES];
        }
        else {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            result = [formatter numberFromString: svalue];
        }
    }
    
    return result;
}


- (Class) typeOfArrayNamed:(NSString *)arrayName {
    return nil;
}

- (NSString *)inputKeyForPropertyNamed:(NSString *)name {
    return name;
}

- (NSString *)outputKeyForPropertyNamed:(NSString *)name {
    return name;
}

@end
