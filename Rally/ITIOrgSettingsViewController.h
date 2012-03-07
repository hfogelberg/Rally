//
//  ITIOrgSettingsViewController.h
//  Rally
//
//  Created by Henrik Fogelberg on 2012-02-22.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITIOrganisation.h"
#import "ITISignsDataSource.h"

@interface ITIOrgSettingsViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property(nonatomic, retain) NSMutableArray *orgs;
@property(nonatomic, retain) IBOutlet UIPickerView *orgPicker;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end
