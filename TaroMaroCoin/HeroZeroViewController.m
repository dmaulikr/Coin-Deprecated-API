//
//  HeroZeroViewController.m
//  TaroMaroCoin
//
//  Created by nestcode on 3/9/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import "HeroZeroViewController.h"

@interface HeroZeroViewController ()

@end

@implementation HeroZeroViewController{
    NSString *CName, *CSymbol;
    NSMutableDictionary *dictGlobalData;
    int selectedsort, selectedCurrency;
    
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
    NSMutableArray *price4rmapi;
    NSMutableArray *price4graphdata;
    NSMutableArray *time4graph;
    NSInteger *i ;
    NSString *strCoin;
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
    CName = [[NSUserDefaults standardUserDefaults]
             stringForKey:@"CurrencyName"];
    
    [_btnCurrency setTitle:CName];
    
    _viewChart.hidden = YES;
    
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
        [_detailSegment setTintColor:[UIColor orangeColor]];
        [_detailSegment setBackgroundColor:[UIColor blackColor]];
        [_viewChart setBackgroundColor:[UIColor blackColor]];
        [_chartView setBackgroundColor:[UIColor blackColor]];
        [_viewData setBackgroundColor:[UIColor blackColor]];
        [self.view setBackgroundColor:[UIColor blackColor]];
        
        [_lblStatic1 setTextColor:[UIColor orangeColor]];
        [_lblStatic2 setTextColor:[UIColor orangeColor]];
        [_lblStatic3 setTextColor:[UIColor orangeColor]];
        [_lblStatic4 setTextColor:[UIColor orangeColor]];
        [_lblStatic5 setTextColor:[UIColor orangeColor]];
        [_lblStatic6 setTextColor:[UIColor orangeColor]];
        
        [_lbl24hVolume setTextColor:[UIColor whiteColor]];
        [_lblChartData setTextColor:[UIColor whiteColor]];
        [_lblMarketCap setTextColor:[UIColor whiteColor]];
        [_lblActiveAssets setTextColor:[UIColor whiteColor]];
        [_lblActiveMarkets setTextColor:[UIColor whiteColor]];
        [_lblActiveCurrencies setTextColor:[UIColor whiteColor]];
        [_lblBitcoinPerMarketCap setTextColor:[UIColor whiteColor]];
        
        
    }
    else{
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0];
        [_detailSegment setTintColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        [_detailSegment setBackgroundColor:[UIColor whiteColor]];
        [_viewChart setBackgroundColor:[UIColor whiteColor]];
        [_chartView setBackgroundColor:[UIColor whiteColor]];
        [_viewData setBackgroundColor:[UIColor whiteColor]];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
        [_lblStatic1 setTextColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        [_lblStatic2 setTextColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        [_lblStatic3 setTextColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        [_lblStatic4 setTextColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        [_lblStatic5 setTextColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        [_lblStatic6 setTextColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        
        [_lbl24hVolume setTextColor:[UIColor blackColor]];
        [_lblChartData setTextColor:[UIColor blackColor]];
        [_lblMarketCap setTextColor:[UIColor blackColor]];
        [_lblActiveAssets setTextColor:[UIColor blackColor]];
        [_lblActiveMarkets setTextColor:[UIColor blackColor]];
        [_lblActiveCurrencies setTextColor:[UIColor blackColor]];
        [_lblBitcoinPerMarketCap setTextColor:[UIColor blackColor]];
        
    }
    
    [self CurrencySymbol];
    
    [self APIGlobalData];
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

- (void) createAdBannerView
{
    NSLog(@"%s",__FUNCTION__);
    if (self.BannerView == nil)
    {
        self.BannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0, 0, GAD_SIZE_320x50.width, GAD_SIZE_320x50.height)];
        
        self.BannerView.rootViewController = self;
        [self.adView addSubview:self.BannerView];
        [self.BannerView setBackgroundColor:[UIColor grayColor]];
        BannerView_.adUnitID = MyAdUnitID2;
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



- (IBAction)SegmentChanged:(id)sender {
    switch ([sender selectedSegmentIndex]) {
        case 0:
            _viewData.hidden = NO;
            _viewChart.hidden = YES;
            break;
        case 1:
            [self getgraphdata:@"all"];
            _viewChart.hidden = NO;
            _viewData.hidden = YES;
            break;
        default:
            _viewData.hidden = NO;
            _viewChart.hidden = YES;
            break;
    }
}

-(void)getgraphdata:(NSString*)his_dur{
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
            graphapi = [NSString stringWithFormat:@"http://www.coincap.io/history/BTC"];
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
                price4rmapi =[jsonArray2 valueForKey: @"market_cap"];
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
               // yVals = price4graphdata;
                self.formatter = [[NSDateFormatter alloc] init];
                [self.formatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"yyyyMMMd" options:0 locale:[NSLocale currentLocale]]];
                
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if(error2 == YES){
               // [self.dropref setHidden:YES];
            }
            else{
               // [self.dropref setHidden:NO];
                
                
                [self createlinegrph];
                
            }
            //Run UI Updates
            
        });
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
    
    if ([strTheme isEqualToString:@"1"]) {
        dataset.fillColor = [UIColor orangeColor];
        dataset.highlightColor = [UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0];
        linechart.noDataTextColor = [UIColor blackColor];
        [dataset setColor:[UIColor orangeColor]];
        linechart.xAxis.labelPosition = XAxisLabelPositionBottom;
        linechart.xAxis.labelTextColor = [UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0];
    }
    else{
        dataset.fillColor = [UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0];
        dataset.highlightColor = [UIColor orangeColor];
        linechart.noDataTextColor = [UIColor whiteColor];
        [dataset setColor:[UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0]];
        linechart.xAxis.labelPosition = XAxisLabelPositionBottom;
        linechart.xAxis.labelTextColor = [UIColor orangeColor];
    }
    
    linechart.leftAxis.labelTextColor = [UIColor clearColor];
    [linechart.leftAxis setEnabled:NO];
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
    
    self.lblChartData.text = [NSString stringWithFormat:@"Price:$%0.2f Date:%@",entry.y,dateString];
}


-(void)CurrencySymbol{
    
    SQLFile *new = [[SQLFile alloc]init];
    NSString *query = [NSString stringWithFormat:@"select Symbol from CurrencyList where Name ='%@'",CName];
    CSymbol = [[new select_currency:query] objectAtIndex:0];
}

-(void)FillData{
    
    NSString *str24 = [[NSString stringWithFormat:@"total_24h_volume_%@",CName]lowercaseString];
    NSNumber *nbr24Volume = [dictGlobalData valueForKey:str24];
    NSString *str24h = [NSString stringWithFormat:@"%@%@",CSymbol,[self suffixNumber:nbr24Volume]];
    _lbl24hVolume.text = str24h;
    
    NSString *strMarketCap = [[NSString stringWithFormat:@"total_market_cap_%@",CName]lowercaseString];
    NSNumber *nbrMarketCap = [dictGlobalData valueForKey:strMarketCap];
    NSString *strMarket = [NSString stringWithFormat:@"%@%@",CSymbol,[self suffixNumber:nbrMarketCap]];
    _lblMarketCap.text = strMarket;
    _lblBitcoinPerMarketCap.text = [NSString stringWithFormat:@"%@%%",[dictGlobalData valueForKey:@"bitcoin_percentage_of_market_cap"]];
    _lblActiveCurrencies.text = [NSString stringWithFormat:@"%@",[dictGlobalData valueForKey:@"active_currencies"]];
    _lblActiveAssets.text = [NSString stringWithFormat:@"%@",[dictGlobalData valueForKey:@"active_assets"]];
    _lblActiveMarkets.text = [NSString stringWithFormat:@"%@",[dictGlobalData valueForKey:@"active_markets"]];
    
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

-(void)APIGlobalData{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        [SVProgressHUD show];
        
        NSString *strUrl = [[NSString stringWithFormat:@"%@%@",URL_GLOBAL,CName]lowercaseString];
        
        [[ApiCallManager sharedApiCallManager] callAPIWithDelegate:self withURL:strUrl withData:nil andCallBack:CALL_TYPE_URL_GLOBAL];
    }
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


#pragma mark - ApiCallManagerDelegate

- (void)parserDidFailWithError:(NSError *)error andCallType:(CallTypeEnum)callType{
    NSLog(@"%s : Error : %@",__FUNCTION__, [error localizedDescription]);
}

- (void)parserSuccessDelegateDidFinish:(NSDictionary *)dictResult andCallType:(CallTypeEnum)callType{
    [SVProgressHUD dismiss];
    if (callType == CALL_TYPE_URL_GLOBAL){
        dictGlobalData = [[NSMutableDictionary alloc]init];
        dictGlobalData = [dictResult mutableCopy];
        [self FillData];
    }
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
         
         [_btnCurrency setTitle:CName];
         
         [self APIGlobalData];
         
     }cancelBlock:^(ActionSheetStringPicker *picker)
     {
         
     }origin:sender];
}
@end
