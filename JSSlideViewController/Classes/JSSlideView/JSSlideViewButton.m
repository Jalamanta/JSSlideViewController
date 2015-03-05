//
//  JSSlideViewButton.m
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
#import "UIView+Frame.h"
#import "JSSlideViewController.h"
#import "JSSlideViewButton.h"

@interface JSSlideViewButton () <UIGestureRecognizerDelegate>
@property (nonatomic, assign) CGPoint currentPanPoint;

+(JSSlideViewButton*)slideViewButton;

@end

@implementation JSSlideViewButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setEnableTap:YES];
    }
    return self;
}

+(JSSlideViewButton*)slideViewButton
{
    JSSlideViewButton *menuButton = [[JSSlideViewButton alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, 44.0f, 44.0f)];
    
    [menuButton setTitle:@"Menu"];
    [[menuButton titleLabel] setFont:[UIFont boldSystemFontOfSize:17.0f]];
    
    [menuButton setWidth:60.0f];
    
    return menuButton;
}

+(JSSlideViewButton*)slideViewButtonForLeftReveal
{
    JSSlideViewButton *JSSlideViewButton = [[self class] slideViewButton];
    [JSSlideViewButton setRevealSide:kJSDraggableSlideViewViewModeForLeftReveal];
    return JSSlideViewButton;
}

+(JSSlideViewButton*)slideViewButtonForRightReveal
{
    JSSlideViewButton *JSSlideViewButton = [[self class] slideViewButton];
    [JSSlideViewButton setRevealSide:kJSDraggableSlideViewViewModeForRightReveal];
    return JSSlideViewButton;
}

+(JSSlideViewButton*)slideViewButtonWithTitle:(NSString*)title
{
    JSSlideViewButton *menuButton = [[JSSlideViewButton alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, 60.0f, 44.0f)];
    [menuButton setTitle:title];
    
    return menuButton;
}


+(JSSlideViewButton*)slideViewButtonWithImage:(UIImage*)image
{
    JSSlideViewButton *menuButton = [[JSSlideViewButton alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, 44.0f, 44.0f)];
    [menuButton setImage:image];
    
    return menuButton;
}

@end
