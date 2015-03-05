//
//  JSSlideMenuDataSource.h
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
#import <CoreLocation/CoreLocation.h>
#import "JSSlideView.h"

extern NSString *const JSSlideMenuTableViewCellReuseIdent;

@interface JSSlideMenuDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, strong) UIColor *menuItemTextColor;
@property (nonatomic, assign) NSTextAlignment menuItemTextAlignment;
@property (nonatomic, strong) UIFont *menuItemFont;

@property (nonatomic, strong) UIColor *menuItemSelectedTextColor;
@property (nonatomic, strong) UIFont *menuItemSelectedFont;

@property (nonatomic, strong) UIColor *menuItemBackgroundColor;
@property (nonatomic, strong) UIImage *menuItemBackgroundImage;

@property (nonatomic, strong) UIView *menuItemBackgroundView;

@property (nonatomic, strong) UIColor *badgeTextColor;
@property (nonatomic, strong) UIColor *badgeBackgroundColor;
@property (nonatomic, strong) UIFont *badgeFont;
@property (nonatomic, assign) CGFloat badgeXOffset;

@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, assign) CGFloat sectionHeight;

-(void)createItemWithMenuIdentifier:(JSSlideViewControllerIdentifier)identifier forSection:(NSInteger)sectionNumber withTitle:(NSString*)title;
-(NSIndexPath*)removeItemWithMenuIdentifier:(JSSlideViewControllerIdentifier)identifier;

-(void)setTitle:(NSString*)title forItemWithIdentifier:(JSSlideViewControllerIdentifier)identifier;

-(void)setIcon:(UIImage*)icon forItemWithIdentifier:(JSSlideViewControllerIdentifier)identifier;

-(void)setBadgeText:(NSString*)badgeText forItemWithIdentifier:(JSSlideViewControllerIdentifier)identifier;
-(NSString*)badgeTextForItemWithIdentifier:(JSSlideViewControllerIdentifier)identifier;

-(void)setCustomView:(UIView *)customView preferredHeight:(CGFloat)height forItemWithIdentifier:(JSSlideViewControllerIdentifier)identifier;

-(void)setMenuItemSelectedBlock:(JSMenuItemSelectedBlock)block forItemWithIdentifier:(JSSlideViewControllerIdentifier)identifer;
-(JSMenuItemSelectedBlock)menuItemSelectedBlockWithIdentifier:(JSSlideViewControllerIdentifier)identifier;
-(JSMenuItemSelectedBlock)menuItemSelectedBlockForItemWithIndexPath:(NSIndexPath*)indexPath;

-(void)setHidden:(BOOL)hidden forItemWithIdentifier:(JSSlideViewControllerIdentifier)identifier;
-(BOOL)isRowHiddenForItemWithIdentifier:(JSSlideViewControllerIdentifier)identifier;

-(BOOL)isRowHiddenForItemWithIndexPath:(NSIndexPath*)indexPath;

-(void)setTitle:(NSString *)title forSectionNumber:(NSUInteger)sectionNumber;

-(JSSlideViewControllerIdentifier)menuIdentifierForItemWithIndexPath:(NSIndexPath*)indexPath;

-(NSIndexPath*)indexPathForTitle:(NSString*)title inSectionNumber:(NSUInteger)sectionNumber;
-(NSIndexPath*)indexPathForItemWithIdentifier:(JSSlideViewControllerIdentifier)identifier;

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath;

-(CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;
-(CGFloat)heightForSectionNumber:(NSUInteger)sectionNumber;

@end
