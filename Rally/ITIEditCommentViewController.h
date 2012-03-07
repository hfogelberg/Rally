//
//  ITIEditCommentViewController.h
//  Rally
//
//  Created by Henrik Fogelberg on 2012-02-16.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITISignComment.h"
#import "ITISignsDataSource.h"
#import <QuartzCore/QuartzCore.h>

@interface ITIEditCommentViewController : UIViewController<UITextViewDelegate>
@property (nonatomic, retain) ITISignComment *comment;
@property (nonatomic, retain) IBOutlet UITextView *commentText;

- (IBAction)closeDialog:(id)sender;
- (IBAction)saveComment:(id)sender;
- (IBAction)deleteComment:(id)sender;

@end
