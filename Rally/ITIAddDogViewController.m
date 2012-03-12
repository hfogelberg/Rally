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
        ITIDog *newDog = [[ITIDog alloc] init];
    
        ITIAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        newDog.comment = delegate.comment;
        delegate.comment = Nil;
        
        newDog.name = nameText.text;
        newDog.breed = breedText.text;
        newDog.dob = dobText.text;
        newDog.height = [heightText.text intValue];
        newDog.isMale = [sexSegm selectedSegmentIndex];
        
        if([newDog.breed length]==0){
            newDog.breed = @" ";
        }
        if([newDog.comment length]==0){
            newDog.comment = @" ";
        }

    [dataSource createDog:newDog];
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
    writeComment.hidden = FALSE;
    editComment.hidden = TRUE;
    
    ITIAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    if(delegate.comment != nil){
        NSString *trimmedComment = [delegate.comment stringByTrimmingCharactersInSet:
                              [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
        if([trimmedComment length]>0){
            writeComment.hidden = TRUE;
            editComment.hidden = FALSE;
        }
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.nameText = Nil;
    self.breedText = Nil;
    self.sexSegm = Nil;
    self.dobText = Nil;
    self.heightText = Nil;
    self.dobPicker = Nil;
}

- (void)viewDidDisappear:(BOOL)animated{
    // Make sure there's no old comment still around;
    ITIAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.comment = Nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
