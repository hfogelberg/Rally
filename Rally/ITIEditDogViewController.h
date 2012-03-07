//
//  ITIEditDogViewController.h
//  Rally
//
//  Created by Henrik Fogelberg on 2012-01-26.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITIDog.h"
#import "ITISignsDataSource.h"
#import "ITIResultsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ITIAppDelegate.h"
#import "ITIDogCommentViewController.h"

@interface ITIEditDogViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate, UIAlertViewDelegate>{
    ITIDog *dog;
}

@property (nonatomic, retain) ITIDog *dog;
@property (nonatomic, retain) IBOutlet UITextField *breedText;
@property (nonatomic, retain) IBOutlet UITextField *dobText;
@property (nonatomic, retain) IBOutlet UISegmentedControl *sexSegm;
@property (nonatomic, retain) IBOutlet UITextField *heightText;
@property (nonatomic, retain) IBOutlet UIDatePicker *dobPicker;
@property (nonatomic, retain) IBOutlet UIButton *resultsButton;
@property (nonatomic, retain) IBOutlet UIButton *addComment;
@property (nonatomic, retain) IBOutlet UIButton *editComment;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *save;
@property (nonatomic, assign) BOOL editDate;

- (IBAction) dateChanged:(id)sender;
- (IBAction)done:(UIBarButtonItem *)sender;
- (IBAction)backgroundTouched:(id)sender;
- (IBAction)deleteDog:(id)sender;
- (void) hideKeyboards;
- (BOOL) dogHasResults;

@end
