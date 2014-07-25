//
//  NotificationsController.h
//  Repeaters1
//
//  Created by Ransom Barber on 9/14/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormatController.h"
#import "DateBrain.h"
#import "Deadline.h"

@interface NotificationsController : NSObject

- (BOOL)checkNotificationWithName:(Deadline *)deadline;

- (NSDate *)checkNotifier:(Deadline *)deadline;

- (void)checkNotifierNames:(NSMutableArray *)nameArray;
- (void)cancelNotificationWithName:(Deadline *)deadline;
- (void)scheduleNotifications:(Deadline *)deadline;

@end
