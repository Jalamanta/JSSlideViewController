//
//  JSSlideMenuViewCell.m
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

#import "UIView+Frame.h"
#import "UIView+Center.h"
#import "JSSlideMenuViewCell.h"

@interface JSSlideMenuViewCell ()

@property (nonatomic, strong) UILabel *badgeLabel;

@end

@implementation JSSlideMenuViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, 30.0f, 20.0f)];
        [[[self badgeLabel] layer] setCornerRadius:2.5f];
        [[[self badgeLabel] layer] setMasksToBounds:YES];
        [[self badgeLabel] setTextAlignment:NSTextAlignmentCenter];
        [[self contentView] addSubview:self.badgeLabel];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [[self badgeLabel] centerViewVertically];
    [[self badgeLabel] setHidden:(self.badgeLabel.text == nil)];
    [[self badgeLabel] setBackgroundColor:self.badgeLabelBackgroundColor];   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    [[self badgeLabel] setBackgroundColor:self.badgeLabelBackgroundColor];
}

-(void)setCustomView:(UIView *)customView
{
    if (_customView != customView)
    {
        [_customView removeFromSuperview];
        [self addSubview:customView];
        
        _customView = customView;
    }
}

@end
