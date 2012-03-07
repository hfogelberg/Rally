//
//  ITIEditResultViewController.m
//  Rally
//
//  Created by Henrik Fogelberg on 2012-02-01.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import "ITIEditResultViewController.h"

@implementation ITIEditResultViewController

@synthesize editDate;
@synthesize dogs;
@synthesize result;
@synthesize selectedDog;
@synthesize dogText;
@synthesize placeText;
@synthesize pointsText;
@synthesize eventDate;
@synthesize pickDog;
@synthesize pickDate;
@synthesize isCompetitioSeg;
@synthesize positionText;
@synthesize addCommentButton;
@synthesize editCommentButton;
@synthesize levels;
@synthesize levelsTable;

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
    
    [self hideKeyboards];
}

- (void) backgroundTouched:(id)sender{
    [self hideKeyboards];
}


- (void) hideKeyboards{
    [placeText resignFirstResponder];
    [dogText resignFirstResponder];
    [eventDate resignFirstResponder];
    [pointsText resignFirstResponder];
    [placeText resignFirstResponder];
    [positionText resignFirstResponder];
    self.navigationItem.hidesBackButton = FALSE;
    
    editDate = NO;
    pickDog.hidden = TRUE;
    pickDate.hidden = TRUE;
}

// If dog name or event date is tapped prevent keyboard from displaying. Instead display
// date picker or dog list
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    BOOL retVal = TRUE;
    
    if(textField == dogText){
        [placeText resignFirstResponder];
        [pointsText resignFirstResponder];
        pickDate.hidden = TRUE;
        pickDog.hidden = FALSE;
        retVal = FALSE;
    }else if(textField == eventDate){
        [placeText resignFirstResponder];
        [pointsText resignFirstResponder];
        pickDog.hidden = TRUE;
        pickDate.hidden = FALSE;
        pickDate.layer.zPosition = 1;
        editDate = YES;
        self.navigationItem.hidesBackButton = TRUE;
        retVal = FALSE;
    }else if(textField == placeText){
        [pointsText resignFirstResponder];
        pickDog.hidden = TRUE;
        pickDate.hidden = TRUE;
    }else if (textField == pointsText){
        [placeText resignFirstResponder];
        [positionText resignFirstResponder];
        pickDog.hidden = TRUE;
        pickDate.hidden = TRUE;
    }else if (textField == positionText){
        [placeText resignFirstResponder];
        [pointsText resignFirstResponder];
        pickDog.hidden = TRUE;
        pickDate.hidden = TRUE;
    }
        
    return retVal;
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
    
    dogText.placeholder = NSLocalizedString(@"DOG", nil);
    eventDate.placeholder = NSLocalizedString(@"DATE", nil);
    placeText.placeholder = NSLocalizedString(@"LOCATION", nil);
    pointsText.placeholder = NSLocalizedString(@"RESULT", nil);
    positionText.placeholder = NSLocalizedString(@"PLACE", nil);
    
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.view.backgroundColor = background;
    
    [self getLevels];
    [self getDogs];
    
    NSString *trimmedComment = [result.comment stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *trimmedPlace = [result.place stringByTrimmingCharactersInSet:
                                [NSCharacterSet whitespaceAndNewlineCharacterSet]];

    dogText.text = self.result.dog_name;
    if([trimmedPlace length]>0)
        placeText.text = self.result.place;
    if(self.result.points>0)
        pointsText.text = [NSString stringWithFormat:@"%d", self.result.points];
    if(self.result.position>0)
        positionText.text = [NSString stringWithFormat:@"%d", self.result.position];
    eventDate.text = self.result.event_date;
    
    isCompetitioSeg.selectedSegmentIndex = self.result.is_competition;
    
    [isCompetitioSeg setTitle:NSLocalizedString(@"COMPETITION", nil) forSegmentAtIndex:0];
    [isCompetitioSeg setTitle:NSLocalizedString(@"TRAINING", nil) forSegmentAtIndex:1];
    
    NSString *title =  [NSString stringWithFormat:@"%@ %@ %@", self.result.dog_name, self.result.place, self.result.event_date];
    self.navigationItem.title = title; 
    
    dogText.delegate = self;
    eventDate.delegate = self;
    placeText.delegate = self;
    pointsText.delegate = self;
    positionText.delegate = self;
    
    if([trimmedComment length]==0){
        addCommentButton.hidden = FALSE;
        addCommentButton.layer.zPosition = 1;
        editCommentButton.hidden = TRUE;
    }else{
        addCommentButton.hidden = TRUE;
        editCommentButton.hidden = FALSE;
        editCommentButton.layer.zPosition = 1;
    }
    
    [[self.levelsTable layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.levelsTable layer] setBorderWidth:2.3];
    [[self.levelsTable layer] setCornerRadius:15];
}

- (void)getDogs{
    ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
    self.dogs = [dataSource getDogs];
    
    int numDogs = [self.dogs count];
    if(numDogs==1){
        ITIDog *dog = [self.dogs objectAtIndex:0];
        result.dog_id = dog.id;
        result.dog_name = dog.name;
        dogText.text = dog.name;
    }else if (numDogs == 0){
        dogText .text = @"";
    }else{
        pickDog.hidden = YES;
    }
}

- (void)getLevels{
    ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
    levels = [dataSource getLevels];
}

- (void)deleteResult:(id)sender{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DROP_RESULT_HEADER", nil)
                                                      message:NSLocalizedString(@"DROP_RESULT", nil)
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"NO", nil)
                                            otherButtonTitles:NSLocalizedString(@"YES", nil), nil];
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if(title==@"Ja"){
        ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
        [dataSource deleteResult:result.id];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)done:(UIBarButtonItem *)sender{
    
    if(editDate == YES){
        [self hideKeyboards];
    }else{
        ITIAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        result.comment = delegate.comment;
        delegate.comment = @" ";
        
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
    
        ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
        [dataSource updateResults:result];
        [self.navigationController popViewControllerAnimated:YES];
    }
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
    self.pickDog = Nil;
    self.pickDate = Nil;
    self.isCompetitioSeg = Nil;
    self.positionText = Nil;
    self.addCommentButton = Nil;
    self.editCommentButton = Nil;
    self.levels = Nil;
    self.levelsTable = Nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)componen{        
    int theRow = [pickDog selectedRowInComponent:0];
    ITIDog *dog = [self.dogs objectAtIndex:theRow];
    dogText.text = dog.name;
    result.dog_id = dog.id;
    result.dog_name = dog.name;
    
    pickDog.hidden = TRUE;
    pickDate.hidden = TRUE;
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    ITIDog *dog = [dogs objectAtIndex:row];
    return dog.name;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.dogs count];
}

- (int) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"editCommentSegue"]){
        ITIResultsCommentViewController *destination = segue.destinationViewController;
        destination.result = self.result;
    }else if([[segue identifier] isEqualToString:@"addCommentSegue"]){
        ITIResultsCommentViewController *destination = segue.destinationViewController;
        destination.result = self.result;
    }
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
    if(level.code == result.level)
        [levelsTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    return cell;
}
@end