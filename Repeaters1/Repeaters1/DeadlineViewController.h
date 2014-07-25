//
//  DeadlineViewController.h
//  Repeaters1
//
//  Created by Ransom Barber on 7/27/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormatController.h"

@class DeadlineViewController;

@protocol DeadlineViewControllerDelegate <NSObject>
- (void)deadlineViewController:(DeadlineViewController *)sender
                didGetDeadline:(NSDate *)deadline;
- (void)dismissPopover;
@end

@interface DeadlineViewController : UIViewController // no need for a datepickerdelegate set here
@property (nonatomic, strong) NSDate *deadline;
@property (nonatomic, strong) NSNumber *hour;
@property (nonatomic, strong) NSNumber *minute;
@property (nonatomic, weak) id <DeadlineViewControllerDelegate> delegate;
@end
