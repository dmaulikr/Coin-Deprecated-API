//
//  ICOsTableViewCell.h
//  TaroMaroCoin
//
//  Created by nestcode on 3/9/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICOsTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIView *viewLiveICO;
@property (weak, nonatomic) IBOutlet UIImageView *imgLIVECoin;
@property (weak, nonatomic) IBOutlet UILabel *lblLIVECoinName;
@property (weak, nonatomic) IBOutlet UILabel *lblLIVECoinDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblLIVECoinStart;
@property (weak, nonatomic) IBOutlet UILabel *lblLIVECoinEnd;

@property (weak, nonatomic) IBOutlet UILabel *lblStaticStart;
@property (weak, nonatomic) IBOutlet UILabel *lblStaticEnd;


@end
