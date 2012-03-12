//
//  ITIResult.h
//  Rally
//
//  Created by Henrik Fogelberg on 2012-01-27.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITIResult : NSObject

@property (nonatomic, assign) int id;
@property (nonatomic, assign) int dog_id;
@property (nonatomic, retain) NSString *dog_name;
@property (nonatomic, retain) NSString *place;
@property (nonatomic, retain) NSString *event_date;
@property (nonatomic, assign) BOOL is_competition;
@property (nonatomic, assign) int level;
@property (nonatomic, retain) NSString *comment;
@property (nonatomic, assign) int points;
@property (nonatomic, assign) int position;
@property (nonatomic, retain) NSString *event;
@property (nonatomic, retain) NSString *club;

@end
