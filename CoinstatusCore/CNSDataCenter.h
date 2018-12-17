//
//  CNSDataCenter.h
//  Coinstatus
//
//  Created by nestcode on 3/9/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <Foundation/Foundation.h>


FOUNDATION_EXPORT NSInteger CNSDataCenterInvalidResponseError;

typedef void(^CNSDataCenterCallback)(id, NSError *);

@interface CNSDataCenter : NSObject

+ (instancetype)defaultCenter;

- (void)clearCoinListCache;
- (void)fetchCoinListWithCallback:(CNSDataCenterCallback)block;

- (void)fetchPrices:(NSArray<NSString *> *)list withCallback:(CNSDataCenterCallback)block;

@end
