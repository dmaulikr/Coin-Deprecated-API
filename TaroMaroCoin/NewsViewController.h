//
//  NewsViewController.h
//  TaroMaroCoin
//
//  Created by nestcode on 3/9/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsTableViewCell.h"
#import "Reachability.h"
#import "ApiCallManager.h"
#import "Constants.h"
#import "HTTPRequestHandler.h"
#import "JSON.h"
#import "SWRevealViewController.h"
#import "SVProgressHUD.h"
#import "UIImageView+RJLoader.h"
#import "UIImageView+WebCache.h"
#import "NewsDetailViewController.h"
#import <GoogleMobileAds/GADBannerView.h>
#import <GoogleMobileAds/GADRequest.h>
#import "AppID.h"
#import <GoogleMobileAds/GADInterstitial.h>

@interface NewsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,ApiCallManagerDelegate,HTTPRequestHandlerDelegate,GADBannerViewDelegate,GADInterstitialDelegate>{
    HTTPRequestHandler *requestHandler;
    id<ApiCallManagerDelegate>_delegate;
    GADBannerView *BannerView_;
}

@property (weak, nonatomic) IBOutlet UITableView *tableNewsData;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIView *adView;
@property(nonatomic,strong) GADBannerView *BannerView;
-(GADRequest *)createRequest;
@property(nonatomic, strong) GADInterstitial *interstitial;

@end
