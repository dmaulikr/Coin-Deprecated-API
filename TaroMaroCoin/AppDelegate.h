//
//  AppDelegate.h
//  TaroMaroCoin
//
//  Created by nestcode on 3/1/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNSExchange.h"
#import "CNSExchangeManager.h"
#import <WatchConnectivity/WatchConnectivity.h>
#import <NotificationCenter/NotificationCenter.h>
#import "Constants.h"
#import <GoogleMobileAds/GADBannerView.h>
#import <GoogleMobileAds/GADRequest.h>
#import <GoogleMobileAds/GADMobileAds.h>
@import GoogleMobileAds;

@interface AppDelegate : UIResponder <UIApplicationDelegate,WCSessionDelegate>
{
    NSString *strdbpath;
}

@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic)NSString *strdbpath;

-(void)syncExchangeListWithWatch;

-(void)CopyandCheckdb;

-(void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void(^)(NSData *data))completionHandler;

@end

