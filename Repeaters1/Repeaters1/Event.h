//
//  Event.h
//  Repeaters1
//
//  Created by Ransom Barber on 10/12/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * notifyNumber;
@property (nonatomic, retain) Category *whichCategory;

@end
