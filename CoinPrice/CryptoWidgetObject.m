//
//  CryptoWidgetObject.m
//  Crypto Ctrl
//
//  Created by Alfred Lieth Årøe on 03.01.2018.
//  Copyright © 2018 Alfred Lieth Årøe. All rights reserved.
//

#import "CryptoWidgetObject.h"

@implementation CryptoWidgetObject


- (instancetype)initBasic {
    self = [super init];
    if (self) {
        _idString = @"";
        _name = @"";
        _price_usd = @"";
        _percent_change_1h = @"";
        _percent_change_24h = @"";
        _percent_change_7d = @"";
        _last_updated = @"";
        
        if (!_image) {
            _image = nil;
        }
    }
    return self;
}

- (instancetype)initWithId:(NSString *)idString
                      name:(NSString *)name
                 price_usd:(NSString *)price_usd
         percent_change_1h:(NSString *)percent_change_1h
        percent_change_24h:(NSString *)percent_change_24h
         percent_change_7d:(NSString *)percent_change_7d
              last_updated:(NSString *)last_updated {
    self = [super init];
    if (self) {
        _idString = idString;
        _name = name;
        _price_usd = price_usd;
        _percent_change_1h = percent_change_1h;
        _percent_change_24h = percent_change_24h;
        _percent_change_7d = percent_change_7d;
        _last_updated = last_updated;
        
        if (!_image) {
            _image = nil;
        }
    }
    return self;
}


- (void)updateDataWithId:(NSString *)idString
                    name:(NSString *)name
               price_usd:(NSString *)price_usd
       percent_change_1h:(NSString *)percent_change_1h
      percent_change_24h:(NSString *)percent_change_24h
       percent_change_7d:(NSString *)percent_change_7d
            last_updated:(NSString *)last_updated {
    _idString = idString;
    _name = name;
    _price_usd = price_usd;
    _percent_change_1h = percent_change_1h;
    _percent_change_24h = percent_change_24h;
    _percent_change_7d = percent_change_7d;
    _last_updated = last_updated;
}


- (void)setCryptoImage:(UIImage *)image {
    _image = image;
}

- (UIImage *)getCryptoImage {
    return _image;
}

- (NSString *)getCryptoIdString {
    return _idString;
}

@end
