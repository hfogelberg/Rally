//
//  ITILevel.h
//  Rally
//
//  Created by Henrik Fogelberg on 2012-02-03.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITILevel : NSObject

@property (nonatomic, assign) int code;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *organisation;
@end
