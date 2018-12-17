//
//  CoinDetailsViewController.m
//  TaroMaroCoin
//
//  Created by nestcode on 3/6/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import "CoinDetailsViewController.h"

@interface CoinDetailsViewController ()

@end

@implementation CoinDetailsViewController{
    NSString *CName, *CSymbol;
    float aboveSlidePosition, belowSlidePosition;
    int selectedCurrency;
    NSString *str_currency;
    NSArray *jsonArray;
    NSArray *jsonArray2;
    NSMutableArray *coinid;
    NSMutableArray *onedayvol;
    NSString *graphapi;
    NSMutableArray *marketcap;
    BOOL error2;
    NSMutableArray *values;
    NSMutableArray *xVals;
    NSMutableArray *yVals;
    NSMutableArray *price;
    NSMutableArray *cirsupply;
    NSMutableArray *per24hr;
    NSString *y;
    NSMutableArray *per1hr;
    NSMutableArray *per7d;
    NSMutableArray *temparr;
    NSMutableArray *symbol;
    NSString *id4api;
    NSArray *dataops;
    NSString *init;
    NSString *tickerapi;
    UIView* coverView;
    NSMutableArray *price4rmapi,*price4rmapi_USD;
    NSMutableArray *price4graphdata;
    NSMutableArray *time4graph;
    NSInteger *i ;
    NSString *strCoin, *strCurreny;
    NSString *strTheme, *strBTCPrice;
    NSInteger m;
    NSUserDefaults *Visited1;
    NSUserDefaults *isBanner, *isFullScreen, *Interval, *bannerID, *FullID;
    NSString *strBanner, *strFull;
}

@synthesize BannerView = BannerView_;
@synthesize interstitial = InterstitialView_;

