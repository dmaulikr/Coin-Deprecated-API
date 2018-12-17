//
//  ICOsTableViewCell.m
//  TaroMaroCoin
//
//  Created by nestcode on 3/9/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import "ICOsTableViewCell.h"

@implementation ICOsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _viewLiveICO.layer.cornerRadius = 10.0f;
    _viewLiveICO.layer.masksToBounds = NO;
    _viewLiveICO.layer.shadowOffset = CGSizeMake(-2, 2);
    _viewLiveICO.layer.shadowRadius = 5;
    _viewLiveICO.layer.shadowOpacity = 0.5;
    
    NSString *strTheme = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"theme"];
    
    if ([strTheme isEqualToString:@"1"]) {
        _viewLiveICO.layer.shadowColor = [UIColor whiteColor].CGColor;
    }
    else{
        _viewLiveICO.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
