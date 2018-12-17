//
//  NewsDetailViewController.h
//  TaroMaroCoin
//
//  Created by nestcode on 3/9/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "SVProgressHUD.h"
#import <GoogleMobileAds/GADBannerView.h>
#import <GoogleMobileAds/GADRequest.h>
#import "AppID.h"
#import "Reachability.h"
#import <GoogleMobileAds/GADInterstitial.h>

@interface NewsDetailViewController : UIViewController<WKNavigationDelegate,WKUIDelegate,UIWebViewDelegate,GADBannerViewDelegate,GADInterstitialDelegate>{
    GADBannerView *BannerView_;
}

@property (weak, nonatomic) IBOutlet UIWebView *WebNewsDetail;
@property (nonatomic, retain) NSString *strNewsURL;
@property (weak, nonatomic) IBOutlet UIView *adView;
@property(nonatomic,strong) GADBannerView *BannerView;
-(GADRequest *)createRequest;
@property(nonatomic, strong) GADInterstitial *interstitial;
@end
