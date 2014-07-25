//
//  NotificationsController.m
//  Repeaters1
//
//  Created by Ransom Barber on 9/14/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import "NotificationsController.h"

@interface NotificationsController ()

@property (strong, nonatomic) DateBrain *dateBrain;
@property (strong, nonatomic) NSDateFormatter *formatter;

@end

@implementation NotificationsController

@synthesize formatter = _formatter;
@synthesize dateBrain = _dateBrain;

- (id)init
{
    if (self = [super init])
    {
        // Initialization code here
        self.dateBrain = [[DateBrain alloc] init];
        self.formatter = [[NSDateFormatter alloc] init]; //[self.formatter stringFromDate:date]
        [self.formatter setDateStyle:NSDateFormatterMediumStyle];
        [self.formatter setTimeStyle:NSDateFormatterNoStyle];
        
    }
    return self;
}

- (void)cancelNotificationWithName:(Deadline *)deadline
{
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    NSArray *notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    DebugLog(@"cancelNotificationWithName: notificationArray has a count of %d", [notificationArray count]);
    for (UILocalNotification *notifier in notificationArray)
    {
        NSString *deadlineName = [notifier.userInfo objectForKey:@"deadlineName"];
        //NSDate *deadlineNext = [notifier.userInfo objectForKey:@"next"];
        DebugLog(@"cancelNotificationWithName: notificationArray userinfo deadlineName = %@", deadlineName);
        
        if ([deadlineName isEqualToString:deadline.whichReminder.name]) {
            DebugLog(@"cancelNotificationWithName: Notifier name in notificationArray, so will cancel notifier.");
            
            [[UIApplication sharedApplication] cancelLocalNotification:notifier];
        }
    }
}


- (BOOL)checkNotificationWithName:(Deadline *)deadline
{
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    NSDate *now = [NSDate date];
    NSDate *check = [deadline.next earlierDate:now];
    if ([check isEqualToDate:deadline.next]) {
        DebugLog(@"checkNotificationWithName: past deadline so returning TRUE");
        return TRUE;
    }
    
    NSArray *notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    DebugLog(@"checkNotificationWithName: notificationArray has a count of %d", [notificationArray count]);
    for (UILocalNotification *notifier in notificationArray)
    {
        NSString *deadlineName = [notifier.userInfo objectForKey:@"deadlineName"];
        NSDate *deadlineNext = [notifier.userInfo objectForKey:@"next"];
        DebugLog(@"checkNotificationWithName: notificationArray userinfo deadlineName = %@", deadlineName);
        
        if ([deadlineName isEqualToString:deadline.whichReminder.name]) {
            if ([deadlineNext isEqualToDate:deadline.next]) {
                DebugLog(@"checkNotificationWithName: Notifier name and time already in notificationArray so will not cancel notifier.");
                return TRUE;
            } else {
                DebugLog(@"checkNotificationWithName: Notifier name already in notificationArray, but time is different so will cancel notifier.");
                
                [[UIApplication sharedApplication] cancelLocalNotification:notifier];
                return FALSE;
            }
        }
    }
    return FALSE;
}

- (NSDate *)checkNotifier:(Deadline *)deadline
{
    NSDate *fireDate = nil;
    NSNumber *notifyNum = deadline.notifyNumber;
    DebugLog(@"notifyNum = %@", notifyNum);
    switch ([notifyNum integerValue]) {
        case 0:
            fireDate = nil;
            break;
        case 1:
            fireDate = deadline.next;
            break;
        case 2:
            fireDate = [deadline.next dateByAddingTimeInterval:-(60*5)];
            break;
        case 3:
            fireDate = [deadline.next dateByAddingTimeInterval:-(60*15)];
            break;
        case 4:
            fireDate = [deadline.next dateByAddingTimeInterval:-(60*30)];
            break;
        case 5:
            fireDate = [deadline.next dateByAddingTimeInterval:-(60*60)];
            break;
            
        default:
            break;
    }
    
    return fireDate;
}

- (void)checkNotifierNames:(NSMutableArray *)nameArray
{
    NSArray *notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    DebugLog(@"checkNotifierNames: nameArray has a count of %d", [nameArray count]);
    DebugLog(@"checkNotifierNames: at first, notificationArray has a count of %d", [notificationArray count]);
    
    if ([nameArray count] == [notificationArray count]) {
        return;
    }
    
    for (UILocalNotification *notifier in notificationArray)
    {
        NSString *deadlineName = [notifier.userInfo objectForKey:@"deadlineName"];
        
        for (NSString *name in nameArray)
        {
            if ([name isEqualToString:deadlineName]) {
                break;
            }
        }
        [[UIApplication sharedApplication] cancelLocalNotification:notifier];
    }
    
    DebugLog(@"checkNotifierNames: after checking, notificationArray has a count of %d", [notificationArray count]);
}

- (void)scheduleNotifications:(Deadline *)deadline
{
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    
    NSDate *notifyDate = [[NSDate alloc] init];
    notifyDate = [self checkNotifier:deadline];
    
    DebugLog(@"scheduleNotifications: deadline.next = %@, time = %@", [self.formatter stringFromDate:deadline.next],  [FormatController formatTimeFromDeadline:deadline.next]);
    DebugLog(@"scheduleNotifications: NotifyDate = %@, time = %@", [self.formatter stringFromDate:notifyDate], [FormatController formatTimeFromDeadline:notifyDate]);
    
    if (notifyDate) {
        BOOL notifierCheck = [self checkNotificationWithName:deadline];
        NSString *deadlineName = NSLocalizedString(@"Deadline", @"deadline name and time alert body");
        if (!notifierCheck) {
            localNotif.fireDate = notifyDate;
            localNotif.timeZone = [NSTimeZone defaultTimeZone];
            localNotif.alertBody = [NSString stringWithFormat:@"%@: %@ at %@", deadlineName, deadline.whichReminder.name, [self.formatter stringFromDate:deadline.next]];
            localNotif.soundName = UILocalNotificationDefaultSoundName;
            
            NSMutableDictionary *infoDict = [NSMutableDictionary dictionaryWithCapacity:2];
            [infoDict setObject:deadline.whichReminder.name forKey:@"deadlineName"];
            [infoDict setObject:deadline.notify forKey:@"notifier"];
            [infoDict setObject:deadline.next forKey:@"next"];
            localNotif.userInfo = infoDict;
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
            DebugLog(@"scheduleNotifications: notification scheduled for %@", [infoDict objectForKey:@"deadlineName"]);
        }
    } else return;
}

@end
