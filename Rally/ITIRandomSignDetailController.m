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

// Move to the next sign when Next is tapped
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
    [super didReceiveMemoryWarning];
    self.sign = Nil;
    self.imageView.image = Nil;
}

// Set the tab bar depending on language
- (void)awakeFromNib{
    self.title = NSLocalizedString(@"RANDOM_SIGN", nil);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.view.backgroundColor = background;

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
