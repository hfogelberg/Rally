//
//  ITISettingsViewController.h
//  Rally
//
//  Created by Henrik Fogelberg on 2012-02-06.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITISignsDataSource.h"
#import "ITISettings.h"
#import "ITILevelSettingsViewController.h"
#import "ITIOrgSettingsViewController.h"

@interface ITISettingsViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic, retain) ITISettings *settings;
@property(nonatomic, retain) IBOutlet UITextField *levelField;
@property(nonatomic, retain) IBOutlet UITextField *orgField;
@property(nonatomic, retain) IBOutlet UILabel *organisationLabel;
@property(nonatomic, retain) IBOutlet UILabel *levelLabel;

@end
