//
//  ITIResultsCommentViewController.m
//  Rally
//
//  Created by Henrik Fogelberg on 2012-02-26.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import "ITIResultsCommentViewController.h"

@implementation ITIResultsCommentViewController

@synthesize saveButton;
@synthesize cancelButton;
@synthesize commentText;
@synthesize result;


- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    CGRect r = CGRectMake (5, 55, 310, 180);
    [commentText setFrame: r];
    commentText.layer.zPosition = 1;
    self.navigationItem.hidesBackButton = TRUE;
}

-(void)cancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)save:(id)sender{
    
    if(result.id>0){
        ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
        result.comment = commentText.text;
        [dataSource saveResultComment:result];
    }else{
        ITIAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        delegate.comment = commentText.text;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    commentText.delegate = self;
    commentText.text = result.comment;
    
    // Make a border around the comment text area.
    [[self.commentText layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.commentText layer] setBorderWidth:2.3];
    [[self.commentText layer] setCornerRadius:15];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.saveButton = Nil;
    self.cancelButton = Nil;
    self.commentText = Nil;
    self.result = Nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
