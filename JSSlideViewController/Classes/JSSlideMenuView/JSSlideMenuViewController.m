//
//  JSSlideMenuViewController.m
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

#import <CoreGraphics/CoreGraphics.h>
#import "JSSlideViewController.h"
#import "JSUtilities.h"
#import "JSRectUtils.h"
#import "UIView+Frame.h"
#import "UIView+Center.h"

#import "JSSlideMenuViewController.h"
#import "JSSlideViewButton.h"
#import "JSDraggableSlideView.h"
#import "JSSlideMenuDataSource.h"
#import "JSSlideMenuViewCell.h"
#import "UIView+Easing.h"

#import "JSSlideMenuViewController.h"

#define kSlideMenuViewSectionHeight (34.0f)
#define kSlideMenuViewTitleHeight (44.0f)

@interface JSSlideMenuViewController () <UITableViewDelegate>

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *titleBackgroundView;
@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong, readwrite) UIViewController *currentViewController;

@property (nonatomic, strong) JSSlideMenuDataSource *dataSource;

@end

@implementation JSSlideMenuViewController

-(void)setup
{
    self.dataSource = [[JSSlideMenuDataSource alloc] init];
    
    self.menuItemTextColor = [UIColor darkGrayColor];
    self.menuItemTextAlignment = NSTextAlignmentLeft;
    self.menuItemFont = [UIFont fontWithName:@"HelveticaBold" size:14.0f];
    self.menuItemBackgroundColor = [UIColor grayColor];
    
    self.separatorColor = [UIColor clearColor];
    
    self.menuSectionTextColor = [UIColor grayColor];
    self.menuSectionTextAlignment = NSTextAlignmentLeft;
    self.menuSectionFont = [UIFont fontWithName:@"HelveticaBold" size:15.0f];
    self.menuSectionBackgroundColor = [UIColor lightGrayColor];
    
    self.badgeTextColor = [UIColor whiteColor];
    self.badgeBackgroundColor = [UIColor redColor];
    self.badgeFont = [UIFont fontWithName:@"Helvetica" size:10.0f];
    
    self.rowHeight = 60.0f;
    self.sectionHeight = kSlideMenuViewSectionHeight;
    
    self.showTitleView = NO;

}

