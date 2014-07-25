//
//  Deadline+Settings.m
//  Repeaters1
//
//  Created by Ransom Barber on 7/27/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import "Deadline+Settings.h"
#import "Repeater+Settings.h"

@implementation Deadline (Settings)

+ (Deadline *)deadlineWithSettingsInfo:(NSDictionary *)settingsInfo
                inManagedObjectContext:(NSManagedObjectContext *)context
{
    DebugLog(@"Deadline+Settings deadlineWithSettingsInfo: settingsInfo = %@", settingsInfo);
    if (!context) {
        DebugLog(@"context is nil");
    }
    Deadline *deadline = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Deadline"];
    request.predicate = [NSPredicate predicateWithFormat:@"whichReminder = %@ AND day = %@", [settingsInfo objectForKey:@"name"], [settingsInfo objectForKey:@"day"]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"day" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
            
    if (!matches || ([matches count] > 1)) {
        // handle error
        DebugLog(@"matches count = 1 %d", [matches count]);
    } else if ([matches count] == 0) {
        DebugLog(@"matches count = 2 %d", [matches count]);
        DebugLog(@"deadline.day = %@ before newobject", deadline.day);

        deadline = [NSEntityDescription insertNewObjectForEntityForName:@"Deadline" inManagedObjectContext:context];
        
        deadline.day = [settingsInfo objectForKey:@"day"];
        deadline.dayNumber = [settingsInfo objectForKey:@"dayNumber"];
        DebugLog(@"deadline.day = %@ after newobject", deadline.day);
        deadline.time = [settingsInfo objectForKey:@"time"];
        deadline.hour = [settingsInfo objectForKey:@"hour"];
        deadline.minute = [settingsInfo objectForKey:@"minute"];
        deadline.next = [settingsInfo objectForKey:@"next"];
        deadline.last = [settingsInfo objectForKey:@"last"];
        deadline.notify = [settingsInfo objectForKey:@"notify"];
        deadline.notifyNumber = [settingsInfo objectForKey:@"notifyNumber"];
        deadline.ordinal = [settingsInfo objectForKey:@"ordinal"];
        deadline.ordinalNumber = [settingsInfo objectForKey:@"ordinalNumber"];
        deadline.whichReminder = [Repeater repeaterWithName:[settingsInfo objectForKey:@"name"] inManagedObjectContext:context];// set this in repeater - done
    } else {
        DebugLog(@"matches count = 3 %d", [matches count]);
        deadline = [matches lastObject];
    }
    
    DebugLog(@"Deadline Settings are: day = %@, time = %@, hour = %@, minute = %@, next = %@, last = %@, notify = %@, ordinal = %@, whichReminder = %@", deadline.day, deadline.time, deadline.hour, deadline.minute, deadline.next, deadline.last, deadline.notify, deadline.ordinal, deadline.whichReminder);
    
    return deadline;
}

+ (Deadline *)updateDeadline:(Deadline *)deadline
            withSettingsInfo:(NSDictionary *)settingsInfo
      inManagedObjectContext:(NSManagedObjectContext *)context
{
    DebugLog(@"Deadline+Settings updateDeadline: settingsInfo = %@", settingsInfo);
        
    if (deadline) {
        deadline.day = [settingsInfo objectForKey:@"day"];
        deadline.dayNumber = [settingsInfo objectForKey:@"dayNumber"];
        deadline.time = [settingsInfo objectForKey:@"time"];
        deadline.hour = [settingsInfo objectForKey:@"hour"];
        deadline.minute = [settingsInfo objectForKey:@"minute"];
        deadline.next = [settingsInfo objectForKey:@"next"];
        deadline.last = [settingsInfo objectForKey:@"last"];
        deadline.notify = [settingsInfo objectForKey:@"notify"];
        deadline.notifyNumber = [settingsInfo objectForKey:@"notifyNumber"];
        deadline.ordinal = [settingsInfo objectForKey:@"ordinal"];
        deadline.ordinalNumber = [settingsInfo objectForKey:@"ordinalNumber"];
        deadline.whichReminder = [Repeater repeaterWithName:[settingsInfo objectForKey:@"name"] inManagedObjectContext:context];
        
        DebugLog(@"Deadline Settings are: day = %@, time = %@, hour = %@, minute = %@, next = %@, last = %@, notify = %@, ordinal = %@, whichReminder = %@", deadline.day, deadline.time, deadline.hour, deadline.minute, deadline.next, deadline.last, deadline.notify, deadline.ordinal, deadline.whichReminder);
    } else {
        DebugLog(@"Deadline+Settings: deadline is %@", deadline);
    }
    
    return deadline;
}

+ (void)removeDeadline:(Deadline *)deadline
inManagedObjectContext:(NSManagedObjectContext *)context
{
    [context deleteObject:deadline];
    return;
}

+(void)checkDeadlinesInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Deadline"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"day" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches) {
        // handle error
        DebugLog(@"checkDeadlinesInManagedObjectContext: !matches");
    } else {
        for (Deadline *dead in matches)
        {
            DebugLog(@"checkDeadlinesInManagedObjectContext: Deadline Day = %@, next = %@", dead.day, dead.next);
        }
    }
    
}

@end
