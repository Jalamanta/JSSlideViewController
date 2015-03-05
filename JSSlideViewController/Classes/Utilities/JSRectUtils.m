//
//  JSRectUtils.m
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

#import "JSUtilsC.h"
#include "JSRectUtils.h"

CGRect CGRectWithNewWidth( CGRect oldRect, CGFloat newWidth)
{
	CGRect newRect = oldRect;
	
	newRect.size.width = newWidth;
	
	return newRect;
}

CGRect CGRectWithNewHeight( CGRect oldRect, CGFloat newHeight)
{
	CGRect newRect = oldRect;
	
	newRect.size.height = newHeight;
	
	return newRect;
}

CGRect CGRectWithNewSize( CGRect oldRect, CGSize newSize)
{
    CGRect newRect = oldRect;
    
    newRect.size = newSize;
    
    return newRect;
}


CGRect CGRectWithNewX( CGRect oldRect, CGFloat newX)
{
	CGRect newRect = oldRect;
	
	newRect.origin.x = newX;
	
	return newRect;
}

CGRect CGRectWithNewY( CGRect oldRect, CGFloat newY)
{
	CGRect newRect = oldRect;
	
	newRect.origin.y = newY;
	
	return newRect;
}

CGRect CGRectWithNewOrigin( CGRect oldRect, CGPoint newOrigin)
{
    CGRect newRect = oldRect;
    
    newRect.origin = newOrigin;
    
    return newRect;
}


CGRect CGRectInsetLeft( CGRect oldRect, CGFloat inset)
{
    CGRect newRect = oldRect;
    
    newRect.origin.x += inset;
    newRect.size.width -= inset;
    newRect.size.width = pos(newRect.size.width);
    
    return newRect;
}

CGRect CGRectInsetRight( CGRect oldRect, CGFloat inset)
{
    CGRect newRect = oldRect;
    
    newRect.size.width -= inset;
    newRect.size.width = pos(newRect.size.width);
    
    return newRect;
}

CGRect CGRectInsetTop( CGRect oldRect, CGFloat inset)
{
    CGRect newRect = oldRect;
    
    newRect.origin.y += inset;
    newRect.size.height -= inset;
    newRect.size.height = pos(newRect.size.height);
    
    return newRect;
}

CGRect CGRectInsetBottom( CGRect oldRect, CGFloat inset)
{
    CGRect newRect = oldRect;
    
    newRect.size.height -= inset;
    newRect.size.height = pos(newRect.size.height);
    
    return newRect;
}

CGSize CGPointSizeFromSize( CGSize size)
{
    return CGSizeMake( size.width * 2.0f, size.height * 2.0f);
}

CGFloat CGRectLeft( CGRect rect)
{
    return rect.origin.x;
}

CGFloat CGRectRight( CGRect rect)
{
    return rect.origin.x + rect.size.width;
}

CGFloat CGRectTop( CGRect rect)
{
    return rect.origin.y;
}

CGFloat CGRectBottom( CGRect rect)
{
    return rect.origin.y + rect.size.height;
}

CGPoint CGRectCenter( CGRect rect)
{
    return CGPointMake( CGRectGetMidX(rect), CGRectGetMidY(rect));
}

CGPoint CGRectTopLeft( CGRect rect)
{
	return rect.origin;
}

CGPoint CGRectTopRight( CGRect rect)
{
	return CGPointMake( CGRectGetMaxX(rect), CGRectGetMinY(rect));
}

CGPoint CGRectBottomLeft( CGRect rect)
{
	return CGPointMake( CGRectGetMinX(rect), CGRectGetMaxY(rect));
}

CGPoint CGRectBottomRight( CGRect rect)
{
	return CGPointMake( CGRectGetMaxX(rect), CGRectGetMaxY(rect));
}

CGRect CGRectFromSize( CGSize size)
{
    return CGRectMake( 0.0f, 0.0f, size.width, size.height);
}

CGRect CGRectFromWidthHeight( CGFloat width, CGFloat height)
{
    return CGRectMake( 0.0f, 0.0f, width, height);
}

CGPoint CGPointIntegral( CGPoint point)
{
    return CGPointMake( (int)point.x, (int)point.y);
}

CGSize CGSizeIntegral( CGSize size)
{
    return CGSizeMake( (int)size.width, (int)size.height);
}

