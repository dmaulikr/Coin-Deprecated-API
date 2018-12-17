//
//  CoinDataTableViewCell.m
//  TaroMaroCoin
//
//  Created by nestcode on 3/5/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import "CoinDataTableViewCell.h"

@implementation CoinDataTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _viewCoinList.layer.cornerRadius = 10.0f;
    _viewCoinList.layer.masksToBounds = NO;
    _viewCoinList.layer.shadowOffset = CGSizeMake(-2, 2);
    _viewCoinList.layer.shadowRadius = 5;
    _viewCoinList.layer.shadowOpacity = 0.5;
    
    NSString *strTheme = [[NSUserDefaults standardUserDefaults]
                stringForKey:@"theme"];
    
    if ([strTheme isEqualToString:@"1"]) {
        _viewCoinList.layer.borderWidth = 0.5f;
        _viewCoinList.layer.borderColor = [UIColor orangeColor].CGColor;
      //  _viewCoinList.layer.shadowColor = [UIColor whiteColor].CGColor;
    }
    else{
        _viewCoinList.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    }
}


@end
