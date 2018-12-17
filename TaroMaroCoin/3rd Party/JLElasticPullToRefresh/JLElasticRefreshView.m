//
//  JLElasticRefreshView.m
//  Janlor
//
//  Created by Janlor on 2018/5/7.
//  Copyright © 2018 Janlor. All rights reserved.
//

#import "JLElasticRefreshView.h"
#import "JLElasticRefreshLoadingView.h"
#import "JLElasticRefresh+Extension.h"

#define kContentOffset @"contentOffset"
#define kContentInset @"contentInset"
#define kFrame @"frame"
#define kPanGestureRecognizerState @"panGestureRecognizer.state"

#define kWaveMaxHeight 70.0
#define kMinOffsetToPull 95.0
#define kLoadingContentInset 50.0
#define kLoadingViewSize 30.0

@interface JLElasticRefreshView ()

#pragma mark - Vars

@property (nonatomic, assign) JLElasticRefreshState state;
@property (nonatomic, assign) CGFloat originalContentInsetTop;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CADisplayLink *displayLink;

#pragma mark - Views

@property (nonatomic, strong) UIView *bounceAnimationHelperView;
@property (nonatomic, strong) UIView *cControlPointView;
@property (nonatomic, strong) UIView *l1ControlPointView;
@property (nonatomic, strong) UIView *l2ControlPointView;
@property (nonatomic, strong) UIView *l3ControlPointView;
@property (nonatomic, strong) UIView *r1ControlPointView;
@property (nonatomic, strong) UIView *r2ControlPointView;
@property (nonatomic, strong) UIView *r3ControlPointView;

@end

@implementation JLElasticRefreshView

- (instancetype)init {
    if (self = [super init]) {
        self.frame = CGRectZero;
        
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTick)];
        [_displayLink addToRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
        _displayLink.paused = YES;
        
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.backgroundColor = UIColor.clearColor.CGColor;
        _shapeLayer.fillColor = UIColor.blackColor.CGColor;
        _shapeLayer.actions = @{@"path": [NSNull null], @"position": [NSNull null], @"bounds": [NSNull null]};
        [self.layer addSublayer:_shapeLayer];
        
        _bounceAnimationHelperView = [[UIView alloc] init];
        [self addSubview:_bounceAnimationHelperView];
        _cControlPointView = [[UIView alloc] init];
        [self addSubview:_cControlPointView];
        _l1ControlPointView = [[UIView alloc] init];
        [self addSubview:_l1ControlPointView];
        _l2ControlPointView = [[UIView alloc] init];
        [self addSubview:_l2ControlPointView];
        _l3ControlPointView = [[UIView alloc] init];
        [self addSubview:_l3ControlPointView];
        _r1ControlPointView = [[UIView alloc] init];
        [self addSubview:_r1ControlPointView];
        _r2ControlPointView = [[UIView alloc] init];
        [self addSubview:_r2ControlPointView];
        _r3ControlPointView = [[UIView alloc] init];
        [self addSubview:_r3ControlPointView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillEnterForeground)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        
        _state = JLElasticRefreshStateStopped;
        _originalContentInsetTop = 0.0;
    }
    return self;
}

- (void)dealloc {
    self.observing = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:kContentOffset]) {
        UIScrollView *scrollView = [self scrollView];
        if (!scrollView) { return ; }
        
        CGFloat newContentOffsetY = [change[NSKeyValueChangeNewKey] CGPointValue].y;
        if ((_state == JLElasticRefreshStateLoading || _state == JLElasticRefreshStateAnimatingToStopped) &&
            newContentOffsetY < -scrollView.contentInset.top) {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, -scrollView.contentInset.top);
        } else {
            [self scrollViewDidChangeContentOffset:scrollView.dragging];
        }
        [self layoutSubviews];
    } else if ([keyPath isEqualToString:kContentInset]) {
        UIEdgeInsets newContentInset = [change[NSKeyValueChangeNewKey] UIEdgeInsetsValue];
        CGFloat newContentInsetTop = newContentInset.top;
        _originalContentInsetTop = newContentInsetTop;
    } else if ([keyPath isEqualToString:kFrame]) {
        [self layoutSubviews];
    } else if ([keyPath isEqualToString:kPanGestureRecognizerState]) {
        UIGestureRecognizerState gestureState = [self scrollView].panGestureRecognizer.state;
        if (gestureState == UIGestureRecognizerStateEnded ||
            gestureState == UIGestureRecognizerStateCancelled ||
            gestureState == UIGestureRecognizerStateFailed) {
            [self scrollViewDidChangeContentOffset:NO];
        }
    }
}

