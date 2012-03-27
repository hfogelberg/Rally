//
//  ITIAddDogViewController.m
//  Rally
//
//  Created by Henrik Fogelberg on 2012-01-26.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import "ITIAddDogViewController.h"

@implementation ITIAddDogViewController

@synthesize nameText;
@synthesize breedText;
@synthesize sexSegm;
@synthesize dobText;
@synthesize heightText;
@synthesize dobPicker;
@synthesize editDate;
@synthesize writeComment;
@synthesize editComment;
@synthesize commentView;
@synthesize dog;

// Update the date label when date picker is changed
- (void) dateChanged:(id)sender{
    NSDate *pickerDate = [dobPicker date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *year = [formatter stringFromDate:pickerDate];
    [formatter setDateFormat:@"MM"];
    NSString *month = [formatter stringFromDate:pickerDate];
    [formatter setDateFormat:@"dd"];
    NSString *day = [formatter stringFromDate:pickerDate];
    dobText.text = [[NSString alloc] initWithFormat:@"%@-%@-%@", year, month, day];

}

// If dog name or event date is tapped prevent keyboard from displaying. Instead display date picker or dog picker
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self hideKeyboards];
    if(textField == dobText){
        dobPicker.hidden = FALSE;
        dobPicker.layer.zPosition = 1;
        editDate = YES;
        self.navigationItem.hidesBackButton = TRUE;
        return false;
    }
    return true;
}

- (void)backgroundTouched:(id)sender{
    [self hideKeyboards];
}

- (void)hideKeyboards{
    editDate = NO;
    [nameText resignFirstResponder];
    [heightText resignFirstResponder];
    [breedText resignFirstResponder];
    dobPicker.hidden = TRUE;
    self.navigationItem.hidesBackButton = FALSE;
}

// Save dog to Db and dismiss detail view
- (void) done:(UIBarButtonItem *)sender{
    if(editDate == YES){
        [self hideKeyboards];
    }else{
        [self saveDog];
        [self.navigationController  popViewControllerAnimated:YES];
    }
}

// Called when Save-button in panel is pushed.
// Only used if user is trying to add a a result before a dog is defined.
- (void)save:(id)sender{
    [self saveDog];
    [self dismissModalViewControllerAnimated:YES];
}

// Validate and save
- (void)saveDog{
    
    ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
    
    if([self.nameText.text length]==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NAME", nil)
                                                        message:NSLocalizedString(@"MISSED_NAME", nil)
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else if([dataSource dogNameIsNotUnique:self.nameText.text]== YES){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NAME", nil)
                                                        message:NSLocalizedString(@"NAME_USED", nil)
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else{
        dog.name = nameText.text;
        dog.breed = breedText.text;
        dog.dob = dobText.text;
        dog.height = [heightText.text intValue];
        dog.isMale = [sexSegm selectedSegmentIndex];
        
        if([dog.breed length]==0){
            dog.breed = @" ";
        }
        if([dog.comment length]==0){
            dog.comment = @" ";
        }

        [dataSource createDog:dog];
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
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)awakeFromNib{
    self.title = NSLocalizedString(@"ADD_DOG", nil);
}

// Make sure that the correct comment icon is displayed
- (void)viewDidAppear:(BOOL)animated{
    BOOL hasComment = FALSE;
    
    if(commentView != Nil){
        if(commentView.comment != Nil)
        {    dog.comment = commentView.comment;
            hasComment = TRUE;
        }
    }
        
    if(hasComment == TRUE){
        self.writeComment.hidden = TRUE;
        self.editComment.hidden = FALSE;
    }else{
        self.writeComment.hidden = FALSE;
        self.editComment.hidden = TRUE;
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dog  = [[ITIDog alloc] init];
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.view.backgroundColor = background;
    
    dobPicker.hidden = TRUE;
    
    breedText.placeholder = NSLocalizedString(@"BREED", nil);
    dobText.placeholder = NSLocalizedString(@"DOB", nil);
    heightText.placeholder = NSLocalizedString(@"HEIGHT", nil);
    nameText.placeholder = NSLocalizedString(@"NAME", nil);
    
    [sexSegm setTitle:NSLocalizedString(@"FEMALE", nil) forSegmentAtIndex:0];
    [sexSegm setTitle:NSLocalizedString(@"MALE", nil) forSegmentAtIndex:1];
    
    dobText.delegate = self;
    nameText.delegate = self;
    breedText.delegate = self;
    heightText.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier]isEqualToString:@"addCommentSegue"]){
        commentView = segue.destinationViewController;
    }else if([[segue identifier]isEqualToString:@"editCommentSegue"]){
        commentView = segue.destinationViewController;
        commentView.comment = dog.comment;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.nameText = Nil;
    self.breedText = Nil;
    self.sexSegm = Nil;
    self.dobText = Nil;
    self.heightText = Nil;
    self.dobPicker = Nil;
    self.dog = Nil;
    self.commentView = Nil;
}

- (void)viewDidDisappear:(BOOL)animated{

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
