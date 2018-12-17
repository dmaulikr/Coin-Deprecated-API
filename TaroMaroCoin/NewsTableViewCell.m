//
//  NewsTableViewCell.m
//  TaroMaroCoin
//
//  Created by nestcode on 3/9/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import "NewsTableViewCell.h"

@implementation NewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _viewNewsCell.layer.cornerRadius = 10.0f;
    
    _viewNewsCell.layer.masksToBounds = NO;
    _viewNewsCell.layer.shadowOffset = CGSizeMake(-2, 2);
    _viewNewsCell.layer.shadowRadius = 5;
    _viewNewsCell.layer.shadowOpacity = 0.5;
    
    NSString *strTheme = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"theme"];
    
    if ([strTheme isEqualToString:@"1"]) {
        _viewNewsCell.layer.shadowColor = [UIColor whiteColor].CGColor;
        
    }
    else{
        _viewNewsCell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