-(id)init
{
    self = [super init];
    if (self)
    {
        [self setup];
    }
    
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.backgroundImage)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:self.backgroundImage];
        [imageView setClipsToBounds:YES];
        [imageView setContentMode:UIViewContentModeCenter];
        [self.view addSubview:imageView];
        self.backgroundView = imageView;
    }
    else
    {
        [self.view setBackgroundColor:self.backgroundColor];
    }

    if (self.titleBackgroundImage)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:self.titleBackgroundImage];
        [imageView setClipsToBounds:YES];
        [imageView setContentMode:UIViewContentModeCenter];
        [self.view addSubview:imageView];
        self.titleBackgroundView = imageView;
    }
    else
    {
        UIView *backgroundView = [[UIView alloc] init];
        [self.view addSubview:backgroundView];
        self.titleBackgroundView = backgroundView;
    }
        
    self.titleLabel = [[UILabel alloc] init];
    [[self titleLabel] setBackgroundColor:[UIColor clearColor]];
    [[self titleLabel] setText:@"Menu"];
    [[self titleLabel] setTextColor:[UIColor blackColor]];
    [[self titleLabel] setTextAlignment:NSTextAlignmentLeft];
    [[self titleLabel] setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [[self titleLabel] setUserInteractionEnabled:YES];
    [[self titleBackgroundView] addSubview:[self titleLabel]];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [[self tableView] setDelegate:self];
    [[self tableView] setDataSource:[self dataSource]];
    [[self tableView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [[self tableView] setSeparatorColor:self.separatorColor];
    [[self tableView] setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:[self tableView]];
    
    [[self tableView] registerClass:[JSSlideMenuViewCell class] forCellReuseIdentifier:JSSlideMenuTableViewCellReuseIdent];
        
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.currentViewController == nil)
    {
        [self selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    
    [[self tableView] setScrollEnabled:(self.tableView.contentSize.height > self.tableView.height)];
 }

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];    

    CGFloat top = 20.0f;
    
    [[self titleBackgroundView] setFrame:CGRectWithNewHeight(self.view.bounds, self.showTitleView ? kSlideMenuViewTitleHeight : 0.0f)];
    [[self titleBackgroundView] setFrameY:top];
    [[self tableView] setFrame:CGRectWithNewHeight(self.view.bounds, self.view.height - self.titleBackgroundView.bottom)];
    [[self tableView] setTop:self.titleBackgroundView.bottom];

    [[self titleLabel] setFrameHeight:self.titleBackgroundView.height];
    [[self titleLabel] setFrameWidth:self.titleBackgroundView.width - 20.0f];
    [[self titleLabel] centerView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

#pragma mark -

-(void)setTitleBackgroundColor:(UIColor *)titleBackgroundColor
{
    _titleBackgroundColor = titleBackgroundColor;
    [[self titleBackgroundView] setBackgroundColor:titleBackgroundColor];
}

-(void)setMenuItemTextColor:(UIColor*)menuItemTextColor
{
    [[self dataSource] setMenuItemTextColor:menuItemTextColor];
}

-(UIColor*)menuItemTextColor
{
    return self.dataSource.menuItemTextColor;
}

-(void)setMenuItemTextAlignment:(NSTextAlignment)menuItemTextAlignment
{
    [[self dataSource] setMenuItemTextAlignment:menuItemTextAlignment];
}

-(NSTextAlignment)menuItemTextAlignment
{
    return self.dataSource.menuItemTextAlignment;
}

-(void)setMenuItemFont:(UIFont *)menuItemFont
{
    [[self dataSource] setMenuItemFont:menuItemFont];
}

-(UIFont*)menuItemFont
{
    return self.dataSource.menuItemFont;
}

-(void)setMenuItemSelectedTextColor:(UIColor*)menuItemSelectedTextColor
{
    [[self dataSource] setMenuItemSelectedTextColor:menuItemSelectedTextColor];
}

-(UIColor*)menuItemSelectedTextColor
{
    return self.dataSource.menuItemSelectedTextColor;
}

-(void)setMenuItemSelectedFont:(UIFont*)menuItemSelectedFont
{
    [[self dataSource] setMenuItemSelectedFont:menuItemSelectedFont];
}

-(UIFont*)menuItemSelectedFont
{
    return self.dataSource.menuItemSelectedFont;
}

-(void)setMenuItemBackgroundColor:(UIColor*)menuItemBackgroundColor
{
    [[self dataSource] setMenuItemBackgroundColor:menuItemBackgroundColor];
}

-(UIColor*)menuItemBackgroundColor
{
    return self.dataSource.menuItemBackgroundColor;
}

-(void)setMenuItemBackgroundImage:(UIImage*)menuItemBackgroundImage
{
    [[self dataSource] setMenuItemBackgroundImage:menuItemBackgroundImage];
}

-(UIImage*)menuItemBackgroundImage
{
    return self.dataSource.menuItemBackgroundImage;
}

-(void)setMenuItemBackgroundView:(UIView*)backgroundView
{
    [[self dataSource] setMenuItemBackgroundView:backgroundView];
}

-(UIView*)menuItemBackgroundView
{
    return self.dataSource.menuItemBackgroundView;
}

-(void)setBadgeTextColor:(UIColor *)badgeTextColor
{
    [[self dataSource] setBadgeTextColor:badgeTextColor];
}

-(UIColor*)badgeTextColor
{
    return self.dataSource.badgeTextColor;
}

-(void)setBadgeBackgroundColor:(UIColor *)badgeBackgroundColor
{
    [[self dataSource] setBadgeBackgroundColor:badgeBackgroundColor];
}

-(UIColor*)badgeBackgroundColor
{
    return self.dataSource.badgeBackgroundColor;
}

-(void)setBadgeFont:(UIFont *)badgeFont
{
    [[self dataSource] setBadgeFont:badgeFont];
}

-(UIFont*)badgeFont
{
    return self.dataSource.badgeFont;
}

-(void)setBadgeXOffset:(CGFloat)badgeXOffset
{
    [[self dataSource] setBadgeXOffset:badgeXOffset];
}

-(CGFloat)badgeXOffset
{
    return self.dataSource.badgeXOffset;
}

-(void)setRowHeight:(CGFloat)rowHeight
{
    [[self dataSource] setRowHeight:rowHeight];
}

-(void)setSectionHeight:(CGFloat)sectionHeight
{
    [[self dataSource] setSectionHeight:sectionHeight];
}

#pragma mark -

-(void)setSeparatorColor:(UIColor *)separatorColor
{
    _separatorColor = separatorColor;
    [[self tableView] setSeparatorColor:_separatorColor];
}

#pragma mark -

-(void)createItemWithMenuIdentifier:(JSSlideViewControllerIdentifier)identifier forSection:(NSInteger)sectionNumber withTitle:(NSString*)title
{
    [[self dataSource] createItemWithMenuIdentifier:identifier forSection:sectionNumber withTitle:title];
}

-(void)removeItemWithMenuIdentifier:(JSSlideViewControllerIdentifier)identifier
{
    [[self dataSource] removeItemWithMenuIdentifier:identifier];
}

-(void)setTitle:(NSString*)title forItemWithIdentifier:(JSSlideViewControllerIdentifier)identifier
{
    NSIndexPath *indexPath = [[self dataSource] indexPathForItemWithIdentifier:identifier];
    [[self dataSource] setTitle:title forItemWithIdentifier:identifier];
    
    [[self tableView] beginUpdates];
    [[self tableView] reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [[self tableView] endUpdates];
}

-(void)setIcon:(UIImage*)icon forItemWithIdentifier:(JSSlideViewControllerIdentifier)identifier
{
    NSIndexPath *indexPath = [[self dataSource] indexPathForItemWithIdentifier:identifier];
    [[self dataSource] setIcon:icon forItemWithIdentifier:identifier];
    
    [[self tableView] beginUpdates];
    [[self tableView] reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [[self tableView] endUpdates];
}

-(void)setBadgeText:(NSString*)badgeText forItemWithIdentifier:(JSSlideViewControllerIdentifier)identifier
{
    NSIndexPath *indexPath = [[self dataSource] indexPathForItemWithIdentifier:identifier];
    
    if ([[[self dataSource] badgeTextForItemWithIdentifier:identifier] isEqualToString:badgeText] == NO)
    {
        [[self dataSource] setBadgeText:badgeText forItemWithIdentifier:identifier];
        
        [[self tableView] beginUpdates];
        [[self tableView] reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [[self tableView] endUpdates];
    }
}

-(void)setCustomView:(UIView *)customView preferredHeight:(CGFloat)height forItemWithIdentifier:(JSSlideViewControllerIdentifier)identifier
{
    NSIndexPath *indexPath = [[self dataSource] indexPathForItemWithIdentifier:identifier];
    [[self dataSource] setCustomView:customView preferredHeight:height forItemWithIdentifier:identifier];
    
    [[self tableView] beginUpdates];
    [[self tableView] reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [[self tableView] endUpdates];    
}

-(void)setHidden:(BOOL)hidden forItemWithIdentifier:(JSSlideViewControllerIdentifier)identifier
{
    NSIndexPath *indexPath = [[self dataSource] indexPathForItemWithIdentifier:identifier];
    if ([[self dataSource] isRowHiddenForItemWithIdentifier:identifier] != hidden)
    {
        [[self dataSource] setHidden:hidden forItemWithIdentifier:identifier];
        
        [[self tableView] beginUpdates];
        [[self tableView] reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:hidden ? UITableViewRowAnimationTop : UITableViewRowAnimationBottom];
        [[self tableView] endUpdates];
    }
}

-(void)setMenuItemSelectedBlock:(JSMenuItemSelectedBlock)block forItemWithIdentifier:(JSSlideViewControllerIdentifier)identifer
{
    [[self dataSource] setMenuItemSelectedBlock:block forItemWithIdentifier:identifer];
}

-(void)setSectionTitle:(NSString *)title forSection:(NSInteger)sectionNumber
{
    NSIndexPath *indexPath = [[self dataSource] indexPathForTitle:title inSectionNumber:sectionNumber];
    [[self dataSource] setTitle:title forSectionNumber:sectionNumber];
    
    [[self tableView] beginUpdates];
    [[self tableView] reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [[self tableView] endUpdates];
}

-(void)selectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [[self tableView] selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    JSSlideMenuViewCell *cell = (JSSlideMenuViewCell*)[[self tableView] cellForRowAtIndexPath:indexPath];
    
    [[cell contentView] setBackgroundColor:[UIColor clearColor]];
    
    [cell setSelected:YES animated:YES];
    
    [[cell textLabel] setTextColor:self.dataSource.menuItemSelectedTextColor];
    [[cell textLabel] setFont:self.dataSource.menuItemSelectedFont];
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSSlideMenuViewCell *cell = (JSSlideMenuViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    [[cell textLabel] setTextColor:self.dataSource.menuItemSelectedTextColor];
    [[cell textLabel] setFont:self.dataSource.menuItemSelectedFont];

    
    JSSlideViewControllerIdentifier identifier = [[self dataSource] menuIdentifierForItemWithIndexPath:indexPath];
    JSMenuItemSelectedBlock selectedBlock = [[self dataSource] menuItemSelectedBlockWithIdentifier:identifier];
    if (selectedBlock)
    {
        selectedBlock( identifier);
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSSlideMenuViewCell *cell = (JSSlideMenuViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if (self.menuItemBackgroundColor)
    {
        [[cell contentView] setBackgroundColor:self.menuItemBackgroundColor];
    }
    
    [[cell textLabel] setTextColor:self.dataSource.menuItemTextColor];
    [[cell textLabel] setFont:self.dataSource.menuItemFont];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self dataSource] heightForRowAtIndexPath:indexPath];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = nil;
    
    NSString *title = [[self dataSource] tableView:tableView titleForHeaderInSection:section];
    CGFloat headerHeight = [[self dataSource] heightForSectionNumber:section];
    
    if (title)
    {
        if (self.menuSectionBackgroundImage)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:self.menuItemBackgroundImage];
            [imageView setClipsToBounds:YES];
            [imageView setFrame:CGRectWithNewHeight( tableView.bounds, headerHeight)];
            [imageView setContentMode:UIViewContentModeCenter];
            sectionHeaderView = imageView;
        }
        else
        {
            UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectWithNewHeight( tableView.bounds, headerHeight)];
            [backgroundView setBackgroundColor:self.menuSectionBackgroundColor];
            sectionHeaderView = backgroundView;
        }
        
        
        UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, tableView.width - 20.0f, headerHeight)];
        [sectionLabel setBackgroundColor:[UIColor clearColor]];
        [sectionLabel setTextColor:self.menuSectionTextColor];
        [sectionLabel setTextAlignment:self.menuSectionTextAlignment];
        [sectionLabel setText:title];
        [sectionLabel setFont:self.menuSectionFont];
        [sectionHeaderView addSubview:sectionLabel];
        [sectionLabel centerView];
    }
    return sectionHeaderView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString *title = [[self dataSource] tableView:tableView titleForHeaderInSection:section];
    
    CGFloat height = [[self dataSource] heightForSectionNumber:section];
    
    return title ? height : 0.0f;
}

@end
