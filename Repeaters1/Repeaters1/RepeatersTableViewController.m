//
//  RepeatersViewController.m
//  Repeaters1
//
//  Created by Ransom Barber on 7/27/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import "RepeatersTableViewController.h"
#import "RepeatersNavigationItem.h"
#import "Repeater.h"
#import "Deadline+Settings.h"
#import "DetailsViewController.h"
#import "AddRepeaterViewController.h"
#import "AboutRepeatersViewController.h"
#import "NotificationsController.h"
#import "FormatController.h"
#import "DateBrain.h"

@interface RepeatersTableViewController ()
@property (strong, nonatomic) NotificationsController *notifier;
@property (strong, nonatomic) NSMutableArray *notifierNamesArray;
@property (strong, nonatomic) NSDateFormatter *formatter;
@property (strong, nonatomic) DateBrain *dateBrain;
- (NSDictionary *)setCellColor:(Deadline *)deadline;
- (UITableViewCell *)cell:(UITableViewCell *)cell withColors:(NSNumber *)colors;
- (void)handleSwipeLeft:(UIGestureRecognizer *)recognizer;
- (void)handleSwipeRight:(UIGestureRecognizer *)recognizer;
- (void)createNotifierNamesArray;
@end

@implementation RepeatersTableViewController

@synthesize repeaterDatabase = _repeaterDatabase;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize leftBarButton = _leftBarButton;
@synthesize myPopoverController = _myPopoverController;
@synthesize notifierNamesArray = _notifierNamesArray;
@synthesize settingsInfo = _settingsInfo;
@synthesize formatter = _formatter;
@synthesize dateBrain = _dateBrain;
@synthesize notifier = _notifier;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        //RepeatersNavigationItem *rnavItem = [[RepeatersNavigationItem alloc] initWithTitle:@"Repeaters"];
    }
    return self;
}

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    //DebugLog(@"leftBarButtonItem 1 = %@", [self.navigationItem leftBarButtonItem]);
    if (_splitViewBarButtonItem != splitViewBarButtonItem) {
        //NSMutableArray *navBarItems = [self.navBar.items mutableCopy];
        //RepeatersNavigationItem *rNavItem = [navBarItems objectAtIndex:0];
        //DebugLog(@"navBarItems objectAtIndex:0 = %@", self.navigationItem);
        if (_splitViewBarButtonItem) { // maybe this will work. different from hagerty:s
            //DebugLog(@"already set leftBarButtonItem  = %@", [self.navigationItem leftBarButtonItem]);
            [self.navigationItem setLeftBarButtonItem:nil animated:YES];
            //DebugLog(@"next leftBarButtonItem  = %@", [self.navigationItem leftBarButtonItem]);
        }
        if (splitViewBarButtonItem) {
            //DebugLog(@"first time setting leftBarButtonItem = %@", [self.navigationItem leftBarButtonItem]);
            //DebugLog(@"passed barButtonItem = %@, and the title = %@", splitViewBarButtonItem, splitViewBarButtonItem.title);
            [self.navigationItem setLeftBarButtonItem:splitViewBarButtonItem animated:YES];
            //DebugLog(@"next leftBarButtonItem  = %@, and the title = %@", [self.navigationItem leftBarButtonItem], self.navigationItem.leftBarButtonItem.title);
        }
        
        //[navBarItems insertObject:rNavItem atIndex:0];
        _splitViewBarButtonItem = splitViewBarButtonItem;
        DebugLog(@"final leftBarButtonItem after setting = %@", [self.navigationItem leftBarButtonItem]);
        //DebugLog(@"final navBarItems objectAtIndex:0 = %@", [navBarItems objectAtIndex:0]);
    }
}

- (void)createNotifierNamesArray
{
    self.notifierNamesArray = [[NSMutableArray alloc] initWithCapacity:1];
    for (Deadline *deadline in [[self fetchedResultsController] fetchedObjects]) {
        [self.notifierNamesArray addObject:deadline.whichReminder.name];
    }
}

- (void)setUpFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Deadline"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"next" ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.repeaterDatabase.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    DebugLog(@"setUpFetchedResultsController: now set.");
    [Repeater checkRepeatersInManagedObjectContext:self.repeaterDatabase.managedObjectContext];
    [Deadline checkDeadlinesInManagedObjectContext:self.repeaterDatabase.managedObjectContext];
    [self createNotifierNamesArray];
    DebugLog(@"setUpFetchedResultsController: self.notifierNamesArray.count = %d", self.notifierNamesArray.count);
}

