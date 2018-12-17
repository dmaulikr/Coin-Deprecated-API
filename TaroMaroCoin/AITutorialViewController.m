//
//  AITutorialViewController.m
//  15 weeks workout
//
//  Created by Maulik Desai on 8/17/18.
//  Copyright © 2018 Maulik Desai. All rights reserved.
//

#import "AITutorialViewController.h"

@interface AITutorialViewController ()

@end

@implementation AITutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Create the data model
    self.pageTitles = @[@"", @"", @"", @"", @"", @"",@"", @"", @"", @"", @"", @""];
    
    self.pageImages = @[@"Image1.png", @"Image2.png", @"Image3.png",
                        @"Image4.png", @"Image5.png", @"Image6.png", @"Image7.png",
                        @"Image8.png", @"Image9.png", @"Image10.png"];
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    ViewController *startingViewController = [self viewControllerAtIndex:0];
    
    [self.pageViewController
     setViewControllers:@[startingViewController]
     direction:UIPageViewControllerNavigationDirectionForward
     animated:NO
     completion:nil];
    
    self.pageViewController.view.frame = CGRectMake(0, 70,
                                                    CGRectGetWidth(self.view.frame),
                                                    CGRectGetHeight(self.view.frame) - 40);
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

#pragma mark - Actions

- (IBAction)actionHideTutorial:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (ViewController*) viewControllerAtIndex: (NSUInteger) index {
    
    if (([self.pageImages count] == 0) ||
        (index >= [self.pageImages count])) {
        return nil;
    }
    
    ViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = ((ViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = ((ViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageImages count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return [self.pageImages count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

@end
