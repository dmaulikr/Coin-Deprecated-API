//
//  ICOsViewController.m
//  TaroMaroCoin
//
//  Created by nestcode on 3/9/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import "ICOsViewController.h"

@interface ICOsViewController ()

@end

@implementation ICOsViewController{
    NSMutableArray *arrICOData;
    NSString *strType;
    NSString *strTheme;
    NSInteger m;
    NSUserDefaults *Visited1;
    NSUserDefaults *isBanner, *isFullScreen, *Interval, *bannerID, *FullID;
    NSString *strBanner, *strFull;
}
@synthesize BannerView = BannerView_;
@synthesize interstitial = InterstitialView_;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ApiICOLiveData];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    strTheme = [[NSUserDefaults standardUserDefaults]
                stringForKey:@"theme"];
    
    if ([strTheme isEqualToString:@"1"]) {
        self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
         [self.view  setBackgroundColor:[UIColor blackColor]];
        [_SegmentICOType setTintColor:[UIColor orangeColor]];
        [_SegmentICOType setBackgroundColor:[UIColor blackColor]];
    }
    else{
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0];
        [self.view  setBackgroundColor:[UIColor whiteColor]];
        [_SegmentICOType setTintColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        [_SegmentICOType setBackgroundColor:[UIColor whiteColor]];
    }
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


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    isBanner = [NSUserDefaults standardUserDefaults];
    isFullScreen = [NSUserDefaults standardUserDefaults];
    Interval = [NSUserDefaults standardUserDefaults];
    bannerID = [NSUserDefaults standardUserDefaults];
    FullID = [NSUserDefaults standardUserDefaults];
    
    strBanner = [bannerID valueForKey:@"bannerID"];
    strFull = [FullID valueForKey:@"FullID"];
    
    NSInteger isBannerActive = [isBanner integerForKey:@"isBanner"];
    if (isBannerActive == 1) {
        [self createAdBannerView];
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
    // request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID, nil];
    return request;
}

-(void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"Ad Received");
}

-(void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Failed to receive ad due to: %@", [error localizedFailureReason]);
}




