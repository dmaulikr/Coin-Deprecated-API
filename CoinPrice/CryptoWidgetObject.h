//
//  CryptoWidgetObject.h
//  Crypto Ctrl
//
//  Created by Alfred Lieth Årøe on 03.01.2018.
//  Copyright © 2018 Alfred Lieth Årøe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface CryptoWidgetObject : NSObject

- (instancetype)initBasic;

- (instancetype)initWithId:(NSString *)idString
                      name:(NSString *)name
                 price_usd:(NSString *)price_usd
         percent_change_1h:(NSString *)percent_change_1h
        percent_change_24h:(NSString *)percent_change_24h
         percent_change_7d:(NSString *)percent_change_7d
              last_updated:(NSString *)last_updated;


- (void)updateDataWithId:(NSString *)idString
                    name:(NSString *)name
               price_usd:(NSString *)price_usd
       percent_change_1h:(NSString *)percent_change_1h
      percent_change_24h:(NSString *)percent_change_24h
       percent_change_7d:(NSString *)percent_change_7d
            last_updated:(NSString *)last_updated;

// Getters and setters
- (void)setCryptoImage:(UIImage *)image;
- (UIImage *)getCryptoImage;
- (NSString *)getCryptoIdString;

@property NSString *idString;
@property NSString *name;
@property NSString *price_usd;
@property NSString *percent_change_1h;
@property NSString *percent_change_24h;
@property NSString *percent_change_7d;
@property NSString *last_updated;
@property UIImage *image;
@end
