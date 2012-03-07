//
//  ITILanguage.h
//  Rally
//
//  Created by Henrik Fogelberg on 2012-02-21.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITILanguage : NSObject

@property (nonatomic, assign) int id;
@property (nonatomic, retain) NSString *code;
@property (nonatomic, retain) NSString *description;

@end
