//
//  AboutRepeatersViewController.m
//  Repeaters1
//
//  Created by Ransom Barber on 9/4/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import "AboutRepeatersViewController.h"

@interface AboutRepeatersViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *aboutScroll;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;

@end

@implementation AboutRepeatersViewController
@synthesize aboutScroll;
@synthesize aboutLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setAboutScroll:nil];
    [self setAboutLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
