//
//  ITIRandomSignDetailController.m
//  Rally
//
//  Created by Henrik Fogelberg on 2012-01-25.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import "ITIRandomSignDetailController.h"

@implementation ITIRandomSignDetailController
@synthesize imageView;
@synthesize sign;

- (void) getNext:(id)sender{
    [self displaySign];
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

- (void)awakeFromNib{
    self.title = NSLocalizedString(@"RANDOM_SIGN", nil);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.view.backgroundColor = background;
    
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Åter" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self displaySign];
}

- (void) displaySign
{
    ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];    
    self.sign = [dataSource getRandomSign];   
    self.imageView.image = self.sign.image;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 5.0;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.imageView = nil;
    self.sign = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"showSignDetailSegue"]) {
        ITISignDetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.sign = sign;
    }
}

@end
