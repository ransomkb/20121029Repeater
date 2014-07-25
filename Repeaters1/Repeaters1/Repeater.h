//
//  Repeater.h
//  Repeaters1
//
//  Created by Ransom Barber on 10/12/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category, Deadline;

@interface Repeater : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *deadlines;
@property (nonatomic, retain) Category *whichCategory;
@end

@interface Repeater (CoreDataGeneratedAccessors)

- (void)addDeadlinesObject:(Deadline *)value;
- (void)removeDeadlinesObject:(Deadline *)value;
- (void)addDeadlines:(NSSet *)values;
- (void)removeDeadlines:(NSSet *)values;

@end
