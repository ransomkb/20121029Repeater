//
//  AddRepeaterViewController.m
//  Repeaters1
//
//  Created by Ransom Barber on 8/2/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import "AddRepeaterViewController.h"

@interface AddRepeaterViewController ()
@end

@implementation AddRepeaterViewController

@synthesize parent;
@synthesize repeaterDatabase = _repeaterDatabase;
@synthesize deadline = _deadline;
@synthesize name = _name;
@synthesize nameTextField = _nameTextField;
@synthesize settingsLabel = _settingsLabel;
@synthesize deadLabel = _deadLabel;
@synthesize notifyLabel = _notifyLabel;
@synthesize settingsInfo = _settingsInfo;
@synthesize ordinalSetting = _ordinalSetting;
@synthesize ordinalNumber = _ordinalNumber;
@synthesize daySetting = _daySetting;
@synthesize dayNumber = _dayNumber;
@synthesize timeString = _timeString;
@synthesize deadlineSetting = _deadlineSetting;
@synthesize notifierSetting = _notifierSetting;
@synthesize notifyNumber = _notifyNumber;
@synthesize ordinalAndDay = _ordinalAndDay;
@synthesize hour = _hour;
@synthesize minute = _minute;
@synthesize dateBrain = _dateBrain;
@synthesize myPopover = _myPopover;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSDictionary *)dateDetails
{
    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] initWithCapacity:4];
    
    [mutDict setObject:self.ordinalSetting forKey:@"ordinal"];
    [mutDict setObject:self.daySetting forKey:@"day"];
    [mutDict setObject:self.hour forKey:@"hour"];
    [mutDict setObject:self.minute forKey:@"minute"];
    
    return mutDict;
}

- (NSDate *)calculateNextDeadline
{
    self.dateBrain = [[DateBrain alloc] init];
    [self.dateBrain justChecking];
    NSDate *dead = [self.dateBrain determineFirstDeadline:[self dateDetails]];
    DebugLog(@"calculateNextDeadline: datebrain date = %@", dead);
    return dead;
}

- (NSDate *)lastDeadline
{
    if (self.deadline.last) {
        return self.deadline.last;
    } else {
        return [NSDate date];
    }
}

- (void)defaultSettings
{
    self.ordinalAndDay = NSLocalizedString(@"Repeats every day in a month", @"AddRep ordinal and day default");
    self.daySetting = NSLocalizedString(@"day", @"addrep daysetting default");
    self.dayNumber = [[NSNumber alloc] initWithInt:0];
    self.ordinalSetting = @"";
    self.ordinalNumber = [[NSNumber alloc] initWithInt:0];
    self.timeString = @"17:00";
    self.hour = [[NSNumber alloc] initWithInt:17];
    DebugLog(@"self.hour = %@", self.hour);
    self.minute = [[NSNumber alloc] initWithInt:00];
    self.deadlineSetting = [FormatController formatDefaultHour:self.hour andMinute:self.minute];
    self.notifierSetting = NSLocalizedString(@"No Notifier", @"addrep notifiersetting default");
    self.notifyNumber = [[NSNumber alloc] initWithInt:0];
}

- (NSDictionary *)updateSettingsInfo
{
    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] initWithCapacity:7];
    
    [mutDict setObject:self.ordinalSetting forKey:@"ordinal"];
    [mutDict setObject:self.ordinalNumber forKey:@"ordinalNumber"];
    [mutDict setObject:self.daySetting forKey:@"day"];
    [mutDict setObject:self.dayNumber forKey:@"dayNumber"];
    [mutDict setObject:self.timeString forKey:@"time"];
    [mutDict setObject:self.hour forKey:@"hour"];
    [mutDict setObject:self.minute forKey:@"minute"];
    [mutDict setObject:self.notifierSetting forKey:@"notify"];
    [mutDict setObject:self.notifyNumber forKey:@"notifyNumber"];
    [mutDict setObject:[self calculateNextDeadline] forKey:@"next"];
    [mutDict setObject:[self lastDeadline] forKey:@"last"];
    [mutDict setObject:self.name forKey:@"name"];
    
    return mutDict;
}

- (void)raiseNameAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Name", @"no name alert title")
                                                    message:NSLocalizedString(@"Please Enter a Name", @"no name alert message")
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Try Again", @"no name alert button")
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)raiseLengthAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"More Than 30 Characters", @"too long alert title")
                                                    message:NSLocalizedString(@"Please Shorten Name", @"too long alert message")
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Try Again", @"too long alert button")
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)raiseNoDeadlineAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Deadline", @"no name alert title")
                                                    message:NSLocalizedString(@"No such Deadline in Database", @"no name alert message")
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Try Again", @"no name alert button")
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![textField.text length]) {
        [textField resignFirstResponder];
    } else if ([textField.text length] > 30) {
        [self raiseLengthAlert];
    }else {
        self.name = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)dayViewController:(DayViewController *)sender
                didGetDay:(NSString*)daySetting
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DebugLog(@"viewDidLoad: self = %@", self);
    self.nameTextField.delegate = self;
    
    [self defaultSettings];
    // prepare for segue does not set outlets and stuff
}

