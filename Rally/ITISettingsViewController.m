//
//  ITISettingsViewController.m
//  Rally
//
//  Created by Henrik Fogelberg on 2012-02-06.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import "ITISettingsViewController.h"

@implementation ITISettingsViewController
@synthesize levelField;
@synthesize orgField;
@synthesize settings;
@synthesize levelLabel;
@synthesize organisationLabel;

// Dismiss keyboard. Instead the picker will be displayed
- (void)textFieldDidBeginEditing:(UITextField *)textField{    
    [orgField resignFirstResponder];
    [levelField resignFirstResponder];
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

// Set text in tab bar depending on localization
- (void)awakeFromNib{
    self.title = NSLocalizedString(@"SETTINGS", nil);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    organisationLabel.text = NSLocalizedString(@"ORGANISATION", nil);
    levelLabel.text = NSLocalizedString(@"LEVEL", nil);
    
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.view.backgroundColor = background;
    orgField.delegate = self;
    levelField.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated{
    ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
    settings = [[ITISettings alloc] init];
    settings = [dataSource getSettingsOverview];
    
    orgField.text = settings.organisation;
    levelField.text = settings.levelDescription;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.levelField=Nil;
    self.orgField=Nil;
    self.settings=Nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

}

@end
