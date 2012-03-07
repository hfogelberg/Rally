//
//  ITIAddResultViewController.h
//  Rally
//
//  Created by Henrik Fogelberg on 2012-01-30.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITIResult.h"
#import "ITIDog.h"
#import "ITISign.h"
#import "ITISignsDataSource.h"
#import <QuartzCore/QuartzCore.h>
#import "ITIAppDelegate.h"

@interface ITIAddResultViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource, UITableViewDelegate >{
    NSMutableArray *dogs;
    ITIResult *result;
}

@property (nonatomic, assign) BOOL editDate;
@property (nonatomic, retain) NSMutableArray *dogs;
@property (nonatomic, retain) ITIResult *result;
@property (nonatomic, retain) ITIDog *selectedDog;
@property (nonatomic, retain) IBOutlet UITextField *dogText;
@property (nonatomic, retain) IBOutlet UITextField *placeText;
@property (nonatomic, retain) IBOutlet UITextField *pointsText;
@property (nonatomic, retain) IBOutlet UITextField *eventDate;
@property (nonatomic, retain) IBOutlet UIPickerView *dogPicker;
@property (nonatomic, retain) IBOutlet UIDatePicker *pickDate;
@property (nonatomic, retain) IBOutlet UISegmentedControl *isCompetitioSeg;
@property (nonatomic, retain) IBOutlet UITextField *positionText;
@property (nonatomic, retain) IBOutlet UITableView *levelTable;
@property (nonatomic, retain) NSMutableArray *levels;


- (IBAction)backgroundTouched:(id)sender;
- (IBAction)dateChanged:(id)sender;
- (void) hideKeyboards;
- (IBAction)changeDogName:(id)sender;
- (IBAction)done:(UIBarButtonItem *)sender;
- (void) getDogs;
- (void) getLevels;

@end
