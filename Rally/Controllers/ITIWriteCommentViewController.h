//
//  ITIWriteCommentViewController.h
//  Rally
//
//  Created by Henrik Fogelberg on 2012-02-16.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITISignComment.h"
#import "ITISign.h"
#import "ITISignsDataSource.h"
#import <QuartzCore/QuartzCore.h>

@interface ITIWriteCommentViewController : UIViewController

@property (nonatomic, retain) ITISign *sign;
@property (nonatomic, retain) IBOutlet UITextView *commentText;

- (IBAction)closeDialog:(id)sender;
- (IBAction)saveComment:(id)sender;

@end
