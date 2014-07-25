//
//  RepeatersViewController.h
//  Repeaters1
//
//  Created by Ransom Barber on 7/27/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "AddRepeaterViewController.h"
#import "DetailsViewController.h"
#import "SplitViewBarButtonItemPresenter.h"


@interface RepeatersTableViewController : CoreDataTableViewController <UIGestureRecognizerDelegate, UIPopoverControllerDelegate, AddRepeaterViewControllerDelegate, DetailsViewControllerDelegate, SplitViewBarButtonItemPresenter>

@property (nonatomic, strong) UIManagedDocument *repeaterDatabase;
@property (nonatomic, strong) NSDictionary *settingsInfo;
@property (nonatomic, strong) UIPopoverController *myPopoverController;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *leftBarButton;

@end
