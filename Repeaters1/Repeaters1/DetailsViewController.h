//
//  RepeatersViewController.h
//  Repeaters1
//
//  Created by Barber Ransom on 7/23/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormatController.h"
#import "Deadline+Settings.h"
#import "Repeater+Settings.h"

@class DetailsViewController;

@protocol DetailsViewControllerDelegate <NSObject>
- (void)dismissPopover;
@end

@interface DetailsViewController : UIViewController <UIActionSheetDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) UIManagedDocument *repeaterDatabase;
@property (strong, nonatomic) Deadline *deadline;

@property (strong, nonatomic) UIPopoverController *myPopover;
@property (weak, nonatomic) id <DetailsViewControllerDelegate> delegate;

- (IBAction)showActionSheet:(id)sender;
- (void)deleteRepeater;

@end
