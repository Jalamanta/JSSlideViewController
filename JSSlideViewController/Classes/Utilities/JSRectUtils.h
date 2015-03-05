//
//  JSRectUtils.h
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

#ifndef __JSRectUtils__
#define __JSRectUtils__

#import <CoreGraphics/CGGeometry.h>

#include <stdio.h>

CGRect CGRectWithNewWidth( CGRect oldRect, CGFloat newWidth);
CGRect CGRectWithNewHeight( CGRect oldRect, CGFloat newHeight);
CGRect CGRectWithNewSize( CGRect oldRect, CGSize newSize);
CGRect CGRectWithNewX( CGRect oldRect, CGFloat newX);
CGRect CGRectWithNewY( CGRect oldRect, CGFloat newY);
CGRect CGRectWithNewOrigin( CGRect oldRect, CGPoint newOrigin);

CGFloat CGRectLeft( CGRect rect);
CGFloat CGRectRight( CGRect rect);
CGFloat CGRectTop( CGRect rect);
CGFloat CGRectBottom( CGRect rect);
CGPoint CGRectCenter( CGRect rect);

CGPoint CGRectTopLeft( CGRect rect);
CGPoint CGRectTopRight( CGRect rect);
CGPoint CGRectBottomLeft( CGRect rect);
CGPoint CGRectBottomRight( CGRect rect);

CGRect CGRectFromSize( CGSize size);
CGRect CGRectFromWidthHeight( CGFloat width, CGFloat height);

CGPoint CGPointIntegral( CGPoint point);
CGSize CGSizeIntegral( CGSize size);

#endif /* defined(__JSRectUtils__) */
