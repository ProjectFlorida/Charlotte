//
//  CHTooltipView.m
//  Charlotte
//
//  Created by Ben Guo on 10/30/14.
//  Copyright (c) 2015 Sum Labs. All rights reserved.
//

#import "CHTooltipView.h"

typedef NS_ENUM(NSInteger, CHTooltipArrowDirection) {
    CHTooltipArrowDirectionUp,
    CHTooltipArrowDirectionDown,
    CHTooltipArrowDirectionLeft,
    CHTooltipArrowDirectionRight
};

NSTimeInterval const kDefaultMovementAnimationDuration = 0.2;
NSTimeInterval const kDefaultEntranceAnimationDuration = 0.1;
NSTimeInterval const kDefaultExitAnimationDuration = 0.1;
CGFloat const kDefaultShadowOpacity = 0.3;
CGFloat const kDefaultShadowRadius = 1;
CGFloat const kDefaultCornerRadius = 0;

@interface CHTooltipView ()

@property (nonatomic, assign) CHTooltipArrowDirection arrowDirection;
@property (nonatomic, strong) CAShapeLayer *arrowShapeLayer;
@property (nonatomic, strong) UIView *arrowView;
@property (nonatomic, strong) UIView *contentContainerView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *contentShadowView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation CHTooltipView

+ (instancetype)sharedView {
    static dispatch_once_t once;
    static CHTooltipView *sharedView;
    dispatch_once(&once, ^ {
        sharedView = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });
    return sharedView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha = 0;
        _handlesDismissal = YES;
        _prefersCenterX = NO;
        _arrowDirection = CHTooltipArrowDirectionDown;
        _movementAnimationDuration = kDefaultMovementAnimationDuration;
        _entranceAnimationDuration = kDefaultEntranceAnimationDuration;
        _exitAnimationDuration = kDefaultExitAnimationDuration;
        _contentInset = UIEdgeInsetsMake(6, 6, 6, 6);

        _backgroundView = [[UIView alloc] initWithFrame:frame];
        _backgroundView.backgroundColor = [UIColor clearColor];
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(handleTapGesture:)];
        _tapGestureRecognizer.enabled = _handlesDismissal;
        [_backgroundView addGestureRecognizer:_tapGestureRecognizer];
        _arrowSize = CGSizeMake(20, 20);

        CGSize arrowSize = [CHTooltipView arrowSizeForDirection:_arrowDirection size:_arrowSize];
        CGRect arrowFrame = CGRectMake(0, 0, arrowSize.width, arrowSize.height);
        _arrowView = [[UIView alloc] initWithFrame:arrowFrame];
        _arrowView.backgroundColor = [UIColor clearColor];
        _arrowShapeLayer = [CAShapeLayer layer];
        _arrowShapeLayer.fillColor = [UIColor whiteColor].CGColor;
        _arrowShapeLayer.frame = _arrowView.frame;
        _arrowShapeLayer.shadowOpacity = kDefaultShadowOpacity;
        _arrowShapeLayer.shadowOffset = CGSizeMake(1, 1);
        _arrowShapeLayer.shadowRadius = kDefaultShadowRadius;
        [_arrowView.layer addSublayer:_arrowShapeLayer];

        _contentContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentContainerView.backgroundColor = [UIColor whiteColor];
        _contentContainerView.layer.cornerRadius = kDefaultCornerRadius;
        _contentContainerView.clipsToBounds = YES;

        _contentShadowView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentShadowView.backgroundColor = [UIColor whiteColor];
        _contentShadowView.layer.shadowOpacity = kDefaultShadowOpacity;
        _contentShadowView.layer.shadowOffset = CGSizeMake(1, 1);
        _contentShadowView.layer.shadowRadius = kDefaultShadowRadius;

        [_backgroundView addSubview:_contentShadowView];
        [_backgroundView addSubview:_arrowView];
        [_backgroundView addSubview:_contentContainerView];
        [self addSubview:_backgroundView];
    }
    return self;
}

