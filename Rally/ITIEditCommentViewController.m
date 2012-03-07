//
//  ITIEditCommentViewController.m
//  Rally
//
//  Created by Henrik Fogelberg on 2012-02-16.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import "ITIEditCommentViewController.h"

@implementation ITIEditCommentViewController
@synthesize comment;
@synthesize commentText;

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    CGRect r = CGRectMake (5, 51, 310, 180);
    [commentText setFrame: r];
    commentText.layer.zPosition = 1;
    self.navigationItem.hidesBackButton = YES;
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
    
    self.commentText.text = comment.body;    
    [[self.commentText layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.commentText layer] setBorderWidth:2.3];
    [[self.commentText layer] setCornerRadius:15];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.comment = Nil;
    self.commentText = Nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)closeDialog:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)saveComment:(id)sender{
    comment.body = commentText.text;
    ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
    [dataSource updateSignComment:comment];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)deleteComment:(id)sender{
    
    ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
    [dataSource deleteSignComment:comment.id];

    [self dismissModalViewControllerAnimated:YES];
}

@end
