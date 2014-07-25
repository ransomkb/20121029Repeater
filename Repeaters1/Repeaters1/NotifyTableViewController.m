//
//  NotifyViewController.m
//  Repeaters1
//
//  Created by Ransom Barber on 7/27/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import "NotifyTableViewController.h"

@interface NotifyTableViewController ()
@property (nonatomic, strong) NSArray *preNotifiers;
@end

@implementation NotifyTableViewController

@synthesize preNotifiers = _preNotifiers;
@synthesize notifyTableView = _notifyTableView;
@synthesize notifier = _notifier;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        
        [self.view addSubview:self.notifyTableView]; // maybe this should be in viewDidLoad; seems to work better here
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.preNotifiers = [[NSArray alloc] initWithObjects:NSLocalizedString(@"No Notifier", @"notifierarray no notifier"), NSLocalizedString(@"At Deadline", @"notifierarray at deadline"), NSLocalizedString(@"5 Minutes Before", @"notifier array 5 min before"), NSLocalizedString(@"15 Minutes Before", @"notifierarray 15 min before"), NSLocalizedString(@"30 Minutes Before", @"notifierarray 30 min before"), NSLocalizedString(@"One Hour Before", @"notifierarray one hour before"), nil];
    
    selectedValueIndex = 0;
    self.notifier = NSLocalizedString(@"One Hour Before", @"default notifier ivar");
    
    //[self.view addSubview:self.notifyTableView];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setNotifyTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.preNotifiers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Notify Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    cell.textLabel.text = [self.preNotifiers objectAtIndex:[indexPath row]];
    
    if ([indexPath row] == selectedValueIndex)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DebugLog(@"didSelectRow: indexPath.row = %d and selectedValueIndex = %d before setting", indexPath.row, selectedValueIndex);
    selectedValueIndex = indexPath.row;
    DebugLog(@"didSelectRow: selectedValueIndex = %d after setting", selectedValueIndex);
    [tableView reloadData];

    self.notifier = [self.preNotifiers objectAtIndex:indexPath.row];
    notifyNumber = indexPath.row;
    DebugLog(@"didSelectRow: self.notifier = %@ after setting", self.notifier);
}

- (IBAction)doneNotifier:(id)sender
{
    DebugLog(@"doneNotifier: self.notifier = %@", self.notifier);
    [self.delegate NotifyTableViewController:self didGetNotifier:self.notifier andNotifierNumber:notifyNumber];
    
    BOOL iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    if (iPad) {
        DebugLog(@"in an iPad");
        [self.delegate dismissPopover];
    } else {
        [[self presentingViewController] dismissModalViewControllerAnimated:YES];
    }
}

@end
