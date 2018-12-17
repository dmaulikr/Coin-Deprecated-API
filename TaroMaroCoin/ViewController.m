//
//  ViewController.m
//  TaroMaroCoin
//
//  Created by nestcode on 3/1/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import "ViewController.h"

#define kMaxWidgets 7

@interface ViewController (){
    
IBOutlet KIImagePager *_imagePager;
    
}

@end

@implementation ViewController{
    NSMutableArray *arrCoinData, *arrFavourite, *arrSearchData ,*arrNames, *arrShortedCoinData;
    NSMutableArray *arrCoinDataTemp,*arrShortedCoinDataTemp;
    NSString *CName, *CSymbol, *CoinsToShow;
    int flagCollection;
    NSMutableDictionary *DictSQLFav;
    int segmentId;
    BOOL searchEnabled;
    NSArray *arrSearchResult;
    int selectedsort, selectedCurrency;
    NSMutableDictionary *dictforWatch;
    NSString *strTheme;
    NSMutableArray *arrOfflineCoinData, *arrOfflineSearchData, *arrOfflineNames, *arrOfflineShortedCoinData;
    NSUserDefaults *userOfflineCoinData, *userOfflineSearchData, *userOfflineNames, *userOfflineShortedCoinData, *userFlagAPICall, *isFromLaunch, *isFirstTime;
    int flagCallAPI;
    NSTimer *timer;
    UIRefreshControl *refreshControl;
    NSInteger m;
    NSUserDefaults *Visited1;
    NSUserDefaults *isBanner, *isFullScreen, *Interval, *bannerID, *FullID;
    NSString *strBanner, *strFull;
    NSUserDefaults *AdvertData;
}
@synthesize BannerView = BannerView_;
@synthesize interstitial = InterstitialView_;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AdvertData = [NSUserDefaults standardUserDefaults];
    isBanner = [NSUserDefaults standardUserDefaults];
    isFullScreen = [NSUserDefaults standardUserDefaults];
    Interval = [NSUserDefaults standardUserDefaults];
    bannerID = [NSUserDefaults standardUserDefaults];
    FullID = [NSUserDefaults standardUserDefaults];
    
    strBanner = [bannerID valueForKey:@"bannerID"];
    strFull = [FullID valueForKey:@"FullID"];
    
    NSInteger isBannerActive = [isBanner integerForKey:@"isBanner"];
    if (isBannerActive == 1) {
       // [self createAdBannerView];
    }
    
    NSInteger intervalFull = [Interval integerForKey:@"Interval"];
    Visited1 = [NSUserDefaults standardUserDefaults];
    NSInteger fav = [Visited1 integerForKey:@"MainVisited"];
    if (intervalFull == 0) {
        intervalFull = 3;
    }
    m = fav % intervalFull;
    if (m == 0) {
        NSInteger isFullActive = [isFullScreen integerForKey:@"isFullScreen"];
        if (isFullActive == 1) {
            [self createAndLoadInterstitial];
        }
    }
    m++;
    [Visited1 setInteger:m forKey:@"MainVisited"];
    [Visited1 synchronize];
    
    
    isFromLaunch = [NSUserDefaults standardUserDefaults];
    isFirstTime = [NSUserDefaults standardUserDefaults];
    
    if ([isFirstTime integerForKey:@"isFirstTime"]==1) {
        _viewImagesDemo.hidden = YES;
    }else{
        _viewImagesDemo.hidden = NO;
        [isFirstTime setInteger:1 forKey:@"isFirstTime"];
        [isFirstTime synchronize];
        
        _imagePager.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
        _imagePager.pageControl.pageIndicatorTintColor = [UIColor blackColor];
        _imagePager.slideshowTimeInterval = 5.5f;
        _imagePager.slideshowShouldCallScrollToDelegate = YES;
        
       // self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
    }
    
    userFlagAPICall = [NSUserDefaults standardUserDefaults];
    userOfflineCoinData = [NSUserDefaults standardUserDefaults];
    userOfflineSearchData = [NSUserDefaults standardUserDefaults];
    userOfflineNames = [NSUserDefaults standardUserDefaults];
    userOfflineShortedCoinData = [NSUserDefaults standardUserDefaults];
    
    _priceRetriever = [CNSPriceRetriever new];
    _priceRetriever.delegate = self;
    
    selectedsort = 0;
    selectedCurrency = 0;
    
    arrShortedCoinData = [[NSMutableArray alloc]init];
    
    self.tableCoinData.tableFooterView = [UIView new];
    arrSearchResult = [[NSArray alloc]init];
    arrSearchData = [[NSMutableArray alloc]init];
    arrOfflineSearchData = [[NSMutableArray alloc]init];
    DictSQLFav = [[NSMutableDictionary alloc]init];
    _viewSearch.hidden = YES;
    
    arrOfflineShortedCoinData = [[NSMutableArray alloc]init];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    flagCollection = 1;
    
    [self TableCollectionChange:flagCollection];
    
    CName = [[NSUserDefaults standardUserDefaults]
                       stringForKey:@"CurrencyName"];
    
    CoinsToShow = [[NSUserDefaults standardUserDefaults]  stringForKey:@"CoinsToShow"];

    [self CurrencySymbol];
    [self viewPages];

    [self APIAdData];
    
    if ([userFlagAPICall integerForKey:@"userFlagAPICall"] != 1) {
        [self APICoinData];
    }
    else
    {
        if ([isFromLaunch integerForKey:@"isFromLaunch"]==1) {
            [self APICoinData];
            [isFromLaunch setInteger:0 forKey:@"isFromLaunch"];
            [isFromLaunch synchronize];
        }
        else{
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"arrCoinData"];
        arrCoinData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        arrShortedCoinData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [self getdata];
        arrSearchResult = [NSMutableArray arrayWithCapacity:[arrCoinData count]];
        [self Names];
        [_tableCoinData reloadData];
        }
        //[_collectionCoinData reloadData];
    }

    NSUserDefaults *shard = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.nestcode.cryptocurrency"];//group.com.nestcode.cryptocurrency
    NSData *widgetCryptoIdData = [shard objectForKey:@"widgetCryptoIdArray"];
    
    if (widgetCryptoIdData) {
        widgetCryptoIdArray = [NSKeyedUnarchiver unarchiveObjectWithData:widgetCryptoIdData];
    } else {
        widgetCryptoIdArray = [[NSMutableArray alloc] init];
    }
    
    //  Day/Night Mode Setting
    strTheme = [[NSUserDefaults standardUserDefaults]
                stringForKey:@"theme"];
    
    if ([strTheme isEqualToString:@"1"]) {
        self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
        [_CurrencySegment setBackgroundColor:[UIColor orangeColor]];
        [_CurrencySegment setTintColor:[UIColor blackColor]];
        [_viewTop setBackgroundColor:[UIColor orangeColor]];
        [_btnListCollection setImage:[UIImage imageNamed:@"DarkbtnCollection.png"] forState:UIControlStateNormal];
        [_btnListCollection setBackgroundColor:[UIColor blackColor]];
        [self.view setBackgroundColor:[UIColor orangeColor]];
    }
    else{
        [self.view setBackgroundColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0];
        [_CurrencySegment setBackgroundColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        [_CurrencySegment setTintColor:[UIColor whiteColor]];
        [_viewTop setBackgroundColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        [_btnListCollection setImage:[UIImage imageNamed:@"btnCollection.png"] forState:UIControlStateNormal];
        [_btnListCollection setBackgroundColor:[UIColor whiteColor]];
    }
    
   /* JLElasticRefreshLoadingViewCircle *loadingView = [[JLElasticRefreshLoadingViewCircle alloc] init];
    loadingView.tintColor = [UIColor whiteColor];
    __weak typeof(self) weakSelf = self;
    [_tableCoinData jler_addRefreshWithActionHandler:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self APICoinData];
            [weakSelf.tableCoinData jler_stopLoading];
        });
    } loadingView:loadingView];
    [_tableCoinData jler_setRefreshFillColor:[UIColor colorWithRed: 57/255.0 green: 67/255.0 blue: 89/255.0 alpha: 1.0]];
    [_tableCoinData jler_setRefreshBackgroundColor:_tableCoinData.backgroundColor];*/
    
    refreshControl = [[UIRefreshControl alloc]init];
    [self.tableCoinData addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
}

- (GADInterstitial *)createAndLoadInterstitial {
    self.interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:strFull];
    self.interstitial.delegate = self;
    [self.interstitial loadRequest:[DFPRequest request]];
    return self.interstitial;
}

- (void)interstitialDidReceiveAd:(DFPInterstitial *)ad {
    NSLog(@"Interstitial Ad Received");
    [InterstitialView_ presentFromRootViewController:self];
}

#pragma mark - KIImagePager DataSource
- (NSArray *) arrayWithImages:(KIImagePager*)pager
{
    return @[
             [UIImage imageNamed:@"Image1.png"],
             [UIImage imageNamed:@"Image2.png"],
             [UIImage imageNamed:@"Image3.png"],
             [UIImage imageNamed:@"Image4.png"]
             ];
}

- (UIViewContentMode) contentModeForImage:(NSUInteger)image inPager:(KIImagePager *)pager
{
    return UIViewContentModeScaleAspectFit;
}


#pragma mark - KIImagePager Delegate
- (void) imagePager:(KIImagePager *)imagePager didScrollToIndex:(NSUInteger)index
{
    NSLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)index);
}

