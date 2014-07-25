//
//  EditorViewController.m
//  Repeaters1
//
//  Created by Ransom Barber on 7/27/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import "EditorViewController.h"

@interface EditorViewController ()
- (void)defaultSettings;
@end

@implementation EditorViewController


- (void)defaultSettings
{
    self.ordinalAndDay = [FormatController formatOrdinal:self.deadline.ordinal andDay:self.deadline.day];

    self.daySetting = self.deadline.day;
    self.dayNumber = self.deadline.dayNumber;
    self.ordinalSetting = self.deadline.ordinal;
    self.ordinalNumber = self.deadline.ordinalNumber;
    self.timeString = self.deadline.time;
    self.hour = self.deadline.hour;
    self.minute = self.deadline.minute;
    self.notifierSetting = self.deadline.notify;
    self.notifyNumber = self.deadline.notifyNumber;
    self.name = self.deadline.whichReminder.name;
    self.nameTextField.text = self.name;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self defaultSettings];
    
    self.nameTextField.delegate = self;
}

 
- (void)viewDidUnload
{
    [self setNameTextField:nil];
    [self setSettingsLabel:nil];
    [self setMyPopover:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.settingsLabel.text = self.ordinalAndDay;
    self.deadLabel.text = [FormatController formatTimeLabel:self.timeString];
    self.notifyLabel.text = [FormatController formatNotifierLabel:self.notifierSetting];
}

- (IBAction)cancelEditor:(id)sender
{
    BOOL iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    if (iPad) {
        DebugLog(@"in an iPad");
        [self.delegate dismissPopover];
    } else {
        [[self presentingViewController] dismissModalViewControllerAnimated:YES];
    }
}

- (IBAction)doneEditor:(id)sender
{
    self.settingsInfo = [self updateSettingsInfo];
    DebugLog(@"Editor doneEditorreached");
    DebugLog(@"Editor doneEditor: settingsInfo = %@", self.settingsInfo);
    NSString *name = [self.settingsInfo objectForKey:@"name"];
    
    if (name.length > 30) {
        [self raiseLengthAlert];
    } else {
        if (self.deadline) {
            self.deadline.day = [self.settingsInfo objectForKey:@"day"];
            self.deadline.dayNumber = [self.settingsInfo objectForKey:@"dayNumber"];
            self.deadline.time = [self.settingsInfo objectForKey:@"time"];
            self.deadline.hour = [self.settingsInfo objectForKey:@"hour"];
            self.deadline.minute = [self.settingsInfo objectForKey:@"minute"];
            self.deadline.next = [self.settingsInfo objectForKey:@"next"];
            self.deadline.last = [self.settingsInfo objectForKey:@"last"];
            self.deadline.notify = [self.settingsInfo objectForKey:@"notify"];
            self.deadline.notifyNumber = [self.settingsInfo objectForKey:@"notifyNumber"];
            self.deadline.ordinal = [self.settingsInfo objectForKey:@"ordinal"];
            self.deadline.ordinalNumber = [self.settingsInfo objectForKey:@"ordinalNumber"];
            self.deadline.whichReminder.name = [self.settingsInfo objectForKey:@"name"];
        
            DebugLog(@"Deadline Settings are: day = %@, time = %@, hour = %@, minute = %@, next = %@, last = %@, notify = %@, ordinal = %@, whichReminder = %@", self.deadline.day, self.deadline.time, self.deadline.hour, self.deadline.minute,self.deadline.next, self.deadline.last, self.deadline.notify, self.deadline.ordinal, self.deadline.whichReminder);
            
            BOOL iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
            if (iPad) {
                DebugLog(@"in an iPad");
                [self.delegate dismissPopover];
            } else {
                [[self presentingViewController] dismissModalViewControllerAnimated:YES];
            }
        } else {
            // handle error of no deadline
            [self raiseNoDeadlineAlert];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier hasPrefix:@"Day Setter"]) {
        DayViewController *dayvc = (DayViewController *)segue.destinationViewController;
        dayvc.delegate = (id<DayViewControllerDelegate>)self;
        dayvc.ordinal = self.deadline.ordinal;
        dayvc.dayOfWeek = self.deadline.day;
        if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
            DebugLog(@"segue is popoverSegue");
            UIStoryboardPopoverSegue *popoverSegue = (id) segue;
            self.myPopover = popoverSegue.popoverController;
            self.myPopover.delegate = (id<UIPopoverControllerDelegate>)self;
            [self.myPopover setPopoverContentSize:CGSizeMake(320, 548) animated:YES];
        }
    } else if ([segue.identifier hasPrefix:@"Deadline Setter"]) {
        DeadlineViewController *deadvc = (DeadlineViewController *)segue.destinationViewController;
        deadvc.delegate = (id<DeadlineViewControllerDelegate>)self;
        if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
            DebugLog(@"segue is popoverSegue");
            UIStoryboardPopoverSegue *popoverSegue = (id) segue;
            self.myPopover = popoverSegue.popoverController;
            self.myPopover.delegate = (id<UIPopoverControllerDelegate>)self;
            [self.myPopover setPopoverContentSize:CGSizeMake(320, 548) animated:YES];
        }
    } else if ([segue.identifier hasPrefix:@"Notifier Setter"]) {
        NotifyTableViewController *notvc = (NotifyTableViewController *)segue.destinationViewController;
        notvc.delegate = (id<NotifyTableViewControllerDelegate>)self;
        if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
            DebugLog(@"segue is popoverSegue");
            UIStoryboardPopoverSegue *popoverSegue = (id) segue;
            self.myPopover = popoverSegue.popoverController;
            self.myPopover.delegate = (id<UIPopoverControllerDelegate>)self;
            [self.myPopover setPopoverContentSize:CGSizeMake(320, 548) animated:YES];
        }
    }
}

- (void)dismissPopover
{
    DebugLog(@"dismissPopover");
    DebugLog(@"should have dismissed");
    [self.myPopover dismissPopoverAnimated:YES];
}

@end
