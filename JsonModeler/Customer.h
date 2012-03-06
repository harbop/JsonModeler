//
//  Customer.h
//  
//
//  Created by Greg Pasquariello on 3/2/12.
//  Copyright (c) 2012 BiggerMind Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+JSON.h"

@interface Customer : NSObject

@property (strong, nonatomic) NSString *customProperty;
@property (strong, nonatomic) NSString *accountHolder;
@property (strong, nonatomic) NSArray *accounts;
@property (strong, nonatomic) NSArray *messages;
@property (strong, nonatomic) NSString *lastUpdated;

@end
