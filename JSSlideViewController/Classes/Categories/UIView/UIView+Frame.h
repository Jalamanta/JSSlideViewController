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

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;

-(void)setFrameX:(CGFloat)x;
-(void)setFrameY:(CGFloat)x;
-(void)setFrameOrigin:(CGPoint)origin;
-(void)setFrameWidth:(CGFloat)width;
-(void)setFrameHeight:(CGFloat)height;
-(void)setFrameSize:(CGSize)size;

-(void)setBoundsWidth:(CGFloat)width;
-(void)setBoundsHeight:(CGFloat)height;
-(void)setBoundsSize:(CGSize)size;
-(void)setBoundsSquareWithLength:(CGFloat)length;

@end
