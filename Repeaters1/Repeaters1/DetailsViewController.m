//
//  RepeatersViewController.m
//  Repeaters1
//
//  Created by Barber Ransom on 7/23/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import "DetailsViewController.h"
#import "EditorViewController.h"
#import "Deadline+Settings.h"
#import "Repeater+Settings.h"
#import "FormatController.h"
#import "NotificationsController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextLabel;
@property (weak, nonatomic) NSString *name;
@property (strong, nonatomic) NotificationsController *notifier;
@property (strong, nonatomic) NSDateFormatter *formatter;
@property (strong, nonatomic) DateBrain *dateBrain;

- (void)checkDeadlineLocalization:(Deadline *)deadline;
@end

@implementation DetailsViewController

@synthesize repeaterDatabase = _repeaterDatabase;
@synthesize deadline = _deadline;
@synthesize nameLabel = _nameLabel;
@synthesize dayLabel = _dayLabel;
@synthesize nextLabel = _nextLabel;
@synthesize formatter = _formatter;
@synthesize dateBrain = _dateBrain;
@synthesize notifier = _notifier;
@synthesize myPopover = _myPopover;
@synthesize name = _name;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setFormatter:(NSDateFormatter *)formatter
{
    _formatter = formatter;
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
    }
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.notifier = [[NotificationsController alloc] init];
}

- (void)viewDidUnload
{
    [self setNameLabel:nil];
    [self setDayLabel:nil];
    [self setNextLabel:nil];
    [self setMyPopover:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.name = self.deadline.whichReminder.name;
    [self checkDeadlineLocalization:self.deadline];
    self.nameLabel.text = self.name;
    self.dayLabel.text = [FormatController formatOrdinal:self.deadline.ordinal andDay:self.deadline.day andTime:self.deadline.time andNotifier:self.deadline.notify];
    self.dateBrain = [[DateBrain alloc] init];
    self.formatter = [[NSDateFormatter alloc] init]; //[self.formatter stringFromDate:date]
    [self.formatter setDateStyle:NSDateFormatterMediumStyle];
    [self.formatter setTimeStyle:NSDateFormatterNoStyle];
    NSString *nextString = NSLocalizedString(@"Present Deadline: ", @"Details second label"); //@"Present Deadline: ";
    self.nextLabel.text = [nextString stringByAppendingString:[self.formatter stringFromDate:self.deadline.next]]; //[self.formatter stringFromDate:self.deadline.next]
}

- (void)checkDeadlineLocalization:(Deadline *)deadline
{
    NSString *checkOrdinal = [FormatController ordinalString:deadline.ordinalNumber];
    NSString *checkDay = [FormatController dayString:deadline.dayNumber];
    NSString *checkNotifier = [FormatController notifierString:deadline.notifyNumber];
    
    if (![deadline.ordinal isEqualToString:checkOrdinal]) {
        deadline.ordinal = checkOrdinal;
    }
    
    if (![deadline.day isEqualToString:checkDay]) {
        deadline.day = checkDay;
    }
    
    if (![deadline.notify isEqualToString:checkNotifier]) {
        deadline.notify = checkNotifier;
    }
}

- (IBAction)dismissRepeater:(id)sender
{
    [self.notifier cancelNotificationWithName:self.deadline]; //prepares for new notification to be set
    [self.dateBrain setNextDeadline:self.deadline];
    while ([self.deadline.next isEqualToDate:[self.deadline.next earlierDate:[NSDate date]]]) {
        [self.dateBrain setNextDeadline:self.deadline]; //creates new next
    }
    
    BOOL iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    if (iPad) {
        DebugLog(@"in an iPad");
        [self.delegate dismissPopover];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)deleteRepeater
{
    [self.notifier cancelNotificationWithName:self.deadline];
    
    [Deadline removeDeadline:self.deadline inManagedObjectContext:self.deadline.managedObjectContext];
    [Repeater removeLastRepeater:self.name inManagedObjectContext:self.repeaterDatabase.managedObjectContext];
    [Repeater checkRepeatersInManagedObjectContext:self.repeaterDatabase.managedObjectContext];
    
    BOOL iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    if (iPad) {
        DebugLog(@"in an iPad");
        [self.delegate dismissPopover];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)showActionSheet:(id)sender
{
    NSString *deleteAS = NSLocalizedString(@"Delete Deadline", @"delete action sheet title");
    UIActionSheet *deleteQuery = [[UIActionSheet alloc] initWithTitle:deleteAS delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"delete action sheet button") destructiveButtonTitle:NSLocalizedString(@"Delete", @"delete action sheet button") otherButtonTitles:nil, nil];
    deleteQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [deleteQuery showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self deleteRepeater];
        DebugLog(@"Delete Button was pushed.");
    } else {
        DebugLog(@"Cancel Button was pushed.");
        
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier hasPrefix:@"Editor"]) {
        EditorViewController *evc = (EditorViewController *)segue.destinationViewController;
        evc.deadline = self.deadline;
        evc.delegate = (id<AddRepeaterViewControllerDelegate>)self;
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
    [self.delegate dismissPopover];
}

@end
