//
//  Deadline+Settings.h
//  Repeaters1
//
//  Created by Ransom Barber on 7/27/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import "Deadline.h"

@interface Deadline (Settings)

+ (Deadline *)deadlineWithSettingsInfo:(NSDictionary *)settingsInfo
                inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Deadline *)updateDeadline:(Deadline *)deadline
            withSettingsInfo:(NSDictionary *)settingsInfo
      inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)removeDeadline:(Deadline *)deadline
inManagedObjectContext:(NSManagedObjectContext *)context;
+(void)checkDeadlinesInManagedObjectContext:(NSManagedObjectContext *)context;
@end
