//
//  Repeater+Settings.h
//  Repeaters1
//
//  Created by Ransom Barber on 7/27/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import "Repeater.h"

@interface Repeater (Settings)

+ (Repeater *)repeaterWithName:(NSString *)name
        inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)removeLastRepeater:(NSString *)name
    inManagedObjectContext:(NSManagedObjectContext *)context;
+(void)checkRepeatersInManagedObjectContext:(NSManagedObjectContext *)context;
@end
