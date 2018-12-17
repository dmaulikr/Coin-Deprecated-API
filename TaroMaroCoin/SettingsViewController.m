//
//  SettingsViewController.m
//  TaroMaroCoin
//
//  Created by nestcode on 3/9/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController{
    int selectedCurrency;
    NSInteger m;
    NSUserDefaults *Visited1;
    NSUserDefaults *isBanner, *isFullScreen, *Interval, *bannerID, *FullID;
    NSString *strBanner, *strFull;
}
@synthesize BannerView = BannerView_;
@synthesize interstitial = InterstitialView_;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lblCurrencyName.text = [[NSUserDefaults standardUserDefaults]
                             stringForKey:@"CurrencyName"];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
   NSString *strTheme = [[NSUserDefaults standardUserDefaults]
                stringForKey:@"theme"];
    
    if ([strTheme isEqualToString:@"1"]) {
        [self.view setBackgroundColor:[UIColor blackColor]];
        [_lblStatic1 setTextColor:[UIColor orangeColor]];
        [_lblStatic2 setTextColor:[UIColor whiteColor]];
        [_lblStatic3 setTextColor:[UIColor whiteColor]];
        [_lblStatic4 setTextColor:[UIColor orangeColor]];
        [_lblStatic5 setTextColor:[UIColor whiteColor]];
        [_lblCurrencyName setTextColor:[UIColor whiteColor]];
        
        [_lblCoinsToDisplay setTextColor:[UIColor whiteColor]];
        [_switchonoff setThumbTintColor:[UIColor orangeColor]];
        
        [_switchonoff setOn:YES];
        
        self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
    }
    else{
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
        [_switchonoff setThumbTintColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        
        [_lblStatic1 setTextColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        [_lblStatic2 setTextColor:[UIColor blackColor]];
        [_lblStatic3 setTextColor:[UIColor blackColor]];
        [_lblStatic4 setTextColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        [_lblStatic5 setTextColor:[UIColor blackColor]];
        [_lblCurrencyName setTextColor:[UIColor blackColor]];
        [_lblCoinsToDisplay setTextColor:[UIColor blackColor]];
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0];
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

- (IBAction)onCurrencySelected:(id)sender {
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
         
         unsigned long startPosition = 0;
         unsigned long endPosition   = [selectedValue rangeOfString:@" "].location;
         NSRange range = NSMakeRange(startPosition, endPosition - startPosition);
         NSString *subString = [selectedValue substringWithRange:range];
         NSLog(@"%@",subString);
         
         [[NSUserDefaults standardUserDefaults] setObject:subString forKey:@"CurrencyName"];
         [[NSUserDefaults standardUserDefaults] synchronize];
    
         _lblCurrencyName.text = selectedValue;
         
     }cancelBlock:^(ActionSheetStringPicker *picker)
     {
         
     }origin:sender];
}

- (IBAction)onCoinsToDisplaySelected:(id)sender {
    
    NSArray *arrCoinShow = @[@"10",@"20",@"50",@"100",@"150",@"200",@"ALL"];
    
    [ActionSheetStringPicker showPickerWithTitle:@"Coins to Display" rows:arrCoinShow initialSelection:selectedCurrency
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
     {
         
         selectedCurrency = (int)selectedIndex;
         _lblCoinsToDisplay.text = selectedValue;
         
         if (selectedIndex == 6) {
             selectedValue = @"0";
         }
         
         [[NSUserDefaults standardUserDefaults] setObject:selectedValue forKey:@"CoinsToShow"];
         [[NSUserDefaults standardUserDefaults] synchronize];
         
         
     }cancelBlock:^(ActionSheetStringPicker *picker)
     {
         
     }origin:sender];
    
}
- (IBAction)onThemeClicked:(id)sender {
    if([sender isOn]){
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"theme"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.view setBackgroundColor:[UIColor blackColor]];
        
        [_lblStatic1 setTextColor:[UIColor orangeColor]];
        [_lblStatic2 setTextColor:[UIColor whiteColor]];
        [_lblStatic3 setTextColor:[UIColor whiteColor]];
        [_lblStatic4 setTextColor:[UIColor orangeColor]];
        [_lblStatic5 setTextColor:[UIColor whiteColor]];
        [_lblCurrencyName setTextColor:[UIColor whiteColor]];
        
        [_lblCoinsToDisplay setTextColor:[UIColor whiteColor]];
        
        [_switchonoff setThumbTintColor:[UIColor orangeColor]];
        
        self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
        
    } else{
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"theme"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
        [_switchonoff setThumbTintColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        
        [_lblStatic1 setTextColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        [_lblStatic2 setTextColor:[UIColor blackColor]];
        [_lblStatic3 setTextColor:[UIColor blackColor]];
        [_lblStatic4 setTextColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        [_lblStatic5 setTextColor:[UIColor blackColor]];
        [_lblCurrencyName setTextColor:[UIColor blackColor]];
        [_lblCoinsToDisplay setTextColor:[UIColor blackColor]];
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0];
    }
}
@end
