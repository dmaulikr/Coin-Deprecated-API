//
//  ViewController.h
//  TaroMaroCoin
//
//  Created by nestcode on 3/1/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coordinate.h"
#import "Reachability.h"
#import "ApiCallManager.h"
#import "Constants.h"
#import "HTTPRequestHandler.h"
#import "JSON.h"
#import "SWRevealViewController.h"
#import "SVProgressHUD.h"
#import "CoinDataTableViewCell.h"
#import "CoinDataCollectionViewCell.h"
#import "UIImageView+RJLoader.h"
#import "UIImageView+WebCache.h"
#import "SQLFile.h"
#import "CoinDetailsViewController.h"
#import "ActionSheetPicker.h"
#import "CNSExchange.h"
#import "CNSExchangeManager.h"
#import "CNSPriceRetriever.h"
#import "AppDelegate.h"
#import "CNSCoin.h"
#import "CNSDataCenter.h"
#import <GoogleMobileAds/GADBannerView.h>
#import <GoogleMobileAds/GADRequest.h>
#import "AppID.h"
#import "UIView+Toast.h"
#import "JLElasticRefresh.h"
#import "ProgressHUD.h"
#import "AITutorialViewController.h"
#import "KIImagePager.h"
#import <GoogleMobileAds/GADInterstitial.h>
#import "SCLAlertView.h"

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,ApiCallManagerDelegate,HTTPRequestHandlerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate,UISearchResultsUpdating,CNSPriceRetrieverDelegate,GADBannerViewDelegate,KIImagePagerDelegate, KIImagePagerDataSource,GADInterstitialDelegate>{
    HTTPRequestHandler *requestHandler;
    id<ApiCallManagerDelegate>_delegate;
    NSMutableArray *widgetCryptoIdArray;
    CNSPriceRetriever *_priceRetriever;
    BOOL _interactiveMovementInFlight;
    BOOL _dataUpdatingDeferred;
    GADBannerView *BannerView_;
    
}



@property (nonatomic, strong) NSMutableArray<CNSExchange *> *exchangeList;

@property (weak, nonatomic) IBOutlet UIButton *btnListCollection;
- (IBAction)onListCollectClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UISearchBar *searchField;


@property (weak, nonatomic) IBOutlet UITableView *tableCoinData;

@property (weak, nonatomic) IBOutlet UISegmentedControl *CurrencySegment;
- (IBAction)chnageValue:(UISegmentedControl *)sender;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionCoinData;

- (IBAction)onSideBarButtonClicked:(id)sender;

- (IBAction)onCurrencyClicked:(id)sender;
- (IBAction)onShortingClicked:(id)sender;
- (IBAction)onSearchClicked:(id)sender;
- (IBAction)onCloseClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnShort;
@property (weak, nonatomic) IBOutlet UIButton *btnShort1;

@property (weak, nonatomic) IBOutlet UIView *viewSearch;

@property (weak, nonatomic) IBOutlet UIButton *btnSideBar;

//  on/off
@property (weak, nonatomic) IBOutlet UIView *viewTop;


@property (weak, nonatomic) IBOutlet UIView *adView;
@property(nonatomic,strong) GADBannerView *BannerView;
-(GADRequest *)createRequest;



@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
- (IBAction)onSliderCloseClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewImagesDemo;

@property NSUInteger pageIndex;
@property NSString *imageFile;


@property(nonatomic, strong) GADInterstitial *interstitial;

@end

