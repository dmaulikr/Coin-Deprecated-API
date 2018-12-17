//
//  JLElasticRefreshLoadingViewCircle.m
//  Janlor
//
//  Created by Janlor on 2018/5/7.
//  Copyright © 2018 Janlor. All rights reserved.
//

#import "JLElasticRefreshLoadingViewCircle.h"

#define kRotationAnimation @"kRotationAnimation"

@interface JLElasticRefreshLoadingViewCircle ()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, assign) CATransform3D identityTransform;

@end

@implementation JLElasticRefreshLoadingViewCircle

- (instancetype)init {
    if (self = [super init]) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.lineWidth = 1.0f;
        _shapeLayer.fillColor = UIColor.clearColor.CGColor;
        _shapeLayer.strokeColor = self.tintColor.CGColor;
        _shapeLayer.actions = @{@"path": [NSNull null], @"position": [NSNull null], @"bounds": [NSNull null]};
        _shapeLayer.anchorPoint = CGPointMake(0.5, 0.5);
        [self.layer addSublayer:_shapeLayer];
        
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = (CGFloat)(1.0 / -500.0);
        CGFloat angle = (CGFloat)(-90.0 * M_PI) / 180.0;
        transform = CATransform3DRotate(transform, angle, 0.0, 0.0, 1.0);
        _identityTransform = transform;
    }
    return self;
}

#pragma mark - Methods

- (void)setPullProgress:(CGFloat)progress {
    [super setPullProgress:progress];
    
    _shapeLayer.strokeEnd = MIN(0.9 * progress, 0.9);
    
    if (progress > 1.0) {
        CGFloat degress = ((progress - 1.0) * 200.0);
        CGFloat angle = (CGFloat)(degress * M_PI) / 180.0;
        _shapeLayer.transform = CATransform3DRotate(_identityTransform, angle, 0.0, 0.0, 1.0);
    } else {
        _shapeLayer.transform = _identityTransform;
    }
}

- (void)startAnimating {
    [super startAnimating];
    
    if ([_shapeLayer animationForKey:kRotationAnimation] != nil) { return; }
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @((CGFloat)(2 * M_PI) + [self currentDegree]);
    rotationAnimation.duration = 1.0;
    rotationAnimation.repeatCount = INFINITY;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [_shapeLayer addAnimation:rotationAnimation forKey:kRotationAnimation];
}

- (void)stopLoading {
    [super stopLoading];
    [_shapeLayer removeAnimationForKey:kRotationAnimation];
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
    _shapeLayer.strokeColor = self.tintColor.CGColor;
}

- (CGFloat)currentDegree {
    id currentDegreeAny = [_shapeLayer valueForKeyPath:@"transform.rotation.z"];
    CGFloat currentDegree = [currentDegreeAny floatValue];
    return currentDegree;
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _shapeLayer.frame = self.bounds;
    
    CGFloat inset = _shapeLayer.lineWidth / 2.0;
    CGRect bounds = _shapeLayer.bounds;
    bounds.origin.x += inset;
    bounds.origin.y += inset;
    bounds.size.width -= 2 * inset;
    bounds.size.height -= 2 * inset;
    _shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:bounds].CGPath;
}

#pragma mark - Lazy

- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
    }
    return _shapeLayer;
}

- (CATransform3D)identityTransform {
    _identityTransform = CATransform3DIdentity;
    return _identityTransform;
}

@end
