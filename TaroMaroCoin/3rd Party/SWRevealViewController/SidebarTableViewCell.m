//
//  SidebarTableViewCell.m
//  Redbull_11
//
//  Created by Trainee 11 on 14/04/17.
//  Copyright © 2017 Trainee 11. All rights reserved.
//

#import "SidebarTableViewCell.h"
#import "UIImageView+RJLoader.h"
#import "UIImageView+WebCache.h"

@implementation SidebarTableViewCell{
    NSUserDefaults *ColorCode;
    NSString *strColor;
   
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    ColorCode = [NSUserDefaults standardUserDefaults];
    strColor = [NSString stringWithFormat:@"%@",[ColorCode valueForKey:@"colorcode"]];
    
    // Initialization code
    _logoutbtn.layer.borderWidth =0.5f;
    _logoutbtn.layer.borderColor = [[UIColor whiteColor]CGColor];
    
    
    
}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

- (IBAction)logoutbtn:(id)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"registered"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
