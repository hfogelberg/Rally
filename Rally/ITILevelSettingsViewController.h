//
//  ITILevelSettingsViewController.h
//  Rally
//
//  Created by Henrik Fogelberg on 2012-02-22.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITILevel.h"
#import "ITISignsDataSource.h"

@interface ITILevelSettingsViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>

@property(nonatomic, retain) NSMutableArray *levels;
@property(nonatomic, retain) IBOutlet UIPickerView *levelPicker;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end
