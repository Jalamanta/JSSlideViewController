//
//  JSSlideViewController.h
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

#import <UIKit/UIKit.h>
#import "JSSlideView.h"
#import "JSSlideViewButton.h"

@protocol JSSlideViewChildControllerProtocol;
@protocol JSSlideViewControllerDelegate;
@protocol JSSidePanelViewControllerDelegate;

@class JSSlideViewButton;

@interface JSSlideViewController : UIViewController

@property (nonatomic, strong, readonly) UIViewController *currentViewController;

@property (nonatomic, strong) UIViewController *leftViewController;
@property (nonatomic, strong) UIViewController *rightViewController;

@property (nonatomic, assign) CGFloat leftViewControllerVisibleWidth;
@property (nonatomic, assign) CGFloat rightViewControllerVisibleWidth;

@property (nonatomic, assign) BOOL leftViewControllerRevealed;
@property (nonatomic, assign) BOOL rightViewControllerRevealed;

@property (nonatomic, assign) BOOL resizeLeftViewController;   // BM: Resize to viewable area
@property (nonatomic, assign) BOOL resizeRightViewController;  // BM: Resize to viewable area

@property (nonatomic, assign) id<JSSlideViewControllerDelegate> slideViewControllerDelegate;

@property (nonatomic, assign) BOOL applyShadow;                             // BM: Default is NO
@property (nonatomic, assign) BOOL darkenCentreViewControllerOnLeftReveal;  // BM: Default is NO
@property (nonatomic, assign) BOOL darkenCentreViewControllerOnRightReveal; // BM: Default is NO
@property (nonatomic, assign) CGFloat darkenLeftViewMaxDarkness;            // BM: Default is 0.4f
@property (nonatomic, assign) CGFloat darkenRightViewMaxDarkness;           // BM: Default is 0.4f

@property (nonatomic, assign) CGPoint centreContainerViewOrigin;


// BM: Returns an Identifier which you can use to access Menu Items and its attributes.

-(JSSlideViewControllerIdentifier)addViewControllerWithBlock:(ViewControllerCreationBlock)block;
-(void)removeViewControllerWithItemIdentifier:(JSSlideViewControllerIdentifier)identifer;

-(void)showLeftViewController;
-(void)showLeftViewControllerToX:(CGFloat)x;
-(void)hideLeftViewController;

-(void)showRightViewController;
-(void)showRightViewControllerToX:(CGFloat)x;
-(void)hideRightViewController;

-(void)switchToViewController:(UIViewController*)viewController withAnimationOptions:(UIViewAnimationOptions)options;
-(void)switchToViewController:(UIViewController*)viewController;

-(void)switchToViewControllerWithItemIdentifier:(JSSlideViewControllerIdentifier)identifier withAnimationOptions:(UIViewAnimationOptions)options;
-(void)switchToViewControllerWithItemIdentifier:(JSSlideViewControllerIdentifier)identifier;

@end

@interface UIViewController (JSSlideViewController)

-(JSSlideViewController*)slideViewController;

@end

@interface UIView (JSSlideViewController)

-(JSSlideViewController*)slideViewController;

@end


// BM: Not yet implemented 
@protocol JSSlideViewControllerDelegate <NSObject>

@optional

-(void)slideViewController:(JSSlideViewController*)slideViewController willSwitchToViewControllerWithItemIdentifer:(JSSlideViewControllerIdentifier)identifier;
-(void)slideViewController:(JSSlideViewController*)slideViewController didSwitchToViewControllerWithItemIdentifer:(JSSlideViewControllerIdentifier)identifier;

@end

@protocol JSSidePanelViewControllerDelegate <NSObject>

@optional

-(void)viewWillAppearUnderSlideViewController:(JSSlideViewController*)slideViewController;
-(void)viewDidAppearUnderSlideViewController:(JSSlideViewController*)slideViewController;
-(void)viewWillDisappearUnderSlideViewController:(JSSlideViewController*)slideViewController;
-(void)viewDidDisappearUnderSlideViewController:(JSSlideViewController*)slideViewController;

@end