- (void)useDocument
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.repeaterDatabase.fileURL path]]) {
        [self.repeaterDatabase saveToURL:self.repeaterDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            [self setUpFetchedResultsController];
        }];
    } else if (self.repeaterDatabase.documentState == UIDocumentStateClosed) {
        [self.repeaterDatabase openWithCompletionHandler:^(BOOL success) {
            [self setUpFetchedResultsController];
        }];
    } else if (self.repeaterDatabase.documentState == UIDocumentStateNormal) {
        [self setUpFetchedResultsController];
    }
}

//set up automatically when variable is created
- (void)setRepeaterDatabase:(UIManagedDocument *)repeaterDatabase
{
    if (_repeaterDatabase != repeaterDatabase) {
        _repeaterDatabase = repeaterDatabase;
        [self useDocument];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    DebugLog(@"Reached viewDidLoad");
    self.leftBarButton = [[UIBarButtonItem alloc] init];
    self.dateBrain = [[DateBrain alloc] init];
    self.notifier = [[NotificationsController alloc] init];
    self.notifierNamesArray = [[NSMutableArray alloc] init];
    
    self.formatter = [[NSDateFormatter alloc] init];
    [self.formatter setDateStyle:NSDateFormatterMediumStyle];
    [self.formatter setTimeStyle:NSDateFormatterNoStyle];
    
    UISwipeGestureRecognizer *gestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    [gestureLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.tableView addGestureRecognizer:gestureLeft];
    
    UISwipeGestureRecognizer *gestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    [gestureRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.tableView addGestureRecognizer:gestureRight];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(viewWillAppear:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    [self.notifier checkNotifierNames:self.notifierNamesArray];
    DebugLog(@"viewDidLoad: self.notifierNamesArray.count = %d", self.notifierNamesArray.count);
}

- (void)viewDidUnload
{
    [self setMyPopoverController:nil];
    //[self setNavigationBarItem:nil];
    [self setLeftBarButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DebugLog(@"Reached viewWillAppear.");
    DebugLog(@"self.navigationItem.leftButton = %@", self.navigationItem.leftBarButtonItem);
    self.leftBarButton = self.navigationItem.leftBarButtonItem;
    if (!self.repeaterDatabase) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Default Repeater Database"];
        self.repeaterDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
    }
    [Repeater checkRepeatersInManagedObjectContext:self.repeaterDatabase.managedObjectContext];
    [Deadline checkDeadlinesInManagedObjectContext:self.repeaterDatabase.managedObjectContext];
    
    [self createNotifierNamesArray];
    DebugLog(@"viewWillAppear: self.notifierNamesArray.count = %d", self.notifierNamesArray.count);
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSDictionary *)setCellColor:(Deadline *)deadline
{
    NSString *subtext = @"";
    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] initWithCapacity:3];
    NSCalendar *usersCalendar = [[NSLocale currentLocale] objectForKey:NSLocaleCalendar];
    NSUInteger unitFlags = NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit ;
    
    NSDateComponents *colorComps = [usersCalendar components:unitFlags fromDate:[NSDate date] toDate:deadline.next options:0];
    DebugLog(@"colorComponents of deadline are day = %d, hour = %d, minute = %d", [colorComps day], [colorComps hour], [colorComps minute]);
        
    if ([colorComps day] > 0) {
        if ([colorComps day] > 5) {
            subtext = NSLocalizedString(@"(> 5 days)", @"deadline over 5 days");
            [mutDict setObject:subtext forKey:@"subtext"];
            [mutDict setObject:[NSNumber numberWithInt:1] forKey:@"colors"];
            return mutDict;
        } else if ([colorComps day] > 2) {
            subtext = NSLocalizedString(@"(> 2 days)", @"deadline over 2 days");
            [mutDict setObject:subtext forKey:@"subtext"];
            [mutDict setObject:[NSNumber numberWithInt:2] forKey:@"colors"];
            return mutDict;
        } else if ([colorComps day] > 0) {
            subtext = NSLocalizedString(@"(> 24 hrs)", @"deadline over 24hrs");
            [mutDict setObject:subtext forKey:@"subtext"];
            [mutDict setObject:[NSNumber numberWithInt:3] forKey:@"colors"];
            return mutDict;
        }
    } else if ([colorComps day] < -2) {
        [self.dateBrain setNextDeadline:deadline];
    } else if ([colorComps minute] < 0) {
        subtext = NSLocalizedString(@"(missed)", @"missed/past the deadline");
        [mutDict setObject:subtext forKey:@"subtext"];
        [mutDict setObject:[NSNumber numberWithInt:7] forKey:@"colors"];
        
        [self.notifier cancelNotificationWithName:deadline];
        return mutDict;
    } else if ([colorComps day] == 0) {
        if ([colorComps hour] < 3) {
            subtext = NSLocalizedString(@"(< 3 hrs)", @"deadline under 3 hrs");
            [mutDict setObject:subtext forKey:@"subtext"];
            [mutDict setObject:[NSNumber numberWithInt:4] forKey:@"colors"];
            return mutDict;
        } else if ([colorComps hour] < 6) {
            subtext = NSLocalizedString(@"(< 6 hrs)", @"deadline under 6 hours");
            [mutDict setObject:subtext forKey:@"subtext"];
            [mutDict setObject:[NSNumber numberWithInt:5] forKey:@"colors"];
            return mutDict;
        } else if ([colorComps hour] < 24) {
            subtext = NSLocalizedString(@"(< 24 hrs)", @"deadline under 24 hours");
            [mutDict setObject:subtext forKey:@"subtext"];
            [mutDict setObject:[NSNumber numberWithInt:6] forKey:@"colors"];
            return mutDict;
        }
    }
    
    subtext = @"";
    [mutDict setObject:subtext forKey:@"subtext"];
    [mutDict setObject:[NSNumber numberWithInt:0] forKey:@"colors"];
    return mutDict;
}

