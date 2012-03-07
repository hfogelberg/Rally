//
//  ITISettings.h
//  Rally
//
//  Created by Henrik Fogelberg on 2012-02-05.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITISettings : NSObject

@property (nonatomic, retain) NSString *organisation;
@property (nonatomic, assign) int levelCode;
@property (nonatomic, retain) NSString *levelDescription;
@property (nonatomic, assign) BOOL isFirstRun;
@end
