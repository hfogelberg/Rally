//
//  ITIDogCommentViewController.h
//  Rally
//
//  Created by Henrik Fogelberg on 2012-02-27.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>
#import "ITIDog.h"
#import "ITIAppDelegate.h"
#import "ITISignsDataSource.h"

@interface ITIDogCommentViewController : UIViewController<UITextViewDelegate>

@property (nonatomic, retain) IBOutlet UIBarButtonItem *saveButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic, retain) IBOutlet UITextView *commentText;
@property (nonatomic, retain) ITIDog *dog;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
