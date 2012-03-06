//
//  Transaction.h
//  
//
//  Created by Greg Pasquariello on 3/2/12.
//  Copyright (c) 2012 BiggerMind Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Transaction : NSObject

@property(nonatomic, strong) NSString *amount;
@property(nonatomic, strong) NSString *date;
@property(nonatomic, strong) NSString *checkImage;

@end
