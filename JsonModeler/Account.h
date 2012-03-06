//
//  Account.h
//  
//
//  Created by Greg Pasquariello on 3/2/12.
//  Copyright (c) 2012 BiggerMind Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Transaction.h"


@interface Account : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic, assign) int index;
@property(nonatomic, assign) double balance;
@property(nonatomic, assign, getter=isActive) bool active;
@property(nonatomic, strong) Transaction *lastTransaction;

@end
