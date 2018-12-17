//
//  SidebarTableViewCell.h
//  Redbull_11
//
//  Created by Trainee 11 on 14/04/17.
//  Copyright © 2017 Trainee 11. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface SidebarTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *logoutbtn;

@property (weak, nonatomic) IBOutlet UIImageView *user_profile;
@property (weak, nonatomic) IBOutlet UILabel *lbl_name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_email;

@property (weak, nonatomic) IBOutlet UIImageView *imgHome;
@property (weak, nonatomic) IBOutlet UIImageView *imgGlobal;
@property (weak, nonatomic) IBOutlet UIImageView *imgNews;
@property (weak, nonatomic) IBOutlet UIImageView *imgSettings;
@property (weak, nonatomic) IBOutlet UIImageView *imgAboutUs;
@property (weak, nonatomic) IBOutlet UIImageView *imgShare;
@property (weak, nonatomic) IBOutlet UIImageView *imgICOs;
@property (weak, nonatomic) IBOutlet UIImageView *imgSupport;
@property (weak, nonatomic) IBOutlet UIImageView *imgRateUs;

@property (weak, nonatomic) IBOutlet UILabel *lblStatic1;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic2;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic3;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic4;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic5;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic6;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic7;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic8;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic9;

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblSubName;

@end
