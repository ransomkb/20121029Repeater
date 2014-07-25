//
//  RepeatersNavigationItem.m
//  Repeaters1
//
//  Created by Ransom Barber on 10/18/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import "RepeatersNavigationItem.h"

@implementation RepeatersNavigationItem
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;

-(id)initWithTitle:(NSString *)title {
    if((self = [super initWithTitle:title])){
        //initializer code
    }
    return self;
}
/*
- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    DebugLog(@"leftBarButtonItem 1 = %@", [self leftBarButtonItem]);
    if (_splitViewBarButtonItem != splitViewBarButtonItem) {
        //NSMutableArray *navBarItems = [self.navBar.items mutableCopy];
        if (_splitViewBarButtonItem) { // maybe this will work. different from hagerty:s
            DebugLog(@"already set leftBarButtonItem  = %@", [self leftBarButtonItem]);
            [self setLeftBarButtonItem:nil animated:YES];
            //[navBarItems removeObject:_splitViewBarButtonItem];
        }
        if (splitViewBarButtonItem) {
            DebugLog(@"first time setting leftBarButtonItem = %@", [self leftBarButtonItem]);
            [self setLeftBarButtonItem:splitViewBarButtonItem animated:YES];
            //[navBarItems insertObject:splitViewBarButtonItem atIndex:0];
        }
        //self.navBar.items = navBarItems;
        _splitViewBarButtonItem = splitViewBarButtonItem;
        DebugLog(@"final leftBarButtonItem after setting = %@", [self leftBarButtonItem]);
    }
}
*/
@end
