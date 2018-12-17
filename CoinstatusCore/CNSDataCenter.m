//
//  CNSDataCenter.m
//  Coinstatus
//
//  Created by nestcode on 3/9/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import "CNSDataCenter.h"

#import "PINCache/PINCache.h"

#import "CNSCoin.h"

#define MAKE_ARRAY(name) NSMutableArray * name = [@[] mutableCopy]

static NSString * const kCacheName = @"Coinstatus";
static NSString * const kServiceBaseURL = @"https://min-api.cryptocompare.com/";
static NSString * const kWebBaseURL = @"https://www.cryptocompare.com/";

NSInteger CNSDataCenterInvalidResponseError = 1000;

static inline
NSError *MakeError(NSInteger code, NSDictionary<NSErrorUserInfoKey,id> *userInfo) {
    return [NSError errorWithDomain:@"CNSDataCenterErrorDomain" code:code userInfo:userInfo];
}

@implementation CNSDataCenter {
    PINMemoryCache *_memCache;
    PINDiskCache *_diskCache;
    NSOperationQueue *_bgQueue;
}

+ (instancetype)defaultCenter {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [self new];
        }
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    _memCache = [[PINMemoryCache alloc] init];
    
    _diskCache = [[PINDiskCache alloc] initWithName:kCacheName];
    _diskCache.ageLimit = 7 * 24 * 60 * 60;  // Cache for a week.
    
    _bgQueue = [[NSOperationQueue alloc] init];
    _bgQueue.name = @"CNSDataCenterBackgroundQueue";
    _bgQueue.qualityOfService = NSQualityOfServiceUserInitiated;
    _bgQueue.maxConcurrentOperationCount = 4;
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.timeoutIntervalForRequest = 10;
    sessionConfig.timeoutIntervalForResource = 30;
    
    return self;
}

- (id)_cachedObjectForKey:(NSString *)key {
    if ([_memCache containsObjectForKey:key]) {
        return [_memCache objectForKey:key];
    }
    
    if ([_diskCache containsObjectForKey:key]) {
        id obj = [_diskCache objectForKey:key];
        [_memCache setObject:obj forKey:key];
        return obj;
    }
    
    return nil;
}

- (void)_setObject:(id)obj toCacheForKey:(NSString *)key {
    [_memCache setObject:obj forKey:key];
    [_diskCache setObject:obj forKey:key];
}

- (void)clearCoinListCache {
    [_memCache removeObjectForKey:@"coinList"];
    [_diskCache removeObjectForKey:@"coinList"];
}

