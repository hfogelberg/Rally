//
//  ITISignComment.h
//  Rally
//
//  Created by Henrik Fogelberg on 2012-02-15.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITISignComment : NSObject

@property(nonatomic, assign) int id;
@property(nonatomic, assign) int sign_id;
@property(nonatomic, copy) NSString *body;

@end
