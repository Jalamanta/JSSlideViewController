//
//  UIView+FrameUtils.h
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

#import "UIView+Frame.h"
#import "JSRectUtils.h"

@implementation UIView (Frame)

-(void)setFrameX:(CGFloat)x 
{
    [self setFrame:CGRectWithNewX([self frame], x)];
}

-(void)setFrameY:(CGFloat)y 
{
    [self setFrame:CGRectWithNewY([self frame], y)];    
}

-(void)setFrameOrigin:(CGPoint)origin 
{
    [self setFrame:CGRectWithNewOrigin([self frame], origin)];
}

-(void)setFrameWidth:(CGFloat)width 
{
    [self setFrame:CGRectWithNewWidth([self frame], width)];
}

-(void)setFrameHeight:(CGFloat)height 
{
    [self setFrame:CGRectWithNewHeight([self frame], height)];    
}

-(void)setFrameSize:(CGSize)size 
{
    [self setFrame:CGRectWithNewSize([self frame], size)];        
}

-(void)setSize:(CGSize)size
{
    [self setFrameSize:size];
}

-(CGFloat)left
{
    return CGRectGetMinX(self.frame);
}

-(CGFloat)top
{
    return CGRectGetMinY(self.frame);
}

-(CGFloat)right
{
    return CGRectGetMaxX(self.frame);
}

-(CGFloat)bottom
{
    return CGRectGetMaxY(self.frame);
}

-(CGFloat)width
{
    return CGRectGetWidth(self.frame);
}

-(CGFloat)height
{
    return CGRectGetHeight(self.frame);
}

-(CGSize)size
{
    return self.frame.size;
}

-(void)setTop:(CGFloat)top
{
    [self setFrameY:top];
}

-(void)setBottom:(CGFloat)bottom
{
   [self setFrameHeight:bottom - self.top];
}

-(void)setLeft:(CGFloat)left
{
    [self setFrameX:left];
}

-(void)setRight:(CGFloat)right
{
    [self setFrameWidth:right - self.left];
}

-(void)setWidth:(CGFloat)width
{
    [self setFrameWidth:width];
}

-(void)setHeight:(CGFloat)height
{
    [self setFrameHeight:height];
}

-(void)setBoundsWidth:(CGFloat)width 
{
    [self setBounds:CGRectWithNewWidth([self bounds], width)];    
}

-(void)setBoundsHeight:(CGFloat)height 
{
    [self setBounds:CGRectWithNewHeight([self bounds], height)];    
}

-(void)setBoundsSize:(CGSize)size 
{
    [self setBounds:CGRectWithNewSize([self bounds], size)];            
}

-(void)setBoundsSquareWithLength:(CGFloat)length
{
    [self setBoundsSize:CGSizeMake(length, length)];
}

@end
