//
//  ITIEditResultViewController.h
//  Rally
//
//  Created by Henrik Fogelberg on 2012-02-01.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITIResult.h"
#import "ITIDog.h"
#import "ITISign.h"
#import "ITISignsDataSource.h"
#import <QuartzCore/QuartzCore.h>
#import "ITIResultsCommentViewController.h"

@interface ITIEditResultViewController : UIViewController  <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>{
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
@property (nonatomic, retain) IBOutlet UIPickerView *pickDog;
@property (nonatomic, retain) IBOutlet UIDatePicker *pickDate;
@property (nonatomic, retain) IBOutlet UISegmentedControl *isCompetitioSeg;
@property (nonatomic, retain) IBOutlet UITextField *positionText;
@property (nonatomic, retain) IBOutlet UIButton *addCommentButton;
@property (nonatomic, retain) IBOutlet UIButton *editCommentButton;
@property (nonatomic, retain) IBOutlet UITableView *levelsTable;
@property (nonatomic, retain) NSMutableArray *levels;

- (IBAction) backgroundTouched:(id)sender;
- (IBAction) dateChanged:(id)sender;
- (void) hideKeyboards;
- (IBAction)done:(UIBarButtonItem *)sender;
- (void) getLevels;
- (void) getDogs;
- (IBAction)deleteResult:(id)sender;

@end
