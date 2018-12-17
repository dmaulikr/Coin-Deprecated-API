//
//  SettingsViewController.h
//  TaroMaroCoin
//
//  Created by nestcode on 3/9/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLFile.h"
#import "CoinDetailsViewController.h"
#import "ActionSheetPicker.h"
#import "SWRevealViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <GoogleMobileAds/GADBannerView.h>
#import <GoogleMobileAds/GADRequest.h>
#import "AppID.h"
#import <GoogleMobileAds/GADInterstitial.h>

@interface SettingsViewController : UIViewController<GADBannerViewDelegate,GADInterstitialDelegate>{
    GADBannerView *BannerView_;
}


@property (weak, nonatomic) IBOutlet UILabel *lblCurrencyName;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectCurrency;
- (IBAction)onCurrencySelected:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *lblCoinsToDisplay;
@property (weak, nonatomic) IBOutlet UIButton *btnCoinsToDisplay;
- (IBAction)onCoinsToDisplaySelected:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

- (IBAction)onThemeClicked:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *lblStatic1;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic2;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic3;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic4;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic5;
@property (weak, nonatomic) IBOutlet UISwitch *switchonoff;

@property (weak, nonatomic) IBOutlet UIView *adView;
@property(nonatomic,strong) GADBannerView *BannerView;
-(GADRequest *)createRequest;
@property(nonatomic, strong) GADInterstitial *interstitial;

@end