- (void) imagePager:(KIImagePager *)imagePager didSelectImageAtIndex:(NSUInteger)index
{
    NSLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)index);
}

- (void)refreshTable {
    [refreshControl endRefreshing];
    [self APICoinData];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self.view endEditing:YES];
    self.tableCoinData.estimatedRowHeight = 0;
    self.tableCoinData.estimatedSectionHeaderHeight = 0;
    self.tableCoinData.estimatedSectionFooterHeight = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(APICoinData) name:@"reload_data" object:nil];
}

-(void)viewPages
{
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe
{
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight)
    {
     [self.view endEditing:YES];
    }
}

-(void)AutoCallAPIBackground
{
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:180.0f target:self selector:@selector(APICoinData) userInfo:nil repeats:YES];
}

- (void) createAdBannerView
{
    NSLog(@"%s",__FUNCTION__);
    if (self.BannerView == nil)
    {
        self.BannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0, 0, GAD_SIZE_320x50.width, GAD_SIZE_320x50.height)];
        [self.adView addSubview:self.BannerView];
        self.BannerView.rootViewController = self;
        BannerView_.adUnitID = strBanner;
        [self.BannerView loadRequest:[GADRequest request]];
    }
    
    if (![self.adView.subviews containsObject:self.BannerView])
        [self.adView addSubview:self.BannerView];
}

-(GADRequest *)createRequest{
    GADRequest *request = [GADRequest request];
    return request;
}

-(void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"Ad Received");
}

-(void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Failed to receive ad due to: %@", [error localizedFailureReason]);
}

-(void)TableCollectionChange:(int)flag{
    if (flag == 1) {
        _collectionCoinData.hidden = YES;
        _tableCoinData.hidden = NO;
        if ([strTheme isEqualToString:@"1"]) {
             [_btnListCollection setImage:[UIImage imageNamed:@"DarkbtnCollection.png"] forState:UIControlStateNormal];
            [_btnListCollection setBackgroundColor:[UIColor blackColor]];
        }
        else{
             [_btnListCollection setImage:[UIImage imageNamed:@"btnCollection.png"] forState:UIControlStateNormal];
            [_btnListCollection setBackgroundColor:[UIColor whiteColor]];
        }
    }
    else{
        //[_collectionCoinData reloadData];
        _collectionCoinData.hidden = NO;
        _tableCoinData.hidden = YES;
        if ([strTheme isEqualToString:@"1"]) {
             [_btnListCollection setImage:[UIImage imageNamed:@"DarkbtnList.png"] forState:UIControlStateNormal];
            [_btnListCollection setBackgroundColor:[UIColor blackColor]];
        }
        else{
            [_btnListCollection setImage:[UIImage imageNamed:@"btnList.png"] forState:UIControlStateNormal];
            [_btnListCollection setBackgroundColor:[UIColor whiteColor]];
        }
    }
}

//collectCell

- (IBAction)onListCollectClicked:(id)sender {
    if (flagCollection == 1) {
        flagCollection = 0;
    }
    else{
        flagCollection = 1;
    }
    [self TableCollectionChange:flagCollection];
}

-(void)CurrencySymbol{
    
    SQLFile *new = [[SQLFile alloc]init];
    NSString *query = [NSString stringWithFormat:@"select Symbol from CurrencyList where Name ='%@'",CName];
    CSymbol = [[new select_currency:query] objectAtIndex:0];
}

- (IBAction)chnageValue:(UISegmentedControl *)sender{
    if (sender.selectedSegmentIndex == 0) {
        segmentId = 0;
        _btnShort.hidden = NO;
        _btnShort1.hidden = NO;
        if (searchEnabled) {
            arrSearchData = [[NSMutableArray alloc]init];
            NSPredicate *resultPredicate = [NSCompoundPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", _searchField.text];

            arrSearchResult = [arrNames filteredArrayUsingPredicate:resultPredicate];
            
            for (int i=0; i<[arrSearchResult count]; i++) {
                NSString *str = [arrSearchResult objectAtIndex:i];
                for ( NSDictionary *dic2 in arrCoinData)
                {
                    if ([[dic2 valueForKey:@"name"] isEqual:str])
                    {
                        [arrSearchData addObject:dic2];
                    }
                }
            }[_tableCoinData reloadData];
        }
        else{
            
            if ([userFlagAPICall integerForKey:@"userFlagAPICall"] != 1) {
                [self APICoinData];
            }
            else
            {
                NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"arrCoinData"];
                arrCoinData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                arrShortedCoinData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                arrSearchResult = [NSMutableArray arrayWithCapacity:[arrCoinData count]];
                [self Names];
                [_tableCoinData reloadData];
            }
        }
    } else {
        _btnShort.hidden = YES;
        _btnShort1.hidden = YES;
        segmentId = 1;
        if (searchEnabled) {
            NSMutableArray *arrFavTemp = [[NSMutableArray alloc]init];
            arrFavTemp = [arrSearchData mutableCopy];
            arrSearchData = [[NSMutableArray alloc]init];
            for (int i = 0 ; i<[arrFavTemp count]; i++) {
                for (int j = 0; j<[arrFavourite count]; j++) {
                    NSMutableDictionary *dictTemp = [arrFavTemp objectAtIndex:i];
                    NSMutableDictionary *dictTempFav = [arrFavourite objectAtIndex:j];
                    if ([[dictTemp valueForKey:@"id"]isEqualToString:[dictTempFav valueForKey:@"CoinID"]]) {
                        [arrSearchData addObject:dictTemp];
                    }
                }
            }
        }
        else{
            NSMutableArray *arrFavTemp = [[NSMutableArray alloc]init];
            arrFavTemp = [arrCoinData mutableCopy];
            arrCoinData = [[NSMutableArray alloc]init];
            for (int i = 0 ; i<[arrFavTemp count]; i++) {
                for (int j = 0; j<[arrFavourite count]; j++) {
                    NSMutableDictionary *dictTemp = [arrFavTemp objectAtIndex:i];
                    NSMutableDictionary *dictTempFav = [arrFavourite objectAtIndex:j];
                    if ([[dictTemp valueForKey:@"id"]isEqualToString:[dictTempFav valueForKey:@"CoinID"]]) {
                        [arrCoinData addObject:dictTemp];
                    }
                }
            }
        }
        [_tableCoinData reloadData];
    }
}

