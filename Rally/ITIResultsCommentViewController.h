//
//  ITIResultsCommentViewController.h
//  Rally
//
//  Created by Henrik Fogelberg on 2012-02-26.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ITIResult.h"
#import "ITIAppDelegate.h"
#import "ITISignsDataSource.h"

@interface ITIResultsCommentViewController : UIViewController<UITextViewDelegate>

@property (nonatomic, retain) IBOutlet UIBarButtonItem *saveButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic, retain) IBOutlet UITextView *commentText;
@property (nonatomic, retain) ITIResult *result;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
@end
