//
//  ICODetailViewController.h
//  TaroMaroCoin
//
//  Created by nestcode on 3/10/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"
#import <GoogleMobileAds/GADBannerView.h>
#import <GoogleMobileAds/GADRequest.h>
#import "AppID.h"
#import <GoogleMobileAds/GADInterstitial.h>

@interface ICODetailViewController : UIViewController <UIWebViewDelegate,GADBannerViewDelegate,GADInterstitialDelegate>{
    GADBannerView *BannerView_;
}

@property (weak, nonatomic) IBOutlet UIWebView *WebNewsDetail;
@property (nonatomic, retain) NSString *strNewsURL;
@property (nonatomic, retain) NSString *strICOURL;

@property (weak, nonatomic) IBOutlet UISegmentedControl *ICOSegment;
- (IBAction)SegmentChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UIWebView *WebICOWatch;

@property (weak, nonatomic) IBOutlet UIView *adView;
@property(nonatomic,strong) GADBannerView *BannerView;
-(GADRequest *)createRequest;
@property(nonatomic, strong) GADInterstitial *interstitial;
@end