- (void)setDefaults
{
    _handlesDismissal = YES;
    _prefersCenterX = NO;
    _movementAnimationDuration = kDefaultMovementAnimationDuration;
    _entranceAnimationDuration = kDefaultEntranceAnimationDuration;
    _exitAnimationDuration = kDefaultExitAnimationDuration;
    _contentInset = UIEdgeInsetsMake(6, 6, 6, 6);
    _arrowSize = CGSizeMake(20, 20);
    _backgroundView.backgroundColor = [UIColor clearColor];
    _arrowShapeLayer.fillColor = [UIColor whiteColor].CGColor;
    _contentContainerView.layer.cornerRadius = kDefaultCornerRadius;
    _contentShadowView.layer.shadowOpacity = kDefaultShadowOpacity;
    _contentShadowView.layer.shadowRadius = kDefaultShadowRadius;
    _arrowShapeLayer.shadowOpacity = kDefaultShadowOpacity;
    _arrowShapeLayer.shadowRadius = kDefaultShadowRadius;
}

+ (CGSize)arrowSizeForDirection:(CHTooltipArrowDirection)direction size:(CGSize)size
{
    switch (direction) {
        case CHTooltipArrowDirectionUp:
        case CHTooltipArrowDirectionDown: {
            return CGSizeMake(size.width*2.0, size.height);
            break;
        }
        case CHTooltipArrowDirectionLeft:
        case CHTooltipArrowDirectionRight:
            return CGSizeMake(size.width, size.height*2.0);
            break;
    }
}

- (UIBezierPath *)arrowPathForDirection:(CHTooltipArrowDirection)direction
{
    CGSize arrowSize = _arrowShapeLayer.frame.size;
    UIBezierPath *path = [UIBezierPath bezierPath];
    switch (direction) {
        case CHTooltipArrowDirectionUp:
            [path moveToPoint:CGPointMake(arrowSize.width*0.25, arrowSize.height)];
            [path addLineToPoint:CGPointMake(arrowSize.width*0.25, arrowSize.height*0.5)];
            [path addLineToPoint:CGPointMake(arrowSize.width*0.5, 0)];
            [path addLineToPoint:CGPointMake(arrowSize.width*0.75, arrowSize.height*0.5)];
            [path addLineToPoint:CGPointMake(arrowSize.width*0.75, arrowSize.height)];
            break;
        case CHTooltipArrowDirectionDown:
            [path moveToPoint:CGPointMake(arrowSize.width*0.25, 0)];
            [path addLineToPoint:CGPointMake(arrowSize.width*0.25, arrowSize.height*0.5)];
            [path addLineToPoint:CGPointMake(arrowSize.width*0.5, arrowSize.height)];
            [path addLineToPoint:CGPointMake(arrowSize.width*0.75, arrowSize.height*0.5)];
            [path addLineToPoint:CGPointMake(arrowSize.width*0.75, 0)];
            break;
        case CHTooltipArrowDirectionLeft:
            [path moveToPoint:CGPointMake(arrowSize.width, arrowSize.height*0.25)];
            [path addLineToPoint:CGPointMake(arrowSize.width*0.5, arrowSize.height*0.25)];
            [path addLineToPoint:CGPointMake(0, arrowSize.height*0.5)];
            [path addLineToPoint:CGPointMake(arrowSize.width*0.5, arrowSize.height*0.75)];
            [path addLineToPoint:CGPointMake(arrowSize.width, arrowSize.height*0.75)];
            break;
        case CHTooltipArrowDirectionRight:
            [path moveToPoint:CGPointMake(0, arrowSize.height*0.25)];
            [path addLineToPoint:CGPointMake(arrowSize.width*0.5, arrowSize.height*0.25)];
            [path addLineToPoint:CGPointMake(arrowSize.width, arrowSize.height*0.5)];
            [path addLineToPoint:CGPointMake(arrowSize.width*0.5, arrowSize.height*0.75)];
            [path addLineToPoint:CGPointMake(0, arrowSize.height*0.75)];
            break;
        default:
            break;
    }
    [path closePath];
    return path;
}

