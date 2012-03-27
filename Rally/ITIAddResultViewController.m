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
@synthesize addCommentButton;
@synthesize editCommentButton;
@synthesize dogId;
@synthesize clubText;
@synthesize eventText;
@synthesize commentView;

// Save the result to the database.
// If the date picker or dog picker dismiss when the user taps save. 
// In that case don't save.
- (void)done:(UIBarButtonItem *)sender{
    
    if(editDate == YES){
        [self hideKeyboards];
    }else{
        if([dogText.text length]==0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NAME", nil)                                                                                             
                                                            message:NSLocalizedString(@"NAME_USED", nil)
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }else{
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
            if([placeText.text isEqual: [NSNull null]])
                result.place = @" ";
            else
                result.place = placeText.text;
            result.points = [points intValue];
            result.position = [position intValue];
            result.event_date = dateString;
            result.is_competition =[isCompetitioSeg selectedSegmentIndex];
            if([eventText.text isEqual: [NSNull null]])
                result.event = @" ";
            else    
                result.event = eventText.text;
            if([clubText.text isEqual: [NSNull null]])
                result.club = @" ";
            else
                result.club = clubText.text;
            
            ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
            [dataSource createResult:result];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

// Update the dog name text field when an item is selected in the dog picker.
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

// If dog name or event date is tapped prevent keyboard from displaying. 
// Instead display or dog picker.
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    BOOL retVal = TRUE;
    [self hideKeyboards];
    
    if(textField == dogText){
        [placeText resignFirstResponder];
        if(dogId==0){
            pickDate.hidden = TRUE;
            dogPicker.hidden = FALSE;
            ITIDog *dog = [dogs objectAtIndex:0];
            dogText.text = dog.name;
            result.dog_id = dog.id;
            result.dog_name = dog.name;
        }
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
        [clubText resignFirstResponder];
        [eventText resignFirstResponder];
        dogPicker.hidden = TRUE;
        pickDate.hidden = TRUE;
        retVal = TRUE;
    }else if (textField == positionText){
        [placeText resignFirstResponder];
        [pointsText resignFirstResponder];
        [clubText resignFirstResponder];
        [eventText resignFirstResponder];
        dogPicker.hidden = TRUE;
        pickDate.hidden = TRUE;
        retVal = TRUE;
    }else if (textField == eventText){
        [placeText resignFirstResponder];
        [pointsText resignFirstResponder];
        [positionText resignFirstResponder];
        [clubText resignFirstResponder];
        dogPicker.hidden = TRUE;
        pickDate.hidden = TRUE;
        retVal = TRUE;
    }else if (textField == clubText){
        [placeText resignFirstResponder];
        [pointsText resignFirstResponder];
        [positionText resignFirstResponder];
        [eventText resignFirstResponder];
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
    [positionText resignFirstResponder];
    [eventText resignFirstResponder];
    [clubText resignFirstResponder];
    
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
    [super didReceiveMemoryWarning];
    
    self.dogs = Nil;
    self.result = Nil;
    self.levels = Nil;
}

// Make sure to refresh the dog picker when a new dog has been added.
- (void)viewDidAppear:(BOOL)animated{
    [self getDogs];

    BOOL hasComment = FALSE;
    
    if(commentView != Nil){
        if(commentView.comment != Nil)
        {    result.comment = commentView.comment;
            hasComment = TRUE;
        }
    }
    
    if(hasComment == TRUE){
        self.addCommentButton.hidden = TRUE;
        self.editCommentButton.hidden = FALSE;
    }else{
        self.addCommentButton.hidden = FALSE;
        self.editCommentButton.hidden = TRUE;
    }
}

// Set title bar depending on language
-(void)awakeFromNib{
    self.title = NSLocalizedString(@"ADD_RESULT", nil);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    result = [[ITIResult alloc] init];
    
    clubText.placeholder = NSLocalizedString(@"CLUB",nil);
    dogText.placeholder = NSLocalizedString(@"NAME", nil);
    eventDate.placeholder = NSLocalizedString(@"DATE", nil);
    eventText.placeholder = NSLocalizedString(@"EVENT_NAME", nil);
    placeText.placeholder = NSLocalizedString(@"LOCATION", nil);
    pointsText.placeholder = NSLocalizedString(@"POINTS", nil);
    positionText.placeholder = NSLocalizedString(@"PLACE", nil);

    [isCompetitioSeg setTitle:NSLocalizedString(@"COMPETITION", nil) forSegmentAtIndex:0];
    [isCompetitioSeg setTitle:NSLocalizedString(@"TRAINING", nil) forSegmentAtIndex:1];
    
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.view.backgroundColor = background;
   
    if(dogId > 0){
        ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
        selectedDog = [dataSource getDogById:dogId];
        dogText.text = selectedDog.name;
        result.dog_id = selectedDog.id;
        result.dog_name = selectedDog.name;
    }else{
        [self getDogs];
    }
    
    [self getLevels];

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
    
    pointsText.delegate = self;
    positionText.delegate = self;
    eventDate.delegate = self;
    placeText.delegate = self;
    dogText.delegate = self;
    eventText.delegate = self;
    clubText.delegate = self;
    
    [[self.levelTable layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.levelTable layer] setBorderWidth:2.3];
    [[self.levelTable layer] setCornerRadius:15];

    [self.dogText addTarget:self
                     action:@selector(backgroundTouched:)
           forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.placeText addTarget:self
                       action:@selector(backgroundTouched:)
             forControlEvents:UIControlEventEditingDidEndOnExit];
    
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
    dataSource = Nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];

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
    self.addCommentButton = Nil;
    self.editCommentButton = Nil;
    self.eventText = Nil;
    self.clubText = Nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"addCommentSegue"]){
        self.commentView = segue.destinationViewController;
        
    }else if([[segue identifier] isEqualToString:@"editCommentSegue"]){
        self.commentView = segue.destinationViewController;
        commentView.comment = self.result.comment;
    }
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