- (void)viewDidLoad {
    [super viewDidLoad];
    strCurreny = @"usd";
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    strTheme = [[NSUserDefaults standardUserDefaults]
                stringForKey:@"theme"];
    str_currency = @"USD";
    
    
    if ([strTheme isEqualToString:@"1"]) {
        self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
        
        [_detailSegment setBackgroundColor:[UIColor orangeColor]];
        [_detailSegment setTintColor:[UIColor blackColor]];
        
        [_ChartSegment setTintColor:[UIColor orangeColor]];
        [_ChartSegment setBackgroundColor:[UIColor blackColor]];
        [_CurrencySegment setTintColor:[UIColor orangeColor]];
        [_CurrencySegment setBackgroundColor:[UIColor blackColor]];
        
        [self.view setBackgroundColor:[UIColor blackColor]];
        [self.viewTop setBackgroundColor:[UIColor orangeColor]];
        [self.viewAbove setBackgroundColor:[UIColor blackColor]];
        [self.viewBelow setBackgroundColor:[UIColor blackColor]];
        [self.viewChart setBackgroundColor:[UIColor blackColor]];
        [self.viewAleart setBackgroundColor:[UIColor blackColor]];
        [self.viewDetails setBackgroundColor:[UIColor blackColor]];
        [self.viewInDetail setBackgroundColor:[UIColor blackColor]];
        
        _viewAbove.layer.borderColor = [UIColor orangeColor].CGColor;
        _viewBelow.layer.borderColor = [UIColor orangeColor].CGColor;
        
        [_lblStatic1 setTextColor:[UIColor orangeColor]];
        [_lblStatic2 setTextColor:[UIColor orangeColor]];
        [_lblStatic3 setTextColor:[UIColor orangeColor]];
        [_lblStatic4 setTextColor:[UIColor orangeColor]];
        [_lblStatic5 setTextColor:[UIColor orangeColor]];
        [_lblStatic6 setTextColor:[UIColor orangeColor]];
        [_lblStatic7 setTextColor:[UIColor orangeColor]];
        [_lblStatic8 setTextColor:[UIColor orangeColor]];
        [_lblStatic9 setTextColor:[UIColor orangeColor]];
        [_lblStatic10 setTextColor:[UIColor orangeColor]];
        [_lblStatic11 setTextColor:[UIColor orangeColor]];
        [_lblStatic12 setTextColor:[UIColor orangeColor]];
        [_lblStatic13 setTextColor:[UIColor orangeColor]];
        
        [_lblPrice setTextColor:[UIColor whiteColor]];
        [_lblSymbol setTextColor:[UIColor whiteColor]];
        [_lblVolume setTextColor:[UIColor whiteColor]];
        [_lblChange1h setTextColor:[UIColor whiteColor]];
        [_lblChange7d setTextColor:[UIColor whiteColor]];
        [_lblPriceBTC setTextColor:[UIColor whiteColor]];
        [_lblPriceUSD setTextColor:[UIColor whiteColor]];
        [_lblChange24h setTextColor:[UIColor whiteColor]];
        [_lblChartData setTextColor:[UIColor whiteColor]];
        [_lblMarketCap setTextColor:[UIColor whiteColor]];
        [_lblMaxSupply setTextColor:[UIColor whiteColor]];
        [_lblCoinAmount setTextColor:[UIColor whiteColor]];
        [_lblLastUpdate setTextColor:[UIColor whiteColor]];
        [_lblPriceAbove setTextColor:[UIColor whiteColor]];
        [_lblPriceBelow setTextColor:[UIColor whiteColor]];
        [_lblTotalSupply setTextColor:[UIColor whiteColor]];
        [_lblAbovePerChange setTextColor:[UIColor whiteColor]];
        [_lblBelowPerChnage setTextColor:[UIColor whiteColor]];
        [_lblAvailableSupply setTextColor:[UIColor whiteColor]];
        
        [_belowSlide setThumbTintColor:[UIColor orangeColor]];
        [_aboveSlide setThumbTintColor:[UIColor orangeColor]];
        
        [_switchAbove setThumbTintColor:[UIColor orangeColor]];
        [_switchBelow setThumbTintColor:[UIColor orangeColor]];
        
        [_btnAboveAdd setBackgroundColor:[UIColor orangeColor]];
        [_btnBelowAdd setBackgroundColor:[UIColor orangeColor]];
        [_btnAboveMinus setBackgroundColor:[UIColor orangeColor]];
        [_btnBelowMinus setBackgroundColor:[UIColor orangeColor]];
        
        
    }
    else{
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        [self.viewTop setBackgroundColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        
        _viewAbove.layer.borderColor = [UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0].CGColor;
        _viewBelow.layer.borderColor = [UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0].CGColor;
        
        [_detailSegment setBackgroundColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        [_detailSegment setTintColor:[UIColor whiteColor]];
        
        [self.viewAbove setBackgroundColor:[UIColor whiteColor]];
        [self.viewBelow setBackgroundColor:[UIColor whiteColor]];
        [self.viewChart setBackgroundColor:[UIColor whiteColor]];
        [self.viewAleart setBackgroundColor:[UIColor whiteColor]];
        [self.viewDetails setBackgroundColor:[UIColor whiteColor]];
        [self.viewInDetail setBackgroundColor:[UIColor whiteColor]];
        
        [_lblStatic1 setTextColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        [_lblStatic2 setTextColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        [_lblStatic3 setTextColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        [_lblStatic4 setTextColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        [_lblStatic5 setTextColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        [_lblStatic6 setTextColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        [_lblStatic7 setTextColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        [_lblStatic8 setTextColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        [_lblStatic9 setTextColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        [_lblStatic10 setTextColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        [_lblStatic11 setTextColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        [_lblStatic12 setTextColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        [_lblStatic13 setTextColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        
        [_lblPrice setTextColor:[UIColor blackColor]];
        [_lblSymbol setTextColor:[UIColor blackColor]];
        [_lblVolume setTextColor:[UIColor blackColor]];
        [_lblChange1h setTextColor:[UIColor blackColor]];
        [_lblChange7d setTextColor:[UIColor blackColor]];
        [_lblPriceBTC setTextColor:[UIColor blackColor]];
        [_lblPriceUSD setTextColor:[UIColor blackColor]];
        [_lblChange24h setTextColor:[UIColor blackColor]];
        [_lblChartData setTextColor:[UIColor blackColor]];
        [_lblMarketCap setTextColor:[UIColor blackColor]];
        [_lblMaxSupply setTextColor:[UIColor blackColor]];
        [_lblCoinAmount setTextColor:[UIColor blackColor]];
        [_lblLastUpdate setTextColor:[UIColor blackColor]];
        [_lblPriceAbove setTextColor:[UIColor blackColor]];
        [_lblPriceBelow setTextColor:[UIColor blackColor]];
        [_lblTotalSupply setTextColor:[UIColor blackColor]];
        [_lblAbovePerChange setTextColor:[UIColor blackColor]];
        [_lblBelowPerChnage setTextColor:[UIColor blackColor]];
        [_lblAvailableSupply setTextColor:[UIColor blackColor]];
        
        [_belowSlide setThumbTintColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        [_aboveSlide setThumbTintColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        
        [_switchAbove setThumbTintColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        [_switchBelow setThumbTintColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];

        [_btnAboveAdd setBackgroundColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        [_btnBelowAdd setBackgroundColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        [_btnAboveMinus setBackgroundColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        [_btnBelowMinus setBackgroundColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        
    }
    
    
    selectedCurrency = 0;
    aboveSlidePosition = 5.0f;
    belowSlidePosition = 5.0f;
    
    _detailSegment.layer.cornerRadius = 0.0f;
    
    [self ViewHideShow];
    _viewDetails.hidden = NO;

    CName = _strCurrencyName;

    _viewBelow.layer.borderWidth = 0.5f;
    _viewAbove.layer.borderWidth = 0.5f;
    
    _viewBelow.layer.cornerRadius = 5.0f;
    _viewAbove.layer.cornerRadius = 5.0f;
    
    [self CurrencySymbol];
    
    [self SingleCoinData];
    
    _aboveSlide.enabled = NO;
    _btnAboveAdd.enabled = NO;
    _btnAboveMinus.enabled = NO;
    _btnBelowAdd.enabled = NO;
    _btnBelowMinus.enabled = NO;
    _belowSlide.enabled = NO;
    
    dataops = @[@"1 Day", @"7 Days", @"1 Month",@"3 Months",@"6 Months",@"1 Year",@"All data"];
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



-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
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
    
    NSArray* units = @[@"K",@"Million",@"Billion",@"Trillion"];
    
    return [NSString stringWithFormat:@"%@%.2f %@",sign, (num / pow(1000, exp)), [units objectAtIndex:(exp-1)]];
}


-(void)getgraphdata:(NSString*)sel_cur FromData: (int) his_dur{
    
    NSLog(@"Current in :%@",sel_cur);
    NSLog(@"durretion in :%d",his_dur);
    
    NSString *Str_Coin = [_dictCoinData valueForKey:@"name"];
    NSString * Str_CurrentTime = @"";
    NSString * Str_DurretionTime = @"";
    int flag_All;
    flag_All =0;
    NSTimeInterval milisecondedDate = ([[NSDate date] timeIntervalSince1970] * 1000);
    Str_CurrentTime = [NSString stringWithFormat:@"%.0f",milisecondedDate];

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    
    
    

    switch (his_dur)
    {
        case 0:
            comps.day = comps.day -1;  // 24 HR
            break;
        case 1:
            comps.day = comps.day -7;  // 24 HR
            break;
        case 2:
            comps.month = comps.month -1;  // 24 HR
            break;
        case 3:
            comps.month = comps.month -3;  // 24 HR
            break;
        case 4:
            comps.month = comps.month -6;  // 24 HR
            break;
        case 5:
            comps.month = comps.month -12;  // 24 HR
            break;
        case 6:
            flag_All =1;
            break;
    }
    
    NSLog(@"%@",[calendar dateFromComponents:comps]);
    NSTimeInterval milisecondedfromDate = ([[calendar dateFromComponents:comps] timeIntervalSince1970] * 1000);
    Str_DurretionTime = [NSString stringWithFormat:@"%.0f",milisecondedfromDate];
    
    NSLog(@"Coin :%@",Str_Coin);
    NSLog(@"Current Time %@",Str_CurrentTime);
    NSLog(@"Duration Time %@",Str_DurretionTime);
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        if (flag_All == 1)
        {
            graphapi = [NSString stringWithFormat:@"%@%@",URL_GRAPH, Str_Coin];
        }
        else
        {
            graphapi = [NSString stringWithFormat:@"%@%@/%@/%@",URL_GRAPH, Str_Coin, Str_DurretionTime,Str_CurrentTime];
        }
        
        NSString *url = graphapi;
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"GET"];
        [request setURL:[NSURL URLWithString:url]];
        NSError *error = nil;
        NSHTTPURLResponse *responseCode = nil;
        NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
        [SVProgressHUD dismiss];
        self.viewChart.userInteractionEnabled = YES;
        if(!([responseCode statusCode] == 200)){
            NSLog(@"Error getting %@, HTTP status code %li", url, (long)[responseCode statusCode]);
            
        }
        else{
            
            
            NSString *data = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
            NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
            id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
            if (error) {
                error2 = YES;
                MDCSnackbarMessage *message = [[MDCSnackbarMessage alloc] init];
                message.text = [NSString stringWithFormat:@"No graph data for %@",strCoin];
                self.chartView.noDataText = [NSString stringWithFormat:@"No graph data for %@",strCoin];
                self.chartView.noDataTextColor = [UIColor whiteColor];
                [MDCSnackbarManager showMessage:message];
                self.btn1.hidden = YES;
                self.btn2.hidden = YES;
                self.btn3.hidden = YES;
                self.btn4.hidden = YES;
                self.btn5.hidden = YES;
                self.btn6.hidden = YES;
                self.btn7.hidden = YES;
                
            }
            else
            {
                
                //setting graph data
                price4graphdata = [[NSMutableArray alloc] init];
                price4rmapi_USD = [[NSMutableArray alloc] init];
                time4graph = [[NSMutableArray alloc] init];
                self.intt = 0;
                jsonArray2 = (NSArray *)jsonObject;
                if ([str_currency isEqualToString:@"USD"]) {
                        price4rmapi =[jsonArray2 valueForKey: @"price_usd"];
                }
                else{
                        price4rmapi =[jsonArray2 valueForKey: @"price_btc"];
                }
                
                price4rmapi_USD =[jsonArray2 valueForKey: @"price_usd"];
                //sperating data to diffrent arrays
                values = [[NSMutableArray alloc]init];
                xVals = [[NSMutableArray alloc] init];
                yVals = [[NSMutableArray alloc] init];
                
                for (NSMutableArray *tempObject in price4rmapi) {
                    [time4graph addObject:[tempObject objectAtIndex:0]];
                    [price4graphdata addObject:[tempObject objectAtIndex:1]];
                    [values addObject:[[ChartDataEntry alloc] initWithX:[[tempObject objectAtIndex:0]doubleValue] y:[[tempObject objectAtIndex:1]doubleValue]]];
                    
                }
                xVals = time4graph;
                yVals = price4graphdata;
                self.formatter = [[NSDateFormatter alloc] init];
                [self.formatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"yyyyMMMd" options:0 locale:[NSLocale currentLocale]]];
                
            }
        }
        
                [self createlinegrph];
                
    
    });
    //pretty self explanatory
}


-(void)getBTCgraphdata:(NSString*)his_dur FromData:(NSString*)from_dur{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        if([his_dur isEqualToString:@"1day"]){
            graphapi = [NSString stringWithFormat:@"http://www.coincap.io/history/1day/%@",strCoin];
        }
        else if ([his_dur isEqualToString:@"7day"]){
            graphapi = [NSString stringWithFormat:@"http://www.coincap.io/history/7day/%@",strCoin];
        }
        else if ([his_dur isEqualToString:@"30day"]){
            graphapi = [NSString stringWithFormat:@"http://www.coincap.io/history/30day/%@",strCoin];
        }
        else if ([his_dur isEqualToString:@"90day"]){
            graphapi = [NSString stringWithFormat:@"http://www.coincap.io/history/90day/%@",strCoin];
        }
        else if ([his_dur isEqualToString:@"180day"]){
            graphapi = [NSString stringWithFormat:@"http://www.coincap.io/history/180day/%@",strCoin];
        }
        else if ([his_dur isEqualToString:@"365day"]){
            graphapi = [NSString stringWithFormat:@"http://www.coincap.io/history/365day/%@",strCoin];
        }
        else if ([his_dur isEqualToString:@"all"]){
            graphapi = [NSString stringWithFormat:@"http://www.coincap.io/history/%@",strCoin];
        }
        else {
            graphapi = [NSString stringWithFormat:@"http://www.coincap.io/history/1day/%@",strCoin];
        }
        
        
        NSString *url = graphapi;
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"GET"];
        [request setURL:[NSURL URLWithString:url]];
        NSError *error = nil;
        NSHTTPURLResponse *responseCode = nil;
        NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
        if(!([responseCode statusCode] == 200)){
            NSLog(@"Error getting %@, HTTP status code %li", url, (long)[responseCode statusCode]);
            
            
        }
        else{
            
            //parsing json data
            NSString *data = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
            NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
            id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
            if (error) {
                error2 = YES;
                //handle if no graph is available for the particular coin
                //                UILabel *label = [[UILabel alloc]initWithFrame:self.chartView.frame];
                //                label.textColor = [UIColor whiteColor];
                //                label.text = [NSString stringWithFormat:@"No graph data for %@",self.coinlabel.text];
                //                label.textAlignment = NSTextAlignmentCenter;
                //
                //                [self.view addSubview:label];
                MDCSnackbarMessage *message = [[MDCSnackbarMessage alloc] init];
                message.text = [NSString stringWithFormat:@"No graph data for %@",strCoin];
                self.chartView.noDataText = [NSString stringWithFormat:@"No graph data for %@",strCoin];
                self.chartView.noDataTextColor = [UIColor whiteColor];
                [MDCSnackbarManager showMessage:message];
                self.btn1.hidden = YES;
                self.btn2.hidden = YES;
                self.btn3.hidden = YES;
                self.btn4.hidden = YES;
                self.btn5.hidden = YES;
                self.btn6.hidden = YES;
                self.btn7.hidden = YES;
                
            }
            else
            {
                //            self.btn1.hidden = NO;
                //            self.btn2.hidden = NO;
                //            self.btn3.hidden = NO;
                //            self.btn4.hidden = NO;
                //            self.btn5.hidden = NO;
                //            self.btn6.hidden = NO;
                //            self.btn7.hidden = NO;
                //  self.refView4Chart.hidden = NO;
                
                //setting graph data
                price4graphdata = [[NSMutableArray alloc] init];
                time4graph = [[NSMutableArray alloc] init];
                self.intt = 0;
                jsonArray2 = (NSArray *)jsonObject;
                price4rmapi =[jsonArray2 valueForKey: @"price"];
                //sperating data to diffrent arrays
                values = [[NSMutableArray alloc]init];
                xVals = [[NSMutableArray alloc] init];
                yVals = [[NSMutableArray alloc] init];
                
                for (NSMutableArray *tempObject in price4rmapi) {
                    [time4graph addObject:[tempObject objectAtIndex:0]];
                    [price4graphdata addObject:[tempObject objectAtIndex:1]];
                    [values addObject:[[ChartDataEntry alloc] initWithX:[[tempObject objectAtIndex:0]doubleValue] y:[[tempObject objectAtIndex:1]doubleValue]]];
                    
                }
                xVals = time4graph;
                yVals = price4graphdata;
                self.formatter = [[NSDateFormatter alloc] init];
                [self.formatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"yyyyMMMd" options:0 locale:[NSLocale currentLocale]]];
                
            }
        }
        
        
        
        [self createlinegrph];
        
        
    });
    //pretty self explanatory
}

-(void)createlinegrph{
    LineChartView *linechart = self.chartView;
    
    LineChartDataSet *dataset = (LineChartDataSet *)linechart.data.dataSets[0];
    dataset = [[LineChartDataSet alloc] initWithValues:values label:@""];
    dataset.values = values;
    dataset.drawValuesEnabled = FALSE;
    dataset.drawCirclesEnabled = FALSE;
    if ([strTheme isEqualToString:@"0"]) {
        dataset.fillColor = [UIColor orangeColor];
        linechart.xAxis.labelTextColor = [UIColor orangeColor];
        linechart.leftAxis.labelTextColor = [UIColor orangeColor];
    }
    else
    {
        linechart.xAxis.labelTextColor = [UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0];
        linechart.leftAxis.labelTextColor = [UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0];
        dataset.fillColor = [UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0];
    }
    
    dataset.highlightColor = [UIColor orangeColor];
    linechart.noDataTextColor = [UIColor whiteColor];
    if ([strTheme isEqualToString:@"0"]) {
        [dataset setColor:[UIColor orangeColor]];
    }
    else
    {
        [dataset setColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
    }
    
    linechart.xAxis.labelPosition = XAxisLabelPositionBottom;
    
    [linechart.rightAxis setEnabled:NO];
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:dataset];
    linechart.delegate = self;
    LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
    DateValueFormatter *formatter2;
    formatter2 = [[DateValueFormatter alloc] init];
    linechart.xAxis.valueFormatter = formatter2;
    linechart.xAxis.granularity = 10;
    linechart.noDataText = [NSString stringWithFormat:@"No graph data for %@",strCoin];
    linechart.xAxis.granularityEnabled = true;
    linechart.drawMarkers = true;
    linechart.xAxis.avoidFirstLastClippingEnabled = false;
    linechart.xAxis.drawLabelsEnabled = TRUE;
    linechart.data = data;
    self.chartView = linechart;
    [self.chartView animateWithXAxisDuration:2];
    // [self.view addSubview:linechart];
}

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    double unixTimeStamp =entry.x;
    NSTimeInterval timeInterval=unixTimeStamp/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setLocale:[NSLocale currentLocale]];
    [dateformatter setDateFormat:@"dd-MM-yyyy"];
    NSString *dateString=[dateformatter stringFromDate:date];
    
    if ([str_currency isEqualToString:@"USD"])
    {
        
        if (entry.y <=1.0f)
        {
            self.lblChartData.text = [NSString stringWithFormat:@"Price:%@%0.8f Date:%@",CSymbol,entry.y,dateString];
        }
        else
        {
            self.lblChartData.text = [NSString stringWithFormat:@"Price:%@%0.8f Date:%@",CSymbol,entry.y,dateString];
        }
    }
    else
    {
        self.lblChartData.text = [NSString stringWithFormat:@"Price:₿%0.8f Date:%@",entry.y,dateString];
    }
}

- (void)SingleCoinData{
    
    NSArray *arrTemp = [_dictCoinData allKeys];
    
    for (int i = 0; i<[arrTemp count]; i++) {
        if ([[_dictCoinData valueForKey:[arrTemp objectAtIndex:i]] isKindOfClass:[NSNull class]]) {
            [_dictCoinData setObject:@"N/A" forKey:[arrTemp objectAtIndex:i]];
        }
    }
    NSString *Pricekey = [[NSString stringWithFormat:@"price_%@",CName]lowercaseString];
    NSString *MarketKey = [[NSString stringWithFormat:@"market_cap_%@",CName]lowercaseString];
    NSNumber *nbrMarketCap = [_dictCoinData valueForKey:MarketKey];
    NSString *strMarket = [NSString stringWithFormat:@"%@%@",CSymbol,[self suffixNumber:nbrMarketCap]];
    NSString *VolumeKey = [[NSString stringWithFormat:@"24h_volume_%@",CName]lowercaseString];
    NSNumber *nbr24Volume = [_dictCoinData valueForKey:VolumeKey];
    NSString *str24h = [NSString stringWithFormat:@"%@%@",CSymbol,[self suffixNumber:nbr24Volume]];
    NSString *str1hr = [NSString stringWithFormat:@"%@",[_dictCoinData valueForKey:@"percent_change_1h"]];
    NSString *str24hr = [NSString stringWithFormat:@"%@",[_dictCoinData valueForKey:@"percent_change_24h"]];
    NSString *str7d = [NSString stringWithFormat:@"%@",[_dictCoinData valueForKey:@"percent_change_7d"]];
    
    _lblTitle.text = [_dictCoinData valueForKey:@"name"];
    _lblCoinAmount.text = [NSString stringWithFormat:@"%@ %.6f",CSymbol,[[_dictCoinData valueForKey:Pricekey]floatValue]];
    _lblPrice.text = [NSString stringWithFormat:@"%@ %.6f",CSymbol,[[_dictCoinData valueForKey:Pricekey]floatValue]];
    
    float chnagedPrice = [[_dictCoinData valueForKey:Pricekey]floatValue];
    float calculateAbove = ((chnagedPrice * aboveSlidePosition/100)+chnagedPrice);
    _lblPriceAbove.text = [NSString stringWithFormat:@"%@ %.2f",CSymbol,calculateAbove];
    
    float calculateBelow = (chnagedPrice - (chnagedPrice * aboveSlidePosition/100));
    _lblPriceBelow.text = [NSString stringWithFormat:@"%@ %.2f",CSymbol,calculateBelow];
    
    _lblSymbol.text = [_dictCoinData valueForKey:@"symbol"];
    strCoin = [_dictCoinData valueForKey:@"symbol"];
    
    _lblPriceUSD.text = [NSString stringWithFormat:@"$ %.2f",[[_dictCoinData valueForKey:@"price_usd"]floatValue]];
    _lblPriceBTC.text = [NSString stringWithFormat:@"฿ %@",[_dictCoinData valueForKey:@"price_btc"]];
    _lblVolume.text = [NSString stringWithFormat:@"%@",str24h];
    _lblMarketCap.text = [NSString stringWithFormat:@"%@",strMarket];
    _lblAvailableSupply.text = [NSString stringWithFormat:@"%@",[_dictCoinData valueForKey:@"available_supply"]];
    _lblTotalSupply.text = [NSString stringWithFormat:@"%@",[_dictCoinData valueForKey:@"total_supply"]];
    _lblMaxSupply.text = [NSString stringWithFormat:@"%@",[_dictCoinData valueForKey:@"max_supply"]];
    
    if ([str1hr containsString:@"-"]) {
        _lblChange1h.textColor = [UIColor redColor];
        _lblChange1h.text = [NSString stringWithFormat:@"↓%@%%",[_dictCoinData valueForKey:@"percent_change_1h"]];
    }
    else{
        _lblChange1h.textColor = [UIColor colorWithRed:19.0f/255.0f green:151.0f/255.0f blue:29.0f/255.0f alpha:1.0];
        _lblChange1h.text = [NSString stringWithFormat:@"↑%@%%",[_dictCoinData valueForKey:@"percent_change_1h"]];
    }
    
    if ([str24hr containsString:@"-"]) {
        _lblChange24h.textColor = [UIColor redColor];
        _lblChange24h.text = [NSString stringWithFormat:@"↓%@%%",[_dictCoinData valueForKey:@"percent_change_24h"]];
    }
    else{
        _lblChange24h.textColor = [UIColor colorWithRed:19.0f/255.0f green:151.0f/255.0f blue:29.0f/255.0f alpha:1.0];
        _lblChange24h.text = [NSString stringWithFormat:@"↑%@%%",[_dictCoinData valueForKey:@"percent_change_24h"]];
    }
    
    if ([str7d containsString:@"-"]) {
        _lblChange7d.textColor = [UIColor redColor];
        _lblChange7d.text = [NSString stringWithFormat:@"↓%@%%",[_dictCoinData valueForKey:@"percent_change_7d"]];
    }
    else{
        _lblChange7d.textColor = [UIColor colorWithRed:19.0f/255.0f green:151.0f/255.0f blue:29.0f/255.0f alpha:1.0];
        _lblChange7d.text = [NSString stringWithFormat:@"↑%@%%",[_dictCoinData valueForKey:@"percent_change_7d"]];
    }
    
    [_imgCoin startLoaderWithTintColor:[UIColor greenColor]];
    
    NSString *strImgUrl = [NSString stringWithFormat:@"%@%@.png",URL_IMAGE,[_dictCoinData valueForKey:@"id"]];
    
    [_imgCoin sd_setImageWithURL:[NSURL URLWithString:strImgUrl] placeholderImage:[UIImage imageNamed:@"Thumnail.png"] options:SDWebImageCacheMemoryOnly | SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        [_imgCoin updateImageDownloadProgress:(CGFloat)receivedSize/expectedSize];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [_imgCoin reveal];
    }];
    
    double unixTimeStamp =[[_dictCoinData objectForKey:@"last_updated"]doubleValue];
    NSTimeInterval _interval=unixTimeStamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:date];
    
    _lblLastUpdate.text = [NSString stringWithFormat:@"Last Update: %@",dateString];
    
    [formatter setDateFormat:@"dd-MM-yyyy"];
    NSString *dateString1 = [formatter stringFromDate:date];
    self.lblChartData.text = [NSString stringWithFormat:@"Price:%@ Date:%@",[NSString stringWithFormat:@"$ %.2f",[[_dictCoinData valueForKey:@"price_usd"]floatValue]],dateString1];
    
    strBTCPrice = [NSString stringWithFormat:@"Price:%@ Date:%@",[NSString stringWithFormat:@"฿ %@",[_dictCoinData valueForKey:@"price_btc"]],dateString1];
    
    //AlertView
    UILongPressGestureRecognizer *aboveAdd = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(aboveAddGesture:)];
    [self.btnAboveAdd addGestureRecognizer:aboveAdd];
    UILongPressGestureRecognizer *AboveMinus = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(aboveMinusGesture:)];
    [self.btnAboveMinus addGestureRecognizer:AboveMinus];
    
    UILongPressGestureRecognizer *BelowAdd = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(BelowAddGesture:)];
    [self.btnBelowAdd addGestureRecognizer:BelowAdd];
    UILongPressGestureRecognizer *BelowMinus = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(BelowMinusGesture:)];
    [self.btnBelowMinus addGestureRecognizer:BelowMinus];
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
    
    self.view.userInteractionEnabled = YES;
    self.viewChart.userInteractionEnabled = YES;
}

-(void)APISingleCoinData{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        [SVProgressHUD show];
        NSString *strUrl = [NSString stringWithFormat:@"%@%@/?convert=%@",URL_ROOT_API,[_dictCoinData valueForKey:@"id"],CName];
        [[ApiCallManager sharedApiCallManager] callAPIWithDelegate:self withURL:strUrl withData:nil andCallBack:CALL_TYPE_GET_CURRENCY];
    }
}

-(void)ViewHideShow{
    _viewChart.hidden = YES;
    _viewAleart.hidden = YES;
    _viewDetails.hidden = YES;
    _viewExchange.hidden = YES;
}

-(void)CurrencySymbol{
    SQLFile *new = [[SQLFile alloc]init];
    NSString *query = [NSString stringWithFormat:@"select Symbol from CurrencyList where Name ='%@'",CName];
    CSymbol = [[new select_currency:query] objectAtIndex:0];
    [_btnCurrency setTitle:CName forState:UIControlStateNormal];
}

- (IBAction)onBackClicked:(id)sender {
    [[self navigationController]popToRootViewControllerAnimated:YES];
}
- (IBAction)SegmentChanged:(id)sender {
    switch ([sender selectedSegmentIndex]) {
        case 0:
            [self ViewHideShow];
            _btnCurrency.hidden = NO;
            _viewDetails.hidden = NO;
            break;
        case 1:
            [self ViewHideShow];
            _btnCurrency.hidden = YES;
            [SVProgressHUD show];
            self.viewChart.userInteractionEnabled = NO;
            [self getgraphdata:str_currency FromData:2];
            _viewChart.hidden = NO;
            break;
        case 2:
            [self ViewHideShow];
            _viewAleart.hidden = NO;
            break;
        default:
            [self ViewHideShow];
            _viewDetails.hidden = NO;
            break;
    }
}

- (IBAction)onCurrencyChangeClicked:(id)sender {
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
         
         CName = [[NSUserDefaults standardUserDefaults]
                  stringForKey:@"CurrencyName"];
         [self CurrencySymbol];
         
         [self APISingleCoinData];
         
     }cancelBlock:^(ActionSheetStringPicker *picker)
     {
         
     }origin:sender];
}

#pragma mark - ValuesChange

- (void)aboveAddGesture:(UILongPressGestureRecognizer*)gesture {
    //if ( gesture.state == UIGestureRecognizerStateBegan ) {
        if (!(aboveSlidePosition >= 100.00f) ) {
            aboveSlidePosition = aboveSlidePosition+0.01;
            NSLog(@"%.2f",aboveSlidePosition);
            _aboveSlide.value = aboveSlidePosition;
            _lblAbovePerChange.text = [NSString stringWithFormat:@"%.2f%%",aboveSlidePosition];
            
            NSString *Pricekey = [[NSString stringWithFormat:@"price_%@",CName]lowercaseString];
            float chnagedAbove = [[_dictCoinData valueForKey:Pricekey]floatValue];
            float calculate = ((chnagedAbove * aboveSlidePosition/100)+chnagedAbove);
            _lblPriceAbove.text = [NSString stringWithFormat:@"%@ %.2f",CSymbol,calculate];
        }
   
}

- (void)aboveMinusGesture:(UILongPressGestureRecognizer*)gesture {
    //if ( gesture.state == UIGestureRecognizerStateBegan ) {
    if (!(aboveSlidePosition >= 100.00f) ) {
        aboveSlidePosition = aboveSlidePosition-0.01;
        NSLog(@"%.2f",aboveSlidePosition);
        _aboveSlide.value = aboveSlidePosition;
        _lblAbovePerChange.text = [NSString stringWithFormat:@"%.2f%%",aboveSlidePosition];
        
        NSString *Pricekey = [[NSString stringWithFormat:@"price_%@",CName]lowercaseString];
        float chnagedAbove = [[_dictCoinData valueForKey:Pricekey]floatValue];
        float calculate = ((chnagedAbove * aboveSlidePosition/100)+chnagedAbove);
        _lblPriceAbove.text = [NSString stringWithFormat:@"%@ %.2f",CSymbol,calculate];
    }
    
}

- (void)BelowAddGesture:(UILongPressGestureRecognizer*)gesture {
    //if ( gesture.state == UIGestureRecognizerStateBegan ) {
    if (!(belowSlidePosition >= 100.00f) ) {
        belowSlidePosition = belowSlidePosition+0.01;
        NSLog(@"%.2f",aboveSlidePosition);
        _belowSlide.value = belowSlidePosition;
        _lblBelowPerChnage.text = [NSString stringWithFormat:@"%.2f%%",belowSlidePosition];
        
        NSString *Pricekey = [[NSString stringWithFormat:@"price_%@",CName]lowercaseString];
        float changedBelow = [[_dictCoinData valueForKey:Pricekey]floatValue];
        float calculate = (changedBelow - (changedBelow * belowSlidePosition/100));
        _lblPriceBelow.text = [NSString stringWithFormat:@"%@ %.2f",CSymbol,calculate];
    }
    
}

- (void)BelowMinusGesture:(UILongPressGestureRecognizer*)gesture {
    //if ( gesture.state == UIGestureRecognizerStateBegan ) {
    if (!(belowSlidePosition >= 100.00f) ) {
        belowSlidePosition = belowSlidePosition-0.01;
        NSLog(@"%.2f",belowSlidePosition);
        _belowSlide.value = belowSlidePosition;
        _lblBelowPerChnage.text = [NSString stringWithFormat:@"%.2f%%",belowSlidePosition];
        
        NSString *Pricekey = [[NSString stringWithFormat:@"price_%@",CName]lowercaseString];
        float changedBelow = [[_dictCoinData valueForKey:Pricekey]floatValue];
        float calculate = (changedBelow - (changedBelow * belowSlidePosition/100));
        _lblPriceBelow.text = [NSString stringWithFormat:@"%@ %.2f",CSymbol,calculate];
    }
    
}

- (IBAction)switchAboveOnOff:(id)sender {
    if([sender isOn]){
        _aboveSlide.enabled = YES;
        _btnAboveAdd.enabled = YES;
        _btnAboveMinus.enabled = YES;
    } else{
       _aboveSlide.enabled = NO;
        _btnAboveAdd.enabled = NO;
        _btnAboveMinus.enabled = NO;
    }
}

- (IBAction)onAboveSlideChange:(id)sender {
    NSString *Pricekey = [[NSString stringWithFormat:@"price_%@",CName]lowercaseString];
    float chnagedAbove = [[_dictCoinData valueForKey:Pricekey]floatValue];
    aboveSlidePosition = _aboveSlide.value;
    _lblAbovePerChange.text = [NSString stringWithFormat:@"%.2f%%",aboveSlidePosition];
    float calculate = ((chnagedAbove * aboveSlidePosition/100)+chnagedAbove);
    _lblPriceAbove.text = [NSString stringWithFormat:@"%@ %.2f",CSymbol,calculate];
    NSLog(@"didEndChanged - %.2f",calculate);
}

- (IBAction)onAboveAddClicked:(id)sender {
    if (!(aboveSlidePosition >= 100.00f) ) {
        aboveSlidePosition = aboveSlidePosition+0.01;
        NSLog(@"%.2f",aboveSlidePosition);
        _aboveSlide.value = aboveSlidePosition;
        _lblAbovePerChange.text = [NSString stringWithFormat:@"%.2f%%",aboveSlidePosition];
        
        NSString *Pricekey = [[NSString stringWithFormat:@"price_%@",CName]lowercaseString];
        float chnagedAbove = [[_dictCoinData valueForKey:Pricekey]floatValue];
        float calculate = ((chnagedAbove * aboveSlidePosition/100)+chnagedAbove);
        _lblPriceAbove.text = [NSString stringWithFormat:@"%@ %.2f",CSymbol,calculate];
    }
    
}

- (IBAction)onAboveMinusClicked:(id)sender {
    aboveSlidePosition = aboveSlidePosition-0.01;
    NSLog(@"%.2f",aboveSlidePosition);
    _aboveSlide.value = aboveSlidePosition;
    _lblAbovePerChange.text = [NSString stringWithFormat:@"%.2f%%",aboveSlidePosition];
    
    NSString *Pricekey = [[NSString stringWithFormat:@"price_%@",CName]lowercaseString];
    float chnagedAbove = [[_dictCoinData valueForKey:Pricekey]floatValue];
    float calculate = ((chnagedAbove * aboveSlidePosition/100)+chnagedAbove);
    _lblPriceAbove.text = [NSString stringWithFormat:@"%@ %.2f",CSymbol,calculate];
}

- (IBAction)switchBelowOnOff:(id)sender {
    if([sender isOn]){
        _belowSlide.enabled = YES;
        _btnBelowAdd.enabled = YES;
        _btnBelowMinus.enabled = YES;
    } else{
        _belowSlide.enabled = NO;
        _btnBelowAdd.enabled = NO;
        _btnBelowMinus.enabled = NO;
    }
}

- (IBAction)onBelowSlideChange:(float)sender {
    NSString *Pricekey = [[NSString stringWithFormat:@"price_%@",CName]lowercaseString];
    float changedBelow = [[_dictCoinData valueForKey:Pricekey]floatValue];
    belowSlidePosition = _belowSlide.value;
    _lblBelowPerChnage.text = [NSString stringWithFormat:@"%.2f%%",belowSlidePosition];
    float calculate = (changedBelow - (changedBelow * belowSlidePosition/100));
    _lblPriceBelow.text = [NSString stringWithFormat:@"%@ %.2f",CSymbol,calculate];
    NSLog(@"didEndChanged - %.2f",calculate);
}

- (IBAction)onBelowAddClicked:(id)sender {
if (!(belowSlidePosition >= 100.00f) ) {
    belowSlidePosition = belowSlidePosition+0.01;
    NSLog(@"%.2f",belowSlidePosition);
    _belowSlide.value = belowSlidePosition;
    _lblBelowPerChnage.text = [NSString stringWithFormat:@"%.2f%%",belowSlidePosition];
    
    NSString *Pricekey = [[NSString stringWithFormat:@"price_%@",CName]lowercaseString];
    float changedBelow = [[_dictCoinData valueForKey:Pricekey]floatValue];
    float calculate = (changedBelow - (changedBelow * belowSlidePosition/100));
    _lblPriceBelow.text = [NSString stringWithFormat:@"%@ %.2f",CSymbol,calculate];
    }
}

- (IBAction)onBelowMinusClicked:(id)sender {
    if (!(belowSlidePosition >= 100.00f) ) {
        belowSlidePosition = belowSlidePosition-0.01;
        NSLog(@"%.2f",belowSlidePosition);
        _belowSlide.value = belowSlidePosition;
        _lblBelowPerChnage.text = [NSString stringWithFormat:@"%.2f%%",belowSlidePosition];
        
        NSString *Pricekey = [[NSString stringWithFormat:@"price_%@",CName]lowercaseString];
        float changedBelow = [[_dictCoinData valueForKey:Pricekey]floatValue];
        float calculate = (changedBelow - (changedBelow * belowSlidePosition/100));
        _lblPriceBelow.text = [NSString stringWithFormat:@"%@ %.2f",CSymbol,calculate];
    }
}

#pragma mark - ApiCallManagerDelegate

- (void)parserDidFailWithError:(NSError *)error andCallType:(CallTypeEnum)callType{
    NSLog(@"%s : Error : %@",__FUNCTION__, [error localizedDescription]);
}

- (void)parserSuccessDelegateDidFinish:(NSDictionary *)dictResult andCallType:(CallTypeEnum)callType{
    [SVProgressHUD dismiss];
    if (callType == CALL_TYPE_GET_CURRENCY){
      
       NSArray *arrCoinData = [dictResult mutableCopy];
        
        _dictCoinData = [arrCoinData objectAtIndex:0];
        
         [self SingleCoinData];
    }
}


- (IBAction)ChartSegmentChanged:(id)sender {
    
    
    long currency_seg =_CurrencySegment.selectedSegmentIndex;
    
    
   [SVProgressHUD show];
    int str_durretion;
    switch (currency_seg)  //USD BTC Both
    {
        case 0:  //USD
            str_currency = @"USD";
            switch ([sender selectedSegmentIndex]) {
                case 0:
                    str_durretion = 0;    // 24 Hour
                    break;
                case 1:
                    str_durretion = 1;    // 1 Week
                    break;
                case 2:
                    str_durretion = 2;    // 30 Day
                    break;
                case 3:
                    str_durretion = 3;    // 3 Month
                    break;
                case 4:
                    str_durretion = 4;    // 6 Month
                    break;
                case 5:
                    str_durretion = 5;    // 1 Year
                    break;
                case 6:
                    str_durretion = 6;   // All
                    break;
            }
            [self getgraphdata:str_currency FromData:str_durretion];
            break;
            
        case 1:
            str_currency = @"BTC";
            switch ([sender selectedSegmentIndex]) {
                case 0:
                    str_durretion = 0;    // 24 Hour
                    break;
                case 1:
                    str_durretion = 1;    // 1 Week
                    break;
                case 2:
                    str_durretion = 2;    // 30 Day
                    break;
                case 3:
                    str_durretion = 3;    // 3 Month
                    break;
                case 4:
                    str_durretion = 4;    // 6 Month
                    break;
                case 5:
                    str_durretion = 5;    // 1 Year
                    break;
                case 6:
                    str_durretion = 6;   // All
                    break;
            }
            [self getgraphdata:str_currency FromData:str_durretion];
            break;
            
        default:
            break;
            
    }
}
    
    

- (IBAction)CurrencySegmentChanged:(id)sender
{
    long Chart_seg =_ChartSegment.selectedSegmentIndex;
    
    [SVProgressHUD show];
    
    int str_durretion;
    switch ([sender selectedSegmentIndex])  //USD BTC Both
    {
        case 0:  //USD
            str_currency = @"USD";
            switch (Chart_seg) {
                case 0:
                    str_durretion = 0;    // 24 Hour
                    break;
                case 1:
                    str_durretion = 1;    // 1 Week
                    break;
                case 2:
                    str_durretion = 2;    // 30 Day
                    break;
                case 3:
                    str_durretion = 3;    // 3 Month
                    break;
                case 4:
                    str_durretion = 4;    // 6 Month
                    break;
                case 5:
                    str_durretion = 5;    // 1 Year
                    break;
                case 6:
                    str_durretion = 6;   // All
                    break;
            }
            [self getgraphdata:str_currency FromData:str_durretion];
            break;
            
        case 1:
            str_currency = @"BTC";
            switch (Chart_seg) {
                case 0:
                    str_durretion = 0;    // 24 Hour
                    break;
                case 1:
                    str_durretion = 1;    // 1 Week
                    break;
                case 2:
                    str_durretion = 2;    // 30 Day
                    break;
                case 3:
                    str_durretion = 3;    // 3 Month
                    break;
                case 4:
                    str_durretion = 4;    // 6 Month
                    break;
                case 5:
                    str_durretion = 5;    // 1 Year
                    break;
                case 6:
                    str_durretion = 6;   // All
                    break;
            }
            [self getgraphdata:str_currency FromData:str_durretion];
            break;
            
        default:
            break;
            
    }
}
@end
