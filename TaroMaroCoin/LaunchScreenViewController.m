//
//  LaunchScreenViewController.m
//  EROSCOIN
//
//  Created by Maulik D'sai on 21/11/17.
//  Copyright © 2017 eroscoin. All rights reserved.
//

#import "LaunchScreenViewController.h"


@interface LaunchScreenViewController ()

@end

static NSString * const LanguageSaveKey = @"currentLanguageKey";

@implementation LaunchScreenViewController{
    NSUserDefaults *isLogin;
    NSUserDefaults *UserAuth, *moduleLock;
    NSString *strCallType;
    NSUserDefaults *userLanguage;
    NSUserDefaults *userFireBaseToken, *StepFlag, *isFromLaunch, *isFirstTime;
    
    NSUserDefaults *UserFake;
    BOOL isUserFake;
    NSInteger m;
    NSUserDefaults *Visited1;
    NSUserDefaults *AdvertData;
    NSUserDefaults *isBanner, *isFullScreen, *Interval, *bannerID, *FullID;
    NSString *strBanner, *strFull;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AdvertData = [NSUserDefaults standardUserDefaults];
    UserFake = [NSUserDefaults standardUserDefaults];
    isBanner = [NSUserDefaults standardUserDefaults];
    isFullScreen = [NSUserDefaults standardUserDefaults];
    Interval = [NSUserDefaults standardUserDefaults];
    bannerID = [NSUserDefaults standardUserDefaults];
    FullID = [NSUserDefaults standardUserDefaults];
    
    isFromLaunch = [NSUserDefaults standardUserDefaults];
    [isFromLaunch setInteger:1 forKey:@"isFromLaunch"];
    [isFromLaunch synchronize];
    isFirstTime = [NSUserDefaults standardUserDefaults];
    
    [self APIAdData];
    
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


- (void)requestHandler:(HTTPRequestHandler *)requestHandler didFinishWithData:(NSData *)data andCallBack:(CallTypeEnum)callType
{
    self.view.userInteractionEnabled = YES;
    
    
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *jsonRes = [response JSONValue];
    
    if ([[jsonRes valueForKey:@"message"] isEqualToString:@"Unauthenticated."]) {
        //    [SVProgressHUD dismiss];
        // [isLogin setInteger:0 forKey:@"LoggedIn"];
        //  [isLogin synchronize];
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Error"
                                     message:@"Unauthenticated"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //  [self performSegueWithIdentifier:@"hometoLogout" sender:self];
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    else  {
        [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_AD_BASE];
        NSLog(@"%@",jsonRes);
        
        if ([[jsonRes valueForKey:@"status"]  isEqualToString:@"error"]) {
            if ([isFirstTime integerForKey:@"isFirstTime"] == 1) {
                [self performSegueWithIdentifier:@"isFirstTime" sender:self];
                [isFirstTime setInteger:0 forKey:@"isFirstTime"];
                [isFirstTime synchronize];
            }
            else{
                [self performSegueWithIdentifier:@"toHome" sender:self];
            }
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
            
            if (dictVersion == NULL) {
                if ([isFirstTime integerForKey:@"isFirstTime"] == 1) {
                    [self performSegueWithIdentifier:@"isFirstTime" sender:self];
                    [isFirstTime setInteger:0 forKey:@"isFirstTime"];
                    [isFirstTime synchronize];
                }
                else{
                    [self performSegueWithIdentifier:@"toHome" sender:self];
                }
            }
            else {
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
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://itunes.apple.com/us/app/cryptocurrency-coinmarketcap/id1376008786?ls=1&mt=8"]];
                        }];
                        [alert showWarning:self.parentViewController title:@"Update Alert!!" subTitle:strUpdateLog closeButtonTitle:nil duration:0.0f];
                    }
                }
            }
        }
    }
}


@end
