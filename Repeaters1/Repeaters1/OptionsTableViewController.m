//
//  OptionsTableViewController.m
//  Repeaters1
//
//  Created by Ransom Barber on 10/12/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import "OptionsTableViewController.h"
#import "RepeatersTableViewController.h"
//#import "DetailNavigationViewController.h"
#import "SplitViewBarButtonItemPresenter.h"

@interface OptionsTableViewController ()

@end

@implementation OptionsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        //UINavigationController* detailRoot = [self.splitViewController.viewControllers objectAtIndex:1];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.splitViewController.delegate = self;
    self.title = @"Options";
    // IMPORTANT: hidable buttons must have a title or they do not appear
}

//IMPORTANT: if you use this, change return to a rtvc
// use this to connect to detailViewController once you need to select annual events as well
- (RepeatersTableViewController *)splitViewRepeatersViewController
{
    id detailVC = [self.splitViewController.viewControllers lastObject];
    //DebugLog(@"detailVC 1 is a class of %@", detailVC);
    if ([detailVC isKindOfClass:[UINavigationController class]]) {
        //DebugLog(@"detailVC 2 is a class of %@", detailVC);
        UINavigationController *navigator = (id) detailVC;
        id rtvc = [navigator visibleViewController];
        //DebugLog(@"rtvc is a class of %@", rtvc);
        if (![rtvc isKindOfClass:[RepeatersTableViewController class]]) {
            //DebugLog(@"navigator's visible view controller is not an rtvc");
            //DebugLog(@"rtvc is a class of %@", rtvc);
            rtvc = nil;
        } else {
           // DebugLog(@"navigator's visible view controller IS an rtvc");
        }
    }
    return detailVC;
}

- (void)setDetailViewController
{
    if ([self splitViewRepeatersViewController]) {
        //set a check mark on the Within a month cell
    } //else {} set this up for annual event and check mark on the cell
}

- (id <SplitViewBarButtonItemPresenter>)splitViewBarButtonItemPresenter
{
    id detailVC = [self.splitViewController.viewControllers lastObject];
    // comment this out later as just checking
    //[self splitViewRepeatersViewController];
    //DebugLog(@"detailVC before = %@", detailVC);
     
    if ([detailVC isKindOfClass:[UINavigationController class]]) {
       
        UINavigationController *navigator = (id) detailVC;
        id rtvc = [navigator visibleViewController];
        
        if (![rtvc isKindOfClass:[RepeatersTableViewController class]]) {
            //DebugLog(@"navigator's visible view controller is not an rtvc");
            //DebugLog(@"rtvc is a class of %@", rtvc);
            detailVC = nil;
        } else {
           // DebugLog(@"navigator's visible view controller IS an rtvc");
        }
        if (![rtvc conformsToProtocol:@protocol(SplitViewBarButtonItemPresenter)]) {
            rtvc = nil;
        }
        //DebugLog(@"navigator's visible view controller (rtvc) = %@", rtvc);
        return rtvc;
    }
    
    //DebugLog(@"detailVC after = %@", detailVC);
    return detailVC;
}

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    // NO will never hide the master
    // return NO;
    //DebugLog(@"orientation = %d and UIInterfaceOrientationIsPortrait(orientation) = %d", orientation, UIInterfaceOrientationIsPortrait(orientation));
    DebugLog(@"shouldHideMaster");
    return [self splitViewBarButtonItemPresenter] ? UIInterfaceOrientationIsPortrait(orientation) : NO;
    //return YES;
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    //DebugLog(@"will hide view controller barButtonItem = %@", barButtonItem);
    //DebugLog(@"splitViewBarButtonItem before = %@", [self splitViewBarButtonItemPresenter].splitViewBarButtonItem);
    barButtonItem.title = self.title;
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = barButtonItem;
    //DebugLog(@"splitViewBarButtonItem after = %@", [self splitViewBarButtonItemPresenter].splitViewBarButtonItem);
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    //DebugLog(@"will show view controller barButtonItem = %@", barButtonItem);
    //DebugLog(@"splitViewBarButtonItem = %@", [self splitViewBarButtonItemPresenter].splitViewBarButtonItem);
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = nil;
    //DebugLog(@"splitViewBarButtonItem after = %@", [self splitViewBarButtonItemPresenter].splitViewBarButtonItem);
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
