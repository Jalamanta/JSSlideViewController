//
//  JSSlideMenuViewController.h
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

@interface JSSlideMenuViewController : UIViewController

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIImage *backgroundImage;

@property (nonatomic, strong) UIColor *titleBackgroundColor;
@property (nonatomic, strong) UIImage *titleBackgroundImage;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, assign) BOOL showTitleView;

@property (nonatomic, strong, readonly) UIViewController *currentViewController;
@property (nonatomic, assign) CGFloat minimumXOffset;
@property (nonatomic, assign) CGFloat maximumXOffset;

@property (nonatomic, strong) UIColor *menuItemTextColor;
@property (nonatomic, assign) NSTextAlignment menuItemTextAlignment;
@property (nonatomic, strong) UIFont *menuItemFont;
@property (nonatomic, strong) UIColor *menuItemSelectedTextColor;
@property (nonatomic, strong) UIFont *menuItemSelectedFont;

@property (nonatomic, strong) UIColor *menuItemBackgroundColor;
@property (nonatomic, strong) UIImage *menuItemBackgroundImage;
@property (nonatomic, strong) UIView *menuItemBackgroundView;
@property (nonatomic, assign) SelectedViewCreationBlock menuItemSelectedBackgroundViewBlock;
@property (nonatomic, assign) CGFloat rowHeight;

@property (nonatomic, strong) UIColor *menuSectionTextColor;
@property (nonatomic, assign) NSTextAlignment menuSectionTextAlignment;
@property (nonatomic, strong) UIFont *menuSectionFont;
@property (nonatomic, strong) UIColor *menuSectionBackgroundColor;
@property (nonatomic, strong) UIImage *menuSectionBackgroundImage;
@property (nonatomic, assign) CGFloat sectionHeight;

@property (nonatomic, strong) UIColor *badgeTextColor;
@property (nonatomic, strong) UIColor *badgeBackgroundColor;
@property (nonatomic, strong) UIFont *badgeFont;
@property (nonatomic, assign) CGFloat badgeXOffset;

@property (nonatomic, strong) UIColor *separatorColor;

-(void)createItemWithMenuIdentifier:(JSSlideViewControllerIdentifier)identifier forSection:(NSInteger)sectionNumber withTitle:(NSString*)title;
-(void)removeItemWithMenuIdentifier:(JSSlideViewControllerIdentifier)identifier;

-(void)setTitle:(NSString*)title forItemWithIdentifier:(JSSlideViewControllerIdentifier)identifer;
-(void)setIcon:(UIImage*)icon forItemWithIdentifier:(JSSlideViewControllerIdentifier)identifer;
-(void)setBadgeText:(NSString*)badgeText forItemWithIdentifier:(JSSlideViewControllerIdentifier)identifier;
-(void)setCustomView:(UIView *)customView preferredHeight:(CGFloat)height forItemWithIdentifier:(JSSlideViewControllerIdentifier)identifer;
-(void)setHidden:(BOOL)hidden forItemWithIdentifier:(JSSlideViewControllerIdentifier)identifer;

-(void)setMenuItemSelectedBlock:(JSMenuItemSelectedBlock)block forItemWithIdentifier:(JSSlideViewControllerIdentifier)identifer;

-(void)setSectionTitle:(NSString *)title forSection:(NSInteger)sectionNumber;

@end
