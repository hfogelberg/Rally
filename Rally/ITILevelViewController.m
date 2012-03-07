//
//  ITILevelViewController.m
//  Rally
//
//  Created by Henrik Fogelberg on 2012-02-21.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import "ITILevelViewController.h"

@implementation ITILevelViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    int level;
    
    if([[segue identifier] isEqualToString:@"beginnerSegue"]){
        level = 1;
    }else if ([[segue identifier] isEqualToString:@"continuedSegue"]){
        level = 2;
    }else if ([[segue identifier] isEqualToString:@"advancedSegue"]){
        level = 3;
    }else if ([[segue identifier] isEqualToString:@"masterSegue"]){
        level = 4;
    }
    
    ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];    
    [dataSource updateLevels:level];
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

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Välj nivå";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Åter" style:UIBarButtonItemStylePlain target:nil action:nil];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
