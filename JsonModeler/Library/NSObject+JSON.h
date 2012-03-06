//
//  NSObject+JSON.h
//  nico
//
//  Created by Greg Pasquariello on 3/5/12.
//  Copyright (c) 2012 BiggerMind Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (JSON)

-(id) initWithJSON:(NSString *)json;
-(id) initWithDictionary:(NSDictionary *)dictionary;

- (NSMutableDictionary *)toDictionary;
- (NSString *)toJSON;

@end


@interface NSArray (JSON)

-(id) initWithJSON:(NSString *)json;
-(id) initWithArray:(NSArray *)array ofClass:(Class)class;

- (NSArray *)toArray;
- (NSString *)toJSON;

@end
