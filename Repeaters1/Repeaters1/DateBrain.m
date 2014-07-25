//
//  DateBrain.m
//  Repeaters1
//
//  Created by Ransom Barber on 8/20/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import "DateBrain.h"

@implementation DateBrain

@synthesize formatter = _formatter;

- (id)init
{
    if (self = [super init])
    {
        // Initialization code here
        self.formatter = [[NSDateFormatter alloc] init];
        [self.formatter setDateStyle:NSDateFormatterMediumStyle];
        [self.formatter setTimeStyle:NSDateFormatterNoStyle];

    }
    return self;
}

+ (NSCharacterSet *)determineOrdinalCharacterSet:(NSString *)ordinal
{
    NSCharacterSet *th = [NSCharacterSet characterSetWithCharactersInString:@"th"];
    NSCharacterSet *st = [NSCharacterSet characterSetWithCharactersInString:@"st"];
    NSCharacterSet *nd = [NSCharacterSet characterSetWithCharactersInString:@"nd"];
    NSCharacterSet *rd = [NSCharacterSet characterSetWithCharactersInString:@"rd"];
    NSCharacterSet *dai = [NSCharacterSet characterSetWithCharactersInString:@"第"];
    
    if ([ordinal hasSuffix:@"th"]) {
        return th;
    } else if ([ordinal hasSuffix:@"st"]) {
        return st;
    } else if ([ordinal hasSuffix:@"nd"]) {
        return nd;
    } else if ([ordinal hasSuffix:@"rd"]) {
        return rd;
    } else {
        return dai;
    }
}

+ (NSInteger)trimOrdinal:(NSString *)ordinal
{
    
    if (ordinal.length != 0) {
        NSString *trimmedOrd = [ordinal stringByTrimmingCharactersInSet:[DateBrain determineOrdinalCharacterSet:ordinal]];
        NSInteger ord = [trimmedOrd integerValue];
        return ord;
    } else {
        return 0;
    }
}

+ (NSInteger)determineDayOfWeekInteger:(NSString *)day
{
    if ([day isEqualToString:NSLocalizedString(@"day", @"day isequalto day")]) {
        return 0;
    } else if ([day isEqualToString:NSLocalizedString(@"Sunday", @"day isequalto sunday")]) {
        return 1;
    } else if ([day isEqualToString:NSLocalizedString(@"Monday", @"day isequalto monday")]) {
        return 2;
    } else if ([day isEqualToString:NSLocalizedString(@"Tuesday", @"day isequalto tuesday")]) {
        return 3;
    } else if ([day isEqualToString:NSLocalizedString(@"Wednesday", @"day isequalto wednesday")]) {
        return 4;
    } else if ([day isEqualToString:NSLocalizedString(@"Thursday", @"day isequalto thursday")]) {
        return 5;
    } else if ([day isEqualToString:NSLocalizedString(@"Friday", @"day isequalto friday")]) {
        return 6;
    } else if ([day isEqualToString:NSLocalizedString(@"Saturday", @"day isequalto saturday")]) {
        return 7;
    } else {
        return 0;
    }
}

- (void)justChecking
{
    DebugLog(@"Got to Just Checking in DateBrain");
}

