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
@synthesize signs;
@synthesize signId;
@synthesize imageScroll;
@synthesize disableSwipe;

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
    NSLog(@"Memory warning");
    self.sign = Nil;
    self.signComment = Nil;
}

- (void)viewDidAppear:(BOOL)animated{
    [self getSignComment];
}

// Display corret button depending on if the sign has a comment or not.
- (void)getSignComment{
    ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
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
    int imageStart = (self.sign.imageOrderId * 220) - 220;
   
    CGPoint offSet = CGPointMake(0, imageStart);
    [imageScroll setContentOffset:offSet];    
    [self getSignComment];
}

- (void)viewDidLoad
{
    [super viewDidLoad]; 
    NSLog(@"View did load");
    //NSString *imageFile = [[ITIImageStore sharedInstance] image];
    //NSLog(@"Image file %@", imageFile);

    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.view.backgroundColor = background;
    
    self.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.sign.signFile ofType:nil]];
    
    self.imageScroll.contentSize = CGSizeMake(320, 10000);
    self.imageScroll.layer.masksToBounds = YES;
    self.imageScroll.layer.cornerRadius = 5.0;
    
    if(disableSwipe == FALSE){
        UISwipeGestureRecognizer *swipeRecognizer;
    
        swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetectedLeft:)];
        swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:swipeRecognizer];

        swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetectedRight:)];
        swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:swipeRecognizer];
    }
    
   [self displaySign];
}

- (IBAction)swipeDetectedLeft:(UIGestureRecognizer *)sender {    
   
    ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
    int id = self.sign.imageOrderId;
    self.sign = Nil;
    self.signComment = Nil;
    self.sign = [dataSource getNextSign:id];
    [self displaySign];

}

- (IBAction)swipeDetectedRight:(UIGestureRecognizer *)sender {    

    ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
    int id = self.sign.imageOrderId;
    self.sign = Nil;
    self.signComment = Nil;
    self.sign = [dataSource getPreviousSign:id];
    dataSource = nil;
    [self displaySign];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.sign = Nil;
    self.descriptionText = Nil;
    self.imageView = Nil;
    self.commentButton = Nil;
    self.signComment = Nil;
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
