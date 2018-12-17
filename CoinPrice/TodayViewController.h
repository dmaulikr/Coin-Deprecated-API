//
//  TodayViewController.h
//  CoinPrice
//
//  Created by nestcode on 3/8/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CryptoWidgetObject.h"
#import "WidgetTableViewCell.h"

@interface TodayViewController : UIViewController{
    NSMutableArray *widgetCryptoIdArray;    // ID
    NSMutableArray *cryptoDataArray;        // All data
    NSArray *imageDataArray;                // Data for images
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
