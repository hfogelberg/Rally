//
//  ITIAppDelegate.h
//  Rally
//
//  Created by Henrik Fogelberg on 2012-01-23.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "/usr/include/sqlite3.h"

@interface ITIAppDelegate : UIResponder <UIApplicationDelegate>{
    sqlite3 *rallyDb;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) sqlite3 *rallyDb;

- (void) copyDatabase;
- (void) setRallyDb;

@end
