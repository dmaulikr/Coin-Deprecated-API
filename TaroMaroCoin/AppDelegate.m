//
//  AppDelegate.m
//  TaroMaroCoin
//
//  Created by nestcode on 3/1/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSUserDefaults * isFromLaunch = [NSUserDefaults standardUserDefaults];
    [isFromLaunch setInteger:1 forKey:@"isFromLaunch"];
    [isFromLaunch synchronize];
    
    if (IS_IPHONE_X){
        [application setStatusBarHidden:NO];
    }
    
    NSString *valueToSave = @"USD";
    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"CurrencyName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self CopyandCheckdb];
    
    [application setMinimumBackgroundFetchInterval:60];
    
    WCSession *session = [WCSession defaultSession];
    session.delegate = self;
    [session activateSession];
    
    NSString *selectedValue = @"0";
    [[NSUserDefaults standardUserDefaults] setObject:selectedValue forKey:@"CoinsToShow"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
   NSUserDefaults *googleAdID = [NSUserDefaults standardUserDefaults];
    NSString *strGoogleID = [googleAdID valueForKey:@"googleAdID"];
    [GADMobileAds configureWithApplicationID:strGoogleID];
    
    NSUserDefaults *Visited1 = [NSUserDefaults standardUserDefaults];
    [Visited1 setInteger:1 forKey:@"MainVisited"];
    [Visited1 synchronize];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reload_data" object:self];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSData *))completionHandler {
    // Instantiate a session configuration object.
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // Instantiate a session object.
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    // Create a data task object to perform the data downloading.
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            // If any error occurs then just display its description on the console.
            NSLog(@"%@",[error localizedDescription]);
        } else {
            // If no error occurs, check the HTTP status code.
            NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
            
            // If it's other than 200, then show it on the console.
            if (HTTPStatusCode != 200) {
                NSLog(@"HTTP status code = %ld", (long)HTTPStatusCode);
            }
            
            // Call the completion handler with the returned data on the main thread.
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completionHandler(data);
            }];
        }
        
    }];
    
    // Resume the task.
    [task resume];
}

-(void)CopyandCheckdb
{
    NSArray *dirpath = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    
    NSString *docdir =[dirpath objectAtIndex:0];
    
    self.strdbpath =[docdir stringByAppendingString :@"CoinFav_DB.sqlite"];
    
    NSLog(@"dbpath =%@",self.strdbpath);
    
    BOOL success;
    
    NSFileManager *fm =[NSFileManager defaultManager];
    
    success =[fm fileExistsAtPath:self.strdbpath];
    
    
    
    if (success)
    {
        NSLog(@"Already Present");
        
    }
    else
    {
        NSError *err;
        NSString *resource =[[NSBundle mainBundle]pathForResource:@"CoinFav_DB" ofType:@"sqlite"];
        
        success =[fm copyItemAtPath:resource toPath:self.strdbpath error:&err];
        
        if (success)
        {
            NSLog(@"Successfully Created");
        }
        else
        {
            NSLog(@"Error = %@",err);
        }
    }
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - WCSessionDelegate

- (void)session:(WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(NSError *)error {
    
}

- (void)sessionDidBecomeInactive:(WCSession *)session {
    
}

- (void)sessionDidDeactivate:(WCSession *)session {
    
}

- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *, id> *)message replyHandler:(void(^)(NSDictionary<NSString *, id> *replyMessage))replyHandler {
    NSString *action = [message objectForKey:@"action"];
    if ([@"forceSync" isEqualToString:action]) {
        [self syncExchangeListWithWatch];
    }
    
    replyHandler(@{});
}

#pragma mark - Watch Relative

- (void)syncExchangeListWithWatch {
    WCSession *session = [WCSession defaultSession];
    if (!session.isReachable) return;
    
    [session
     transferUserInfo:@{
                        @"action": @"syncExchangeList",
                        @"payload": [CNSExchangeManager defaultManager].exchangeList
                        }];
}

@end
