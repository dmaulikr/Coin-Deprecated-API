//
//  JLElasticRefresh+Extension.h
//  Janlor
//
//  Created by Janlor on 2018/5/7.
//  Copyright © 2018 Janlor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizer.h>

@class JLElasticRefreshLoadingView;

@interface NSObject (JLElasticRefresh)

- (void)jler_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;
- (void)jler_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

@end

@interface UIScrollView (JLElasticRefresh)

- (void)jler_addRefreshWithActionHandler:(void(^)(void))actionHandler
                             loadingView:(JLElasticRefreshLoadingView *)loadingView;
- (void)jler_removeRefresh;
- (void)jler_setRefreshBackgroundColor:(UIColor *)color;
- (void)jler_setRefreshFillColor:(UIColor *)color;
- (void)jler_stopLoading;

@end

@interface UIView (JLElasticRefresh)

- (CGPoint)jler_center:(BOOL)usePresentationLayerIfPossible;

@end

@interface UIPanGestureRecognizer (JLElasticRefresh)

- (void)jler_resign;

@end