#pragma mark - Retrive Data From Database When User Press Favourite

-(void)getdata
{
    SQLFile *new =[[SQLFile alloc]init];
    NSString *querynew =[NSString stringWithFormat:@"select * from Favourite"];
    arrFavourite = [[NSMutableArray alloc]init];
    arrFavourite =[new select_favou:querynew];
}

-(void)CheckConnection{
    NSString *strError = NSLocalizedString(@"No-Internet Connection", @"");
    
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.messageColor = [UIColor orangeColor];
    style.backgroundColor = [UIColor darkGrayColor];
    [self.view makeToast:strError
                duration:3.0
                position:CSToastPositionBottom
                   style:style];
    
    [CSToastManager setSharedStyle:style];
    [CSToastManager setTapToDismissEnabled:YES];
    [CSToastManager setQueueEnabled:YES];
    
    //[SVProgressHUD dismiss];
    [_tableCoinData jler_removeRefresh];
    self.view.userInteractionEnabled = YES;
}

-(void)APICoinData{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"arrCoinData"];
        arrCoinData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        arrShortedCoinData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        arrSearchResult = [NSMutableArray arrayWithCapacity:[arrCoinData count]];
        [self Names];
        [_tableCoinData reloadData];
    }
    else
    {
        [SVProgressHUD show];
        NSString *strUrl = [NSString stringWithFormat:@"%@%@&limit=%@",API_GET_CURRENCY,CName,CoinsToShow];
        [[ApiCallManager sharedApiCallManager] callAPIWithDelegate:self withURL:strUrl withData:nil andCallBack:CALL_TYPE_GET_CURRENCY];
    }
}

