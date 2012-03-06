//
//  Customer.m
// 
//
//  Created by Greg Pasquariello on 3/2/12.
//  Copyright (c) 2012 BiggerMind Software. All rights reserved.
//

#import "Customer.h"
#import "Account.h"

@implementation Customer

@synthesize customProperty;
@synthesize accountHolder;
@synthesize accounts;
@synthesize lastUpdated;
@synthesize messages;

-(NSString *) inputKeyForPropertyNamed:(NSString *)name {
    return name;
}

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

@end
