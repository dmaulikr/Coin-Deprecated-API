//
//  HeroZeroViewController.h
//  TaroMaroCoin
//
//  Created by nestcode on 3/9/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "ApiCallManager.h"
#import "Constants.h"
#import "HTTPRequestHandler.h"
#import "JSON.h"
#import "SWRevealViewController.h"
#import "SVProgressHUD.h"
#import "SQLFile.h"
#import "ActionSheetPicker.h"
@import MaterialComponents;
@import CCDropDownMenus;
@import Charts;
#import "DateValueFormatter.h"
#define SECS_PER_DAY (86400)

#import <GoogleMobileAds/GADBannerView.h>
#import <GoogleMobileAds/GADRequest.h>
#import <GoogleMobileAds/GADInterstitial.h>
#import "AppID.h"

@interface HeroZeroViewController : UIViewController <ApiCallManagerDelegate,HTTPRequestHandlerDelegate,ChartViewDelegate,GADBannerViewDelegate,GADInterstitialDelegate>
{
    HTTPRequestHandler *requestHandler;
    id<ApiCallManagerDelegate>_delegate;
    GADBannerView *BannerView_;
}

@property (weak, nonatomic) IBOutlet UILabel *lbl24hVolume;
@property (weak, nonatomic) IBOutlet UILabel *lblBitcoinPerMarketCap;
@property (weak, nonatomic) IBOutlet UILabel *lblActiveCurrencies;
@property (weak, nonatomic) IBOutlet UILabel *lblActiveAssets;
@property (weak, nonatomic) IBOutlet UILabel *lblActiveMarkets;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UILabel *lblMarketCap;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnCurrency;
- (IBAction)onCurrencyClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewData;
@property (weak, nonatomic) IBOutlet UIView *viewChart;

@property (weak, nonatomic) IBOutlet LineChartView *chartView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *detailSegment;
- (IBAction)SegmentChanged:(id)sender;

@property (nonatomic,strong) NSDateFormatter *formatter;
@property (nonatomic,strong) NSNumber *intt;
@property (weak, nonatomic) IBOutlet UILabel *lblChartData;
@property (strong, nonatomic) IBOutlet UIButton *btn1;
@property (strong, nonatomic) IBOutlet UIButton *btn2;
@property (strong, nonatomic) IBOutlet UIButton *btn3;
@property (strong, nonatomic) IBOutlet UIButton *btn4;
@property (strong, nonatomic) IBOutlet UIButton *btn5;
@property (strong, nonatomic) IBOutlet UIButton *btn6;
@property (strong, nonatomic) IBOutlet UIButton *btn7;


@property (weak, nonatomic) IBOutlet UILabel *lblStatic1;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic2;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic3;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic4;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic5;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic6;

@property (weak, nonatomic) IBOutlet UIView *adView;
@property(nonatomic,strong) GADBannerView *BannerView;
-(GADRequest *)createRequest;
@property(nonatomic, strong) GADInterstitial *interstitial;

@end
