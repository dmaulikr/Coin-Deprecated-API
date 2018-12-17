//
//  JLElasticRefreshLoadingView.h
//  Janlor
//
//  Created by Janlor on 2018/5/7.
//  Copyright © 2018 Janlor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLElasticRefreshLoadingView : UIView

@property (nonatomic, strong) CAShapeLayer *maskLayer;

- (void)setPullProgress:(CGFloat)progress;
- (void)startAnimating;
- (void)stopLoading;

@end