#pragma mark - Notifications

- (void)applicationWillEnterForeground {
    if (_state == JLElasticRefreshStateLoading) {
        [self layoutSubviews];
    }
}

#pragma mark - Methods (Public)

- (void)disassociateDisplayLink {
    [self.displayLink invalidate];
}

- (void)stopLoading {
    if (_state == JLElasticRefreshStateAnimatingToStopped) { return; }
    self.state = JLElasticRefreshStateAnimatingToStopped;
}

- (UIScrollView *)scrollView {
    return (UIScrollView *)self.superview;
}

#pragma mark - Methods (Private)

- (BOOL)isAnimating {
    return _state == JLElasticRefreshStateAnimatingBounce ||
    _state == JLElasticRefreshStateAnimatingToStopped;
}

- (CGFloat)actualContentOffsetY {
    UIScrollView *scrollView = [self scrollView];
    if (!scrollView) { return 0.f; }
    return MAX(-scrollView.contentInset.top - scrollView.contentOffset.y, 0.f);
}

- (CGFloat)currentHeight {
    UIScrollView *scrollView = [self scrollView];
    if (!scrollView) { return 0.f; }
    return MAX(-_originalContentInsetTop - scrollView.contentOffset.y, 0.f);
}

- (CGFloat)currentWaveHeight {
    return MIN(self.bounds.size.height / 3.0 * 1.6, kWaveMaxHeight);
}

- (CGPathRef)currentPath {
    CGFloat width = [self scrollView].bounds.size.width;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    BOOL animating = [self isAnimating];
    
    [bezierPath moveToPoint:CGPointZero];
    [bezierPath addLineToPoint:CGPointMake(0.f, [_l3ControlPointView jler_center:animating].y)];
    [bezierPath addCurveToPoint:[_l1ControlPointView jler_center:animating]
                  controlPoint1:[_l3ControlPointView jler_center:animating]
                  controlPoint2:[_l2ControlPointView jler_center:animating]];
    [bezierPath addCurveToPoint:[_r1ControlPointView jler_center:animating]
                  controlPoint1:[_cControlPointView jler_center:animating]
                  controlPoint2:[_r1ControlPointView jler_center:animating]];
    [bezierPath addCurveToPoint:[_r3ControlPointView jler_center:animating]
                  controlPoint1:[_r1ControlPointView jler_center:animating]
                  controlPoint2:[_r2ControlPointView jler_center:animating]];
    [bezierPath addLineToPoint:CGPointMake(width, 0.f)];
    
    [bezierPath closePath];
    
    return bezierPath.CGPath;
}

- (void)scrollViewDidChangeContentOffset:(BOOL)dragging {
    CGFloat offsetY = [self actualContentOffsetY];
    
    if (_state == JLElasticRefreshStateStopped && dragging) {
        self.state = JLElasticRefreshStateDragging;
    } else if (_state == JLElasticRefreshStateDragging && dragging == NO) {
        if (offsetY >= kMinOffsetToPull) {
            self.state = JLElasticRefreshStateAnimatingBounce;
        } else {
            self.state = JLElasticRefreshStateStopped;
        }
    } else if (_state == JLElasticRefreshStateDragging ||
               _state == JLElasticRefreshStateStopped) {
        CGFloat pullProgress = offsetY / kMinOffsetToPull;
        [self.loadingView setPullProgress:pullProgress];
    }
}

- (void)resetScrollViewContentInset:(BOOL)shouldAddObserverWhenFinished animated:(BOOL)animated completion:(void(^)(void))completion {
    UIScrollView *scrollView = [self scrollView];
    if (!scrollView) { return; }
    
    UIEdgeInsets contentInset = scrollView.contentInset;
    contentInset.top = _originalContentInsetTop;
    
    if (_state == JLElasticRefreshStateAnimatingBounce) {
        contentInset.top += [self currentHeight];
    } else if (_state == JLElasticRefreshStateLoading) {
        contentInset.top += kLoadingContentInset;
    }
    
    [scrollView jler_removeObserver:self forKeyPath:kContentInset];
    
    void (^animationBlock)(void) = ^(){
        scrollView.contentInset = contentInset;
    };
    
    void (^completionBlock)(void) = ^(){
        if (shouldAddObserverWhenFinished && self.observing) {
            [scrollView jler_addObserver:self forKeyPath:kContentInset];
            if (completion) { completion(); }
        }
    };
    
    if (animated) {
        [self startDisplayLink];
        [UIView animateWithDuration:0.4 animations:animationBlock completion:^(BOOL finished) {
            [self stopDisplayLink];
            completionBlock();
        }];
    } else {
        animationBlock();
        completionBlock();
    }
}

