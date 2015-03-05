//
//  JSDraggableSlideView.h
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

#import <QuartzCore/QuartzCore.h>
#import "JSUtilities.h"
#import "UIView+Frame.h"
#import "JSSlideViewController.h"
#import "JSDraggableSlideView.h"
#import "JSSlideViewController.h"

@interface JSDraggableSlideView () <UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGPoint currentPanPoint;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong, readwrite) UILabel *titleLabel;

@end

@implementation JSDraggableSlideView

+(JSDraggableSlideView*)JSDraggableSlideViewWithFrame:(CGRect)frame
{
    JSDraggableSlideView *draggableView = [[JSDraggableSlideView alloc] initWithFrame:frame];
    
    return draggableView;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewPanned:)]];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)]];
        
        [self setClipsToBounds:YES];
        
        [self setEnableDrag:YES];
    }
    return self;
}


-(void)setImage:(UIImage *)image
{
    if (_image != image)
    {
        if (self.imageView == nil)
        {            self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
            [[self imageView] setContentMode:UIViewContentModeCenter];
            [[self imageView] setUserInteractionEnabled:YES];
            [self addSubview:[self imageView]];
        }
        
        [[self imageView] setImage:image];
        _image = image;
    }
}

-(void)setTitle:(NSString*)title
{
    if (_title != title)
    {
        if (self.titleLabel == nil)
        {
            self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
            [[self titleLabel] setTextAlignment:NSTextAlignmentCenter];
            [self addSubview:[self titleLabel]];
        }
        [[self titleLabel] setText:title];
        _title = title;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_image) [[self imageView] setFrame:self.bounds];
    if (_title) [[self titleLabel] setFrame:self.bounds];
}

-(void)viewPanned:(UIPanGestureRecognizer*)gesture
{
    if (self.enableDrag)
    {
        CGFloat minimumConstraint = 0.0f;
        CGFloat maximumConstraint = self.slideViewController.leftViewControllerVisibleWidth;

        if (self.revealSide == kJSDraggableSlideViewViewModeForRightReveal)
        {
            [[self slideViewController] setRightViewControllerRevealed:YES];
            minimumConstraint = -self.slideViewController.rightViewControllerVisibleWidth;
            maximumConstraint = 0.0f;
        }
        else
        {
            [[self slideViewController] setLeftViewControllerRevealed:YES];
        }
        
        CGPoint translatedPoint = [gesture translationInView:self.superview];
       
        if (gesture.state == UIGestureRecognizerStateBegan)
        {
            self.currentPanPoint = translatedPoint;
        }
        else if (gesture.state == UIGestureRecognizerStateChanged)
        {
            CGFloat x = self.slideViewController.centreContainerViewOrigin.x + (translatedPoint.x - self.currentPanPoint.x);
            
            x = MAX( minimumConstraint, MIN(x, maximumConstraint));
            
            [[self slideViewController] setCentreContainerViewOrigin:CGPointMake( x, self.slideViewController.centreContainerViewOrigin.y)];
            
            self.currentPanPoint = translatedPoint;
        }
        else if (gesture.state == UIGestureRecognizerStateEnded ||
                 gesture.state == UIGestureRecognizerStateCancelled ||
                 gesture.state == UIGestureRecognizerStateFailed)
        {
            CGFloat x = self.slideViewController.centreContainerViewOrigin.x + (translatedPoint.x - self.currentPanPoint.x);
            
            x = MAX( minimumConstraint, MIN(x, maximumConstraint));
            
            CGFloat destinationX = [JSUtilities closestConstraintToValue:x
                                                     minimumConstraint:minimumConstraint
                                                     maximumConstraint:maximumConstraint];
            
            if (self.revealSide == kJSDraggableSlideViewViewModeForLeftReveal)
            {
                [[self slideViewController] showLeftViewControllerToX:destinationX];
            }
            else
            {
                [[self slideViewController] showRightViewControllerToX:destinationX];
            }
        }
    }
}


-(void)viewTapped:(UITapGestureRecognizer*)gesture
{
    if (self.enableTap)
    {
        if (self.revealSide == kJSDraggableSlideViewViewModeForLeftReveal)
        {
            if (self.slideViewController.leftViewControllerRevealed)
            {
                [[self slideViewController] hideLeftViewController];
            }
            else
            {
                [[self slideViewController] showLeftViewController];
            }
        }
        else
        {
            if (self.slideViewController.rightViewControllerRevealed)
            {
                [[self slideViewController] hideRightViewController];
            }
            else
            {
                [[self slideViewController] showRightViewController];
            }
        }
    }
}

#pragma mark -

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

@end
