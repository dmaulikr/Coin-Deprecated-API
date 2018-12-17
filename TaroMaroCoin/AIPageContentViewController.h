//
//  AIPageContentViewController.h
//  15 weeks workout
//
//  Created by Maulik Desai on 8/17/18.
//  Copyright © 2018 Maulik Desai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AIPageContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property NSUInteger pageIndex;
@property NSString *imageFile;

@end
