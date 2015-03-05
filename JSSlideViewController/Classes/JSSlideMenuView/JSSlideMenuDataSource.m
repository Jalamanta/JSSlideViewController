//
//  JSSlideMenuDataSource.m
//  UtilJS Kit
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

#import "JSSlideViewController.h"
#import "UIView+Frame.h"
#import "UIView+Center.h"
#import "JSSlideMenuDataSource.h"
#import "JSSlideMenuViewCell.h"
#import "JSSlideMenuViewController.h"

NSString *const JSSlideMenuTableViewCellReuseIdent = @"JSSlideMenuTableViewCellReuseIdent";


#define kSliderMenuSectionHeight (34.0f)
#define kSliderMenuTitleHeight (44.0f)

@class SOMenuSection;

@interface SOMenuRow : NSObject

@property (nonatomic, strong) JSSlideViewControllerIdentifier identifier;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) NSString *badgeText;
@property (nonatomic, assign) BOOL hidden;
@property (nonatomic, weak) SOMenuSection *menuSection;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, copy) JSMenuItemSelectedBlock selectedBlock;
@property (nonatomic, assign) CGFloat preferredHeightForCustomView;

-(id)initWithMenuSection:(SOMenuSection*)section;

@end

@interface SOMenuSection : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSMutableArray *rows;

-(id)initWithTitle:(NSString*)title;
-(SOMenuRow*)menuRowWithTitle:(NSString*)title;
-(SOMenuRow*)menuRowWithItemIdentifier:(JSSlideViewControllerIdentifier)identifier;
-(SOMenuRow*)menuRowAtIndex:(NSUInteger)index;

-(NSUInteger)menuRowIndexForTitle:(NSString*)title;
-(NSUInteger)menuRowIndexForIdentifier:(JSSlideViewControllerIdentifier)identifier;

@end

@implementation SOMenuRow

-(id)initWithMenuSection:(SOMenuSection*)menuSection
{
    self = [super init];
    if (self)
    {
        [self setMenuSection:menuSection];
    }
    return self;
}

@end

@implementation SOMenuSection

-(id)init
{
    self = [super init];
    if (self)
    {
        self.rows = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

-(id)initWithTitle:(NSString*)title
{
    self = [self init];
    if (self)
    {
        self.title = title;
    }
    return self;
}

-(SOMenuRow*)menuRowWithTitle:(NSString*)title
{
    __block SOMenuRow *row = nil;
    [[self rows] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       
        if ([[(SOMenuRow*)obj title] isEqualToString:title])
        {
            row = obj;
            *stop = YES;
        }
    }];
    
    return row;
}

-(SOMenuRow*)menuRowWithItemIdentifier:(JSSlideViewControllerIdentifier)identifier
{
    __block SOMenuRow *row = nil;
    [[self rows] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([[(SOMenuRow*)obj identifier] isEqualToString:identifier])
        {
            row = obj;
            *stop = YES;
        }
    }];
    
    return row;
}

-(NSUInteger)menuRowIndexForTitle:(NSString*)title
{
    __block NSUInteger index = 0;
    
    [[self rows] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([[(SOMenuRow*)obj title] isEqualToString:title])
        {
            index = idx;
            *stop = YES;
        }
    }];

    return index;
}

-(NSUInteger)menuRowIndexForIdentifier:(JSSlideViewControllerIdentifier)identifier
{
    __block NSUInteger index = 0;
    
    [[self rows] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([[(SOMenuRow*)obj identifier] isEqualToString:identifier])
        {
            index = idx;
            *stop = YES;
        }
    }];
    
    return index;
}

-(SOMenuRow*)menuRowAtIndex:(NSUInteger)index
{
    SOMenuRow *row = nil;
    
    if (index < self.rows.count)
    {
        row = [[self rows] objectAtIndex:index];
    }
    
    return row;
}

@end


@interface JSSlideMenuDataSource ()

@property (nonatomic, strong) NSMutableArray *sections;
@end

@implementation JSSlideMenuDataSource

-(id)init
{
    self = [super init];
    if (self)
    {
        self.sections = [[NSMutableArray alloc] initWithCapacity:15];
        self.badgeXOffset = 220.0f;
    }
    return self;
}

-(SOMenuSection*)createSectionForNumber:(NSUInteger)sectionNumber
{
    SOMenuSection *menuSection = nil;
    
    NSUInteger count = self.sections.count;
    for (NSUInteger i = count; i<=sectionNumber; i++)
    {
        menuSection = [[SOMenuSection alloc] init];
        [[self sections] addObject:menuSection];
    }
    
    return menuSection;
}

-(SOMenuSection*)sectionForSectionNumber:(NSUInteger)sectionNumber
{
    SOMenuSection *menuSection = nil;
    
    if (sectionNumber < self.sections.count)
    {
        menuSection = [[self sections] objectAtIndex:sectionNumber];
    }
    else
    {
        menuSection = [self createSectionForNumber:sectionNumber];
    }
    return menuSection;
}

