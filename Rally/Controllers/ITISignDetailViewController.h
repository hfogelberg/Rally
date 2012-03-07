//
//  ITISignDetailViewController.h
//  Rally
//
//  Created by Henrik Fogelberg on 2012-01-25.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITISign.h"
#import "ITISignsDataSource.h"
#import <QuartzCore/QuartzCore.h>
#import "ITISignComment.h"
#import "ITISignCommentViewController.h"

@interface ITISignDetailViewController : UIViewController<UIGestureRecognizerDelegate>

@property (nonatomic, retain) ITISign *sign;
@property (nonatomic, retain) ITISignComment *signComment;
@property (nonatomic, retain) IBOutlet UITextView *descriptionText;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *commentButton;

- (void) displaySign;
- (void) getSignComment;

@end
