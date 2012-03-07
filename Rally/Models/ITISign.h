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
@property (nonatomic, copy) NSString *header;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) UIImage *image;
@property (nonatomic, copy) UIImage *thumb;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *organisation;

@end