- (UITableViewCell *)cell:(UITableViewCell *)cell withColors:(NSNumber *)colors
{
    BOOL iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    
    UIColor *backgroundColor = [UIColor blackColor];
    UIColor *textColor = [UIColor whiteColor];
    
    switch ([colors integerValue]) {
        case 0:
            backgroundColor = [UIColor whiteColor];
            textColor = [UIColor blackColor];
            break;
        case 1:
            if (iPad) {
                cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PadPurple.png"]];
            } else {
                cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PhonePurple.png"]];
            }
            backgroundColor = [UIColor clearColor];
            break;
        case 2:
            if (iPad) {
                cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PadBlue.png"]];
            } else {
                cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PhoneBlue.png"]];
            }
            backgroundColor = [UIColor clearColor];
            break;
        case 3:
            if (iPad) {
                cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PadGreen.png"]];
            } else {
                cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PhoneGreen.png"]];
            }
            backgroundColor = [UIColor clearColor];
            textColor = [UIColor darkGrayColor];
            break;
        case 4:
            if (iPad) {
                cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PadRed.png"]];
            } else {
                cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PhoneRed.png"]];
            }
            backgroundColor = [UIColor clearColor];
            break;
        case 5:
            if (iPad) {
                cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PadOrange.png"]];
            } else {
                cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PhoneOrange.png"]];
            }
            backgroundColor = [UIColor clearColor];
            break;
        case 6:
            if (iPad) {
                cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PadYellow.png"]];
            } else {
                cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PhoneYellow.png"]];
            }
            backgroundColor = [UIColor clearColor];
            textColor = [UIColor darkGrayColor];
            break;
        case 7:
            if (iPad) {
                cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PadBlack.png"]];
            } else {
                cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PhoneBlack.png"]];
            }
            backgroundColor = [UIColor clearColor];
            break;
        default:
            break;
    }
    
    cell.backgroundColor = backgroundColor;
    cell.textLabel.textColor = textColor;
    cell.detailTextLabel.textColor = textColor;
    
    return cell;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Repeater Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    UIFont *iPadFont = [UIFont fontWithName:@"Arial" size:25.0];
    
    BOOL iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    if (iPad) {
        cell.textLabel.font = iPadFont;
    }
    
    Deadline *deadline = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (deadline) {
        cell.textLabel.text = deadline.whichReminder.name;
        DebugLog(@"cell.textLabel.text = %@", cell.textLabel.text);
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ / %@ ", [self.formatter stringFromDate:deadline.next], [FormatController formatTimeFromDeadline:deadline.next]];
        DebugLog(@"cell.detailTextLabel.text = %@", cell.detailTextLabel.text);
        [self.notifier scheduleNotifications:deadline];
    }
        
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    Deadline *deadline = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (deadline) {
        DebugLog(@"willDisplayCell: deadline name = %@", deadline.whichReminder.name);
        NSDictionary *colorDict = [self setCellColor:deadline];
        cell = [self cell:cell withColors:[colorDict objectForKey:@"colors"]];
        cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingString:[colorDict objectForKey:@"subtext"]];
        [cell setSelectionStyle:UITableViewCellEditingStyleNone];
        DebugLog(@"deadline.next = %@, backgroundcolor = %@", [self.formatter stringFromDate:deadline.next], cell.backgroundColor);
    }
}
 
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     BOOL iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
     if (iPad) {
         return 80;
     } else {
         return 60;
     }

 }

