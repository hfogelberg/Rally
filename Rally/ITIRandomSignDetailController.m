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
@synthesize imageScroll;

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
    
    self.imageScroll.contentSize = CGSizeMake(320, 10000);
    self.imageScroll.layer.masksToBounds = YES;
    self.imageScroll.layer.cornerRadius = 5.0;
    
    [self displaySign];}

- (void) displaySign
{
    ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];    
    self.sign = [dataSource getRandomSign];   
    self.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.sign.signFile ofType:nil]];
    self.navigationItem.title = self.sign.level;
    int imageStart = (self.sign.imageOrderId * 220) - 220;
    
    CGPoint offSet = CGPointMake(0, imageStart);
    [imageScroll setContentOffset:offSet];   
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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
        detailViewController.disableSwipe = TRUE;
    }
}

@end
