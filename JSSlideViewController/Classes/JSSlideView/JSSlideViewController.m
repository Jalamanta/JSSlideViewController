//
//  JSSlideViewController.m
//  JSSlideViewController
//
//  Created on 28/02/2015.
//
//  Copyright (c) 2015 Jalamanta
//
//  This software is provided 'as-is', without any express or implied
//  warranty. In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//     claim that you wrote the original software. If you use this software
//     in a product, an acknowledgement in the product documentation would be
//     appreciated but is not required.
//  2. Altered source versions must be plainly marked as such, and must not be
//     misrepresented as being the original software.
//  3. This notice may not be removed or altered from any source distribution.
//

#import <CoreGraphics/CoreGraphics.h>

#import "JSUtilities.h"
#import "JSRectUtils.h"
#import "UIView+Frame.h"
#import "UIView+FindViewController.h"

#import "UIView+Easing.h"

#import "JSSlideViewController.h"
#import "JSSlideViewController.h"
#import "JSSlideViewButton.h"
#import "JSDraggableSlideView.h"


@interface JSSlideViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong, readwrite) UIViewController *currentViewController;
@property (nonatomic, strong) JSDraggableSlideView *draggableView;

@property (nonatomic, strong) UIView *leftContainerView;
@property (nonatomic, strong) UIView *centreContainerView;
@property (nonatomic, strong) UIView *rightContainerView;

@property (nonatomic, strong) UISwipeGestureRecognizer *leftEdgeSwipeGesture;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightEdgeSwipeGesture;

@property (nonatomic, strong) NSMutableDictionary *dataSource;

@property (nonatomic, assign) BOOL lastMessageSentWasViewWillAppear;

@end

@implementation JSSlideViewController

-(id)init
{
    self = [super init];
    if (self)
    {
        [self setup];
    }
    
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setup];
    }
    return self;
}