-(void)APIAdData{
    
    NSDictionary *tmp = [[NSDictionary alloc]initWithObjectsAndKeys:
                         @"iOS",@"type",
                         @"com.app.TaroMaroCoins",@"build_id",
                         nil];
    NSError* error;
    NSData* data = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    self.view.userInteractionEnabled = NO;
    
    NSString *strUrl = [NSString stringWithFormat:@"%@",AD_BASE];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    
    requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_AD_BASE];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (searchEnabled) {
        return [arrSearchData count];
    }
    else{
        return [arrCoinData count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     CoinDataTableViewCell *cell = [self.tableCoinData dequeueReusableCellWithIdentifier:@"coincell" forIndexPath:indexPath];
    
    NSMutableDictionary *dictCoinData = [[NSMutableDictionary alloc]init];
    if (searchEnabled) {
        dictCoinData = [arrSearchData objectAtIndex:indexPath.row];
    }
    else{
        dictCoinData = [arrCoinData objectAtIndex:indexPath.row];
    }
    //color
    strTheme = [[NSUserDefaults standardUserDefaults]
                stringForKey:@"theme"];
    
    if ([strTheme isEqualToString:@"1"]) {
        
        [cell.lblStatic1 setTextColor:[UIColor lightGrayColor]];
        [cell.lblStatic2 setTextColor:[UIColor lightGrayColor]];
        [cell.lblStatic3 setTextColor:[UIColor lightGrayColor]];
        [cell.lblStatic4 setTextColor:[UIColor whiteColor]];
        [cell.lblStatic5 setTextColor:[UIColor whiteColor]];
        [cell.lblStatic6 setTextColor:[UIColor whiteColor]];
        
        [cell.lbl1h setTextColor:[UIColor whiteColor]];
        [cell.lbl7d setTextColor:[UIColor whiteColor]];
        [cell.lbl24h setTextColor:[UIColor whiteColor]];
        [cell.lblName setTextColor:[UIColor orangeColor]];
        [cell.lblRank setTextColor:[UIColor whiteColor]];
        [cell.lblPrice setTextColor:[UIColor whiteColor]];
        [cell.lblVolume setTextColor:[UIColor whiteColor]];
        [cell.lblMarketCap setTextColor:[UIColor whiteColor]];
        [cell.viewCoinList setBackgroundColor:[UIColor blackColor]];
        [cell.contentView setBackgroundColor:[UIColor blackColor]];
        [_tableCoinData setBackgroundColor:[UIColor blackColor]];
        [cell.btnFavImage setImage:[UIImage imageNamed:@"DarkbtnNoFav.png"] forState:UIControlStateNormal];
    }
    else{
        [cell.lblStatic1 setTextColor:[UIColor darkGrayColor]];
        [cell.lblStatic2 setTextColor:[UIColor darkGrayColor]];
        [cell.lblStatic3 setTextColor:[UIColor darkGrayColor]];
        [cell.lblStatic4 setTextColor:[UIColor blackColor]];
        [cell.lblStatic5 setTextColor:[UIColor blackColor]];
        [cell.lblStatic6 setTextColor:[UIColor blackColor]];
        
        [cell.lbl1h setTextColor:[UIColor blackColor]];
        [cell.lbl7d setTextColor:[UIColor blackColor]];
        [cell.lbl24h setTextColor:[UIColor blackColor]];
        [cell.lblName setTextColor:[UIColor orangeColor]];
        [cell.lblRank setTextColor:[UIColor blackColor]];
        [cell.lblPrice setTextColor:[UIColor blackColor]];
        [cell.lblVolume setTextColor:[UIColor blackColor]];
        [cell.lblMarketCap setTextColor:[UIColor blackColor]];
        
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
        [cell.viewCoinList setBackgroundColor:[UIColor whiteColor]];
        [_tableCoinData setBackgroundColor:[UIColor whiteColor]];
        
        [cell.btnFavImage setImage:[UIImage imageNamed:@"btnNoFav.png"] forState:UIControlStateNormal];
    }
    
    NSArray *arrTemp = [dictCoinData allKeys];
    
    for (int i = 0; i<[arrTemp count]; i++) {
        if ([[dictCoinData valueForKey:[arrTemp objectAtIndex:i]] isKindOfClass:[NSNull class]]) {
            [dictCoinData setObject:@"N/A" forKey:[arrTemp objectAtIndex:i]];
        }
    }
    
    NSString *Pricekey = [[NSString stringWithFormat:@"price_%@",CName]lowercaseString];
    
    NSString *MarketKey = [[NSString stringWithFormat:@"market_cap_%@",CName]lowercaseString];
    NSNumber *nbrMarketCap = [dictCoinData valueForKey:MarketKey];
    NSString *strMarket = [NSString stringWithFormat:@"%@%@",CSymbol,[self suffixNumber:nbrMarketCap]];
    
    NSString *VolumeKey = [[NSString stringWithFormat:@"24h_volume_%@",CName]lowercaseString];
    NSNumber *nbr24Volume = [dictCoinData valueForKey:VolumeKey];
    NSString *str24h = [NSString stringWithFormat:@"%@%@",CSymbol,[self suffixNumber:nbr24Volume]];
    
    cell.lblRank.text = [dictCoinData valueForKey:@"rank"];
    cell.lblName.text = [NSString stringWithFormat:@"%@ (%@)", [dictCoinData valueForKey:@"name"],[dictCoinData valueForKey:@"symbol"]];
    cell.lblPrice.text = [NSString stringWithFormat:@"%@%@ (฿%.6f)",CSymbol,[dictCoinData valueForKey:Pricekey],[[dictCoinData valueForKey:@"price_btc"]floatValue]];
    cell.lblMarketCap.text = [NSString stringWithFormat:@"%@",strMarket];
    cell.lblVolume.text = [NSString stringWithFormat:@"%@",str24h];
    
    NSString *str1hr = [NSString stringWithFormat:@"%@",[dictCoinData valueForKey:@"percent_change_1h"]];
    NSString *str24hr = [NSString stringWithFormat:@"%@",[dictCoinData valueForKey:@"percent_change_24h"]];
    NSString *str7d = [NSString stringWithFormat:@"%@",[dictCoinData valueForKey:@"percent_change_7d"]];
    
    if ([str1hr containsString:@"-"]) {
        cell.lbl1h.textColor = [UIColor redColor];
        cell.lbl1h.text = [NSString stringWithFormat:@"↓%@%%",[dictCoinData valueForKey:@"percent_change_1h"]];
    }
    else{
        cell.lbl1h.textColor = [UIColor colorWithRed:19.0f/255.0f green:151.0f/255.0f blue:29.0f/255.0f alpha:1.0];
        cell.lbl1h.text = [NSString stringWithFormat:@"↑%@%%",[dictCoinData valueForKey:@"percent_change_1h"]];
    }
    
    if ([str24hr containsString:@"-"]) {
        cell.lbl24h.textColor = [UIColor redColor];
        cell.lbl24h.text = [NSString stringWithFormat:@"↓%@%%",[dictCoinData valueForKey:@"percent_change_24h"]];
    }
    
    else{
        cell.lbl24h.textColor = [UIColor colorWithRed:19.0f/255.0f green:151.0f/255.0f blue:29.0f/255.0f alpha:1.0];
        cell.lbl24h.text = [NSString stringWithFormat:@"↑%@%%",[dictCoinData valueForKey:@"percent_change_24h"]];
    }
    
    if ([str7d containsString:@"-"]) {
        cell.lbl7d.textColor = [UIColor redColor];
        cell.lbl7d.text = [NSString stringWithFormat:@"↓%@%%",[dictCoinData valueForKey:@"percent_change_7d"]];
    }
    else{
        cell.lbl7d.textColor = [UIColor colorWithRed:19.0f/255.0f green:151.0f/255.0f blue:29.0f/255.0f alpha:1.0];
        cell.lbl7d.text = [NSString stringWithFormat:@"↑%@%%",[dictCoinData valueForKey:@"percent_change_7d"]];
    }
    
    [cell.imgCoin startLoaderWithTintColor:[UIColor greenColor]];
    
    NSString *strImgUrl = [NSString stringWithFormat:@"%@%@.png",URL_IMAGE,[dictCoinData valueForKey:@"id"]];
    
    
    [cell.imgCoin sd_setImageWithURL:[NSURL URLWithString:strImgUrl] placeholderImage:[UIImage imageNamed:@"Thumnail.png"] options:SDWebImageCacheMemoryOnly | SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        [cell.imgCoin updateImageDownloadProgress:(CGFloat)receivedSize/expectedSize];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [cell.imgCoin reveal];
    }];
    
    for (int i=0; i<[arrFavourite count]; i++) {
        
        DictSQLFav = [arrFavourite objectAtIndex:i];
        if ([[DictSQLFav valueForKey:@"CoinID"]isEqualToString:[dictCoinData valueForKey:@"id"]]) {
            [cell.btnFavImage setImage:[UIImage imageNamed:@"btnFav.png"] forState:UIControlStateNormal];
        }
    }
    
    [cell.btnFavImage setTag:indexPath.row];
    [cell.btnFavImage addTarget:self action:@selector(Fav:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *dict_new = [[NSMutableDictionary alloc]init];
    if (searchEnabled) {
        dict_new = [arrSearchData objectAtIndex:indexPath.row];
        
    }
    else{
        dict_new = [arrCoinData objectAtIndex:indexPath.row];
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CoinDetailsViewController *coinData = (CoinDetailsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"CoinDetailsViewController"];

    coinData.dictCoinData = dict_new;
    coinData.strCurrencyName = CName;
    [[self navigationController] pushViewController:coinData animated:YES];
}

// Function found at: https://medium.com/ios-os-x-development/enable-slide-to-delete-in-uitableview-9311653dfe2
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     NSMutableDictionary *dict_new = [[NSMutableDictionary alloc]init];
    dict_new = [arrCoinData objectAtIndex:indexPath.row];
    
    NSString *idString = [dict_new valueForKey:@"id"];
    BOOL add = ![widgetCryptoIdArray containsObject:idString];
    
    NSString *title = add ? @"Add to\nwidget!" : @"Remove from\nwidget!";
    
    UITableViewRowAction *addToWidget = [UITableViewRowAction
                                         rowActionWithStyle:UITableViewRowActionStyleNormal
                                         title:title
                                         handler:^(UITableViewRowAction *action, NSIndexPath *indexP) {
                                             
                                             // Legg til eller fjern
                                             if ([widgetCryptoIdArray count] < kMaxWidgets && add) {
                                                 [widgetCryptoIdArray addObject:idString];
                                             } else if (!add) {
                                                 [widgetCryptoIdArray removeObject:idString];
                                             }
                                             
                                             // Oppdater NSUserDefaults
                                             NSData *data = [NSKeyedArchiver archivedDataWithRootObject:widgetCryptoIdArray];
                                             
                                             NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.nestcode.cryptocurrency"];
                                             
                                             [shared setObject:data forKey:@"widgetCryptoIdArray"];
                                             [shared synchronize];
                                             
                                             // "Lukk" raden
                                             [tableView setEditing:NO animated:YES];
                                         }];
    
    // TODO: Sjekk om den er med på widgets allerede (rød farge hvis med fra før, grønn farge hvis ikke med fra før)
    // og om det er plass til flere i widgeten eller ikke
    
    if (add) {
        [addToWidget setBackgroundColor:[UIColor colorWithRed:19.0f/255.0f green:151.0f/255.0f blue:29.0f/255.0f alpha:1.0]];
    } else {
        [addToWidget setBackgroundColor:[UIColor redColor]];
    }
    
    return @[addToWidget];
}

- (void)Fav:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableCoinData];
    NSIndexPath *indexPath = [self.tableCoinData indexPathForRowAtPoint:buttonPosition];
    
    dictforWatch = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *dict_new = [[NSMutableDictionary alloc]init];
    
    if (searchEnabled) {
        dict_new = [arrSearchData objectAtIndex:indexPath.row];
        dictforWatch = [arrSearchData objectAtIndex:indexPath.row];
    }
    else{
        dict_new = [arrCoinData objectAtIndex:indexPath.row];
        dictforWatch = [arrCoinData objectAtIndex:indexPath.row];
    }
    
    NSString *CoinID = [NSString stringWithFormat:@"%@",[dict_new objectForKey:@"id"]];
    SQLFile *new = [[SQLFile alloc]init];
    NSString *querynew =[NSString stringWithFormat:@"select * from Favourite where R_id = '%@'",CoinID];
    NSMutableArray *arrTemp = [[NSMutableArray alloc]init];
    arrTemp =[new select_favou:querynew];
    
        if (arrTemp.count == 1) {
            NSString *removeFav = [NSString stringWithFormat:@"DELETE FROM Favourite WHERE R_id ='%@'",CoinID];

            if ([new operationdb:removeFav]==YES)
            {
                if (segmentId == 1) {
                    [self getdata];
                    NSMutableArray *arrFavTemp = [[NSMutableArray alloc]init];
                    arrFavTemp = [arrCoinData mutableCopy];
                    arrCoinData = [[NSMutableArray alloc]init];
                    for (int i = 0 ; i<arrFavTemp.count; i++) {
                        for (int j = 0; j<[arrFavourite count]; j++) {
                            NSMutableDictionary *dictTemp = [arrFavTemp objectAtIndex:i];
                            NSMutableDictionary *dictTempFav = [arrFavourite objectAtIndex:j];
                            if ([[dictTemp valueForKey:@"id"]isEqualToString:[dictTempFav valueForKey:@"CoinID"]]) {
                                [arrCoinData addObject:dictTemp];
                            }
                        }
                    }
                    [_tableCoinData reloadData];
                }
            }
            
            //            if ([new operationdb:removeFav]==YES)
//            {
//                if (segmentId == 1) {
//                    [self getdata];
//                    NSMutableArray *arrFavTemp = [[NSMutableArray alloc]init];
//                    arrFavTemp = [arrCoinData mutableCopy];
//                    arrCoinData = [[NSMutableArray alloc]init];
//                    for (int i = 0 ; i<[arrFavTemp count]; i++) {
//                        for (int j = 0; j<[arrFavourite count]; j++) {
//                            NSMutableDictionary *dictTemp = [arrFavTemp objectAtIndex:i];
//                            NSMutableDictionary *dictTempFav = [arrFavourite objectAtIndex:j];
//                            if ([[dictTemp valueForKey:@"id"]isEqualToString:[dictTempFav valueForKey:@"CoinID"]]) {
//                                [arrCoinData addObject:dictTemp];
//                            }
//                        }
//                    }
//                    [_tableCoinData reloadData];
//                }
//            }
        }
        else{
            NSString *addtoFav = [NSString stringWithFormat:@"insert into Favourite values(null,'%@')",CoinID];
            if ([new operationdb:addtoFav]==YES)
            {
                CoinID = nil;
            }
        }
    
    
    [self getdata];
    [_tableCoinData reloadData];
}

