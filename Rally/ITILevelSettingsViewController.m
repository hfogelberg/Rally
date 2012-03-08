//
//  ITILevelSettingsViewController.m
//  Rally
//
//  Created by Henrik Fogelberg on 2012-02-22.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import "ITILevelSettingsViewController.h"

@implementation ITILevelSettingsViewController
@synthesize levelPicker;
@synthesize levels;

- (void)cancel:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

// Save selected level
- (void)done:(id)sender{
    ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
    int theRow = [levelPicker selectedRowInComponent:0];
    ITILevel *level = [self.levels objectAtIndex:theRow];
    [dataSource updateLevels:level.code];
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
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.view.backgroundColor = background;
    
    ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
    levels = [dataSource getLevels];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.levelPicker = Nil;
    self.levels = Nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    ITILevel *level = [self.levels objectAtIndex:row]; 
    return level.description;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [levels count];
}

- (int) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

@end
