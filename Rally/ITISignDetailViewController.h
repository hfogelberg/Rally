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
#import "ITIImageStore.h"

@interface ITISignDetailViewController : UIViewController<UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (nonatomic, retain) ITISign *sign;
@property (nonatomic, retain) ITISignComment *signComment;
@property (nonatomic, retain) IBOutlet UITextView *descriptionText;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *commentButton;
@property (nonatomic, retain) NSMutableArray *signs;
@property (nonatomic, assign) int signId;
@property (nonatomic, retain) IBOutlet UIScrollView *imageScroll;

- (void) displaySign;
- (void) getSignComment;

@end
