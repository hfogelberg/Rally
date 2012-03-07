//
//  ITIAddResultViewController.m
//  Rally
//
//  Created by Henrik Fogelberg on 2012-01-30.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import "ITIAddResultViewController.h"

@implementation ITIAddResultViewController

@synthesize editDate;
@synthesize dogs;
@synthesize result;
@synthesize selectedDog;
@synthesize dogText;
@synthesize placeText;
@synthesize pointsText;
@synthesize eventDate;
@synthesize dogPicker;
@synthesize pickDate;
@synthesize isCompetitioSeg;
@synthesize positionText;
@synthesize levelTable;
@synthesize levels;

- (void)done:(UIBarButtonItem *)sender{
    
    if(editDate == YES){
        [self hideKeyboards];
    }else{
        if([dogText.text length]==0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NAME", nil)                                                                             message:NSLocalizedString(@"NAME_USED", nil)
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }else{
            ITIAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
            result.comment = delegate.comment;
            delegate.comment = @" ";
            
            NSIndexPath *selectedRowIndex = [levelTable indexPathForSelectedRow];
            ITILevel *selectedLevel = [levels objectAtIndex:selectedRowIndex.row];
            result.level = selectedLevel.code;
            
            NSDate *date = [pickDate date];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            NSString *dateString = [dateFormat stringFromDate:date];
    
            NSString *points = pointsText.text;
            NSString *position = positionText.text;
    
            result.dog_name = dogText.text;
            result.event_date = dateString;
            result.place = placeText.text;
            result.points = [points intValue];
            result.position = [position intValue];
            result.event_date = dateString;
            result.is_competition =[isCompetitioSeg selectedSegmentIndex];
            
            ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
            [dataSource createResult:result];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)changeDogName:(id)sender{
    
    int numDogs = [self.dogs count];
    if(numDogs>0){
        dogPicker.hidden = FALSE;
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ADD_DOG", nil)
                                                        message:NSLocalizedString(@"ADD_DOG_TEXT", nil) 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

// Update the date label when date picker is changed
- (void) dateChanged:(id)sender{
    NSDate *pickerDate = [pickDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *year = [formatter stringFromDate:pickerDate];
    [formatter setDateFormat:@"MM"];
    NSString *month = [formatter stringFromDate:pickerDate];
    [formatter setDateFormat:@"dd"];
    NSString *day = [formatter stringFromDate:pickerDate];
    eventDate.text = [[NSString alloc] initWithFormat:@"%@-%@-%@", year, month, day];
    result.event_date = eventDate.text;
}

// If dog name or event date is tapped prevent keyboard from displaying. Instead display
// date picker or dog list
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    BOOL retVal = TRUE;
    [self hideKeyboards];
    
    if(textField == dogText){
        [placeText resignFirstResponder];
        pickDate.hidden = TRUE;
        dogPicker.hidden = FALSE;
        ITIDog *dog = [dogs objectAtIndex:0];
        dogText.text = dog.name;
        result.dog_id = dog.id;
        result.dog_name = dog.name;
        retVal = FALSE;
    }else if(textField == eventDate){
        [placeText resignFirstResponder];
        dogPicker.hidden = TRUE;
        pickDate.hidden = FALSE;
        editDate = YES;
        self.navigationItem.hidesBackButton = TRUE;
        retVal = FALSE;
    }else if(textField == placeText){
        dogPicker.hidden = TRUE;
        pickDate.hidden = TRUE;
        retVal = TRUE;
    }else if (textField == pointsText){
        [placeText resignFirstResponder];
        [pointsText resignFirstResponder];
        dogPicker.hidden = TRUE;
        pickDate.hidden = TRUE;
        retVal = TRUE;
    }else if (textField == positionText){
        [placeText resignFirstResponder];
        [pointsText resignFirstResponder];
        dogPicker.hidden = TRUE;
        pickDate.hidden = TRUE;
        retVal = TRUE;
    }
    
    return retVal;
}

- (void) backgroundTouched:(id)sender{
    [self hideKeyboards];
}

// Hide pickers and keyboards
- (void) hideKeyboards{
  
    [dogText resignFirstResponder];
    [eventDate resignFirstResponder];
    [pointsText resignFirstResponder];
    [placeText resignFirstResponder];
    editDate = FALSE;
    self.navigationItem.hidesBackButton = FALSE;
    
    dogPicker.hidden = TRUE;
    pickDate.hidden = TRUE;
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

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
/*- (void)loadView
{
}
*/

- (void)viewDidAppear:(BOOL)animated{
    [self getDogs];
}


-(void)awakeFromNib{
    self.title = NSLocalizedString(@"ADD_RESULT", nil);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dogText.placeholder = NSLocalizedString(@"NAME", nil);
    eventDate.placeholder = NSLocalizedString(@"DATE", nil);
    placeText.placeholder = NSLocalizedString(@"LOCATION", nil);
    pointsText.placeholder = NSLocalizedString(@"POINTS", nil);
    positionText.placeholder = NSLocalizedString(@"PLACE", nil);

    [isCompetitioSeg setTitle:NSLocalizedString(@"COMPETITION", nil) forSegmentAtIndex:0];
    [isCompetitioSeg setTitle:NSLocalizedString(@"TRAINING", nil) forSegmentAtIndex:1];
    
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.view.backgroundColor = background;
    
    [self getDogs];
    [self getLevels];
    
    self.result = [[ITIResult alloc] init];
    
    dogText.delegate = self;
    eventDate.delegate = self;
    placeText.delegate = self;
    pointsText.delegate = self;
    positionText.delegate = self;
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *year = [formatter stringFromDate:now];
    [formatter setDateFormat:@"MM"];
    NSString *month = [formatter stringFromDate:now];
    [formatter setDateFormat:@"dd"];
    NSString *day = [formatter stringFromDate:now];
    eventDate.text = [[NSString alloc] initWithFormat:@"%@-%@-%@", year, month, day];
    self.result.event_date = eventDate.text;
    
    [[self.levelTable layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.levelTable layer] setBorderWidth:2.3];
    [[self.levelTable layer] setCornerRadius:15];
    
    [self hideKeyboards];
}

- (void)getLevels{
    ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
    levels = [dataSource getLevels];
}

- (void)getDogs{
     ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
     self.dogs = [dataSource getDogs];   
   
     int numDogs = [self.dogs count];
    
     if (numDogs == 0){
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ADD_DOG", nil)
                                                         message:NSLocalizedString(@"ADD_DOG_TEXT", nil) 
                                                        delegate:nil 
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
         [alert show];
         [self performSegueWithIdentifier:(@"addDogSegue") sender:self];
     }else if(numDogs==1){    
         ITIDog *dog = [self.dogs objectAtIndex:0];
         result.dog_id = dog.id;
         result.dog_name = dog.name;
         self.dogText.text = result.dog_name;
     }
//         else{
//         ITIDog *dog = [self.dogs objectAtIndex:0];
//         result.dog_id = dog.id;
//         result.dog_name = dog.name;
//         self.dogText.text = dog.name;
//     }
    dataSource = Nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Make sure there's no old comment still around;
    ITIAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.comment = @" ";

    self.dogs = Nil;
    self.result = Nil;
    self.selectedDog = Nil;
    self.dogText = Nil;
    self.placeText = Nil;
    self.pointsText = Nil;
    self.eventDate = Nil;
    self.dogPicker = Nil;
    self.pickDate = Nil;
    self.isCompetitioSeg = Nil;
    self.positionText = Nil;
    self.levelTable = Nil;
    self.levels = Nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)componen{        
    int theRow = [dogPicker selectedRowInComponent:0];
    ITIDog *dog = [self.dogs objectAtIndex:theRow];
    dogText.text = dog.name;
    result.dog_id = dog.id;
    result.dog_name = dog.name;
    
    dogPicker.hidden = TRUE;
    pickDate.hidden = TRUE;
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    ITIDog *dog = [self.dogs    objectAtIndex:row];
    return dog.name;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.dogs count];
}

- (int) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.levels count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    ITILevel *level = [levels objectAtIndex:indexPath.row];
    cell.textLabel.text = level.description;
    
    return cell;
}



@end
