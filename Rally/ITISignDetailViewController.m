//
//  ITISignDetailViewController.m
//  Rally
//
//  Created by Henrik Fogelberg on 2012-01-25.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import "ITISignDetailViewController.h"

@implementation ITISignDetailViewController

@synthesize sign;
@synthesize descriptionText;
@synthesize imageView;
@synthesize commentButton;
@synthesize signComment;


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

// Make sure the correct comment butt on is displaye
- (void) viewWillAppear:(BOOL)animated{
    [self displaySign];
}

// Display corret button depending on if the sign has a comment or not.
- (void)getSignComment{
    ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
    NSLog(@"Sign id %d", sign.id);
    signComment = [dataSource getSignComment:sign.id];
    if(signComment == nil){
        commentButton.image = [UIImage imageNamed:@"toolpen.png"];
    }else{
        commentButton.image = [UIImage imageNamed:@"toolnote.png"];
    }
}

// Set text fields and display image
- (void)displaySign{
    self.navigationItem.title = self.sign.header;
    self.descriptionText.text = self.sign.body;
    self.imageView.image = self.sign.image;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 5.0;
    
    [self getSignComment];
}

- (void)viewDidLoad
{
    [super viewDidLoad]; 
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.view.backgroundColor = background;
    
    UISwipeGestureRecognizer *swipeRecognizer;
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetectedLeft:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeRecognizer];

    swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetectedRight:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRecognizer];
}

- (IBAction)swipeDetectedLeft:(UIGestureRecognizer *)sender {    
    ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
    self.sign = [dataSource getNextSign:sign.id];
    [self displaySign];
}

- (IBAction)swipeDetectedRight:(UIGestureRecognizer *)sender {    
    ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
    self.sign = [dataSource getPreviousSign:sign.id];
    [self displaySign];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.sign = Nil;
    self.descriptionText = Nil;
    self.imageView = Nil;
    self.signComment = Nil;
    self.commentButton = Nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue   identifier] isEqualToString:@"signCommentSegue"]){
        ITISignCommentViewController *destination = segue.destinationViewController;
        destination.sign = sign;
        if(signComment != nil)
            destination.comment = signComment;
    }
    
}

@end
