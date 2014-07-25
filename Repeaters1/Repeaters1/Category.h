//
//  Category.h
//  Repeaters1
//
//  Created by Ransom Barber on 10/12/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Repeater;

@interface Category : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) NSSet *repeaters;
@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

- (void)addRepeatersObject:(Repeater *)value;
- (void)removeRepeatersObject:(Repeater *)value;
- (void)addRepeaters:(NSSet *)values;
- (void)removeRepeaters:(NSSet *)values;

@end