#pragma mark CollectioView - Data

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"collectCell";
    
    CoinDataCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSMutableDictionary *dict_data = [[NSMutableDictionary alloc]init];
    
    strTheme = [[NSUserDefaults standardUserDefaults]
                stringForKey:@"theme"];
    
    if ([strTheme isEqualToString:@"1"]) {
        [cell.lblName setTextColor:[UIColor whiteColor]];
        [cell.lblShortName setTextColor:[UIColor whiteColor]];
        [cell.contentView setBackgroundColor:[UIColor blackColor]];
        [_collectionCoinData setBackgroundColor:[UIColor blackColor]];
    }
    else{
        [cell.lblName setTextColor:[UIColor blackColor]];
        [cell.lblShortName setTextColor:[UIColor blackColor]];
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
        [_collectionCoinData setBackgroundColor:[UIColor whiteColor]];
    }
    
    if (searchEnabled) {
        dict_data = [arrSearchData objectAtIndex:indexPath.row];
        
    }
    else{
        dict_data = [arrCoinData objectAtIndex:indexPath.row];
    }
    
    NSString *strCoinName = [dict_data valueForKey:@"name"];
    
    if (strCoinName.length <= 15) {
        cell.lblName.text = strCoinName;
    }
    else{
        unsigned long startPosition = 0;
        unsigned long endPosition   = [strCoinName rangeOfString:@" "].location;
        NSRange range = NSMakeRange(startPosition, endPosition - startPosition);
        NSString *subString = [strCoinName substringWithRange:range];
        cell.lblName.text = subString;
    }
    
    cell.lblShortName.text = [NSString stringWithFormat:@"(%@)",[dict_data valueForKey:@"symbol"]];
    
    [cell.imgCoin startLoaderWithTintColor:[UIColor colorWithRed:19.0f/255.0f green:151.0f/255.0f blue:29.0f/255.0f alpha:1.0]];
    
    NSString *strImgUrl = [NSString stringWithFormat:@"%@%@.png",URL_IMAGE,[dict_data valueForKey:@"id"]];
    
    
    [cell.imgCoin sd_setImageWithURL:[NSURL URLWithString:strImgUrl] placeholderImage:[UIImage imageNamed:@"Thumnail.png"] options:SDWebImageCacheMemoryOnly | SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        [cell.imgCoin updateImageDownloadProgress:(CGFloat)receivedSize/expectedSize];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [cell.imgCoin reveal];
    }];
 
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict_new = [[NSMutableDictionary alloc]init];
    
    if (searchEnabled) {
        dict_new = [arrSearchData objectAtIndex:indexPath.row];
        
    }
    else{
        dict_new = [arrCoinData objectAtIndex:indexPath.row];
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CoinDetailsViewController *coinData = (CoinDetailsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"CoinDetailsViewController"];
    coinData.strCurrencyName = CName;
    coinData.dictCoinData = dict_new;
    [[self navigationController] pushViewController:coinData animated:YES];
}

-(void)Names{
    arrNames = [[NSMutableArray alloc]init];
    arrNames = [arrCoinData valueForKey:@"name"];
}

