//
//  ITIDogDetailViewController.h
//  Rally
//
//  Created by Henrik Fogelberg on 2012-01-25.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITIDog.h"

@interface ITIDogDetailViewController : UIViewController

@property (nonatomic, retain) ITIDog *dog;
@property (nonatomic, retain) UILabel *nameText;
@property (nonatomic, retain) UILabel *breedText;
@property (nonatomic, retain) UILabel *sexSwitch;
@property (nonatomic, retain) UILabel *dobPicker;


@end
