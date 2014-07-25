//
//  DayViewController.h
//  Repeaters1
//
//  Created by Ransom Barber on 7/27/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormatController.h"

@class DayViewController;

@protocol DayViewControllerDelegate <NSObject>
- (void)dayViewController:(DayViewController *)sender
            didGetOrdinal:(NSString *)ordinal
                andDidGetDay:(NSString *)dayOfWeek;
- (void)dismissPopover;
@end

@interface DayViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSString *ordinal;
@property (strong, nonatomic) NSString *dayOfWeek;
@property (nonatomic, copy) NSString *daySetting;
@property (nonatomic, weak) id <DayViewControllerDelegate> delegate;

@end
