//
//  ITIOrgSettingsViewController.m
//  Rally
//
//  Created by Henrik Fogelberg on 2012-02-22.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import "ITIOrgSettingsViewController.h"

@implementation ITIOrgSettingsViewController
@synthesize orgs;
@synthesize orgPicker;


- (void)cancel:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)done:(id)sender{
    ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
    int theRow = [orgPicker selectedRowInComponent:0];
    ITIOrganisation *org = [self.orgs objectAtIndex:theRow];
    [dataSource updateOrganisation:org.code];
    [self dismissModalViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.orgs = Nil;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.view.backgroundColor = background;
    
    ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
    orgs = [dataSource getOrganisations];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.orgs = Nil;
    self.orgPicker = Nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    ITIOrganisation *org = [self.orgs objectAtIndex:row]; 
    return org.code;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [orgs count];
}

- (int) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

@end