-(void)setup
{
    self.dataSource = [NSMutableDictionary new];

    _leftViewControllerVisibleWidth = 320.0f - 50.0f;
    _rightViewControllerVisibleWidth = 320.0f - 50.0f;
    
    _darkenLeftViewMaxDarkness = 0.60f;
    _darkenRightViewMaxDarkness = 0.60f;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.rightContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
    [[self rightContainerView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:self.rightContainerView];
    
    self.leftContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
    [[self leftContainerView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:self.leftContainerView];

    if (self.resizeLeftViewController)
    {
        [[self leftContainerView] setFrame:CGRectWithNewWidth( self.view.bounds, self.leftViewControllerVisibleWidth)];
    }
    if (self.resizeRightViewController)
    {
        [[self rightContainerView] setFrame:CGRectWithNewWidth( self.view.bounds, self.rightViewControllerVisibleWidth)];
    }
    
    self.centreContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
    [[self centreContainerView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:self.centreContainerView];
    
    self.draggableView = [[JSDraggableSlideView alloc] initWithFrame:self.view.bounds];
    [[self draggableView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [[self draggableView] setSlideViewController:self];
    [[self draggableView] setEnableTap:YES];
}

-(void)setRightViewControllerVisibleWidth:(CGFloat)rightViewControllerVisibleWidth
{
    if (_rightViewControllerVisibleWidth != rightViewControllerVisibleWidth)
    {
        _rightViewControllerVisibleWidth = rightViewControllerVisibleWidth;
        [[self rightContainerView] setFrame:CGRectMake( self.view.width - _rightViewControllerVisibleWidth, 0.0f,
                                                       _rightViewControllerVisibleWidth, self.view.height)];
    }
}

-(void)setLeftViewControllerVisibleWidth:(CGFloat)leftViewControllerVisibleWidth
{
    if (_leftViewControllerVisibleWidth != leftViewControllerVisibleWidth)
    {
        _leftViewControllerVisibleWidth = leftViewControllerVisibleWidth;
        [[self leftContainerView] setFrame:CGRectWithNewWidth( self.view.bounds, _leftViewControllerVisibleWidth)];
    }
}


-(void)setResizeLeftViewController:(BOOL)resizeLeftViewController
{
    if (_resizeLeftViewController != resizeLeftViewController)
    {
        _resizeLeftViewController = resizeLeftViewController;
        if (resizeLeftViewController)
        {
            [[self leftContainerView] setFrame:CGRectWithNewWidth( self.view.bounds, _leftViewControllerVisibleWidth)];
        }
    }
}

-(void)setResizeRightViewController:(BOOL)resizeRightViewController
{
    if (_resizeRightViewController != resizeRightViewController)
    {
        _resizeRightViewController = resizeRightViewController;
        if (resizeRightViewController)
        {
            [[self rightContainerView] setFrame:CGRectMake( self.view.width - _rightViewControllerVisibleWidth, 0.0f,
                                                            _rightViewControllerVisibleWidth, self.view.height)];
        }
    }
}


-(void)setLeftViewController:(UIViewController *)leftViewController
{
    if (leftViewController)
    {
        _leftViewController = leftViewController;
        [_leftViewController willMoveToParentViewController:self];
        [self.leftContainerView addSubview:_leftViewController.view];
        [[leftViewController view] setFrame:self.leftContainerView.bounds];
        [self addChildViewController:_leftViewController];
        [_leftViewController didMoveToParentViewController:self];
    }
    else if (_leftViewController)
    {
        [_leftViewController willMoveToParentViewController:nil];
        [_leftViewController.view removeFromSuperview];
        [_leftViewController removeFromParentViewController];
    }
}

-(void)setRightViewController:(UIViewController *)rightViewController
{
    if (rightViewController)
    {
        _rightViewController = rightViewController;
        [_rightViewController willMoveToParentViewController:self];
        [self.rightContainerView addSubview:_rightViewController.view];
        [[rightViewController view] setFrame:self.rightContainerView.bounds];
        [self addChildViewController:_rightViewController];
        [_rightViewController didMoveToParentViewController:self];
    }
    else if (_rightViewController)
    {
        [_rightViewController willMoveToParentViewController:nil];
        [_rightViewController.view removeFromSuperview];
        [_rightViewController removeFromParentViewController];
    }
}

#pragma mark -

-(void)addLeftMenuButtonToChildController:(UIViewController*)childController
{
    if (self.leftViewController &&
        [childController conformsToProtocol:@protocol(JSSlideViewChildControllerProtocol)] &&
        [childController respondsToSelector:@selector(setSlideViewButtonForLeftReveal:)])
    {
        if ([(id<JSSlideViewChildControllerProtocol>)childController slideViewButtonForLeftReveal] == nil)
        {
            JSSlideViewButton *menuButton = [JSSlideViewButton slideViewButtonForLeftReveal];
            [menuButton setSlideViewController:self];
            [(id<JSSlideViewChildControllerProtocol>)childController setSlideViewButtonForLeftReveal:menuButton];
        }
    }
}

-(void)addRightMenuButtonToChildController:(UIViewController*)childController
{
    if (self.rightViewController &&
        [childController conformsToProtocol:@protocol(JSSlideViewChildControllerProtocol)] &&
        [childController respondsToSelector:@selector(setSlideViewButtonForRightReveal:)])
    {
        if ([(id<JSSlideViewChildControllerProtocol>)childController slideViewButtonForRightReveal] == nil)
        {
            JSSlideViewButton *menuButton = [JSSlideViewButton slideViewButtonForRightReveal];
            [menuButton setSlideViewController:self];
            [(id<JSSlideViewChildControllerProtocol>)childController setSlideViewButtonForRightReveal:menuButton];
        }
    }
}

-(JSSlideViewControllerIdentifier)addViewControllerWithBlock:(ViewControllerCreationBlock)block
{
    JSSlideViewControllerIdentifier identifier = [[NSUUID UUID] UUIDString];
    
    [[self dataSource] setObject:block forKey:identifier];
    
    return identifier;
}

-(void)removeViewControllerWithItemIdentifier:(JSSlideViewControllerIdentifier)identifier
{
    [[self dataSource] removeObjectForKey:identifier];
}


-(void)applyShadowToCurrentView
{
    UIView *view = self.centreContainerView;
    
    [[view layer] setShadowColor:[UIColor blackColor].CGColor];
    [[view layer] setShadowOffset:CGSizeMake(0.0f, 0.0f)];
    [[view layer] setShadowOpacity:0.3f];
    [[view layer] setShadowRadius:16.0f];
    [[view layer] setShadowPath:[UIBezierPath bezierPathWithRect:[view bounds]].CGPath];
}

-(void)switchToViewController:(UIViewController*)viewController animated:(BOOL)animated withAnimationOptions:(UIViewAnimationOptions)options
{
    if (viewController)
    {
        if ([[self childViewControllers] containsObject:viewController] == NO)
        {
            [self addChildViewController:viewController];
            [viewController didMoveToParentViewController:self];
            
            [viewController.view layoutIfNeeded];
        }
        
        UIViewController *previousViewController = self.currentViewController;
        
        if (previousViewController == nil)
        {
            [self setCurrentViewController:viewController];
            [[[self currentViewController] view] setFrame:self.view.bounds];
            [self.centreContainerView addSubview:[[self currentViewController] view]];
            
            if (self.leftViewController)
            {
                [self addLeftMenuButtonToChildController:[self currentViewController]];
            }
            
            if (self.rightViewController)
            {
                [self addRightMenuButtonToChildController:[self currentViewController]];
            }
            
            if (self.applyShadow) [self applyShadowToCurrentView];
            
            [viewController.view layoutIfNeeded];
        }
        else if (previousViewController != viewController)
        {
            __weak __block JSSlideViewController *weakSelf=self;
            
            [[viewController view] setFrame:weakSelf.currentViewController.view.frame];
            [self setCurrentViewController:viewController];
            
            if (self.applyShadow) [self applyShadowToCurrentView];

            NSTimeInterval duration = animated ? 0.3f:0.0f;
            [self transitionFromViewController:previousViewController
                              toViewController:viewController
                                      duration:duration
                                       options:options
                                    animations:^{
                                        
                                    } completion:^(BOOL finished) {
                                        // BM: finished = NO on my JSVisualisation App.
                                        // if (finished)
                                        {
                                            [previousViewController removeFromParentViewController];
                                            if (weakSelf.leftViewController)
                                            {
                                                [weakSelf addLeftMenuButtonToChildController:[weakSelf currentViewController]];
                                            }
                                            
                                            if (weakSelf.rightViewController)
                                            {
                                                [weakSelf addRightMenuButtonToChildController:[weakSelf currentViewController]];
                                            }

                                            if (self.leftViewControllerRevealed)
                                            {
                                                [weakSelf hideLeftViewController];
                                            }
                                            else if (self.rightViewControllerRevealed)
                                            {
                                                [weakSelf hideRightViewController];
                                            }
                                        }
                                    }];
        }
        else
        {
            [self hideLeftViewController];
        }
    }
}

-(void)switchToViewController:(UIViewController*)viewController withAnimationOptions:(UIViewAnimationOptions)options
{
    [self switchToViewController:viewController animated:YES withAnimationOptions:options];
}

-(void)switchToViewController:(UIViewController*)viewController animated:(BOOL)animated
{
    [self switchToViewController:viewController animated:animated withAnimationOptions:UIViewAnimationOptionTransitionNone];
}

-(void)switchToViewController:(UIViewController*)viewController
{
    [self switchToViewController:viewController animated:NO withAnimationOptions:UIViewAnimationOptionTransitionNone];
}



-(void)switchToViewControllerWithItemIdentifier:(JSSlideViewControllerIdentifier)identifier animated:(BOOL)animated withAnimationOptions:(UIViewAnimationOptions)options
{
    UIViewController *viewController = [self viewControllerFromIdentifier:identifier];

    [self switchToViewController:viewController animated:animated withAnimationOptions:options];
}

-(void)switchToViewControllerWithItemIdentifier:(JSSlideViewControllerIdentifier)identifier withAnimationOptions:(UIViewAnimationOptions)options
{
    [self switchToViewControllerWithItemIdentifier:identifier animated:YES withAnimationOptions:options];
}

-(void)switchToViewControllerWithItemIdentifier:(JSSlideViewControllerIdentifier)identifier animated:(BOOL)animated
{
    [self switchToViewControllerWithItemIdentifier:identifier animated:animated withAnimationOptions:UIViewAnimationOptionTransitionNone];
}

-(void)switchToViewControllerWithItemIdentifier:(JSSlideViewControllerIdentifier)identifier
{
    UIViewController *viewController = [self viewControllerFromIdentifier:identifier];
    
    [self switchToViewController:viewController animated:NO withAnimationOptions:UIViewAnimationOptionTransitionNone];
}

-(UIViewController*)viewControllerFromIdentifier:(JSSlideViewControllerIdentifier)identifier
{
    UIViewController *viewController = nil;
    
    ViewControllerCreationBlock creationBlock = [[self dataSource] objectForKey:identifier];
    
    if (creationBlock)
    {
        viewController = creationBlock();
    }
    
    return viewController;
}

-(void)setLeftViewControllerRevealed:(BOOL)leftViewControllerRevealed
{
    if (_leftViewControllerRevealed != leftViewControllerRevealed)
    {
        _leftViewControllerRevealed = leftViewControllerRevealed;
        [[self leftContainerView] setHidden:!leftViewControllerRevealed];
        [[self rightContainerView] setHidden:leftViewControllerRevealed];
     }
}

-(void)setRightViewControllerRevealed:(BOOL)rightViewControllerRevealed
{
    if (_rightViewControllerRevealed != rightViewControllerRevealed)
    {
        _rightViewControllerRevealed = rightViewControllerRevealed;
        [[self rightContainerView] setHidden:!rightViewControllerRevealed];
        [[self leftContainerView] setHidden:rightViewControllerRevealed];
    }
}

#pragma mark - Animations

-(CGFloat)calculateScaleFromOrigin:(CGFloat)origin toDestination:(CGFloat)destination maxSpan:(CGFloat)maxSpan
{
    CGFloat scale = (maxSpan - destination) / maxSpan;
    
    return scale;
}

-(NSTimeInterval)calculateDurationFromOrigin:(CGFloat)origin toDestination:(CGFloat)destination maxSpan:(CGFloat)maxSpan
{
    NSTimeInterval duration = 0.5f;
    if ((fabs(MAX(destination, origin) - MIN(origin, destination))/maxSpan) == 1.0f)
    {
        duration = 0.3f;
    }
    return duration;
}

-(CAMediaTimingFunction*)getEasingFunctionForOrigin:(CGFloat)origin toDestination:(CGFloat)destination maxSpan:(CGFloat)maxSpan
{
    CAMediaTimingFunction *easingFunction = easeOutExpo;
    
    if ((fabs(MAX(destination, origin) - MIN(origin, destination))/maxSpan) == 1.0f)
    {
        easingFunction = easeOutQuad;
    }
    return easingFunction;
}

-(void)showLeftViewControllerToX:(CGFloat)x
{
    NSTimeInterval duration = [self calculateDurationFromOrigin:self.centreContainerView.left toDestination:x maxSpan:self.leftViewControllerVisibleWidth];
    CAMediaTimingFunction *easingFunction = [self getEasingFunctionForOrigin:self.centreContainerView.left toDestination:x maxSpan:self.leftViewControllerVisibleWidth];
    
    CGFloat alpha = fabsf(x/self.rightViewControllerVisibleWidth) * self.darkenLeftViewMaxDarkness;
    
    if (x > 0)
    {
        [[self draggableView] setFrame:self.centreContainerView.bounds];
        [[self draggableView] setRevealSide:kJSDraggableSlideViewViewModeForLeftReveal];
 
        [self.centreContainerView addSubview:self.draggableView];
        [self.centreContainerView bringSubviewToFront:self.draggableView];
    }
    
    BOOL didShow = (x == self.leftViewControllerVisibleWidth);
    BOOL willShow = (self.centreContainerView.left == 0);
    BOOL willHide = (x ==  0);
    
    if (willShow)
    {
        [self notifyWillShowViewController:self.leftViewController];
    }
    else if (willHide)
    {
        [self notifyWillHideViewController:self.leftViewController];
    }
    
    __weak JSSlideViewController *wself = self;
    
     [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         [wself.centreContainerView setEasingFunction:easingFunction forKeyPath:@"frame"];
                         [wself.centreContainerView setFrameX:x];
                          
                         if (self.darkenCentreViewControllerOnLeftReveal)
                         {
                             [wself.draggableView setAlpha:alpha];
                         }
                     } completion:^(BOOL finished) {
                         
                         if (didShow)
                         {
                             wself.leftViewControllerRevealed = YES;
                         }
                         else
                         {
                             [[wself draggableView] removeFromSuperview];
                             wself.leftViewControllerRevealed = NO;
                         }
                     }];
}


-(void)showLeftViewController
{
    self.leftViewControllerRevealed = YES;
    [self showLeftViewControllerToX:self.leftViewControllerVisibleWidth];
}

-(void)hideLeftViewController
{
    [self showLeftViewControllerToX:0.0f];
}

#pragma mark -

-(void)notifyWillShowViewController:(UIViewController*)viewController
{
    if ([viewController conformsToProtocol:@protocol(JSSidePanelViewControllerDelegate)] &&
        [viewController respondsToSelector:@selector(viewWillAppearUnderSlideViewController:)])
    {
        [(id<JSSidePanelViewControllerDelegate>)viewController viewWillAppearUnderSlideViewController:self];
    }
    self.lastMessageSentWasViewWillAppear = YES;
}

-(void)notifyDidShowViewController:(UIViewController*)viewController
{
    if (self.lastMessageSentWasViewWillAppear &&
        [viewController conformsToProtocol:@protocol(JSSidePanelViewControllerDelegate)] &&
        [viewController respondsToSelector:@selector(viewDidAppearUnderSlideViewController:)])
    {
        [(id<JSSidePanelViewControllerDelegate>)viewController viewDidAppearUnderSlideViewController:self];
    }
    self.lastMessageSentWasViewWillAppear = NO;
}

-(void)notifyWillHideViewController:(UIViewController*)viewController
{
    if ([viewController conformsToProtocol:@protocol(JSSidePanelViewControllerDelegate)] &&
        [viewController respondsToSelector:@selector(viewWillDisappearUnderSlideViewController:)])
    {
        [(id<JSSidePanelViewControllerDelegate>)viewController viewWillDisappearUnderSlideViewController:self];
    }
    self.lastMessageSentWasViewWillAppear = NO;
}

-(void)notifyDidHideViewController:(UIViewController*)viewController
{
    if ([viewController conformsToProtocol:@protocol(JSSidePanelViewControllerDelegate)] &&
        [viewController respondsToSelector:@selector(viewDidDisappearUnderSlideViewController:)])
    {
        [(id<JSSidePanelViewControllerDelegate>)viewController viewDidDisappearUnderSlideViewController:self];
    }
    self.lastMessageSentWasViewWillAppear = NO;
}


-(void)showRightViewControllerToX:(CGFloat)x
{
    NSTimeInterval duration = [self calculateDurationFromOrigin:self.centreContainerView.right toDestination:x maxSpan:self.rightViewControllerVisibleWidth];
    CAMediaTimingFunction *easingFunction = [self getEasingFunctionForOrigin:self.centreContainerView.right toDestination:x maxSpan:self.rightViewControllerVisibleWidth];
    
    CGFloat alpha = fabs(x / self.rightViewControllerVisibleWidth) * self.darkenRightViewMaxDarkness;

    if (x < 0)
    {
        [[self draggableView] setFrame:self.centreContainerView.bounds];
        [[self draggableView] setRevealSide:kJSDraggableSlideViewViewModeForRightReveal];
        
        [[self centreContainerView] addSubview:[self draggableView]];
        [[self centreContainerView] bringSubviewToFront:self.draggableView];
    }

    BOOL didShow = (x == -self.rightViewControllerVisibleWidth);
    BOOL didHide = (x == 0);
    BOOL willShow = (self.centreContainerView.left == 0);
    BOOL willHide = (x ==  0);
    
    if (willShow)
    {
        [self notifyWillShowViewController:self.rightViewController];
    }
    else if (willHide)
    {
        [self notifyWillHideViewController:self.rightViewController];
    }

    __weak JSSlideViewController *wself = self;
  
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         [[wself centreContainerView] setEasingFunction:easingFunction forKeyPath:@"frame"];
                         [[wself centreContainerView] setFrameX:x];
                         
                         if (self.darkenCentreViewControllerOnRightReveal)
                         {
                             [[wself draggableView] setAlpha:alpha];
                         }
                         
                     } completion:^(BOOL finished) {
                         
                         if (didShow)
                         {
                             wself.rightViewControllerRevealed = YES;
                             [wself notifyDidShowViewController:self.rightViewController];
                         }
                         else if (didHide)
                         {
                             [[wself draggableView] removeFromSuperview];
                             wself.rightViewControllerRevealed = NO;
                             [wself notifyDidHideViewController:self.rightViewController];
                         }
                      }];
}


-(void)showRightViewController
{
    self.rightViewControllerRevealed = YES;
    [self showRightViewControllerToX:-self.rightViewControllerVisibleWidth];
}

-(void)hideRightViewController
{
    [self showRightViewControllerToX:0.0f];
}

#pragma mark -

-(void)setDarkenCentreViewControllerOnLeftReveal:(BOOL)darkenCentreViewControllerOnLeftReveal
{
    _darkenCentreViewControllerOnLeftReveal = darkenCentreViewControllerOnLeftReveal;
    
    [[self draggableView] setAlpha:darkenCentreViewControllerOnLeftReveal ? 0.0f : 1.0f];
    [[self draggableView] setBackgroundColor:darkenCentreViewControllerOnLeftReveal ? [UIColor blackColor] : [UIColor clearColor]];
}

-(void)setDarkenCentreViewControllerOnRightReveal:(BOOL)darkenCentreViewControllerOnRightReveal
{
    _darkenCentreViewControllerOnRightReveal = darkenCentreViewControllerOnRightReveal;
    
    [[self draggableView] setAlpha:darkenCentreViewControllerOnRightReveal ? 0.0f : 1.0f];
    [[self draggableView] setBackgroundColor:darkenCentreViewControllerOnRightReveal ? [UIColor blackColor] : [UIColor clearColor]];
}

-(void)setDarkenLeftViewMaxDarkness:(CGFloat)darkenLeftViewMaxDarkness
{
    _darkenLeftViewMaxDarkness = MIN( 1.0f, darkenLeftViewMaxDarkness);
}

-(void)setDarkenRightViewMaxDarkness:(CGFloat)darkenRightViewMaxDarkness
{
    _darkenRightViewMaxDarkness = MIN( 1.0f, darkenRightViewMaxDarkness);
}

-(void)setCentreContainerViewOrigin:(CGPoint)centreContainerViewOrigin
{
    [[self centreContainerView] setFrameOrigin:centreContainerViewOrigin];
    
    if (centreContainerViewOrigin.x == 0)
    {
        [[self draggableView] removeFromSuperview];
    }
    else if (centreContainerViewOrigin.x < 0)
    {
        if (self.draggableView.superview == nil)
        {
            [self notifyWillShowViewController:self.rightViewController];
            
            [[self draggableView] setFrame:self.centreContainerView.bounds];
            [[self draggableView] setRevealSide:kJSDraggableSlideViewViewModeForRightReveal];
            
            [[self centreContainerView] addSubview:[self draggableView]];
            [[self centreContainerView] bringSubviewToFront:self.draggableView];
        }
        if (self.darkenCentreViewControllerOnRightReveal)
        {
            [[self draggableView] setAlpha:fabsf(centreContainerViewOrigin.x/self.rightViewControllerVisibleWidth) * self.darkenRightViewMaxDarkness];
        }
    }
    else if (centreContainerViewOrigin.x > 0)
    {
        if (self.draggableView.superview == nil)
        {
            [self notifyWillHideViewController:self.leftViewController];
            
            [[self draggableView] setFrame:self.centreContainerView.bounds];
            [[self draggableView] setRevealSide:kJSDraggableSlideViewViewModeForLeftReveal];
            
            [[self centreContainerView] addSubview:[self draggableView]];
            [[self centreContainerView] bringSubviewToFront:self.draggableView];
        }
        if (self.darkenCentreViewControllerOnLeftReveal)
        {
            [[self draggableView] setAlpha:(centreContainerViewOrigin.x/self.leftViewControllerVisibleWidth) * self.darkenLeftViewMaxDarkness];
        }
    }
}

-(CGPoint)centreContainerViewOrigin
{
    return self.centreContainerView.frame.origin;
}

#pragma UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end

@implementation UIViewController (JSSlideViewController)

-(JSSlideViewController*)slideViewController
{
    UIViewController *viewController = self.parentViewController;
    
    while (!(viewController == nil || [viewController isKindOfClass:[JSSlideViewController class]]))
    {
        viewController = viewController.parentViewController;
    }
    
    return (JSSlideViewController*)viewController;
}

@end

@implementation UIView (JSSlideViewController)

-(JSSlideViewController*)slideViewController
{
    UIViewController *viewController = [self parentViewController];
    
    while (!(viewController == nil || [viewController isKindOfClass:[JSSlideViewController class]]))
    {
        viewController = viewController.parentViewController;
    }
    
    return (JSSlideViewController*)viewController;
}

@end


