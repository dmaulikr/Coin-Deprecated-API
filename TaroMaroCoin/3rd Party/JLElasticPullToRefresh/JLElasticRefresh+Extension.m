//
//  JLElasticRefresh+Extension.m
//  Janlor
//
//  Created by Janlor on 2018/5/7.
//  Copyright © 2018 Janlor. All rights reserved.
//

#import "JLElasticRefresh+Extension.h"
#import <objc/runtime.h>
#import "JLElasticRefreshLoadingView.h"
#import "JLElasticRefreshView.h"

#pragma mark - NSObject

@interface NSObject ()

@property (nonatomic, strong) NSMutableArray *jler_observers;

@end

@implementation NSObject (JLElasticRefresh)

static char *jler_associatedObserversKeys = "observers";

- (NSMutableArray *)jler_observers {
    NSMutableArray *observers = objc_getAssociatedObject(self, jler_associatedObserversKeys);
    if (!observers) {
        observers = [NSMutableArray array];
        self.jler_observers = observers;
    }
    return observers;
}

- (void)setJler_observers:(NSMutableArray *)jler_observers {
    objc_setAssociatedObject(self, jler_associatedObserversKeys, jler_observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)jler_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    NSDictionary *observerInfo = @{keyPath: observer};
    if (![self.jler_observers containsObject:observerInfo]) {
        [self.jler_observers addObject:observerInfo];
        [self addObserver:observer forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)jler_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    NSDictionary *observerInfo = @{keyPath: observer};
    if ([self.jler_observers containsObject:observerInfo]) {
        [self.jler_observers removeObject:observerInfo];
        [self removeObserver:observer forKeyPath:keyPath];
    }
}

@end

#pragma mark - UIScrollView

@interface UIScrollView ()

@property (nonatomic, strong) JLElasticRefreshView *refreshView;

@end

@implementation UIScrollView (JLElasticRefresh)

static char *jler_associatedRefreshViewKeys = "RefreshView";

- (UIView *)refreshView {
    return objc_getAssociatedObject(self, jler_associatedRefreshViewKeys);
}

- (void)setRefreshView:(JLElasticRefreshView *)refreshView {
    objc_setAssociatedObject(self, jler_associatedRefreshViewKeys, refreshView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)jler_addRefreshWithActionHandler:(void(^)(void))actionHandler loadingView:(JLElasticRefreshLoadingView *)loadingView {
    self.multipleTouchEnabled = NO;
    self.panGestureRecognizer.minimumNumberOfTouches = 1;
    
    JLElasticRefreshView *refreshView = [[JLElasticRefreshView alloc] init];
    self.refreshView = refreshView;
    refreshView.actionHandler = actionHandler;
    refreshView.loadingView = loadingView;
    [self addSubview:refreshView];
    refreshView.observing = YES;
}

- (void)jler_removeRefresh {
    [self.refreshView disassociateDisplayLink];
    self.refreshView.observing = NO;
    [self.refreshView removeFromSuperview];
}

- (void)jler_setRefreshBackgroundColor:(UIColor *)color {
    self.refreshView.backgroundColor = color;
}

- (void)jler_setRefreshFillColor:(UIColor *)color {
    self.refreshView.fillColor = color;
}

- (void)jler_stopLoading {
    [self.refreshView stopLoading];
}

@end

#pragma mark - UIView

@implementation UIView (JLElasticRefresh)

- (CGPoint)jler_center:(BOOL)usePresentationLayerIfPossible {
    CALayer *presentationLayer = self.layer.presentationLayer;
    if (usePresentationLayerIfPossible && presentationLayer) {
        return presentationLayer.position;
    }
    return self.center;
}

@end

#pragma mark - UIPanGestureRecognizer

@implementation UIPanGestureRecognizer (JLElasticRefresh)

- (void)jler_resign {
    self.enabled = NO;
    self.enabled = YES;
}

@end

