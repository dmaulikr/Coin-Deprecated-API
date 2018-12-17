//
//  JLElasticRefreshLoadingView.m
//  Janlor
//
//  Created by Janlor on 2018/5/7.
//  Copyright © 2018 Janlor. All rights reserved.
//

#import "JLElasticRefreshLoadingView.h"

@implementation JLElasticRefreshLoadingView

#pragma mark - Constructors

- (instancetype)init {
    if (self = [super init]) {
        self.frame = CGRectZero;
    }
    return self;
}

#pragma mark - Methods

- (void)setPullProgress:(CGFloat)progress {
    
}

- (void)startAnimating {
    
}

- (void)stopLoading {
    
}

#pragma mark - Lazy

- (CAShapeLayer *)maskLayer {
    if (!_maskLayer) {
        _maskLayer = [CAShapeLayer layer];
        _maskLayer.backgroundColor = UIColor.clearColor.CGColor;
        _maskLayer.fillColor = UIColor.blackColor.CGColor;
        _maskLayer.actions = @{@"path": [NSNull null], @"position": [NSNull null], @"bounds": [NSNull null]};
        self.layer.mask = _maskLayer;
    }
    return _maskLayer;
}

@end