- (void)animateBounce {
    __weak typeof(self) weakSelf = self;
    
    UIScrollView *scrollView = [self scrollView];
    if (!scrollView) { return; }
    if (!self.observing) { return; }
    
    [self resetScrollViewContentInset:NO animated:NO completion:nil];
    
    CGFloat centerY = kLoadingContentInset;
    CGFloat duration = 0.9;
    
    scrollView.scrollEnabled = NO;
    [self startDisplayLink];
    [scrollView jler_removeObserver:self forKeyPath:kContentOffset];
    [scrollView jler_removeObserver:self forKeyPath:kContentInset];
    [UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:0.43 initialSpringVelocity:0.0 options:0 animations:^{
        weakSelf.cControlPointView.center  = CGPointMake(weakSelf.cControlPointView.center.x, centerY);
        weakSelf.l1ControlPointView.center = CGPointMake(weakSelf.l1ControlPointView.center.x, centerY);
        weakSelf.l2ControlPointView.center = CGPointMake(weakSelf.l2ControlPointView.center.x, centerY);
        weakSelf.l3ControlPointView.center = CGPointMake(weakSelf.l3ControlPointView.center.x, centerY);
        weakSelf.r1ControlPointView.center = CGPointMake(weakSelf.r1ControlPointView.center.x, centerY);
        weakSelf.r2ControlPointView.center = CGPointMake(weakSelf.r2ControlPointView.center.x, centerY);
        weakSelf.r3ControlPointView.center = CGPointMake(weakSelf.r3ControlPointView.center.x, centerY);
    } completion:^(BOOL finished) {
        [weakSelf stopDisplayLink];
        [weakSelf resetScrollViewContentInset:YES animated:NO completion:nil];
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        UIScrollView *strongScrollView = [strongSelf scrollView];
        if (strongSelf && strongScrollView) {
            [strongScrollView jler_addObserver:self forKeyPath:kContentOffset];
            strongScrollView.scrollEnabled = YES;
        }
        weakSelf.state = JLElasticRefreshStateLoading;
    }];
    
    _bounceAnimationHelperView.center = CGPointMake(0.0, _originalContentInsetTop + [self currentHeight]);
    [UIView animateWithDuration:duration * 0.4 animations:^{
        weakSelf.bounceAnimationHelperView.center = CGPointMake(0.0, weakSelf.originalContentInsetTop + kLoadingContentInset);
    } completion:nil];
}

#pragma mark - CADisplayLink

- (void)startDisplayLink {
    _displayLink.paused = NO;
}

- (void)stopDisplayLink {
    _displayLink.paused = YES;
}

- (void)displayLinkTick {
    CGFloat width  = self.bounds.size.width;
    CGFloat height = 0.f;
    
    if (_state == JLElasticRefreshStateAnimatingBounce) {
        UIScrollView *scrollView = [self scrollView];
        if (!scrollView) { return; }
        
        CGFloat top = [_bounceAnimationHelperView jler_center:[self isAnimating]].y;
        CGFloat left = scrollView.contentInset.left;
        CGFloat bottom = scrollView.contentInset.bottom;
        CGFloat right = scrollView.contentInset.right;
        scrollView.contentInset = UIEdgeInsetsMake(top, left, bottom, right);
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, -scrollView.contentInset.top);
        
        height = scrollView.contentInset.top - _originalContentInsetTop;
        
        self.frame = CGRectMake(0.0, -height - 1.0, width, height);
    } else if (_state == JLElasticRefreshStateAnimatingToStopped) {
        height = [self actualContentOffsetY];
    }
    
    self.shapeLayer.frame = CGRectMake(0.0, 0.0, width, height);
    self.shapeLayer.path = [self currentPath];
    
    [self layoutLoadingView];
}

#pragma mark - Layout

