//
//  JLElasticRefreshView.h
//  Janlor
//
//  Created by Janlor on 2018/5/7.
//  Copyright © 2018 Janlor. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JLElasticRefreshState) {
    JLElasticRefreshStateStopped = 1,
    JLElasticRefreshStateDragging,
    JLElasticRefreshStateAnimatingBounce,
    JLElasticRefreshStateLoading,
    JLElasticRefreshStateAnimatingToStopped,
};

@class JLElasticRefreshLoadingView;

@interface JLElasticRefreshView : UIView

@property (nonatomic, copy) void (^actionHandler)(void);
@property (nonatomic, strong) JLElasticRefreshLoadingView *loadingView;
@property (nonatomic, assign) BOOL observing;
@property (nonatomic, strong) UIColor *fillColor;

- (void)disassociateDisplayLink;
- (void)stopLoading;

@end