- (void)setContentView:(UIView *)view
{
    _contentView = view;
    for (UIView *view in self.contentContainerView.subviews) {
        [view removeFromSuperview];
    }
    UIEdgeInsets insets = UIEdgeInsetsMake(-self.contentInset.top,
                                           -self.contentInset.left,
                                           -self.contentInset.bottom,
                                           -self.contentInset.right);
    [_contentView setFrame:CGRectMake(-insets.left, -insets.top,
                                      _contentView.bounds.size.width, _contentView.bounds.size.height)];
    [self.contentContainerView addSubview:_contentView];
    self.contentContainerView.frame = UIEdgeInsetsInsetRect(_contentView.bounds, insets);
    self.contentContainerView.frame = CGRectOffset(self.contentContainerView.frame, -insets.right, -insets.bottom);
    self.contentShadowView.frame = self.contentContainerView.frame;
}

- (void)showWithTargetRect:(CGRect)targetRect relativeToView:(UIView *)view inView:(UIView *)containingView
{
    BOOL shouldFadeIn = NO;
    if (!self.superview) {
        shouldFadeIn = YES;
        [containingView addSubview:self];
    }

    CGRect contentFrame = self.contentContainerView.frame;
    CGRect viewFrame = self.frame;
    __block CGRect arrowFrame = self.arrowView.frame;

    CGPoint centerTop = CGPointMake(CGRectGetMidX(targetRect), CGRectGetMinY(targetRect));
    centerTop = [view convertPoint:centerTop toView:self];
    CGPoint centerBottom = CGPointMake(CGRectGetMidX(targetRect), CGRectGetMaxY(targetRect));
    centerBottom = [view convertPoint:centerBottom toView:self];
    CGPoint centerLeft = CGPointMake(CGRectGetMinX(targetRect), CGRectGetMidY(targetRect));
    centerLeft = [view convertPoint:centerLeft toView:self];
    CGPoint centerRight = CGPointMake(CGRectGetMaxX(targetRect), CGRectGetMidY(targetRect));
    centerRight = [view convertPoint:centerRight toView:self];

    CGFloat distanceToTop = centerTop.y;
    CGFloat distanceToRight = CGRectGetWidth(viewFrame) - centerTop.x;
    CGFloat distanceToLeft = centerTop.x;
    CGFloat cornerRadius = self.contentContainerView.layer.cornerRadius;
    CGFloat minContentX = CGRectGetWidth(contentFrame)*0.5;
    CGFloat maxContentX = CGRectGetWidth(viewFrame) - CGRectGetWidth(contentFrame)*0.5;
    CGFloat maxContentY = CGRectGetHeight(viewFrame) - CGRectGetHeight(contentFrame)*0.5;
    __block CGFloat minArrowX, maxArrowX, maxArrowY;

    BOOL(^willChangeArrowDirection)() = ^BOOL() {
        CHTooltipArrowDirection newDirection;
        if (distanceToTop > CGRectGetHeight(contentFrame) + CGRectGetHeight(arrowFrame)){
            newDirection = CHTooltipArrowDirectionDown;
        }
        else {
            if (distanceToLeft > CGRectGetWidth(contentFrame) + CGRectGetWidth(arrowFrame)) {
                newDirection = CHTooltipArrowDirectionRight;
            }
            else if (distanceToRight > CGRectGetWidth(contentFrame) + CGRectGetWidth(arrowFrame)) {
                newDirection = CHTooltipArrowDirectionLeft;
            }
            else {
                newDirection = CHTooltipArrowDirectionUp;
            }
        }
        return newDirection != self.arrowDirection;
    };

    void(^updateArrow)() = ^() {
        CGSize arrowSize = [[self class] arrowSizeForDirection:self.arrowDirection size:self.arrowSize];
        self.arrowView.frame = CGRectMake(self.arrowView.frame.origin.x,
                                          self.arrowView.frame.origin.y,
                                          arrowSize.width, arrowSize.height);
        arrowFrame = self.arrowView.frame;
        minArrowX = CGRectGetWidth(arrowFrame)*0.25 + cornerRadius;
        maxArrowX = CGRectGetWidth(viewFrame) - CGRectGetWidth(arrowFrame)*0.25 - cornerRadius;
        maxArrowY = CGRectGetHeight(viewFrame) - CGRectGetHeight(arrowFrame)*0.25 - cornerRadius;
        self.arrowShapeLayer.frame = self.arrowView.bounds;
        self.arrowShapeLayer.path = [self arrowPathForDirection:self.arrowDirection].CGPath;
    };

    void(^positionElements)() = ^() {
        // point down
        if (distanceToTop > CGRectGetHeight(contentFrame) + CGRectGetHeight(arrowFrame)){
            self.arrowDirection = CHTooltipArrowDirectionDown;
            updateArrow();
            CGPoint targetPoint = centerTop;
            CGFloat contentX = MAX(MIN(targetPoint.x, maxContentX), minContentX);
            CGFloat contentY = targetPoint.y - CGRectGetHeight(contentFrame)*0.5 - CGRectGetHeight(arrowFrame)*0.5;
            if (self.prefersCenterX) {
                // attempt to center the tooltip along the x axis
                CGFloat arrowSideWidth = CGRectGetWidth(arrowFrame)*0.25;
                CGFloat targetMinX = arrowSideWidth;
                CGFloat targetMaxX = CGRectGetWidth(viewFrame) - arrowSideWidth;
                if (targetPoint.x > targetMinX && targetPoint.x < targetMaxX) {
                    contentX = CGRectGetMidX(viewFrame);
                }
            }
            self.contentContainerView.center = CGPointMake(contentX, contentY);
            CGFloat arrowX = MAX(MIN(targetPoint.x, maxArrowX), minArrowX);
            CGFloat arrowY = contentY + CGRectGetHeight(contentFrame)*0.5;
            self.arrowView.center = CGPointMake(arrowX, arrowY);
        }
        else {
            // point right
            if (distanceToLeft > CGRectGetWidth(contentFrame) + CGRectGetWidth(arrowFrame)) {
                self.arrowDirection = CHTooltipArrowDirectionRight;
                updateArrow();
                CGPoint targetPoint = centerRight;
                CGFloat contentX = targetPoint.x - CGRectGetWidth(arrowFrame)*0.5 - CGRectGetWidth(contentFrame)*0.5;
                CGFloat contentY = MIN(targetPoint.y, maxContentY);
                self.contentContainerView.center = CGPointMake(contentX, contentY);
                CGFloat arrowX = targetPoint.x - CGRectGetWidth(arrowFrame)*0.5;
                CGFloat arrowY = MIN(targetPoint.y, maxArrowY);
                self.arrowView.center = CGPointMake(arrowX, arrowY);
            }
            // point left
            else if (distanceToRight > CGRectGetWidth(contentFrame) + CGRectGetWidth(arrowFrame)) {
                self.arrowDirection = CHTooltipArrowDirectionLeft;
                updateArrow();
                CGPoint targetPoint = centerLeft;
                CGFloat contentX = targetPoint.x + CGRectGetWidth(contentFrame)*0.5 + CGRectGetWidth(arrowFrame)*0.5;
                CGFloat contentY = MIN(targetPoint.y, maxContentY);
                self.contentContainerView.center = CGPointMake(contentX, contentY);
                CGFloat arrowX = targetPoint.x + CGRectGetWidth(arrowFrame)*0.5;
                CGFloat arrowY = MIN(targetPoint.y, maxArrowY);
                self.arrowView.center = CGPointMake(arrowX, arrowY);
            }
            // point up
            else {
                self.arrowDirection = CHTooltipArrowDirectionUp;
                updateArrow();
                CGPoint targetPoint = centerBottom;
                CGFloat contentX = MAX(MIN(targetPoint.x, maxContentX), minContentX);
                CGFloat contentY = targetPoint.y + CGRectGetHeight(contentFrame)*0.5 + CGRectGetHeight(arrowFrame)*0.5;
                if (self.prefersCenterX) {
                    // attempt to center the tooltip along the x axis
                    CGFloat arrowSideWidth = CGRectGetWidth(arrowFrame)*0.25;
                    CGFloat targetMinX = arrowSideWidth;
                    CGFloat targetMaxX = CGRectGetWidth(viewFrame) - arrowSideWidth;
                    if (targetPoint.x > targetMinX && targetPoint.x < targetMaxX) {
                        contentX = CGRectGetMidX(viewFrame);
                    }
                }               
                self.contentContainerView.center = CGPointMake(contentX, contentY);
                CGFloat arrowX = MAX(MIN(targetPoint.x, maxArrowX), minArrowX);
                CGFloat arrowY = contentY - CGRectGetHeight(contentFrame)*0.5;
                self.arrowView.center = CGPointMake(arrowX, arrowY);
            }
        }
        self.contentShadowView.center = self.contentContainerView.center;
    };

    if (shouldFadeIn) {
        positionElements();
        [UIView animateWithDuration:self.entranceAnimationDuration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.alpha = 1;
                         } completion:^(BOOL finished) {
                             if ([self.delegate respondsToSelector:@selector(tooltipDidAppear:)]) {
                                 [self.delegate tooltipDidAppear:self];
                             }
                         }];
    }
    else {
        BOOL shouldHideArrow = willChangeArrowDirection();
        if (shouldHideArrow) {
            self.arrowView.alpha = 0;
        }
        [UIView animateWithDuration:self.movementAnimationDuration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             positionElements();
                         } completion:^(BOOL finished) {
                             self.arrowView.alpha = 1;
                         }];
    }
}

