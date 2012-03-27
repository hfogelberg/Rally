//
//  ITIDog.h
//  Rally
//
//  Created by Henrik Fogelberg on 2012-01-25.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ITIDog : NSObject

@property (nonatomic, assign) int id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *breed;
@property (nonatomic, assign) int isMale;
@property (nonatomic, retain) NSString *dob;
@property (nonatomic, retain) NSString *comment;
@property (nonatomic, assign) int height;

@end
