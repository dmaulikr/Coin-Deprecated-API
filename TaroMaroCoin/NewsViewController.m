//
//  NewsViewController.m
//  TaroMaroCoin
//
//  Created by nestcode on 3/9/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import "NewsViewController.h"

@interface NewsViewController ()

@end

@implementation NewsViewController{
    NSMutableArray *arrNewsData;
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
    arrNewsData = [[NSMutableArray alloc]init];

    
    [self APINewsData];
    
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
    }
    else{
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0];
        [self.view  setBackgroundColor:[UIColor whiteColor]];
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



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrNewsData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsTableViewCell *cell = [self.tableNewsData dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:indexPath];
    
    if ([strTheme isEqualToString:@"1"]) {
        [_tableNewsData setBackgroundColor:[UIColor blackColor]];
        [cell.contentView setBackgroundColor:[UIColor blackColor]];
        [cell.lblNewsCompanyName setTextColor:[UIColor whiteColor]];
        [cell.lblNewsDesc setTextColor:[UIColor whiteColor]];
        [cell.lblNewsTitle setTextColor:[UIColor orangeColor]];
        [cell.lblDate setTextColor:[UIColor orangeColor]];
        [cell.viewNewsCell setBackgroundColor:[UIColor blackColor]];
    }
    else{
        [_tableNewsData setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
        [cell.lblNewsCompanyName setTextColor:[UIColor blackColor]];
        [cell.lblNewsDesc setTextColor:[UIColor blackColor]];
        [cell.lblNewsTitle setTextColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        [cell.lblDate setTextColor:[UIColor blackColor]];
        [cell.viewNewsCell setBackgroundColor:[UIColor whiteColor]];
    }
    
    NSMutableDictionary *dictNewsData = [[NSMutableDictionary alloc]init];
    dictNewsData = [arrNewsData objectAtIndex:indexPath.row];
    
    cell.lblNewsTitle.text = [dictNewsData valueForKey:@"title"];
    cell.lblNewsDesc.text = [dictNewsData valueForKey:@"body"];
    
    double unixTimeStamp =[[dictNewsData objectForKey:@"published_on"]doubleValue];
    NSTimeInterval _interval=unixTimeStamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"dd-MMM-yy HH:mm"];
    NSString *dateString = [formatter stringFromDate:date];
    
    cell.lblDate.text = [NSString stringWithFormat:@"%@",dateString];
    
    NSString *strNewsImageURL = [dictNewsData valueForKey:@"imageurl"];
    [cell.imgNewsImage sd_setImageWithURL:[NSURL URLWithString:strNewsImageURL] placeholderImage:[UIImage imageNamed:@"Thumnail.png"] options:SDWebImageCacheMemoryOnly | SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        [cell.imgNewsImage updateImageDownloadProgress:(CGFloat)receivedSize/expectedSize];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [cell.imgNewsImage reveal];
    }];
    
    
    NSMutableDictionary *DictImage = [dictNewsData valueForKey:@"source_info"];
    NSString *strImg = [DictImage valueForKey:@"img"];
    
    cell.lblNewsCompanyName.text = [DictImage valueForKey:@"name"];
    
    [cell.imgNewsCompany sd_setImageWithURL:[NSURL URLWithString:strImg] placeholderImage:[UIImage imageNamed:@"Thumnail.png"] options:SDWebImageCacheMemoryOnly | SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        [cell.imgNewsCompany updateImageDownloadProgress:(CGFloat)receivedSize/expectedSize];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [cell.imgNewsCompany reveal];
    }];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *dict_new = [[NSMutableDictionary alloc]init];
        dict_new = [arrNewsData objectAtIndex:indexPath.row];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NewsDetailViewController *NewsData = (NewsDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"NewsDetailViewController"];
    
    NewsData.strNewsURL = [dict_new valueForKey:@"url"];
    
    [[self navigationController] pushViewController:NewsData animated:YES];
    
}

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

-(void)APINewsData{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        [SVProgressHUD show];
        
        NSString *strUrl = [NSString stringWithFormat:@"%@",URL_NEWS];
        
        [[ApiCallManager sharedApiCallManager] callAPIWithDelegate:self withURL:strUrl withData:nil andCallBack:CALL_TYPE_URL_NEWS];
    }
}

#pragma mark - ApiCallManagerDelegate

- (void)parserDidFailWithError:(NSError *)error andCallType:(CallTypeEnum)callType{
    NSLog(@"%s : Error : %@",__FUNCTION__, [error localizedDescription]);
}

- (void)parserSuccessDelegateDidFinish:(NSDictionary *)dictResult andCallType:(CallTypeEnum)callType{
    [SVProgressHUD dismiss];
    if (callType == CALL_TYPE_URL_NEWS){
        arrNewsData = [dictResult mutableCopy];
        NSLog(@"%@",arrNewsData);
        [_tableNewsData reloadData];
    }
}

@end
