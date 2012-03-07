//
//  ITIEditDogViewController.m
//  Rally
//
//  Created by Henrik Fogelberg on 2012-01-26.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import "ITIEditDogViewController.h"

@implementation ITIEditDogViewController

@synthesize dog;
@synthesize breedText;
@synthesize sexSegm;
@synthesize dobText;
@synthesize heightText;
@synthesize dobPicker;
@synthesize editDate;
@synthesize resultsButton;
@synthesize editComment;
@synthesize addComment;
@synthesize save;

- (void) done:(UIBarButtonItem *)sender{
    
    if(editDate == YES){
        [self hideKeyboards];
    }else{
        ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
    
        self.dog.breed = breedText.text;
        if([self.dog.breed length]==0){
            self.dog.breed= @" ";
        }
        self.dog.dob = dobText.text;
        self.dog.height  = [heightText.text intValue];
        self.dog.isMale = [sexSegm selectedSegmentIndex];
    
        [dataSource updateDog:self.dog];
        [self.navigationController  popViewControllerAnimated:YES];
    }
}

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

// If dog name or event date is tapped prevent keyboard from displaying. Instead display
// date picker or dog list
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self hideKeyboards];
    if(textField == dobText){
        dobPicker.hidden = FALSE;
        dobPicker.layer.zPosition = 1;
        self.navigationItem.hidesBackButton = TRUE;
        return false;
    }
    return true;
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
    
    self.navigationItem.title = self.dog.name;
    
    NSString *trimmedBreed = [dog.breed stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *trimmedComment = [dog.comment stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([trimmedBreed length]>0)
        self.breedText.text = self.dog.breed;
    self.dobText.text = self.dog.dob;
    if(self.dog.height>0)
        self.heightText.text = [NSString stringWithFormat:@"%d", self.dog.height];
    self.sexSegm.selectedSegmentIndex = self.dog.isMale;
    
    [sexSegm setTitle:NSLocalizedString(@"FEMALE", nil) forSegmentAtIndex:0];
    [sexSegm setTitle:NSLocalizedString(@"MALE", nil) forSegmentAtIndex:1];
    breedText.placeholder = NSLocalizedString(@"BREED", nil);
    dobText.placeholder = NSLocalizedString(@"DOB", nil);
    heightText.placeholder = NSLocalizedString(@"HEIGHT", nil);
    
    dobPicker.hidden = TRUE;
    dobText.delegate = self;    
    heightText.delegate = self;
    breedText.delegate = self;
    
    if([self dogHasResults]==NO)
        resultsButton.hidden = TRUE;
    else
        resultsButton.hidden = FALSE;
    

    if([trimmedComment length]==0){
        addComment.hidden = FALSE;
        addComment.layer.zPosition = 1;
        editComment.hidden = TRUE;
    }else{
        addComment.hidden = TRUE;
        editComment.hidden = FALSE;
        editComment.layer.zPosition = 1;
    }
    
    [self hideKeyboards];
}

- (void)deleteDog:(id)sender{
    NSMutableString *messageText;
    
    
    if([self dogHasResults]==YES)
        messageText = [[NSMutableString alloc] initWithString:NSLocalizedString(@"DROP_DOG_RESULTS", nil)];
    else
       messageText = [[NSMutableString alloc] initWithString:NSLocalizedString(@"DROP_DOG", nil)];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DROP_DOG_HEADER", nil)
                                                    message:messageText 
                                                   delegate:self 
                                          cancelButtonTitle:NSLocalizedString(@"NO", nil)
                                          otherButtonTitles:NSLocalizedString(@"YES", nil)];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if(title==@"Ja")
    {
        ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
        [dataSource deleteDog:dog.id];
        [self.navigationController  popViewControllerAnimated:YES];
    }
}

- (BOOL) dogHasResults{
    ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
    return [dataSource dogHasResults:dog.id];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Make sure there's no old comment still around;
    ITIAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.comment = @" ";
    
    self.dog = Nil;
    self.breedText = Nil;
    self.sexSegm = Nil;
    self.dobText = Nil;
    self.heightText = Nil;
    self.dobPicker = Nil;
    self.resultsButton = Nil;
    self.editComment = Nil;
    self.addComment = Nil;
}

- (void)backgroundTouched:(id)sender{
    [self hideKeyboards];
}

- (void)hideKeyboards{
    [heightText resignFirstResponder];
    [breedText resignFirstResponder];
    dobPicker.hidden = TRUE;
    self.navigationItem.hidesBackButton = FALSE;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier]isEqualToString:@"showDogResultsSegue"]){
        ITIResultsViewController *destination = segue.destinationViewController;
        destination.dogId = self.dog.id;
    }else if([[segue identifier] isEqualToString:@"addCommentSegue"]){
        ITIDogCommentViewController *destination = segue.destinationViewController;
        destination.dog = dog;
        
    }else if([[segue identifier] isEqualToString:@"editCommentSegue"]){
        ITIDogCommentViewController *destination = segue.destinationViewController;
        destination.dog = dog; 
    }
}

@end
