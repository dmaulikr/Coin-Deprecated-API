//
//  NewsTableViewCell.h
//  TaroMaroCoin
//
//  Created by nestcode on 3/9/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *viewNewsCell;
@property (weak, nonatomic) IBOutlet UIImageView *imgNewsCompany;
@property (weak, nonatomic) IBOutlet UILabel *lblNewsCompanyName;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;

@property (weak, nonatomic) IBOutlet UIImageView *imgNewsImage;
@property (weak, nonatomic) IBOutlet UILabel *lblNewsTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblNewsDesc;

@end