- (void)setNextDeadline:(Deadline *)deadline
{
    DebugLog(@"got to setNextDeadline");
    DebugLog(@"setNextDeadline: deadline.next = %@, time = %@", [self.formatter stringFromDate:deadline.next], [FormatController formatTimeFromDeadline:deadline.next]);
    NSInteger ordInt = [DateBrain trimOrdinal:deadline.ordinal];
    NSInteger day = [DateBrain determineDayOfWeekInteger:deadline.day];
    
    NSCalendar *usersCalendar = [[NSLocale currentLocale] objectForKey:NSLocaleCalendar];
    
    if ((ordInt == 0) && (day != 0)) { //repeats once a week
        DebugLog(@"setNextDeadline: adjusted weekday deadline = %@, time = %@", [self.formatter stringFromDate:deadline.next], [FormatController formatTimeFromDeadline:deadline.next]);
        NSDateComponents *tempComps = [[NSDateComponents alloc] init];
        [tempComps setWeekdayOrdinal:1];
        NSDate *checker = [usersCalendar dateByAddingComponents:tempComps toDate:deadline.next  options:0];
        DebugLog(@"setNextDeadline: adjusted weekday deadline = %@, time = %@", [self.formatter stringFromDate:checker], [FormatController formatTimeFromDeadline:checker]);
        deadline.next = checker;
    } else if ((ordInt != 0) && (day == 0)) { //repeats same date every month
        DebugLog(@"setNextDeadline: adjusted ordinal deadline = %@, time = %@", [self.formatter stringFromDate:deadline.next], [FormatController formatTimeFromDeadline:deadline.next]);
        NSDateComponents *tempComps = [[NSDateComponents alloc] init];
        [tempComps setMonth:1];
        NSDate *checker = [usersCalendar dateByAddingComponents:tempComps toDate:deadline.next  options:0];
        DebugLog(@"setNextDeadline: adjusted ordinal deadline = %@, time = %@", [self.formatter stringFromDate:checker], [FormatController formatTimeFromDeadline:checker]);
        deadline.next = checker;
    } else if((ordInt != 0) && (day != 0)) { //repeats same weekday ordinal once a month
        NSUInteger unitFlags = NSMinuteCalendarUnit | NSHourCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
        NSDateComponents *nextComps = [usersCalendar components:unitFlags fromDate:deadline.next];

        DebugLog(@"ordint is %d, day is %d, so repeats on same weekday once a month", ordInt, day);
        DebugLog(@"nextComps weekdayOrdinal = %d and weekday = %d", [nextComps weekdayOrdinal], [nextComps weekday]);
        [nextComps setMonth:[nextComps month]+1];
        if ([nextComps month] >= 13) {
            [nextComps setMonth:1];
            [nextComps setYear:[nextComps year]+1];
        }
        
        deadline.next = [usersCalendar dateFromComponents:nextComps];
        DebugLog(@"setNextDeadline: adjusted ordinal and weekday deadline = %@, time = %@", [self.formatter stringFromDate:deadline.next], [FormatController formatTimeFromDeadline:deadline.next]);
    } else if ((ordInt == 0) && (day == 0)) { //repeats everyday
        DebugLog(@"setNextDeadline: adjusted every day deadline = %@, time = %@", [self.formatter stringFromDate:deadline.next], [FormatController formatTimeFromDeadline:deadline.next]);
        NSDateComponents *tempComps = [[NSDateComponents alloc] init];
        [tempComps setDay:1];
        NSDate *checker = [usersCalendar dateByAddingComponents:tempComps toDate:deadline.next  options:0];
        DebugLog(@"setNextDeadline: adjusted every day deadline = %@, time = %@", [self.formatter stringFromDate:checker], [FormatController formatTimeFromDeadline:checker]);
        deadline.next = checker;
    }
}

- (void)setLastDeadline:(Deadline *)deadline
{
    DebugLog(@"got to setLastDeadline");
        
    DebugLog(@"setLastDeadline: deadline.last = %@, time = %@", [self.formatter stringFromDate:deadline.last], [FormatController formatTimeFromDeadline:deadline.last]);
    NSInteger ordInt = [DateBrain trimOrdinal:deadline.ordinal];
    NSInteger day = [DateBrain determineDayOfWeekInteger:deadline.day];
    
    NSCalendar *usersCalendar = [[NSLocale currentLocale] objectForKey:NSLocaleCalendar];
    
    if ((ordInt == 0) && (day != 0)) { //repeats once a week
        DebugLog(@"setLastDeadline: adjusted weekday deadline = %@, time = %@", [self.formatter stringFromDate:deadline.last], [FormatController formatTimeFromDeadline:deadline.last]);
        NSDateComponents *tempComps = [[NSDateComponents alloc] init];
        [tempComps setWeekdayOrdinal:-1];
        NSDate *checker = [usersCalendar dateByAddingComponents:tempComps toDate:deadline.next  options:0];
        DebugLog(@"setLastDeadline: adjusted weekday deadline = %@, time = %@", [self.formatter stringFromDate:checker], [FormatController formatTimeFromDeadline:checker]);
        deadline.last = checker;
    } else if ((ordInt != 0) && (day == 0)) { //repeats same date every month
        DebugLog(@"setLastDeadline: adjusted ordinal deadline = %@, time = %@", [self.formatter stringFromDate:deadline.last], [FormatController formatTimeFromDeadline:deadline.last]);
        NSDateComponents *tempComps = [[NSDateComponents alloc] init];
        [tempComps setMonth:-1];
        NSDate *checker = [usersCalendar dateByAddingComponents:tempComps toDate:deadline.next  options:0];
        DebugLog(@"setLastDeadline: adjusted ordinal deadline = %@, time = %@", [self.formatter stringFromDate:checker], [FormatController formatTimeFromDeadline:checker]);
        deadline.last = checker;
    } else if((ordInt != 0) && (day != 0)) { //repeats same weekday ordinal once a month
        NSUInteger unitFlags = NSMinuteCalendarUnit | NSHourCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
        NSDateComponents *lastComps = [usersCalendar components:unitFlags fromDate:deadline.next];
        
        DebugLog(@"ordint is %d, day is %d, so repeats on same weekday once a month", ordInt, day);
        DebugLog(@"lastComps weekdayOrdinal = %d and weekday = %d", [lastComps weekdayOrdinal], [lastComps weekday]);
        [lastComps setMonth:[lastComps month]-1];
        if ([lastComps month] >= 13) {
            [lastComps setMonth:1];
            [lastComps setYear:[lastComps year]];
        }
        
        deadline.last = [usersCalendar dateFromComponents:lastComps];
        DebugLog(@"setLastDeadline: adjusted ordinal and weekday deadline = %@, time = %@", [self.formatter stringFromDate:deadline.last], [FormatController formatTimeFromDeadline:deadline.last]);
    } else if ((ordInt == 0) && (day == 0)) { //repeats everyday
        DebugLog(@"setLastDeadline: adjusted every day deadline = %@, time = %@", [self.formatter stringFromDate:deadline.last], [FormatController formatTimeFromDeadline:deadline.last]);
        NSDateComponents *tempComps = [[NSDateComponents alloc] init];
        [tempComps setDay:-1];
        NSDate *checker = [usersCalendar dateByAddingComponents:tempComps toDate:deadline.next  options:0];
        DebugLog(@"setLastDeadline: adjusted every day deadline = %@, time = %@", [self.formatter stringFromDate:checker], [FormatController formatTimeFromDeadline:checker]);
        deadline.last = checker;
    }
}

