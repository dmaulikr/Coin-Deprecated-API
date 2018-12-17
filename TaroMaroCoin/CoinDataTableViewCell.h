//
//  CoinDataTableViewCell.h
//  TaroMaroCoin
//
//  Created by nestcode on 3/5/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoinDataTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblMarketCap;
@property (weak, nonatomic) IBOutlet UILabel *lblVolume;
@property (weak, nonatomic) IBOutlet UILabel *lbl1h;
@property (weak, nonatomic) IBOutlet UILabel *lbl24h;
@property (weak, nonatomic) IBOutlet UILabel *lbl7d;
@property (weak, nonatomic) IBOutlet UIImageView *imgCoin;
@property (weak, nonatomic) IBOutlet UILabel *lblRank;
@property (weak, nonatomic) IBOutlet UIButton *btnFavImage;

@property (weak, nonatomic) IBOutlet UIView *viewCoinList;


@property (weak, nonatomic) IBOutlet UILabel *lblStatic1;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic2;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic3;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic4;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic5;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic6;



@end