- (IBAction)onSideBarButtonClicked:(id)sender {
    
    [_btnSideBar addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)onCurrencyClicked:(id)sender {
    SQLFile *new = [[SQLFile alloc]init];
    NSString *query = [NSString stringWithFormat:@"select * from CurrencyList"];
    NSMutableArray *arrCurrencyList = [new select_allcurrency:query];
    
    NSMutableDictionary *dictCurrencyList = [[NSMutableDictionary alloc]init];
    
    NSMutableArray *arrCurrency = [[NSMutableArray alloc]init];
    
    for (int i = 0; i< [arrCurrencyList count]; i++) {
        dictCurrencyList = [arrCurrencyList objectAtIndex:i];
        NSString *strTemp = [NSString stringWithFormat:@"%@ - %@",[dictCurrencyList valueForKey:@"CName"],[dictCurrencyList valueForKey:@"CFullName"]];
        [arrCurrency addObject:strTemp];
    }
    NSSortDescriptor *data = [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                           ascending:YES];
    
    [ActionSheetStringPicker showPickerWithTitle:@"Select Currency" rows:arrCurrency initialSelection:selectedCurrency
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
     {
         
         selectedCurrency = (int)selectedIndex;
         [ProgressHUD show:@"Please wait..."];
         unsigned long startPosition = 0;
         unsigned long endPosition   = [selectedValue rangeOfString:@" "].location;
         NSRange range = NSMakeRange(startPosition, endPosition - startPosition);
         NSString *subString = [selectedValue substringWithRange:range];
         NSLog(@"%@",subString);
         
         [[NSUserDefaults standardUserDefaults] setObject:subString forKey:@"CurrencyName"];
         [[NSUserDefaults standardUserDefaults] synchronize];
         
         CName = [[NSUserDefaults standardUserDefaults]
                  stringForKey:@"CurrencyName"];
         [self CurrencySymbol];
         
         [self APICoinData];
         
     }cancelBlock:^(ActionSheetStringPicker *picker)
     {
         
     }origin:sender];
    
}

- (IBAction)onShortingClicked:(id)sender {
    NSArray *arrShort = @[@"Name A-Z", @"Price LH", @"Market Cap LH", @"Change 1h LH", @"Change 24h LH", @"Change 7d LH", @"Volume 24h LH", @"Name Z-A", @"Price", @"Market Cap", @"Change 1h", @"Change 24h", @"Change 7d", @"Volume 24h"];
    
    
    [ActionSheetStringPicker showPickerWithTitle:@"Sort By" rows:arrShort initialSelection:selectedsort
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
     {
         
         NSString *Pricekey = [[NSString stringWithFormat:@"price_%@",CName]lowercaseString];
         
         NSString *MarketKey = [[NSString stringWithFormat:@"market_cap_%@",CName]lowercaseString];
         
         NSString *VolumeKey = [[NSString stringWithFormat:@"24h_volume_%@",CName]lowercaseString];
         
         selectedsort = (int)selectedIndex;
         
         switch (selectedIndex) {
             case 0: //name
             {
                 NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                        ascending:YES selector:@selector(caseInsensitiveCompare:)];
                 NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
                 NSArray *sortedArray = [arrShortedCoinData sortedArrayUsingDescriptors:sortDescriptors];
                 
                 [arrCoinData removeAllObjects];
                 [arrCoinData setArray:sortedArray];
             }
                 break;
             case 1: //price
             {
                 NSSortDescriptor *sortByPrice = [NSSortDescriptor sortDescriptorWithKey:Pricekey
                                                                              ascending:YES selector:@selector(localizedCaseInsensitiveContainsString:)];
                 NSArray *sortDescriptors = [NSArray arrayWithObject:sortByPrice];
                 NSArray *sortedArray = [arrShortedCoinData sortedArrayUsingDescriptors:sortDescriptors];
                 
                 [arrCoinData removeAllObjects];
                 [arrCoinData setArray:sortedArray];
             }
                 break;
             case 2: //marketCap
             {
                 NSSortDescriptor *sortByMarket = [NSSortDescriptor sortDescriptorWithKey:MarketKey
                                                                              ascending:YES selector:@selector(localizedCaseInsensitiveContainsString:)];
                 NSArray *sortDescriptors = [NSArray arrayWithObject:sortByMarket];
                 NSArray *sortedArray = [arrShortedCoinData sortedArrayUsingDescriptors:sortDescriptors];
                 
                 [arrCoinData removeAllObjects];
                 [arrCoinData setArray:sortedArray];
             }
                 break;
             case 3: //chnage 1h
             {
                 NSSortDescriptor *sortByChange1 = [NSSortDescriptor sortDescriptorWithKey:@"percent_change_1h" ascending:YES selector:@selector(localizedCaseInsensitiveContainsString:)];
                 NSArray *sortDescriptors = [NSArray arrayWithObject:sortByChange1];
                 NSArray *sortedArray = [arrShortedCoinData sortedArrayUsingDescriptors:sortDescriptors];
                 
                 [arrCoinData removeAllObjects];
                 [arrCoinData setArray:sortedArray];
             }
                 break;
             case 4: //chnage 24h
             {
                 NSSortDescriptor *sortBychnage24 = [NSSortDescriptor sortDescriptorWithKey:@"percent_change_24h" ascending:YES selector:@selector(localizedCaseInsensitiveContainsString:)];
                 NSArray *sortDescriptors = [NSArray arrayWithObject:sortBychnage24];
                 NSArray *sortedArray = [arrShortedCoinData sortedArrayUsingDescriptors:sortDescriptors];
                 
                 [arrCoinData removeAllObjects];
                 [arrCoinData setArray:sortedArray];
             }
                 break;
             case 5: //change 7d
             {
                 NSSortDescriptor *sortBychnage7 = [NSSortDescriptor sortDescriptorWithKey:@"percent_change_7d" ascending:YES selector:@selector(localizedCaseInsensitiveContainsString:)];
                 NSArray *sortDescriptors = [NSArray arrayWithObject:sortBychnage7];
                 NSArray *sortedArray = [arrShortedCoinData sortedArrayUsingDescriptors:sortDescriptors];
                 
                 [arrCoinData removeAllObjects];
                 [arrCoinData setArray:sortedArray];
             }
                 break;
             case 6: //volume
             {
                 NSSortDescriptor *sortByVolume = [NSSortDescriptor sortDescriptorWithKey:VolumeKey
                                                                              ascending:YES selector:@selector(localizedCaseInsensitiveContainsString:)];
                 NSArray *sortDescriptors = [NSArray arrayWithObject:sortByVolume];
                 NSArray *sortedArray = [arrShortedCoinData sortedArrayUsingDescriptors:sortDescriptors];
                 
                 [arrCoinData removeAllObjects];
                 [arrCoinData setArray:sortedArray];
             }
                 break;
             case 7://name LH
             {
                 NSSortDescriptor *sortByNameLH = [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                              ascending:NO selector:@selector(caseInsensitiveCompare:)];
                 NSArray *sortDescriptors = [NSArray arrayWithObject:sortByNameLH];
                 NSArray *sortedArray = [arrShortedCoinData sortedArrayUsingDescriptors:sortDescriptors];
                 
                 [arrCoinData removeAllObjects];
                 [arrCoinData setArray:sortedArray];
             }
                 break;
             case 8: //price LH
             {
                 NSSortDescriptor *sortByPriceLH = [NSSortDescriptor sortDescriptorWithKey:Pricekey
                                                                               ascending:NO selector:@selector(localizedCaseInsensitiveContainsString:)];
                 NSArray *sortDescriptors = [NSArray arrayWithObject:sortByPriceLH];
                 NSArray *sortedArray = [arrShortedCoinData sortedArrayUsingDescriptors:sortDescriptors];
                 
                 [arrCoinData removeAllObjects];
                 [arrCoinData setArray:sortedArray];
             }
                 break;
             case 9: //Market LH
             {
                 NSSortDescriptor *sortByMarketLH = [NSSortDescriptor sortDescriptorWithKey:MarketKey
                                                                                ascending:NO selector:@selector(localizedCaseInsensitiveContainsString:)];
                 NSArray *sortDescriptors = [NSArray arrayWithObject:sortByMarketLH];
                 NSArray *sortedArray = [arrShortedCoinData sortedArrayUsingDescriptors:sortDescriptors];
                 
                 [arrCoinData removeAllObjects];
                 [arrCoinData setArray:sortedArray];
             }
                 break;
             case 10: //Change 1LH
             {
                 NSSortDescriptor *sortByChange1LH = [NSSortDescriptor sortDescriptorWithKey:@"percent_change_1h" ascending:NO selector:@selector(localizedCaseInsensitiveContainsString:)];
                 NSArray *sortDescriptors = [NSArray arrayWithObject:sortByChange1LH];
                 NSArray *sortedArray = [arrShortedCoinData sortedArrayUsingDescriptors:sortDescriptors];
                 
                 [arrCoinData removeAllObjects];
                 [arrCoinData setArray:sortedArray];
             }
                 break;
             case 11:  //Change 24LH
             {
                 NSSortDescriptor *sortBychnage24LH = [NSSortDescriptor sortDescriptorWithKey:@"percent_change_24h" ascending:NO selector:@selector(localizedCaseInsensitiveContainsString:)];
                 NSArray *sortDescriptors = [NSArray arrayWithObject:sortBychnage24LH];
                 NSArray *sortedArray = [arrShortedCoinData sortedArrayUsingDescriptors:sortDescriptors];
                 
                 [arrCoinData removeAllObjects];
                 [arrCoinData setArray:sortedArray];
             }
                 break;
             case 12: //Change 7LH
             {
                 NSSortDescriptor *sortBychnage7LH = [NSSortDescriptor sortDescriptorWithKey:@"percent_change_7d" ascending:NO selector:@selector(localizedCaseInsensitiveContainsString:)];
                 NSArray *sortDescriptors = [NSArray arrayWithObject:sortBychnage7LH];
                 NSArray *sortedArray = [arrShortedCoinData sortedArrayUsingDescriptors:sortDescriptors];
                 
                 [arrCoinData removeAllObjects];
                 [arrCoinData setArray:sortedArray];
             }
                 break;
             case 13: //volume LH
             {
                 NSSortDescriptor *sortByVolumeLH = [NSSortDescriptor sortDescriptorWithKey:VolumeKey
                                                                                ascending:NO selector:@selector(localizedCaseInsensitiveContainsString:)];
                 NSArray *sortDescriptors = [NSArray arrayWithObject:sortByVolumeLH];
                 NSArray *sortedArray = [arrShortedCoinData sortedArrayUsingDescriptors:sortDescriptors];
                 
                 [arrCoinData removeAllObjects];
                 [arrCoinData setArray:sortedArray];
             }
                 break;
                 
             default:
                 break;
         }
         
         [_tableCoinData reloadData];
         //[_collectionCoinData reloadData];
         
     }cancelBlock:^(ActionSheetStringPicker *picker)
     {
         
     }origin:sender];
}

