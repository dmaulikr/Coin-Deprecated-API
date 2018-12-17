//
//  WidgetTableViewCell.h
//  Crypto Ctrl
//
//  Created by Alfred Lieth Årøe on 03.01.2018.
//  Copyright © 2018 Alfred Lieth Årøe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WidgetTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *widgetCryptoImageView;
@property (strong, nonatomic) IBOutlet UILabel *widgetCryptoNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *widgetCryptoPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *widgetCryptoDifferenceLabel;

@end
