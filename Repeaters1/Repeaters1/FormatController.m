//
//  FormatController.m
//  Repeaters1
//
//  Created by Ransom Barber on 8/17/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import "FormatController.h"

@implementation FormatController

@synthesize formatter = _formatter;

- (id)init
{
    if (self = [super init])
    {
        // Initialization code here
        
    }
    return self;
}

+ (NSString *)formatOrdinal:(NSString *)ordinal
                     andDay:(NSString *)day
                    andTime:(NSString *)time
{
    return [NSString stringWithFormat:NSLocalizedString(@"Every %@ %@ at %@", @"Formatting Label showing Deadline ordinal, day and time"), ordinal, day, time];
}

+ (NSString *)formatOrdinal:(NSString *)ordinal
                     andDay:(NSString *)day
                    andTime:(NSString *)time
                andNotifier:(NSString *)notifier
{
    return [NSString stringWithFormat:NSLocalizedString(@"Repeats every %@ %@ in a month at %@. Notifier: %@", @"Formatting Repeating Ordinal, Day and Time in a month with a Notifier"), ordinal, day, time, notifier];
}

+ (NSString *)formatOrdinal:(NSString *)ordinal
                     andDay:(NSString *)day
{
    NSString *label = [NSString stringWithFormat:NSLocalizedString(@"Repeats every %@ %@", @"Formatting Repeats every Ordinal Day"), ordinal, day];
    DebugLog(@"Formatter: Day set to: %@", label);
    
    return label;
}

+ (NSString *)formatAlertWithOrdinal:(NSString *)ordinal
                              andDay:(NSString *)day
{
    NSString *ordinalAlert = [NSString stringWithFormat:NSLocalizedString(@"Every %@ %@ is not possible.", @"Formatting Day Alert with Ordinal and Day"), ordinal, day];
    return ordinalAlert;
}

+ (NSString *)formatTimeFromDeadline:(NSDate *)deadlineTime
{
    if (deadlineTime) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        NSString *deadlineString = [formatter stringFromDate:deadlineTime];
        DebugLog(@"formatTime: deadline = %@", deadlineString);
        
        return deadlineString;
    } else {
        return @"17:00";
    }
}

+ (NSNumber *)formatHourFromDeadline:(NSDate *)deadlineTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH"];
    NSString *formattedDeadline = [formatter stringFromDate:deadlineTime];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterNoStyle];
    NSNumber *hour = [f numberFromString:formattedDeadline];
    DebugLog(@"formatHour: self.hour = %@", hour);
    return hour;
}

+ (NSNumber *)formatMinuteFromDeadline:(NSDate *)deadlineTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm"];
    NSString *formattedDeadline = [formatter stringFromDate:deadlineTime];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterNoStyle];
    NSNumber *minute = [f numberFromString:formattedDeadline];
    DebugLog(@"formatMinute: self.minute = %@", minute);
    return minute;
}

+ (NSDate *)formatDefaultHour:(NSNumber *)hour
                    andMinute:(NSNumber *)minute
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setHour:[hour integerValue]];
    DebugLog(@"comps hour = %d", [comps hour]);
    [comps setMinute:[minute integerValue]];
    
    NSCalendar *usersCalendar = [[NSLocale currentLocale] objectForKey:NSLocaleCalendar];
    NSDate *date = [usersCalendar dateFromComponents:comps];
    
    DebugLog(@"formatDefaultHour: deadlineSetting will be set to date = %@", [self formatTimeFromDeadline:date]);
    return date;
}

+ (NSString *)formatTimeLabel:(NSString *)time
{
    return [NSString stringWithFormat:NSLocalizedString(@"At %@", @"Formatting Time Label"), time];
}

+ (NSString *)formatNotifierLabel:(NSString *)notifier
{
    NSString *notifyMe = NSLocalizedString(@"Notify me", @"notify me: notifier message");
    return [NSString stringWithFormat:@"%@: %@", notifyMe, notifier];
}

