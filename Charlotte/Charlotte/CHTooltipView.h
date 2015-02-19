//
//  CHTooltipView.h
//  Charlotte
//
//  Created by Ben Guo on 10/30/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHTooltipView;

@protocol CHTooltipViewDelegate <NSObject>

@optional
/// Tells the delegate that the tooltip appeared
- (void)tooltipDidAppear:(CHTooltipView *)tooltipView;

/// Tells the delegate that the tooltip disappeared
- (void)tooltipDidDisappear:(CHTooltipView *)tooltipView;

@end

@interface CHTooltipView : UIView

/// The tooltip's content view
@property (nonatomic, strong, readonly) UIView *contentContainerView;

/// The distance that the content view is inset from the enclosing tooltip view
@property (nonatomic, assign) UIEdgeInsets contentInset UI_APPEARANCE_SELECTOR;

/// The color of the tooltip. Default is white.
@property (nonatomic, strong) UIColor *tooltipColor UI_APPEARANCE_SELECTOR;

/// The color of the overlay view. Default is clear.
@property (nonatomic, strong) UIColor *backgroundColor UI_APPEARANCE_SELECTOR;

/// The tooltip's shadow opacity. Default is 0.3.
@property (nonatomic, assign) CGFloat shadowOpacity UI_APPEARANCE_SELECTOR;

/// The tooltip's corner radius. Default is 0.0
@property (nonatomic, assign) CGFloat cornerRadius UI_APPEARANCE_SELECTOR;

/// The size of the tooltip's arrow.
@property (nonatomic, assign) CGSize arrowSize UI_APPEARANCE_SELECTOR;

/// The animation duration used to move the tooltip to another target rect.
@property (nonatomic, assign) NSTimeInterval movementAnimationDuration UI_APPEARANCE_SELECTOR;

/// The animation duration used to animate the tooltip's appearance.
@property (nonatomic, assign) NSTimeInterval entranceAnimationDuration UI_APPEARANCE_SELECTOR;

/// The animation duration used to animate the tooltip's disappearance.
@property (nonatomic, assign) NSTimeInterval exitAnimationDuration UI_APPEARANCE_SELECTOR;

/// The tooltip view's delegate
@property (nonatomic, weak) id<CHTooltipViewDelegate> delegate;

/**
 *  If `handlesDismissal` is set to YES, tapping outside the tooltip's content frame will dismiss the tooltip.
 *  If `handlesDismissal` is set to NO, all touch events outside the tooltip's content frame will be forwarded,
 *  without dismissing the tooltip. Default is YES.
 */
@property (nonatomic, assign) BOOL handlesDismissal UI_APPEARANCE_SELECTOR;

/**
 *  If `prefersCenterX` is set to YES, the tooltip will attempt to center itself along the screen's x-axis.
 *  Default is NO.
 */
@property (nonatomic, assign) BOOL prefersCenterX UI_APPEARANCE_SELECTOR;

/**
 *  Returns the shared tooltip view.
 *
 *  @return A CHTooltipView instance
 */
+ (instancetype)sharedView;

/**
 *  Sets the view used as the tooltip's content.
 *
 *  @param view A UIView object
 */
- (void)setContentView:(UIView *)view;

/**
 *  Shows the tooltip pointing to the target rect.
 *
 *  CHTooltipView will attempt to display the tooltip above `targetRect`. If there is not enough space for the tooltip
 *  there, the tooltip will be positioned below the rectangle. The tooltip's pointer is placed at the center of the top 
 *  or bottom of the target rectangle as appropriate.
 *
 *  Once it is set, the target rectangle does not track the view; if the view moves or changes size, you must update the
 *  target rectangle accordingly.
 *
 *  @param targetRect       A rectangle that defines the area that is to be the target of the tooltip
 *  @param view             The view relative to which `targetRect` is specified
 *  @param containingView   The view in which the tooltip should be displayed
 */
- (void)showWithTargetRect:(CGRect)targetRect relativeToView:(UIView *)view inView:(UIView *)containingView;

/**
 *  Hides the tooltip.
 */
- (void)dismiss;

/**
 *  Resets the shared tooltip to its default state.
 */
- (void)setDefaults;

/**
 *  Returns a Boolean value indicating whether or not the tooltip is currently visible
 *
 *  @return A Boolean value indicating whether or not the tooltip is visible.
 */
- (BOOL)isVisible;

@end
