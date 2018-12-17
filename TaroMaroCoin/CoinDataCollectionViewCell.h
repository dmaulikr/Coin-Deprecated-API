//
//  CoinDataCollectionViewCell.h
//  TaroMaroCoin
//
//  Created by nestcode on 3/5/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoinDataCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *imgCoin;
@property (weak, nonatomic) IBOutlet UILabel *lblShortName;



@end
