//
//  ITIRandomSignDetailController.h
//  Rally
//
//  Created by Henrik Fogelberg on 2012-01-25.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITISign.h"
#import "ITISignDetailViewController.h"
#import "ITISignsDataSource.h"
#import <QuartzCore/QuartzCore.h>

@interface ITIRandomSignDetailController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, retain) ITISign *sign;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIScrollView *imageScroll;

- (IBAction)getNext:(id)sender;
- (IBAction) displaySign;

@end