-(SOMenuRow*)menuRowForIndexPath:(NSIndexPath*)indexPath
{
    SOMenuRow *menuRow = nil;
    
    if (indexPath.section < self.sections.count)
    {
        SOMenuSection *menuSection = [self sectionForSectionNumber:indexPath.section];
        if (indexPath.row < menuSection.rows.count)
        {
            menuRow = [menuSection menuRowAtIndex:indexPath.row];
        }
    }
    
    return menuRow;
}

-(SOMenuRow*)menuRowForItemWithIdentifier:(JSSlideViewControllerIdentifier)identifier
{
    __block SOMenuRow *menuRow = nil;
    
    [[self sections] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        SOMenuSection *section = (SOMenuSection*)obj;
        menuRow = [section menuRowWithItemIdentifier:identifier];
        if (menuRow) *stop = YES;
    }];
    
    return menuRow;
}

-(NSIndexPath*)indexPathForTitle:(NSString*)title inSectionNumber:(NSUInteger)sectionNumber
{
    SOMenuSection *section = [self sectionForSectionNumber:sectionNumber];
    NSUInteger row = [section menuRowIndexForTitle:title];
    
    return [NSIndexPath indexPathForRow:row inSection:sectionNumber];
}

-(NSIndexPath*)indexPathForItemWithIdentifier:(JSSlideViewControllerIdentifier)identifier
{
    NSIndexPath *indexPath = nil;
    
    SOMenuRow *menuRow = [self menuRowForItemWithIdentifier:identifier];
    SOMenuSection *menuSection = menuRow.menuSection;
    
    if (menuSection && menuRow)
    {
        indexPath = [NSIndexPath indexPathForRow:[[menuSection rows] indexOfObject:menuRow]
                                       inSection:[[self sections] indexOfObject:menuSection]];
    }
    return indexPath;
}

-(void)createItemWithMenuIdentifier:(JSSlideViewControllerIdentifier)identifier forSection:(NSInteger)sectionNumber withTitle:(NSString*)title
{
    SOMenuSection *menuSection = [self sectionForSectionNumber:sectionNumber];
    NSMutableArray *rows = [menuSection rows];

    SOMenuRow *menuRow = [menuSection menuRowWithTitle:title];
    if (menuRow == nil)
    {
        menuRow = [[SOMenuRow alloc] initWithMenuSection:menuSection];
        [rows addObject:menuRow];

        [menuRow setTitle:title];
        [menuRow setIdentifier:identifier];
    }
}

-(NSIndexPath*)removeItemWithMenuIdentifier:(JSSlideViewControllerIdentifier)identifier;
{
    SOMenuRow *menuRow = [self menuRowForItemWithIdentifier:identifier];
    SOMenuSection *menuSection = [menuRow menuSection];
    
    NSIndexPath *indexPath = [self indexPathForItemWithIdentifier:identifier];
    
    [[menuSection rows] removeObject:menuRow];
    
    return indexPath;
}

-(void)setTitle:(NSString *)title forSectionNumber:(NSUInteger)sectionNumber
{
    SOMenuSection *menuSection = [self sectionForSectionNumber:sectionNumber];
    [menuSection setTitle:title];
}

-(void)setHidden:(BOOL)hidden forTitle:(NSString*)title inSectionNumber:(NSUInteger)sectionNumber
{
    SOMenuSection *menuSection = [self sectionForSectionNumber:sectionNumber];
    SOMenuRow *menuRow = [menuSection menuRowWithTitle:title];
    [menuRow setHidden:hidden];
}

-(BOOL)isRowHiddenForItemWithIndexPath:(NSIndexPath *)indexPath
{
    SOMenuRow *menuRow = [self menuRowForIndexPath:indexPath];
    return menuRow.hidden;
}

-(void)setTitle:(NSString *)title forItemWithIdentifier:(JSSlideViewControllerIdentifier)identifier
{
    SOMenuRow *menuRow = [self menuRowForItemWithIdentifier:identifier];
    [menuRow setTitle:title];
}

-(void)setIcon:(UIImage *)icon forItemWithIdentifier:(JSSlideViewControllerIdentifier)identifier
{
    SOMenuRow *menuRow = [self menuRowForItemWithIdentifier:identifier];
    [menuRow setIcon:icon];
}

-(void)setCustomView:(UIView *)customView preferredHeight:(CGFloat)height forItemWithIdentifier:(JSSlideViewControllerIdentifier)identifier
{
    SOMenuRow *menuRow = [self menuRowForItemWithIdentifier:identifier];
    menuRow.preferredHeightForCustomView = height;
    if (menuRow.customView && customView.superview)
    {
        UIView *cellContentView = menuRow.customView.superview;
        [menuRow.customView removeFromSuperview];
        [cellContentView addSubview:customView];
    }
    
    [menuRow setCustomView:customView];
}