- (void)handleSwipeLeft:(UIGestureRecognizer *)recognizer
{
    CGPoint swipeLocation = [recognizer locationInView:self.tableView];
    NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
    DebugLog(@"Cell was swiped Left.");
    
    Deadline *deadline = [self.fetchedResultsController objectAtIndexPath:swipedIndexPath];
    if (deadline) {
        deadline.last = deadline.next; //resets last to next
        [self.notifier cancelNotificationWithName:deadline]; //prepares for new notification to be set; returns unused BOOL
        [self.dateBrain setNextDeadline:deadline]; //creates new next
        while ([deadline.next isEqualToDate:[deadline.next earlierDate:[NSDate date]]]) {
            [self.dateBrain setNextDeadline:deadline]; //creates new next
        }
        DebugLog(@"Left-Swipe: now deadline.last = %@", deadline.last);
    }
}

- (void)handleSwipeRight:(UIGestureRecognizer *)recognizer
{
    CGPoint swipeLocation = [recognizer locationInView:self.tableView];
    NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
    DebugLog(@"Cell was swiped Right.");
    
    Deadline *deadline = [self.fetchedResultsController objectAtIndexPath:swipedIndexPath];
    if (deadline) {
        [self.notifier cancelNotificationWithName:deadline]; //prepares for new notification to be set; returns unused BOOL
        [self.dateBrain setLastDeadline:deadline]; //creates last from next
        if ([deadline.last isEqualToDate:[deadline.last laterDate:[NSDate date]]]) {
            deadline.next = deadline.last; // resets next
            [self.dateBrain setLastDeadline:deadline]; //creates new last from next
        }
        DebugLog(@"Right-Swipe: now deadline.next = %@", deadline.next);
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DebugLog(@"didDeselectRowAtIndexPath = %d", indexPath.row);
    
    BOOL iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    if (iPad) {
        DebugLog(@"in a storyboard");
        Deadline *deadline = [self.fetchedResultsController objectAtIndexPath:indexPath];
        DetailsViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
        dvc.repeaterDatabase = self.repeaterDatabase;
        dvc.deadline = deadline;
        dvc.delegate = (id<DetailsViewControllerDelegate>)self;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        self.myPopoverController = [[UIPopoverController alloc] initWithContentViewController:dvc];
        self.myPopoverController.delegate = (id<UIPopoverControllerDelegate>)self;
        [self.myPopoverController setPopoverContentSize:CGSizeMake(320, 548) animated:YES];
        [self.myPopoverController presentPopoverFromRect:[cell frame] inView:[self tableView] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    DebugLog(@"Got to prepareForSegue");
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Deadline *deadline = [self.fetchedResultsController objectAtIndexPath:indexPath];

    if ([segue.identifier hasPrefix:@"Details"]) {
        DetailsViewController *dvc = (DetailsViewController *)segue.destinationViewController;
        dvc.repeaterDatabase = self.repeaterDatabase;
        dvc.deadline = deadline;
    } else if ([segue.identifier hasPrefix:@"Add"]) {
        AddRepeaterViewController *avc = (AddRepeaterViewController *)segue.destinationViewController;
        avc.repeaterDatabase = self.repeaterDatabase;
        avc.name = NSLocalizedString(@"Enter a name", @"addviewcontroller enter a name default");
        avc.parent = TRUE;
        avc.delegate = (id<AddRepeaterViewControllerDelegate>)self;
        if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
            DebugLog(@"segue is popoverSegue");
            UIStoryboardPopoverSegue *popoverSegue = (id) segue;
            self.myPopoverController = popoverSegue.popoverController;
            self.myPopoverController.delegate = (id<UIPopoverControllerDelegate>)self;
        }
    } else if ([segue.identifier hasPrefix:@"Info"]) {
        if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
            DebugLog(@"segue is popoverSegue");
            UIStoryboardPopoverSegue *popoverSegue = (id) segue;
            self.myPopoverController = popoverSegue.popoverController;
            self.myPopoverController.delegate = (id<UIPopoverControllerDelegate>)self;
            [self.myPopoverController setPopoverContentSize:CGSizeMake(320, 600) animated:YES];
        }
    }
}

- (void)dismissPopover
{
    DebugLog(@"dismissPopover");
    DebugLog(@"should have dismissed");
    [self.myPopoverController dismissPopoverAnimated:YES];
}

@end
