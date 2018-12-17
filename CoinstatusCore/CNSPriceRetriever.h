//
//  CNSPriceRetriever.h
//  CoinstatusCore
//
//  Created by nestcode on 2018/2/12.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CNSPriceRetriever;

@protocol CNSPriceRetrieverDelegate <NSObject>

@optional
- (void)newDataAvailableOfPriceRetriever:(CNSPriceRetriever *)retriever;

@end

@interface CNSPriceRetriever : NSObject

@property (nonatomic, copy) NSArray<NSString *> *exchangeList;
@property (nonatomic, weak) id<CNSPriceRetrieverDelegate> delegate;

- (void)startRetrieving;
- (void)stopRetrieving;

- (NSDictionary<NSString *, id> *)infoFromSymbol:(NSString *)fsym;

@end
