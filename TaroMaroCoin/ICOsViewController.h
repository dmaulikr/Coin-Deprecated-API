//
//  ICOsViewController.h
//  TaroMaroCoin
//
//  Created by nestcode on 3/9/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICOsTableViewCell.h"
#import "ICODetailViewController.h"
#import "Reachability.h"
#import "ApiCallManager.h"
#import "Constants.h"
#import "HTTPRequestHandler.h"
#import "JSON.h"
#import "SWRevealViewController.h"
#import "SVProgressHUD.h"
#import "UIImageView+RJLoader.h"
#import "UIImageView+WebCache.h"
#import <GoogleMobileAds/GADBannerView.h>
#import <GoogleMobileAds/GADRequest.h>
#import "AppID.h"
#import <GoogleMobileAds/GADInterstitial.h>

@interface ICOsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,ApiCallManagerDelegate,GADBannerViewDelegate,HTTPRequestHandlerDelegate,GADInterstitialDelegate>{
    HTTPRequestHandler *requestHandler;
    id<ApiCallManagerDelegate>_delegate;
    GADBannerView *BannerView_;
}

@property (weak, nonatomic) IBOutlet UITableView *tableICOData;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *SegmentICOType;

- (IBAction)segmentChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *adView;
@property(nonatomic,strong) GADBannerView *BannerView;
-(GADRequest *)createRequest;
@property(nonatomic, strong) GADInterstitial *interstitial;

@end