+ (NSString *)dayString:(NSNumber *)dayNumber
{
    DebugLog(@"dayNumber = %@", dayNumber);
    
    NSString *dayString = NSLocalizedString(@"day", @"picker day");
    
    switch ([dayNumber integerValue]) {
        case 0:
            //dayString = NSLocalizedString(@"day", @"picker day");
            break;
        case 1:
            dayString = NSLocalizedString(@"Sunday", @"picker sunday");
            break;
        case 2:
            dayString = NSLocalizedString(@"Monday", @"picker monday");
            break;
        case 3:
            dayString = NSLocalizedString(@"Tuesday", @"picker tuesday");
            break;
        case 4:
            dayString = NSLocalizedString(@"Wednesday", @"picker wednesday");
            break;
        case 5:
            dayString = NSLocalizedString(@"Thursday", @"picker thursday");
            break;
        case 6:
            dayString = NSLocalizedString(@"Friday", @"picker friday");
            break;
        case 7:
            dayString = NSLocalizedString(@"Saturday", @"picker saturday");
            break;
            
        default:
            break;
    }
    
    DebugLog(@"dayString = %@", dayString);
    return dayString;
}

+ (NSString *)ordinalString:(NSNumber *)ordinalNumber
{
    DebugLog(@"ordinalNumber = %@", ordinalNumber);
    
    NSString *ordinalString = @"";
    int i = [ordinalNumber integerValue];
    
    if (i == 0)
    {
        NSString *none = @"";
        ordinalString = none;
    }
    else if(i == 1 || i == 21 || i == 31)
    {
        NSString *st = [NSString stringWithFormat:NSLocalizedString(@"%dst", @"Ordinal with ~first"), i];
        ordinalString = st;
    }
    else if(i == 2 || i == 22)
    {
        NSString *nd = [NSString stringWithFormat:NSLocalizedString(@"%dnd", @"Ordinal with ~second"), i];
        ordinalString = nd;
    }
    else if(i == 3 || i == 23)
    {
        NSString *rd = [NSString stringWithFormat:NSLocalizedString(@"%drd", @"Ordinal with ~third"), i];
        ordinalString = rd;
    }
    else
    {
        NSString *th = [NSString stringWithFormat:NSLocalizedString(@"%dth", @"Ordinal with ~th"), i];
        ordinalString = th;
    }
    
    DebugLog(@"ordinalString = %@", ordinalString);
    return ordinalString;
}

+ (NSString *)notifierString:(NSNumber *)notifierNumber
{
    DebugLog(@"notifierNumber = %@", notifierNumber);
    
    NSString *notifierString = NSLocalizedString(@"No Notifier", @"notifierarray no notifier");
    
    switch ([notifierNumber integerValue]) {
        case 0:
            break;
        case 1:
            notifierString = NSLocalizedString(@"At Deadline", @"notifierarray at deadline");
            break;
        case 2:
            notifierString = NSLocalizedString(@"5 Minutes Before", @"notifier array 5 min before");
            break;
        case 3:
            notifierString = NSLocalizedString(@"15 Minutes Before", @"notifierarray 15 min before");
            break;
        case 4:
            notifierString = NSLocalizedString(@"30 Minutes Before", @"notifierarray 30 min before");
            break;
        case 5:
            notifierString = NSLocalizedString(@"One Hour Before", @"notifierarray one hour before");
            break;
        default:
            break;
    }
    
    DebugLog(@"notifierString = %@", notifierString);
    return notifierString;
}

+ (NSMutableArray *)setOrdinalArray
{
    NSInteger capacity = 32;
    NSMutableArray *mutableOrdinal = [NSMutableArray arrayWithCapacity:capacity];
    
    for (int i = 0; i<32; i++)
    {
        if (i == 0)
        {
            NSString *none = @"";
            [mutableOrdinal addObject:none];
        }
        else if(i == 1 || i == 21 || i == 31)
        {
            NSString *st = [NSString stringWithFormat:NSLocalizedString(@"%dst", @"Ordinal with ~first"), i];
            [mutableOrdinal addObject:st];
        }
        else if(i == 2 || i == 22)
        {
            NSString *nd = [NSString stringWithFormat:NSLocalizedString(@"%dnd", @"Ordinal with ~second"), i];
            [mutableOrdinal addObject:nd];
        }
        else if(i == 3 || i == 23)
        {
            NSString *rd = [NSString stringWithFormat:NSLocalizedString(@"%drd", @"Ordinal with ~third"), i];
            [mutableOrdinal addObject:rd];
        }
        else
        {
            NSString *th = [NSString stringWithFormat:NSLocalizedString(@"%dth", @"Ordinal with ~th"), i];
            [mutableOrdinal addObject:th];
        }
    }
    
    return mutableOrdinal;
}


@end
