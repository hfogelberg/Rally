//
//  ITIAppDelegate.h
//  Rally
//
//  Created by Henrik Fogelberg on 2012-01-23.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITISettings.h"
#import "ITISignsDataSource.h"

@interface ITIAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) ITISettings *settings;

- (void) getSettings;
- (void) copyDatabase;
@end
