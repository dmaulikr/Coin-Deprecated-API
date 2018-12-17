//
//  AITutorialViewController.h
//  15 weeks workout
//
//  Created by Maulik Desai on 8/17/18.
//  Copyright © 2018 Maulik Desai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface AITutorialViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;

@end
