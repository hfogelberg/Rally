//
//  ITIImageStore.m
//  Rally
//
//  Created by Henrik Fogelberg on 2012-03-16.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import "ITIImageStore.h"

@implementation ITIImageStore

@synthesize image;
@synthesize thumb;

+ (ITIImageStore *)sharedInstance
{
    // the instance of this class is stored here
    static ITIImageStore *myInstance = nil;
    
    // check to see if an instance already exists
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
        // initialize variables here
    }
    // return the instance of this class
    return myInstance;
}

@end