- (void)fetchCoinListWithCallback:(CNSDataCenterCallback)block {
    static NSString *cacheKey = @"coinList";
    
    [_bgQueue addOperationWithBlock:^{
        id cachedObj = [self _cachedObjectForKey:cacheKey];
        if (cachedObj) {
            block(cachedObj, nil);
            return;
        }
        NSURL *curl=[NSURL URLWithString:@"https://min-api.cryptocompare.com/data/all/coinlist"];
        NSString *curl4 = [NSString stringWithFormat:@"%@",curl];
        
        NSURL *finalurl = [[NSURL alloc] initWithString:curl4];
        NSLog(@"final url: %@", finalurl);
        
       NSURL * url1 = [NSURL URLWithString:@"https://www.cryptocompare.com/"];
        
        NSURLSessionConfiguration *csc=[NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *csession = [NSURLSession sessionWithConfiguration:csc delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        
        NSURLSessionDataTask *ctask=[csession dataTaskWithURL:finalurl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                     
                                     {
                                         dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                                             NSString *strName = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                             NSLog(@"str: %@",strName);
                                             
                                            NSMutableDictionary *dictSuccess = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                             
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 
                                                 NSMutableArray *arrCoinData = [dictSuccess objectForKey:@"Data"];
                                                 
                                                 id _Data = [dictSuccess objectForKey:@"Data"];
                                                 if (!_Data) {
                                                     block(nil, MakeError(CNSDataCenterInvalidResponseError, NULL));
                                                     return;
                                                 }
                                                 MAKE_ARRAY(result);
                                                 
                                                 [_Data enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                                                     CNSCoin *coin = [CNSCoin new];
                                                     coin.name = key;
                                                     coin.coinName = [obj objectForKey:@"CoinName"];
                                                     coin.imageURL = [NSURL URLWithString:[kWebBaseURL stringByAppendingPathComponent:[obj objectForKey:@"ImageUrl"]]];
                                                     coin.symbol = [obj objectForKey:@"Symbol"];
                                                     
                                                     [result addObject:coin];
                                                 }];
                                                 
                                                 [result sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"coinName" ascending:YES]]];
                                                 
                                                 [self _setObject:result toCacheForKey:cacheKey];
                                                 
                                                 block(result, nil);
                                                 
                                             });
                                         });
                                     }];
        [ctask resume];
        }];
    
    
    
    /* [_httpSessionManager
     GET:@"/data/all/coinlist"
     parameters:nil
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     id _Data = [responseObject objectForKey:@"Data"];
     if (!_Data) {
     block(nil, MakeError(CNSDataCenterInvalidResponseError, NULL));
     return;
     }
     MAKE_ARRAY(result);
     [_Data enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
     CNSCoin *coin = [CNSCoin new];
     coin.name = key;
     coin.coinName = [obj objectForKey:@"CoinName"];
     coin.imageURL = [NSURL URLWithString:[kWebBaseURL stringByAppendingPathComponent:[obj objectForKey:@"ImageUrl"]]];
     coin.symbol = [obj objectForKey:@"Symbol"];
     
     [result addObject:coin];
     }];
     
     [result sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"coinName" ascending:YES]]];
     
     [self _setObject:result toCacheForKey:cacheKey];
     
     block(result, nil);
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     block(nil, error);
     }];*/
}

- (void)fetchPrices:(NSArray<NSString *> *)list withCallback:(CNSDataCenterCallback)block {
    /*
     [_httpSessionManager
     GET:@"/data/pricemultifull"
     parameters:@{@"fsyms": fsymsParameter, @"tsyms": @"USD"}
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     id _RAW = [responseObject objectForKey:@"RAW"];
     if (!_RAW) {
     block(nil, MakeError(CNSDataCenterInvalidResponseError, NULL));
     return;
     }
     block(_RAW, nil);
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     block(nil, error);
     }];
     */
    [_bgQueue addOperationWithBlock:^{
        NSMutableString *fsymsParameter = [NSMutableString string];
        [list enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (fsymsParameter.length) {
                [fsymsParameter appendString:@","];
            }
            [fsymsParameter appendString:[obj componentsSeparatedByString:@"~"].firstObject];
        }];
        NSString *str = [NSString stringWithFormat:@"https://min-api.cryptocompare.com/data/pricemultifull?fsyms=%@&tsyms=USD",fsymsParameter];
        NSURL *curl=[NSURL URLWithString:str];
        NSString *curl4 = [NSString stringWithFormat:@"%@",curl];
        NSURL *finalurl = [[NSURL alloc] initWithString:curl4];
        NSURLSessionConfiguration *csc=[NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *csession = [NSURLSession sessionWithConfiguration:csc delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        
        NSURLSessionDataTask *ctask=[csession dataTaskWithURL:finalurl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                     {
                                         dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                                             NSString *strName = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                             NSLog(@"str: %@",strName);
                                             NSMutableDictionary *dictSuccess = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 id _RAW = [dictSuccess objectForKey:@"RAW"];
                                                 if (!_RAW) {
                                                     block(nil, MakeError(CNSDataCenterInvalidResponseError, NULL));
                                                     return;
                                                 }
                                                 block(_RAW, nil);
                                             });
                                         });
                                     }];
        [ctask resume];
    }];
}

@end