- (void)layoutLoadingView {
    CGFloat width  = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGFloat minOriginY = (kLoadingContentInset - kLoadingViewSize) / 2.0;
    CGFloat originY = MAX(MIN((height - kLoadingViewSize) / 2.0, minOriginY), 0.0);
    
    self.loadingView.frame = CGRectMake((width - kLoadingViewSize) / 2.0, originY, kLoadingViewSize, kLoadingViewSize);
    self.loadingView.maskLayer.frame = [self convertRect:_shapeLayer.frame toView:self.loadingView];
    self.loadingView.maskLayer.path = _shapeLayer.path;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIScrollView *scrollView = [self scrollView];
    if (!scrollView) { return; }
    
    if (_state == JLElasticRefreshStateAnimatingBounce) { return; }
    
    CGFloat width  = scrollView.bounds.size.width;
    CGFloat height = [self currentHeight];
    
    self.frame = CGRectMake(0.0, -height, width, height);
    
    if (_state == JLElasticRefreshStateLoading ||
        _state == JLElasticRefreshStateAnimatingToStopped) {
        self.cControlPointView.center = CGPointMake(width / 2.0, height);
        self.l1ControlPointView.center = CGPointMake(0.0, height);
        self.l2ControlPointView.center = CGPointMake(0.0, height);
        self.l3ControlPointView.center = CGPointMake(0.0, height);
        self.r1ControlPointView.center = CGPointMake(width, height);
        self.r2ControlPointView.center = CGPointMake(width, height);
        self.r3ControlPointView.center = CGPointMake(width, height);
    } else {
        CGFloat locationX = [scrollView.panGestureRecognizer locationInView:scrollView].x;
        
        CGFloat waveHeight = [self currentWaveHeight];
        CGFloat baseHeight = self.bounds.size.height - waveHeight;
        
        CGFloat minLeftX = MIN(locationX - width / 2.0 * 0.28, 0.0);
        CGFloat maxRightX = MAX(width + (locationX - width / 2.0) * 0.28, width);
        
        CGFloat leftPartWidth = locationX - minLeftX;
        CGFloat rightPartWidth = maxRightX - locationX;
        
        self.cControlPointView.center = CGPointMake(locationX, baseHeight + waveHeight * 1.36);
        self.l1ControlPointView.center = CGPointMake(minLeftX + leftPartWidth * 0.71, baseHeight + waveHeight * 0.64);
        self.l2ControlPointView.center = CGPointMake(minLeftX + leftPartWidth * 0.44, baseHeight);
        self.l3ControlPointView.center = CGPointMake(minLeftX, baseHeight);
        self.r1ControlPointView.center = CGPointMake(maxRightX - rightPartWidth * 0.71, baseHeight + waveHeight * 0.64);
        self.r2ControlPointView.center = CGPointMake(maxRightX - (rightPartWidth * 0.44), baseHeight);
        self.r3ControlPointView.center = CGPointMake(maxRightX, baseHeight);
    }
    
    self.shapeLayer.frame = CGRectMake(0.0, 0.0, width, height);
    self.shapeLayer.path = [self currentPath];
    
    [self layoutLoadingView];
}

#pragma mark - Setter

- (void)setState:(JLElasticRefreshState)state {
    JLElasticRefreshState previousValue = _state;
    _state = state;
    if (previousValue == JLElasticRefreshStateDragging &&
        state == JLElasticRefreshStateAnimatingBounce) {
        [self.loadingView startAnimating];
        [self animateBounce];
    } else if (state == JLElasticRefreshStateLoading) {
        if (self.actionHandler) { self.actionHandler(); }
    } else if (state == JLElasticRefreshStateAnimatingToStopped) {
        __weak typeof(self) weakSelf = self;
        [self resetScrollViewContentInset:YES animated:YES completion:^{
            weakSelf.state = JLElasticRefreshStateStopped;
        }];
    } else if (state == JLElasticRefreshStateStopped) {
        [self.loadingView stopLoading];
    }
}

- (void)setLoadingView:(JLElasticRefreshLoadingView *)loadingView {
    [_loadingView removeFromSuperview];
    if (loadingView) {
        [self addSubview:loadingView];
    }
    _loadingView = loadingView;
}

- (void)setOriginalContentInsetTop:(CGFloat)originalContentInsetTop {
    _originalContentInsetTop = originalContentInsetTop;
    [self layoutSubviews];
}

- (void)setObserving:(BOOL)observing {
    _observing = observing;
    UIScrollView *scrollView = [self scrollView];
    if (!scrollView) { return; }
    if (_observing) {
        [scrollView jler_addObserver:self forKeyPath:kContentOffset];
        [scrollView jler_addObserver:self forKeyPath:kContentInset];
        [scrollView jler_addObserver:self forKeyPath:kFrame];
        [scrollView jler_addObserver:self forKeyPath:kPanGestureRecognizerState];
    } else {
        [scrollView jler_removeObserver:self forKeyPath:kContentOffset];
        [scrollView jler_removeObserver:self forKeyPath:kContentInset];
        [scrollView jler_removeObserver:self forKeyPath:kFrame];
        [scrollView jler_removeObserver:self forKeyPath:kPanGestureRecognizerState];
    }
}

- (void)setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
    self.shapeLayer.fillColor = fillColor.CGColor;
}

@end