- (void)dismiss
{
    [UIView animateWithDuration:self.exitAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         if ([self.delegate respondsToSelector:@selector(tooltipDidDisappear:)]) {
                             [self.delegate tooltipDidDisappear:self];
                         }
                     }];
}

- (BOOL)isVisible
{
    return [self  superview] != nil;
}

- (void)setContentInset:(UIEdgeInsets)contentInset
{
    _contentInset = contentInset;
    [self setContentView:self.contentView];
}

- (void)setHandlesDismissal:(BOOL)handlesDismissal
{
    _handlesDismissal = handlesDismissal;
    self.tapGestureRecognizer.enabled = handlesDismissal;
}

- (void)setMovementAnimationDuration:(NSTimeInterval)duration
{
    _movementAnimationDuration = duration;
}

- (void)setEntranceAnimationDuration:(NSTimeInterval)duration
{
    _entranceAnimationDuration = duration;
}

- (void)setExitAnimationDuration:(NSTimeInterval)duration
{
    _exitAnimationDuration = duration;
}

- (void)setCornerRadius:(CGFloat)radius
{
    _cornerRadius = radius;
    self.contentContainerView.layer.cornerRadius = radius;
    self.contentShadowView.layer.cornerRadius = radius;
}

- (void)setArrowSize:(CGSize)arrowSize
{
    _arrowSize = arrowSize;
}

- (void)setTooltipColor:(UIColor *)color
{
    _tooltipColor = color;
    self.contentContainerView.backgroundColor = color;
    self.arrowShapeLayer.fillColor = color.CGColor;
}

- (void)setBackgroundColor:(UIColor *)color
{
    _backgroundColor = color;
    self.backgroundView.backgroundColor = color;
}

- (void)setShadowOpacity:(CGFloat)opacity
{
    _shadowOpacity = opacity;
    self.contentShadowView.layer.shadowOpacity = opacity;
    self.arrowShapeLayer.shadowOpacity = opacity;
}

- (void)setPrefersCenterX:(BOOL)prefersCenterX
{
    _prefersCenterX = prefersCenterX;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return self.handlesDismissal;
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView:self.backgroundView];
    if (!CGRectContainsPoint(self.contentContainerView.frame, location)) {
        [self dismiss];
    }
}

@end