-(NSString*) suffixNumber:(NSNumber*)number
{
    if (!number)
        return @"";
    
    long long num = [number longLongValue];
    
    int s = ( (num < 0) ? -1 : (num > 0) ? 1 : 0 );
    NSString* sign = (s == -1 ? @"-" : @"" );
    
    num = llabs(num);
    
    if (num < 1000)
        return [NSString stringWithFormat:@"%@%lld",sign,num];
    
    int exp = (int) (log10l(num) / 3.f); //log10l(1000));
    
    NSArray* units = @[@"K",@"Million",@"Billion",@"Trillion",@"Quadrillion"];
    
    return [NSString stringWithFormat:@"%@%.2f %@",sign, (num / pow(1000, exp)), [units objectAtIndex:(exp-1)]];
}

- (IBAction)onSearchClicked:(id)sender {
    _viewSearch.hidden = NO;
}

- (IBAction)onCloseClicked:(id)sender {
    _viewSearch.hidden = YES;
    [_searchField setText:@""];
    searchEnabled = NO;
    
    [self.view endEditing:YES];
    
    if (segmentId == 1) {
        [self getdata];
        NSMutableArray *arrFavTemp = [[NSMutableArray alloc]init];
        arrFavTemp = [arrCoinData mutableCopy];
        arrCoinData = [[NSMutableArray alloc]init];
        for (int i = 0 ; i<[arrFavTemp count]; i++) {
            for (int j = 0; j<[arrFavourite count]; j++) {
                NSMutableDictionary *dictTemp = [arrFavTemp objectAtIndex:i];
                NSMutableDictionary *dictTempFav = [arrFavourite objectAtIndex:j];
                if ([[dictTemp valueForKey:@"id"]isEqualToString:[dictTempFav valueForKey:@"CoinID"]]) {
                    [arrCoinData addObject:dictTemp];
                }
            }
        }
        NSLog(@"%@",arrCoinData);
        [_tableCoinData reloadData];
        //[_collectionCoinData reloadData];
    }
        else{
            if ([userFlagAPICall integerForKey:@"userFlagAPICall"] != 1) {
                [self APICoinData];
            }
            else
            {
                NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"arrCoinData"];
                arrCoinData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                arrShortedCoinData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                
                arrSearchResult = [NSMutableArray arrayWithCapacity:[arrCoinData count]];
                [self Names];
                
                [_tableCoinData reloadData];
                //[_collectionCoinData reloadData];
            }
        }
}

- (void)filterContentForSearchText:(NSString*)searchText
{
    arrSearchData = [[NSMutableArray alloc]init];
    NSPredicate *resultPredicate = [NSCompoundPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchText];
    
    
    arrSearchResult = [arrNames filteredArrayUsingPredicate:resultPredicate];

    for (int i=0; i<[arrSearchResult count]; i++) {
        NSString *str = [arrSearchResult objectAtIndex:i];
        for ( NSDictionary *dic2 in arrCoinData)
        {
            if ([[dic2 valueForKey:@"name"] isEqual:str])
            {
                [arrSearchData addObject:dic2];
               // NSLog(@"Result: %@",arrSearchData);
            }
        }
    }
    NSLog(@"%@",arrCoinData);
    [_tableCoinData reloadData];
    //[_collectionCoinData reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text.length == 0) {
        searchEnabled = NO;
      //[self.tableCoinData reloadData];
    }
    else {
        searchEnabled = YES;
        [self filterContentForSearchText:searchBar.text];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchEnabled = YES;
    [self filterContentForSearchText:searchBar.text];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setText:@""];
    searchEnabled = NO;
    [_tableCoinData reloadData];
    //[_collectionCoinData reloadData];
}

