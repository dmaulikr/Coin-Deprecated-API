//
//  TodayViewController.m
//  CoinPrice
//
//  Created by nestcode on 3/8/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Init the data array
    cryptoDataArray = [[NSMutableArray alloc] init];
    
    // [[NSUserDefaults alloc] initWithSuiteName:@"group.com.nestcode.cryptocurrency"];
    
    NSUserDefaults *shard = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.nestcode.cryptocurrency"];
    
    NSData *widgetCryptoIdData = [shard objectForKey:@"widgetCryptoIdArray"];
    
    if (widgetCryptoIdData) {
        widgetCryptoIdArray = [NSKeyedUnarchiver unarchiveObjectWithData:widgetCryptoIdData];
    } else {
        widgetCryptoIdArray = [[NSMutableArray alloc] init];
    }
    
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"cryptoImageData" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
    NSError *error = nil;
    imageDataArray = [NSJSONSerialization JSONObjectWithData:jsonData options: 0 error:&error];
    
    
    NSLog(@"Array: %@", widgetCryptoIdData);
    
    //    NSInteger counter = 0;
    //    for (NSString *idString in widgetCryptoIdArray) {
    //        [self getAndUpdateCurrencyDataWithId:idString andIndex:counter++];
    //    }
    
    for (NSInteger i = 0; i < [widgetCryptoIdArray count]; i++) {
        NSLog(@"Caller getAndUpdate på index %li\n", (long)i);
        [cryptoDataArray addObject:[[CryptoWidgetObject alloc] initBasic]];
        [self getAndUpdateCurrencyDataWithId:[widgetCryptoIdArray objectAtIndex:i] andIndex:i];
    }
    
    // self.preferredContentSize = CGSizeMake(self.view.frame.size.width, 36*[widgetCryptoIdArray count]);

    if (37*[widgetCryptoIdArray count] > 120) {
        [self.extensionContext setWidgetLargestAvailableDisplayMode:NCWidgetDisplayModeExpanded];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    NSLog(@"Updates...\n");
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    completionHandler(NCUpdateResultNewData);
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode
                         withMaximumSize:(CGSize)maxSize {
    if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        self.preferredContentSize = CGSizeMake(0, 110);
    }
    else{
        self.preferredContentSize = CGSizeMake(0, 37*[widgetCryptoIdArray count]);
    }
}


#pragma mark - Downloade data


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


- (void)getAndUpdateCurrencyDataWithId:(NSString *)idString andIndex:(NSInteger)index{
    
    NSString *URLString = [NSString stringWithFormat:@"https://api.coinmarketcap.com/v1/ticker/%@/", idString];
    NSURL *URL = [NSURL URLWithString:URLString];
    
    [self downloadDataFromURL:URL withCompletionHandler:^(NSData *data){
        if (data != nil) {
            NSError *error2;
            NSMutableArray *returnedArr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error2];
            if (error2 != nil) {
                NSLog(@"%@", [error2 localizedDescription]);
            } else {
                // Her kommer det ny data!
                
                NSLog(@"The returned arr: %@", returnedArr);
                
                NSString *idString = [[returnedArr objectAtIndex:0] objectForKey:@"id"];
                NSString *name = [[returnedArr objectAtIndex:0] objectForKey:@"name"];
                NSString *price_usd = [[returnedArr objectAtIndex:0] objectForKey:@"price_usd"];
                NSString *percent_change_1h = [[returnedArr objectAtIndex:0] objectForKey:@"percent_change_1h"];
                NSString *percent_change_24h = [[returnedArr objectAtIndex:0] objectForKey:@"percent_change_24h"];
                NSString *percent_change_7d = [[returnedArr objectAtIndex:0] objectForKey:@"percent_change_7d"];
                NSString *last_updated = [[returnedArr objectAtIndex:0] objectForKey:@"last_updated"];
                
                NSString *imgId = @"";
                for (NSInteger i = 0; i < imageDataArray.count; i++) {
                    if ([[[imageDataArray objectAtIndex:i] objectForKey:@"name"] isEqualToString:name]) {
                        imgId = [[imageDataArray objectAtIndex:i] objectForKey:@"id"];
                        break;
                    }
                }
                
                // NSLog(@"index : %li, count : %li\n",(long)index, [cryptoDataArray count]);
                
                if (index + 1> [cryptoDataArray count]) {
                    // Add new data
                    NSLog(@"Adding data\n");
                    CryptoWidgetObject *dataObject = [[CryptoWidgetObject alloc]
                                                      initWithId:idString
                                                      name:name
                                                      price_usd:price_usd
                                                      percent_change_1h:percent_change_1h
                                                      percent_change_24h:percent_change_24h
                                                      percent_change_7d:percent_change_7d
                                                      last_updated:last_updated];
                    [cryptoDataArray addObject:dataObject];
                    
                    
                    [self getAndUpdateCurrencyImageWithIndex:index andId:imgId];
                    
                    
                } else {
                    // Update old data
                    NSLog(@"Updating old data\n");
                    [[cryptoDataArray objectAtIndex:index] updateDataWithId:idString
                                                                       name:name
                                                                  price_usd:price_usd
                                                          percent_change_1h:percent_change_1h
                                                         percent_change_24h:percent_change_24h
                                                          percent_change_7d:percent_change_7d
                                                               last_updated:last_updated];
                    // [cryptoDataArray setObject:dataObject atIndexedSubscript:index];
                    if ([[cryptoDataArray objectAtIndex:index] getCryptoImage] == nil) {
                        [self getAndUpdateCurrencyImageWithIndex:index andId:imgId];
                        // NSLog(@"Caller img downloade\n");
                    }
                    
                }
                
                // [cryptoDataArray replaceObjectAtIndex:index withObject:dataObject];
                
                
                /*
                 if ([cryptoDataArray count] < start+i) {
                 // Endre det eksisterende elementet
                 [cryptoDataArray replaceObjectAtIndex:start+i withObject:cryptoDataObject];
                 } else {
                 // Legg til et nytt element
                 [cryptoDataArray addObject:cryptoDataObject];
                 }
                 */
                
                
                
                // Oppdater table-viewet!
                [self.tableView reloadData];
            }
        } else {
            NSLog(@"Returned dict is nil");
        }
        
    }];
}

