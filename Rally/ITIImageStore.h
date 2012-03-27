//
//  ITIImageStore.h
//  Rally
//
//  Created by Henrik Fogelberg on 2012-03-16.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITIImageStore : NSObject{
    NSString *image;
    NSString *thumb;
}

@property (nonatomic, retain) NSString *image;
@property (nonatomic, retain) NSString *thumb;

+ (ITIImageStore *) sharedInstance;

@end
