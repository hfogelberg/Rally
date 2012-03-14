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
@synthesize dogId;
@synthesize comment;

// Resize the text wiew when editing begins
- (void)textViewDidBeginEditing:(UITextView *)textView{
    CGRect r = CGRectMake (5, 55, 310, 180);
    [commentText setFrame: r];
    commentText.layer.zPosition = 1;
    self.navigationItem.hidesBackButton = FALSE;

}

-(void)cancel:(id)sender{
    self.commentText.text = @"";
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Save comment to Db if we have a dog id.
// Oterwise save the comment in the app delegate.
- (void)save:(id)sender{
    
    comment = commentText.text;
    if(dogId>0){
        ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
        NSLog(@"Save comment %d %@", dogId, comment);
        [dataSource saveDogComment:dogId :comment];
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
    comment = Nil;
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.view.backgroundColor = background;
       
    
    self.commentText.delegate = self;
    
    if(dogId>0){
        ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
        ITIDog *dog = [dataSource getDogById:dogId];
        comment = dog.comment;
    }
        
    NSLog(@"Dog comment loading: %@", comment);    
    self.commentText.text = comment;
    
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