- (void)getAndUpdateCurrencyImageWithIndex:(NSInteger)index andId:(NSString*)imgID {
    // Link found in sourcecode at coinmarketcap.com
    NSString *URLString = [NSString stringWithFormat:@"https://files.coinmarketcap.com/static/img/coins/32x32/%@.png", imgID];
    NSURL *URL = [NSURL URLWithString:URLString];
    [self downloadDataFromURL:URL withCompletionHandler:^(NSData *data){
        if (data != nil) {
            // Her kommer det ny data!
            [[cryptoDataArray objectAtIndex:index] setCryptoImage:[UIImage imageWithData:data]];
            [self.tableView reloadData];
        } else {
            NSLog(@"Image data is nil...\n");
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // NSLog(@"Reload..\n");
    return [cryptoDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cryptoDataArray count] == 0) {
        UITableViewCell * theCell = [tableView dequeueReusableCellWithIdentifier:@"ingenData" forIndexPath:indexPath];
        return theCell;
    }
    
    WidgetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"widgetCell" forIndexPath:indexPath];
    
    CryptoWidgetObject *cryptoDataObject = [cryptoDataArray objectAtIndex:indexPath.row];
    
    // Name
    [cell.widgetCryptoNameLabel setText:cryptoDataObject.name];
    
    // Price
    [cell.widgetCryptoPriceLabel setText:[NSString stringWithFormat:@"$ %@", cryptoDataObject.price_usd]];
    
    // Diff
    cell.widgetCryptoDifferenceLabel.layer.masksToBounds = YES;
    [cell.widgetCryptoDifferenceLabel.layer setCornerRadius:5.0f];
    
    NSString *diffText = [NSString stringWithFormat:@"%@%%", cryptoDataObject.percent_change_24h];
    if ([diffText containsString:@"-"]) {
        [cell.widgetCryptoDifferenceLabel setBackgroundColor:[UIColor redColor]];
    } else {
        [cell.widgetCryptoDifferenceLabel setBackgroundColor:[UIColor colorWithRed:19.0f/255.0f green:151.0f/255.0f blue:29.0f/255.0f alpha:1.0]];
        diffText = [NSString stringWithFormat:@"+%@", diffText];
    }
    [cell.widgetCryptoDifferenceLabel setText:diffText];
    
    // Image
    if (cryptoDataObject.image != nil) {
        [cell.widgetCryptoImageView setImage:cryptoDataObject.image];
    }
    
    return cell;
}


@end

