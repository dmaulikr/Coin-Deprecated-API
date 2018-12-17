//
//  CNSExchangeManager.h
//  CoinstatusCore
//
//  Created by nestcode on 3/9/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CNSExchangeManager : NSObject

/**
 User selected exchange list.
 Content format: @"fsym~tsym"
 */
@property (nonatomic) NSArray<NSString *> *exchangeList;

+ (instancetype)defaultManager;

@end
