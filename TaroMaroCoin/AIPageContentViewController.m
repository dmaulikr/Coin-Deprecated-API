//
//  AIPageContentViewController.m
//  15 weeks workout
//
//  Created by Maulik Desai on 8/17/18.
//  Copyright © 2018 Maulik Desai. All rights reserved.
//

#import "AIPageContentViewController.h"
#import "AITutorialViewController.h"

@interface AIPageContentViewController ()

@end

@implementation AIPageContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
    
}


@end
