//
//  CNSExchange.m
//  Coinstatus
//
//  Created by nestcode on 3/9/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import "CNSExchange.h"

@implementation CNSExchange

+ (instancetype)exchangeFromSymbol:(NSString *)fsym toSymbol:(NSString *)tsym {
    CNSExchange *instance = [CNSExchange new];
    instance.fromSymbol = fsym;
    instance.toSymbol = tsym;
    return instance;
}

@end
