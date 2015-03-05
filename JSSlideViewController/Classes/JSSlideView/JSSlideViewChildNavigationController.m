//
//  JSSlideViewChildNavigationController.m
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

#import "JSSlideViewChildNavigationController.h"
#import "JSSlideViewController.h"

@interface JSSlideViewChildNavigationController ()

@property (nonatomic, strong) UIBarButtonItem *slideViewBarButton;

@end

@implementation JSSlideViewChildNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([[self slideViewController] leftViewController] &&
        self.slideViewButtonForLeftReveal == nil)
    {
        self.slideViewButtonForLeftReveal = [JSSlideViewButton slideViewButtonForLeftReveal];
    }
    
    if ([[self slideViewController] rightViewController] &&
        self.slideViewButtonForRightReveal == nil)
    {
        self.slideViewButtonForRightReveal = [JSSlideViewButton slideViewButtonForRightReveal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setSlideViewButtonForLeftReveal:(JSSlideViewButton *)slideViewButtonForLeftReveal
{
    _slideViewButtonForLeftReveal = slideViewButtonForLeftReveal;
    
    NSMutableArray *barButtonItems = [NSMutableArray arrayWithArray:self.topViewController.navigationItem.leftBarButtonItems];
    if (barButtonItems &&
        [barButtonItems containsObject:self.slideViewBarButton] == NO)
    {
        self.slideViewBarButton = [[UIBarButtonItem alloc] initWithCustomView:_slideViewButtonForLeftReveal];
        [barButtonItems insertObject:self.slideViewBarButton atIndex:0];
        
        [[[self topViewController] navigationItem] setLeftBarButtonItems:barButtonItems];
        
        JSSlideViewController *slideViewController = [self slideViewController];
        if (slideViewController)
        {
            [slideViewButtonForLeftReveal setSlideViewController:slideViewController];
        }
    }
}

-(void)setSlideViewButtonForRightReveal:(JSSlideViewButton *)slideViewButtonForRightReveal
{
    _slideViewButtonForRightReveal = slideViewButtonForRightReveal;
    
    NSMutableArray *barButtonItems = [NSMutableArray arrayWithArray:self.topViewController.navigationItem.rightBarButtonItems];
    if (barButtonItems &&
        [barButtonItems containsObject:self.slideViewBarButton] == NO)
    {
        self.slideViewBarButton = [[UIBarButtonItem alloc] initWithCustomView:slideViewButtonForRightReveal];
        [barButtonItems addObject:self.slideViewBarButton];
        
        [[[self topViewController] navigationItem] setRightBarButtonItems:barButtonItems];
        
        JSSlideViewController *slideViewController = [self slideViewController];
        if (slideViewController)
        {
            [slideViewButtonForRightReveal setSlideViewController:slideViewController];
        }
    }
}

@end
