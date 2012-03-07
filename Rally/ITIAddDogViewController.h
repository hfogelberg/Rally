//
//  ITIAddDogViewController.h
//  Rally
//
//  Created by Henrik Fogelberg on 2012-01-26.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ITIDog.h"
#import "ITISignsDataSource.h"
#import "ITIAppDelegate.h"


@interface ITIAddDogViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, retain) IBOutlet UITextField *nameText;
@property (nonatomic, retain) IBOutlet UITextField *breedText;
@property (nonatomic, retain) IBOutlet UITextField *dobText;
@property (nonatomic, retain) IBOutlet UISegmentedControl *sexSegm;
@property (nonatomic, retain) IBOutlet UITextField *heightText;
@property (nonatomic, retain) IBOutlet UIDatePicker *dobPicker;
@property (nonatomic, assign) BOOL editDate;
@property (nonatomic, retain) IBOutlet UIButton *writeComment;
@property (nonatomic, retain) IBOutlet UIButton *editComment;

- (IBAction) dateChanged:(id)sender;
- (IBAction)done:(UIBarButtonItem *)sender;
- (IBAction)backgroundTouched:(id)sender;
- (BOOL) dogNameIsNotUnique;
- (void) hideKeyboards;
- (IBAction)save:(id)sender;
- (void) saveDog;

@end
