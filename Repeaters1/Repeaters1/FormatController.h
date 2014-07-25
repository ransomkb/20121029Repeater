//
//  FormatController.h
//  Repeaters1
//
//  Created by Ransom Barber on 8/17/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deadline.h"

@interface FormatController : NSObject

@property (strong, nonatomic) NSDateFormatter *formatter;

+ (NSDate *)formatDefaultHour:(NSNumber *)hour
                    andMinute:(NSNumber *)minute;

+ (NSString *)formatOrdinal:(NSString *)ordinal
                     andDay:(NSString *)day
                    andTime:(NSString *)time;
+ (NSString *)formatOrdinal:(NSString *)ordinal
                     andDay:(NSString *)day
                    andTime:(NSString *)time
                andNotifier:(NSString *)notifier;
+ (NSString *)formatOrdinal:(NSString *)ordinal
                     andDay:(NSString *)day;
+ (NSString *)formatAlertWithOrdinal:(NSString *)ordinal
                              andDay:(NSString *)day;
+ (NSString *)formatTimeLabel:(NSString *)time;
+ (NSString *)formatNotifierLabel:(NSString *)notifier;
+ (NSString *)formatTimeFromDeadline:(NSDate *)deadline;
+ (NSString *)dayString:(NSNumber *)dayNumber;
+ (NSString *)ordinalString:(NSNumber *)ordinalNumber;
+ (NSString *)notifierString:(NSNumber *)notifierNumber;

+ (NSMutableArray *)setOrdinalArray;

+ (NSNumber *)formatHourFromDeadline:(NSDate *)deadline;
+ (NSNumber *)formatMinuteFromDeadline:(NSDate *)deadline;

@end
