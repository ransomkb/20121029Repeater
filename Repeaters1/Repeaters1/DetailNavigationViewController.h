//
//  DetailNavigationViewController.h
//  Repeaters1
//
//  Created by Ransom Barber on 10/18/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewBarButtonItemPresenter.h"


@interface DetailNavigationViewController : UINavigationController <SplitViewBarButtonItemPresenter>
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

@end
