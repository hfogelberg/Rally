//
//  ITISignCommentViewController.m
//  Rally
//
//  Created by Henrik Fogelberg on 2012-03-02.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import "ITISignCommentViewController.h"

@implementation ITISignCommentViewController

@synthesize sign;
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
    [super didReceiveMemoryWarning];
    self.sign = Nil;
    self.comment = Nil;
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
    
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.view.backgroundColor = background;
    
    if(comment != Nil)
        self.commentText.text = comment.body;    
    [[self.commentText layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.commentText layer] setBorderWidth:2.3];
    [[self.commentText layer] setCornerRadius:15];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.commentText = Nil;
    self.comment = Nil;
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
    ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
    
    if(comment == nil){
        ITISignComment *newComment = [[ITISignComment alloc] init];
        newComment.body = commentText.text;
        newComment.sign_id = sign.id;
        newComment.body = commentText.text;
        [dataSource createSignComment:newComment];
    }else{
        [dataSource updateSignComment:comment];
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)deleteComment:(id)sender{
    
    ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
    [dataSource deleteSignComment:comment.id];
    
    [self dismissModalViewControllerAnimated:YES];
}

@end