-(void)setMenuItemSelectedBlock:(JSMenuItemSelectedBlock)block forItemWithIdentifier:(JSSlideViewControllerIdentifier)identifier
{
    SOMenuRow *menuRow = [self menuRowForItemWithIdentifier:identifier];
    [menuRow setSelectedBlock:block];
}

-(JSMenuItemSelectedBlock)menuItemSelectedBlockWithIdentifier:(JSSlideViewControllerIdentifier)identifier
{
    SOMenuRow *menuRow = [self menuRowForItemWithIdentifier:identifier];
    return [menuRow selectedBlock];
}

-(JSMenuItemSelectedBlock)menuItemSelectedBlockForItemWithIndexPath:(NSIndexPath*)indexPath
{
    SOMenuRow *menuRow = [self menuRowForIndexPath:indexPath];
    return [menuRow selectedBlock];
}

-(void)setBadgeText:(NSString*)badgeText forItemWithIdentifier:(JSSlideViewControllerIdentifier)identifier
{
    SOMenuRow *menuRow = [self menuRowForItemWithIdentifier:identifier];
    [menuRow setBadgeText:badgeText];
}

-(NSString*)badgeTextForItemWithIdentifier:(JSSlideViewControllerIdentifier)identifier
{
    SOMenuRow *menuRow = [self menuRowForItemWithIdentifier:identifier];
    return menuRow.badgeText;
}

-(void)setHidden:(BOOL)hidden forItemWithIdentifier:(JSSlideViewControllerIdentifier)identifier
{
    SOMenuRow *menuRow = [self menuRowForItemWithIdentifier:identifier];
    [menuRow setHidden:hidden];
}

-(BOOL)isRowHiddenForItemWithIdentifier:(JSSlideViewControllerIdentifier)identifier
{
    SOMenuRow *menuRow = [self menuRowForItemWithIdentifier:identifier];
    return menuRow.hidden;
}

-(JSSlideViewControllerIdentifier)menuIdentifierForItemWithIndexPath:(NSIndexPath*)indexPath
{
    SOMenuRow *menuRow = [self menuRowForIndexPath:indexPath];
    return menuRow.identifier;
}

#pragma mark -

-(CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL hidden = [self isRowHiddenForItemWithIndexPath:indexPath];
    CGFloat height = self.rowHeight;
    SOMenuRow *menuRow = [self menuRowForIndexPath:indexPath];
    if (menuRow.customView)
    {
        height = menuRow.preferredHeightForCustomView;
    }
    
    return hidden ? 0.0 : height;
}

-(CGFloat)heightForSectionNumber:(NSUInteger)sectionNumber
{
    return self.sectionHeight;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SOMenuSection *menuSection = [self sectionForSectionNumber:section];
    return menuSection.rows.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    SOMenuRow *menuRow = [self menuRowForIndexPath:indexPath];
    JSSlideMenuViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:JSSlideMenuTableViewCellReuseIdent forIndexPath:indexPath];
    [[cell textLabel] setTextAlignment:[self menuItemTextAlignment]];
    [[cell textLabel] setBackgroundColor:[UIColor clearColor]];
    [[cell textLabel] setTextColor:cell.isSelected ? [self menuItemSelectedTextColor] : [self menuItemTextColor]];
    [[cell textLabel] setFont:cell.isSelected ? [self menuItemSelectedFont] : [self menuItemFont]];
    [[cell textLabel] setBackgroundColor:[UIColor clearColor]];
    
    [[cell contentView] setBackgroundColor:[UIColor clearColor]];
    if (menuRow.customView)
    {
        [[cell contentView] addSubview:menuRow.customView];
    }
    
    [[cell badgeLabel] setText:menuRow.badgeText];
    [[cell badgeLabel] setLeft:self.badgeXOffset];
    [[cell badgeLabel] setTextColor:self.badgeTextColor];
    [[cell badgeLabel] setBackgroundColor:self.badgeBackgroundColor];
    [[cell badgeLabel] setFont:self.badgeFont];
    [cell setBadgeLabelBackgroundColor:self.badgeBackgroundColor];
    
    if (self.menuItemBackgroundView)
    {
        [cell setBackgroundView:self.menuItemBackgroundView];
    }
    else if (self.menuItemBackgroundImage)
    {
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:self.menuItemBackgroundImage]];
    }
    else if (self.menuItemBackgroundColor)
    {
        [[cell contentView] setBackgroundColor:self.menuItemBackgroundColor];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    [[cell textLabel] setText:menuRow.title];
    [[cell imageView] setImage:menuRow.icon];
    

    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    SOMenuSection *menuSection = [self sectionForSectionNumber:section];
    return menuSection.title;
}



@end
