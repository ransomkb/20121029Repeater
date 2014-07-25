//
//  DetailNavigationViewController.m
//  Repeaters1
//
//  Created by Ransom Barber on 10/18/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import "DetailNavigationViewController.h"
#import "RepeatersNavigationItem.h"

@interface DetailNavigationViewController ()

@end

@implementation DetailNavigationViewController

@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize navBar = _navBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.navigationController setToolbarHidden:NO];
    }
    return self;
}


- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    DebugLog(@"leftBarButtonItem 1 = %@", [self.navigationItem leftBarButtonItem]);
    if (_splitViewBarButtonItem != splitViewBarButtonItem) {
        NSMutableArray *navBarItems = [self.navBar.items mutableCopy];
        RepeatersNavigationItem *rNavItem = [navBarItems objectAtIndex:0];
        DebugLog(@"navBarItems objectAtIndex:0 = %@", rNavItem);
        if (_splitViewBarButtonItem) { // maybe this will work. different from hagerty:s
            DebugLog(@"already set leftBarButtonItem  = %@", [rNavItem leftBarButtonItem]);
            [rNavItem setLeftBarButtonItem:nil animated:YES];
            DebugLog(@"next leftBarButtonItem  = %@", [rNavItem leftBarButtonItem]);
        }
        if (splitViewBarButtonItem) {
            DebugLog(@"first time setting leftBarButtonItem = %@", [rNavItem leftBarButtonItem]);
            [rNavItem setLeftBarButtonItem:splitViewBarButtonItem animated:YES];
            DebugLog(@"next leftBarButtonItem  = %@", [rNavItem leftBarButtonItem]);
        }
        
        [navBarItems insertObject:rNavItem atIndex:0];
        _splitViewBarButtonItem = splitViewBarButtonItem;
        DebugLog(@"final leftBarButtonItem after setting = %@", [rNavItem leftBarButtonItem]);
        DebugLog(@"final navBarItems objectAtIndex:0 = %@", [navBarItems objectAtIndex:0]);
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setNavBar:nil];
    [super viewDidUnload];
}
@end