- (void)viewDidUnload
{
    [self setNameTextField:nil];
    [self setSettingsLabel:nil];
    [self setDeadLabel:nil];
    [self setNotifyLabel:nil];
    [self setMyPopover:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.settingsLabel.text = NSLocalizedString(@"Default: Repeats every day", @"addrep settingslabel");
    self.deadLabel.text = NSLocalizedString(@"Default: 17:00", @"addrep deadlinelabel");
    self.notifyLabel.text = NSLocalizedString(@"Default: No Notifier", @"addrep notifylabel");
    self.nameTextField.placeholder = self.name;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dayViewController:(DayViewController *)sender
            didGetOrdinal:(NSString *)ordinal
             andDidGetDay:(NSString *)dayOfWeek
{
    self.ordinalSetting = ordinal;
    self.daySetting = dayOfWeek;
    DebugLog(@"doneDay: self.ordinal = %@ and self.dayOfWeek = %@", ordinal, dayOfWeek);
    self.ordinalNumber = [NSNumber numberWithInteger:[DateBrain trimOrdinal:ordinal]];
    self.dayNumber = [NSNumber numberWithInteger:[DateBrain determineDayOfWeekInteger:dayOfWeek]];
    DebugLog(@"doneDay: self.ordinalNumber = %@ and self.dayNumber = %@", self.ordinalNumber, self.dayNumber);
    self.ordinalAndDay = [FormatController formatOrdinal:self.ordinalSetting andDay:self.daySetting];
    self.settingsLabel.text = self.ordinalAndDay; // maybe can get rid of ordinalAndDay
}

- (void)deadlineViewController:(DeadlineViewController *)sender
                didGetDeadline:(NSDate *)deadlineTime
{
    DebugLog(@"AddRep: doneTime: self.deadline = %@", deadlineTime);
    self.deadlineSetting = deadlineTime;
    self.timeString = [FormatController formatTimeFromDeadline:self.deadlineSetting];
    self.hour = [FormatController formatHourFromDeadline:self.deadlineSetting];
    self.minute = [FormatController formatMinuteFromDeadline:self.deadlineSetting];
    self.deadLabel.text = [FormatController formatTimeLabel:self.timeString];
}

- (void)NotifyTableViewController:(NotifyTableViewController *)sender
                   didGetNotifier:(NSString *)notifier
                andNotifierNumber:(int)notifyNumber
{
    DebugLog(@"AddRep: doneNotifier: self.notifier = %@", notifier);
    self.notifyNumber = [NSNumber numberWithInt:notifyNumber];
    DebugLog(@"AddRep: doneNotifier: self.notifyNumber = %@", self.notifyNumber);
    self.notifierSetting = notifier;
    self.notifyLabel.text = [FormatController formatNotifierLabel:self.notifierSetting];
}

- (IBAction)cancelAddRepeater:(id)sender
{
    DebugLog(@"cancelAddRepeater");
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
    DebugLog(@"AddRepeater doneEditor reached");
    self.settingsInfo = [self updateSettingsInfo];
    DebugLog(@"AddRep doneEditor: settingsInfo = %@", self.settingsInfo);
    NSString *name = [self.settingsInfo objectForKey:@"name"];
   
    if (name.length > 30) {
        [self raiseLengthAlert];
    } else if ([name isEqualToString:NSLocalizedString(@"Enter a name", @"addrep enter a name isequal")]) {
        [self raiseNameAlert];
    }else {
        [Deadline deadlineWithSettingsInfo:self.settingsInfo inManagedObjectContext:self.repeaterDatabase.managedObjectContext];
        BOOL iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
        if (iPad) {
            DebugLog(@"in an iPad");
            [self.delegate dismissPopover];
        } else {
            [[self presentingViewController] dismissModalViewControllerAnimated:YES];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier hasPrefix:@"Add Day"]) {
        DayViewController *dayvc = (DayViewController *)segue.destinationViewController;
        dayvc.delegate = (id<DayViewControllerDelegate>)self;
        dayvc.ordinal = @"";
        dayvc.dayOfWeek = NSLocalizedString(@"day", @"dayviewcontroller dayofweek default setting");
        DebugLog(@"dayvc.ordinal = %@, dayvc.dayOfWeek = %@", dayvc.ordinal, dayvc.dayOfWeek);
        if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
            DebugLog(@"segue is popoverSegue");
            UIStoryboardPopoverSegue *popoverSegue = (id) segue;
            self.myPopover = popoverSegue.popoverController;
            self.myPopover.delegate = (id<UIPopoverControllerDelegate>)self;
            [self.myPopover setPopoverContentSize:CGSizeMake(320, 548) animated:YES];
        }
    } else if ([segue.identifier hasPrefix:@"Add Deadline"]) {
        DeadlineViewController *deadvc = (DeadlineViewController *)segue.destinationViewController;
        deadvc.delegate = (id<DeadlineViewControllerDelegate>)self;
        if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
            DebugLog(@"segue is popoverSegue");
            UIStoryboardPopoverSegue *popoverSegue = (id) segue;
            self.myPopover = popoverSegue.popoverController;
            self.myPopover.delegate = (id<UIPopoverControllerDelegate>)self;
            [self.myPopover setPopoverContentSize:CGSizeMake(320, 548) animated:YES];
        }
    } else if ([segue.identifier hasPrefix:@"Add Notifier"]) {
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
