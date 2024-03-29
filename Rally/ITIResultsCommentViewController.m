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
@synthesize resultId;
@synthesize comment;

// Resize text view when editing
- (void)textViewDidBeginEditing:(UITextView *)textView{
    CGRect r = CGRectMake (5, 55, 310, 180);
    [commentText setFrame: r];
    commentText.layer.zPosition = 1;
    self.navigationItem.hidesBackButton = FALSE;
}

-(void)cancel:(id)sender{
    commentText.text = @"";
    [self dismissViewControllerAnimated:YES completion:nil];
}

// If there is a result id update Db.
// Otherwise save comment in app delegate
- (void)save:(id)sender{
    
    self.comment = self.commentText.text;
    if(self.resultId>0){
        ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
        [dataSource saveResultComment :self.comment :self.resultId];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)deleteComment:(id)sender{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DROP_COMMENT_HEADER", nil)
                                                      message:NSLocalizedString(@"DROP_COMMENT", nil)
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"NO", nil)
                                            otherButtonTitles:NSLocalizedString(@"YES", nil), nil];
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if([alertView buttonTitleAtIndex:buttonIndex]==NSLocalizedString(@"YES", nil))
    {
        self.comment = nil;
        self.commentText.text = @"";
        if(resultId>0){
            ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
            [dataSource deleteResultComment:resultId];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.view.backgroundColor = background;

    self.commentText.delegate = self;
    
    if(self.resultId>0){
        ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
        self.comment = [dataSource getResultComment:self.resultId];
    }
    
    self.commentText.text = self.comment;
    
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