- (IBAction)segmentChanged:(id)sender {
    switch ([sender selectedSegmentIndex]) {
        case 0:
            [self ApiICOLiveData];
            break;
        case 1:
            [self ApiICOCominData];
            break;
        case 2:
            [self ApiICOFinishedData];
            break;
        default:
            [self ApiICOLiveData];
            break;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrICOData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ICOsTableViewCell *cell = [self.tableICOData dequeueReusableCellWithIdentifier:@"ICOCell" forIndexPath:indexPath];
    
    NSMutableDictionary *dictICOData = [[NSMutableDictionary alloc]init];
    dictICOData = [arrICOData objectAtIndex:indexPath.row];
    
    cell.lblLIVECoinName.text = [dictICOData valueForKey:@"name"];
    cell.lblLIVECoinDesc.text = [dictICOData valueForKey:@"description"];
    cell.lblLIVECoinStart.text = [NSString stringWithFormat:@"%@",[dictICOData valueForKey:@"start_time"]];
    cell.lblLIVECoinEnd.text = [NSString stringWithFormat:@"%@",[dictICOData valueForKey:@"end_time"]];
    
    NSString *strImg = [dictICOData valueForKey:@"image"];
    [cell.imgLIVECoin sd_setImageWithURL:[NSURL URLWithString:strImg] placeholderImage:[UIImage imageNamed:@"Thumnail.png"] options:SDWebImageCacheMemoryOnly | SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        [cell.imgLIVECoin updateImageDownloadProgress:(CGFloat)receivedSize/expectedSize];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [cell.imgLIVECoin reveal];
    }];
    
    if ([strType isEqualToString:@"live"]) {
        cell.lblStaticStart.text = @"Started on:";
        cell.lblStaticEnd.text = @"Ends on:";
    }
    else if ([strType isEqualToString:@"upcoming"]){
        cell.lblStaticStart.text = @"Will Start on:";
        cell.lblStaticEnd.text = @"Ends on:";
    }else{
        cell.lblStaticStart.text = @"Started on:";
        cell.lblStaticEnd.text = @"Ended on:";
    }
    
    if ([strTheme isEqualToString:@"1"]) {
        [_tableICOData setBackgroundColor:[UIColor blackColor]];
        [cell.contentView setBackgroundColor:[UIColor blackColor]];
        [cell.lblStaticEnd setTextColor:[UIColor orangeColor]];
        [cell.lblStaticStart setTextColor:[UIColor orangeColor]];
        [cell.lblLIVECoinEnd setTextColor:[UIColor whiteColor]];
        [cell.lblLIVECoinDesc setTextColor:[UIColor whiteColor]];
        [cell.lblLIVECoinName setTextColor:[UIColor orangeColor]];
        [cell.lblLIVECoinStart setTextColor:[UIColor whiteColor]];
        [cell.viewLiveICO setBackgroundColor:[UIColor blackColor]];
        
    }
    else{
        [_tableICOData setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
        [cell.lblStaticEnd setTextColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        [cell.lblStaticStart setTextColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        [cell.lblLIVECoinEnd setTextColor:[UIColor blackColor]];
        [cell.lblLIVECoinDesc setTextColor:[UIColor blackColor]];
        [cell.lblLIVECoinName setTextColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        [cell.lblLIVECoinStart setTextColor:[UIColor blackColor]];
        [cell.viewLiveICO setBackgroundColor:[UIColor whiteColor]];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 170;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *dict_new = [[NSMutableDictionary alloc]init];
    dict_new = [arrICOData objectAtIndex:indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ICODetailViewController *ICOData = (ICODetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ICODetailViewController"];
    
    ICOData.strNewsURL = [dict_new valueForKey:@"website_link"];
    ICOData.strICOURL = [dict_new valueForKey:@"icowatchlist_url"];
    
    [[self navigationController] pushViewController:ICOData animated:YES];
    
}

#pragma mark - API Calls

-(void)CheckConnection{
    NSString *strError = NSLocalizedString(@"Device is not connected to Internet!! Please connect to the Internet and try again!!", @"");
    NSString *strAlert = NSLocalizedString(@"Alert!!", @"");
    UIAlertController * alertController1 = [UIAlertController alertControllerWithTitle: strAlert
                                                                               message: strError
                                                                        preferredStyle:UIAlertControllerStyleAlert];
    [alertController1 addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    [self presentViewController:alertController1 animated:YES completion:nil];
    //  [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
}

-(void)ApiICOLiveData{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        [SVProgressHUD show];
        
        NSString *strUrl = [NSString stringWithFormat:@"%@live",ICO_URL];
        
        [[ApiCallManager sharedApiCallManager] callAPIWithDelegate:self withURL:strUrl withData:nil andCallBack:CALL_TYPE_URL_NEWS];
        strType = @"live";
    }
}

-(void)ApiICOCominData{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        [SVProgressHUD show];
        
        NSString *strUrl = [NSString stringWithFormat:@"%@upcoming",ICO_URL];
        
        [[ApiCallManager sharedApiCallManager] callAPIWithDelegate:self withURL:strUrl withData:nil andCallBack:CALL_TYPE_URL_NEWS];
        strType = @"upcoming";
    }
}

-(void)ApiICOFinishedData{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        [SVProgressHUD show];
        
        NSString *strUrl = [NSString stringWithFormat:@"%@finished",ICO_URL];
        
        [[ApiCallManager sharedApiCallManager] callAPIWithDelegate:self withURL:strUrl withData:nil andCallBack:CALL_TYPE_URL_NEWS];
        
        strType = @"finished";
        
    }
}

#pragma mark - ApiCallManagerDelegate

- (void)parserDidFailWithError:(NSError *)error andCallType:(CallTypeEnum)callType{
    NSLog(@"%s : Error : %@",__FUNCTION__, [error localizedDescription]);
}

- (void)parserSuccessDelegateDidFinish:(NSDictionary *)dictResult andCallType:(CallTypeEnum)callType{
    [SVProgressHUD dismiss];
    if (callType == CALL_TYPE_URL_NEWS){
        
        arrICOData = [[NSMutableArray alloc]init];
        
        NSMutableDictionary *dictICO = [dictResult valueForKey:@"ico"];
        if ([strType isEqualToString:@"live"]) {
            arrICOData = [dictICO valueForKey:@"live"];
        }
        else if ([strType isEqualToString:@"upcoming"]){
            arrICOData = [dictICO valueForKey:@"upcoming"];
        }else{
            arrICOData = [dictICO valueForKey:@"finished"];
        }
        [_tableICOData reloadData];
    }
}

@end
