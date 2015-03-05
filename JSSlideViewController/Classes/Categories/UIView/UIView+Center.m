//
//  UIView+Center.m
//  JSFramework
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

#import "UIView+Center.h"

#import "JSRectUtils.h"
#import "UIView+Frame.h"

@implementation UIView (Center)

-(void)setCenterIntegral:(CGPoint)center
{
    [self setFrameOrigin:CGPointIntegral(CGPointMake(center.x - self.width/2.0f, center.y - self.height/2.0f))];
}

-(void)centerViewVerticallyForDeviceRotationWithDuration:(NSTimeInterval)duration
{    
    // center is wrong in landscape mode on iPad.
    CGRect parentBounds = [[self superview] frame];
    CGPoint parentCenter = CGPointMake( parentBounds.size.width/2.0f,
                                       parentBounds.size.height/2.0f);
    
    CGPoint newCenter = [self center];
    newCenter.y = parentCenter.x;
    
    if (duration > 0.0f)
    {
        [UIView animateWithDuration:duration animations:^(void)
         {
             [self setCenterIntegral:newCenter];
         }];
    }
    else {
        [self setCenterIntegral:newCenter];
    }
}

-(void)centerViewVertically
{
    // center is wrong in landscape mode on iPad.
    CGRect parentBounds = [[self superview] frame];
    CGPoint parentCenter = CGPointMake( parentBounds.size.width/2.0f,
                                       parentBounds.size.height/2.0f);
    
    CGPoint newCenter = [self center];
    newCenter.y = parentCenter.y;
    
    [self setCenterIntegral:newCenter];
    
}

// Argh - American spelling!
-(void)centerViewHorizontallyForDeviceRotationWithDuration:(NSTimeInterval)duration
{
    
    // center is wrong in landscape mode on iPad.
    CGRect parentBounds = [[self superview] frame];
    CGPoint parentCenter = CGPointMake( parentBounds.size.width/2.0f,
                                       parentBounds.size.height/2.0f);
    
    CGPoint newCenter = [self center];
    newCenter.x = parentCenter.y;
    
    if (duration > 0.0f) {
        [UIView animateWithDuration:duration animations:^(void)
         {
             [self setCenterIntegral:newCenter];
         }];
    }
    else
    {
        [self setCenterIntegral:newCenter];
    }
}

-(void)centerViewHorizontally
{
    // center is wrong in landscape mode on iPad.
    CGRect parentBounds = [[self superview] frame];
    CGPoint parentCenter = CGPointMake( parentBounds.size.width/2.0f,
                                       parentBounds.size.height/2.0f);
    
    CGPoint newCenter = [self center];
    newCenter.x = parentCenter.x;
    
    [self setCenterIntegral:newCenter];
}

// Call in willRotate
-(void)centerViewForDeviceRotationWithDuration:(NSTimeInterval)duration
{
    
    CGPoint parentCenter;    
    
    // center is wrong in landscape mode on iPad.
    CGRect parentBounds = [[self superview] frame];
    
    
    // When a device starts in PortraitUpsideDown then a rotation is from Portrait to Portrait Upside Down.
    // This is the exception to normal behaviour which is that a rotation will always be from Portrait to Landscape
    // or vice versa.
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortraitUpsideDown &&
        [[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortrait)
    {
        parentCenter = CGPointMake( (parentBounds.size.width) / 2.0f,
                                    (parentBounds.size.height) / 2.0f);
        
    }
    else
    {
        parentCenter = CGPointMake( (parentBounds.size.height + 20.0f) / 2.0f,
                                    (parentBounds.size.width - 20.0f) / 2.0f);
    }
         
    if (duration > 0.0f)
    {
        [UIView animateWithDuration:duration animations:^(void)
         {
             [self setCenterIntegral:parentCenter];
         }];
    }
    else
    {
        [self setCenterIntegral:parentCenter];
    }
}

-(void)centerView
{
    CGRect parentBounds = [[self superview] frame];
    CGPoint parentCenter = CGPointMake( parentBounds.size.width/2.0f,
                                       parentBounds.size.height/2.0f);
    [self setCenterIntegral:parentCenter];
}

@end
