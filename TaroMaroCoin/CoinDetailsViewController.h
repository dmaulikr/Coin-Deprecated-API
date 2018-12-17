//
//  CoinDetailsViewController.h
//  TaroMaroCoin
//
//  Created by nestcode on 3/6/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "ApiCallManager.h"
#import "Constants.h"
#import "HTTPRequestHandler.h"
#import "JSON.h"
#import "SVProgressHUD.h"
#import "UIImageView+RJLoader.h"
#import "UIImageView+WebCache.h"
#import "SQLFile.h"
#import "ActionSheetPicker.h"

#import <GoogleMobileAds/GADBannerView.h>
#import <GoogleMobileAds/GADRequest.h>
#import "AppID.h"
#import <GoogleMobileAds/GADInterstitial.h>

@import MaterialComponents;
@import Charts;
#import "DateValueFormatter.h"
#define SECS_PER_DAY (86400)


@interface CoinDetailsViewController : UIViewController<ApiCallManagerDelegate,HTTPRequestHandlerDelegate,ChartViewDelegate,GADBannerViewDelegate,GADInterstitialDelegate>{
    HTTPRequestHandler *requestHandler;
    id<ApiCallManagerDelegate>_delegate;
    GADBannerView *BannerView_;
}

@property (weak, nonatomic) IBOutlet UIView *viewTop;


@property(nonatomic, retain)NSMutableDictionary *dictCoinData;
@property(nonatomic, retain)NSString *strCurrencyName;
- (IBAction)onBackClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *imgCoin;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;


@property (weak, nonatomic) IBOutlet UIView *viewDetails;
@property (weak, nonatomic) IBOutlet UILabel *lblCoinAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblLastUpdate;
@property (weak, nonatomic) IBOutlet UILabel *lblSymbol;
@property (weak, nonatomic) IBOutlet UILabel *lblPriceUSD;
@property (weak, nonatomic) IBOutlet UILabel *lblPriceBTC;
@property (weak, nonatomic) IBOutlet UILabel *lblVolume;
@property (weak, nonatomic) IBOutlet UILabel *lblMarketCap;
@property (weak, nonatomic) IBOutlet UILabel *lblAvailableSupply;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalSupply;
@property (weak, nonatomic) IBOutlet UILabel *lblMaxSupply;
@property (weak, nonatomic) IBOutlet UILabel *lblChange1h;
@property (weak, nonatomic) IBOutlet UILabel *lblChange24h;
@property (weak, nonatomic) IBOutlet UILabel *lblChange7d;
@property (nonatomic,strong) NSNumber *intt;


@property (weak, nonatomic) IBOutlet UIView *viewInDetail;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic1;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic2;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic3;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic4;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic5;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic6;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic7;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic8;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic9;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic10;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic11;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic12;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic13;



@property (weak, nonatomic) IBOutlet UISegmentedControl *detailSegment;
- (IBAction)SegmentChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewChart;
@property (weak, nonatomic) IBOutlet UILabel *lblChartData;
@property (nonatomic,strong) NSDateFormatter *formatter;
@property (strong, nonatomic) IBOutlet UIButton *btn1;
@property (strong, nonatomic) IBOutlet UIButton *btn2;
@property (strong, nonatomic) IBOutlet UIButton *btn3;
@property (strong, nonatomic) IBOutlet UIButton *btn4;
@property (strong, nonatomic) IBOutlet UIButton *btn5;
@property (strong, nonatomic) IBOutlet UIButton *btn6;
@property (strong, nonatomic) IBOutlet UIButton *btn7;
@property (weak, nonatomic) IBOutlet LineChartView *chartView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *ChartSegment;
- (IBAction)ChartSegmentChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UISegmentedControl *CurrencySegment;
- (IBAction)CurrencySegmentChanged:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *viewExchange;


@property (weak, nonatomic) IBOutlet UIView *viewAleart;
@property (weak, nonatomic) IBOutlet UIButton *btnCurrency;
- (IBAction)onCurrencyChangeClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblPriceAbove;
@property (weak, nonatomic) IBOutlet UIView *priceAboveChange;
@property (weak, nonatomic) IBOutlet UIButton *btnAboveAdd;
@property (weak, nonatomic) IBOutlet UIButton *btnAboveMinus;
- (IBAction)switchAboveOnOff:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblAbovePerChange;
- (IBAction)onAboveSlideChange:(id)sender;
@property (weak, nonatomic) IBOutlet UISlider *aboveSlide;



- (IBAction)onAboveAddClicked:(id)sender;
- (IBAction)onAboveMinusClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lblPriceBelow;
@property (weak, nonatomic) IBOutlet UIView *priceBelowChange;
@property (weak, nonatomic) IBOutlet UIButton *btnBelowAdd;
@property (weak, nonatomic) IBOutlet UIButton *btnBelowMinus;
- (IBAction)switchBelowOnOff:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblBelowPerChnage;
- (IBAction)onBelowSlideChange:(float)sender;
@property (weak, nonatomic) IBOutlet UISlider *belowSlide;


@property (weak, nonatomic) IBOutlet UIView *viewBelow;
@property (weak, nonatomic) IBOutlet UIView *viewAbove;

- (IBAction)onBelowAddClicked:(id)sender;
- (IBAction)onBelowMinusClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UISwitch *switchAbove;
@property (weak, nonatomic) IBOutlet UISwitch *switchBelow;

@property (weak, nonatomic) IBOutlet UIView *adView;
@property(nonatomic,strong) GADBannerView *BannerView;
-(GADRequest *)createRequest;


@property(nonatomic, strong) GADInterstitial *interstitial;

@end
