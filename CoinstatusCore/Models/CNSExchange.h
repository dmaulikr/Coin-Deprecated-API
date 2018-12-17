//
//  CNSExchange.h
//  Coinstatus
//
//  Created by nestcode on 3/9/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CNSExchange : NSObject

@property (nonatomic, copy) NSString *fromSymbol;
@property (nonatomic, copy) NSString *toSymbol;
@property (nonatomic, assign) uint16_t flags;
@property (nonatomic, copy) NSDecimalNumber *value;

+ (instancetype)exchangeFromSymbol:(NSString *)fsym toSymbol:(NSString *)tsym;

@end
