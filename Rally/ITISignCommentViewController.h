//
//  ITISignCommentViewController.h
//  Rally
//
//  Created by Henrik Fogelberg on 2012-03-02.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITISignComment.h"
#import "ITISignsDataSource.h"
#import <QuartzCore/QuartzCore.h>

@interface ITISignCommentViewController : UIViewController

@property (nonatomic, retain) ITISign *sign;
@property (nonatomic, retain) ITISignComment *comment;
@property (nonatomic, retain) IBOutlet UITextView *commentText;

- (IBAction)closeDialog:(id)sender;
- (IBAction)saveComment:(id)sender;
- (IBAction)deleteComment:(id)sender;

@end
