//
//  ITISign.h
//  Rally
//
//  Created by Henrik Fogelberg on 2012-01-23.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITISign : NSObject

@property (nonatomic, assign) int id;
@property (nonatomic, retain) NSString *header;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, assign) int imageStart;
@property (nonatomic, retain) NSString *thumb;
@property (nonatomic, retain) NSString *level;
@property (nonatomic, retain) NSString *organisation;
@property (nonatomic, assign) int imageOrderId;
@property (nonatomic, retain) NSString *signFile;

@end