- (NSDate *)determineFirstDeadline:(NSDictionary *)dict
{
    DebugLog(@"determineFirstDeadline: using");

    NSInteger ordInt = [DateBrain trimOrdinal:[dict objectForKey:@"ordinal"]];
    NSInteger day = [DateBrain determineDayOfWeekInteger:[dict objectForKey:@"day"]];
    
    NSNumber *minute = [dict objectForKey:@"minute"];
    NSNumber *hour = [dict objectForKey:@"hour"];
    DebugLog(@"determineFirstDeadline: ordinal = %d, weekday = %d, hour = %@, minute = %@", ordInt, day, hour, minute);
    
    NSDate *today = [NSDate date];
    NSDate *date = [[NSDate alloc] init];
    NSCalendar *usersCalendar = [[NSLocale currentLocale] objectForKey:NSLocaleCalendar];
    NSUInteger unitFlags = NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    
    NSDateComponents *nextComps = [[NSDateComponents alloc] init];
    NSDateComponents *todayComps = [usersCalendar components:unitFlags fromDate:today];
    
    [nextComps setMinute:[minute integerValue]];
    DebugLog(@"nextComps minute = %d", [nextComps minute]);
    [nextComps setHour:[hour integerValue]];
    DebugLog(@"nextComps hour = %d", [nextComps hour]);
    [nextComps setMonth:[todayComps month]];
    DebugLog(@"nextComps month = %d", [nextComps month]);
    [nextComps setYear:[todayComps year]];
    DebugLog(@"nextComps year = %d", [nextComps year]);
    
    if ((ordInt == 0) && (day != 0)) {
        [nextComps setWeekday:day];
        [nextComps setWeekdayOrdinal:1];
        DebugLog(@"ordint is 0, day is %d, so repeats every week, set to first one", day);
        DebugLog(@"nextComps weekdayOrdinal = %d and weekday = %d", [nextComps weekdayOrdinal], [nextComps weekday]);
        
        date = [usersCalendar dateFromComponents:nextComps];
        DebugLog(@"determineFirstDeadline: deadline = %@, time = %@", [self.formatter stringFromDate:date], [FormatController formatTimeFromDeadline:date]);
        DebugLog(@"determineFirstDeadline: today = %@, time = %@", [self.formatter stringFromDate:today], [FormatController formatTimeFromDeadline:today]);
        NSDate *checker = [date laterDate:today];
        if ([checker isEqualToDate:today]) {
            DebugLog(@"determineFirstDeadline: checker = %@, time = %@", [self.formatter stringFromDate:checker], [FormatController formatTimeFromDeadline:checker]);
            [nextComps setWeekdayOrdinal:[todayComps weekdayOrdinal]];
            
            date = [usersCalendar dateFromComponents:nextComps];
            DebugLog(@"determineFirstDeadline: deadline = %@, time = %@", [self.formatter stringFromDate:date], [FormatController formatTimeFromDeadline:date]);
            DebugLog(@"determineFirstDeadline: today = %@, time = %@", [self.formatter stringFromDate:today], [FormatController formatTimeFromDeadline:today]);
            NSDate *checker = [date laterDate:today];
            if ([checker isEqualToDate:today]) {
                DebugLog(@"determineFirstDeadline: checker = %@, time = %@", [self.formatter stringFromDate:checker], [FormatController formatTimeFromDeadline:checker]);
                DebugLog(@"nextcomps weekdayOrdinal = %d", [nextComps weekdayOrdinal]);
                NSDateComponents *tempComps = [[NSDateComponents alloc] init];
                [tempComps setWeekdayOrdinal:1];
                checker = [usersCalendar dateByAddingComponents:tempComps toDate:date  options:0];
                DebugLog(@"determineFirstDeadline: adjusted weekday deadline = %@, time = %@", [self.formatter stringFromDate:checker], [FormatController formatTimeFromDeadline:checker]);
                date = checker;
            }
        }
    } else if ((ordInt != 0) && (day == 0)) {
        [nextComps setDay:ordInt];
        DebugLog(@"ordint is %d, day is 0, so repeats on the same date every month", ordInt);
        DebugLog(@"nextComps day = %d", [nextComps day]);
        
        date = [usersCalendar dateFromComponents:nextComps];
        DebugLog(@"determineFirstDeadline: deadline = %@, time = %@", [self.formatter stringFromDate:date], [FormatController formatTimeFromDeadline:date]);
        DebugLog(@"determineFirstDeadline: today = %@, time = %@", [self.formatter stringFromDate:today], [FormatController formatTimeFromDeadline:today]);
        NSDate *checker = [date laterDate:today];
        if ([checker isEqualToDate:today]) {
            DebugLog(@"determineFirstDeadline: checker = %@, time = %@", [self.formatter stringFromDate:checker], [FormatController formatTimeFromDeadline:checker]);
            
            NSDateComponents *tempComps = [[NSDateComponents alloc] init];
            [tempComps setMonth:1];
            checker = [usersCalendar dateByAddingComponents:tempComps toDate:date  options:0];
            DebugLog(@"determineFirstDeadline: adjusted ordinal deadline = %@, time = %@", [self.formatter stringFromDate:checker], [FormatController formatTimeFromDeadline:checker]);
            date = checker;
        }
    } else if((ordInt != 0) && (day != 0)) {
        if (ordInt > 0 && ordInt < 5) {
            [nextComps setWeekday:day];
            [nextComps setWeekdayOrdinal:ordInt];
            DebugLog(@"ordint is %d, day is %d, so repeats on same weekday once a month", ordInt, day);
            DebugLog(@"nextComps weekdayOrdinal = %d and weekday = %d", [nextComps weekdayOrdinal], [nextComps weekday]);
        }
        //deal with error
        
        date = [usersCalendar dateFromComponents:nextComps];
        DebugLog(@"determineFirstDeadline: deadline = %@, time = %@", [self.formatter stringFromDate:date], [FormatController formatTimeFromDeadline:date]);
        DebugLog(@"determineFirstDeadline: today = %@, time = %@", [self.formatter stringFromDate:today], [FormatController formatTimeFromDeadline:today]);
        NSDate *checker = [date laterDate:today];
        if ([checker isEqualToDate:today]) {
            DebugLog(@"determineFirstDeadline: checker = %@, time = %@", [self.formatter stringFromDate:checker], [FormatController formatTimeFromDeadline:checker]);
            
            [nextComps setMonth:[nextComps month]+1];
            if ([nextComps month] >= 13) {
                [nextComps setMonth:1];
                [nextComps setYear:[nextComps year]+1];
            }
            
            date = [usersCalendar dateFromComponents:nextComps];
            DebugLog(@"determineFirstDeadline: adjusted month deadline = %@, time = %@", [self.formatter stringFromDate:date], [FormatController formatTimeFromDeadline:date]);
        }
    } else if ((ordInt == 0) && (day == 0)) {
        [nextComps setDay:[todayComps day]];
        DebugLog(@"ordint is 0, day is 0, so repeats every day");
        DebugLog(@"nextComps day = %d", [nextComps day]);
        
        date = [usersCalendar dateFromComponents:nextComps];
        DebugLog(@"determineFirstDeadline: deadline = %@, time = %@", [self.formatter stringFromDate:date], [FormatController formatTimeFromDeadline:date]);
        DebugLog(@"determineFirstDeadline: today = %@, time = %@", [self.formatter stringFromDate:today], [FormatController formatTimeFromDeadline:today]);
        NSDate *checker = [date laterDate:today];
        if ([checker isEqualToDate:today]) {
            DebugLog(@"determineFirstDeadline: checker = %@, time = %@", [self.formatter stringFromDate:checker], [FormatController formatTimeFromDeadline:checker]);
            NSDateComponents *tempComps = [[NSDateComponents alloc] init];
            [tempComps setDay:1];
            checker = [usersCalendar dateByAddingComponents:tempComps toDate:date  options:0];
            DebugLog(@"determineFirstDeadline: adjusted ordinal deadline = %@, time = %@", [self.formatter stringFromDate:checker], [FormatController formatTimeFromDeadline:checker]);
            date = checker;
        }
    }    DebugLog(@"determineFirstDeadline: deadline = %@, time = %@", [self.formatter stringFromDate:date], [FormatController formatTimeFromDeadline:date]);
    
    return date;
}

@end