#pragma mark - ApiCallManagerDelegate

- (void)parserDidFailWithError:(NSError *)error andCallType:(CallTypeEnum)callType{
    NSLog(@"%s : Error : %@",__FUNCTION__, [error localizedDescription]);
}

- (void)parserSuccessDelegateDidFinish:(NSDictionary *)dictResult andCallType:(CallTypeEnum)callType{
    [_tableCoinData jler_removeRefresh];
    
    if (callType == CALL_TYPE_GET_CURRENCY)
    {
        arrCoinDataTemp = [dictResult mutableCopy];
        arrShortedCoinDataTemp = [dictResult mutableCopy];
        [self getdata];
        
            if (arrCoinDataTemp.count > 0)
            {
                //Store to NsuserDefault
                [self AutoCallAPIBackground];

                [userFlagAPICall setInteger:1 forKey:@"userFlagAPICall"];
                [userFlagAPICall synchronize];
                NSData *dataSave = [NSKeyedArchiver archivedDataWithRootObject:arrCoinDataTemp];
                [userOfflineCoinData setObject:dataSave forKey:@"arrCoinData"];
                [userOfflineCoinData synchronize];
                //Fetch from NsuserDefault
                NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"arrCoinData"];
                arrCoinData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                arrShortedCoinData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            }
            else
            {
                NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"arrCoinData"];
                arrCoinData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                arrShortedCoinData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            }
        
        arrSearchResult = [NSMutableArray arrayWithCapacity:[arrCoinData count]];
        [self Names];
        
        if (segmentId == 1) {
            NSMutableArray *arrFavTemp = [[NSMutableArray alloc]init];
            arrFavTemp = [arrCoinData mutableCopy];
            arrCoinData = [[NSMutableArray alloc]init];
            for (int i = 0 ; i<[arrFavTemp count]; i++) {
                for (int j = 0; j<[arrFavourite count]; j++) {
                    NSMutableDictionary *dictTemp = [arrFavTemp objectAtIndex:i];
                    NSMutableDictionary *dictTempFav = [arrFavourite objectAtIndex:j];
                    if ([[dictTemp valueForKey:@"id"]isEqualToString:[dictTempFav valueForKey:@"CoinID"]]) {
                        [arrCoinData addObject:dictTemp];
                    }
                }
            }
        }
        [SVProgressHUD dismiss];
        [ProgressHUD dismiss];
        [_tableCoinData reloadData];
    }
}


- (void)requestHandler:(HTTPRequestHandler *)requestHandler didFinishWithData:(NSData *)data andCallBack:(CallTypeEnum)callType
{
    self.view.userInteractionEnabled = YES;
    
    
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *jsonRes = [response JSONValue];
    
    if ([[jsonRes valueForKey:@"message"] isEqualToString:@"Unauthenticated."]) {
        //  [SVProgressHUD dismiss];
        //  [isLogin setInteger:0 forKey:@"LoggedIn"];
        //  [isLogin synchronize];
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Error"
                                     message:@"Unauthenticated"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //[self performSegueWithIdentifier:@"hometoLogout" sender:self];
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    else  {
        [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_AD_BASE];
        NSLog(@"%@",jsonRes);
        
        if ([[jsonRes valueForKey:@"status"]  isEqualToString:@"error"]) {
    
        }
        else{
            NSDictionary *dictTemp = [[NSDictionary alloc]init];
            dictTemp = [jsonRes valueForKey:@"data"];
            NSDictionary *dictAdvrt = [[NSDictionary alloc]init];
            NSMutableArray *arrPersonalAdvrt = [[NSMutableArray alloc]init];
            dictAdvrt = [dictTemp valueForKey:@"advertisement_detail"];
            arrPersonalAdvrt = [dictTemp valueForKey:@"personal_ads"];
            
            if ([[dictAdvrt valueForKey:@"rewarded_id"] isKindOfClass:[NSNull class]]) {
                [dictAdvrt setValue:@"N/A" forKey:@"rewarded_id"];
            }
            [AdvertData setObject:dictAdvrt forKey:@"AdvertData"];
            [AdvertData synchronize];
            
            NSUserDefaults *googleAdID = [NSUserDefaults standardUserDefaults];
            [googleAdID setValue:[dictAdvrt valueForKey:@"google_app_id"] forKey:@"googleAdID"];
            [googleAdID synchronize];
            
            NSString *strIsBanner = [NSString stringWithFormat:@"%@",[[dictAdvrt objectForKey:@"display_type"]valueForKey:@"Banner"]];
            NSString *strIsFull = [NSString stringWithFormat:@"%@",[[dictAdvrt objectForKey:@"display_type"]valueForKey:@"Fullscreen"]];
            NSString *strInterval = [NSString stringWithFormat:@"%@",[dictAdvrt valueForKey:@"fullscreen_showtime"]];
            NSString *strBanner = [NSString stringWithFormat:@"%@",[dictAdvrt valueForKey:@"banner_id"]];
            NSString *strFull = [NSString stringWithFormat:@"%@",[dictAdvrt valueForKey:@"fullscreen_id"]];
            
            [isBanner setInteger:[strIsBanner integerValue] forKey:@"isBanner"];
            [isFullScreen setInteger:[strIsFull integerValue] forKey:@"isFullScreen"];
            [Interval setInteger:[strInterval integerValue] forKey:@"Interval"];
            [bannerID setValue:strBanner forKey:@"bannerID"];
            [FullID setValue:strFull forKey:@"FullID"];
            [isBanner synchronize];
            [isFullScreen synchronize];
            [Interval synchronize];
            [bannerID synchronize];
            [FullID synchronize];
            
            NSDictionary *dictVersion = [dictTemp valueForKey:@"version_detail"];
            NSString *strUpdate = [dictVersion valueForKey:@"app_force_update"];
            NSString *strUpdateVersion = [dictVersion valueForKey:@"app_version"];
            NSString *strUpdateLog = [dictVersion valueForKey:@"change_log"];
            NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            NSString *AppLink = [NSString stringWithFormat:@"%@",[dictTemp valueForKey:@"app_link"]];
          
                if ([strUpdateVersion compare:version options:NSNumericSearch] == NSOrderedDescending) {
                    if ([strUpdate isEqualToString:@"No"]) {
                        SCLAlertView *alert = [[SCLAlertView alloc] init];
                        [alert addButton:@"OK" actionBlock:^(void) {
                        }];
                        [alert showWarning:self.parentViewController title:@"Update Alert!!" subTitle:strUpdateLog closeButtonTitle:nil duration:0.0f];
                    }
                    else{
                        SCLAlertView *alert = [[SCLAlertView alloc] init];
                        [alert addButton:@"OK" actionBlock:^(void) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: AppLink]];
                        }];
                        [alert showWarning:self.parentViewController title:@"Update Alert!!" subTitle:strUpdateLog closeButtonTitle:nil duration:0.0f];
                }
            }
        }
    }
}



- (IBAction)onSliderCloseClicked:(id)sender {
     _viewImagesDemo.hidden = YES;
}




@end
