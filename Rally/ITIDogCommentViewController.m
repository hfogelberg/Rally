//
//  ITIDogCommentViewController.m
//  Rally
//
//  Created by Henrik Fogelberg on 2012-02-27.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import "ITIDogCommentViewController.h"

@implementation ITIDogCommentViewController

@synthesize saveButton;
@synthesize cancelButton;
@synthesize commentText;
@synthesize dog;

// Resize the text wiew when editing begins
- (void)textViewDidBeginEditing:(UITextView *)textView{
    CGRect r = CGRectMake (5, 55, 310, 360);
    [commentText setFrame: r];
    commentText.layer.zPosition = 1;
    self.navigationItem.hidesBackButton = FALSE;

}

-(void)cancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Save comment to Db if we have a dog id.
// Oterwise save the comment in the app delegate.
- (void)save:(id)sender{
    
    if(dog.id>0){
        ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
        dog.comment = commentText.text;
        [dataSource addDogComment:dog];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.view.backgroundColor = background;
    
    ITIAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    if(dog){
        commentText.text = dog.comment;
    }else if(delegate.comment){
        commentText.text = delegate.comment;
    }
    
    [self.commentText setDelegate:self];
    
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
    self.dog = Nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
