//
//  DayViewController.m
//  Repeaters1
//
//  Created by Ransom Barber on 7/27/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import "DayViewController.h"
#import "DateBrain.h"

@interface DayViewController ()

@property (weak, nonatomic) IBOutlet UIPickerView *dayPicker;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@property (strong, nonatomic) NSArray *ordinalArray;
@property (strong, nonatomic) NSArray *dayArray;

@end

@implementation DayViewController

@synthesize dayLabel = _dayLabel;
@synthesize dayPicker = _dayPicker;
@synthesize daySetting = _daySetting;
@synthesize delegate = _delegate;

@synthesize ordinal = _ordinal;
@synthesize dayOfWeek = _dayOfWeek;
@synthesize ordinalArray = _ordinalArray;
@synthesize dayArray = _dayArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	DebugLog(@"DayViewController: viewDidLoad");
    self.ordinalArray = [NSArray arrayWithArray:[FormatController setOrdinalArray]];
    self.dayArray = [[NSArray alloc] initWithObjects:NSLocalizedString(@"day", @"picker day"), NSLocalizedString(@"Sunday", @"picker sunday"), NSLocalizedString(@"Monday", @"picker monday"), NSLocalizedString(@"Tuesday", @"picker tuesday"), NSLocalizedString(@"Wednesday", @"picker wednesday"), NSLocalizedString(@"Thursday", @"picker thursday"), NSLocalizedString(@"Friday", @"picker friday"), NSLocalizedString(@"Saturday", @"picker saturday"), nil]; //took the empty @"", out
}

- (void)viewDidUnload
{
    [self setDayPicker:nil];
    [self setDayLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    DebugLog(@"self.ordinal = %@, self.dayOfWeek = %@", self.ordinal, self.dayOfWeek);
    self.dayLabel.text = [FormatController formatOrdinal:self.ordinal andDay:self.dayOfWeek];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)
    {
        return [self.ordinalArray count];
    }
    
    return [self.dayArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        return [self.ordinalArray objectAtIndex:row];
    }
    
    return [self.dayArray objectAtIndex:row];
}

#pragma mark - PickerView Delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        NSString *resultString = [[NSString alloc] initWithFormat:@"%@", [self.ordinalArray objectAtIndex:row]];
        DebugLog(@"resultStringOrd = %@", resultString);
        
        if (!resultString)
        {
            self.ordinal = @"";
        }
        else
        {
            self.ordinal = resultString;
        }
        DebugLog(@"ordinal = %@", self.ordinal);
    }
    else
    {
        NSString *resultString = [[NSString alloc] initWithFormat:@"%@", [self.dayArray objectAtIndex:row]];
        DebugLog(@"resultStringDay = %@", resultString);
        
        if (!resultString)
        {
            self.dayOfWeek = @"";
        }
        else
        {
            self.dayOfWeek = resultString;
        }
        DebugLog(@"dayOfWeek = %@", self.dayOfWeek);
    }
    
    NSString *label = [FormatController formatOrdinal:self.ordinal andDay:self.dayOfWeek];
    DebugLog(@"Day set to: %@", label);
    
    self.dayLabel.text = label;
}

- (IBAction)doneDay:(id)sender
{
    DebugLog(@"doneDay: self.ordinal = %@ and self.dayOfWeek = %@", self.ordinal, self.dayOfWeek);
    DebugLog(@"integer of ordinal is %d", [DateBrain trimOrdinal:self.ordinal]);
    
    if ((![self.dayOfWeek isEqualToString:NSLocalizedString(@"day", @"dayofweek isequalto day")]) && ([DateBrain trimOrdinal:self.ordinal] > 4)) { //
        UIAlertView *ordinalAlert = [[UIAlertView alloc] init];
        ordinalAlert.delegate = self;
        ordinalAlert.alertViewStyle = UIAlertViewStyleDefault;
        ordinalAlert.message = [FormatController formatAlertWithOrdinal:self.ordinal andDay:self.dayOfWeek];
        [ordinalAlert addButtonWithTitle:NSLocalizedString(@"Try Again", @"alert try again button")];
        [ordinalAlert show];
    } else {
        [self.delegate dayViewController:self didGetOrdinal:self.ordinal andDidGetDay:self.dayOfWeek];
        
        BOOL iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
        if (iPad) {
            DebugLog(@"in an iPad");
            [self.delegate dismissPopover];
        } else {
            [[self presentingViewController] dismissModalViewControllerAnimated:YES];
        }
    }
}


@end
