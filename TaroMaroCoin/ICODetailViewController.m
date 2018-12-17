//
//  ICODetailViewController.m
//  TaroMaroCoin
//
//  Created by nestcode on 3/10/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import "ICODetailViewController.h"

@interface ICODetailViewController ()

@end

@implementation ICODetailViewController{
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
    
    [SVProgressHUD show];
    [SVProgressHUD setBackgroundColor:[UIColor grayColor]];
    
    _WebNewsDetail.delegate = self;
    _WebICOWatch.delegate = self;
    
    NSURL *url = [NSURL URLWithString:self.strNewsURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.WebNewsDetail.allowsInlineMediaPlayback = YES;
    [_WebNewsDetail loadRequest:request];
    
    NSURL *urlICO = [NSURL URLWithString:self.strICOURL];
    NSURLRequest *requestICO = [NSURLRequest requestWithURL:urlICO];
    self.WebICOWatch.allowsInlineMediaPlayback = YES;
    [_WebICOWatch loadRequest:requestICO];
    
    _WebICOWatch.hidden = YES;
    
    strTheme = [[NSUserDefaults standardUserDefaults]
                stringForKey:@"theme"];
    
    if ([strTheme isEqualToString:@"1"]) {
        self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
        [_ICOSegment setTintColor:[UIColor orangeColor]];
        [_ICOSegment setBackgroundColor:[UIColor blackColor]];
    }
    else{
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0];
        [_ICOSegment setTintColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        [_ICOSegment setBackgroundColor:[UIColor whiteColor]];
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




- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //Check here if still webview is loding the content
    if (webView.isLoading)
        return;
    
    //after code when webview finishes
    [SVProgressHUD dismiss];
    NSLog(@"Webview loding finished");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
}

- (IBAction)SegmentChanged:(id)sender {
    switch ([sender selectedSegmentIndex]) {
        case 0:
            _WebICOWatch.hidden = YES;
            _WebNewsDetail.hidden = NO;
            break;
        case 1:
            _WebICOWatch.hidden = NO;
            _WebNewsDetail.hidden = YES;
            break;
        default:
            _WebICOWatch.hidden = YES;
            _WebNewsDetail.hidden = NO;
            break;
    }
}
@end
