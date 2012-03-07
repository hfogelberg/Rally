//
//  ITIWriteCommentViewController.m
//  Rally
//
//  Created by Henrik Fogelberg on 2012-02-16.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import "ITIWriteCommentViewController.h"

@implementation ITIWriteCommentViewController
@synthesize sign;
@synthesize commentText;

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
    
    [[self.commentText layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.commentText layer] setBorderWidth:2.3];
    [[self.commentText layer] setCornerRadius:15];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.sign = nil;
    self.commentText = nil;
}

- (void)saveComment:(id)sender{
    ITISignComment *comment = [[ITISignComment alloc] init];
    comment.sign_id = sign.id;
    comment.body = commentText.text;
    ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
    [dataSource createSignComment:comment];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)closeDialog:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)delete:(id)sender{
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
